import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "Ball/ball"
import "Levels/level"

playdate.display.setRefreshRate(30)

local gfx = playdate.graphics
local spritelib = gfx.sprite
local screenWidth = playdate.display.getWidth()
local screenHeight = playdate.display.getHeight()

local currentLevel = Level()
local playerBall = Ball()

function playdate.update()
	spritelib.update()
end