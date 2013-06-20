class (exports ? @).Sneaky

  # -----------------
  #    2D Geometry
  # -----------------

  class Vector
    constructor: (@x, @y) ->

  # -----------------
  #      Actors
  # -----------------
  #
  # Each frame:
  #   1) A list of collisions is compiled for every actor.
  #   2) Each of those collision callbacks is called in the order they were set.
  #      You can move actors around in their callbacks and the other collisions
  #      will still safely trigger. Callbacks are passed two vectors.
  #   3) Every actor is drawn.
  #   4) Any key events that occured during the last frame are processed in the
  #      order they arrived.
  #   5) Gravity modifies the velocity.
  #   6) The velocity modifies the position.

  @Actor: class Actor
    constructor: (@position) ->

    position: Vector(0, 0)

    velocity: Vector(0, 0)

    gravity: Vector(0, 0)

    onHit: (classOrInstance, callback) ->
      @collisionCallbacks.push
        classOrInstance: classOrInstance
        callback: callback

  # -----------------
  #     Key Codes
  # -----------------

  @BACKSPACE: 8
  @TAB: 9
  @ENTER: 13
  @SHIFT: 16
  @CTRL: 17
  @ALT: 18
  @PAUSE_BREAK: 19
  @CAPS_LOCK: 20
  @ESC: 27
  @SPACE: ' '
  @PAGE_UP: 33
  @PAGE_DOWN: 34
  @END: 35
  @HOME: 36
  @LEFT: 37
  @UP: 38
  @RIGHT: 39
  @DOWN: 40

###
  constructor (@width, @height): ->

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

    ###
