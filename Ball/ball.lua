class('Ball').extends(playdate.graphics.sprite)

local floor = math.floor

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return floor(num * mult + 0.5) / mult
end

function Ball:init()

	Ball.super.init(self)

	self.image = playdate.graphics.image.new('Ball/ball')
	
	self:setCollideRect(0, 0, 32, 32)
	
	self.x = playdate.display.getWidth() / 2
	self.y = playdate.display.getHeight() / 2
	self.xVel = 0
	self.yVel = 0
	
	self.calibratedX = 0
	self.calibratedY = 0
	self.calibratedZ = 0
	
	self.dx = 0
	self.dy = 0
	self.speed = 7
	
	self.calibrated = false
	
	self:reset()
	self:addSprite()
end

function Ball:reset()
	self:moveTo(self.x, self.y)
end

function Ball:update()

	if not playdate.accelerometerIsRunning() then
		playdate.startAccelerometer()
	else
		if not self.calibrated then
			self.calibratedX, self.calibratedY, self.calibratedZ = playdate.readAccelerometer()
			self.calibrated = true
		end
		
		local accelX,accelY,accelZ = playdate.readAccelerometer()
		self.dx = round(accelX - self.calibratedX, 1)
		self.dy = round(accelY - self.calibratedY, 1)
	end	
	
	if playdate.buttonIsPressed("a") and playdate.buttonIsPressed("b") then
		self.calibrated = false
	end
	
	self:setImage(self.image)
	local xSpeed = self.speed * self.dx
	local ySpeed = self.speed * self.dy
	self:moveTo(self.x + xSpeed, self.y + ySpeed)
	playdate.graphics.setDrawOffset((playdate.display.getWidth() / 2) - self.x, (playdate.display.getHeight() / 2) - self.y)
end