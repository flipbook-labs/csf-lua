-- ROBLOX upstream: https://github.com/ComponentDriven/csf/blob/v0.1.2-next.0/src/index.ts
local Packages = script:FindFirstAncestor("Packages")
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
type Array<T> = LuauPolyfill.Array<T>
local RegExp = require(Packages.RegExp)
type RegExp = RegExp.RegExp
local exports = {}
local story = require(script.story)
local toStartCaseStr = require(script.toStartCaseStr).toStartCaseStr

-- ROBLOX deviation START: Manually export types from `story`
export type AnnotatedStoryFn = story.AnnotatedStoryFn
export type Args = story.Args
export type ArgsEnhancer = story.ArgsEnhancer
export type ArgsStoryFn = story.ArgsStoryFn
export type ArgTypes = story.ArgTypes
export type ArgTypesEnhancer = story.ArgTypesEnhancer
export type BaseAnnotations = story.BaseAnnotations
export type ComponentAnnotations = story.ComponentAnnotations
export type ComponentId = story.ComponentId
export type ComponentTitle = story.ComponentTitle
export type Conditional = story.Conditional
export type DecoratorApplicator = story.DecoratorApplicator
export type DecoratorFunction = story.DecoratorFunction
export type Globals = story.Globals
export type GlobalTypes = story.GlobalTypes
export type InputType = story.InputType
export type LegacyAnnotatedStoryFn = story.LegacyAnnotatedStoryFn
export type LegacyStoryAnnotationsOrFn = story.LegacyStoryAnnotationsOrFn
export type LegacyStoryFn = story.LegacyStoryFn
export type LoaderFunction = story.LoaderFunction
export type Parameters = story.Parameters
export type PartialStoryFn = story.PartialStoryFn
export type PlayFunction = story.PlayFunction
export type PlayFunctionContext = story.PlayFunctionContext
export type ProjectAnnotations = story.ProjectAnnotations
export type Renderer = story.Renderer
export type StepFunction = story.StepFunction
export type StepLabel = story.StepLabel
export type StepRunner = story.StepRunner
export type StoryAnnotations = story.StoryAnnotations
export type StoryAnnotationsOrFn = story.StoryAnnotationsOrFn
export type StoryContext = story.StoryContext
export type StoryContextForEnhancers = story.StoryContextForEnhancers
export type StoryContextForLoaders = story.StoryContextForLoaders
export type StoryContextUpdate = story.StoryContextUpdate
export type StoryFn = story.StoryFn
export type StoryId = story.StoryId
export type StoryIdentifier = story.StoryIdentifier
export type StoryName = story.StoryName
export type StrictArgs = story.StrictArgs
export type StrictArgTypes = story.StrictArgTypes
export type StrictGlobalTypes = story.StrictGlobalTypes
export type StrictInputType = story.StrictInputType
export type StrictParameters = story.StrictParameters
export type Tag = story.Tag
export type ViewMode = story.ViewMode
-- ROBLOX deviation END

--[[*
 * Remove punctuation and illegal characters from a story ID.
 *
 * See https://gist.github.com/davidjrice/9d2af51100e41c6c4b4a
 ]]
local function sanitize(string_)
	return string_
		:toLowerCase()
		-- eslint-disable-next-line no-useless-escape
		:replace(
			RegExp(
				"[ \u{2019}\u{2013}\u{2014}\u{2015}\u{2032}\u{BF}'`~!@#$%^&*()_|+\\-=?;:'\",.<>\\{\\}\\[\\]\\\\\\/]",
				"gi"
			), --[[ ROBLOX NOTE: global flag is not implemented yet ]]
			"-"
		)
		:replace(RegExp("-+", "g") --[[ ROBLOX NOTE: global flag is not implemented yet ]], "-")
		:replace(RegExp("^-+"), "")
		:replace(RegExp("-+$"), "")
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
type StoryDescriptor = Array<string> | RegExp | string
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
