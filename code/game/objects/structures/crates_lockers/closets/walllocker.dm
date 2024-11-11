//added by cael from old bs12
//not sure if there's an immediate place for secure wall lockers, but i'm sure the players will think of something

/obj/structure/closet/walllocker
	desc = "A wall mounted storage locker."
	name = "wall locker"
	icon = 'icons/obj/closets/bases/wall.dmi'
	closet_appearance = /decl/closet_appearance/wall
	density = FALSE
	anchored = TRUE
	store_mobs = 0
	wall_mounted = 1

	open_sound = 'sound/machines/click.ogg'
	close_sound = 'sound/machines/click.ogg'

//spawns 2 sets of breathmask, emergency oxy tank and crowbar

/obj/structure/closet/walllocker/emerglocker
	name = "emergency locker"
	desc = "A wall mounted locker with emergency supplies."
	var/list/spawnitems = list(/obj/item/tank/emergency/oxygen,/obj/item/clothing/mask/breath,/obj/item/tool/crowbar/red)
	var/amount = 2 // spawns each items X times.
	closet_appearance = /decl/closet_appearance/wall/emergency

/obj/structure/closet/walllocker/emerglocker/toggle(mob/user as mob)
	src.attack_hand(user)
	return

/obj/structure/closet/walllocker/emerglocker/attackby(obj/item/W as obj, mob/user as mob)
	return

/obj/structure/closet/walllocker/emerglocker/attack_hand(mob/user as mob)
	if (istype(user, /mob/living/silicon/ai))	//Added by Strumpetplaya - AI shouldn't be able to
		return									//activate emergency lockers.  This fixes that.  (Does this make sense, the AI can't call attack_hand, can it? --Mloc)
	if(!amount)
		to_chat(user, "<spawn class='notice'>It's empty..")
		return
	if(amount)
		to_chat(user, "<spawn class='notice'>You take out some items from \the [src].")
		for(var/path in spawnitems)
			new path(src.loc)
		amount--
	return

/obj/structure/closet/walllocker/emerglocker/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker/emerglocker/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker/emerglocker/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker/emerglocker/east
	pixel_x = 32
	dir = EAST

//VOREStation Add Start
/obj/structure/closet/walllocker/medical
	name = "first-aid closet"
	desc = "It's a wall-mounted storage unit for first aid supplies."
	closet_appearance = /decl/closet_appearance/wall/medical

/obj/structure/closet/walllocker/medical/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker/medical/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker/medical/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker/medical/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker/wooden
	name = "wooden cabinet"
	desc = "A wall mounted storage cabinet."
	closet_appearance = /decl/closet_appearance/wall_double/wooden

/obj/structure/closet/walllocker/wooden/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker/wooden/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker/wooden/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker/wooden/east
	pixel_x = 32
	dir = EAST
//VOREStation Add End

//double-size "cabinet" lockers, from Killian
/obj/structure/closet/walllocker_double
	desc = "A wall mounted storage cabinet."
	name = "wall cabinet"
	icon = 'icons/obj/closets/bases/wall_double.dmi'
	closet_appearance = /decl/closet_appearance/wall_double
	density = FALSE
	anchored = TRUE
	store_mobs = 0
	wall_mounted = 1
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER

	open_sound = 'sound/machines/click.ogg'
	close_sound = 'sound/machines/click.ogg'

/obj/structure/closet/walllocker_double/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker_double/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker_double/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker_double/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker_double/kitchen
	desc = "A wall mounted storage cabinet, for the kitchen. Now where's the flour gone..?"
	name = "kitchen cabinet"
	icon = 'icons/obj/closets/bases/wall_double.dmi'
	closet_appearance = /decl/closet_appearance/wall_double/kitchen
	density = FALSE
	anchored = TRUE

/obj/structure/closet/walllocker_double/kitchen/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker_double/kitchen/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker_double/kitchen/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker_double/kitchen/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker_double/medical
	name = "medical cabinet"
	desc = "A wall mounted medical supply cabinet. Probably full of drugs!"	//not actually full of drugs, sorry!
	closet_appearance = /decl/closet_appearance/wall_double/medical

/obj/structure/closet/walllocker_double/medical/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker_double/medical/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker_double/medical/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker_double/medical/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker_double/emergency_engi
	name = "emergency supplies cabinet"
	desc = "A wall mounted cabinet. Seemingly has cool stuff for 'emergency use only'."
	closet_appearance = /decl/closet_appearance/wall_double/emergency_engi

	starts_with = list(
		/obj/item/clothing/mask/breath = 2,
		/obj/item/tank/emergency/oxygen/engi = 2,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/radio = 3)

