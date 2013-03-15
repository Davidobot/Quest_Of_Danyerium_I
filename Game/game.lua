--[[
Controls:
Arrows Keys - Move
Tab - Display Inventory
W (While in inventory) - Move selection block up
S (While in inventory) - Move selection block down
Enter (Without anything selected) - Select an item
Enter (With something selected) - Swap out highlighted item for selected item
Z (While is inventory) - Delete highlighted item
X (While in inventory) - Delete all items
--]]

map     	= require 'class.map'
WorldMap    = require 'maps/mainWorld'
entity  	= require 'class.entity'

House1      = require 'maps/playerHouse'

CurMap      = WorldMap

player = require 'Game/player'

require 'Game/setCallbacks'

function gameLoad()
	width = love.graphics.getWidth()
    height = love.graphics.getHeight()
	
	block = {}
	block[1] = _navi:new('This |c{mblue}noise|c{white} in your head was created when you fell into this god-damn bush and hurt your head.|! I will not be taking you to the doctor after this.',{face = face_1, face_border = true, name = "Your Fairy", wbox = 256, hbox = 128})
	
	playVoice = 0
	
	setCallBacksWorld(WorldMap, player)
	setCallBacksHouse1(House1, player)
	
	item_highlighted = 1
	
	local grid_l = anim8.newGrid(32, 32, player.imgL:getWidth(), player.imgL:getHeight())
	local grid_r = anim8.newGrid(32, 32, player.imgR:getWidth(), player.imgR:getHeight())
	local grid_f = anim8.newGrid(32, 32, player.imgF:getWidth(), player.imgF:getHeight())
	local grid_b = anim8.newGrid(32, 32, player.imgB:getWidth(), player.imgB:getHeight())
   
	pWalkL = anim8.newAnimation('loop', grid_l('1-2,1'), 0.1)
	pWalkR = anim8.newAnimation('loop', grid_r('1-2,1'), 0.1)
	pWalkF = anim8.newAnimation('loop', grid_f('1-2,1'), 0.1)
	pWalkB = anim8.newAnimation('loop', grid_b('1-2,1'), 0.1)
	
	local grid_l_hit = anim8.newGrid(32, 32, player.imgL_hit:getWidth(), player.imgL_hit:getHeight())
	local grid_r_hit = anim8.newGrid(32, 32, player.imgR_hit:getWidth(), player.imgR_hit:getHeight())
	local grid_f_hit = anim8.newGrid(32, 32, player.imgF_hit:getWidth(), player.imgF_hit:getHeight())
	local grid_b_hit = anim8.newGrid(32, 32, player.imgB_hit:getWidth(), player.imgB_hit:getHeight())
	
	pWalkL_hit = anim8.newAnimation('loop', grid_l_hit('1-2,1'), 0.2)
	pWalkR_hit = anim8.newAnimation('loop', grid_r_hit('1-2,1'), 0.2)
	pWalkF_hit = anim8.newAnimation('loop', grid_f_hit('1-2,1'), 0.2)
	pWalkB_hit = anim8.newAnimation('loop', grid_b_hit('1-2,1'), 0.2)
	
	NPC = {}
	NPCscan(WorldMap)
	delNPC = {}
	
	camera:setBounds(0, 0, (CurMap.width * CurMap.tilewidth) - 800, (CurMap.height * CurMap.tileheight) - 600)
	
	globalDT = 1
	setx = 0
	sety = 0
	
	hitMax  = 6
	hitStat = 0
	
	--Particles
	mx = 0
	my = 0
	
	particle_display_time=0.1
  	dtotal=particle_display_time
	i = love.graphics.newImage("textures/particle.png")

	particle = love.graphics.newParticleSystem(i, 256)
	

	particle:setEmissionRate          (20)
	particle:setLifetime              (0.1)
	particle:setParticleLife          (1)
	particle:setPosition              (0, 0)
	particle:setDirection             (0)
	particle:setSpread                (20)
	particle:setSpeed                 (100, 200)
	particle:setGravity               (100)
	particle:setRadialAcceleration    (10)
	particle:setTangentialAcceleration(0)
	particle:setSizes                 (3)
	particle:setSizeVariation         (5.7)
	particle:setRotation              (0)
	particle:setSpin                  (0)
	particle:setSpinVariation         (0)
	particle:setColors               (20, 20, 25, 240, 155, 155, 155, 10)
	particle:stop();
end

