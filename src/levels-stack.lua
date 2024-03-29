local M = {}
local levels = require("src.levels")

M.list = {
	{
		level = 0,
		callback = levels.random_walk,
	},
	{
		level = 1,
		callback = levels.go_towards_light,
	},
	{
		level = 2,
		callback = levels.collisions_avoidance,
	},
	{
		level = 3,
		callback = levels.stay_still,
	},
}

return M
