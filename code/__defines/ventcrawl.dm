// DO NOT LEAVE A TRAILING COMMA!

/// Things that are always considered legal to ventcrawl with. Usually because they are internal objects related to mob or game functionality.
#define VENTCRAWL_BASE_WHITELIST 	/atom/movable/screen, \
									/atom/movable/emissive_blocker, \
									/obj/machinery/camera, \
									/obj/item/radio/headset/mob_headset, \
									/obj/item/radio/borg, \
									/obj/item/rig/protean, \
									/obj/item/implant
//mob/living/simple_mob/borer, //VORESTATION AI TEMPORARY REMOVAL REPLACE BACK IN LIST WHEN RESOLVED

/// Vore unique objects
#define VENTCRAWL_VORE_WHITELIST 	/obj/belly, \
									/obj/soulgem, \
									/obj/item/holder

/// Reasonable items with a low chance of causing exploits, mostly for catslugs but allowed by default on other vent crawlers
#define VENTCRAWL_SMALLITEM_WHITELIST /obj/item/coin, \
									/obj/item/aliencoin, \
									/obj/item/toy, \
									/obj/item/clipboard, \
									/obj/item/paper, \
									/obj/item/pen, \
									/obj/item/canvas, \
									/obj/item/paint_palette, \
									/obj/item/paint_brush, \
									/obj/item/camera, \
									/obj/item/photo, \
									/obj/item/camera_film, \
									/obj/item/taperecorder, \
									/obj/item/rectape
