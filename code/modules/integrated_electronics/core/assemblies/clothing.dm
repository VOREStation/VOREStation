
// The base subtype for assemblies that can be worn. Certain pieces will have more or less capabilities
// E.g. Glasses have less room than something worn over the chest.
// Note that the electronic assembly is INSIDE the object that actually gets worn, in a similar way to implants.

/obj/item/device/electronic_assembly/clothing
	name = "electronic clothing"
	icon_state = "circuitry" // Needs to match the clothing's base icon_state.
	desc = "It's a case, for building machines attached to clothing."
	w_class = ITEMSIZE_SMALL
	max_components = IC_COMPONENTS_BASE
	max_complexity = IC_COMPLEXITY_BASE
	var/obj/item/clothing/clothing = null

/obj/item/device/electronic_assembly/clothing/nano_host()
	return clothing

/obj/item/device/electronic_assembly/clothing/resolve_nano_host()
	return clothing

/obj/item/device/electronic_assembly/clothing/update_icon()
	..()
	clothing.icon_state = icon_state
	// We don't need to update the mob sprite since it won't (and shouldn't) actually get changed.

// This is 'small' relative to the size of regular clothing assemblies.
/obj/item/device/electronic_assembly/clothing/small
	max_components = IC_COMPONENTS_BASE / 2
	max_complexity = IC_COMPLEXITY_BASE / 2
	w_class = ITEMSIZE_TINY

// Ditto.
/obj/item/device/electronic_assembly/clothing/large
	max_components = IC_COMPONENTS_BASE * 2
	max_complexity = IC_COMPLEXITY_BASE * 2
	w_class = ITEMSIZE_NORMAL


// This is defined higher up, in /clothing to avoid lots of copypasta.
/obj/item/clothing
	var/obj/item/device/electronic_assembly/clothing/IC = null
	var/obj/item/integrated_circuit/built_in/action_button/action_circuit = null // This gets pulsed when someone clicks the button on the hud.

/obj/item/clothing/emp_act(severity)
	if(IC)
		IC.emp_act(severity)
	..()

/obj/item/clothing/examine(mob/user)
	. = ..()
	if(IC)
		. += IC.examine(user)

/obj/item/clothing/CtrlShiftClick(mob/user)
	var/turf/T = get_turf(src)
	if(!T.AdjacentQuick(user)) // So people aren't messing with these from across the room
		return FALSE
	var/obj/item/I = user.get_active_hand() // ctrl-shift-click doesn't give us the item, we have to fetch it
	return IC.attackby(I, user)

/obj/item/clothing/attack_self(mob/user)
	if(IC)
		if(IC.opened)
			IC.attack_self(user)
		else
			action_circuit.do_work()
	else
		..()

/obj/item/clothing/Moved(oldloc)
	if(IC)
		IC.on_loc_moved(oldloc)
	else
		..()

/obj/item/clothing/on_loc_moved(oldloc)
	if(IC)
		IC.on_loc_moved(oldloc)
	else
		..()

// Does most of the repeatative setup.
/obj/item/clothing/proc/setup_integrated_circuit(new_type)
	// Set up the internal circuit holder.
	IC = new new_type(src)
	IC.clothing = src
	IC.name = name

	// Clothing assemblies can be triggered by clicking on the HUD. This allows that to occur.
	action_circuit = new(src.IC)
	IC.force_add_circuit(action_circuit)
	action_button_name = "Activate [name]"

/obj/item/clothing/Destroy()
	if(IC)
		IC.clothing = null
		action_circuit = null // Will get deleted by qdel-ing the IC assembly.
		qdel(IC)
	return ..()

// Specific subtypes.

// Jumpsuit.
/obj/item/clothing/under/circuitry
	name = "electronic jumpsuit"
	desc = "It's a wearable case for electronics. This on is a black jumpsuit with wiring weaved into the fabric."
	description_info = "Control-shift-click on this with an item in hand to use it on the integrated circuit."
	icon_state = "circuitry"
	worn_state = "circuitry"

/obj/item/clothing/under/circuitry/Initialize()
	setup_integrated_circuit(/obj/item/device/electronic_assembly/clothing)
	return ..()


// Gloves.
/obj/item/clothing/gloves/circuitry
	name = "electronic gloves"
	desc = "It's a wearable case for electronics. This one is a pair of black gloves, with wires woven into them. A small \
	device with a screen is attached to the left glove."
	description_info = "Control-shift-click on this with an item in hand to use it on the integrated circuit."
	icon_state = "circuitry"
	item_state = "circuitry"

/obj/item/clothing/gloves/circuitry/Initialize()
	setup_integrated_circuit(/obj/item/device/electronic_assembly/clothing/small)
	return ..()


