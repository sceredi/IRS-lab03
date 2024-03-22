local robot_wrapper = require("src.wrapper.robot_wrapper")
local logger = require("src.wrapper.logger")
local globals = require("src.globals")
local M = {}

function M.collisions_avoidance()
	local nearest = {
		pos = 1,
		value = robot_wrapper.get_proximity_sensor_readings()[1].value,
	}
	for i = 1, #robot_wrapper.get_proximity_sensor_readings() do
		if robot_wrapper.get_proximity_sensor_readings()[i].value > nearest.value then
			nearest = {
				pos = i,
				value = robot_wrapper.get_proximity_sensor_readings()[i].value,
			}
		end
	end
	if nearest.value >= globals.PROXIMITY_THRESHOLD then
		local rotation_speed = robot_wrapper.random.uniform(0, globals.MAX_VELOCITY / 2)
		if nearest.pos <= 7 then
			robot_wrapper.wheels.set_velocity(rotation_speed, -rotation_speed)
		elseif nearest.pos >= 18 then
			robot_wrapper.wheels.set_velocity(-rotation_speed, rotation_speed)
		else
			return false
		end
		robot_wrapper.leds.set_all_colors("red")
		return true
	else
		return false
	end
end

function M.random_walk()
	robot_wrapper.leds.set_all_colors("green")
	local left_v = robot_wrapper.random.uniform(0, globals.MAX_VELOCITY)
	local right_v = robot_wrapper.random.uniform(0, globals.MAX_VELOCITY)
	robot_wrapper.wheels.set_velocity(left_v, right_v)
	return false
end

local function calculateWheelSpeed(brightest)
	local left_v, right_v
	if brightest.pos == 1 or brightest.pos == 24 then
		left_v = globals.MAX_VELOCITY
		right_v = globals.MAX_VELOCITY
		robot_wrapper.leds.set_all_colors("black")
		robot_wrapper.leds.set_single_color(1, "yellow")
		robot_wrapper.leds.set_single_color(12, "yellow")
	elseif brightest.pos <= 12 then
		left_v = robot_wrapper.random.uniform(0, -globals.MAX_VELOCITY / 2)
		right_v = robot_wrapper.random.uniform(0, globals.MAX_VELOCITY)
		robot_wrapper.leds.set_all_colors("black")
		robot_wrapper.leds.set_single_color(brightest.pos / 2, "yellow")
	else
		left_v = robot_wrapper.random.uniform(0, globals.MAX_VELOCITY)
		right_v = robot_wrapper.random.uniform(0, -globals.MAX_VELOCITY / 2)
		robot_wrapper.leds.set_all_colors("black")
		robot_wrapper.leds.set_single_color(brightest.pos / 2, "yellow")
	end
	return left_v, right_v
end

function M.go_towards_light()
	local brightest_light = {
		pos = 1,
		value = robot_wrapper.get_light_sensor_readings()[1].value,
	}
	for i = 2, #robot_wrapper.get_light_sensor_readings() do
		if robot_wrapper.get_light_sensor_readings()[i].value > brightest_light.value then
			brightest_light = {
				pos = i,
				value = robot_wrapper.get_light_sensor_readings()[i].value,
			}
		end
	end
	logger.log("Brightest light: " .. brightest_light.value)
	if brightest_light.value >= globals.LIGHT_THRESHOLD then
		local left_v, right_v = calculateWheelSpeed(brightest_light)
		robot_wrapper.wheels.set_velocity(left_v, right_v)
	end
	return false
end

function M.stay_still()
	local brightest_light = {
		pos = 1,
		value = robot_wrapper.get_light_sensor_readings()[1].value,
	}
	for i = 2, #robot_wrapper.get_light_sensor_readings() do
		if robot_wrapper.get_light_sensor_readings()[i].value > brightest_light.value then
			brightest_light = {
				pos = i,
				value = robot_wrapper.get_light_sensor_readings()[i].value,
			}
		end
	end
	if brightest_light.value >= globals.LIGHT_THRESHOLD then
		robot_wrapper.leds.set_all_colors("yellow")
		robot_wrapper.wheels.set_velocity(0, 0)
		return true
	end
	return false
end
return M
