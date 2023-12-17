-- ROBLOX upstream: https://github.com/ComponentDriven/csf/blob/v0.1.2-next.0/src/toStartCaseStr.ts
local Packages = script:FindFirstAncestor("Packages")

local RegExp = require(Packages.RegExp)

local exports = {}
local function toStartCaseStr(str: string)
	return str:replace(RegExp("_", "g"), " ")
		:replace(RegExp("-", "g"), " ")
		:replace(RegExp(".", "g"), " ")
		:replace(RegExp("([^\n])([A-Z])([a-z])", "g"), function(_, m1, m2, m3)
			return ("%s %s%s"):format(tostring(m1), tostring(m2), tostring(m3))
		end)
		:replace(RegExp("([a-z])([A-Z])", "g"), function(_, m1, m2)
			return ("%s %s"):format(tostring(m1), tostring(m2))
		end)
		:replace(RegExp("([a-z])([0-9])", "gi"), function(_, m1, m2)
			return ("%s %s"):format(tostring(m1), tostring(m2))
		end)
		:replace(RegExp("([0-9])([a-z])", "gi"), function(_, m1, m2)
			return ("%s %s"):format(tostring(m1), tostring(m2))
		end)
		:replace(RegExp("(s|^)(w)", "g"), function(_, m1, m2)
			return ("%s%s"):format(tostring(m1), tostring(m2:toUpperCase()))
		end)
		:replace(RegExp(" +", "g"), " ")
		:trim()
end
exports.toStartCaseStr = toStartCaseStr
return exports
