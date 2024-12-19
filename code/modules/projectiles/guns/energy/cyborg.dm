/// This file PRIMARILY contains guns for borgs. The key word being PRIMARILY.
/// Some things are included in here for relevence's sake (like the dogborg blade)


/obj/item/gun/energy/robotic/proc/gun_flag_check(var/flag_to_check) //Checks for the flag of the gun.
	return (borg_flags & flag_to_check)

/obj/item/melee/robotic/proc/weapon_flag_check(var/flag_to_check) //Checks for the flag of the gun.
	return (borg_flags & flag_to_check)

/// The base gun types. Build off these four.
/obj/item/gun/energy/robotic
	name = "Cybernetic Gun"
	desc = "A gun commonly used by cyborgs and other robotic lifeforms to stun"
	var/borg_flags = COUNTS_AS_ROBOT_GUN //We add flags to this!
	self_recharge = 1
	use_external_power = 1
	projectile_type = /obj/item/projectile/beam/lasertag //This is the base gun and should never be used.

/obj/item/gun/energy/robotic/laser
	borg_flags = COUNTS_AS_ROBOT_GUN | COUNTS_AS_ROBOT_LASER
	projectile_type = /obj/item/projectile/beam

/obj/item/gun/energy/robotic/taser
	name = "Cybernetic Taser"
	desc = "An integrated taser that is used to neutralize foes."
	borg_flags = COUNTS_AS_ROBOT_GUN | COUNTS_AS_ROBOT_TASER
	icon_state = "taser"
	item_state = null	//so the human update icon uses the icon_state instead.
	projectile_type = /obj/item/projectile/beam/stun
	charge_cost = 400
	recharge_time = 7 //Time it takes for shots to recharge (in ticks)

/obj/item/gun/energy/robotic/disabler
	borg_flags = COUNTS_AS_ROBOT_GUN | COUNTS_AS_ROBOT_DISABLER
	name = "disabler"
	desc = "A small and nonlethal gun produced by NT.."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "ertgunstun"
	fire_sound = 'sound/weapons/eLuger.ogg'
	projectile_type = /obj/item/projectile/beam/disable
	charge_cost = 240
	recharge_time = 10



/// Variant gun types


/// Tasers
/obj/item/gun/energy/robotic/taser/xeno
	name = "xeno taser gun"
	desc = "Straight out of NT's testing laboratories, this small gun is used to subdue non-humanoid xeno life forms. \
	While marketed towards handling slimes, it may be useful for other creatures."
	icon_state = "taserblue"
	fire_sound = 'sound/weapons/taser2.ogg'
	charge_cost = 120
	projectile_type = /obj/item/projectile/beam/stun/xeno
	accuracy = 30
	description_info = "This gun will stun a slime or other lesser slimy lifeform for about two seconds if hit with the projectile it fires."
	description_fluff = "An easy to use weapon designed by NanoTrasen, for NanoTrasen. This weapon is based on the NT Mk30 NL, \
	it's core components swaped out for a new design made to subdue lesser slime-based xeno lifeforms at a distance.  It is \
	ineffective at stunning non-slimy lifeforms such as humanoids."
	recharge_time = 3

/obj/item/gun/energy/robotic/taser/swarm
	name = "disabler"
	desc = "An archaic device which attacks the target's nervous-system or control circuits."
	icon_state = "disabler"
	projectile_type = /obj/item/projectile/beam/stun/disabler
	charge_cost = 800
	recharge_time = 5 //0.5 SECONDS


/// Lasers
/obj/item/gun/energy/robotic/laser/retro
	name = "retro laser"
	icon_state = "retro"
	item_state = "retro"
	desc = "A 23rd century model of the basic lasergun. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."
	projectile_type = /obj/item/projectile/beam
	fire_delay = 10

/obj/item/gun/energy/robotic/laser/rifle
	name = "Mounted Laser Rifle"
	desc = "A Hephaestus Industries G40E rifle, designed to kill with concentrated energy blasts.  This variant has the ability to \
	switch between standard fire and a more efficent but weaker 'suppressive' fire."
	description_fluff = "The leading arms producer in the SCG, Hephaestus typically only uses its 'top level' branding for its military-grade equipment used by armed forces across human space."
	icon_state = "laser"
	item_state = "laser"
	wielded_item_state = "laser-wielded"
	fire_delay = 8
	force = 10
	projectile_type = /obj/item/projectile/beam/midlaser
	firemodes = list(
		list(mode_name="normal", fire_delay=8, projectile_type=/obj/item/projectile/beam/midlaser, charge_cost = 240),
		list(mode_name="suppressive", fire_delay=5, projectile_type=/obj/item/projectile/beam/weaklaser, charge_cost = 60),
		)
	one_handed_penalty = 0

/obj/item/gun/energy/robotic/laser/heavy
	name = "mounted laser cannon"
	desc = "With the laser cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron \
	flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	item_state = null
	wielded_item_state = "mhdhowitzer-wielded" //Placeholder (Sure it is.)
	projectile_type = /obj/item/projectile/beam/heavylaser //Fun fact: This isn't actually the normal cannon.
	recharge_time = 10
	accuracy = 0
	one_handed_penalty = 0
	charge_cost = 400
	fire_delay = 20

