function menuLoad()
	menu_bg = love.graphics.newImage("textures/bgMenu.png")
	button = love.graphics.newImage("textures/button.png")
		
	vc1 = 255
	vc2 = 255
	vc3 = 255
	selected = 1
end

function menuUpdate(dt)
	if selected == 1 then
       	vc1 = 0
		vc2 = 255
	elseif selected == 2 then
		vc2 = 0
		vc1 = 255
	end
end

function menuDraw()
	love.graphics.draw(menu_bg,0,0)
	
	love.graphics.setColor(255, 255, vc1)--variable colour 1
	love.graphics.draw(button, 399 - (168 / 2), 250)--button1
	love.graphics.print("PLAY", 420, 260)--text1
	
	love.graphics.setColor(255, 255, vc2)--variable colour 2
	love.graphics.draw(button, 399 - (168 / 2), 330)--button2
	love.graphics.print("QUIT", 420, 340)--text2
	
	love.graphics.setColor(255, 255, 255)
end

function menuKeyPressed( key )
	if selected == 2 and key == "up" then
		selected = 1
	elseif selected == 1 and key == "down" then
		selected = 2
	end
	
	if key == "return" and selected == 1 then
		gamestate = 3
	elseif key == "return" and selected == 2 then
		return love.event.push("quit") or love.event.push("q")
	end
end