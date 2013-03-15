function createNPC(y, x, NPC) --Places NCPs acording to their id: 1-Trader 2-Warrior 3-Wizard
	local i = {}
	i.pic = love.graphics.newImage("textures/Enemy1.png")
	i.x = x
	i.y = y
	i.velocity = 640
	i.vx = 0
	i.vy = 0
	i.h = 32
	i.w = 32
	i.health = 10
	i.moveTimer = 0
	table.insert(NPC, i)
end

function NPCmove(v, dt, map)
	local move = math.random(0, 3)
	
	if move == 0 then
		v.vy = -v.velocity
	elseif move == 1 then
		v.vy = v.velocity
	else 
		v.vy = 0
	end
	if move == 2 then
		v.vx = -v.velocity
	elseif move == 3 then
		v.vx = v.velocity
	else
		v.vx = 0
	end
	
	-- move horizontally first
	v.x  = v.x + v.vx*dt
	v.x  = map:resolveXdirection(v,v.x,v.y,v.w,v.h)
	
	-- apply vertical movement
	v.y  = v.y + dt*v.vy
	v.y  = map:resolveYdirection(v,v.x,v.y,v.w,v.h)
end

function NPCpush(v, dt, map, move, player)
	if move == 0 then
		v.vy = -v.velocity * 3
		player.vy = player.velocity / 2
	elseif move == 1 then
		v.vy = v.velocity * 3
		player.vy = -player.velocity / 2
	else 
		v.vy = 0
		player.vy = 0
	end
	if move == 2 then
		v.vx = -v.velocity * 3
		player.vx = player.velocity / 2
	elseif move == 3 then
		v.vx = v.velocity * 3
		player.vx = -player.velocity / 2
	else
		v.vx = 0
		player.vx = 0
	end
	
	-- move horizontally first
	v.x  = v.x + v.vx*dt
	v.x  = map:resolveXdirection(v,v.x,v.y,v.w,v.h)
	
	-- apply vertical movement
	v.y  = v.y + dt*v.vy
	v.y  = map:resolveYdirection(v,v.x,v.y,v.w,v.h)
	
	leftSideGX,_,rightSideGX = map:getRange(player.x,player.y,player.w,player.h)
	player:update(dt,map)
end

function NPCscan(map)
	for y,row in pairs(map.grid) do
		for x,id in pairs(row) do
			local x,y = (x-1)*32,(y-1)*32
			
			if id == 6 then
				createNPC(y, x, NPC)
			end
		end
	end
end