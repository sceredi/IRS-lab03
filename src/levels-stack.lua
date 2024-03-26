local M = {}
local levels = require("src.levels")

M.list = {
	{
		level = 0,
		callback = levels.collisions_avoidance,
	},
	{
		level = 1,
		callback = levels.random_walk,
	},
	{
		level = 2,
		callback = levels.go_towards_light,
	},
}

return M