/obj/item/gun/energy/robotic/laser/dakkalaser
	name = "suppression gun"
	desc = "A massive weapon designed to pressure the opposition by raining down a torrent of energy pellets."
	icon_state = "dakkalaser"
	item_state = "dakkalaser"
	wielded_item_state = "dakkalaser-wielded"
	charge_cost = 24
	projectile_type = /obj/item/projectile/energy/blue_pellet
	cell_type = /obj/item/cell/device/weapon/recharge //This one doesn't use borg power, it has it's own power cell. I don't know why, but I'm not here to balance/unbalance it.
	self_recharge = 0 //Ditto
	use_external_power = 0 //Ditto
	accuracy = 75 // Suppressive weapons don't work too well if there's no risk of being hit.
	burst_delay = 1 // Burst faster than average.

	firemodes = list(
		list(mode_name="single shot", burst = 1, burst_accuracy = list(75), dispersion = list(0), charge_cost = 24),
		list(mode_name="five shot burst", burst = 5, burst_accuracy = list(75,75,75,75,75), dispersion = list(1,1,1,1,1)),
		list(mode_name="ten shot burst", burst = 10, burst_accuracy = list(75,75,75,75,75,75,75,75,75,75), dispersion = list(2,2,2,2,2,2,2,2,2,2)),
		)


/// MELEE WEAPONS

/obj/item/melee/robotic //Just the parent. Don't use this one.
	name = "Robotic Appendage"
	desc = "A robotic weapon of some sort."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "swordtail"
	var/borg_flags = COUNTS_AS_ROBOTIC_MELEE

/obj/item/melee/robotic/jaws
	icon = 'icons/mob/dogborg_vr.dmi'
	hitsound = 'sound/weapons/bite.ogg'
	throwforce = 0
	w_class = ITEMSIZE_NORMAL
	pry = 1
	tool_qualities = list(TOOL_CROWBAR)

/obj/item/melee/robotic/jaws/big
	name = "combat jaws"
	icon_state = "jaws"
	desc = "The jaws of the law."
	force = 25
	armor_penetration = 25
	defend_chance = 15
	attack_verb = list("chomped", "bit", "ripped", "mauled", "enforced")

/obj/item/melee/robotic/jaws/small
	name = "puppy jaws"
	icon_state = "smalljaws"
	desc = "The jaws of a small dog."
	force = 10
	defend_chance = 5
	attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")
	var/emagged = 0
/obj/item/melee/robotic/jaws/small/attack_self(mob/user)
	var/mob/living/silicon/robot/R = user
	if(R.emagged || R.emag_items)
		emagged = !emagged
		if(emagged)
			name = "combat jaws"
			icon_state = "jaws"
			desc = "The jaws of the law."
			force = 25
			armor_penetration = 25
			defend_chance = 15
			attack_verb = list("chomped", "bit", "ripped", "mauled", "enforced")
		else
			name = "puppy jaws"
			icon_state = "smalljaws"
			desc = "The jaws of a small dog."
			force = 10
			armor_penetration = 0
			defend_chance = 5
			attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")
		update_icon()


/obj/item/melee/robotic/borg_combat_shocker
	name = "combat shocker"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "combatshocker"
	desc = "Shocking!"
	force = 15
	throwforce = 0
	hitsound = 'sound/weapons/genhit1.ogg'
	attack_verb = list("hit")
	w_class = ITEMSIZE_NORMAL
	var/charge_cost = 15
	var/dogborg = FALSE

/obj/item/melee/robotic/borg_combat_shocker/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(isrobot(target))
		return ..()

	var/agony = 60 // Copied from stun batons
	var/stun = 0 // ... same

	var/obj/item/organ/external/affecting = null
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		affecting = H.get_organ(hit_zone)

	if(user.a_intent == I_HURT)
		// Parent handles messages
		. = ..()
		//whacking someone causes a much poorer electrical contact than deliberately prodding them.
		agony *= 0.5
		stun *= 0.5
	else
		if(affecting)
			if(dogborg)
				target.visible_message(span_danger("[target] has been zap-chomped in the [affecting.name] with [src] by [user]!"))
			else
				target.visible_message(span_danger("[target] has been zapped in the [affecting.name] with [src] by [user]!"))
		else
			if(dogborg)
				target.visible_message(span_danger("[target] has been zap-chomped with [src] by [user]!"))
			else
				target.visible_message(span_danger("[target] has been zapped with [src] by [user]!"))
		playsound(src, 'sound/weapons/Egloves.ogg', 50, 1, -1)

	// Try to use power
	var/stunning = FALSE
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R.cell?.use(charge_cost) == charge_cost)
			stunning = TRUE

	if(stunning)
		target.stun_effect_act(stun, agony, hit_zone, src)
		msg_admin_attack("[key_name(user)] stunned [key_name(target)] with the [src].")
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.forcesay(hit_appends)

/obj/item/melee/robotic/blade //For downstreams that use blade
	name = "Robotic Blade"
	desc = "A glowing blade. It appears to be extremely sharp."
	borg_flags = COUNTS_AS_ROBOTIC_MELEE | COUNTS_AS_ROBOT_BLADE
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "swordtail"
	force = 35 //Takes 3 hits to 100-0
	armor_penetration = 70
	sharp = TRUE
	edge = TRUE
	throwforce = 0 //This shouldn't be thrown in the first place.
	hitsound = 'sound/weapons/blade1.ogg'
	attack_verb = list("slashed", "stabbed", "jabbed", "mauled", "sliced")
	w_class = ITEMSIZE_NORMAL

/obj/item/melee/robotic/dagger //For downstreams that use dagger
	name = "Robotic Dagger"
	desc = "A glowing dagger. It appears to be extremely sharp."
	borg_flags = COUNTS_AS_ROBOTIC_MELEE | COUNTS_AS_ROBOT_DAGGER
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "swordtail"
	force = 35 //Takes 3 hits to 100-0
	armor_penetration = 70
	sharp = TRUE
	edge = TRUE
	throwforce = 0 //This shouldn't be thrown in the first place.
	hitsound = 'sound/weapons/blade1.ogg'
	attack_verb = list("slashed", "stabbed", "jabbed", "mauled", "sliced")
	w_class = ITEMSIZE_NORMAL
