/*This file is a list of all preclaimed planes & layers

All planes & layers should be given a value here instead of using a magic/arbitrary number.

After fiddling with planes and layers for some time, I figured I may as well provide some documentation:

What are planes?
	Think of Planes as a sort of layer for a layer - if plane X is a larger number than plane Y, the highest number for a layer in X will be below the lowest
	number for a layer in Y.
	Planes also have the added bonus of having planesmasters.

What are Planesmasters?
	Planesmasters, when in the sight of a player, will have its appearance properties (for example, colour matrices, alpha, transform, etc)
	applied to all the other objects in the plane. This is all client sided.
	Usually you would want to add the planesmaster as an invisible image in the client's screen.

What can I do with Planesmasters?
	You can: Make certain players not see an entire plane,
	Make an entire plane have a certain colour matrices,
	Make an entire plane transform in a certain way,
	Make players see a plane which is hidden to normal players - I intend to implement this with the antag HUDs for example.
	Planesmasters can be used as a neater way to deal with client images or potentially to do some neat things

How do planes work?
	A plane can be any integer from -100 to 100. (If you want more, bug lummox.)
	All planes above 0, the 'base plane', are visible even when your character cannot 'see' them, for example, the HUD.
	All planes below 0, the 'base plane', are only visible when a character can see them.

How do I add a plane?
	Think of where you want the plane to appear, look through the pre-existing planes and find where it is above and where it is below
	Slot it in in that place, and change the pre-existing planes, making sure no plane shares a number.
	Add a description with a comment as to what the plane does.

How do I make something a planesmaster?
	Add the PLANE_MASTER appearance flag to the appearance_flags variable.

What is the naming convention for planes or layers?
	Make sure to use the name of your object before the _LAYER or _PLANE, eg: [NAME_OF_YOUR_OBJECT HERE]_LAYER or [NAME_OF_YOUR_OBJECT HERE]_PLANE
	Also, as it's a define, it is standard practice to use capital letters for the variable so people know this.

*/

#define SPACE_PLANE     		-82	// Reserved for use in space/parallax
#define PARALLAX_PLANE  		-80	// Reserved for use in space/parallax

// OPENSPACE_PLANE reserves all planes between OPENSPACE_PLANE_START and OPENSPACE_PLANE_END inclusive
#define OPENSPACE_PLANE 		-75 // /turf/simulated/open will use OPENSPACE_PLANE + z (Valid z's being 2 thru 17)
#define OPENSPACE_PLANE_START	-73
#define OPENSPACE_PLANE_END		-58
#define OVER_OPENSPACE_PLANE	-57

// Turf Planes
#define SPACE_PLANE				-43 // Space turfs themselves
#define PLATING_PLANE			-44 // Plating
	#define DISPOSAL_LAYER		2.1 // Under objects, even when planeswapped
	#define PIPES_LAYER			2.2	// Under objects, even when planeswapped
	#define WIRES_LAYER			2.3 // Under objects, even when planeswapped
	#define ATMOS_LAYER			2.4 // Pipe-like atmos machinery that goes on the floor, like filters.
	#define ABOVE_UTILITY		2.5 // Above stuff like pipes and wires
#define TURF_PLANE				-45 // Turfs themselves, most flooring
	#define WATER_FLOOR_LAYER	2.0 // The 'bottom' of water tiles.
	#define UNDERWATER_LAYER	2.5 // Anything on this layer will render under the water layer.
	#define WATER_LAYER			3.0 // Layer for water overlays.
	#define ABOVE_TURF_LAYER	3.1	// Snow and wallmounted/floormounted equipment
#define DECAL_PLANE				-44 // Permanent decals
#define DIRTY_PLANE				-43 // Nonpermanent decals
#define BLOOD_PLANE				-42 // Blood is really dirty, but we can do special stuff if we separate it

// Obj planes
#define OBJ_PLANE				-35
	#define STAIRS_LAYER			2.5 // Layer for stairs
	#define HIDING_LAYER			2.6 // Layer at which mobs hide to be under things like tables
	#define DOOR_OPEN_LAYER			2.7 // Under all objects if opened. 2.7 due to tables being at 2.6
	#define TABLE_LAYER				2.8 // Just under stuff that wants to be slightly below common objects.
	#define PROJECTILE_HIT_THRESHOLD_LAYER 2.8
	#define UNDER_JUNK_LAYER		2.9 // Things that want to be slightly below common objects
	// Turf/Obj layer boundary
	#define ABOVE_JUNK_LAYER		3.1 // Things that want to be slightly above common objects
	#define DOOR_CLOSED_LAYER		3.1	// Doors when closed
	#define WINDOW_LAYER			3.2	// Windows
	#define ON_WINDOW_LAYER			3.3 // Ontop of a window
	#define ABOVE_WINDOW_LAYER 		3.4 //Above full tile windows so wall items are clickable

