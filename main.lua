-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
update = 0
currentPiece ={}
index = 4
pieceCreate = true
board = {}
canRotate = true
pause = false
group = {}
extra_group = {}
start_over = true
gameOverGroup = {}
totalScore = 0
scoreGroup = {}
nextPieceGroup = display.newGroup()

display1 = display.newRect(0,0,0,0)
display2 = display.newRect(0,0,0,0)
display3 = display.newRect(0,0,0,0)
display4 = display.newRect(0,0,0,0)

local menuScreen = {}
local tweenMS = {}

function randomizeColor()
	for i = 0, 23 do
		for j = 0, 10 do
			if board[i][j] ~= 0 then
				board[i][j]:setFillColor(math.random(), math.random(), math.random())
			end
		end
	end
end

function deleteBoard()
	for i =0, 23 do
		for j = 0, 10 do
			board[i][j] = 0
		end
	end
end

function drawPiece(the_pieces)
	i = math.floor(currentPiece.y/21)
	j = math.floor(currentPiece.x/21)

	if display1 ~= nil then
		display1:removeSelf()
		display2:removeSelf()
		display3:removeSelf()
		display4:removeSelf()
	end
	
	display1 = display.newRect((j + the_pieces.piece1x)*21 + 10, (i + the_pieces.piece1y)*21 + 21 , 17,19)
	display2 = display.newRect((j + the_pieces.piece2x)*21 + 10, (i + the_pieces.piece2y)*21 + 21 , 17,19)
	display3 = display.newRect((j + the_pieces.piece3x)*21 + 10, (i + the_pieces.piece3y)*21 + 21 , 17,19)
	display4 = display.newRect((j + the_pieces.piece4x)*21 + 10, (i + the_pieces.piece4y)*21 + 21 , 17,19)

	group:insert(display1)
	group:insert(display2)
	group:insert(display3)
	group:insert(display4)
end

function drawNextPiece()

	nextPieceGroup:removeSelf()
	nextPieceGroup = display.newGroup()
	local nextPiece = {}
	local type = {}
	if index == 0 then
		type = "tPiece"
	elseif index == 1 then
		type = "zPiece"
	elseif index == 2 then
		type = "sPiece"
	elseif index == 3 then
		type = "oPiece"
	elseif index == 4 then
		type = "iPiece"
	elseif index == 5 then
		type = "lPiece"
	elseif index == 6 then
		type = "jPiece"
	end
	
	i = 20
	j = 13
	
	nextPiece["rotation"] = 0
	nextPiece["type"] = type
	local the_pieces = pieceRotation(nextPiece)
	
	local displayNext1 = display.newRect((j + the_pieces.piece1x)*21 + 10, (i + the_pieces.piece1y)*21 + 21 , 17,19)
	local displayNext2 = display.newRect((j + the_pieces.piece2x)*21 + 10, (i + the_pieces.piece2y)*21 + 21 , 17,19)
	local displayNext3 = display.newRect((j + the_pieces.piece3x)*21 + 10, (i + the_pieces.piece3y)*21 + 21 , 17,19)
	local displayNext4 = display.newRect((j + the_pieces.piece4x)*21 + 10, (i + the_pieces.piece4y)*21 + 21 , 17,19)
	
	nextPieceGroup:insert(displayNext1)
	nextPieceGroup:insert(displayNext2)
	nextPieceGroup:insert(displayNext3)
	nextPieceGroup:insert(displayNext4)
	
	
end

function updateScore(rows)
	totalScore = totalScore + ( rows * 100)
	scoreGroup = display.newGroup()
	local scoreBox = display.newRect(display.contentWidth - 50 , (display.contentHeight/4) * 3, 50, 50)
	scoreBox:setFillColor(1,1,1)
	scoreGroup:insert(scoreBox)
	local text = display.newText(totalScore, display.contentWidth - 50, (display.contentHeight / 4) * 3, native.systemFontBold, 14)
	text:setFillColor(0,0,0)
