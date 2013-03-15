items = {}

function items:set(name, desc, img, minSharp, maxSharp, curSharp, heal)

local img = love.graphics.newImage("textures/weapons/sword_1.png")
inventory:set( 1, sword_1, "Wooden Sword - The Basic Sword", img, 1, 2, 0)
local img = love.graphics.newImage("textures/weapons/shield_1.png")
inventory:set( 2, shield_1, "Wooden Shield - The Basic Shield", img, 0.5, 1.5, 0)
local img = love.graphics.newImage("textures/weapons/sword_1.png")
inventory:set( 3, potion_1, "Simple Juice - Heals 2 hearts", img, 0, 0, 2)

--template:

--local img = love.graphics.newImage("textures/weapons/sword_1.png")
--inventory:set( 3, potion_1, "Simple Juice - Heals 2 hearts", img, 0, 0, 2)

end