// Glasses.
/obj/item/clothing/glasses/circuitry
	name = "electronic goggles"
	desc = "It's a wearable case for electronics. This one is a pair of goggles, with wiring sticking out. \
	Could this augment your vision?" // Sadly it won't, or at least not yet.
	description_info = "Control-shift-click on this with an item in hand to use it on the integrated circuit."
	icon_state = "circuitry"
	item_state = "night" // The on-mob sprite would be identical anyways.

/obj/item/clothing/glasses/circuitry/Initialize()
	setup_integrated_circuit(/obj/item/device/electronic_assembly/clothing/small)
	return ..()

// Shoes
/obj/item/clothing/shoes/circuitry
	name = "electronic boots"
	desc = "It's a wearable case for electronics. This one is a pair of boots, with wires attached to a small \
	cover."
	description_info = "Control-shift-click on this with an item in hand to use it on the integrated circuit."
	icon_state = "circuitry"
	item_state = "circuitry"

/obj/item/clothing/shoes/circuitry/Initialize()
	setup_integrated_circuit(/obj/item/device/electronic_assembly/clothing/small)
	return ..()

// Head
/obj/item/clothing/head/circuitry
	name = "electronic headwear"
	desc = "It's a wearable case for electronics. This one appears to be a very technical-looking piece that \
	goes around the collar, with a heads-up-display attached on the right."
	description_info = "Control-shift-click on this with an item in hand to use it on the integrated circuit."
	icon_state = "circuitry"
	item_state = "circuitry"

/obj/item/clothing/head/circuitry/Initialize()
	setup_integrated_circuit(/obj/item/device/electronic_assembly/clothing/small)
	return ..()

// Ear
/obj/item/clothing/ears/circuitry
	name = "electronic earwear"
	desc = "It's a wearable case for electronics. This one appears to be a technical-looking headset."
	description_info = "Control-shift-click on this with an item in hand to use it on the integrated circuit."
	icon = 'icons/obj/clothing/ears.dmi'
	icon_state = "circuitry"
	item_state = "circuitry"

/obj/item/clothing/ears/circuitry/Initialize()
	setup_integrated_circuit(/obj/item/device/electronic_assembly/clothing/small)
	return ..()

// Exo-slot
/obj/item/clothing/suit/circuitry
	name = "electronic chestpiece"
	desc = "It's a wearable case for electronics. This one appears to be a very technical-looking vest, that \
	almost looks professionally made, however the wiring popping out betrays that idea."
	description_info = "Control-shift-click on this with an item in hand to use it on the integrated circuit."
	icon_state = "circuitry"
	item_state = "circuitry"

/obj/item/clothing/suit/circuitry/Initialize()
	setup_integrated_circuit(/obj/item/device/electronic_assembly/clothing/large)
	return ..()

/obj/item/clothing/attackby(var/obj/item/I, var/mob/user)
	if(IC != null)
		if(istype(I, /obj/item/integrated_circuit))
			if(!user.unEquip(I) && !istype(user, /mob/living/silicon/robot)) //Robots cannot de-equip items in grippers.
				return FALSE
			if(IC.add_circuit(I, user))
				to_chat(user, "<span class='notice'>You slide \the [I] inside \the [src].</span>")
				playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
				interact(user)
				return TRUE

		else if(I.is_crowbar())
			playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
			IC.opened = !IC.opened
			to_chat(user, "<span class='notice'>You [IC.opened ? "opened" : "closed"] \the [src].</span>")
			update_icon()
			return TRUE

		else if(istype(I, /obj/item/device/integrated_electronics/wirer) || istype(I, /obj/item/device/integrated_electronics/debugger) || I.is_screwdriver())
			if(IC.opened)
				interact(user)
				return TRUE
			else
				to_chat(user, "<span class='warning'>\The [src] isn't opened, so you can't fiddle with the internal components.  \
				Try using a crowbar.</span>")
				return FALSE
		else if(istype(I, /obj/item/weapon/cell/device))
			if(!IC.opened)
				to_chat(user, "<span class='warning'>\The [src] isn't opened, so you can't put anything inside.  Try using a crowbar.</span>")
				return FALSE
			if(IC.battery)
				to_chat(user, "<span class='warning'>\The [src] already has \a [IC.battery] inside.  Remove it first if you want to replace it.</span>")
				return FALSE
			var/obj/item/weapon/cell/device/cell = I
			user.drop_item(cell)
			cell.forceMove(src)
			IC.battery = cell
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You slot \the [cell] inside \the [src]'s power supplier.</span>")
			interact(user)
			return TRUE

		else
			return ..()
	else
		return ..()