/*
 * Rigsuit upgrades/abilities.
 */

/datum/rig_charge
	var/short_name = "undef"
	var/display_name = "undefined"
	var/product_type = "undefined"
	var/charges = 0

/obj/item/rig_module
	name = "hardsuit upgrade"
	desc = "It looks pretty sciency."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "module"
	matter = list(MAT_STEEL = 20000, MAT_PLASTIC = 30000, MAT_GLASS = 5000)

	var/damage = 0
	var/obj/item/rig/holder

	var/module_cooldown = 10
	var/next_use = 0

	var/toggleable                      // Set to 1 for the device to show up as an active effect.
	var/usable                          // Set to 1 for the device to have an on-use effect.
	var/selectable                      // Set to 1 to be able to assign the device as primary system.
	var/redundant                       // Set to 1 to ignore duplicate module checking when installing.
	var/permanent                       // If set, the module can't be removed.
	var/disruptive = 1                  // Can disrupt by other effects.
	var/activates_on_touch              // If set, unarmed attacks will call engage() on the target.

	var/active                          // Basic module status
	var/disruptable                     // Will deactivate if some other powers are used.

	var/use_power_cost = 0              // Power used when single-use ability called.
	var/active_power_cost = 0           // Power used when turned on.
	var/passive_power_cost = 0          // Power used when turned off.

	var/list/charges                    // Associative list of charge types and remaining numbers.
	var/charge_selected                 // Currently selected option used for charge dispensing.

	// Icons.
	var/suit_overlay
	var/suit_overlay_icon = 'icons/mob/rig_modules.dmi'
	var/suit_overlay_active             // If set, drawn over icon and mob when effect is active.
	var/suit_overlay_inactive           // As above, inactive.
	var/suit_overlay_used               // As above, when engaged.

	//Display fluff
	var/interface_name = "hardsuit upgrade"
	var/interface_desc = "A generic hardsuit upgrade."
	var/engage_string = "Engage"
	var/activate_string = "Activate"
	var/deactivate_string = "Deactivate"

	var/list/stat_modules = new()

/obj/item/rig_module/examine()
	. = ..()
	switch(damage)
		if(0)
			. += "It is undamaged."
		if(1)
			. += "It is badly damaged."
		if(2)
			. += "It is almost completely destroyed."

/obj/item/rig_module/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W,/obj/item/stack/nanopaste))

		if(damage == 0)
			to_chat(user, "There is no damage to mend.")
			return

		to_chat(user, "You start mending the damaged portions of \the [src]...")

		if(!do_after(user,30) || !W || !src)
			return

		var/obj/item/stack/nanopaste/paste = W
		damage = 0
		to_chat(user, "You mend the damage to [src] with [W].")
		paste.use(1)
		return

	else if(istype(W,/obj/item/stack/cable_coil))

		switch(damage)
			if(0)
				to_chat(user, "There is no damage to mend.")
				return
			if(2)
				to_chat(user, "There is no damage that you are capable of mending with such crude tools.")
				return

		var/obj/item/stack/cable_coil/cable = W
		if(!cable.get_amount() >= 5)
			to_chat(user, "You need five units of cable to repair \the [src].")
			return

		to_chat(user, "You start mending the damaged portions of \the [src]...")
		if(!do_after(user,30) || !W || !src)
			return

		damage = 1
		to_chat(user, "You mend some of damage to [src] with [W], but you will need more advanced tools to fix it completely.")
		cable.use(5)
		return
	..()

/obj/item/rig_module/Initialize(mapload)
	. = ..()
	if(suit_overlay_inactive)
		suit_overlay = suit_overlay_inactive

	if(charges && charges.len)
		var/list/processed_charges = list()
		for(var/list/charge in charges)
			var/datum/rig_charge/charge_dat = new

			charge_dat.short_name   = charge[1]
			charge_dat.display_name = charge[2]
			charge_dat.product_type = charge[3]
			charge_dat.charges      = charge[4]

			if(!charge_selected) charge_selected = charge_dat.short_name
			processed_charges[charge_dat.short_name] = charge_dat

		charges = processed_charges

	stat_modules +=	new/atom/movable/stat_rig_module/activate(src)
	stat_modules +=	new/atom/movable/stat_rig_module/deactivate(src)
	stat_modules +=	new/atom/movable/stat_rig_module/engage(src)
	stat_modules +=	new/atom/movable/stat_rig_module/select(src)
	stat_modules +=	new/atom/movable/stat_rig_module/charge(src)

/obj/item/rig_module/Destroy()
	holder?.installed_modules -= src
	holder = null
	QDEL_NULL_LIST(stat_modules)
	. = ..()


// Called when the module is installed into a suit.
/obj/item/rig_module/proc/installed(var/obj/item/rig/new_holder)
	holder = new_holder
	return

