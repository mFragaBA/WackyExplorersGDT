# WackyExplorersGDT

Silly game I made to spend part of my weekend

- 2D, splitscreen multiplayer. Maybe online multiplayer in the future.
- Inspired by deep sea adventure board game

## How to play

Currently there is the following gameplay loop:

- start new game with randomized items in a base.
- player can move around with the arrow keys and pick items with space.
- player has an indicator pointing to the closest pickable and another one
pointing in the direction of the starting base
- you can pickup loot with the `space` key. The item that is picked up is the
focused one, which has an outline. If player has multiple items close by, you
can switch the focus with the `E` key.
- at any time the player can go back to the base and press the `space` key to
unload all picked up items, which scores some points. 

## Roadmap

- [ ] PlayerController
    - [x] basic movement
    - [ ] advanced movement mechanics
- [ ] Loot
    - [x] point scoring loot (supported but need to start creating the items)
    - [x] stat modifying loot (supported but need to start creating the items)
    - [ ] ability loot (consumable)
- [ ] Shared resource
    - [ ] basic resource drain
    - [ ] multi-player support
- [x] Main Loop
- [ ] Neutral Mobs
- [ ] Map Generation
    - [ ] 1st basic open map with randomized loot locations
    - [ ] dungeon-y map with rooms and corridors
    - [ ] CP (Constraint Programming)
    - [ ] more(?)
- [ ] UI
    - [ ] HUD (remaining resource left, current player's points)
    - [ ] item tooltips
- [ ] Menu Screens
