/obj/item/material/butterfly
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	description_fluff = "This could be used to engrave messages on suitable surfaces if you really put your mind to it! Alt-click a floor or wall to engrave with it." //This way it's not a completely hidden, arcane art to engrave.
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

/obj/item/material/butterfly/update_force()
	if(active)
		edge = TRUE
		sharp = TRUE
		..() //Updates force.
		throwforce = max(3,force-3)
		hitsound = 'sound/weapons/bladeslice.ogg'
		icon_state += "_open"
		w_class = ITEMSIZE_NORMAL
		attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	else
		force = 3
		edge = FALSE
		sharp = FALSE
		hitsound = initial(hitsound)
		icon_state = initial(icon_state)
		w_class = initial(w_class)
		attack_verb = initial(attack_verb)

/obj/item/material/butterfly/switchblade
	name = "switchblade"
	desc = "A classic switchblade with gold engraving. Just holding it makes you feel like a gangster."
	icon_state = "switchblade"

/obj/item/material/butterfly/boxcutter
	name = "box cutter"
	desc = "A thin, inexpensive razor-blade knife designed to open cardboard boxes."
	icon_state = "boxcutter"
	force_divisor = 0.1 // 6 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.2 // 4 when thrown with weight 20 (steel)

/obj/item/material/butterfly/attack_self(mob/user)
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
/obj/item/material/knife
	name = "kitchen knife"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "knife"
	desc = "A general purpose Chef's Knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	description_fluff = "This could be used to engrave messages on suitable surfaces if you really put your mind to it! Alt-click a floor or wall to engrave with it." //This way it's not a completely hidden, arcane art to engrave.
	sharp = TRUE
	edge = TRUE
	force_divisor = 0.15 // 9 when wielded with hardness 60 (steel)
	matter = list(MAT_STEEL = 12000)
	origin_tech = list(TECH_MATERIAL = 1)
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	drop_sound = 'sound/items/drop/knife.ogg'

// These no longer inherit from hatchets.
/obj/item/material/knife/tacknife
	name = "tactical knife"
	desc = "You'd be killing loads of people if this was Medal of Valor: Heroes of Space."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	force_divisor = 0.25 //15 when hardness 60 (steel)
	attack_verb = list("stabbed", "chopped", "cut")
	applies_material_colour = 1

/obj/item/material/knife/tacknife/combatknife
	name = "combat knife"
	desc = "If only you had a boot to put it in."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife2"
	item_state = "knife"
	force_divisor = 0.34 // 20 with hardness 60 (steel)
	thrown_force_divisor = 1.75 // 20 with weight 20 (steel)
	attack_verb = list("sliced", "stabbed", "chopped", "cut")
	applies_material_colour = 1

// Identical to the tactical knife but nowhere near as stabby.
// Kind of like the toy esword compared to the real thing.
/obj/item/material/knife/tacknife/boot
	name = "boot knife"
	desc = "A small fixed-blade knife for putting inside a boot."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife3"
	item_state = "knife"
	force_divisor = 0.15
	applies_material_colour = 0

/obj/item/material/knife/hook
	name = "meat hook"
	desc = "A sharp, metal hook what sticks into things."
	icon_state = "hook_knife"

/obj/item/material/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	applies_material_colour = 0

/obj/item/material/knife/butch
	name = "butcher's cleaver"
	icon_state = "butch"
	desc = "A huge thing used for chopping and chopping up meat. This includes clowns and clown-by-products."
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/material/knife/table
	name = "table knife"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "knife_table"
	sharp = FALSE // blunted tip
	force_divisor = 0.1

/obj/item/material/knife/table/plastic
	default_material = "plastic"

/obj/item/material/knife/machete
	name = "machete"
	desc = "A sharp machete often found in survival kits."
	icon_state = "machete"
	force_divisor = 0.3 // 18 when hardness 60 (steel)
	attack_verb = list("slashed", "chopped", "gouged", "ripped", "cut")
	can_cleave = TRUE //Now hatchets inherit from the machete, and thus knives. Tables turned.
	slot_flags = SLOT_BELT
	default_material = "plasteel" //VOREStation Edit

/obj/item/material/knife/machete/cyborg
	name = "integrated machete"
	desc = "A sharp machete often found attached to robots."
	unbreakable = TRUE

/obj/item/material/knife/tacknife/survival
	name = "survival knife"
	desc = "A hunting grade survival knife."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "survivalknife"
	item_state = "knife"
	applies_material_colour = FALSE
	default_material = "plasteel" //VOREStation Edit
	toolspeed = 2 // Use a real axe if you want to chop logs.

/obj/item/material/knife/stone
	name = "stone blade"
	desc = "A crude blade made by chipping away at a piece of flint."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "stone_blade"
	applies_material_colour = FALSE
	fragile = TRUE
	dulled = TRUE
	edge = TRUE
	sharp = TRUE
	default_material = MAT_FLINT

/obj/item/material/knife/stone/wood
	name = "stone knife"
	desc = "A crude blade of flint with a wooden handle, secured with plant fibers twined into sturdy ropes. Useful for cutting, stabbing, slicing, and even shearing."
	icon_state = "stone_wood_knife"
	dulled = FALSE
	fragile = FALSE

/obj/item/material/knife/stone/bone
	name = "stone knife"
	desc = "A crude blade of flint with a bone handle, secured with plant fibers twined into sturdy ropes. Useful for cutting, stabbing, slicing, and even shearing."
	icon_state = "stone_bone_knife"
	dulled = FALSE
	fragile = FALSE
