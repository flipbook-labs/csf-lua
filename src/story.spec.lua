-- ROBLOX upstream: https://github.com/ComponentDriven/csf/blob/v0.1.2-next.0/src/story.test.ts
-- ROBLOX deviation START: Can't test types, so we don't use this file
--[=[
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Symbol = LuauPolyfill.Symbol
local Promise = require(Packages.Promise)
--[[ eslint-disable eslint-comments/disable-enable-pair ]]
--[[ eslint-disable import/no-extraneous-dependencies ]]
--[[ global HTMLElement ]]
local expectTypeOf = require(Packages["expect-type"]).expectTypeOf
local storyJsModule = require(script.Parent["story.js"])
local Renderer = storyJsModule.Renderer
local Args = storyJsModule.Args
local ArgsFromMeta = storyJsModule.ArgsFromMeta
local ArgsStoryFn = storyJsModule.ArgsStoryFn
local ComponentAnnotations = storyJsModule.ComponentAnnotations
local DecoratorFunction = storyJsModule.DecoratorFunction
local LoaderFunction = storyJsModule.LoaderFunction
local ProjectAnnotations = storyJsModule.ProjectAnnotations
local StoryAnnotationsOrFn = storyJsModule.StoryAnnotationsOrFn
local StrictArgs = storyJsModule.StrictArgs -- NOTE Example of internal type definition for @storybook/<X> (where X is a renderer)
type XRenderer = Renderer & {
	component: (
		args: typeof((
			({} :: any) :: any --[[ ROBLOX TODO: Unhandled node for type: TSThisType ]] --[[ this ]]
		).T)
	) -> string,
	storyResult: string,
	canvasElement: HTMLElement,
}
type XMeta<TArgs = Args> = ComponentAnnotations<XRenderer, TArgs>
type XStory<TArgs = Args> = StoryAnnotationsOrFn<XRenderer, TArgs> -- NOTE Examples of using types from @storybook/<X> in real project
type ButtonArgs = { x: string, y: string }
local function Button(props: ButtonArgs)
	return "Button"
end -- NOTE Various kind usages
local simple: XMeta = {
	title = "simple",
	component = Button,
	tags = { "foo", "bar" },
	decorators = {
		function(storyFn, context)
			return ("withDecorator(%s)"):format(tostring(storyFn(context)))
		end,
	},
	parameters = {
		a = function()
			return nil
		end,
		b = 0 / 0,
		c = Symbol("symbol"),
	},
	loaders = {
		function()
			return Promise.resolve({ d = "3" })
		end,
	},
	args = { x = "1" },
	argTypes = { x = { type = { name = "string" } } },
}
local strict: XMeta<ButtonArgs> = {
	title = "simple",
	component = Button,
	tags = { "foo", "bar" },
	decorators = {
		function(storyFn, context)
			return ("withDecorator(%s)"):format(tostring(storyFn(context)))
		end,
	},
	parameters = {
		a = function()
			return nil
		end,
		b = 0 / 0,
		c = Symbol("symbol"),
	},
	loaders = {
		function()
			return Promise.resolve({ d = "3" })
		end,
	},
	args = { x = "1" },
	argTypes = { x = { type = { name = "string" } } },
} -- NOTE Various story usages
local Simple: XStory
function Simple()
	return "Simple"
end
local CSF1Story: XStory
function CSF1Story()
	return "Named Story"
end
CSF1Story.story = {
	name = "Another name for story",
	tags = { "foo", "bar" },
	decorators = {
		function(storyFn)
			return ("Wrapped(%s"):format(tostring(storyFn()))
		end,
	},
	parameters = { a = { 1, "2", {} }, b = nil, c = Button },
	loaders = {
		function()
			return Promise.resolve({ d = "3" })
		end,
	},
	args = { a = 1 },
}
local CSF2Story: XStory
function CSF2Story()
	return "Named Story"
end
CSF2Story.storyName = "Another name for story"
CSF2Story.tags = { "foo", "bar" }
CSF2Story.decorators = {
	function(storyFn)
		return ("Wrapped(%s"):format(tostring(storyFn()))
	end,
}
CSF2Story.parameters = { a = { 1, "2", {} }, b = nil, c = Button }
CSF2Story.loaders = {
	function()
		return Promise.resolve({ d = "3" })
	end,
}
CSF2Story.args = { a = 1 }
local CSF3Story: XStory = {
	render = function(args)
		return "Named Story"
	end,
	name = "Another name for story",
	tags = { "foo", "bar" },
	decorators = {
		function(storyFn)
			return ("Wrapped(%s"):format(tostring(storyFn()))
		end,
	},
	parameters = { a = { 1, "2", {} }, b = nil, c = Button },
	loaders = {
		function()
			return Promise.resolve({ d = "3" })
		end,
	},
	args = { a = 1 },
}
local CSF3StoryStrict: XStory<ButtonArgs> = {
	render = function(args)
		return "Named Story"
	end,
	name = "Another name for story",
	tags = { "foo", "bar" },
	decorators = {
		function(storyFn)
			return ("Wrapped(%s"):format(tostring(storyFn()))
		end,
	},
	parameters = { a = { 1, "2", {} }, b = nil, c = Button },
	loaders = {
		function()
			return Promise.resolve({ d = "3" })
		end,
	},
	args = { x = "1" },
	play = function(ref0)
		local step, canvasElement = ref0.step, ref0.canvasElement
		return Promise.resolve():andThen(function()
			step("a step", function(ref0)
				local substep = ref0.step
				return Promise.resolve():andThen(function()
					substep("a substep", function() end):expect()
				end)
			end):expect()
		end)
	end,
}
local project: ProjectAnnotations<XRenderer> = {
	runStep = function(self, label, play, context)
		return play(context)
	end,
}
test("ArgsFromMeta will infer correct args from render/loader/decorators", function()
	local decorator1: DecoratorFunction<XRenderer, { decoratorArg: string }>
	function decorator1(Story, ref0)
		local args = ref0.args
		return ("%s"):format(tostring(args.decoratorArg))
	end
	local decorator2: DecoratorFunction<XRenderer, { decoratorArg2: string }>
	function decorator2(Story, ref0)
		local args = ref0.args
		return ("%s"):format(tostring(args.decoratorArg2))
	end
	local decorator3: DecoratorFunction<XRenderer, Args>
	function decorator3(Story, ref0)
		local args = ref0.args
		return ""
	end
	local decorator4: DecoratorFunction<XRenderer, StrictArgs>
	function decorator4(Story, ref0)
		local args = ref0.args
		return ""
	end
	local loader: LoaderFunction<XRenderer, { loaderArg: number }>
	function loader(ref0)
		local args = ref0.args
		return Promise.resolve():andThen(function()
			return { loader = ("%s"):format(tostring(args.loaderArg)) }
		end)
	end
	local loader2: LoaderFunction<XRenderer, { loaderArg2: number }>
	function loader2(ref0)
		local args = ref0.args
		return Promise.resolve():andThen(function()
			return { loader2 = ("%s"):format(tostring(args.loaderArg2)) }
		end)
	end
	local renderer: ArgsStoryFn<XRenderer, { theme: string }>
	function renderer(args)
		return ("%s"):format(tostring(args.theme))
	end
	local meta = {
		component = Button,
		args = { disabled = false },
		render = renderer,
		decorators = { decorator1, decorator2, decorator3, decorator4 },
		loaders = { loader, loader2 },
	}
	expectTypeOf():toEqualTypeOf()
end)
test("You can assign a component to Meta, even when you pass a top type", function()
	expectTypeOf({ component = Button }):toMatchTypeOf()
	expectTypeOf({ component = Button }):toMatchTypeOf()
	expectTypeOf({ component = Button }):toMatchTypeOf()
	expectTypeOf({ component = Button }):toMatchTypeOf()
	expectTypeOf({ component = Button }):toMatchTypeOf()
	expectTypeOf({ component = Button })["not"]:toMatchTypeOf()
	expectTypeOf({ component = Button })["not"]:toMatchTypeOf()
end)
]=]
-- ROBLOX deviation END
