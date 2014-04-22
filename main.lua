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
		create()
	end
	
end


function createPiece()
	local balloon = display.newRect(105, 0,  21, 21 )
	balloon.myName = "Square"
	balloon.bodyType = "dynamic"
	physics.addBody(balloon)
	currentPiece = balloon
	currentPiece:addEventListener("touch", moveRight) 
	currentPiece:addEventListener("collision", onCollision)
end

function moveBalloon(event)
	currentPiece:removeEventListener("touch", moveRight)
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
	--if event.element1.name ~= "Wall" and event.element2.name ~= "Wall" then
		timer.performWithDelay(1, moveBalloon, 1)
	--end
end

function rotate()

--do special things
end

function moveLeft()
	currentPiece.x = currentPiece.x - 21
end

function moveRight(event)
	currentPiece.x = currentPiece.x + 21
end
 
function create()

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
floor.y = display.contentHeight + 55
physics.addBody(floor, "static")
floor.myName = "Floor"

local leftWall = display.newRect(0,0,1, display.contentHeight*2 + 50)
local rightWall = display.newRect(210, 0, 5, display.contentHeight*2 + 52)
leftWall.name = "Wall"
rightWall.name = "Wall"

physics.addBody(leftWall, "static", {bounce = 0.1, friction = 1.0})
physics.addBody(rightWall, "static", {bounce = 0.1, friction = 1.0})

display.setStatusBar(display.HiddenStatusBar)

Runtime:addEventListener("enterFrame", movePiece)

--local function Main()

--end
end
addMenuScreen()

