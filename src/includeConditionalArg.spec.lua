-- ROBLOX upstream: https://github.com/ComponentDriven/csf/blob/v0.1.2-next.0/src/includeConditionalArg.test.ts
local Packages; --[[ ROBLOX comment: must define Packages module ]]
local JestGlobals = require(Packages.Dev.JestGlobals);
local describe = JestGlobals.describe;
local expect = JestGlobals.expect;
local it = JestGlobals.it;
local includeConditionalArg.jsModule = require(script.Parent["includeConditionalArg.js"]);
local includeConditionalArg = includeConditionalArg.jsModule.includeConditionalArg;
local testValue = includeConditionalArg.jsModule.testValue;
local story.jsModule = require(script.Parent["story.js"]);
type Conditional = story.jsModule.Conditional
describe("testValue", function()
describe("truthy", function()
it:each({{"implicit true", {}, true, true}, {"implicit truthy", {}, 1, true}, {"implicit falsey", {}, 0, false}, {"truthy true", {truthy = true}, true, true}, {"truthy truthy", {truthy = true}, 1, true}, {"truthy falsey", {truthy = true}, 0, false}, {"falsey true", {truthy = false}, true, false}, {"falsey truthy", {truthy = false}, 1, false}, {"falsey falsey", {truthy = false}, 0, true}})("%s", function(_name,cond,value,expected)
expect(testValue(cond, value)).toBe(expected);
end);
end);
describe("exists", function()
it:each({{"exist", {exists = true}, 1, true}, {"exist false", {exists = true}, nil, false}, {"nexist", {exists = false}, nil, true}, {"nexist false", {exists = false}, 1, false}})("%s", function(_name,cond,value,expected)
expect(testValue(cond, value)).toBe(expected);
end);
end);
describe("eq", function()
it:each({{"true", {eq = 1}, 1, true}, {"false", {eq = 1}, 2, false}, {"undefined", {eq = nil}, nil, false}, {"undefined false", {eq = 1}, nil, false}, {"object true", {eq = {x = 1}}, {x = 1}, true}, {"object true", {eq = {x = 1}}, {x = 2}, false}})("%s", function(_name,cond,value,expected)
expect(testValue(cond, value)).toBe(expected);
end);
end);
describe("neq", function()
it:each({{"true", {neq = 1}, 2, true}, {"false", {neq = 1}, 1, false}, {"undefined true", {neq = 1}, nil, true}, {"undefined false", {neq = nil}, nil, false}, {"object true", {neq = {x = 1}}, {x = 2}, true}, {"object false", {neq = {x = 1}}, {x = 1}, false}})("%s", function(_name,cond,value,expected)
expect(testValue(cond, value)).toBe(expected);
end);
end);
end);
describe("includeConditionalArg", function()
describe("errors", function()
it("should throw if neither arg nor global is specified", function()
expect(function()
return includeConditionalArg({["if"] = {} :: Conditional}, {}, {});
end).toThrowErrorMatchingInlineSnapshot("\"Invalid conditional value {}\"");
end);
it("should throw if arg and global are both specified", function()
expect(function()
return includeConditionalArg({["if"] = {arg = "a", global = "b"}}, {}, {});
end).toThrowErrorMatchingInlineSnapshot("\"Invalid conditional value {\"arg\":\"a\",\"global\":\"b\"}\"");
end);
it("should throw if mulitiple exists / eq / neq are specified", function()
expect(function()
return includeConditionalArg({["if"] = {arg = "a", exists = true, eq = 1}}, {}, {});
end).toThrowErrorMatchingInlineSnapshot("\"Invalid conditional test {\"exists\":true,\"eq\":1}\"");
expect(function()
return includeConditionalArg({["if"] = {arg = "a", exists = false, neq = 0}}, {}, {});
end).toThrowErrorMatchingInlineSnapshot("\"Invalid conditional test {\"exists\":false,\"neq\":0}\"");
expect(function()
return includeConditionalArg({["if"] = {arg = "a", eq = 1, neq = 0}}, {}, {});
end).toThrowErrorMatchingInlineSnapshot("\"Invalid conditional test {\"eq\":1,\"neq\":0}\"");
end);
end);
describe("args", function()
describe("implicit", function()
it:each({{"implicit true", {["if"] = {arg = "a"}}, {a = 1}, {}, true}, {"truthy true", {["if"] = {arg = "a", truthy = true}}, {a = 0}, {}, false}, {"truthy false", {["if"] = {arg = "a", truthy = false}}, {}, {}, true}})("%s", function(_name,argType,args,globals,expected)
expect(includeConditionalArg(argType, args, globals)).toBe(expected);
end);
end);
describe("exists", function()
it:each({{"exist", {["if"] = {arg = "a", exists = true}}, {a = 1}, {}, true}, {"exist false", {["if"] = {arg = "a", exists = true}}, {}, {}, false}})("%s", function(_name,argType,args,globals,expected)
expect(includeConditionalArg(argType, args, globals)).toBe(expected);
end);
end);
describe("eq", function()
it:each({{"scalar true", {["if"] = {arg = "a", eq = 1}}, {a = 1}, {}, true}, {"scalar false", {["if"] = {arg = "a", eq = 1}}, {a = 2}, {a = 1}, false}})("%s", function(_name,argType,args,globals,expected)
expect(includeConditionalArg(argType, args, globals)).toBe(expected);
end);
end);
describe("neq", function()
it:each({{"scalar true", {["if"] = {arg = "a", neq = 1}}, {a = 2}, {}, true}, {"scalar false", {["if"] = {arg = "a", neq = 1}}, {a = 1}, {a = 2}, false}})("%s", function(_name,argType,args,globals,expected)
expect(includeConditionalArg(argType, args, globals)).toBe(expected);
end);
end);
end);
describe("globals", function()
describe("truthy", function()
it:each({{"implicit true", {["if"] = {global = "a"}}, {}, {a = 1}, true}, {"implicit undefined", {["if"] = {global = "a"}}, {}, {}, false}, {"truthy true", {["if"] = {global = "a", truthy = true}}, {}, {a = 0}, false}, {"truthy false", {["if"] = {global = "a", truthy = false}}, {}, {a = 0}, true}})("%s", function(_name,argType,args,globals,expected)
expect(includeConditionalArg(argType, args, globals)).toBe(expected);
end);
end);
describe("exists", function()
it:each({{"implicit exist true", {["if"] = {global = "a", exists = true}}, {}, {a = 1}, true}, {"implicit exist false", {["if"] = {global = "a", exists = true}}, {a = 1}, {}, false}})("%s", function(_name,argType,args,globals,expected)
expect(includeConditionalArg(argType, args, globals)).toBe(expected);
end);
end);
describe("eq", function()
it:each({{"scalar true", {["if"] = {global = "a", eq = 1}}, {}, {a = 1}, true}, {"scalar false", {["if"] = {arg = "a", eq = 1}}, {a = 2}, {a = 1}, false}})("%s", function(_name,argType,args,globals,expected)
expect(includeConditionalArg(argType, args, globals)).toBe(expected);
end);
end);
describe("neq", function()
it:each({{"scalar true", {["if"] = {global = "a", neq = 1}}, {}, {a = 2}, true}, {"scalar false", {["if"] = {global = "a", neq = 1}}, {a = 2}, {a = 1}, false}})("%s", function(_name,argType,args,globals,expected)
expect(includeConditionalArg(argType, args, globals)).toBe(expected);
end);
end);
end);
end);