#!/usr/bin/env python3

from argparse import ArgumentParser
from pathlib import Path
import os
import subprocess
from shutil import rmtree

parser = ArgumentParser()
parser.add_argument(
    "upstream_repo",
    type=str,
    help="The owner and name of a repository. ex: Roblox/js-to-lua",
)
parser.add_argument("-o", "--output", type=Path, default="build/")
parser.add_argument(
    "-f", "--fresh", help="Clean build files first before running", action="store_true"
)


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


JS_TO_LUA_PATH = Path("dist/apps/convert-js-to-lua/index.js")


def build_js_to_lua(repo_path: Path) -> Path:
    command_path = repo_path.joinpath(JS_TO_LUA_PATH)

    if command_path.exists():
        print(
            f"info: Already built, using path to js-to-lua: {command_path.absolute()}"
        )
    else:
        subprocess.run(["npm", "install"], cwd=repo_path)
        subprocess.run(["npm", "run", "build:prod"], cwd=repo_path)

    return command_path


def main():
    args = parser.parse_args()

    if args.fresh:
        print("info: Cleaning build files...")
        rmtree(args.output)

    print("info: Cloning Git repos...")
    js_to_lua_path = clone_or_pull_repo("Roblox/js-to-lua", args.output)
    upstream_repo_dir = clone_or_pull_repo(args.upstream_repo, args.output)

    print("info: Building js-to-lua...")
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