end

function createBoard()
	for i = 0, 23 do
	board[i] = {}
		for j = 0, 10 do
		board[i][j] = 0
		end
	end
end

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

function goAway()
	--print("goAway")
	os.exit()
end

function recreate()
	--board = {}
	----printBoard()
	--currentPiece = {}
	gameOverGroup:removeSelf()
	----create()
	----addMenuScreen()
	timer.performWithDelay(1000, create, 1)
	nextPieceGroup = display.newGroup()
end

function fail()
	if start_over then
		deleteBoard()
		board = {}
		pieceCreate = false
		gameOverGroup = display.newGroup()
		start_over = false
		pause = true
		
		extra_group:removeSelf()
		
		Runtime:removeEventListener("enterFrame", movePiece)
		Runtime:removeEventListener("collision", onCollision)

		local yes = display.newImage("yes.png")
		yes.x = display.contentWidth/4
		yes.y = (display.contentHeight/4) * 3
		yes:scale(0.4, 0.4)
		local no = display.newImage("no.png")
		no:scale(0.5, 0.5)
		no.x = (display.contentWidth/4) * 3
		no.y = (display.contentHeight/4) * 3
		
		local failed = display.newImage("fail.png")
		
		failed.x = display.contentWidth/2
		failed.y = display.contentHeight/4
		failed.name = "failed"
		
		yes.name = "yes"
		no.nmae = "no"
		
		gameOverGroup:insert(yes)
		gameOverGroup:insert(no)
		gameOverGroup:insert(failed)
		
		yes:addEventListener('tap', recreate)
		no:addEventListener('tap', goAway)
		group:removeSelf()
		scoreGroup:removeSelf()
		--nextPieceGroup:removeSelf()
	end
end

function createPiece()
	updateScore(0)
	--print("createPiece")
	canRotate = true
	pieceCreate = true
	
	local balloon = display.newImage("box.png")
	balloon.width = 21
	balloon.height = 21

	local balloon = display.newGroup()
	if index == 0 then
		balloon.type = "tPiece"
	elseif index == 1 then
		balloon.type = "zPiece"
	elseif index == 2 then
		balloon.type = "sPiece"
	elseif index == 3 then
		balloon.type = "oPiece"
	elseif index == 4 then
		balloon.type = "iPiece"
	elseif index == 5 then
		balloon.type = "lPiece"
	elseif index == 6 then
		balloon.type = "jPiece"
	end

	balloon.height = 21
	balloon.width = 21
	balloon:scale(.3, .3)
	--part1, part2, part3, part4 = piece()
	balloon.myName = "Square"
	balloon.bodyType = "dynamic"
	balloon.x = 21 * 5
	balloon.y = -50
	
	--physics.addBody(balloon, "dynamic",{shape=part1}, {shape=part2}, {shape=part3}, {shape=part4})
	--physics.addBody(balloon, "dynamic")
	currentPiece = balloon
	balloon.isFixedRotation = true
	--index = index + 1
	if index > 6 then
		index = 0
	end
	drawNextPiece()
	
	--group:insert(balloon)
	--group:insert(currentPiece)
end

