#!/usr/bin/env just --justfile

project_dir := absolute_path("src")
packages_dir := absolute_path("Packages")
dev_project := "dev.project.json"

tmpdir := `mktemp -d`
global_defs_path := tmpdir / "globalTypes.d.lua"
sourcemap_path := tmpdir / "sourcemap.json"

client_settings := "/Applications/RobloxStudio.app/Contents/MacOS/ClientSettings"

default:
  @just --list

init:
	foreman install
	just wally-install

lint:
	selene {{ project_dir }}
	stylua --check {{ project_dir }}

convert-latest:
	./scripts/convert-latest.py ComponentDriven/csf

wally-install:
	wally install
	rojo sourcemap {{ dev_project }} -o {{ sourcemap_path }}
	wally-package-types --sourcemap {{ sourcemap_path }} {{ packages_dir }}

set-flags:
	mkdir -p {{ client_settings }}
	cp -R scripts/ClientAppSettings.json {{ client_settings }}

test:
    just set-flags
    rojo build {{ dev_project }} -o test-place.rbxl
    run-in-roblox --place test-place.rbxl --script scripts/run-tests.lua

analyze:
	curl -s -o {{ global_defs_path }} \
		-O https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/master/scripts/globalTypes.d.lua

	rojo sourcemap {{ dev_project }} -o {{ sourcemap_path }}

	luau-lsp analyze --sourcemap={{ sourcemap_path }} \
		--defs={{ global_defs_path }} \
		--settings="./.vscode/settings.json" \
		--ignore=**/_Index/** \
		{{ project_dir }}

