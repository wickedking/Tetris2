-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
highScores = require("highScore")

timer.performWithDelay(1, function() collectgarbage("collect") end)

options = {loop = -1}

fillBoard = true
fillBoardCircle = {}

soundEffects = true
soundEffectsCircle = {}

sfx = {}

sfx.theme = audio.loadStream("theme.mp3")
sfx.level_one = audio.loadStream("level_one.mp3")
sfx.level_two = audio.loadStream("level_two.mp3")
sfx.level_three = audio.loadStream("level_three.mp3")
sfx.level_four = audio.loadStream("level_four.mp3")

music = true
musicCircle = {}
background = {}

level = 1

tapControl = true
tapCircle = {}
buttonCircle = {}

update = 0
update_number = 20

updatePieceNumber = 100

currentPiece = {}
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
totalScoreCopy = 0
scoreGroup = display.newGroup()
nextPieceGroup = display.newGroup()

pieceLines = display.newGroup()

use_ghostPiece = true
ghostGroup = nil

--Used to change range of random colors
low_color = 50
high_color = 51

--Constants for the printing on screen. The offset for each
x_offset = 10
y_offset = -12

--the multiplier for the board values.
board_offset = 21 --need to be set at run time
height_offset = display.contentHeight / 23

board_height = 23
board_width = 10

block_size = 19

pause_block = display.newRect(0,0,0,0)
pause_text = {}

click = audio.loadSound("tap4.wav")

--the_music = audio.loadSound("stepping.wav")

display1 = display.newRect(0,0,0,0)
display2 = display.newRect(0,0,0,0)
display3 = display.newRect(0,0,0,0)
display4 = display.newRect(0,0,0,0)

local menuScreen = {}
local tweenMS = {}
settingsScreenGroup = {}

line1 = {}
line2 = {}

fillImage = {}
soundEffectImage = {}
musicImage = {}
controlImage = {}

highScoreText = {}
yourScoreText = {}

highScore = {}
highScore.score1 = 100
highScore = loadTable("highScore.json")

--if highScore.score1 == 100 then -- highScore.score1 == nil then
--	highScore.score1 = 1500
--	saveTable(highScore, "highScore.json")
--end

function settingsScreen()
--sound effects
--fill board
--music
--Tap on screen control

	menuScreen:removeSelf()
	audio.stop()
	settingScreenGroup = display.newGroup()

	local fillText = display.newText(settingScreenGroup, "Fill Board", display.contentWidth/5, display.contentHeight/6, native.systemFontBold, 14)
	local soundEffectText = display.newText(settingScreenGroup, "Sound Effects", display.contentWidth/5, display.contentHeight/6 * 2, native.systemFontBold, 14)
	local musicText = display.newText(settingScreenGroup, "music", display.contentWidth/5, display.contentHeight/6 * 3, native.systemFontBold, 14)
	local controlText = display.newText(settingScreenGroup, "Control: On for Tap", display.contentWidth/5, display.contentHeight/6 * 4, native.systemFontBold, 14)
	
	local backText = display.newText(settingScreenGroup, "Main Menu", display.contentWidth/2, display.contentHeight/6 * 5, native.systemFontBold, 14)
	
	
	if fillBoard == true then
		fillImage = display.newImage("on_button.png")
	else 
		fillImage = display.newImage("off_button.png")
	end
	if soundEffects == true then
		soundEffectImage = display.newImage("on_button.png")
	else 
		soundEffectImage = display.newImage("off_button.png")
	end
	if music == true then
		musicImage = display.newImage("on_button.png")
	else 
		musicImage = display.newImage("off_button.png")
	end
	if tapControl == true then
		controlImage = display.newImage("on_button.png")
	else 
		controlImage = display.newImage("off_button.png")
	end
	
	--fillImage = display.newImage("on_button.png")
	--soundEffectImage = display.newImage("on_button.png")
	--musicImage = display.newImage("on_button.png")
	--controlImage = display.newImage("on_button.png")
	
	fillImage:scale(0.5, 0.5)
	soundEffectImage:scale(0.5, 0.5)
	musicImage:scale(0.5, 0.5)
	controlImage:scale(0.5, 0.5)
	
	fillImage.x = display.contentWidth/4 * 3
	soundEffectImage.x = display.contentWidth/4 * 3
	musicImage.x = display.contentWidth/4 * 3
	controlImage.x = display.contentWidth/4 * 3
	
	fillImage.y = display.contentHeight/6
	soundEffectImage.y = display.contentHeight/6 * 2
	musicImage.y = display.contentHeight/6 * 3
	controlImage.y = display.contentHeight/6 * 4
	
	
	soundEffectText:addEventListener("tap", soundEffect)
	controlText:addEventListener("tap", displayControl)
	musicText:addEventListener("tap", soundMusic)
	fillText:addEventListener("tap", changeFill)
	
	fillImage:addEventListener("tap", changeFill)
	soundEffectImage:addEventListener("tap", soundEffect)
	musicImage:addEventListener("tap", soundMusic)
	controlImage:addEventListener("tap", displayControl)	
	backText:addEventListener("tap", backToMenu)
	
