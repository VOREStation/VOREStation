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

#define PLANE_ADMIN1			-92 //Purely for shenanigans
#define PLANE_ADMIN2			-91 //And adminbuse
#define PLANE_ADMIN3			-90 //And generating salt

#define SPACE_PLANE     		-32	// Reserved for use in space/parallax
#define PARALLAX_PLANE  		-30	// Reserved for use in space/parallax

// OPENSPACE_PLANE reserves all planes between OPENSPACE_PLANE_START and OPENSPACE_PLANE_END inclusive
#define OPENSPACE_PLANE 		-55 // /turf/simulated/open will use OPENSPACE_PLANE + z (Valid z's being 2 thru 17)
#define OPENSPACE_PLANE_START	-53
#define OPENSPACE_PLANE_END		-38
#define OVER_OPENSPACE_PLANE	-37

////////////////////////////////////////////////////////////////////////////////////////
#define PLANE_WORLD				0	// BYOND's default value for plane, the "base plane"
////////////////////////////////////////////////////////////////////////////////////////

	//#define TURF_LAYER		2 //For easy recordkeeping; this is a byond define
	#define DECALS_LAYER		2.01
	#define OVERTURF_LAYER		2.1
	#define DOOR_OPEN_LAYER		2.7 //Under all objects if opened. 2.7 due to tables being at 2.6
	//#define OBJ_LAYER			3 //For easy recordkeeping; this is a byond define
	#define DOOR_CLOSED_LAYER	3.1 //Above most items if closed
	#define SHOWER_OPEN_LAYER	3.4
	#define BELOW_MOB_LAYER		3.9
	//#define MOB_LAYER			4 //For easy recordkeeping; this is a byond define
	#define ABOVE_MOB_LAYER		4.1
	#define SHOWER_CLOSED_LAYER 4.2

	//#define FLY_LAYER			5 //For easy recordkeeping; this is a byond define
	#define LIGHTING_LAYER		11 //Layer that lighting used to be on (now it's on a plane)
	#define HUD_LAYER			20 //Above lighting, but below obfuscation. For in-game HUD effects (whereas SCREEN_LAYER is for abstract/OOC things like inventory slots)
	#define OBFUSCATION_LAYER	21 //Where images covering the view for eyes are put
	#define SCREEN_LAYER		22 //Mob HUD/effects layer

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

//Fullscreen overlays under inventory
#define PLANE_FULLSCREEN		90	//Blindness, mesons, druggy, etc
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


//////////////////////////
/atom/proc/hud_layerise()
	plane = PLANE_PLAYER_HUD_ITEMS
	layer = LAYER_HUD_ITEM

/atom/proc/reset_plane_and_layer()
	plane = initial(plane)
	layer = initial(layer)


// Check if a mob can "logically" see an atom plane
#define MOB_CAN_SEE_PLANE(M, P) (P == PLANE_WORLD || (P >= OPENSPACE_PLANE_START && P <= OPENSPACE_PLANE_END) || (P in M.planes_visible))
