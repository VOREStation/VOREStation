/obj/item/weapon/material/sword
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	slot_flags = SLOT_BELT
	force_divisor = 0.7 // 42 when wielded with hardnes 60 (steel)
	thrown_force_divisor = 0.5 // 10 when thrown with weight 20 (steel)
	sharp = TRUE
	edge = TRUE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'

/obj/item/weapon/material/sword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(unique_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(src, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/weapon/material/sword/katana
	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	icon_state = "katana"
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/weapon/material/sword/rapier
	name = "rapier"
	desc = "A slender, fancy and sharply pointed sword."
	icon_state = "rapier"
	item_state = "rapier"
	slot_flags = SLOT_BELT
	applies_material_colour = 0
	attack_verb = list("attacked", "stabbed", "prodded", "poked", "lunged")
	edge = 0 //rapiers are pointy, but not cutty like other swords

/obj/item/weapon/material/sword/longsword
	name = "longsword"
	desc = "A double-edged large blade."
	icon_state = "longsword"
	item_state = "longsword"
	applies_material_colour = 0
	slot_flags = SLOT_BELT | SLOT_BACK
	can_cleave = TRUE

/obj/item/weapon/material/sword/sabre
	name = "sabre"
	desc = "A sharp curved sword, a favored weapon of pirates far in the past."
	icon_state = "sabre"
	item_state = "sabre"
	applies_material_colour = 0 //messes up the hilt color otherwise
	slot_flags = SLOT_BELT

/obj/item/weapon/material/sword/battleaxe
	name = "battleaxe"
	desc = "A one handed battle axe, still a deadly weapon."
	icon_state = "axe"
	item_state = "axe"
	slot_flags = SLOT_BACK
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'
	can_cleave = TRUE

/obj/item/weapon/material/sword/battleaxe/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(unique_parry_check(user, attacker, damage_source) && prob(10))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(src, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/weapon/material/sword/khopesh
	name = "khopesh"
	desc = "An ancient sword shapped like a sickle."
	icon_state = "khopesh"
	item_state = "khopesh"
	applies_material_colour = 0
	slot_flags = SLOT_BELT

/obj/item/weapon/material/sword/dao
	name = "dao"
	desc = "A single-edged broadsword."
	icon_state = "dao"
	item_state = "dao"
	applies_material_colour = 0
	slot_flags = SLOT_BELT

/obj/item/weapon/material/sword/gladius
	name = "gladius"
	desc = "An ancient short sword, designed to stab and cut."
	icon_state = "gladius"
	item_state = "gladius"
	applies_material_colour = 0
	slot_flags = SLOT_BELT