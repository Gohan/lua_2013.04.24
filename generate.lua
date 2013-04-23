--[[
--]]
local string = require "string"
local lustache = require "lustache"
local Widget = {
    WidgetTemplate = [[
local {{ui_name}} = {
    ui_type = "{{ui_type}}",
    ui_background = "{{&ui_background}}",
    childrens = {{&childrens_tostring}}
}
]],
    new = function(self, o)
        o = o or {}
        setmetatable(o, self)
        self.__index = self
        o.childrens = {}
        return o
    end,
    to_string = function(self, indent)
        print(self.ui_name .. 'to_string')
        indent = indent or 0
        ret = lustache:render(self.WidgetTemplate, self)
        if indent > 0 then
            ret = ret:gsub("[^\r\n]+", string.rep(' ', indent).."%0")
            ret = ret:gsub('^(.-)[\r\n]*$', "%1")
        end
        return ret
    end,
    childrens_tostring = function(self)
        local ret = ""
        local has_children = false
        for k,v in pairs(self.childrens) do
            ret = ret .. v:to_string(8) .. ',' .. '\n'
            has_children = true
        end
        if has_children == false then
            ret = "{}"
        else
            ret = ret:gsub('^(.-)[\r\n]*$', "%1")
            ret = " {\n"..ret.."}"
        end

        return ret
    end,
    ui_type = 'Dialog',
    ui_name = 'Widget',
    ui_background = 'somewhere/somethere.png',
    childrens = {
    }
}

root1 = Widget:new()
root1.ui_name = 'D1'
root2 = Widget:new()
root2.ui_name = 'D2'
root1.childrens[root2.ui_name] = root2
root3 = Widget:new()
root3.ui_name = 'Button'
root1.childrens[root3.ui_name] = root3
print(root1:to_string())
print(#root1.childrens)