function updateBoard(the_pieces)
--will be called will freezeing piece
--will create new objects on board and then display.
--will be able to keep a reference to all "destroyed" pieces
--will check rows to see if deletion is necassary
	if pause == false then

		i = math.floor(currentPiece.y/21)
		j = math.floor(currentPiece.x/21)
		
		--well checks are actually working at the moment. 

		if i + the_pieces.piece1y > 23 or j + the_pieces.piece1x > 10 or j + the_pieces.piece1x < 0 or i + the_pieces.piece1y < 0 then
			pause = true
			fail()
			return
		else
			board[i + the_pieces.piece1y][j + the_pieces.piece1x] = display.newRect((j + the_pieces.piece1x)*21 + 10, (i + the_pieces.piece1y)*21 +21, 19,19)
			board[i + the_pieces.piece1y][j + the_pieces.piece1x]:setFillColor(math.random(),math.random(), math.random())
			group:insert(board[i + the_pieces.piece1y][j + the_pieces.piece1x])
			physics.addBody(board[i + the_pieces.piece1y][j + the_pieces.piece1x], "kinematic")
		end
		
		if i + the_pieces.piece2y > 23 or j + the_pieces.piece2x > 10 or j + the_pieces.piece2x < 0 or i + the_pieces.piece2y < 0 then
			pause = true
			fail()
			return
		else
			board[i + the_pieces.piece2y][j + the_pieces.piece2x] = display.newRect((j + the_pieces.piece2x)*21 + 10, (i + the_pieces.piece2y)*21 +21, 17,19)
			board[i + the_pieces.piece2y][j + the_pieces.piece2x]:setFillColor(math.random(),math.random(), math.random())
			group:insert(board[i + the_pieces.piece2y][j + the_pieces.piece2x])
			physics.addBody(board[i + the_pieces.piece2y][j + the_pieces.piece2x], "kinematic")
		end
		if i + the_pieces.piece3y > 23 or j + the_pieces.piece3x > 10  or j + the_pieces.piece3x < 0 or i + the_pieces.piece3y < 0 then
			fail()
			pause = true
			return
		else
			board[i + the_pieces.piece3y][j + the_pieces.piece3x] = display.newRect((j + the_pieces.piece3x)*21 + 10, (i + the_pieces.piece3y)*21 +21, 17,19)
			board[i + the_pieces.piece3y][j + the_pieces.piece3x]:setFillColor(math.random(),math.random(), math.random())
			group:insert(board[i + the_pieces.piece3y][j + the_pieces.piece3x])
			physics.addBody(board[i + the_pieces.piece3y][j + the_pieces.piece3x], "kinematic")
		end
		if i + the_pieces.piece4y > 23 or j + the_pieces.piece4x > 10  or j + the_pieces.piece4x < 0 or i + the_pieces.piece4y < 0 then
			fail()
			pause = true
			return
		else
			board[i + the_pieces.piece4y][j + the_pieces.piece4x] = display.newRect((j + the_pieces.piece4x)*21 + 10, (i + the_pieces.piece4y)*21+21, 17,19)
			board[i + the_pieces.piece4y][j + the_pieces.piece4x]:setFillColor(math.random(),math.random(), math.random())
			group:insert(board[i + the_pieces.piece4y][j + the_pieces.piece4x])
			physics.addBody(board[i + the_pieces.piece4y][j + the_pieces.piece4x], "kinematic")
		end
		removeRows()
	--call to check for rows
	end
end

function printBoard()
	for i = 0, 23 do
		for j = 0, 10 do
			print(board[i][j])
		end
	end

end

function redraw() --need to draw it a bit down, and a bit to the right
	group:removeSelf()
	group = display.newGroup()
	for i = 0, 23 do
		for j = 0, 10 do
			if board[i][j] ~= 0 then
				print(i.." i value")
				print(j)
				board[i][j] = display.newRect((j * 21) + 10, (i *21) + 21, 19, 19)
				board[i][j]:setFillColor(math.random(), math.random(), math.random())
				group:insert(board[i][j])
			end
		end
	end
end

function rowFall(inital_row, total_rows)
	print("rowFall")
	print(inital_row)
	print(total_rows)
	for i = inital_row, 0, -1 do
		for j = 0, 10 do
			--print(board[i][j])
			if board[i][j] ~= 0 then
				--print("something happended")
				board[i + total_rows][j] = board[i][j]
				board[i][j] = 0
				--print(board[i][j])
				--print(board[i+ total_rows][j])
			end
		end
	end
	redraw()
end