/obj/structure/closet/walllocker_double/emergency_engi/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker_double/emergency_engi/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker_double/emergency_engi/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker_double/emergency_engi/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker_double/hydrant
	name = "fire-safety closet"
	desc = "It's a storage cabinet packed with fire-fighting supplies."
	closet_appearance = /decl/closet_appearance/wall_double/fire_safety

	starts_with = list(
		/obj/item/clothing/suit/fire,
		/obj/item/clothing/mask/gas,
		/obj/item/flashlight,
		/obj/item/tank/oxygen/red,
		/obj/item/extinguisher,
		/obj/item/clothing/head/hardhat/red)

/obj/structure/closet/walllocker_double/hydrant/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker_double/hydrant/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker_double/hydrant/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker_double/hydrant/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker_double/survival
	desc = "A wall mounted storage cabinet. It contains a small amount of emergency supplies for wilderness survival, but they probably won't last very long."
	name = "emergency survival wall cabinet"
	icon = 'icons/obj/closets/bases/wall_double.dmi'
	closet_appearance = /decl/closet_appearance/wall_double/survival
	density = FALSE
	anchored = TRUE
	store_mobs = 0
	wall_mounted = 1
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER

	starts_with = list(
		/obj/item/clothing/suit/space/emergency,
		/obj/item/clothing/head/helmet/space/emergency,
		/obj/item/clothing/mask/breath,
		/obj/item/tank/oxygen,
		/obj/item/suit_cooling_unit/emergency,
		/obj/item/gps,
		/obj/item/material/knife/tacknife/survival,
		/obj/random/mre,
		/obj/item/flashlight/color/yellow,
		/obj/item/flashlight/flare,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle)

/obj/structure/closet/walllocker_double/survival/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker_double/survival/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker_double/survival/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker_double/survival/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker_double/security
	name = "security cabinet"
	desc = "A wall mounted cabinet. This one is suspiciously red."
	closet_appearance = /decl/closet_appearance/wall_double/security

/obj/structure/closet/walllocker_double/security/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker_double/security/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker_double/security/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker_double/security/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker_double/misc_civ
	closet_appearance = /decl/closet_appearance/wall_double/gaming

/obj/structure/closet/walllocker_double/misc_civ/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker_double/misc_civ/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker_double/misc_civ/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker_double/misc_civ/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker_double/generic_civ
	closet_appearance = /decl/closet_appearance/wall_double/generic_civ

/obj/structure/closet/walllocker_double/generic_civ/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker_double/generic_civ/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker_double/generic_civ/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker_double/generic_civ/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker_double/casino
	closet_appearance = /decl/closet_appearance/wall_double/casino

/obj/structure/closet/walllocker_double/casino/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker_double/casino/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker_double/casino/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker_double/casino/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker_double/cargo
	desc = "A wall mounted cabinet. This one is in cargo colors."
	closet_appearance = /decl/closet_appearance/wall_double/cargo

/obj/structure/closet/walllocker_double/cargo/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker_double/cargo/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker_double/cargo/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker_double/cargo/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker_double/science
	desc = "A wall mounted cabinet. This one is in research colors."
	closet_appearance = /decl/closet_appearance/wall_double/science

/obj/structure/closet/walllocker_double/science/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker_double/science/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker_double/science/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker_double/science/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker_double/command
	desc = "A wall mounted cabinet. This one is in command colors."
	closet_appearance = /decl/closet_appearance/wall_double/command

/obj/structure/closet/walllocker_double/command/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker_double/command/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker_double/command/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker_double/command/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker_double/command/ce
	closet_appearance = /decl/closet_appearance/wall_double/ce

/obj/structure/closet/walllocker_double/command/cmo
	closet_appearance = /decl/closet_appearance/wall_double/cmo

/obj/structure/closet/walllocker_double/command/rd
	closet_appearance = /decl/closet_appearance/wall_double/rd

/obj/structure/closet/walllocker_double/command/hos
	closet_appearance = /decl/closet_appearance/wall_double/hos

/obj/structure/closet/walllocker_double/command/iaa
	closet_appearance = /decl/closet_appearance/wall_double/iaa

/obj/structure/closet/walllocker_double/engineering
	desc = "A wall mounted cabinet. This one is in engineering colors."
	closet_appearance = /decl/closet_appearance/wall_double/engineering

/obj/structure/closet/walllocker_double/engineering/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker_double/engineering/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker_double/engineering/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker_double/engineering/east
	pixel_x = 32
	dir = EAST
