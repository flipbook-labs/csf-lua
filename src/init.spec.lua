-- ROBLOX upstream: https://github.com/ComponentDriven/csf/blob/v0.1.2-next.0/src/index.test.ts
local Packages = script:FindFirstAncestor("Packages")
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
type Array<T> = LuauPolyfill.Array<T>
local JestGlobals = require(Packages.Dev.JestGlobals)
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local RegExp = require(Packages.RegExp)
local indexJsModule = require(script.Parent)
local toId = indexJsModule.toId
local storyNameFromExport = indexJsModule.storyNameFromExport
local isExportStory = indexJsModule.isExportStory
describe("toId", function()
	local testCases: Array<Array<string | string | nil>> = {
		-- name, kind, story, output
		-- name, kind, story, output
		{ "handles simple cases", "kind", "story", "kind--story" },
		{ "handles kind without story", "kind", nil, "kind" },
		{ "handles basic substitution", "a b$c?d\u{1F600}e", "1-2:3", "a-b-c-d\u{1F600}e--1-2-3" },
		{ "handles runs of non-url chars", "a?&*b", "story", "a-b--story" },
		{ "removes non-url chars from start and end", "?ab-", "story", "ab--story" },
		{ "downcases", "KIND", "STORY", "kind--story" },
		{
			"non-latin",
			"\u{41A}\u{43D}\u{43E}\u{43F}\u{43A}\u{438}",
			"\u{43D}\u{43E}\u{440}\u{43C}\u{430}\u{43B}\u{44C}\u{43D}\u{44B}\u{439}",
			"\u{43A}\u{43D}\u{43E}\u{43F}\u{43A}\u{438}--\u{43D}\u{43E}\u{440}\u{43C}\u{430}\u{43B}\u{44C}\u{43D}\u{44B}\u{439}",
		},
		{ "korean", "kind", "\u{BC14}\u{BCF4} (babo)", "kind--\u{BC14}\u{BCF4}-babo" },
		{
			"all punctuation",
			"kind",
			'unicorns,\u{2019}\u{2013}\u{2014}\u{2015}\u{2032}\u{BF}`"<>()!.!!!{}[]%^&$*#&',
			"kind--unicorns",
		},
	}
	Array.forEach(testCases, function(ref0)
		local name, kind, story, output = table.unpack(ref0, 1, 4)
		-- eslint-disable-next-line jest/valid-title
		it(name, function()
			expect(toId(kind, story)).toBe(output)
		end)
	end) --[[ ROBLOX CHECK: check if 'testCases' is an Array ]]
	it("does not allow kind with *no* url chars", function()
		expect(function()
			return toId("?", "asdf")
		end).toThrow("Invalid kind '?', must include alphanumeric characters")
	end)
	it("does not allow empty kind", function()
		expect(function()
			return toId("", "asdf")
		end).toThrow("Invalid kind '', must include alphanumeric characters")
	end)
	it("does not allow story with *no* url chars", function()
		expect(function()
			return toId("kind", "?")
		end).toThrow("Invalid name '?', must include alphanumeric characters")
	end)
	it("allows empty story", function()
		expect(function()
			return toId("kind", "")
		end)["not"].toThrow()
	end)
end)
describe("storyNameFromExport", function()
	it("should format CSF exports with sensible defaults", function()
		local testCases = {
			name = "Name",
			someName = "Some Name",
			someNAME = "Some NAME",
			some_custom_NAME = "Some Custom NAME",
			someName1234 = "Some Name 1234",
			someName1_2_3_4 = "Some Name 1 2 3 4",
		}
		Array.forEach(Object.entries(testCases), function(ref0)
			local key, val = table.unpack(ref0, 1, 2)
			return expect(storyNameFromExport(key)).toBe(val)
		end) --[[ ROBLOX CHECK: check if 'Object.entries(testCases)' is an Array ]]
	end)
end)
describe("isExportStory", function()
	it("should exclude __esModule", function()
		expect(isExportStory("__esModule", {})).toBeFalsy()
	end)
	it("should include all stories when there are no filters", function()
		expect(isExportStory("a", {})).toBeTruthy()
	end)
	it("should filter stories by arrays", function()
		expect(isExportStory("a", { includeStories = { "a" } })).toBeTruthy()
		expect(isExportStory("a", { includeStories = {} })).toBeFalsy()
		expect(isExportStory("a", { includeStories = { "b" } })).toBeFalsy()
		expect(isExportStory("a", { excludeStories = { "a" } })).toBeFalsy()
		expect(isExportStory("a", { excludeStories = {} })).toBeTruthy()
		expect(isExportStory("a", { excludeStories = { "b" } })).toBeTruthy()
		expect(isExportStory("a", { includeStories = { "a" }, excludeStories = { "a" } })).toBeFalsy()
		expect(isExportStory("a", { includeStories = {}, excludeStories = {} })).toBeFalsy()
		expect(isExportStory("a", { includeStories = { "a" }, excludeStories = { "b" } })).toBeTruthy()
	end)
	it("should filter stories by regex", function()
		expect(isExportStory("a", { includeStories = RegExp("a") })).toBeTruthy()
		expect(isExportStory("a", { includeStories = RegExp(".*") })).toBeTruthy()
		expect(isExportStory("a", { includeStories = RegExp("b") })).toBeFalsy()
		expect(isExportStory("a", { excludeStories = RegExp("a") })).toBeFalsy()
		expect(isExportStory("a", { excludeStories = RegExp(".*") })).toBeFalsy()
		expect(isExportStory("a", { excludeStories = RegExp("b") })).toBeTruthy()
		expect(isExportStory("a", { includeStories = RegExp("a"), excludeStories = { "a" } })).toBeFalsy()
		expect(isExportStory("a", { includeStories = RegExp(".*"), excludeStories = RegExp(".*") })).toBeFalsy()
		expect(isExportStory("a", { includeStories = RegExp("a"), excludeStories = RegExp("b") })).toBeTruthy()
	end)
end)
