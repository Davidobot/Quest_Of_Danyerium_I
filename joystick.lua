joyNum = 1

function joystickLoad()
	open = love.joystick.open( joyNum )
end

function joystickUpdate(dt)
	-- Axis 2 = Left Analog Stick
	-- Axis 5 = Right Analog Stick
	
	--D-pad Left - l
	--		Right - r
	--		Up - u
	--		Down - d
	--		Nothing - c
	
	directionD = love.joystick.getHat( joyNum, 1 ) -- D-pad
	directionAnLLR = love.joystick.getAxis( joyNum, 1 ) -- Analog Sticks
	directionAnLUD = love.joystick.getAxis( joyNum, 2 ) -- Analog Sticks
	directionAnR = love.joystick.getAxis( joyNum, 5 ) -- Analog Sticks
	
	if directionAnLLR == -1 then
		player.vx = -player.velocity
	elseif directionAnLLR == 1 then
		player.vx = player.velocity
	else 
		player.vx = 0 
	end
	if directionAnLUD == -1 then
		player.vy = -player.velocity
	elseif directionAnLUD == 1 then
		player.vy = player.velocity
	else
		player.vy = 0
	end
end

function joystickKeyPressed(button)
end