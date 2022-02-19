// -------------- Pummeler -------------
/obj/item/weapon/gun/energy/pummeler
	name = "hypersonic gun"
	desc = "For when you want to get that pesky marketing guy out of your face ASAP. The PML9 'Pummeler' fires one HUGE \
	sonic blast in the direction of fire, throwing the target away from you at high speed. Now you can REALLY \
	turn up the bass to max."

	description_info = "This gun punts people away and has a chance of knocking them down briefly. It may also throw them over railings in the process!"
	description_fluff = ""
	description_antag = ""

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "pum"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "gun"

	fire_sound = 'sound/effects/basscannon.ogg'
	projectile_type = /obj/item/projectile/pummel

	charge_cost = 600

	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 5)

	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEMSIZE_LARGE

//Projectile
/obj/item/projectile/pummel
	name = "sonic blast"
	icon_state = "sound"
	damage = 5
	damage_type = BRUTE
	check_armour = "melee"
	embed_chance = 0
	vacuum_traversal = 0
	range = 6 //Scary name, but just deletes the projectile after this range

/obj/item/projectile/pummel/on_hit(var/atom/movable/target, var/blocked = 0)
	if(isliving(target))
		var/mob/living/L = target
		var/throwdir = get_dir(firer,L)
		if(prob(40) && !blocked)
			L.Stun(1)
			L.Confuse(1)
		L.throw_at(get_edge_target_turf(L, throwdir), rand(3,6), 10)

		//VOREStation Add Start
		if(istype(L, /mob/living/simple_mob/vore/alienanimals/startreader))
			var/mob/living/simple_mob/vore/alienanimals/startreader/S = L
			if(!S.flipped)
				S.adjustBruteLoss(100)
				S.visible_message("<span class='notice'>\The [S] is flipped over!!!</span>")
				S.flipped = TRUE
				S.flip_cooldown = 10
				S.handle_flip()
		//VOREStation Add End
		return 1
