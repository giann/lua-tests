#!../lua

local c = clock()

_WD = wd or ""

assert(setlocale"C")

local showmem = function ()
  if %totalmem then
    local a,b,c = %totalmem()
    %print(%format("\n ---- memoria total: %d, maxima: %d,  blocos: %d\n",
                    a, c, b))
  end
end

assert(dofile(_WD..'main.lua'))

settagmethod(tag(nil), 'gc', function (a)
  %write(_STDERR, '.')
end)

showmem()
assert(dofile(_WD..'gc.lua'))
showmem()
assert(dofile(_WD..'db.lua'))
showmem()
assert(dofile(_WD..'calls.lua') == deep)
showmem()
assert(dofile(_WD..'strings.lua'))
showmem()
assert(dofile(_WD..'literals.lua'))
showmem()
assert(dofile(_WD..'attrib.lua') == 27)
showmem()
assert(dofile(_WD..'locals.lua') == 5)
assert(dofile(_WD..'constructs.lua'))
assert(dofile(_WD..'big.lua') == 'a')
assert(dofile(_WD..'verybig.lua') == 10); collectgarbage()
showmem()
assert(dofile(_WD..'func.lua'))
showmem()
assert(dofile(_WD..'nextvar.lua'))
showmem()
assert(dofile(_WD..'pm.lua'))
showmem()
assert(dofile(_WD..'api.lua'))
showmem()
assert(dofile(_WD..'tag.lua') == 12)
showmem()
assert(dofile(_WD..'vararg.lua'))
showmem()
assert(dofile(_WD..'pragmas.lua'))
showmem()
assert(dofile(_WD..'errors.lua'))
showmem()
assert(dofile(_WD..'fallback.lua'))
showmem()
assert(dofile(_WD..'math.lua'))
showmem()
assert(dofile(_WD..'sort.lua'))
showmem()
assert(dofile(_WD..'gc.lua'))
showmem()
assert(dofile(_WD..'files.lua'))
print("final OK !!!")
showmem()

$ifnot _hard_i
print('limpando tudo!!!!')
local preserve = {_STDERR = 1, error = 1, _ERRORMESSAGE = 1, _ALERT = 1,
                  tostring = 1, _INPUT=1, _OUTPUT=1}

local collectgarbage, showmem, print, format, clock =
      collectgarbage, showmem, print, format, clock

setcallhook(function (a) %assert(%type(a) == 'string') end)
foreachvar(function (n) if not %preserve[n] then %setglobal(n, nil) end end)
$end

collectgarbage();showmem()

print(format("\n\ntempo total: %.2f\n", clock()-c))