function gameKeyPressed(key)
	arc.set_key(key)
	if love.keyboard.isDown("tab") then
		if key == "w" then
			if item_highlighted > 1 then
				item_highlighted = item_highlighted - 1
			end
		elseif key == "s" then
			if item_highlighted < MAX_INVENTORY then
				item_highlighted = item_highlighted + 1
			end
		elseif key == "return" then
			if item_selected then
				inventory:swap( item_selected, item_highlighted )
				item_selected = nil
			else
				item_selected = item_highlighted
			end
		end
	end
	
	if key == "up" then
		player.direction = 0
	elseif key == "down" then
		player.direction = 1
	elseif key == "left" then
		player.direction = 2
	elseif key == "right" then
		player.direction = 3
	end
	
	if key == "z" and CurMap == WorldMap then
		pWalkL_hit:gotoFrame(1)
		pWalkR_hit:gotoFrame(1)
		pWalkF_hit:gotoFrame(1)
		pWalkB_hit:gotoFrame(1)
		hitStat = 0
		local inv1 = inventory:get(1)
		local inv2 = inventory:get(2)
		
		for i,v in ipairs(NPC) do
			if player.x + 32 > v.x - 8 and player.x < v.x + 32 + 8 and player.y + 32 > v.y - 8 and player.y < v.y + 32 + 8 then
				if (player.x < v.x and player.direction == 3) or (player.x > v.x and player.direction == 2) or (player.y < v.y and player.direction == 1) or (player.y > v.y and player.direction == 0) then
					if inv1 == nil then
					elseif inv2 == nil then
					else
						local plStrong1 = math.random(inv1.minSharp, inv1.maxSharp)
					
						v.health = v.health - plStrong1
						
						mx = v.x + 16
						my = v.y + 16
					
						if player.direction == 0 then
							dtotal=0
							NPCpush(v, globalDT, WorldMap, 0, player)
						elseif player.direction == 1 then
							dtotal=0
							NPCpush(v, globalDT, WorldMap, 1, player)
						elseif player.direction == 2 then
							dtotal=0
							NPCpush(v, globalDT, WorldMap, 2, player)
						elseif player.direction == 3 then
							dtotal=0
							NPCpush(v, globalDT, WorldMap, 3, player)
						end
					end
				end
			end
		end
	end
end

function gameUpdate(dt)
	arc.check_keys(dt)
	if dt > 1/60 then dt = 1/60 end
	
	globalDT = dt
	
	joystickUpdate(dt)
	
	if love.keyboard.isDown('left') then
		player.vx = -player.velocity
	elseif love.keyboard.isDown('right') then
		player.vx = player.velocity
	else 
		player.vx = 0 
	end
	if love.keyboard.isDown('up') then
		player.vy = -player.velocity
	elseif love.keyboard.isDown('down') then
		player.vy = player.velocity
	else
		player.vy = 0
	end
	
	pWalkB:update(dt)
	pWalkF:update(dt)
	pWalkL:update(dt)
	pWalkR:update(dt)
	
	pWalkB_hit:update(dt)
	pWalkF_hit:update(dt)
	pWalkL_hit:update(dt)
	pWalkR_hit:update(dt)
	
	if setx > 0 and sety > 0 then
		player.x = setx
		player.y = sety
		setx = 0
		sety = 0
		camera:setPosition(player.x - width / 2, player.y - height / 2)
		camera:setBounds(0, 0, (CurMap.width * CurMap.tilewidth) - 800, (CurMap.height * CurMap.tileheight) - 600)
	end
	
	leftSideGX,_,rightSideGX = CurMap:getRange(player.x,player.y,player.w,player.h)
	player:update(dt,CurMap)
	
	if CurMap == WorldMap then
		for i,v in ipairs(NPC) do
			if v and (v.x < player.x + 400 or v.x > player.x - 400) and (v.y > player.y - 300 or v.y < player.y + 300) then
				v.moveTimer = v.moveTimer + 1
				if v.health < 0 or v.health == 0 then
					keyZ = 1
					table.insert(delNPC, i)
				end
			
				if v.moveTimer == 20 then
					NPCmove(v, dt, WorldMap)
					v.moveTimer = 0
				end
			end
		end
	end
	
	delEnemy()
	
	--Particles
	dtotal = dtotal + dt   -- we add the time passed since the last update, probably a very small number like 0.01
	if dtotal <= particle_display_time then
		--update particle
		particle:start();	
	end	
	particle:update(dt);
	
	--Camera
	
	camera:setPosition(player.x - width / 2, player.y - height / 2)
	if keyZ == 1 then
		camera:setPosition(player.x - width / 2 - 5, player.y - height / 2 - 5)
		keyZ = 0
	end
