local IC = require("component").inventory_controller
local R=require("component").robot
local RA = require("robot")
local C = require("computer")
local G = require("component").generator
local sides = require("sides")
local shell = require("shell")


local args, ops = shell.parse(...)

local mined=0
local retToBase=false
local retToLoc=false

local invS=R.inventorySize()
local EInvS=IC.getInventorySize(sides.down)

function checkPower()
  return C.energy()/C.maxEnergy()
end

function checkInv()
  if R.count(invS-4)>0 then
    return true
  else
    return false
  end
end

function digSlice(dist)
  RA.swing(sides.forward)
  RA.forward()
  RA.swingUp()
  RA.swingDown()

  RA.turnLeft()
  RA.swing(sides.forward)
  RA.forward()
  RA.swingUp()
  RA.swingDown()

  RA.turnAround()
  RA.forward()

  RA.swing(sides.forward)
  RA.forward()
  RA.swingUp()
  RA.swingDown()

  RA.turnAround()
  RA.forward()
  if dist%7==0 then
    RA.place()
  end
  RA.turnRight()
end

function load()
  R.select(1)
  IC.suckFromSlot(sides.down,1,64-R.count())
  R.select(2)
  IC.suckFromSlot(sides.down,2,64-R.count())
end

function unload()
  local i=3
  local j=3
    
  while i<=invS do
    R.select(i)
    if R.count()>0 then
      if IC.getStackInInternalSlot(i).name=="minecraft:coal" then
        R.transferTo(1)
      end
      while R.count()>0 and j<=EInvS do
        IC.dropIntoSlot(sides.down, j)
        j=j+1
      end
    end
    j=1
    i=i+1
  end
  R.select(2)
end

function returnToBase(dist)
  local i=0
  while i<dist do
    RA.back()
    if checkPower()<0.05 then
      R.select(1)
      G.insert()
      R.select(2)
    end
    i=i+1
  end
  R.select(1)
  G.remove()
  R.select(2)
  load()
  unload()
  while checkPower()<0.99 do
    os.sleep(20)
  end
end

function returnToLoc(dist)
  local i=0
  while i<dist do
    RA.forward()
    i=i+1
  end
end

while mined<tonumber(args[1]) do
  if checkPower()<0.15 or checkInv() or R.count(2)<=1 then
    returnToBase(mined)
    returnToLoc(mined)
  end
  digSlice(mined)
  mined=mined+1
  print("Progress "..(mined*100)/tonumber(args[1]).."%")
end  
returnToBase(mined)  