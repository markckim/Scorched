Scorched
========

Prototype experimenting with destructible terrain (i.e., "Scorched" / "Worms" type gameplay) using cocos2d and box2d.

Demo of an implementation of destructible terrain on iOS using cocos2d and box2d. Touching an area creates a circular hole. If the circle intersects the terrain, it is removed. The image has been separated into different tiles (indicated by the red lined boundaries) which are box2d edges to improve performance. Upon terrain destruction, the borders are reconstructed and new edges are created based on the remaining terrain inside the tile.

[![ScreenShot](https://github.com/markckim/Scorched/blob/master/Scorched/destructible_terrain.png)](http://www.youtube.com/watch?v=TBiFPUwqvh0)