// Mob planes
#define MOB_PLANE				-25
	#define BELOW_MOB_LAYER			3.9 // Should be converted to plane swaps
	#define ABOVE_MOB_LAYER			4.1	// Should be converted to plane swaps

// Top plane (in the sense that it's the highest in 'the world' and not a UI element)
#define ABOVE_PLANE				-10

////////////////////////////////////////////////////////////////////////////////////////
#define PLANE_WORLD				0	// BYOND's default value for plane, the "base plane"
////////////////////////////////////////////////////////////////////////////////////////

	//#define AREA_LAYER		1 //For easy recordkeeping; this is a byond define

	//#define TURF_LAYER		2 //For easy recordkeeping; this is a byond define

	//#define OBJ_LAYER			3 //For easy recordkeeping; this is a byond define

	//#define MOB_LAYER			4 //For easy recordkeeping; this is a byond define

	//#define FLY_LAYER			5 //For easy recordkeeping; this is a byond define

	#define HUD_LAYER				20	// Above lighting, but below obfuscation. For in-game HUD effects (whereas SCREEN_LAYER is for abstract/OOC things like inventory slots)
	#define SCREEN_LAYER			22	// Mob HUD/effects layer

#define PLANE_ADMIN1			3 //Purely for shenanigans (below lighting)
#define PLANE_PLANETLIGHTING	4 //Lighting on planets
#define PLANE_LIGHTING			5 //Where the lighting (and darkness) lives
#define PLANE_LIGHTING_ABOVE	6 //For glowy eyes etc. that shouldn't be affected by darkness

#define PLANE_GHOSTS			10 //Spooooooooky ghooooooosts
#define PLANE_AI_EYE			11 //The AI eye lives here

// "Character HUDs", aka HUDs, but not the game's UI. Things like medhuds. I know Planes say they must be intergers, but it's lies.
#define PLANE_CH_STATUS			15 //Status icon
#define PLANE_CH_HEALTH			16 //Health icon
#define PLANE_CH_LIFE			17 //Health bar
#define PLANE_CH_ID				18 //Job icon
#define PLANE_CH_WANTED			19 //Arrest icon
#define PLANE_CH_IMPLOYAL		20 //Loyalty implant icon
#define PLANE_CH_IMPTRACK		21 //Tracking implant icon
#define PLANE_CH_IMPCHEM		22 //Chemical implant icon
#define PLANE_CH_SPECIAL		23 //Special role icon (revhead or w/e)
#define PLANE_CH_STATUS_OOC		24 //OOC status hud for spooks

#define PLANE_MESONS			30 //Stuff seen with mesons, like open ceilings. This is 30 for downstreams.

#define PLANE_ADMIN2			33 //Purely for shenanigans (above lighting)

#define PLANE_BUILDMODE			39 //Things that only show up when you have buildmode on

//Fullscreen overlays under inventory
#define PLANE_FULLSCREEN		90 //Blindness, mesons, druggy, etc
	#define OBFUSCATION_LAYER	5 //Where images covering the view for eyes are put
	#define FULLSCREEN_LAYER	18
	#define DAMAGE_LAYER		18.1
	#define BLIND_LAYER			18.2
	#define CRIT_LAYER			18.3

//Client UI HUD stuff
#define PLANE_PLAYER_HUD		95 //The character's UI is on this plane
	#define LAYER_HUD_UNDER		1 //Under the HUD items
	#define LAYER_HUD_BASE		2 //The HUD items themselves
	#define LAYER_HUD_ITEM		3 //Things sitting on HUD items (largely irrelevant because PLANE_PLAYER_HUD_ITEMS)
	#define LAYER_HUD_ABOVE		4 //Things that reside above items (highlights)
#define PLANE_PLAYER_HUD_ITEMS	96 //Separate layer with which to apply colorblindness
#define PLANE_PLAYER_HUD_ABOVE	97 //Things above the player hud

#define PLANE_ADMIN3			99 //Purely for shenanigans (above HUD)


//////////////////////////
/atom/proc/hud_layerise()
	plane = PLANE_PLAYER_HUD_ITEMS
	layer = LAYER_HUD_ITEM

/atom/proc/reset_plane_and_layer()
	plane = initial(plane)
	layer = initial(layer)


// Check if a mob can "logically" see an atom plane
#define MOB_CAN_SEE_PLANE(M, P) (P <= PLANE_WORLD || (P in M.planes_visible))
