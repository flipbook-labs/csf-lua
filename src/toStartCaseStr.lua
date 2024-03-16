-- ROBLOX upstream: https://github.com/ComponentDriven/csf/blob/v0.1.2-next.0/src/toStartCaseStr.ts
local Packages = script:FindFirstAncestor("Packages")
local LuauPolyfill = require(Packages.LuauPolyfill)
local exports = {}
local function toStartCaseStr(str: string)
	-- ROBLOX deviation START: Manually translated regex to Luau string patterns
	str = str:gsub("_", " ")
		:gsub("-", " ")
		:gsub("%.", " ")
		:gsub("([^\n])([A-Z])([a-z])", function(m1, m2, m3)
			return `{m1} {m2}{m3}`
		end)
		:gsub("([a-z])([A-Z])", function(m1, m2)
			return `{m1} {m2}`
		end)
		:gsub("(%a+)([0-9])", function(m1, m2)
			return `{m1} {m2}`
		end)
		:gsub("([0-9])(%a+)", function(m1, m2)
			return `{m1} {m2}`
		end)
		:gsub("(%s)(%w)", function(m1, m2)
			return `{m1}{m2:upper()}`
		end)
		:gsub("^(%w)", function(m1)
			return m1:upper()
		end)
		:gsub(" +", " ")

	str = LuauPolyfill.String.trim(str)
	-- ROBLOX deviation END

	return str
end
exports.toStartCaseStr = toStartCaseStr
return exports
