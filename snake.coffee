$ = jQuery
$canvas = document.getElementById 'snake-game'
context = $canvas.getContext "2d"

gridSize = 20
numColumns = 30
numRows= 25

snake = []

applePos = 
	x: 10
	y: 10

dx = 1
dy = 0

score = 0

gameState = "inprogress"

$(document).keydown (evt) ->
	if gameState == "dead" and evt.keyCode == 32
		initGame()
		return

	if evt.keyCode == 40 and dy == 0 
		dy = 1 
		dx = 0 #Down
	else if evt.keyCode == 38 and dy == 0
		dy = -1 
		dx = 0 #Up
	else if evt.keyCode == 37 and dx == 0
		dx = -1
		dy = 0 #left
	else if evt.keyCode == 39 and dx == 0
		dx = 1
		dy = 0 #right

initGame = ->
	dx = 1
	dy = 0
	snake = [
		{ x: 5, y: 5 }
		{ x: 6, y: 5 }
		{ x: 7, y: 5 }
	]
	positionApple snake
	gameState = "inprogress"
	score = 0
	updateScore 0

gameBoardWidth = ->
	numColumns * gridSize

clearBackground = (ctx) -> 
	ctx.fillStyle = "#333333"
	ctx.fillRect(0, 0, gameBoardWidth(), 500);
 
gridPosToCanvasPos = (pos) -> pos * gridSize

drawSnake = (ctx, snake) ->
	context.fillStyle = '#FFFFFF'
	for pos in snake
		context.fillRect gridPosToCanvasPos(pos.x) + 1, gridPosToCanvasPos(pos.y) + 1, gridSize - 2, gridSize - 2

	null #don't return anything

generateNewRandomPosition = ->
	newPos = 
		x: Math.floor Math.random() * numColumns
		y: Math.floor Math.random() * numRows
	newPos

positionApple = (snake) ->
	pos = generateNewRandomPosition()
	while(positionCollidesWithSnake pos, snake)
		pos = generateNewRandomPosition()

	applePos = pos

positionCollidesWithSnake = (pos, snake) ->
	for snakePos in snake
		if pos.x == snakePos.x && pos.y == snakePos.y
			return true

	return false;

updateScore = (points) ->
	score += points
	$('#score').html score

moveSnake = (snake) -> 
	snakeHead=
		x: snake[snake.length - 1].x + dx
		y: snake[snake.length - 1].y + dy

	snakeIsDead = positionCollidesWithSnake snakeHead, snake

	if snakeHead.x < 0 or snakeHead.x >= numColumns
		snakeIsDead = true
	else if snakeHead.y < 0 or snakeHead.y >= numRows
		snakeIsDead = true
	else
		snake.push snakeHead

	if snakeHead.x == applePos.x and snakeHead.y == applePos.y
		positionApple snake
		updateScore 25
	else if snakeIsDead
		gameState = "dead"
	else
		snake.shift()

	null

drawApple = (ctx) ->
	context.fillStyle = '#00AA00'
	context.fillRect gridPosToCanvasPos(applePos.x) + 1, gridPosToCanvasPos(applePos.y) + 1, gridSize - 2, gridSize - 2	

drawDeadScreen = (ctx) ->
	ctx.fillStyle = '#AA0000'
	ctx.font = "36px Helvetica"
	deadMessage = "You killed the snake!"
	ctx.fillText deadMessage, gameBoardWidth() / 2 - ctx.measureText(deadMessage).width / 2, 150

	ctx.font = "18px Helvetica"
	restartMessage = "Press space to restart"
	ctx.fillText restartMessage, gameBoardWidth() / 2 - ctx.measureText(restartMessage).width / 2, 180

tick = ->
	clearBackground context
	drawApple()
	drawSnake context, snake

	if gameState == "inprogress"
		moveSnake snake
	else if gameState == "dead"
		drawDeadScreen context

initGame()
setInterval ->
	tick()
, 150	