end

function backToMenu()
	settingScreenGroup:removeSelf()
	settingScreenGroup = display.newGroup()
	
	fillImage:removeSelf()
	soundEffectImage:removeSelf()
	musicImage:removeSelf()
	controlImage:removeSelf()
	
	fillImage = display.newRect(0,0,0,0)
	soundEffectImage = display.newRect(0,0,0,0)
	musicImage = display.newRect(0,0,0,0)
	controlImage = display.newRect(0,0,0,0)
	
	addMenuScreen()

end

function pauseGame()
	if pause == false then
		pause = true
		audio.pause()
		pause_block = display.newRect(0,0,1000, 1000)
		pause_block:setFillColor(0,0,0)
		pause_block:addEventListener("tap", pauseGame)
		pauseText = display.newText("PAUSED", display.contentWidth/2, display.contentHeight/2, native.systemFontBold, 18)
	else
		pause = false
		audio.play(the_music, options)
		pause_block:removeSelf()
		pauseText:removeSelf()
	end
end

function randomizeColor()
	for i = 0, board_height do
		for j = 0, board_width do
			if board[i][j] ~= 0 then
				board[i][j]:setFillColor(math.random(low_color, high_color) / 100 ,math.random(low_color, high_color) / 100, math.random(low_color, high_color) / 100)
			end
		end
	end
end

function deleteBoard()
	for i =0, board_height do
		for j = 0, board_width do
			board[i][j] = 0
		end
	end
end

function drawPiece(the_pieces)
	pieceLines:removeSelf()
	local i = math.floor(currentPiece.y/height_offset)
	local j = math.floor(currentPiece.x/board_offset)

	if display1 ~= nil then
		display1:removeSelf()
		display2:removeSelf()
		display3:removeSelf()
		display4:removeSelf()
	end
	local small_x = 10
	local big_x = -10
	
	if the_pieces.piece1x < small_x then
		small_x = the_pieces.piece1x
	end
	if the_pieces.piece2x < small_x then
		small_x = the_pieces.piece2x
	end
	if the_pieces.piece3x < small_x then
		small_x = the_pieces.piece3x
	end
	if the_pieces.piece4x < small_x then
		small_x = the_pieces.piece4x
	end
	if the_pieces.piece1x > big_x then
		big_x = the_pieces.piece1x
	end
	if the_pieces.piece2x > big_x then
		big_x = the_pieces.piece2x
	end
	if the_pieces.piece3x > big_x then
		big_x = the_pieces.piece3x
	end
	if the_pieces.piece4x > big_x then
		big_x = the_pieces.piece4x
	end
	

	pieceLines = display.newGroup()
	
	small_x = (small_x * 21) + currentPiece.x
	big_x = big_x + 1
	big_x = (big_x * 21) + currentPiece.x
	
	line1 = display.newLine(small_x , currentPiece.y - 35, small_x, 480)
	line2 = display.newLine(big_x, currentPiece.y - 35, big_x, 480)
	
	pieceLines:insert(line1)
	pieceLines:insert(line2)
	
	line1:setStrokeColor(0.33,0.0,1.0)
	line2:setStrokeColor(0.33,0.0,1.0)
	
	display1 = display.newRect((j + the_pieces.piece1x) * board_offset + x_offset, (i + the_pieces.piece1y) * board_offset + y_offset, block_size, block_size)
	display2 = display.newRect((j + the_pieces.piece2x) * board_offset + x_offset, (i + the_pieces.piece2y) * board_offset + y_offset, block_size, block_size)
	display3 = display.newRect((j + the_pieces.piece3x) * board_offset + x_offset, (i + the_pieces.piece3y) * board_offset + y_offset, block_size, block_size)
	display4 = display.newRect((j + the_pieces.piece4x) * board_offset + x_offset, (i + the_pieces.piece4y) * board_offset + y_offset, block_size, block_size)

	group:insert(display1)
	group:insert(display2)
	group:insert(display3)
	group:insert(display4)
	
	if use_ghostPiece and pause == false then
		ghostPiece()
	end
