-- ROBLOX upstream: https://github.com/ComponentDriven/csf/blob/v0.1.2-next.0/src/toStartCaseStr.ts
local exports = {}
local function toStartCaseStr(str: string)
	return str:replace(
		error("not implemented"), --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /_/g ]]
		" "
	)
		:replace(
			error("not implemented"), --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /-/g ]]
			" "
		)
		:replace(
			error("not implemented"), --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /\./g ]]
			" "
		)
		:replace(
			error("not implemented"), --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /([^\n])([A-Z])([a-z])/g ]]
			function(
				str2,
				_1, --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $1 ]]
				_2, --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $2 ]]
				_3 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $3 ]]
			)
				return ("%s %s%s"):format(
					tostring(
						_1 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $1 ]]
					),
					tostring(
						_2 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $2 ]]
					),
					tostring(
						_3 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $3 ]]
					)
				)
			end
		)
		:replace(
			error("not implemented"), --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /([a-z])([A-Z])/g ]]
			function(
				str2,
				_1, --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $1 ]]
				_2 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $2 ]]
			)
				return ("%s %s"):format(
					tostring(
						_1 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $1 ]]
					),
					tostring(
						_2 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $2 ]]
					)
				)
			end
		)
		:replace(
			error("not implemented"), --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /([a-z])([0-9])/gi ]]
			function(
				str2,
				_1, --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $1 ]]
				_2 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $2 ]]
			)
				return ("%s %s"):format(
					tostring(
						_1 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $1 ]]
					),
					tostring(
						_2 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $2 ]]
					)
				)
			end
		)
		:replace(
			error("not implemented"), --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /([0-9])([a-z])/gi ]]
			function(
				str2,
				_1, --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $1 ]]
				_2 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $2 ]]
			)
				return ("%s %s"):format(
					tostring(
						_1 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $1 ]]
					),
					tostring(
						_2 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $2 ]]
					)
				)
			end
		)
		:replace(
			error("not implemented"), --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ /(\s|^)(\w)/g ]]
			function(
				str2,
				_1, --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $1 ]]
				_2 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $2 ]]
			)
				return ("%s%s"):format(
					tostring(
						_1 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $1 ]]
					),
					tostring(
						_2 --[[ ROBLOX CHECK: replaced unhandled characters in identifier. Original identifier: $2 ]]:toUpperCase()
					)
				)
			end
		)
		:replace(
			error("not implemented"), --[[ ROBLOX TODO: Unhandled node for type: RegExpLiteral ]] --[[ / +/g ]]
			" "
		)
		:trim()
end
exports.toStartCaseStr = toStartCaseStr
return exports
