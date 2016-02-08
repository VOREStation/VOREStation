/obj/item/weapon/spell/projectile
	name = "projectile template"
	icon_state = "generic"
	desc = "This is a generic template that shoots projectiles.  If you can read this, the game broke!"
	cast_methods = CAST_RANGED
	var/obj/item/projectile/spell_projectile = null
	var/energy_cost_per_shot = 0
	var/instability_per_shot = 0
	var/pre_shot_delay = 0 //Mesured in seconds

/obj/item/weapon/spell/projectile/on_ranged_cast(atom/hit_atom, mob/living/user)
	if(spell_projectile)
		if(pay_energy(energy_cost_per_shot))
			if(pre_shot_delay)
				user.Stun(pre_shot_delay)
				sleep(pre_shot_delay SECONDS)
			var/obj/item/projectile/new_projectile = new spell_projectile(get_turf(user))
			new_projectile.launch(hit_atom)
			owner.adjust_instability(instability_per_shot)