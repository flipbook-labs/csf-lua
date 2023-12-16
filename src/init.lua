-- ROBLOX upstream: https://github.com/ComponentDriven/csf/blob/v0.1.2-next.0/src/index.ts
local Packages = script:FindFirstAncestor("Packages")
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
type Array<T> = LuauPolyfill.Array<T>
local exports = {}
local toStartCaseStr = require(script.toStartCaseStr).toStartCaseStr
--[[*
 * Remove punctuation and illegal characters from a story ID.
 *
 * See https://gist.github.com/davidjrice/9d2af51100e41c6c4b4a
 ]]
local function sanitize(string_)
	return string_
		:toLowerCase() -- eslint-disable-next-line no-useless-escape
		:replace(
			error("not implemented"), --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /[ ’–—―′¿'`~!@#$%^&*()_|+\-=?;:'",.<>\{\}\[\]\\\/]/gi ]]
			"-"
		)
		:replace(error("not implemented"), --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /-+/g ]] "-")
		:replace(error("not implemented"), --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /^-+/ ]] "")
		:replace(error("not implemented"), --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /-+$/ ]] "")
end
exports.sanitize = sanitize
local function sanitizeSafe(string_, part: string)
	local sanitized = sanitize(string_)
	if sanitized == "" then
		error(
			Error.new(
				("Invalid %s '%s', must include alphanumeric characters"):format(tostring(part), tostring(string_))
			)
		)
	end
	return sanitized
end
--[[*
 * Generate a storybook ID from a component/kind and story name.
 ]]
local function toId(kind: string, name: string?)
	return ("%s%s"):format(
		tostring(sanitizeSafe(kind, "kind")),
		if Boolean.toJSBoolean(name) then ("--%s"):format(tostring(sanitizeSafe(name, "name"))) else ""
	)
end
exports.toId = toId
--[[*
 * Transform a CSF named export into a readable story name
 ]]
local function storyNameFromExport(key: string)
	return toStartCaseStr(key)
end
exports.storyNameFromExport = storyNameFromExport
type StoryDescriptor = Array<string> | RegExp
export type IncludeExcludeOptions = {
	includeStories: StoryDescriptor?,
	excludeStories: StoryDescriptor?,
}
local function matches(storyKey: string, arrayOrRegex: StoryDescriptor)
	if Boolean.toJSBoolean(Array.isArray(arrayOrRegex)) then
		return Array.includes(arrayOrRegex, storyKey) --[[ ROBLOX CHECK: check if 'arrayOrRegex' is an Array ]]
	end
	return storyKey:match(arrayOrRegex)
end
--[[*
 * Does a named export match CSF inclusion/exclusion options?
 ]]
local function isExportStory(key: string, ref0: IncludeExcludeOptions)
	local includeStories, excludeStories = ref0.includeStories, ref0.excludeStories
	local ref = key ~= "__esModule" and (not Boolean.toJSBoolean(includeStories) or matches(key, includeStories))
	return -- https://babeljs.io/docs/en/babel-plugin-transform-modules-commonjs
		if Boolean.toJSBoolean(ref)
		then not Boolean.toJSBoolean(excludeStories) or not Boolean.toJSBoolean(matches(key, excludeStories))
		else ref
end
exports.isExportStory = isExportStory
export type SeparatorOptions = { rootSeparator: string | RegExp, groupSeparator: string | RegExp }
--[[*
 * Parse out the component/kind name from a path, using the given separator config.
 ]]
local function parseKind(kind: string, ref0: SeparatorOptions)
	local rootSeparator, groupSeparator = ref0.rootSeparator, ref0.groupSeparator
	local root, remainder = table.unpack(kind:split(rootSeparator, 2), 1, 2)
	local groups = Array.filter(
		(Boolean.toJSBoolean(remainder) and remainder or kind):split(groupSeparator),
		function(i)
			return not not Boolean.toJSBoolean(i)
		end
	) --[[ ROBLOX CHECK: check if '(remainder || kind).split(groupSeparator)' is an Array ]] -- when there's no remainder, it means the root wasn't found/split
	return {
		root = if Boolean.toJSBoolean(remainder) then root else nil,
		groups = groups,
	}
end
exports.parseKind = parseKind
exports.includeConditionalArg = require(script.includeConditionalArg).includeConditionalArg
Object.assign(exports, require(script.story))
return exports