function removeRows()
	rows = 0
	the_row = 0
	
	for i = 0, 23 do
		local boolean check = true
		for j = 0, 10 do
			if board[i][j] == 0 then
			check = false
			break
			end
		end
		if check then
			if the_row == 0 then
				the_row = i
			end
			rows = rows + 1
			for j = 0, 10 do
			 board[i][j]:removeSelf()
			 board[i][j] = 0
			end
		--go back and delete row
		--need to move pieces down
		end
	end
	if rows ~= 0 then
		rowFall(the_row, rows)
	end
	updateScore(rows)
end

function checkTopRow()
	local isPiece = false
	for j = 0, 10 do
		if board[0][j] ~= 0 then
		isPiece = true
		break
		end
	end
	return isPiece
end

function checkMove(dx, dy)
	local can = false
	local piece1 = false
	local piece2 = false
	local piece3 = false
	local piece4 = false
	local piece = pieceRotation(currentPiece)
	x = math.floor(currentPiece.x/21)
	y = math.floor(currentPiece.y/21)
	if piece.piece1x + x + dx >= 0 and piece.piece1x + x + dx <= 10 then
		if piece.piece2x + x + dx >= 0 and piece.piece2x + x + dx <= 10 then
			if piece.piece3x + x + dx >= 0 and piece.piece3x + x + dx <= 10 then
				if piece.piece4x + x + dx >= 0 and piece.piece4x + x + dx <= 10 then
					if  piece.piece1y + y + dy >=  0 and piece.piece2y + y + dy >=  0 and piece.piece3y + y + dy >=  0 and piece.piece4y + y + dy >=  0 then
						if  piece.piece1y + y + dy <= 23 then
							piece1 = true
							if  piece.piece2y + y + dy <= 23 then
								piece2 = true
								if  piece.piece3y + y + dy <= 23 then
									piece3 = true
									if piece.piece4y + y + dy <= 23 then
										piece4 = true
										--take current position add x and y and then check for a piece
										if board[y + piece.piece1y + dy][x + piece.piece1x + dx] == 0 then
											if board[y + piece.piece2y + dy][x + piece.piece2x + dx] == 0 then
												if board[y + piece.piece3y + dy][x + piece.piece3x + dx] == 0 then
													if board[y + piece.piece4y + dy][x + piece.piece4x + dx] == 0 then
														can = true
													end
												end
											end
										end
									end
								end
							end
						end
					else
						local test = checkTopRow()
						if test == false then
							can = true
						end
					
					end
				end
			end
		end
	end
	
	return can
end

function freezePiece(freezeEvent)
	if pieceCreate == true then
		local pieces = pieceRotation(currentPiece)
		--physics.removeBody(currentPiece)
		physics.addBody(currentPiece, "static")
		currentPiece.myName = "death"
		pieceCreate = false
		randomizeColor()
		timer.performWithDelay(1, updateBoard(pieces), 1)
		currentPiece:removeSelf()
		timer.performWithDelay(100, createPiece, 1)
	end
end

function movePiece(moveEvent)
	update = update + 1
	if update %20 == 0  and pause == false then
		if checkMove(0,1) then
		currentPiece.y = currentPiece.y + 21
		else
			freezePiece()
		end
		drawPiece(pieceRotation(currentPiece))
	end
end

function onCollision(event)
	if event.object1.myName == "Square" or event.object2.myName == "Square" then
		if event.object1.myName ~= "leftWall" and event.object2.myName ~= "leftWall" then
			if event.object1.myName ~= "rightWall" and event.object2.myName ~= "rightWall" then
				timer.performWithDelay(1, freezePiece, 1)
			end
		end
	end
end

