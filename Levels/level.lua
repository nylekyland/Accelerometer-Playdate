class('Level').extends(playdate.graphics.sprite)

local gfx = playdate.graphics

local function loadLevelJson(path)
	local levelData = nil
	
	local f = playdate.file.open(path)
	if f then
		local s = playdate.file.getSize(path)
		levelData = f:read(s)
		f:close()
		
		if not levelData then
			print('ERROR LOADING DATA for ' .. path)
			return nil
		end
	end

	local jsonTable = json.decode(levelData)
	
	if not jsonTable then
		print('ERROR PARSING JSON DATA for ' .. path)
		return nil
	else
		print('LOAD SUCCESSFUL for ' .. path)
	end
	
	return jsonTable
end

local function loadLevelTiles(level, leveltiles)
	local tileX = 0
	local tileY = -(level.tileheight)
	for i, tile in ipairs(level.layers[1].data) do
		if i % level.width - 1 == 0 then
			tileY = tileY + level.tileheight
			tileX = 0
		end
		table.insert(leveltiles, {x = tileX, y = tileY, width = level.tilewidth, height = level.tileheight, id = tile})
		tileX = tileX + level.tilewidth
	end
end

function Level:init()
	Level.super.init(self)
	
	self.level = loadLevelJson("levels/test.json")
	self.leveltiles = {}
	loadLevelTiles(self.level, self.leveltiles)
	
	local levelImageTable = gfx.imagetable.new('Tiles/tile')
	self.tilemap = gfx.tilemap.new()
	self.tilemap:setImageTable(levelImageTable)
	self.tilemap:setSize(self.level.width, self.level.height)
	for i, tile in ipairs(self.leveltiles) do
		if tile ~= 0 then
			--print("tile: " .. (tile.x / 32) + 1 .. "," .. (tile.y / 32) + 1 .. " - " .. tile.id)
			self.tilemap:setTileAtPosition((tile.x / 32) + 1, (tile.y / 32) + 1, tile.id)
		end
	end
	
	self:setBounds(0, 0, self.level.width * 32, self.level.height * 32)
	self:addSprite()
end

function Level:update()

end

function Level:draw(x,y,width,height)
	self.tilemap:draw(0,0)
end