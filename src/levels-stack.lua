local M = {}
local levels = require("src.levels")

M.list = {
	{
		callback = levels.random_walk,
	},
	{
		callback = levels.go_towards_light,
	},
	{
		callback = levels.collisions_avoidance,
	},
	{
		callback = levels.stay_still,
	},
}

return M
