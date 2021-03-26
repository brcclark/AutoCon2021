# Application Overview

Shuttles need to move between the following Stations
1. Load
2. Fill
3. Weigh/Inspect
4. Reject
5. Cap
6. Buffer
7. Offload

Shuttles can go through numerous steps for filling if the recipe requires it
Reject is optional after the weigh/inspect station


## Product Recipe
Fills
  Layers[]
    0 denotes not used, 1-4 denotes fill stations


## Load Station
At load, products are assigned a recipe. Product is loaded on the shuttle
Upon completion of the load, the shuttles are moved to their appropriate fill station

## Fill Station
There are 4 fill stations, each fills a different type of product.
Each also has a different motion profile it needs to preform

First pass - shuttles don't use the bypass lanes. Simply go from 1,2,3,4 sequentially. 

### Traversal Between Fill Stations
Shuttles entering the fill area will be commanded to move to the Fill entry station. From there the shuttle will look at it's recipe to know which station to go to next. If the desired station is > current Station + 1, then we'll use the bypass lane to get to that station

Each station will have instructions on how to enter and exit the buffer lane. Entrance will be used before starting the traversal movement to the next station
