function setCallBacksWorld(map, player)
	map:setCallbacks(
		function(self,side,obj,gx,gy)
			local tileType = self:getTile(gx,gy).type
		
			if tileType == 2 then return true end
			
  			if tileType == 3 then --Block can be entered only from Left
 				if side == 'left' and leftSideGX > gx then return true end
 			end
			
 			if tileType == 4 then --Block can be entered only from Right
 				if side == 'right' and rightSideGX < gx then return true end
 			end
			
			if tileType == 5 then --Block activates an event once. It disappears after.
				self:setTileID(gx,gy,1)
				playVoice = 1
				return true end
			
			if tileType == 7 then
				setx = 448
				sety = 544
				CurMap = House1
				return true
			end
		end
	)
end

function setCallBacksHouse1(map, player)
	map:setCallbacks(
		function(self,side,obj,gx,gy)
			local tileType = self:getTile(gx,gy).type
		
			if tileType == 2 then return true end
			
			if tileType == 3 then
				setx = 352
				sety = 896
				CurMap = WorldMap
				return true
			end
		end
	)
end