local robot_wrapper = require("src.wrapper.robot_wrapper")
local globals = require("src.globals")
local M = {}

-- get the closest proximity sensor to the robot
local function get_closest_proximity_sensor()
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
	return nearest
end

-- get the average value of the top-left and top-right proximity sensors
local function get_avg_tl_tr_proximity()
	local tl, tr = 0, 0
	for i = 1, 7 do
		tl = tl + robot_wrapper.get_proximity_sensor_readings()[i].value
	end
	for i = 18, 24 do
		tr = tr + robot_wrapper.get_proximity_sensor_readings()[i].value
	end
	return tl / 7, tr / 7
end

-- avoid collisions with obstacles
function M.collisions_avoidance()
	local nearest = get_closest_proximity_sensor()
	local left_v, right_v = nil, nil
	if nearest.value >= globals.PROXIMITY_THRESHOLD then
		local rotation_speed = robot_wrapper.random.uniform(0, globals.MAX_VELOCITY / 2)
		local tl, tr = get_avg_tl_tr_proximity()
		if
			tl - tr <= math.abs(globals.PROXIMITY_THRESHOLD_FUNNEL_MAX_DIFF)
			and tl + tr >= globals.PROXIMITY_THRESHOLD_FUNNEL_MIN_SUM
		then
			left_v = -rotation_speed
			right_v = rotation_speed
		elseif nearest.pos <= 7 then
			left_v = rotation_speed
			right_v = -rotation_speed
		elseif nearest.pos >= 18 then
			left_v = -rotation_speed
			right_v = rotation_speed
		end
		robot_wrapper.leds.set_all_colors("red")
	end
	return left_v, right_v
end

-- move randomly
function M.random_walk()
	robot_wrapper.leds.set_all_colors("green")
	local left_v = robot_wrapper.random.uniform(0, globals.MAX_VELOCITY)
	local right_v = robot_wrapper.random.uniform(0, globals.MAX_VELOCITY)
	return left_v, right_v
end

-- calculate the wheel speed based on the brightest light, to move towards it
local function calculateWheelSpeed(brightest)
	local left_v, right_v = nil, nil
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

-- get the brightest light sensor
local function get_brightest_light()
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
	return brightest_light
end

-- move towards the brightest light
function M.go_towards_light()
	local brightest_light = get_brightest_light()
	local left_v, right_v = nil, nil
	if brightest_light.value >= globals.LIGHT_THRESHOLD then
		left_v, right_v = calculateWheelSpeed(brightest_light)
	end
	return left_v, right_v
end

-- stay still if the brightest light is above the arrival threshold
function M.stay_still()
	local brightest_light = get_brightest_light()
	local left_v, right_v = nil, nil
	if brightest_light.value >= globals.ARRIVAL_THRESHOLD then
		robot_wrapper.leds.set_all_colors("yellow")
		left_v, right_v = 0, 0
	end
	return left_v, right_v
end

return M
