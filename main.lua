require 'menu'
require 'options'
require 'intro'
require 'complete'
require 'preTextures'
require 'joystick'

require 'libs/items'
require 'libs/inventory'
require ('libs/camera')
anim8 = require 'libs/anim8'

arc_path = 'arc/'
require(arc_path .. 'arc')
_navi = require(arc_path .. 'navi')

require 'Game/enemy'
require 'Game/NPC'
require 'Game/game'

function love.load()
	-- Loads Everything
	preTextures()
	joystickLoad()
	introLoad()
	menuLoad()
	optionsLoad()
	gameLoad()

	gamestate = 1
end

function love.update(dt)
	if gamestate == 0 then
		introUpdate(dt)
	end
	
	if gamestate == 1 then
		menuUpdate(dt)
	end
	
	if gamestate == 2 then
		optionsUpdate(dt)
	end
	
	if gamestate == 3 then
		gameUpdate(dt)
	end
end

function love.draw()
	if gamestate == 0 then
		introDraw()
	end
	
	if gamestate == 1 then
		menuDraw()
	end
	
	if gamestate == 2 then
		optionsDraw()
	end
	
	if gamestate == 3 then
		gameDraw()
	end
end

function love.keypressed(key)
	if gamestate == 0 then
		introKeyPressed(key)
	end
	
	if gamestate == 1 then
		menuKeyPressed(key)
	end
	
	if gamestate == 2 then
		optionsKeyPressed(key)
	end
	
	if gamestate == 3 then
		gameKeyPressed(key)
	end
end

function love.joystickpressed( joystick, button)
	-- X - 1
	-- O -2
	-- [] - 3 
	-- ^ - 4
	
	if gamestate == 3 then
		joystickKeyPressed(button)
	end
end