end

function drawNextPiece()
	if pause == true then
		return
	end
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
	
	local displayNext1 = display.newRect((j + the_pieces.piece1x) * board_offset + x_offset, (i + the_pieces.piece1y) * board_offset + y_offset , block_size, block_size)
	local displayNext2 = display.newRect((j + the_pieces.piece2x) * board_offset + x_offset, (i + the_pieces.piece2y) * board_offset + y_offset , block_size, block_size)
	local displayNext3 = display.newRect((j + the_pieces.piece3x) * board_offset + x_offset, (i + the_pieces.piece3y) * board_offset + y_offset , block_size, block_size)
	local displayNext4 = display.newRect((j + the_pieces.piece4x) * board_offset + x_offset, (i + the_pieces.piece4y) * board_offset + y_offset , block_size, block_size)
	
	nextPieceGroup:insert(displayNext1)
	nextPieceGroup:insert(displayNext2)
	nextPieceGroup:insert(displayNext3)
	nextPieceGroup:insert(displayNext4)
	
	
end

function updateScore(rows)
	if pause == true then
		return
	end
	scoreGroup:removeSelf()
	totalScore = totalScore + ( rows * 100)
	totalScoreCopy = totalScore + ( rows * 100)
	scoreGroup = display.newGroup()
	local scoreBox = display.newRect(display.contentWidth - 50 , (display.contentHeight/5) * 3 + 20, 50, 50)
	scoreBox:setFillColor(1,1,1)
	scoreGroup:insert(scoreBox)
	local text = display.newText(totalScore, display.contentWidth - 50, (display.contentHeight / 5) * 3 + 20, native.systemFontBold, 14)
	text:setFillColor(0,0,0)
	
	if totalScoreCopy / updatePieceNumber > 1 and totalScore % 100 then
		if update_number < 3 then
			return
		end
		
		level = level + 1
		--totalScoreCopy = totalScoreCopy % 1000
		

		if (level == 2) then 
			if update_number > 18 then
				update_number = update_number - 2
			end
			audio.stop()
			audio.dispose(sfx.level_one)
			audio.play(sfx.level_two, options)
			background:removeSelf()
			background = display.newImage("spring.png", display.contentWidth/2, display.contentHeight/2)
			background:toBack()
		elseif (level == 3) then
			if update_number > 16 then
				update_number = update_number - 2
			end
			audio.stop()
			audio.dispose(sfx.level_two)
			audio.play(sfx.level_three, options)
			background:removeSelf()
			background = display.newImage("summer.png", display.contentWidth/2, display.contentHeight/2)
			background:toBack()		
		elseif(level == 4) then
			if update_number > 14 then
				update_number = update_number - 2
			end
			audio.stop()
			audio.dispose(sfx.level_three)
			audio.play(sfx.level_four, options)
			background:removeSelf()
			background = display.newImage("fall.png", display.contentWidth/2, display.contentHeight/2)
			background:toBack()
			
--		else 
--			background:removeSelf()
--			background = display.newImage("winter.png", display.contentWidth/2, display.contentHeight/2)
--			background:toBack()
		end
		
		
	end
end

function createBoard()
	for i = 0, board_height do
	board[i] = {}
		for j = 0, board_width do
		board[i][j] = 0
		end
	end
end