end

function gameDraw()
	camera:set()
	
	CurMap:draw()
	
	if love.keyboard.isDown("up") then
		pWalkB:draw(player.imgB, player.x, player.y)
		player.direction = 0
	elseif love.keyboard.isDown("down") then
		pWalkF:draw(player.imgF, player.x, player.y)
		player.direction = 1
	elseif love.keyboard.isDown("left") then
		pWalkL:draw(player.imgL, player.x, player.y)
		player.direction = 2
	elseif love.keyboard.isDown("right") then
		pWalkR:draw(player.imgR, player.x, player.y)
		player.direction = 3
	else
		
		if player.direction == 0 then
			pWalkB:gotoFrame(1)
			pWalkB:draw(player.imgB, player.x, player.y)
		elseif player.direction == 1 then
			pWalkF:gotoFrame(1)
			pWalkF:draw(player.imgF, player.x, player.y)
		elseif player.direction == 2 then
			pWalkL:gotoFrame(1)
			pWalkL:draw(player.imgL, player.x, player.y)
		elseif player.direction == 3 then
			pWalkR:gotoFrame(1)
			pWalkR:draw(player.imgR, player.x, player.y)
		end
		
	end
	
		
	if love.keyboard.isDown("z") and player.direction == 0 then
		if hitStat < hitMax then
			pWalkF_hit:draw(player.imgB_hit, player.x, player.y - 28)
			hitStat = hitStat + 1
		end
	elseif love.keyboard.isDown("z") and player.direction == 1 then
		if hitStat < hitMax then
			pWalkB_hit:draw(player.imgF_hit, player.x, player.y + 32)
			hitStat = hitStat + 1
		end
	elseif love.keyboard.isDown("z") and player.direction == 2 then
		if hitStat < hitMax then
			pWalkL_hit:draw(player.imgL_hit, player.x - 32, player.y)
			hitStat = hitStat + 1
		end
	elseif love.keyboard.isDown("z") and player.direction == 3 then
		if hitStat < hitMax then
			pWalkR_hit:draw(player.imgR_hit, player.x + 32, player.y)
			hitStat = hitStat + 1
		end
	end
	
	if CurMap == WorldMap then
		for i,v in ipairs(NPC) do
			if v then
				love.graphics.draw(v.pic, v.x, v.y)
			end
		end

		local whiteColor  = {255,255,255}
	
		for y,row in pairs(WorldMap.grid) do
			for x,id in pairs(row) do
				love.graphics.setColor(WorldMap.tileset[id].color or whiteColor)

				local x,y = (x-1)*32,(y-1)*32
				if id == 13 then
					love.graphics.draw(WorldMap.tileset[id].img,x,y)
				end
			end
		end
	end
	
	--draw particle
	love.graphics.push()
	love.graphics.translate(mx, my)
	love.graphics.draw(particle, 0, 0)
	love.graphics.pop()
	
	camera:unset()
	
	love.graphics.draw(guiInfo, 0, height - 32) 
	
	if love.keyboard.isDown("tab") then
		love.graphics.setColor( 255, 255, 255 )
		love.graphics.draw(guiInv, 0, 0)
		for i = 1, MAX_INVENTORY do
			local item = inventory:get(i)
			
			if item then
				love.graphics.setColor( 0, 0, 0 )
				love.graphics.print( item.desc, 16 + 32 + 4, (10 + 32)*(i-1) + 8 + 8 )
				love.graphics.setColor( 255, 255, 255 )
				love.graphics.draw( item.img, 8, (10 + 32)*(i-1) + 8 )
			end
		end
		if item_selected then
			love.graphics.setColor( 255, 0, 0 )
			love.graphics.rectangle( "line", 8, (10 + 32)*(item_selected-1) + 8, 32, 32 )
		end
		love.graphics.setColor( 0, 255, 0 )
		love.graphics.rectangle( "line", 8, (10 + 32)*(item_highlighted-1) + 8, 32, 32 )
	end
	
	
	--Chat
	if playVoice > 0 then
		if playVoice == 1 then
			block[1]:play(0,0)
			if block[1]:is_over() then
				playVoice = 0
			end
		end
	end
	
	arc.clear_key()
end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end

function math.dist(x1,y1, x2,y2) 
	return ((x2-x1)^2+(y2-y1)^2)^0.5 
end