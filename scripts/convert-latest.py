#!/usr/bin/env python3

from argparse import ArgumentParser
from pathlib import Path
import os
import subprocess

parser = ArgumentParser()
parser.add_argument("upstream_repo")
parser.add_argument("-o", "--output", type=Path, default="build/")


def clone_or_pull_repo(repo_name: str, build_dir: Path) -> Path:
    if not build_dir.exists():
        build_dir.mkdir()

    print(f"info: Cloning {repo_name} into {build_dir}...")
    repo_name_no_owner = os.path.basename(repo_name)
    full_path = build_dir.joinpath(repo_name_no_owner)

    if full_path.exists():
        print("info: Repo already cloned. Pulling latest changes...")
        subprocess.run(
            ["git", "pull"],
            cwd=full_path,
        )
    else:
        subprocess.run(["git", "clone", f"https://github.com/{repo_name}", full_path])

    return full_path


def build_js_to_lua(repo_path: Path) -> Path:
    print("info: Building js-to-lua...")
    subprocess.run(["npm", "install"], cwd=repo_path)
    subprocess.run(["npm", "run", "build:prod"], cwd=repo_path)

    return repo_path.joinpath("dist/apps/convert-js-to-lua/index.js")


def main():
    args = parser.parse_args()

    print("info: Cloning Git repos...")
    js_to_lua_path = clone_or_pull_repo("Roblox/js-to-lua", args.output)
    upstream_repo_dir = clone_or_pull_repo(args.upstream_repo, args.output)

    runner = build_js_to_lua(js_to_lua_path)

    print(f"info: Path to js-to-lua: {runner.absolute()}")

    print(f"info: Converting {args.upstream_repo} to Luau...")
    subprocess.run(
        [
            "node",
            str(runner),
            "--input",
            f"{upstream_repo_dir}/**/*.ts",
            "--output",
            ".",
        ]
    )

    print(f"info: Successfully converted {args.upstream_repo}")


if __name__ == "__main__":
    main()