function changeFill()
	if fillBoard then
		fillBoard = false
		fillImage:removeSelf()
		fillImage = display.newImage("off_button.png")
		fillImage.x = display.contentWidth/ 4 * 3
		fillImage.y = display.contentHeight / 6
		fillImage:scale(0.5, 0.5)
		fillImage:addEventListener("tap", changeFill)
	else 
		fillBoard = true
		fillImage:removeSelf()
		fillImage = display.newImage("on_button.png")
		fillImage.x = display.contentWidth/ 4 * 3
		fillImage.y = display.contentHeight / 6
		fillImage:scale(0.5, 0.5)
		fillImage:addEventListener("tap", changeFill)
	end
end

function soundEffect()
	if soundEffects then
		soundEffects = false
		soundEffectImage:removeSelf()
		soundEffectImage = display.newImage("off_button.png")
		soundEffectImage.x = display.contentWidth/4 * 3
		soundEffectImage.y = display.contentHeight/6 * 2
		soundEffectImage:scale(0.5, 0.5)
		soundEffectImage:addEventListener("tap", soundEffect)
	else
		soundEffects = true
		soundEffectImage:removeSelf()
		soundEffectImage = display.newImage("on_button.png")
		soundEffectImage.x = display.contentWidth/4 * 3
		soundEffectImage.y = display.contentHeight/6 * 2
		soundEffectImage:scale(0.5, 0.5)
		soundEffectImage:addEventListener("tap", soundEffect)
	end
end

function soundMusic()
	if music then
		music = false
		musicImage:removeSelf()
		musicImage = display.newImage("off_button.png")
		musicImage.x = display.contentWidth/4 * 3
		musicImage.y = display.contentHeight/6 * 3
		musicImage:scale(0.5, 0.5)
		musicImage:addEventListener("tap", soundMusic)
	else
		music = true
		musicImage = display.newImage("on_button.png")
		musicImage.x = display.contentWidth/4 * 3
		musicImage.y = display.contentHeight/6 * 3
		musicImage:scale(0.5, 0.5)
		musicImage:addEventListener("tap", soundMusic)
	end
end

function displayControl()
	if tapControl then
		tapControl = false
		controlImage:removeSelf()
		controlImage = display.newImage("off_button.png")
		controlImage.x = display.contentWidth/4 * 3
		controlImage.y = display.contentHeight/6 * 4
		controlImage:scale(0.5, 0.5)
		controlImage:addEventListener("tap", displayControl)
		
	else
		tapControl = true
		controlImage:removeSelf()
		controlImage = display.newImage("on_button.png")
		controlImage.x = display.contentWidth/4 * 3
		controlImage.y = display.contentHeight/6 * 4
		controlImage:scale(0.5, 0.5)
		controlImage:addEventListener("tap", displayControl)
	end

end

function addMenuScreen()
	menuScreen = display.newGroup()
	local mScreen = display.newImage("splash_other.png")
	mScreen:toBack()
	local startButton = display.newImage("start.png")
	startButton:scale( .5, .5)
	
	--local settingsText = display.newText(menuScreen, "Settings", display.contentWidth/2, display.contentHeight/4 * 3, native.systemFontBold, 14)
	local settingsButton = display.newImage("setting.png")
	settingsButton:scale(0.6, 0.6)
	
	settingsButton.x = display.contentWidth/4 * 3.25
	settingsButton.y = display.contentHeight/4 * 3.75
	
	--settingsText:setFillColor(255, 0, 0)
	--settingsText:toFront()
	settingsButton:addEventListener("tap", settingsScreen)
	
	mScreen.x = display.contentWidth/2 
	mScreen.y = display.contentHeight/2
	startButton.name = 'startB'
	menuScreen:insert(mScreen)
	startButton.x = display.contentWidth/4
	startButton.y = display.contentHeight/4 * 3.7
	menuScreen:insert(startButton)
	menuScreen:insert(settingsButton)
	--soundEffectText:addEventListener("tap", soundEffect)
	
	--controlText:addEventListener("tap", displayControl)
	--musicText:addEventListener("tap", soundMusic)
	--fillText:addEventListener("tap", changeFill)
	startButton:addEventListener('tap', tweenMS)
	if music then 
		audio.play(sfx.theme, options)
	end

end

