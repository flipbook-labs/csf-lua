-- ROBLOX upstream: https://github.com/ComponentDriven/csf/blob/v0.1.2-next.0/src/SBType.ts
local Packages = script:FindFirstAncestor("Packages")
local LuauPolyfill = require(Packages.LuauPolyfill)
type Array<T> = LuauPolyfill.Array<T>
type Record<K, T> = { [K]: T } --[[ ROBLOX TODO: TS 'Record' built-in type is not available in Luau ]]
local exports = {}
type SBBaseType = { required: boolean?, raw: string? }
export type SBScalarType = SBBaseType & { name: "boolean" | "string" | "number" | "function" | "symbol" }
export type SBArrayType = SBBaseType & { name: "array", value: SBType }
export type SBObjectType = SBBaseType & { name: "object", value: Record<string, SBType> }
export type SBEnumType = SBBaseType & { name: "enum", value: Array<string | number> }
export type SBIntersectionType = SBBaseType & { name: "intersection", value: Array<SBType> }
export type SBUnionType = SBBaseType & { name: "union", value: Array<SBType> }
export type SBOtherType = SBBaseType & { name: "other", value: string }
export type SBType =
	SBScalarType
	| SBEnumType
	| SBArrayType
	| SBObjectType
	| SBIntersectionType
	| SBUnionType
	| SBOtherType -- Needed for ts-jest as we export * from './SBType.js' in the other file
-- Might be a bug

return exports
