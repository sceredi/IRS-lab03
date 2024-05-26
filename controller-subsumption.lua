-- Put your global variables here
local robot_wrapper = require("src.wrapper.robot_wrapper")
local logger = require("src.wrapper.logger")
local levels_stack = require("src.levels-stack")

local n_steps = 0

function init()
	n_steps = 0
	robot_wrapper.wheels.set_velocity(0, 0)
end

-- execute_steps will execute all levels in the stack and set the velocity of the robot
local function execute_steps()
	local left_v, right_v = nil, nil
	for i, level in ipairs(levels_stack.list) do
		local callback = level.callback
		logger.log("executing level " .. i)
		local left_ret, right_ret = callback()
		if left_ret ~= nil and right_ret ~= nil then
			left_v = left_ret
			right_v = right_ret
		end
	end
	if left_v ~= nil and right_v ~= nil then
		robot_wrapper.wheels.set_velocity(left_v, right_v)
	end
end

function step()
	n_steps = n_steps + 1
	execute_steps()
end

function reset()
	n_steps = 0
	robot_wrapper.wheels.set_velocity(0, 0)
end

-- destroy is called when the controller is destroyed
function destroy()
	local x = robot.positioning.position.x
	local y = robot.positioning.position.y
	local d = math.sqrt((x - 2) ^ 2 + y ^ 2)
	-- return the distance to the target
	print("f_distance " .. d)
end
