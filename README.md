# IRS Third Activity
## Objective
The objective of the activity was the same as that of the second activity, while also utilizing an implementation of the 
Subsumption Architecture.
### Constraints
- Use the Subsumption Architecture for the implementation.
- Move towards the light as swiftly as possible.
- Avoid collisions with obstacles.

## Solution Implemented
### Layers Definition
```lua
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
```

This code snippet shows the implementation of the "list" of levels defined in the architecture:
- `level` is simply used for pretty logging of the current level being executed.
- `callback` is a reference to a function that, when executed, will use the readings from the various sensors and 
execute some actions on the actuators. The callback functions will also return a boolean value: `true` if the 
executed action is the last one that needs to be executed, `false` if the following layers should also execute 
their callback and override the values set by the current one. For example, if an obstacle is very close to the 
robot, the collision avoidance callback will execute and return `true` so that the robot will avoid the obstacle 
and deny the execution of the following layers.

## Edits from the Second Activity Implementation
Few changes were implemented from the previous architecture to this one. Some edits were needed due to the 
implementation of the return value in the callback function. The remainder of the code remains largely unchanged. 
An important difference is the removal of hardcoded values from the main file executed by the Argos controller. 
These values were relocated to a `src/globals.lua` file, enhancing isolation and accessibility, while the 
hardcoded thresholds remain present in the implementation.

## Problems
The current implementation still cannot solve the funnel problem.