function rotate()
	if canRotate == false then
		canRotate = true
		return
	else 
		canRotate = false
	end
	if currentPiece.type == "oPiece" then
		return
	elseif currentPiece.type == "iPiece" or currentPiece.type == "zPiece" or  currentPiece.type == "sPiece" then
		if currentPiece.rotation == 90 then
			currentPiece.rotation = 0
			if checkMove(0,0) then
				--do nothing
			else 
				currentPiece.rotation = 0
			end
		else
			currentPiece.rotation = 90
			if checkMove(0,0) then
				--do nothing
			else 
				currentPiece.rotation = 0
			end
		end
		drawPiece(pieceRotation(currentPiece))
		return
	end
	currentPiece.rotation = currentPiece.rotation + 90
	if checkMove(0,0) then
		--do nothing
	else 
		currentPiece.rotation = currentPiece.rotation - 90
	end
	if currentPiece.rotation >= 360 then
		currentPiece.rotation = 0
	end
	--print(currentPiece.rotation)
	drawPiece(pieceRotation(currentPiece))
end

function moveLeft()
	if checkMove(-1, 0) then
		currentPiece.x = currentPiece.x - 21
	end
	drawPiece(pieceRotation(currentPiece))
end

function moveRight()
	--if math.floor(currentPiece.x/21) >= 10 then
	--	return
	--end
	--moves = pieceRotation(currentPiece)
	--if (moves["piece1x"] * 21) + currentPiece.x < 11 then
	--	if (moves["piece2x"] * 21) + currentPiece.x < 11 then
	--		if (moves["piece3x"] * 21) + currentPiece.x < 11 then
	--			if (moves["piece4x"] * 21) + currentPiece.x < 11 then
	--				currentPiece.x = currentPiece.x + 21
	--				drawPiece(pieceRotation(currentPiece))
	--			end
	--		end
	--	end
	--end
	if checkMove(1,0) then
		currentPiece.x = currentPiece.x + 21
	end
	drawPiece(pieceRotation(currentPiece))
end

function rightWallCollision(event)
	if event.object1.myName == "Square" or event.object2.myName == "Square" then
		if event.object1.myName == "rightWall" and event.object2.myName == "rightWall" then
			moveLeft()
		end
	end

end

function leftWallCollision(event)
	if event.object1.myName == "Square" or event.object2.myName == "Square" then
		if event.object1.myName == "leftWall" or event.object2.myName == "leftWall" then
			moveRight()
		end
	end

end
 
function create()
	start_over = true
	pause = false
	
	nextPieceGroup:removeSelf()
	nextPieceGroup:removeSelf()
	
	display1 = display.newRect(0,0,0,0)
	display2 = display.newRect(0,0,0,0)
	display3 = display.newRect(0,0,0,0)
	display4 = display.newRect(0,0,0,0)

	group = display.newGroup()
	extra_group = display.newGroup()
	createBoard()
	local physics = require("physics")
	--physics.setDrawMode("hybrid")
	physics.start()
	physics.setGravity(0, 0)

	local leftB = display.newImage("left_button.png")
	leftB.x = display.contentWidth - 50
	leftB.y = display.contentHeight / 8
	leftB:addEventListener("tap", moveLeft)

	local rightB = display.newImage("right_button.png")
	rightB.x = display.contentWidth - 50
	rightB.y = display.contentHeight / 2
	rightB:addEventListener("tap", moveRight)

	local rotateB = display.newImage("rotate.png")
	rotateB.x = display.contentWidth - 50
	rotateB.y = display.contentHeight - 100
	rotateB:addEventListener("touch", rotate)
	
	extra_group:insert(leftB)
	extra_group:insert(rightB)
	extra_group:insert(rotateB)

	createPiece()

	local floor = display.newImage("base.png")
	floor.x = display.contentWidth/2
	floor.y = display.contentHeight + 55
	physics.addBody(floor, "static")
	floor.myName = "Floor"

	local leftWall = display.newRect(0,0,1, display.contentHeight*2 + 50)
	local rightWall = display.newRect(221, 0, 5, display.contentHeight*2 + 52)
	leftWall.myName = "leftWall"
	rightWall.myName = "rightWall"

	physics.addBody(leftWall, "static", {bounce = 0.1, friction = 1.0})
	physics.addBody(rightWall, "static", {bounce = 0.1, friction = 1.0})

	display.setStatusBar(display.HiddenStatusBar)
	
	extra_group:insert(floor)
	extra_group:insert(leftWall)
	extra_group:insert(rightWall)

	Runtime:addEventListener("enterFrame", movePiece)
	Runtime:addEventListener("collision", onCollision)
	--Runtime:addEventListener("preCollision", leftWallCollision)
	--Runtime:addEventListener("preCollision", rightWallCollision)
