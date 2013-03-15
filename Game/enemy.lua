function makeEnemy()
	local enemy = {}
	enemy.x = 256
	enemy.y = 256
	enemy.pic  = love.graphics.newImage("textures/Char.png") --Original Pic
	enemy.pic2 = love.graphics.newImage("textures/Enemy1.png") --Pic when getting hurt
	enemy.w = 32
	enemy.h = 32
	
	enemy.health = 10
	
	table.insert(NPC, enemy)
end

function delEnemy()
	for i,v in ipairs(delNPC) do
        table.remove(NPC, v)
    end
	
    delNPC = {}
end
