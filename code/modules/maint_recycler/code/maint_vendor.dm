/obj/machinery/maint_vendor
	name = "decrepit machine"
	desc = "A long since abandoned \"trash 4 cash\" rewards kiosk. Now featuring a state of the art, monochrome holographic tube display!"
	icon = 'code/modules/maint_recycler/icons/maint_vendor.dmi'
	icon_state = 'default'

	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10

	description_info = "With points you get from another, similar machine in maint - you can redeem various goodies!"
	description_fluff = "While the \"Trash 4 Cash\" recycling campaign came to an end decades ago, the underlying systems still work as well as ever."


	var/item_creation_energy_use = 400 //old and clunky