function tweenMS:tap(e)
	if (e.target.name == 'startB') then
		transition.to(menuScreen, {time = 400, y = -menuScreen.height * 2, transition = easing.outExpo, onComplete = addGameScreen})
		audio.stop()
		create()
	end
end

function goAway()
	audio.stop()
	os.exit()
end

function recreate()
	gameOverGroup:removeSelf()
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
		no:addEventListener('tap', goAway)
		group:removeSelf()
		if nextPieceGroup ~= nil then
			nextPieceGroup:removeSelf()
		end
		scoreGroup:removeSelf()
		pieceLines:removeSelf()
		ghostGroup:removeSelf()
		line1:removeSelf()
		line2:removeSelf()
		pieceLines = display.newGroup()
		ghostGroup = display.newGroup()
		
		if totalScore > highScore.score1 then
			highScore.score1 = totalScore
			saveTable(highScore, "highScore.json")
			display.newText(gameOverGroup, "NEW HIGHSCORE!", display.contentWidth/2, display.contentHeight/2 + 30, native.systemFontBold, 16)
		end
		

		
		highScoreText = display.newText(gameOverGroup, "High Score: "..highScore.score1, display.contentWidth/5 * 2- 30, display.contentHeight/2, native.systemFontBold, 14)
		highScoreText:setFillColor(0,0,0)
		
		yourScoreText = display.newText(gameOverGroup, "Your Score: "..totalScore, display.contentWidth/5 * 4 - 35, display.contentHeight/2, native.systemFontBold, 14)
		yourScoreText:setFillColor(0,0,0)
		
		
		
	end
end

function createPiece()
	updateScore(0)
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
	balloon.myName = "Square"
	balloon.bodyType = "dynamic"
	balloon.x = 21 * 5
	balloon.y = -50
	
	currentPiece = balloon
	balloon.isFixedRotation = true
	index = index + 1
	if index > 6 then
		index = 0
	end
	drawNextPiece()
end

function updateBoard(the_pieces)
--will be called will freezeing piece
--will create new objects on board and then display.
--will be able to keep a reference to all "destroyed" pieces
--will check rows to see if deletion is necassary
	if pause == false then

		i = math.floor(currentPiece.y/board_offset)
		j = math.floor(currentPiece.x/board_offset)
		
		--well checks are actually working at the moment. 

		if i + the_pieces.piece1y > board_height or j + the_pieces.piece1x > board_width or j + the_pieces.piece1x < 0 or i + the_pieces.piece1y < 0 then
			pause = true
			fail()
			return
		else
			board[i + the_pieces.piece1y][j + the_pieces.piece1x] = display.newRect((j + the_pieces.piece1x)* board_offset + x_offset, (i + the_pieces.piece1y)*board_offset + y_offset, block_size, block_size)
			board[i + the_pieces.piece1y][j + the_pieces.piece1x]:setFillColor(math.random(low_color, high_color) / 100 ,math.random(low_color, high_color) / 100, math.random(low_color, high_color) / 100)
			group:insert(board[i + the_pieces.piece1y][j + the_pieces.piece1x])
			physics.addBody(board[i + the_pieces.piece1y][j + the_pieces.piece1x], "kinematic")
		end
		
		if i + the_pieces.piece2y > board_height or j + the_pieces.piece2x > board_width or j + the_pieces.piece2x < 0 or i + the_pieces.piece2y < 0 then
			pause = true
			fail()
			return
		else
			board[i + the_pieces.piece2y][j + the_pieces.piece2x] = display.newRect((j + the_pieces.piece2x)* board_offset + x_offset, (i + the_pieces.piece2y)*board_offset + y_offset, block_size, block_size)
			board[i + the_pieces.piece2y][j + the_pieces.piece2x]:setFillColor(math.random(low_color, high_color) / 100 ,math.random(low_color, high_color) / 100, math.random(low_color, high_color) / 100)
			group:insert(board[i + the_pieces.piece2y][j + the_pieces.piece2x])
			physics.addBody(board[i + the_pieces.piece2y][j + the_pieces.piece2x], "kinematic")
		end
		if i + the_pieces.piece3y > board_height or j + the_pieces.piece3x > board_width  or j + the_pieces.piece3x < 0 or i + the_pieces.piece3y < 0 then
			pause = true
			fail()
			return
		else
			board[i + the_pieces.piece3y][j + the_pieces.piece3x] = display.newRect((j + the_pieces.piece3x)*board_offset + x_offset, (i + the_pieces.piece3y)*board_offset + y_offset, block_size, block_size)
			board[i + the_pieces.piece3y][j + the_pieces.piece3x]:setFillColor(math.random(low_color, high_color) / 100 ,math.random(low_color, high_color) / 100, math.random(low_color, high_color) / 100)
			group:insert(board[i + the_pieces.piece3y][j + the_pieces.piece3x])
			physics.addBody(board[i + the_pieces.piece3y][j + the_pieces.piece3x], "kinematic")
		end
		if i + the_pieces.piece4y > board_height or j + the_pieces.piece4x > board_width  or j + the_pieces.piece4x < 0 or i + the_pieces.piece4y < 0 then
			pause = true
			fail()
			return
		else
			board[i + the_pieces.piece4y][j + the_pieces.piece4x] = display.newRect((j + the_pieces.piece4x)* board_offset + x_offset, (i + the_pieces.piece4y)* board_offset + y_offset, block_size, block_size)
			board[i + the_pieces.piece4y][j + the_pieces.piece4x]:setFillColor(math.random(low_color, high_color) / 100 ,math.random(low_color, high_color) / 100, math.random(low_color, high_color) / 100)
			group:insert(board[i + the_pieces.piece4y][j + the_pieces.piece4x])
			physics.addBody(board[i + the_pieces.piece4y][j + the_pieces.piece4x], "kinematic")
		end
		removeRows()
	end
