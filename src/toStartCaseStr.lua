-- ROBLOX upstream: https://github.com/ComponentDriven/csf/blob/v0.1.2-next.0/src/toStartCaseStr.ts
local Packages = script:FindFirstAncestor("Packages")

local LuauPolyfill = require(Packages.LuauPolyfill)

type ReplacementFn = string | (...string) -> string

-- ROBLOX deviation START: Added a `replace` polyfill since LuauPolyfill doesn't have one
local function replace(str: string, pattern: string, replacement: ReplacementFn)
	local matches = {}
	for match in str:gmatch(pattern) do
		table.insert(matches, match)
	end

	for _, match in matches do
		if typeof(replacement) == "string" then
			str = str:gsub(match, replacement)
		else
			str = str:gsub(match, replacement(table.unpack(matches)))
		end
	end

	return str
end
-- ROBLOX deviation END

local exports = {}
local function toStartCaseStr(str: string)
	-- ROBLOX deviation START: Manually translated regex to Luau string patterns
	str = str:gsub("_", " "):gsub("-", " "):gsub("%.", " ")

	str = replace(str, "([^\n])([A-Z])([a-z])", function(m1, m2, m3)
		return `{m1} {m2}{m3}`
	end)

	str = replace(str, "([a-z])([A-Z])", function(m1, m2)
		return `{m1} {m2}`
	end)

	str = replace(str, "([a-z])([0-9])", function(m1, m2)
		return `{m1} {m2}`
	end)

	str = replace(str, "([0-9])([a-z])", function(m1, m2)
		return `{m1} {m2}`
	end)

	str = replace(str, "(%s|^)(%w)", function(m1, m2)
		return `{m1} {m2:upper()}`
	end)

	str = str:gsub(" +", " ")

	str = LuauPolyfill.String.trim(str)
	-- ROBLOX deviation END

	return str
end
exports.toStartCaseStr = toStartCaseStr
return exports
