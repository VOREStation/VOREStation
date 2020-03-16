/////// Smartfridges ///////
/obj/machinery/smartfridge
	icon = 'icons/obj/vending_vr.dmi'
	icon_state = "fridge_sci"
	var/icon_base = "fridge_sci"
	var/icon_contents = "chem"
	var/expert_job = "Scientist"

// Science
/obj/machinery/smartfridge/secure/extract
	icon_contents = "slime"
	expert_job = "Xenobiologist"

// Medical
/obj/machinery/smartfridge/secure/medbay
	icon_state = "fridge_sci"
	icon_base = "fridge_sci"
	icon_contents = "chem"
	expert_job = "Chemist"

/obj/machinery/smartfridge/secure/virology
	icon_state = "fridge_sci"
	icon_base = "fridge_sci"
	icon_contents = "chem"
	expert_job = "Medical Doctor"

/obj/machinery/smartfridge/chemistry //What is this one even for?
	icon_state = "fridge_sci"
	icon_base = "fridge_sci"
	icon_contents = "chem"
	expert_job = "Chemist"

/obj/machinery/smartfridge/chemistry/virology
	expert_job = "Medical Doctor"

// Food 'n Drink
/obj/machinery/smartfridge/drinks
	icon_state = "fridge_dark"
	icon_base = "fridge_dark"
	icon_contents = "drink"
	expert_job = "Bartender"

/obj/machinery/smartfridge/foods
	icon_state = "fridge_food"
	icon_base = "fridge_food"
	icon_contents = "food"
	expert_job = "Chef"

/obj/machinery/smartfridge/drying_rack
	icon_state = "drying_rack"
	icon_base = "drying_rack"
	expert_job = "Botanist"

/obj/machinery/smartfridge/seeds
	expert_job = "Botanist"

/obj/machinery/smartfridge/Initialize()
	. = ..()
	//Just a hack to avoid rewriting the Polaris icon system for these
	icon_on = "[icon_base]"
	icon_off = "[icon_base]-off"
	icon_panel = "[icon_base]-panel"
	update_icon()

/obj/machinery/smartfridge/vend()
	. = ..()
	update_icon()

/obj/machinery/smartfridge/stock()
	. = ..()
	update_icon()

// Allow thrown items into smartfridges
/obj/machinery/smartfridge/throw_impact(var/atom/movable/A)
	. = ..()
	if(accept_check(A) && A.thrower)
		//Try to find what job they are via ID
		var/obj/item/weapon/card/id/thrower_id
		if(ismob(A.thrower))
			var/mob/T = A.thrower
			thrower_id = T.GetIdCard()
		
		//98% chance the expert makes it
		if(expert_job && thrower_id && thrower_id.rank == expert_job && prob(98))
			stock(A)
		
		//20% chance a non-expert makes it
		else if(prob(20))
			stock(A)

/obj/machinery/smartfridge/update_icon()
	cut_overlays()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "[icon_base]-off"
	else
		icon_state = icon_base

	if(is_secure)
		add_overlay("[icon_base]-sidepanel")

	if(panel_open)
		add_overlay("[icon_base]-panel")

	var/is_off = ""
	if(inoperable())
		is_off = "-off"

	// Fridge contents
	switch(contents.len)
		if(0)
			add_overlay("empty[is_off]")
		if(1 to 2)
			add_overlay("[icon_contents]-1[is_off]")
		if(3 to 5)
			add_overlay("[icon_contents]-2[is_off]")
		if(6 to 8)
			add_overlay("[icon_contents]-3[is_off]")
		else
			add_overlay("[icon_contents]-4[is_off]")

	// Fridge top
	var/image/I = image(icon, "[icon_base]-top")
	I.pixel_z = 32
	I.layer = ABOVE_WINDOW_LAYER
	add_overlay(I)
