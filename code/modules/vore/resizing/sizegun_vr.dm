//
// Size Gun
//
/obj/item/gun/energy/sizegun
	name = "size gun" //I have no idea why this was called shrink ray when this increased and decreased size.
	desc = "A highly advanced ray gun with a knob on the side to adjust the size you desire. Warning: Do not insert into mouth."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "sizegun-shrink100"
	item_state = "sizegun"
	var/initial_icon_state = "sizegun"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_guns_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_guns_vr.dmi')
	fire_sound = 'sound/weapons/wave.ogg'
	charge_cost = 240
	projectile_type = /obj/item/projectile/beam/sizelaser
	origin_tech = list(TECH_BLUESPACE = 4)
	modifystate = "sizegun-shrink"
	battery_lock = 1
	var/backfire = 0
	var/size_set_to = 1
	firemodes = list(
		list(mode_name		= "select size",
			projectile_type	= /obj/item/projectile/beam/sizelaser,
			modifystate		= "sizegun-grow",
			fire_sound		= 'sound/weapons/pulse3.ogg'
		))

/obj/item/gun/energy/sizegun/New()
	..()
	verbs += /obj/item/gun/energy/sizegun/proc/select_size
	verbs += /obj/item/gun/energy/sizegun/proc/spin_dial

/obj/item/gun/energy/sizegun/attack_self(mob/user)
	. = ..()
	select_size()

/obj/item/gun/energy/sizegun/proc/spin_dial()
	set name = "Spin Size Dial"
	set category = "Object"
	set src in view(1)

	size_set_to = (rand(25,200)) /100
	usr.visible_message(span_warning("\The [usr] spins the size dial to a random value!"),span_notice("You spin the dial to a random value!"))

/obj/item/gun/energy/sizegun/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/beam/sizelaser/G = .
	if(istype(G))
		G.set_size = size_set_to

/obj/item/gun/energy/sizegun/proc/select_size()
	set name = "Select Size"
	set category = "Object"
	set src in view(1)

	var/size_select = tgui_input_number(usr, "Put the desired size (25-200%), (1-600%) in dormitory areas.", "Set Size", size_set_to * 100, 600, 1)
	if(!size_select)
		return //cancelled
	//We do valid resize testing in actual firings because people move after setting these things.
	//Just a basic clamp here to the valid ranges.
	size_set_to = clamp((size_select/100), RESIZE_MINIMUM_DORMS, RESIZE_MAXIMUM_DORMS)
	to_chat(usr, span_notice("You set the size to [size_select]%"))
	if(size_set_to < RESIZE_MINIMUM || size_set_to > RESIZE_MAXIMUM)
		to_chat(usr, span_notice("Note: Resizing limited to 25-200% automatically while outside dormatory areas.")) //hint that we clamp it in resize

/obj/item/gun/energy/sizegun/update_icon(var/ignore_inhands)
	var/grow_mode = "shrink"
	if(size_set_to > 1)
		grow_mode = "grow"
	if(charge_meter)
		var/ratio = power_supply.charge / power_supply.maxcharge

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, 0.25) * 100, 25)

		icon_state = "[initial_icon_state]-[grow_mode][ratio]"
		item_state = "[initial_icon_state]-[grow_mode]"

	if(!ignore_inhands) update_held_icon()

/obj/item/gun/energy/sizegun/examine(mob/user)
	. = ..()
	. += span_info("It is currently set at [size_set_to*100]%")

/obj/item/gun/energy/sizegun/admin
	name = "modified size gun"
	desc = "An older model sizegun, modified to be without limits on minimum/maximum size, and have an unlimited charge. Time to show 'em that size does matter."
	description_fluff = "A standard size gun that has been modified with \
	a distabilized bluespace element that has allowed the gun to break the \
	normal laws of physics and create a 'weapon' capable of sizing any \
	creature well beyond any conceivable size. Only a handfull of these \
	exist in the known universe and they are \
	exclusively owned by NanoTrasen for research purposes."
	icon_state = "sizegun_admin-shrink100"
	item_state = "sizegun_admin"
	initial_icon_state = "sizegun_admin"
	charge_cost = 0
	projectile_type = /obj/item/projectile/beam/sizelaser/admin

/datum/category_item/catalogue/anomalous/precursor_a/alien_sizegun
	name = "Precursor Alpha Object - Matter Manipulation Ray"
	desc = "This appears to be some sort of weapon and if someone were to pull \
	the trigger lopcated at the handle of the device it would fire a strong \
	laser at whatever it is pointed towards. While the laser certainly looks \
	dangerous, it is not, instead it is a powerful size manipulation spectrum \
	that is not disimilar to the size guns used by NanoTrasen.\
	<br><br>\
	It is unknown why the precursors would need such a device, possibly for \
	making it easier to transport large specimines. It is hard to tell \
	exactly what purpose such a device served the precursors but researchers \
	have their theories as they continue to analyse the technology."
	value = CATALOGUER_REWARD_MEDIUM