end

function redraw()
	group:removeSelf()
	group = display.newGroup()
	for i = 0, board_height do
		for j = 0, board_width do
			if board[i][j] ~= 0 then
				board[i][j] = display.newRect((j * board_offset) + x_offset, (i * board_offset) + y_offset, block_size, block_size)
				board[i][j]:setFillColor(math.random(low_color, high_color) / 100 ,math.random(low_color, high_color) / 100, math.random(low_color, high_color) / 100)
				group:insert(board[i][j])
			end
		end
	end
end

function rowFall(inital_row) 
	for i = inital_row, 0, -1 do
		for j = 0, board_width do
			if board[i][j] ~= 0 then
				board[i + 1][j] = board[i][j]
				board[i][j] = 0
			end
		end
	end
	redraw()
end

function removeRows()
	rows = 0
	the_row = 0
	
	for i = 0, board_height do
		local boolean check = true
		for j = 0, board_width do
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
			for j = 0, board_width do
			 board[i][j]:removeSelf()
			 board[i][j] = 0
			end
			rowFall(the_row)
		end
	end
	updateScore(rows)
end

function checkTopRow()
	--if board == nil then
	--	return false
	--end
	local isPiece = false
	for j = 0, board_width do
		--if board[0][j] == nil then
		--	return false
		--end
		if board[0][j] ~= 0 then
		isPiece = true
		break
		end
	end
	return isPiece
end

function checkMove(dx, dy)
	if currentPiece == nil then
		return false
	end
	local can = false
	local piece1 = false
	local piece2 = false
	local piece3 = false
	local piece4 = false
	local piece = pieceRotation(currentPiece)
	x = math.floor(currentPiece.x/board_offset)
	y = math.floor(currentPiece.y/board_offset)
	if piece.piece1x + x + dx >= 0 and piece.piece1x + x + dx <= board_width then
		if piece.piece2x + x + dx >= 0 and piece.piece2x + x + dx <= board_width then
			if piece.piece3x + x + dx >= 0 and piece.piece3x + x + dx <= board_width then
				if piece.piece4x + x + dx >= 0 and piece.piece4x + x + dx <= board_width then
					if  piece.piece1y + y + dy >=  0 and piece.piece2y + y + dy >=  0 and piece.piece3y + y + dy >=  0 and piece.piece4y + y + dy >=  0 then
						if  piece.piece1y + y + dy <= board_height then
							piece1 = true
							if  piece.piece2y + y + dy <= board_height then
								piece2 = true
								if  piece.piece3y + y + dy <= board_height then
									piece3 = true
									if piece.piece4y + y + dy <= board_height then
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

