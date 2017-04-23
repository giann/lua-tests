
mt = {}
local foo
A = false
do
    local _ENV = mt
    foo = function ()
        A = 3
    end
end

print(mt, debug.getupvalue(foo, 1))