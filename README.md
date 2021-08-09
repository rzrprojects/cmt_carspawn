# cmt_carspawn - Spawn Admin Cars
With this ressource you can spawn vehicles directly from your database where these are stored. You can tune them like you want and spawn them wherever you want.

(Because this is **FailRP** on Rolleplay servers, the plate is default set to **Admin**)



## Commands

  - **admincar enable/disable <plate>** (allow or disallow the owner of the vehicle to spawn it via this menu - you can also use true/false)
  - **admincar plate <plate>** (set the plate of the vehicle your'e in, you must be in the Driver's seat)
  - **carspawn** (open the menu)

  
  
## Setup

Installation:
  - import the **cmt_carspawn.sql** file to your database
  - add **start cmt_carspawn** to your server.cfg
  
Requirements: [es_extended](https://github.com/esx-framework/es_extended)

Permissions:
  - add_ace group.owner command.carspawn allow  (give that only to people you trust)
  - add_ace group.mod command.admincar allow  (give that to your mods or sups)


