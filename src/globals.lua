local M = {}

-- the robot max speed
M.MAX_VELOCITY = 15

-- the minimum light threshold to consider a light source
M.LIGHT_THRESHOLD = 0.01

-- the maximum light treshold before the robot stops
M.ARRIVAL_THRESHOLD = 0.55

-- when to start avoiding obstacles
M.PROXIMITY_THRESHOLD = 0.5

-- the maximum difference to consider the robot is in a funnel
M.PROXIMITY_THRESHOLD_FUNNEL_MAX_DIFF = 0.5

-- the minimum sum to consider the robot is in a funnel
M.PROXIMITY_THRESHOLD_FUNNEL_MIN_SUM = 0.4

return M
