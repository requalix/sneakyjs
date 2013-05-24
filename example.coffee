class Dude extends Sneaky.Actor

  SPEED: 4
  JUMP_SPEED: 8

  constructor: (left, right, jump, splash) ->
    Sneaky.keydown left, -> @velocity.x = -SPEED
    Sneaky.keydown right, -> @velocity.x = +SPEED
    Sneaky.keydown jump, -> @velocity.y = +JUMP_SPEED


class (exports ? @).Example extends Sneaky.Game

  constructor: (@width, @height) ->

  # Key Codes
  UP: 38
  DOWN: 40
  ESC: 27
  SPACE: 32

  _ctx = null
  WIDTH = null
  HEIGHT = null

viewportX = 0
viewportY = 0
viewportWidth = 1
viewportHeight = 1

translate = (x, y) ->
  [(x - viewportX) * WIDTH / viewportWidth,
   (y - viewportY) * HEIGHT / viewportHeight]

root.sglInit = ->
  ctx = $("#game")[0].getContext("2d")
  viewportWidth = WIDTH = $("#game").width()
  viewportHeight = HEIGHT = $("#game").height()

root.drawCircle = (x, y, radius, fillStyle) ->
  [x, y] = translate x, y
  ctx.fillStyle = fillStyle if fillStyle
  ctx.beginPath()
  ctx.arc x, y, radius / viewportWidth * WIDTH, 0, Math.PI*2, true
  ctx.closePath()
  ctx.fill()

root.drawRect = (x, y, width, height, fillStyle) ->
  [x, y] = translate x, y
  ctx.fillStyle = fillStyle if fillStyle
  ctx.beginPath()
  ctx.rect x, y, width * WIDTH / viewportWidth, height * HEIGHT / viewportHeight
  ctx.closePath()
  ctx.fill()

root.drawLine = (x1, y1, x2, y2, strokeStyle) ->
  [x1, y1] = translate x1, y1
  [x2, y2] = translate x2, y2
  ctx.strokeStyle = strokeStyle if strokeStyle
  ctx.beginPath()
  ctx.moveTo(x1, y1)
  ctx.lineTo(x2, y2)
  ctx.stroke()

root.setViewport = (x, y, width = viewportWidth, height = viewportHeight) ->
  viewportWidth = width
  viewportHeight = height
  viewportX = x
  viewportY = y

isDown = {}
keyDownCallbacks = {}
keyUpCallbacks = {}

root.registerKeyDown = (keyCode, callback) ->
  keyDownCallbacks[keyCode] ?= []
  keyDownCallbacks[keyCode].push callback

root.registerKeyUp = (keyCode, callback) ->
  keyUpCallbacks[keyCode] ?= []
  keyUpCallbacks[keyCode].push callback

$(document).keydown (event) =>
  if not isDown[event.keyCode]
    isDown[event.keyCode] = true
    for callback in keyDownCallbacks[event.keyCode] ? []
      callback()

$(document).keyup (event) ->
  isDown[event.keyCode] = false
  for callback in keyUpCallbacks[event.keyCode] ? []
    callback()

root.startGame = (fn) ->
  draw = () ->
    ctx.clearRect 0, 0, WIDTH, HEIGHT
    fn()
  setInterval(draw, 10) # ~ 100 fps
