-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
update = 0
currentPiece ={}
index = 6
pieceCreate = true

local menuScreen = {}
local tweenMS = {}
--currentPiece:addEventListener("collision", onCollision)


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
	print("create Piece")
	pieceCreate = true
	local balloon = display.newRect(100, 0, 0, 0)
	part1, part2, part3, part4 = piece()
	balloon.myName = "Square"
	balloon.bodyType = "dynamic"
	balloon.x = 100
	balloon.y = 0
	physics.addBody(balloon, "dynamic",{shape=part1}, {shape=part2}, {shape=part3}, {shape=part4})
	currentPiece = balloon
	balloon.isFixedRotation = true
	index = index + 1
	if index > 6 then
		index = 0
	end
	--local balloon = display.newRect(100, 0,  21, 21 )
	--balloon.myName = "Square"
	--balloon.bodyType = "dynamic"
	--physics.addBody(balloon)
	--currentPiece = balloon
	--currentPiece:addEventListener("touch", moveRight) 
	--currentPiece:addEventListener("collision", onCollision)
end

function moveBalloon(freezeEvent)
	--currentPiece:removeEventListener("touch", moveRight)
	--currentPiece:removeEventListener("collision", onCollision)
	if pieceCreate == true then
		--timer.performWithDelay(100, createPiece, 1)
		physics.removeBody(currentPiece)
		physics.addBody(currentPiece, "static")
		currentPiece.myName = "death"
		--createPiece()
		pieceCreate = false
		timer.performWithDelay(100, createPiece, 1)
	end
end

function movePiece(moveEvent)
	update = update + 1
	if update %10 == 0 then
		currentPiece.y = currentPiece.y + 10
	end
end

function onCollision(event)
	print(event.object1.myName)
	print(event.object2.myName)
	if event.object1.myName == "Square" or event.object2.myName == "Square" then
		if event.object1.myName ~= "Wall" and event.object2.myName ~= "Wall" then
			timer.performWithDelay(1, moveBalloon, 1)
		end
	end
end

function rotate()
	currentPiece.rotation = currentPiece.rotation + 45
	if currentPiece.rotation >= 360 then
		currentPiece.rotation = 0
	end
--do special things
end

function moveLeft()
	currentPiece.x = currentPiece.x - 21
end

function moveRight()
	print("moveRight")
	currentPiece.x = currentPiece.x + 21
end
 
function create()

local physics = require("physics")
physics.setDrawMode("debug")
physics.start()
physics.setGravity(0, 0)

local background = display.newImage("bkg_bricks.png")
background.x = display.contentWidth/2
background.y = display.contentHeight/2


local leftB = display.newImage("left_button.png")
leftB.x = display.contentWidth - 50
leftB.y = display.contentHeight / 8
physics.addBody(leftB, "static")
leftB:addEventListener("tap", moveLeft)

local rightB = display.newImage("right_button.png")
rightB.x = display.contentWidth - 50
rightB.y = display.contentHeight / 2
rightB:addEventListener("tap", moveRight)

local rotateB = display.newImage("rotate.png")
rotateB.x = display.contentWidth - 50
rotateB.y = display.contentHeight - 100
rotateB:addEventListener("touch", rotate)


createPiece()
	--local balloon = display.newRect(100, 0,  21, 21 )
--	local balloon = display.newImage("blue_balloon.png")
--	balloon.x = 100
--	balloon.y = 0
--	local part1 = {-21, 0, -21, 21, 0, 21, 0,0}
--	local part2 = {0,0, 0, 21, 21, 21, 21,0}
--	local part3 = {21, 0, 21,21, 42,21, 42,0}
--	local part4 = {0,21, 0,42, 21, 42, 21, 21}
	
	
	
local floor = display.newImage("base.png")
floor.x = display.contentWidth/2
floor.y = display.contentHeight + 55
physics.addBody(floor, "static")
floor.myName = "Floor"

local leftWall = display.newRect(0,0,1, display.contentHeight*2 + 50)
local rightWall = display.newRect(210, 0, 5, display.contentHeight*2 + 52)
leftWall.myName = "Wall"
rightWall.myName = "Wall"

physics.addBody(leftWall, "static", {bounce = 0.1, friction = 1.0})
physics.addBody(rightWall, "static", {bounce = 0.1, friction = 1.0})

display.setStatusBar(display.HiddenStatusBar)

Runtime:addEventListener("enterFrame", movePiece)
Runtime:addEventListener("collision", onCollision)

--local function Main()

--end
end




function piece() --TODO refactor each piece into its own method better coding
	--t piece table coodinates
	local partt2 = {-21, 0, -21, 21, 0, 21, 0,0}
	local partt1 = {0,0, 0, 21, 21, 21, 21,0}
	local partt3 = {21, 0, 21,21, 42,21, 42,0}
	local partt4 = {0,21, 0,42, 21, 42, 21, 21} --done
	
	--z piece
	local partz1 = {0,0,  0,21, 21,21, 21,0}
	local partz2 = {-21,0, -21,21, 0,21, 0,0}
	local partz3 = {0,21, 0,42, 21,42, 21,21}
	local partz4 = {21,21, 21,42, 42,42, 42,21} --done
	
	--s piece
	local parts1 = {0,0, 0,21, 21,21, 21,0}
	local parts2 = {-21,21, -21,42, 0,42, 0,21}
	local parts3 = {0,21, 0,42, 21,42, 21,21}
	local parts4 = {21,0, 21,21, 42,21, 42,0} --done
	
	--o piece
	local parto1 = {0,0, 0,21, 21,21, 21,0}
	local parto2 = {0,21, 0,42, 21,42, 21,21}
	local parto3 = {21,0, 21,21, 42,21, 42,0}
	local parto4 = {21,21, 21,42, 42,42, 42,21} --done
	
	--i piece
	local parti1 = {0,0, 0,21, 21,21, 21,0}
	local parti2 = {0,-21, 0,0, 21,0, 21,-21}
	local parti3 = {0,-42, 0,-21, 21,-21, 21,-42}
	local parti4 = {0,21, 0,42, 21,42, 21,21}-- done
	
	--l piece
	local partl2 = {0,-21, 0,0, 21,0, 21,-21}
	local partl1 = {0,0, 0,21, 21,21, 21,0}
	local partl3 = {0,21, 0,42, 21,42, 21,21}
	local partl4 = {21,21, 21,42, 42,42, 42,21} -- done
	
	--j piece
	local partj2 = {0,-21, 0,0, 21,0, 21,-21}
	local partj1 = {0,0, 0,21, 21,21, 21,0}
	local partj3 = {0,21, 0,42, 21,42, 21,21}
	local partj4 = {-21,21, -21,42, 0,42, 0,21} -- done
	
	if index == 0 then
		return partt1, partt2, partt3, partt4
	elseif index == 1 then
		return partz1, partz2, partz3, partz4
	elseif index == 2 then
		return parts1, parts2, parts3, parts4
	elseif index == 3 then
		return parto1, parto2, parto3, parto4
	elseif index == 4 then
		return parti1, parti2, parti3, parti4
	elseif index == 5 then
		return partl1, partl2, partl3, partl4
	else 
		return partj1, partj2, partj3, partj4
	end
end
addMenuScreen()

--piece moves past the wall. Needed to stop movement against wall better

