// Robot Weapons
/obj/item/gun/energy/taser/mounted/cyborg/ertgun //Not a taser, but it's being used as a base so it takes energy and actually works.
	name = "disabler"
	desc = "A small and nonlethal gun produced by NT.."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "ertgunstun"
	fire_sound = 'sound/weapons/eLuger.ogg'
	projectile_type = /obj/item/projectile/beam/disable
	charge_cost = 240 //Normal cost of a taser. It used to be 1000, but after some testing it was found that it would sap a borg's battery to quick
	recharge_time = 10 //Takes ten ticks to recharge a shot, so don't waste them all!
	//cell_type = null //Same cell as a taser until edits are made.

/obj/item/gun/energy/robotic/flare
	name = "flare gun"
	desc = "A flare-gun"
	projectile_type = /obj/item/projectile/energy/flash/flare
	fire_sound = 'sound/weapons/tablehit1.ogg'
	icon = 'icons/obj/gun.dmi'
	icon_state = "taser"
	charge_cost = 480
	borg_flags = COUNTS_AS_ROBOT_GUN | COUNTS_AS_ROBOT_TASER

/obj/item/gun/energy/robotic/smallmedigun
	name = "borg directed restoration system"
	desc = "An adapted version of the BL-3 'Phoenix, for expiremental useage in borgs."
	projectile_type = /obj/item/projectile/beam/medical_cell/borg
	accept_cell_type = /obj/item/cell/device
	cell_type = /obj/item/cell/device/weapon
	charge_cost = 600
	fire_delay = 6
	force = 5
	icon_state = "medbeam"
	icon = 'icons/obj/gun_vr.dmi'
	accuracy = 100
	fire_sound = 'sound/weapons/eluger.ogg'
	self_recharge = 1
	use_external_power = 1

/obj/item/projectile/beam/medical_cell/borg
	range = 4

/obj/item/projectile/beam/medical_cell/borg/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		if(target.stat != DEAD)
			target.adjustBruteLoss(-3.75)
			target.adjustFireLoss(-3.75)
	else
		return 1

/obj/item/melee/robotic/blade/explotailspear
	name = "energy tail"
	desc = "A glowing tail spear with a moderate range. It appears to be extremely sharp."
	force = 45
	armor_penetration = 25 //30 to try and make it not useless against armored mobs but not fully nullify it.
	reach = 3
	projectile_parry_chance = 15.

/obj/item/melee/robotic/jaws/big/explojaws
	name = "explo jaws"
	desc = "Highly lethal jaws for close range combat."
	force = 60
	armor_penetration = 25 //To try and make it not useless against armored mobs but not fully nullify it
	projectile_parry_chance = 15

/obj/item/gun/energy/robotic/phasegun
	name = "EW26 Artemis Mounted"
	desc = "The RayZar EW26 Artemis, also known as the 'phase carbine', is a downsized energy-based weapon specifically designed for use against wildlife. This one has a safety interlock that prevents firing while in proximity to the facility."
	description_fluff = "RayZar is Ward-Takahashi’s main consumer weapons brand, known for producing and licensing a wide variety of specialist energy weapons of various types and quality primarily for the civilian market."
	icon = 'icons/obj/gun.dmi'
	icon_state = "phasecarbine"
	charge_cost = 160
	recharge_time = 16
	projectile_type = /obj/item/projectile/energy/phase
	use_external_power = 1
	self_recharge = 1
	borg_flags = COUNTS_AS_ROBOT_GUN | COUNTS_AS_ROBOT_LASER
