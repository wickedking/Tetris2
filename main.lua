-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
update = 0
currentPiece ={}

function createPiece()
	local balloon = display.newRect(display.contentWidth/2,display.contentHeight/4,  60, 60 )
	balloon.myName = "Square"
	physics.addBody(balloon, "dynamic")
	currentPiece = balloon
	currentPiece:addEventListener("touch", moveBalloon) 
end

function moveBalloon(event)
	print("called")
	currentPiece:removeEventListener("touch", moveBalloon)
	physics.removeBody(currentPiece)
	physics.addBody(currentPiece, "static")
	createPiece()
end
function movePiece(event)
	update = update + 1
	if update %10 == 0 then
		currentPiece.y = currentPiece.y + 10
	end
end



function onCollision(event)
print("things")
	if(event.phase == "began") then
		if event.object1.myName == "Square" or event.object2.myName == "Square" then
			moveBalloon(event)
		end
	end
end



local physics = require("physics")
physics.setDrawMode("hybrid")
physics.start()
physics.setGravity(0, 0)

local background = display.newImage("bkg_bricks.png")
background.x = display.contentWidth/2
background.y = display.contentHeight/2



--local balloon = display.newRect(display.contentWidth/2,display.contentHeight/2,  50, 50 )
--balloon.x = display.contentWidth/2
--balloon.y = display.contentHeight/3
--local balloon = display.newRect(display.contentWidth/2,display.contentHeight/4,  60, 60 )
--balloon.myName = "Square"
--currentPiece = balloon

--physics.addBody(balloon, "dynamic")
--physics.addBody(balloon1, {bounce = 0.8, radius = 20, friction = 1.0})

createPiece()
local floor = display.newImage("base.png")
floor.x = display.contentWidth/2
floor.y = display.contentHeight
physics.addBody(floor, "static")
floor.myName = "Floor"

local leftWall = display.newRect(0,0,1, display.contentHeight*2)
local rightWall = display.newRect(display.contentWidth+1, 0, 1, display.contentHeight*2)
local ceiling = display.newRect(0,0,display.contentWidth*2, 1)

physics.addBody(leftWall, "static", {bounce = 0.1, friction = 1.0})
physics.addBody(rightWall, "static", {bounce = 0.1, friction = 1.0})
physics.addBody(ceiling, "static", {bounce = 0.1, friction = 1.0})

display.setStatusBar(display.HiddenStatusBar)



currentPiece:addEventListener("touch", moveBalloon) 
Runtime:addEventListener("enterFrame", movePiece)
Runtime:addEventListener("collision", onCollision)

