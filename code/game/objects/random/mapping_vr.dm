/obj/random/empty_or_lootable_crate
	name = "random crate"
	desc = "Spawns a random crate which may or may not have contents. Sometimes spawns nothing."
	icon = 'icons/obj/storage.dmi'
	icon_state = "moneybag"
	spawn_nothing_percentage = 20

/obj/random/empty_or_lootable_crate/item_to_spawn()
	return pick(/obj/random/crate,
			/obj/random/multiple/corp_crate)