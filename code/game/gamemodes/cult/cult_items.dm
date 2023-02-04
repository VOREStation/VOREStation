/obj/item/weapon/melee/cultblade
	name = "cult blade"
	desc = "An arcane weapon wielded by the followers of an unknown god."
	icon_state = "cultblade"
	origin_tech = list(TECH_COMBAT = 1, TECH_ARCANE = 1)
	w_class = ITEMSIZE_LARGE
	force = 30
	throwforce = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	edge = TRUE
	sharp = TRUE

/obj/item/weapon/melee/cultblade/cultify()
	return

/obj/item/weapon/melee/cultblade/attack(mob/living/M, mob/living/user, var/target_zone)
	if(iscultist(user) && !istype(user, /mob/living/simple_mob/construct))
		return ..()

	var/zone = (user.hand ? "l_arm":"r_arm")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ(zone)
		to_chat(user, "<span class='danger'>An inexplicable force rips through your [affecting.name], tearing the sword from your grasp!</span>")
		//random amount of damage between half of the blade's force and the full force of the blade.
		user.apply_damage(rand(force/2, force), BRUTE, zone, 0, sharp = TRUE, edge = TRUE)
		user.Weaken(5)
	else if(!istype(user, /mob/living/simple_mob/construct))
		to_chat(user, "<span class='danger'>An inexplicable force rips through you, tearing the sword from your grasp!</span>")
	else
		to_chat(user, "<span class='critical'>The blade hisses, forcing itself from your manipulators. \The [src] will only allow mortals to wield it against foes, not kin.</span>")

	user.drop_from_inventory(src, src.loc)
	throw_at(get_edge_target_turf(src, pick(alldirs)), rand(1,3), throw_speed)

	var/spooky = pick('sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg', 'sound/hallucinations/growl3.ogg', 'sound/hallucinations/wail.ogg')
	playsound(src, spooky, 50, 1)

	return 1

/obj/item/weapon/melee/cultblade/pickup(mob/living/user as mob)
	if(!iscultist(user) && !istype(user, /mob/living/simple_mob/construct))
		to_chat(user, "<span class='warning'>An overwhelming feeling of dread comes over you as you pick up the cultist's sword. It would be wise to be rid of this blade quickly.</span>")
		user.make_dizzy(120)
	if(istype(user, /mob/living/simple_mob/construct))
		to_chat(user, "<span class='warning'>\The [src] hisses, as it is discontent with your acquisition of it. It would be wise to return it to a worthy mortal quickly.</span>")

/obj/item/clothing/head/culthood
	name = "cult hood"
	icon_state = "culthood"
	desc = "A hood worn by the followers of an unknown god."
	origin_tech = list(TECH_MATERIAL = 3, TECH_ARCANE = 1)
	flags_inv = HIDEFACE
	body_parts_covered = HEAD
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 80, bomb = 25, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/head/culthood/cultify()
	return

/obj/item/clothing/head/culthood/magus
	name = "magus helm"
	icon_state = "magus"
	desc = "A helm worn by the followers of an unknown god."
	flags_inv = HIDEFACE | BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/culthood/alt
	icon_state = "cult_hoodalt"

/obj/item/clothing/suit/cultrobes
	name = "cult robes"
	desc = "A set of armored robes worn by the followers of an unknown god."
	icon_state = "cultrobes"
	origin_tech = list(TECH_MATERIAL = 3, TECH_ARCANE = 1)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/book/tome,/obj/item/weapon/melee/cultblade)
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 80, bomb = 25, bio = 10, rad = 0)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0

/obj/item/clothing/suit/cultrobes/cultify()
	return

/obj/item/clothing/suit/cultrobes/alt
	icon_state = "cultrobesalt"

/obj/item/clothing/suit/cultrobes/magusred
	name = "magus robes"
	desc = "A set of armored robes worn by the followers of an unknown god."
	icon_state = "magusred"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/head/helmet/space/cult
	name = "cult helmet"
	desc = "A space worthy helmet used by the followers of an unknown god."
	icon_state = "cult_helmet"
	origin_tech = list(TECH_MATERIAL = 3, TECH_ARCANE = 1)
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 80, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0

/obj/item/clothing/head/helmet/space/cult/cultify()
	return

/obj/item/clothing/suit/space/cult
	name = "cult armour"
	icon_state = "cult_armour"
	origin_tech = list(TECH_MATERIAL = 3, TECH_ARCANE = 1)
	desc = "A bulky suit of armour, bristling with spikes. It looks space-worthy."
	w_class = ITEMSIZE_NORMAL
	allowed = list(/obj/item/weapon/book/tome,/obj/item/weapon/melee/cultblade,/obj/item/weapon/tank/emergency/oxygen,/obj/item/device/suit_cooling_unit)
	slowdown = 0.5
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 80, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS

/obj/item/clothing/suit/space/cult/cultify()
	return