function dropIndex()
	local index = 0
	for i = 1, 25 do
		local test = checkMove(0,i)
		if test then
			index = i
		else
			break
		end
	end
	return index
end

function ghostPiece()
	local index = dropIndex()
	local the_pieces = pieceRotation(currentPiece)
	
	local i = math.floor(currentPiece.y/height_offset)
	local j = math.floor(currentPiece.x/board_offset)
	
	ghost1 = display.newRect((j + the_pieces.piece1x) * board_offset + x_offset, (i + index + the_pieces.piece1y) * board_offset + y_offset, block_size, block_size)
	ghost2 = display.newRect((j + the_pieces.piece2x) * board_offset + x_offset, (i + index + the_pieces.piece2y) * board_offset + y_offset, block_size, block_size)
	ghost3 = display.newRect((j + the_pieces.piece3x) * board_offset + x_offset, (i + index + the_pieces.piece3y) * board_offset + y_offset, block_size, block_size)
	ghost4 = display.newRect((j + the_pieces.piece4x) * board_offset + x_offset, (i + index + the_pieces.piece4y) * board_offset + y_offset, block_size, block_size)
	
	ghost1:setFillColor(0, 0,1)
	ghost2:setFillColor(0, 0,1)
	ghost3:setFillColor(0, 0,1)
	ghost4:setFillColor(0, 0,1)
	
	ghost1.alpha = .4
	ghost2.alpha = .4
	ghost3.alpha = .4
	ghost4.alpha = .4
	
	
	if ghostGroup ~= nil then
		ghostGroup:removeSelf()
	end
	ghostGroup = display.newGroup()
	
	ghostGroup:insert(ghost1)
	ghostGroup:insert(ghost2)
	ghostGroup:insert(ghost3)
	ghostGroup:insert(ghost4)
	
end

function dropPiece()
	local index = dropIndex()
	currentPiece.y = currentPiece.y + (index * height_offset)
end

function freezePiece(freezeEvent)
	if pieceCreate == true then
		if soundEffects then
			audio.play(click)
		end
		local pieces = pieceRotation(currentPiece)
		--physics.removeBody(currentPiece)
		physics.addBody(currentPiece, "static")
		currentPiece.myName = "death"
		pieceCreate = false
		randomizeColor()
		updateBoard(pieces)
		currentPiece:removeSelf()
		createPiece()
	end
end

function movePiece(moveEvent)
	update = update + 1
	if update % update_number == 0  and pause == false then
		if checkMove(0,1) then
			currentPiece.y = currentPiece.y + board_offset
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
	if currentPiece == nil then
		return
	end
	--if canRotate == false then
	--	canRotate = true
	--	return
	--else 
	--	canRotate = false
	--end
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
	drawPiece(pieceRotation(currentPiece))
end

function moveLeft()
	if currentPiece == nil then
		return
	end
	if checkMove(-1, 0) then
		currentPiece.x = currentPiece.x - board_offset
	end
	drawPiece(pieceRotation(currentPiece))
end

function moveRight()
	if currentPiece == nil then
		return
	end
	if checkMove(1,0) then
		currentPiece.x = currentPiece.x + board_offset
	end
	drawPiece(pieceRotation(currentPiece))
end

function moveLeftGlobal(e) 
	if (pause) then 
		return
	elseif (e.x < 235/2) and checkMove(-1, 0)  then
		currentPiece.x = currentPiece.x - 21
	end
	drawPiece(pieceRotation(currentPiece))
	
end

function moveRightGlobal(e) 
	if (pause) then 
		return
	elseif (e.x > 235/2) and (e.x < 235) and checkMove(1, 0) then  
		currentPiece.x = currentPiece.x + 21
	end
	drawPiece(pieceRotation(currentPiece))
end

function dropPieceMotion(e)
	--local endY
	--if (e.phase == "ended") then
	--	endY = e.y
	--end
	if (pause) then
		return
	elseif (e.yStart < e.y) and (e.phase == "ended") then
		dropPiece()
	end
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

