local IC = require("component").inventory_controller
local R=require("component").robot
local RA = require("robot")
local C = require("computer")
local sides = require("sides")
local shell = require("shell")

local args, ops = shell.parse(...)

local mined=0
local retToBase=false
local retToLoc=false

local invS=R.inventorySize()
local EInvS=IC.getInventorySize(sides.down)

function checkPower(onBase)
  if not onBase and C.energy()/C.maxEnergy()<0.15 then
    return true
  else
    return false
  end
  if onBase and C.energy()/C.maxEnergy()>0.99 then
    return true
  else
    return false
  end
end

function checkInv()
  if R.count(invS)>0 then
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
  if dist%7==0 and R.count()>1 then
    RA.place()
  end
  RA.turnRight()
end

function unload()
  local i=3
  local j=1
    
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
    i=i+1
  end
  unload()
  while checkPower(true) do
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
  if checkPower(false) or checkInv() then
    returnToBase(mined)
    returnToLoc(mined)
  end
  digSlice(mined)
  mined=mined+1
  print("Progress "..(mined*100)/tonumber(args[1]).."%")
end  
returnToBase(mined)  