//Proc for one-use abilities like teleport.
/obj/item/rig_module/proc/engage()

	if(damage >= 2)
		to_chat(usr, span_warning("The [interface_name] is damaged beyond use!"))
		return 0

	if(world.time < next_use)
		to_chat(usr, span_warning("You cannot use the [interface_name] again so soon."))
		return 0

	if(!holder || holder.canremove)
		to_chat(usr, span_warning("The suit is not initialized."))
		return 0

	if(usr.lying || usr.stat || usr.stunned || usr.paralysis || usr.weakened)
		to_chat(usr, span_warning("You cannot use the suit in this state."))
		return 0

	if(holder.wearer && holder.wearer.lying)
		to_chat(usr, span_warning("The suit cannot function while the wearer is prone."))
		return 0

	if(holder.security_check_enabled && !holder.check_suit_access(usr))
		to_chat(usr, span_danger("Access denied."))
		return 0

	if(!holder.check_power_cost(usr, use_power_cost, 0, src, (istype(usr,/mob/living/silicon ? 1 : 0) ) ) )
		return 0

	next_use = world.time + module_cooldown

	return 1

// Proc for toggling on active abilities.
/obj/item/rig_module/proc/activate(var/skip_engage = 0) //VOREStation Edit - Allow us to skip the engage call.
	//VOREStation Edit - Allow us to skip the engage call
	if(active)
		return 0
	if(!skip_engage && !engage())
		return 0
	//VOREStation Edit End
	active = 1

	spawn(1)
		if(suit_overlay_active)
			suit_overlay = suit_overlay_active
		else
			suit_overlay = null
		holder.update_icon()

	return 1

// Proc for toggling off active abilities.
/obj/item/rig_module/proc/deactivate()

	if(!active)
		return 0

	active = 0

	spawn(1)
		if(suit_overlay_inactive)
			suit_overlay = suit_overlay_inactive
		else
			suit_overlay = null
		if(holder)
			holder.update_icon()

	return 1

// Called when the module is uninstalled from a suit.
/obj/item/rig_module/proc/removed()
	deactivate()
	holder = null
	return

// Called by the hardsuit each rig process tick.
/obj/item/rig_module/process()
	if(active)
		return active_power_cost
	else
		return passive_power_cost

// Called by holder rigsuit attackby()
// Checks if an item is usable with this module and handles it if it is
/obj/item/rig_module/proc/accepts_item(var/obj/item/input_device)
	return 0

/atom/movable/stat_rig_module
	var/module_mode = ""
	var/obj/item/rig_module/module

/atom/movable/stat_rig_module/Initialize(mapload)
	. = ..()
	module = loc
	if(!istype(module))
		return INITIALIZE_HINT_QDEL

/atom/movable/stat_rig_module/Destroy()
	module = null
	. = ..()

/atom/movable/stat_rig_module/proc/AddHref(var/list/href_list)
	return

/atom/movable/stat_rig_module/proc/CanUse()
	return 0

/atom/movable/stat_rig_module/Click()
	if(CanUse())
		switch(module_mode)
			if("select")
				module.holder.selected_module = module
			if("engage")
				module.engage()
			if("activate")
				module.activate()
			if("deactivate")
				module.deactivate()
			if("toggle")
				if(module.active)
					module.deactivate()
				else
					module.activate()
			if("select_charge_type")
				module.charge_selected = module.charges[module.charges.Find(module.charge_selected)]

/atom/movable/stat_rig_module/DblClick()
	return Click()

/atom/movable/stat_rig_module/activate/Initialize(mapload)
	. = ..()
	if(!istype(module))
		return INITIALIZE_HINT_QDEL
	name = module.activate_string
	if(module.active_power_cost)
		name += " ([module.active_power_cost*10]A)"
	module_mode = "activate"

/atom/movable/stat_rig_module/activate/CanUse()
	return module.toggleable && !module.active

/atom/movable/stat_rig_module/deactivate/Initialize(mapload)
	. = ..()
	if(!istype(module))
		return INITIALIZE_HINT_QDEL
	name = module.deactivate_string
	// Show cost despite being 0, if it means changing from an active cost.
	if(module.active_power_cost || module.passive_power_cost)
		name += " ([module.passive_power_cost*10]P)"

	module_mode = "deactivate"

/atom/movable/stat_rig_module/deactivate/CanUse()
	return module.toggleable && module.active

/atom/movable/stat_rig_module/engage/Initialize(mapload)
	. = ..()
	if(!istype(module))
		return INITIALIZE_HINT_QDEL
	name = module.engage_string
	if(module.use_power_cost)
		name += " ([module.use_power_cost*10]E)"
	module_mode = "engage"

/atom/movable/stat_rig_module/engage/CanUse()
	return module.usable

/atom/movable/stat_rig_module/select/Initialize(mapload)
	. = ..()
	name = "Select"
	module_mode = "select"

/atom/movable/stat_rig_module/select/CanUse()
	if(module.selectable)
		name = module.holder.selected_module == module ? "Selected" : "Select"
		return 1
	return 0

/atom/movable/stat_rig_module/charge/Initialize(mapload)
	. = ..()
	name = "Change Charge"
	module_mode = "select_charge_type"

/atom/movable/stat_rig_module/charge/AddHref(var/list/href_list)
	var/charge_index = module.charges.Find(module.charge_selected)
	if(!charge_index)
		charge_index = 0
	else
		charge_index = charge_index == module.charges.len ? 1 : charge_index+1

	href_list["charge_type"] = module.charges[charge_index]

/atom/movable/stat_rig_module/charge/CanUse()
	if(module.charges && module.charges.len)
		var/datum/rig_charge/charge = module.charges[module.charge_selected]
		name = "[charge.display_name] ([charge.charges]C) - Change"
		return 1
	return 0
