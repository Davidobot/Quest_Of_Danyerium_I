require 'libs/items'

inventory = {}

function inventory:get( index )
	return self[index]
end

function inventory:set(index, name, desc, img, minSharp, maxSharp, heal)
	-- "Index" is the place in the inventory
	-- "Name" is the name of the object
	-- "Desc" is the decription of the object
	-- "Img" is the image file of the object
	-- "minSharp"/"maxSharp" is the minimum and maximum sharpness for a sword
	self[index] = {}
	self[index].name = name
	self[index].desc = desc
	self[index].img  = img
	self[index].minSharp = minSharp
	self[index].maxSharp = maxSharp
end

function inventory:add(name, desc, img, minSharp, maxSharp, curSharp, heal)
	--Basicly the same as inventory:set with the exeption that it picks the slot on it's own
	for i = 0, MAX_INVENTORY do
		if self[i] == nil then
			local index = i
			
			self[index] = {}
			self[index].name = name
			self[index].desc = desc
			self[index].img  = img
			self[index].minSharp = minSharp
			self[index].maxSharp = maxSharp
			break
		end
	end
end

function inventory:swap( first, second )
	self[first], self[second] = self[second], self[first]
end

function inventory:clear( index )
	self[index] = nil
end

function inventory:clearAll()
	for i = 0, MAX_INVENTORY do
		self[i] = nil
	end
end

MAX_INVENTORY = 8

local img = love.graphics.newImage("textures/weapons/sword_1.png")
inventory:set( 1, sword_1, "Wooden Sword - The Basic Sword", img, 1, 2, 0)
local img = love.graphics.newImage("textures/weapons/shield_1.png")
inventory:set( 2, shield_1, "Wooden Shield - The Basic Shield", img, 0.5, 1.5, 0)
local img = love.graphics.newImage("textures/weapons/sword_1.png")
inventory:set( 3, potion_1, "Simple Juice - Heals 2 hearts", img, 0, 0, 2)