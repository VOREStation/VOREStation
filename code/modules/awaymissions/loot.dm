/obj/effect/spawner/lootdrop
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	var/lootcount = 1		//how many items will be spawned
	var/lootdoubles = 0		//if the same item can be spawned twice
	var/loot = ""			//a list of possible items to spawn- a string of paths

/obj/effect/spawner/lootdrop/initialize()
	var/list/things = params2list(loot)

	if(things && things.len)
		for(var/i = lootcount, i > 0, i--)
			if(!things.len)
				return

			var/loot_spawn = pick(things)
			var/loot_path = text2path(loot_spawn)

			if(!loot_path || !lootdoubles)
				things.Remove(loot_spawn)
				continue

			new loot_path(get_turf(src))
	qdel(src)

/obj/effect/floor_decal/symbol
	name = "strange symbol"
	icon = 'icons/obj/decals_vr.dmi'

/obj/effect/floor_decal/symbol/ca
	desc = "It looks like a skull, or maybe a crown."
	icon_state = "ca"

/obj/effect/floor_decal/symbol/da
	desc = "It looks like a lightning bolt."
	icon_state = "da"

/obj/effect/floor_decal/symbol/em
	desc = "It looks like the letter 'Y' with an underline."
	icon_state = "em"

/obj/effect/floor_decal/symbol/es
	desc = "It looks like two horizontal lines, with a dotted line in the middle, like a highway, or race track."
	icon_state = "es"

/obj/effect/floor_decal/symbol/fe
	desc = "It looks like an arrow pointing upward. Maybe even a spade."
	icon_state = "fe"

/obj/effect/floor_decal/symbol/gu
	desc = "It looks like an unfolded square box from the top with a cross on it."
	icon_state = "gu"

/obj/effect/floor_decal/symbol/lo
	desc = "It looks kind of like a cup. Specifically, a martini glass."
	icon_state = "lo"

/obj/effect/floor_decal/symbol/pr
	desc = "It looks like a box with a cross on it."
	icon_state = "pr"

/obj/effect/floor_decal/symbol/sa
	desc = "It looks like a right triangle with a dot to the side. It reminds you of a wooden strut between a wall and ceiling."
	icon_state = "sa"