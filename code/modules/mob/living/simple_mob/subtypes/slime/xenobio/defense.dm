// Contains code for slimes getting attacked, beat, touched, etc, and reacting to that.

// Clicked on by empty hand.
// Handles trying to wrestle a slime off of someone being eatten.
/mob/living/simple_mob/slime/xenobio/attack_hand(mob/living/L)
	if(victim) // Are we eating someone?
		var/fail_odds = 30
		if(victim == L) // Harder to get the slime off if it's you that is being eatten.
			fail_odds = 60

		if(prob(fail_odds))
			visible_message(span("warning", "\The [L] attempts to wrestle \the [name] off!"))
			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

		else
			visible_message(span("warning", "\The [L] manages to wrestle \the [name] off!"))
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

			if(prob(40))
				adjust_discipline(1) // Do this here so that it will be justified discipline.
			stop_consumption()
			step_away(src, L)

	else
		..()

// Handles the actual harming by a melee weapon.
/mob/living/simple_mob/slime/xenobio/hit_with_weapon(obj/item/I, mob/living/user, effective_force, hit_zone)
	..() // Apply damage and etc.
	if(!stat && effective_force > 0)
		if(!is_justified_to_discipline()) // Wow, buddy, why am I getting attacked??
			adjust_discipline(1) // This builds resentment due to being unjustified.

			if(user in friends) // Friend attacking us for no reason.
				if(prob(25))
					friends -= user
					say("[user]... not friend...")

		else // We're actually being bad.
			var/prob_to_back_down = round(effective_force)
			if(is_adult)
				prob_to_back_down /= 2
			if(prob(prob_to_back_down))
				adjust_discipline(2) // Justified.

// Shocked grilles don't hurt slimes, and in fact give them charge.
/mob/living/simple_mob/slime/xenobio/electrocute_act(shock_damage, obj/source, siemens_coeff = 1.0, def_zone = null)
	power_charge = between(0, power_charge + round(shock_damage / 10), 10)
	to_chat(src, span("notice", "\The [source] shocks you, and it charges you."))

// Getting slimebatoned/xenotased.
/mob/living/simple_mob/slime/xenobio/slimebatoned(mob/living/user, amount)
	adjust_discipline(round(amount/2))
	Weaken(amount) // This needs to come afterwards or else it will always be considered abuse to the slime.
