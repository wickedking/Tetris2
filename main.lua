-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
update = 0
currentPiece ={}

--function currentPiece:collision(inEvent)
--	timer.performWithDelay(1, moveBalloon())
--
--end

function createPiece()
	local balloon = display.newRect(display.contentWidth/2,display.contentHeight/4,  60, 60 )
	balloon.myName = "Square"
	balloon.bodyType = "dynamic"
	physics.addBody(balloon)
	currentPiece = balloon
	--currentPiece.collision = onCollision()
	currentPiece:addEventListener("touch", onCollision) 
	currentPiece:addEventListener("collision", onCollision)
end

function moveBalloon(event)
	--print(event.name)
	currentPiece:removeEventListener("touch", onCollision)
	currentPiece:removeEventListener("collision", onCollision)
	physics.removeBody(currentPiece)
	physics.addBody(currentPiece, "static")
	currentPiece.myName = "death"
	--currentPiece.bodyType = "static"
	print(currentPiece.bodyType)
	createPiece()
end
function movePiece(event)
	update = update + 1
	if update %10 == 0 then
		currentPiece.y = currentPiece.y + 10
	end
end



function onCollision(event)
	timer.performWithDelay(1, moveBalloon, 1)
end



local physics = require("physics")
physics.setDrawMode("hybrid")
physics.start()
physics.setGravity(0, 0)

local background = display.newImage("bkg_bricks.png")
background.x = display.contentWidth/2
background.y = display.contentHeight/2

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



--currentPiece:addEventListener("touch", onCollision) 
Runtime:addEventListener("enterFrame", movePiece)
--currentPiece:addEventListener("preCollision", onCollision)

