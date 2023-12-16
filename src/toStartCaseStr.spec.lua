-- ROBLOX upstream: https://github.com/ComponentDriven/csf/blob/v0.1.2-next.0/src/toStartCaseStr.test.ts
local Packages --[[ ROBLOX comment: must define Packages module ]]
local JestGlobals = require(Packages.Dev.JestGlobals)
local expect = JestGlobals.expect
local test = JestGlobals.test
--[[ eslint-disable eslint-comments/disable-enable-pair ]]
--[[ eslint-disable import/no-extraneous-dependencies ]]
local startCase = require(Packages.lodash.startCase).default
local toStartCaseStr = require(script.Parent.toStartCaseStr).toStartCaseStr
test:each({
	{ "snake_case", "Snake Case" },
	{ "AAAaaaAAAaaa", "AA Aaaa AA Aaaa" },
	{ "kebab-case", "Kebab Case" },
	{ "camelCase", "Camel Case" },
	{ "camelCase1", "Camel Case 1" },
	{ "camelCase1a", "Camel Case 1 A" },
	{ "camelCase1A", "Camel Case 1 A" },
	{ "camelCase1A2", "Camel Case 1 A 2" },
	{ "camelCase1A2b", "Camel Case 1 A 2 B" },
	{ "camelCase1A2B", "Camel Case 1 A 2 B" },
	{ "camelCase1A2B3", "Camel Case 1 A 2 B 3" },
	{ "__FOOBAR__", "FOOBAR" },
	{ "__FOO_BAR__", "FOO BAR" },
	{ "__FOO__BAR__", "FOO BAR" },
	{ " FOO BAR", "FOO BAR" },
	{ "1. Fooo", "1 Fooo" },
	{ "ZIndex", "Z Index" },
})("%s", function(str, expected)
	local outcome = toStartCaseStr(str)
	local fromLodash = startCase(str)
	expect({ outcome = outcome, fromLodash = fromLodash }).toEqual({
		outcome = expected,
		fromLodash = fromLodash,
	})
	expect(outcome).toEqual(fromLodash)
end)