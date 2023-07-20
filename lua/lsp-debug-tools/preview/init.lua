--- @class Preview
--- @field transform fun(x: string): string
--- @field history string[]
--- @field max_count number
local Preview = {}

local function reverse(t)
    local out = {}
    for i = #t, 1, -1 do
        table.insert(out, t[i])
    end
    return out
end

Preview.__index = Preview

function Preview:new()
    return setmetatable({
        transform = function(x) return x end,
        history = {},
        max_count = 10,
    }, self)
end

function Preview:with_transform(transform)
    self.transform = transform
    return transform
end

function Preview:with_max_count(count)
    self.max_count = count
    return self
end

function Preview:render(line)
    table.insert(self.history, self.transform(line))
    if #self.history > self.max_count then
        table.remove(self.history, 1)
    end

    return reverse(self.history)
end

return Preview


