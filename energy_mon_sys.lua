local component = require "component"
local m = component.induction_matrix
local r = component.br_reactor
local computer = require("computer")
local GUI = require("GUI")

local mainContainer = GUI.fullScreenContainer()

  

  digits = 3
  shift = 10 ^ digits
  

  while true do
  os.sleep(1)
-- работаем с накопителем
    a = (m.getEnergyStored()*100)/(m.getMaxEnergyStored())
    z = math.floor(a*shift+0.5)/shift
   
     y = math.floor(z+0.5)
     input = m.getInput()
     maxio = m.getTransferCap()
     output = m.getOutput()
    
    mainContainer:addChild(GUI.panel(1, 1, mainContainer.width, mainContainer.height, 0x2D2D2D))
    mainContainer:addChild(GUI.text(3, 1, 0xFFFFFF, m.getEnergyStored()/2.5))
    mainContainer:addChild(GUI.progressBar(2, 2, 100, 0x3366CC, 0xEEEEEE, 0xEEEEEE, y, true, true, "Energy: ", " %"))
    mainContainer:addChild(GUI.text(3, 4, 0xFFFFFF, input/2.5))
    mainContainer:addChild(GUI.progressBar(2, 5, 100, 0x3366CC, 0xEEEEEE, 0xEEEEEE, math.floor(((input*100)/maxio)*shift+0.5)/shift, true, true, "Energy in: ", " "))
    mainContainer:addChild(GUI.text(3, 7, 0xFFFFFF, output/2.5))
    mainContainer:addChild(GUI.progressBar(2, 8, 100, 0x3366CC, 0xEEEEEE, 0xEEEEEE, math.floor(((output*100)/maxio)*shift+0.5)/shift, true, true, "Energy out: ", " "))
  
-- работаем с реактором
    
    maxfuel = r.getFuelAmountMax()
    curfuel = r.getFuelAmount()
    pfuel = (curfuel*100)/maxfuel
    rpfuel = math.floor(pfuel*shift+0.5)/shift
    ctrlrodlev = r.getControlRodLevel(0)
    
    if a<90 then
      r.setAllControlRodLevels(0)
    end
    if a>90 and a<95 then
      r.setAllControlRodLevels(90)
    end
    if a>=95 and a<96 then
      r.setAllControlRodLevels(95)
    end
    if a>=96 and a<97 then
     r.setAllControlRodLevels(96)
    end
    if a>=97 and a<98 then
      r.setAllControlRodLevels(97)
    end
    if a>=98 and a<99 then
      r.setAllControlRodLevels(98)
    end
    if a>=99 and a<100 then
      r.setAllControlRodLevels(99)
    end
    if a==100 then
      r.setAllControlRodLevels(100)
    end
    
    mainContainer:addChild(GUI.progressBar(2, 10, 100, 0x3366CC, 0xEEEEEE, 0xEEEEEE, ctrlrodlev, true, true, "Controlrod insertion: ", " %"))
    mainContainer:addChild(GUI.progressBar(2, 12, 100, 0x3366CC, 0xEEEEEE, 0xEEEEEE, rpfuel, true, true, "Fuel: ", " %"))
    
    
    mainContainer:drawOnScreen(true)
 



    
       b = 0
-- врубаем сирену если заряд меньше 0.1%
    if z <= 0.1 or pfuel<90 then
      while b < 20 do
       b = b+1 
      component.tape_drive.seek(-999999)
      component.tape_drive.play()
      computer.beep(900)
      computer.beep(500)
      os.sleep(1.9)
      component.tape_drive.stop()
      end
    end
  end
  
   
  
