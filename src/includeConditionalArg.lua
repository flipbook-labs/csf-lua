-- ROBLOX upstream: https://github.com/ComponentDriven/csf/blob/v0.1.2-next.0/src/includeConditionalArg.ts
local HttpService = game:GetService("HttpService")

local Packages = script:FindFirstAncestor("Packages")
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
type Array<T> = LuauPolyfill.Array<T>
type Omit<T, K> = T --[[ ROBLOX TODO: TS 'Omit' built-in type is not available in Luau ]]
local exports = {}
--[[ eslint-disable eslint-comments/disable-enable-pair ]]
--[[ eslint-disable import/no-extraneous-dependencies ]]
--[[ @ts-expect-error (has no typings) ]]
-- ROBLOX deviation START: Using direct == comparison instead
-- local isEqual = require(Packages["@ngard"]["tiny-isequal"]).isEqual
-- ROBLOX deviation END
local storyJsModule = require(script.Parent.story)
type Args = storyJsModule.Args
type Globals = storyJsModule.Globals
type InputType = storyJsModule.InputType
type Conditional = storyJsModule.Conditional
local function count(vals: Array<any>)
	return Array.filter(
		Array.map(vals, function(v)
			return typeof(v) ~= nil
		end), --[[ ROBLOX CHECK: check if 'vals' is an Array ]]
		Boolean
	).length
end
local function testValue(cond: Omit<Conditional, "arg" | "global">, value: any)
	local exists, eq, neq, truthy
	do
		local ref = cond :: any
		exists, eq, neq, truthy = ref.exists, ref.eq, ref.neq, ref.truthy
	end
	if
		count({ exists, eq, neq, truthy })
		> 1 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		-- ROBLOX deviation START: Using HttpService to stringify json
		error(Error.new(`Invalid conditional test {HttpService:JSONEncode({ exists = exists, eq = eq, neq = neq })}`))
		-- ROBLOX deviation END
	end
	if typeof(eq) ~= nil then
		-- ROBLOX deviation START: Using direct == comparison instead
		return value == eq
		-- ROBLOX deviation END
	end
	if typeof(neq) ~= nil then
		-- ROBLOX deviation START: Direct == comparison instead of using isEqual
		return not Boolean.toJSBoolean(value == neq)
		-- ROBLOX deviation END
	end
	if typeof(exists) ~= nil then
		local valueExists = typeof(value) ~= nil
		return if Boolean.toJSBoolean(exists) then valueExists else not Boolean.toJSBoolean(valueExists)
	end
	local shouldBeTruthy = if typeof(truthy) == nil then true else truthy
	return if Boolean.toJSBoolean(shouldBeTruthy)
		then not not Boolean.toJSBoolean(value)
		else not Boolean.toJSBoolean(value)
end
exports.testValue = testValue
--[[*
 * Helper function to include/exclude an arg based on the value of other other args
 * aka "conditional args"
 ]]
local function includeConditionalArg(argType: InputType, args: Args, globals: Globals)
	if not Boolean.toJSBoolean(argType["if"]) then
		return true
	end
	local arg, global
	do
		local ref = argType["if"] :: any
		arg, global = ref.arg, ref.global
	end
	if count({ arg, global }) ~= 1 then
		-- ROBLOX deviation START: Using HttpService to stringify json
		error(Error.new(`Invalid conditional value {HttpService:JSONEncode({ arg = arg, global = global })}`))
		-- ROBLOX deviation END
	end
	local value = if Boolean.toJSBoolean(arg) then args[tostring(arg)] else globals[tostring(global)] -- eslint-disable-next-line @typescript-eslint/no-non-null-assertion
	return testValue(argType["if"] :: any, value)
end
exports.includeConditionalArg = includeConditionalArg
return exports
