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

# Shuttle Logic
Each shuttle has a state machine that it moves through. It will go back and forth between waiting for a Macro/Move traversal block to complete and then waiting for a station to complete it's operation

Filling may be broken out due to it's complexity

## Station Positions
| Station | Position X | Position Y | 
| ======= | ========== | ========== |
| Load    |            |            |
| Fill 1  |            |            |
| Fill 2  |            |            |
| Fill 3  |            |            |
| Fill 4  |            |            |
| Weigh   |            |            |
| Cap 1   |            |            |
| Cap 2   |            |            |
| Reject  |            |            |

# Shuttle state machine
   1. Off
   2. Init
   3. Idle
   4. MovingToLoad
   5. Loading
   6. MovingToFill
   7. Filling
   8. FillingEvaluate
   9. MovingToWeigh
   10. Weighing
   11. MovingToCap
   12. Capping
   13. MovingToBuffer
   14. WaitingAtBuffer
   15. MovingToUnload
   16. Unloading
   18. MovingToReject
   19. Rejecting
   20. Error

# Macros
  128. Load To Fill Entry
  129. Fill Entry To Fill 1
  130. Fill 1 To Fill 2
  131. Fill 2 To Fill 3
  132. Fill 3 To Fill 4
  133. Fill 4 To Fill 1
  134. Fill 4 To Fill Exit
  135. Fill Exit to Weigh 1
  136. Fill Exit to Weigh 2
  137. Weigh to Cap 1
  138. Weigh to Cap 2
  139. Weigh to Reject
  140. Cap to Buffer 1
  141. Cap to Buffer 2
  142. Cap to Buffer 3
  143. Cap to Buffer 4
  144. Buffer to Unload
  145. Unload to Load
  146. Reject to Load