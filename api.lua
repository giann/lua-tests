
$ifnot testC

  print('\a\n >>> testC nao ativo: pulando testes da API <<<\n\a')

$else

  print('testando API com C')

-- push(1); push(2)
a,b = testC("1 2")
assert(a == 1 and b == 2)

-- push(1); push(4); setglobal('a'); setglobal('b')
testC("1 4 =a =b")
assert(a == 4 and b == 1)

-- r1 = param(1); push(r1)
assert(testC("p11 o1") == "p11 o1")

-- r1 = createtable; push(r1); push(4); push(8); settable(): push(r1)
a = testC"c1 o1 4 8 t o1"
assert(a[4] == 8)

function f(a,b,c,d)
  assert(a==b and d==nil);
  if c == nil then
    -- push(3); push(3); push(1); f(); r1 = result(1); push(r1)
    return testC("3 3 1 ff p11 o1")
  else return a
  end
end

a = 2
-- push(2); r1 = a; push(r1); f(); r1 = result(1);
-- push(r1); push(r1); f(); r1 = result(1); push(r1)
assert(testC("2 g1a o1 ff p11 o1 o1 ff p11 o1") == 3)

a = {x=45}
-- push('a'); r0 = a; push(r0); push('x'); r1=gettable(); push(r1);
a,b = testC('sa g0a o0 sx i1 o1')
assert(a == 'a' and b == 45)

-- push('a'); r0 = {}; push(r0), push(1), push(2), rawsettable;
-- push('a'); x = r0; r5 = x; push(r5), push(1), r3=gettable();
-- a = r3; x = r0; f()
testC("sa c0 o0 1 2 T sa o0 =x G5x o5 1 i3 o3 =a ff")
assert(a == 2 and x[1] == 2)

s = sin
-- push(1); call(s); push(9); r1 = result(1); push(r1)
a,b = testC('1 fs 9 p11 o1')
assert(a == 9 and b == sin(1))
assert(testC('1 fs') == nil)

-- push(1); r3 = getglobal('x'); r1 = param(2); r5 = pop(); push(r1)
a = call(testC, {"1 g3x p12 P5 o1", "testando"}, "pack")
assert(a.n == 1 and a[1] == "testando")


a = nil
-- r0 = a; push(r0); lock[2] = ref(1); r3 = lock[2]; push(r3)
a = testC"g0a o0 l2 r32 o3"
assert(not a)

-- r0 = {}; push(r0); lock[1] = ref(1)
testC("c0 o0 l1")

collectgarbage()

-- r5 = lock[1]; push(r5)
assert(type(testC("r51 o5")) == 'table')


-- colect in cl 'val' of all collected tables
tt = newtag()
cl = {n=0}
function f(x)  cl.n=cl.n+1; cl[x.val] = 1 end
settagmethod(tt, 'gc', f)

a = {val = 1}; b = {val = 2}; c = {val = 'v'}
settag(a, tt); settag(b, tt); settag(c, tt)

-- lock[1] = a; lock[2] = b; lock[3] = c
testC('g1a o1 l1 g1b o1 L2 g1c o1 L3')
-- return lock[1], lock[2], lock[3]
t = call(testC, {'r11 o1 r12 o1 r13 o1'}, "pack")
assert(t[1] == a and t[2] == b and t[3] == c)
t=nil a=nil b=nil c=nil

collectgarbage()

assert(type(testC("r51 o5")) == 'table')
-- testC("r52 o5")   -- must give an error

-- check that unlocked objects have been collected
assert(cl.n == 2 and cl[2] and cl.v and not cl[1])

-- unlock(lock[1])
testC("u1")
collectgarbage()
assert(cl.n == 3 and cl[1])

t = testC
s = 'p22 p33 o2 o3'
f = testC("g1s o1 8 Ct2")
a,b = f(4)
assert(a == 8 and b == 4)

-- testando lua_nextvar
X = nil
local a,b,c,d,e,f,g =
  testC("g2X 9 N2 p51 P3 8 p72 N3 P4 p61 o3 o5 o4 o6 p92 o7 o9")
local x,y = nextvar(nil)
assert(a==x and b==x and e==y)
x,y = nextvar(x)
assert(c==x and d==x and f==y)
assert(not g)

foreachvar(function (n) X=n end)   -- get 'last' global var
local a,b = testC("7 8 9 g2X N2 P3 o3 o2")
assert(not a and b == X)

-- testando lua_next
X = {x="alo"}
local a,b,c,d = testC("0 P1 g0X 8 n01 p51 p62 P1 9 n01 P1 o1 o5 o6")
assert(a==0 and b=='x' and c=='alo' and d == nil)


X = 'OK'
p = print
-- r0 = x; push(r0); call p
testC('G0X o0 fp')


$end
