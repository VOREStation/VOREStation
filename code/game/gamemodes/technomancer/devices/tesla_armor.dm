/datum/technomancer/equipment/tesla_armor
	name = "Tesla Armor"
	desc = "This piece of armor offers a retaliation-based defense.  When the armor is 'ready', it will completely protect you from \
	the next attack you suffer, and strike the attacker with a strong bolt of lightning, provided they are close enough.  This effect requires \
	fifteen seconds to recharge.  If you are attacked while this is recharging, a weaker lightning bolt is sent out, however you won't be protected from \
	the person beating you."
	cost = 150
	obj_path = /obj/item/clothing/suit/armor/tesla

/obj/item/clothing/suit/armor/tesla
	name = "tesla armor"
	desc = "This rather dangerous looking armor will hopefully shock your enemies, and not you in the process."
	icon_state = "reactive" //wip
	item_state = "reactive"
	blood_overlay_type = "armor"
	slowdown = 1
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	var/ready = 1 //Determines if the next attack will be blocked, as well if a strong lightning bolt is sent out at the attacker.
	var/ready_icon_state = "reactive" //also wip
	var/normal_icon_state = "reactiveoff"
	var/cooldown_to_charge = 15 SECONDS

/obj/item/clothing/suit/armor/tesla/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	//First, some retaliation.
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		if(P.firer && get_dist(user, P.firer) <= 3)
			if(ready)
				shoot_lightning(P.firer, 40)
			else
				shoot_lightning(P.firer, 15)

	else
		if(attacker && attacker != user)
			if(get_dist(user, attacker) <= 3) //Anyone farther away than three tiles is too far to shoot lightning at.
				if(ready)
					shoot_lightning(attacker, 40)
				else
					shoot_lightning(attacker, 15)

	//Deal with protecting our wearer now.
	if(ready)
		ready = 0
		spawn(cooldown_to_charge)
			ready = 1
			update_icon()
			user << "<span class='notice'>\The [src] is ready to protect you once more.</span>"
		visible_message("<span class='danger'>\The [user]'s [src.name] blocks [attack_text]!</span>")
		update_icon()
		return 1
	return 0

/obj/item/clothing/suit/armor/tesla/update_icon()
	..()
	if(ready)
		icon_state = ready_icon_state
	else
		icon_state = normal_icon_state
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_wear_suit(0)

/obj/item/clothing/suit/armor/tesla/proc/shoot_lightning(var/mob/target, var/power)
	var/obj/item/projectile/beam/lightning/lightning = new(src)
	lightning.power = power
	lightning.launch(target)
	visible_message("<span class='danger'>\The [src] strikes \the [target] with lightning!</span>")
	playsound(get_turf(src), 'sound/weapons/gauss_shoot.ogg', 75, 1)