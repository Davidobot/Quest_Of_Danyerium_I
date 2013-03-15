
local lg    = love.graphics
local floor = math.floor
local ceil  = math.ceil
local min   = math.min
local max   = math.max

local font        = lg.newFont(12)
local fmidheight  = font:getHeight()/2
local whiteColor  = {255,255,255}

local m   = {class = 'map'}
m.__index = m
m.new     = function(self,t)
	return setmetatable(t,self)
end
m.__call  = m.new
setmetatable(m,{__call = m.new})

function m.draw(map)
	local prevFont  = lg.getFont()
	local w,h       = map.tilewidth,map.tileheight
	local wc,hc     = w/2,h/2
	
	lg.setFont(font)
	
	for y,row in pairs(map.grid) do
		for x,id in pairs(row) do
			lg.setColor(map.tileset[id].color or whiteColor)

			local x,y = (x-1)*w,(y-1)*h
			lg.draw(map.tileset[id].img,x,y)
			
			if id == 13 then
				lg.draw(map.tileset[1].img,x,y)
			end
			x,y = x+wc-font:getWidth(id)/2,y+hc-fmidheight
		end
	end
	
	lg.setFont(prevFont or font)	
end

function m:setTileID(x,y,id)
	self.grid[y][x] = id
end

function m:setTileSize(w,h)
	self.tileheight = h
	self.tilewidth  = w
end

function m:setGrid(grid)
	self.grid = grid
end

function m:setTileset(tileset)
	self.tileset = tileset
end

function m:setCallbacks(preSolve,postSolve)
	self.preSolve = preSolve; self.postSolve = postSolve
end

function m:getTile(x,y)
	return self.tileset[ self.grid[y][x] ]
end

function m:getTileSize()
	return self.tilewidth,self.tileheight
end

function m:getRange(x,y,w,h)
	local mw,mh = 32, 32
	local gx,gy =  
		floor(x/mw)+1,
		floor(y/mh)+1
	local gx2,gy2 =
		ceil((x+w)/mw),
		ceil((y+h)/mh)
	return gx,gy,gx2,gy2
end

function m:preSolve(side,obj,gx,gy)
end

function m:postSolve(side,obj,gx,gy)
end

function m:resolveXdirection(obj,x,y,w,h)
	local mw,mh         = 32, 32
	local gx,gy,gx2,gy2 = self:getRange(x,y,w,h)

	for gy = gy,gy2 do
		if self:preSolve('right',obj,gx2,gy) then
			x = ((gx2-1)*mw)-w
			self:postSolve('right',obj,gx2,gy)
		end
	end

	for gy = gy,gy2 do
		if self:preSolve('left',obj,gx,gy) then
			x = gx*mw
			self:postSolve('left',obj,gx,gy)
		end
	end
	return x
end

function m:resolveYdirection(obj,x,y,w,h)
	local mw,mh         = 32, 32
	local gx,gy,gx2,gy2 = self:getRange(x,y,w,h)

	for gx = gx,gx2 do
		if self:preSolve('floor',obj,gx,gy2) then
			y = (gy2-1)*mh-h
			self:postSolve('floor',obj,gx,gy2)
		end
	end

	for gx = gx,gx2 do
		if self:preSolve('ceiling',obj,gx,gy) then
			y = gy*mh
			self:postSolve('ceiling',obj,gx,gy)
		end
	end
	return y
end
-----------------------------------------------------------
return m