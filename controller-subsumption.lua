-- Put your global variables here
local robot_wrapper = require("src.wrapper.robot_wrapper")
local logger = require("src.wrapper.logger")
local levels_stack = require("src.levels-stack")

local n_steps = 0

--[[ This function is executed every time you press the 'execute'
     button ]]
function init()
	n_steps = 0
	robot_wrapper.wheels.set_velocity(0, 0)
end

-- NOTE: I can add the state as a parameter of this function and pass it to the callbacks
local function execute_steps()
	for _, level in ipairs(levels_stack.tree) do
		local level_number = level.level
		local callback = level.callback
		logger.log("executing level " .. level_number)
		if callback() then
			return true -- Behavior successfully executed
		end
	end
	return false -- No behavior executed
end
--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
	n_steps = n_steps + 1
	execute_steps()
end

--[[ This function is executed every time you press the 'reset'
     button in the GUI. It is supposed to restore the state
     of the controller to whatever it was right after init() was
     called. The state of sensors and actuators is reset
     automatically by ARGoS. ]]
function reset()
	n_steps = 0
	robot_wrapper.wheels.set_velocity(0, 0)
end

--[[ This function is executed only once, when the robot is removed
     from the simulation ]]
function destroy()
	-- put your code here
end