function fillBoard()
	for number = 0, 10 do
		i = math.random(13, 23)
		j = math.random(0, 10)
		board[i][j] = display.newRect((j * board_offset) + x_offset, (i * board_offset) + y_offset, block_size, block_size)
		board[i][j]:setFillColor(math.random(low_color, high_color) / 100, math.random(low_color, high_color) / 100,math.random(low_color, high_color) / 100)
		group:insert(board[i][j])
	end
end
 
function create()
	start_over = true
	pause = false
	
	nextPieceGroup = display.newGroup()
	scoreGroup = display.newGroup()
	
	display1 = display.newRect(0,0,0,0)
	display2 = display.newRect(0,0,0,0)
	display3 = display.newRect(0,0,0,0)
	display4 = display.newRect(0,0,0,0)

	group = display.newGroup()
	extra_group = display.newGroup()
	createBoard()
	
	if fillBoard then
		fillBoard()
	end
	
	local physics = require("physics")
	--physics.setDrawMode("hybrid")
	physics.start()
	physics.setGravity(0, 0)
	
	if tapControl == false then
		local leftB = display.newImage("left_button.png")
		leftB.x = display.contentWidth - 50
		leftB.y = display.contentHeight / 8 - 25
		leftB:scale(0.6, 0.6)
		leftB:addEventListener("tap", moveLeft)

		local rightB = display.newImage("right_button.png")
		rightB.x = display.contentWidth - 50
		rightB.y = display.contentHeight / 4 -20
		rightB:scale(0.6, 0.6)
		rightB:addEventListener("tap", moveRight)
	
		extra_group:insert(leftB)
		extra_group:insert(rightB)
		
	else
		Runtime:addEventListener("tap", moveLeftGlobal)
		Runtime:addEventListener("tap", moveRightGlobal)
		
	end
	Runtime:addEventListener("touch", dropPieceMotion)
	--Runtime:addEventListener("touch", dropPiece)

	local rotateB = display.newImage("rotate.png")
	rotateB.x = display.contentWidth - 50
	rotateB.y = display.contentHeight /3 + 10
	rotateB:scale(0.6, 0.6)
	rotateB:addEventListener("tap", rotate) --switch to tap
	
	local pauseB = display.newImage("pause.png")
	pauseB.x = display.contentWidth - 50
	pauseB.y = (display.contentHeight / 5 )* 2 + 45
	pauseB:scale(0.5, 0.5)
	
	pauseB:addEventListener("tap", pauseGame)
	
	extra_group:insert(rotateB)
	extra_group:insert(pauseB)

	createPiece()

	local floor = display.newImage("base.png")
	floor.x = display.contentWidth/2
	floor.y = display.contentHeight + 43
	physics.addBody(floor, "static")
	floor.myName = "Floor"

	local leftWall = display.newRect(0,0,1, display.contentHeight*2 + 50)
	local rightWall = display.newRect(235, 0, 5, display.contentHeight*2 + 52)
	leftWall.myName = "leftWall"
	rightWall.myName = "rightWall"

	physics.addBody(leftWall, "static", {bounce = 0.1, friction = 1.0})
	physics.addBody(rightWall, "static", {bounce = 0.1, friction = 1.0})

	display.setStatusBar(display.HiddenStatusBar)
	
	extra_group:insert(floor)
	extra_group:insert(leftWall)
	extra_group:insert(rightWall)

	Runtime:addEventListener("enterFrame", movePiece)
	
	background = display.newImage("winter.png", display.contentWidth/2, display.contentHeight/2)
	background:toBack();
	

	if music then
		audio.play(sfx.level_one, options)
	end
	--timer.performWithDelay(1000,fail, 1)
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
			locations["piece1x"] = -1
			locations["piece1y"] = 0
			locations["piece2x"] = 0
			locations["piece2y"] = 0
			locations["piece3x"] = -1
			locations["piece3y"] = 1
			locations["piece4x"] = -2
			locations["piece4y"] = 1
		elseif currentPiece.rotation == 90 then
			locations["piece1x"] = -1
			locations["piece1y"] = -1
			locations["piece2x"] = -1
			locations["piece2y"] = 0
			locations["piece3x"] = 0
			locations["piece3y"] = 0
			locations["piece4x"] = 0
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

addMenuScreen()

--need to potentaily fix error on check move
--potentially implement breakout.