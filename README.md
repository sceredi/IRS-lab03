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
```

This code snippet shows the implementation of the "list" of levels defined in the architecture:
- `level` is simply used for pretty logging of the current level being executed.
- `callback` is a reference to a function that, when executed, will use the readings from the various sensors and 
execute some actions on the actuators. The callback function will return the values to change in the actuators. 
In this case only the left and right wheel speed values. Every layer above the current one is able to ovverride
those values with the one it returns, making the level number the same as the importance of the level.

## Edits from the Second Activity Implementation
Few changes were implemented from the previous architecture to this one. Some edits were needed due to the 
implementation of the return value in the callback function. The remainder of the code remains largely unchanged. 
An important difference is the removal of hardcoded values from the main file executed by the Argos controller. 
These values were relocated to a `src/globals.lua` file, enhancing isolation and accessibility, while the 
hardcoded thresholds remain present in the implementation.

## Problems
The current implementation still cannot solve the funnel problem.