end

function pieceRotation(currentPiece)
--return xy, xy, xy, xy from current location of subpieces. 
--so a t piece in the down position at 105, 21 would return
--assuming xy location is down and right square
locations = {}
	

	if currentPiece.type == "tPiece" then --screwed
		if currentPiece.rotation == 0 then
			locations["piece1x"] = -1
			locations["piece1y"] = 0
			locations["piece2x"] = 0
			locations["piece2y"] = 0
			locations["piece3x"] = 0
			locations["piece3y"] = 1
			locations["piece4x"] = 1
			locations["piece4y"] = 0
		elseif currentPiece.rotation == 90 then 
			locations["piece1x"] = -1
			locations["piece1y"] = 0
			locations["piece2x"] = -1
			locations["piece2y"] = 1
			locations["piece3x"] = -2
			locations["piece3y"] = 0
			locations["piece4x"] = -1
			locations["piece4y"] = -1
		elseif currentPiece.rotation == 180 then
			locations["piece1x"] = -2
			locations["piece1y"] = -1
			locations["piece2x"] = -1
			locations["piece2y"] = -1
			locations["piece3x"] = -1
			locations["piece3y"] = -2
			locations["piece4x"] = 0
			locations["piece4y"] = -1
		else  --0,-1, 0,-2, 1,-1, 0,0
			locations["piece1x"] = 0
			locations["piece1y"] = -1
			locations["piece2x"] = 0
			locations["piece2y"] = -2
			locations["piece3x"] =  1
			locations["piece3y"] = -1
			locations["piece4x"] = 0
			locations["piece4y"] = 0
		end
	elseif currentPiece.type == "sPiece" then
		if currentPiece.rotation == 0 then 
			locations["piece1x"] = 0
			locations["piece1y"] = 0
			locations["piece2x"] = 1
			locations["piece2y"] = 0
			locations["piece3x"] = 0
			locations["piece3y"] = 1
			locations["piece4x"] = -1
			locations["piece4y"] = 1
		elseif currentPiece.rotation == 90 then
			locations["piece1x"] = -2
			locations["piece1y"] = -1
			locations["piece2x"] = -2
			locations["piece2y"] = 0
			locations["piece3x"] = -1
			locations["piece3y"] = 0
			locations["piece4x"] = -1
			locations["piece4y"] = 1
	end
	elseif currentPiece.type == "zPiece" then --screwed
		if currentPiece.rotation == 0 then -- 1,0, 0,0, 2,0, 1,1 -1x +1y
			locations["piece1x"] = 0
			locations["piece1y"] = 0
			locations["piece2x"] = -1
			locations["piece2y"] = 0
			locations["piece3x"] = 1
			locations["piece3y"] = 1
			locations["piece4x"] = 0
			locations["piece4y"] = 1
		elseif currentPiece.rotation == 90 then -- -1,0, -2,0, -2,1, -1,-1
			locations["piece1x"] = -1
			locations["piece1y"] = 0
			locations["piece2x"] = -2
			locations["piece2y"] = 0
			locations["piece3x"] = -2
			locations["piece3y"] = 1
			locations["piece4x"] = -1
			locations["piece4y"] = -1
		end
	elseif currentPiece.type == "oPiece" then
		locations["piece1x"] = 0
		locations["piece1y"] = 0
		locations["piece2x"] = 0
		locations["piece2y"] = 1
		locations["piece3x"] = 1
		locations["piece3y"] = 0
		locations["piece4x"] = 1
		locations["piece4y"] = 1
	elseif currentPiece.type == "iPiece" then
		if currentPiece.rotation == 0 then -- 0,0, 0,1, 0,-1, 0,-21
			locations["piece1x"] = 0
			locations["piece1y"] = 0
			locations["piece2x"] = 0
			locations["piece2y"] = 1
			locations["piece3x"] = 0
			locations["piece3y"] = -1
			locations["piece4x"] = 0
			locations["piece4y"] = -2
		elseif currentPiece.rotation == 90 then -- 0,0 1,0, -1,0, -2,0
			locations["piece1x"] = 0
			locations["piece1y"] = 0
			locations["piece2x"] = 1
			locations["piece2y"] = 0
			locations["piece3x"] = -1
			locations["piece3y"] = 0
			locations["piece4x"] = -2
			locations["piece4y"] = 0
		end
	elseif currentPiece.type == "lPiece" then
		if currentPiece.rotation == 0 then -- 0,0, 0,-1, 0,1, 1,1
			locations["piece1x"] = 0
			locations["piece1y"] = 0
			locations["piece2x"] = 0
			locations["piece2y"] = -1
			locations["piece3x"] = 0
			locations["piece3y"] = 1
			locations["piece4x"] = 1
			locations["piece4y"] = 1
		elseif currentPiece.rotation == 90 then -- 0,0, -1,0, -2,0, -2,1
			locations["piece1x"] = 0
			locations["piece1y"] = 0
			locations["piece2x"] = -1
			locations["piece2y"] = 0
			locations["piece3x"] = -2
			locations["piece3y"] = 0
			locations["piece4x"] = -2
			locations["piece4y"] = 1
		elseif currentPiece.rotation == 180 then -- -1,0, -1,-1, -1,-2, -2,-2
			locations["piece1x"] = -1
			locations["piece1y"] = 0
			locations["piece2x"] = -1
			locations["piece2y"] = -1
			locations["piece3x"] = -1
			locations["piece3y"] = -2
			locations["piece4x"] = -2
			locations["piece4y"] = -2
		else  -- -1,-1, 0,-1, 1,-1, 1,-2
			locations["piece1x"] = -1
			locations["piece1y"] = -1
			locations["piece2x"] = 0
			locations["piece2y"] = -1
			locations["piece3x"] =  1
			locations["piece3y"] = -1
			locations["piece4x"] = 1
			locations["piece4y"] = -2
		end
	else
		if currentPiece.rotation == 0 then -- 0,0, 0,1, -1,1, 0,-10
			locations["piece1x"] = 0
			locations["piece1y"] = 0
			locations["piece2x"] = 0
			locations["piece2y"] = 1
			locations["piece3x"] = -1
			locations["piece3y"] = 1
			locations["piece4x"] = 0
			locations["piece4y"] = -1
		elseif currentPiece.rotation == 90 then -- -2,-1, -2,0, -1,0, 0,0
			locations["piece1x"] = -2
			locations["piece1y"] = -1
			locations["piece2x"] = -2
			locations["piece2y"] = 0
			locations["piece3x"] = -1
			locations["piece3y"] = 0
			locations["piece4x"] = 0
			locations["piece4y"] = 0
		elseif currentPiece.rotation == 180 then -- -1,0, -1,-1, -1,-2, 0,-2
			locations["piece1x"] = -1
			locations["piece1y"] = 0
			locations["piece2x"] = -1
			locations["piece2y"] = -1
			locations["piece3x"] = -1
			locations["piece3y"] = -2
			locations["piece4x"] = 0
			locations["piece4y"] = -2
		else  -- 0,-1, -1,-1, 1,-1, 1,0
			locations["piece1x"] = 0
			locations["piece1y"] = -1
			locations["piece2x"] = -1
			locations["piece2y"] = -1
			locations["piece3x"] =  1
			locations["piece3y"] = -1
			locations["piece4x"] = 1
			locations["piece4y"] = 0
		end
	end
	return locations
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

