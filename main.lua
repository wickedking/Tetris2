-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
update = 0
currentPiece ={}

local menuScreen = {}
local tweenMS = {}

function addMenuScreen()
	menuScreen = display.newGroup()
	local mScreen = display.newImage("menuScreen.png")
	local startButton = display.newImage("play_button.png")
	
	mScreen.x = display.contentWidth/2
	mScreen.y = display.contentHeight/2
	startButton.name = 'startB'
	menuScreen:insert(mScreen)
	startButton.x = display.contentWidth/2
	startButton.y = display.contentHeight/2
	menuScreen:insert(startButton)
	
	startButton:addEventListener('tap', tweenMS)

end

function tweenMS:tap(e)
	if (e.target.name == 'startB') then
		transition.to(menuScreen, {time = 400, y = -menuScreen.height * 2, transition = easing.outExpo, onComplete = addGameScreen})
	end
end


function createPiece()
	local balloon = display.newRect(display.contentWidth/2,display.contentHeight/4,  60, 60 )
	balloon.myName = "Square"
	balloon.bodyType = "dynamic"
	physics.addBody(balloon)
	currentPiece = balloon
	currentPiece:addEventListener("touch", onCollision) 
	currentPiece:addEventListener("collision", onCollision)
end

function moveBalloon(event)
	currentPiece:removeEventListener("touch", onCollision)
	currentPiece:removeEventListener("collision", onCollision)
	physics.removeBody(currentPiece)
	physics.addBody(currentPiece, "static")
	currentPiece.myName = "death"
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

Runtime:addEventListener("enterFrame", movePiece)


--local function Main()
addMenuScreen()
--end
