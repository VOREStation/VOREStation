/obj/item/weapon/material/butterfly
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	icon_state = "butterflyknife"
	item_state = null
	hitsound = null
	var/active = 0
	w_class = ITEMSIZE_SMALL
	attack_verb = list("patted", "tapped")
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 when thrown with weight 20 (steel)
	drop_sound = 'sound/items/drop/knife.ogg'
	pickup_sound = 'sound/items/pickup/knife.ogg'

/obj/item/weapon/material/butterfly/update_force()
	if(active)
		edge = 1
		sharp = 1
		..() //Updates force.
		throwforce = max(3,force-3)
		hitsound = 'sound/weapons/bladeslice.ogg'
		icon_state += "_open"
		w_class = ITEMSIZE_NORMAL
		attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	else
		force = 3
		edge = 0
		sharp = 0
		hitsound = initial(hitsound)
		icon_state = initial(icon_state)
		w_class = initial(w_class)
		attack_verb = initial(attack_verb)

/obj/item/weapon/material/butterfly/switchblade
	name = "switchblade"
	desc = "A classic switchblade with gold engraving. Just holding it makes you feel like a gangster."
	icon_state = "switchblade"

/obj/item/weapon/material/butterfly/boxcutter
	name = "box cutter"
	desc = "A thin, inexpensive razor-blade knife designed to open cardboard boxes."
	icon_state = "boxcutter"
	force_divisor = 0.1 // 6 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.2 // 4 when thrown with weight 20 (steel)

/obj/item/weapon/material/butterfly/attack_self(mob/user)
	active = !active
	update_force()

	if(user)
		if(active)
			to_chat(user, "<span class='notice'>You flip out \the [src].</span>")
			playsound(src, 'sound/weapons/flipblade.ogg', 15, 1)
		else
			to_chat(user, "<span class='notice'>\The [src] can now be concealed.</span>")
		add_fingerprint(user)

/*
 * Kitchen knives
 */
/obj/item/weapon/material/knife
	name = "kitchen knife"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "knife"
	desc = "A general purpose Chef's Knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	sharp = 1
	edge = 1
	force_divisor = 0.15 // 9 when wielded with hardness 60 (steel)
	matter = list(DEFAULT_WALL_MATERIAL = 12000)
	origin_tech = list(TECH_MATERIAL = 1)
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	drop_sound = 'sound/items/drop/knife.ogg'

/obj/item/weapon/material/knife/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	to_chat(viewers(user), pick("<span class='danger'>\The [user] is slitting [TU.his] wrists with \the [src]! It looks like [TU.hes] trying to commit suicide.</span>", \
	                      "<span class='danger'>\The [user] is slitting [TU.his] throat with \the [src]! It looks like [TU.hes] trying to commit suicide.</span>", \
	                      "<span class='danger'>\The [user] is slitting [TU.his] stomach open with \the [src]! It looks like [TU.hes] trying to commit seppuku.</span>"))
	return (BRUTELOSS)

// These no longer inherit from hatchets.
/obj/item/weapon/material/knife/tacknife
	name = "tactical knife"
	desc = "You'd be killing loads of people if this was Medal of Valor: Heroes of Space."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	force_divisor = 0.25 //15 when hardness 60 (steel)
	attack_verb = list("stabbed", "chopped", "cut")
	applies_material_colour = 1

/obj/item/weapon/material/knife/tacknife/combatknife
	name = "combat knife"
	desc = "If only you had a boot to put it in."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	force_divisor = 0.34 // 20 with hardness 60 (steel)
	thrown_force_divisor = 1.75 // 20 with weight 20 (steel)
	attack_verb = list("sliced", "stabbed", "chopped", "cut")
	applies_material_colour = 1

// Identical to the tactical knife but nowhere near as stabby.
// Kind of like the toy esword compared to the real thing.
/obj/item/weapon/material/knife/tacknife/boot
	name = "boot knife"
	desc = "A small fixed-blade knife for putting inside a boot."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	force_divisor = 0.15
	applies_material_colour = 0

/obj/item/weapon/material/knife/hook
	name = "meat hook"
	desc = "A sharp, metal hook what sticks into things."
	icon_state = "hook_knife"

/obj/item/weapon/material/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	applies_material_colour = 0

/obj/item/weapon/material/knife/butch
	name = "butcher's cleaver"
	icon_state = "butch"
	desc = "A huge thing used for chopping and chopping up meat. This includes clowns and clown-by-products."
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/weapon/material/knife/machete
	name = "machete"
	desc = "A sharp machete often found in survival kits."
	icon_state = "machete"
	force_divisor = 0.3 // 18 when hardness 60 (steel)
	attack_verb = list("slashed", "chopped", "gouged", "ripped", "cut")
	can_cleave = TRUE //Now hatchets inherit from the machete, and thus knives. Tables turned.
	slot_flags = SLOT_BELT
	default_material = "plasteel" //VOREStation Edit

/obj/item/weapon/material/knife/tacknife/survival
	name = "survival knife"
	desc = "A hunting grade survival knife."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "survivalknife"
	item_state = "knife"
	applies_material_colour = FALSE
	default_material = "plasteel" //VOREStation Edit
	toolspeed = 2 // Use a real axe if you want to chop logs.