/obj/item/gun/energy/sizegun/admin/abductor
	name = "alien size gun"
	desc = "A strange looking ray gun weapon with an adjustor knob on the side. The design is alien, but it bares a striking resemblence to the older model size guns that NT uses for research."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_sizegun)
	icon_state = "sizegun-abductor-shrink100"
	item_state = "sizegun-abductor"
	initial_icon_state = "sizegun-abductor"
	charge_cost = 0
	projectile_type = /obj/item/projectile/beam/sizelaser/admin/alien

/obj/item/gun/energy/sizegun/admin/select_size()
	set name = "Select Size"
	set category = "Object"
	set src in view(1)

	var/size_select = tgui_input_number(usr, "Put the desired size (1-600%)", "Set Size", size_set_to * 100, 600, 1)
	if(!size_select)
		return //cancelled
	size_set_to = clamp((size_select/100), 0, 1000) //eheh
	to_chat(usr, span_notice("You set the size to [size_select]%"))

/obj/item/gun/energy/sizegun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	if(backfire)
		if(prob(50))
			to_chat(user, span_notice("\The [src] backfires and consumes its entire charge!"))
			Fire(user, user)
			power_supply.charge = 0
			var/mob/living/M = loc // TGMC Ammo HUD
			if(istype(M)) // TGMC Ammo HUD
				M?.hud_used.update_ammo_hud(M, src)
			return
		else
			return ..()
	else
		return ..()

/obj/item/gun/energy/sizegun/attack(atom/A, mob/living/user, adjacent, params)
	if(backfire)
		if(prob(50))
			to_chat(user, span_notice("\The [src] backfires and consumes its entire charge!"))
			Fire(user, user)
			power_supply.charge = 0
			var/mob/living/M = loc // TGMC Ammo HUD
			if(istype(M)) // TGMC Ammo HUD
				M?.hud_used.update_ammo_hud(M, src)
			return
		else
			return ..()
	else
		return ..()


/obj/item/gun/energy/sizegun/attackby(var/obj/item/A as obj, mob/user as mob)
	if(A.has_tool_quality(TOOL_WIRECUTTER))
		if(backfire)
			to_chat(user, span_warning("You repair the damage to the \the [src]."))
			backfire = 0
			name = "size gun"
		else
			to_chat(user, span_warning("You snip a wire on \the [src], making it less reliable."))
			backfire = 1
			name = "unstable size gun"
	..()

/obj/item/gun/energy/sizegun/backfire
	name = "unstable size gun"
	backfire = 1

/obj/item/gun/energy/sizegun/mounted
	name = "mounted size gun"
	self_recharge = 1
	use_external_power = 1
//
// Beams for size gun
//
/obj/item/projectile/beam/sizelaser
	name = "size beam"
	icon_state = "xray"
	nodamage = 1
	damage = 0
	check_armour = "laser"
	var/set_size = 1 //Let's default to 100%
	can_miss = FALSE

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/sizelaser/on_hit(var/atom/target)
	var/mob/living/M = target
	var/ignoring_prefs = (target == firer ? TRUE : FALSE) // Resizing yourself
	if(istype(M))
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(istype(H.gloves, /obj/item/clothing/gloves/bluespace))
				M.visible_message(span_warning("\The [H]'s bracelet flashes and absorbs the beam!"),span_notice("Your bracelet flashes and absorbs the beam!"))
				return
		if(!M.resize(set_size, uncapped = M.has_large_resize_bounds(), ignore_prefs = ignoring_prefs))
			to_chat(M, span_blue("The beam fires into your body, changing your size!"))
		M.update_icon()
		return
	return 1

/obj/item/projectile/beam/sizelaser/admin/on_hit(var/atom/target)
	var/mob/living/M = target

	if(istype(M))

		var/can_be_big = M.has_large_resize_bounds()
		var/very_big = is_extreme_size(set_size)

		if(very_big && can_be_big) // made an extreme size in an area that allows it, don't assume adminbuse
			to_chat(firer, span_warning("[M] will lose this size upon moving into an area where this size is not allowed."))
		else if(very_big) // made an extreme size in an area that doesn't allow it, assume adminbuse
			to_chat(firer, span_warning("[M] will retain this normally unallowed size outside this area."))

		M.resize(set_size, uncapped = TRUE, ignore_prefs = TRUE) // Always ignores prefs, caution is advisable

		to_chat(M, span_blue("The beam fires into your body, changing your size!"))
		M.update_icon()
		return
	return 1

/obj/item/projectile/beam/sizelaser/shrink
	set_size = 0.5 //50% of current size

/obj/item/projectile/beam/sizelaser/grow
	set_size = 2.0 //200% of current size

/obj/item/projectile/beam/sizelaser/admin/alien
	name = "alien size beam"
	icon_state = "darkb"

	muzzle_type = /obj/effect/projectile/muzzle/darkmatter
	tracer_type = /obj/effect/projectile/tracer/darkmatter
	impact_type = /obj/effect/projectile/impact/darkmatter
