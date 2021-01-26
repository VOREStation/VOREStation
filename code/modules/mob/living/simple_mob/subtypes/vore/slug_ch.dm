//Passive vore slug. This mob is intended to be annoying but harmless to anybody it can't eat.

/mob/living/simple_mob/vore/slug
	name = "slug"
	desc = "A giant, cold-tolerant slug. It seems excessively passive."
	catalogue_data = list(/datum/category_item/catalogue/fauna/slug)
	tt_desc = "S Arion hortensis"
	icon = 'icons/mob/vore_ch.dmi'
	icon_dead = "slug-dead"
	icon_living = "slug"
	icon_state = "slug"
	faction = "slug" //A faction other than neutral is necessary to get the slug to try eating station crew.
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	melee_damage_lower = 0
	melee_damage_upper = 1 //Not intended to pose any sort of threat outside of vore. Other code should stop it from ever attacking but this is an extra safety check.
	friendly = list("blinks at")
	response_help = "pokes"
	response_disarm = "prods"
	response_harm = "punches"
	movement_cooldown = 40 //I guess you could call this a SNAIL'S PACE.
	maxHealth = 500
	health = 500
	attacktext = list("headbutted")
	minbodytemp = 80
	ai_holder_type = /datum/ai_holder/simple_mob/passive/slug_ch
	vore_icons = SA_ICON_LIVING
	armor = list(
				"melee" = 98,
				"bullet" = 0,
				"laser" = -50,
				"energy" = -50,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 100) //Relatively harmless but agonizing to kill with melee.

	glow_toggle = TRUE 
	glow_range = 1.3 //This seems to be the minimum range which makes glow visible.
	glow_color = "#33ccff" //Same glow color as Sif trees.
	glow_intensity = 1


	var/list/my_slime = list()
	var/slime_max = 35 //With a slug which moves once every 10 seconds and a 5 minute delete timer, this should never exceed 30.
	var/mob/living/vore_memory = null

/mob/living/simple_mob/vore/slug //I guess separating the vore variables is a little more organized?
	vore_bump_chance = 100 //Always attempt a bump nom if possible...
	vore_bump_emote = "knocks over and begins slowly engulfing" 
	vore_active = 1
	vore_icons = 1
	vore_capacity = 1
	vore_pounce_chance = 100 //...while this should make bump noms always knock the target over. Passive AI meanwhile should mean this never affects combat since it doesn't fight back.
	vore_ignores_undigestable = 0
	swallowTime = 100 //10 seconds. Easy to crawl away from when knocked over.
	vore_default_mode = DM_DIGEST

/mob/living/simple_mob/vore/slug/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.desc	= "Somehow you remained still just long enough for the slug to wrap its radula around your body and gradually draw you into its pharynx. The slug moves with agonizing slowness and devours prey at a snail's pace; inch by inch you're crammed down its gullet and squishes and squeezed into the slug's gizzard. Thick walls bear down, covered with shallow, toothy ridges. The slimy moss in here suggests you're not the slug's diet but the gizzard seems intent on churning and scraping over you regardless..."
	B.digest_burn = 0.1
	B.digest_brute = 0.2
	B.vore_verb = "engulf"
	B.name = "gizzard"
	B.mode_flags = DM_FLAG_THICKBELLY
	B.escapechance = 5
	B.fancy_vore = 1
	B.vore_sound = "Squish2"
	B.release_sound = "Pred Escape"
	B.contamination_color = "cyan"
	B.contamination_flavor = "Wet"


	B.emote_lists[DM_DIGEST] = list(
		"The toothy walls scrape and grind against your body.",
		"The humid air feels thick and heavy, stinging faintly with each breath.",
		"Heavy slime oozes over you, making it difficult to move."
		) //Why do so many vore mobs have endo emotes despite being digest only?

/datum/category_item/catalogue/fauna/slug
	name = "Sivian Fauna - Moss Slug"
	desc = "Classification: S Arion hortensis\
	<br><br>\
	A large herbivorous slug commonly spotted near northern waterways with abundant moss. The slug is remarkably resistant to blunt trauma despite its fleshy body due to a foul-tasting outer casing \
	of thick, mucus-filled tissue protecting the more vulnerable musculature beneath.  Said mucus is a natural irritant and hardens rapidly in contact with air, sealing wounds and allowing the slug to shrug off most surface injuries. \
	Few predators exist for the Sivian slug due to the stinging slime's tendency to adhere to attacking claws and appendages.\
	<br><br>\
	The Sivian slug is typically regarded as a pest due to the animal's large bulk and tendency to crush weak structures in its path. Most tools do little to dissuade the creature, forcing homesteads to rely on firearms or reinforced fencing \
	with a slippery coating the slug cannot stick to. While subsisting primarily on Sivian moss, the slug is an opportunistic predator known to eat small fauna which wander into its path. The slime excreted from the slug's foot is particularly sticky and capable of miring small animals. The Sivian slug glows faintly due to colonies bioluminescent bacteria present in its diet."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/vore/slug/proc/spread_slime()
	if(my_slime.len >= slime_max)
		return
	if(istype(get_turf(src), /turf/simulated/floor/water)) //Important to stop my_slime from filling with null entries in water.
		return
	var/obj/effect/slug_glue/G = new /obj/effect/slug_glue/(get_turf(src))
	G.my_slug = src
	my_slime += G

/mob/living/simple_mob/vore/slug/death()
	..()
	for(var/obj/effect/slug_glue/G in my_slime)
		G.my_slug = null
		my_slime -= G //No point in keeping these loaded in the list when the slug dies if somehow the list sticks around after death.

/mob/living/simple_mob/vore/slug/Moved()
	. = ..()
	spread_slime()

/mob/living/simple_mob/vore/slug/do_attack(atom/A, turf/T) //Override of attack proc to ensure the slug can only attempt to eat people, not harm them. Inability to actually hurt anybody is intended, otherwise this mob wouldn't have 98 melee armor.
	if(ckey) //If we're player controlled, use the default attack code. 
		return ..()
	if(istype(A, /mob/living) && !will_eat(A)) 
		ai_holder.lose_target() //Ignore anybody we can't eat.
		return
	else //This is the parent do_attack() code for determining whether or not attacks can hit.
		face_atom(A)
		var/missed = FALSE
		if(!isturf(A) && !(A in T) ) // Turfs don't contain themselves so checking contents is pointless if we're targeting a turf.
			missed = TRUE
		else if(!T.AdjacentQuick(src))
			missed = TRUE

		if(missed) // Most likely we have a slow attack and they dodged it or we somehow got moved.
			add_attack_logs(src, A, "Animal-attacked (dodged)", admin_notify = FALSE)
			playsound(src, 'sound/rakshasa/Decay1.ogg', 75, 1)
			visible_message(span("warning", "\The [src] misses."))
			return FALSE
		tryBumpNom(A) //Meant for bump noms but this works as intended here and has sanity checks. 

/mob/living/simple_mob/vore/slug/perform_the_nom(mob/living/user, mob/living/prey, mob/living/pred, obj/belly/belly, delay)
	..()
	vore_memory = prey

/datum/ai_holder/simple_mob/passive/slug_ch
	wander = TRUE
	base_wander_delay = 7 
	wander_when_pulled = TRUE	
	vision_range = 10
	can_flee = FALSE //Otherwise it'll run as soon as it gets a target.

/obj/effect/slug_glue
	name = "liquid"
	desc = "This looks wet."
	icon = 'icons/effects/effects_ch.dmi'
	icon_state = "wet_turf"
	opacity = 0
	mouse_opacity = 0 //Unclickable
	anchored = 1
	density = 0
	can_buckle = 1
	buckle_lying = TRUE

	var/persist_time = 5 MINUTES //How long until we cease existing.
	var/mob/living/simple_mob/vore/slug/my_slug = null //This should be set by the slug. 
	var/turf/my_turf = null //The turf we spawn on.
	var/base_escape_time = 1 MINUTE //How long does it take to struggle free? Affected by the victim's size_multiplier.

/obj/effect/slug_glue/New()
	..()
	dissipate()
	my_turf = get_turf(src)
	if(istype(my_turf, /turf/simulated/floor/water)) //Aside from not making sense in water, this prevents drowning.
		qdel(src)
/*	for(var/obj/effect/slug_glue/G in my_turf.contents)
		if(G == src)
			continue
		else	
			qdel(G) //Prevent glue layering
*/ //Not including this due to performance concerns but keeping as comments for reference. 

/obj/effect/slug_glue/proc/dissipate() //When spawned, set a timer to despawn.
	if(!persist_time)
		qdel(src)
		return
	else
		spawn(persist_time) //I used sleep() here first and it made the slug sleep for 5 minutes when spawning glue. Byond.
		qdel(src)
		return

/obj/effect/slug_glue/Destroy()
	. = ..()
	if(my_slug)
		my_slug.my_slime -= src //Remove the slime from the slug's list when destroyed.

//This could probably be applied to spideweb code to make it work as intended again.
/obj/effect/slug_glue/Uncross(atom/movable/AM, atom/newloc)
	if(istype(AM, /mob/living/simple_mob/vore/slug))
		return ..()
	else if(istype(AM, /mob/living))
		if(prob(50))
			to_chat(AM, span("warning", "You stick to \the [my_turf]!"))
			return FALSE
	return ..()


/obj/effect/slug_glue/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return

	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(istype(L, /mob/living/simple_mob/vore/slug))
			return

		if(L.m_intent == "run" && !L.buckled) 
			if(has_buckled_mobs())
				return
			buckle_mob(L)
			L.stop_pulling()
			L.Weaken(2)
			to_chat(L, "<span class='warning'>You tripped in the sticky substance, sticking to [my_turf]!</span>")
			playsound(src, 'sound/rakshasa/Decay3.ogg', 100, 1)
			alert_slug(L)

/obj/effect/slug_glue/proc/alert_slug(mob/living/victim as mob)
	if(!my_slug || !has_buckled_mobs() || isbelly(my_slug.loc)) //Otherwise if you eat the slug it will infinitely attempt to eat you if you trip in glue.
		return
	if(my_slug.vore_memory == victim) //Getting eaten lets you get stuck once without alerting the slug. This is to prevent instantly getting eaten again if you struggle free with run intent on.
		my_slug.vore_memory = null
		return
	my_slug.ai_holder.give_target(victim)

/obj/effect/slug_glue/proc/unalert_slug(mob/living/victim as mob)
	if(!my_slug)
		return
	if(my_slug.ai_holder.target == victim)
		my_slug.ai_holder.remove_target() //Instant loss of target. Necessary to simulate the mob giving up if the prey escapes.

/obj/effect/slug_glue/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	user.setClickCooldown(user.get_attack_speed())
	to_chat(user, "You tug and strain against the sticky substance...")
	var/escape_time
	switch(buckled_mob.size_multiplier)
		if(RESIZE_TINY - 1 to RESIZE_A_NORMALSMALL) //24% to 75% size scale, 1% below 25% is to account for microcillin sometimes going slightly below 25%
			escape_time = 2 * base_escape_time
		if(RESIZE_A_NORMALSMALL to RESIZE_A_BIGNORMAL) //75% to 125% size scale
			escape_time = base_escape_time
		if(RESIZE_A_BIGNORMAL to RESIZE_HUGE + 1) //125% to 201% size scale, 1% above 200% is to acount for macrocillin sometimes going slightly above 200%
			escape_time = 0.5 * base_escape_time
		else
			escape_time = base_escape_time //Admeme size scale
	if(do_after(user, escape_time, src, incapacitation_flags = INCAPACITATION_DEFAULT & ~(INCAPACITATION_RESTRAINED | INCAPACITATION_BUCKLED_FULLY)))
		if(!has_buckled_mobs())
			return
		to_chat(user, "You tug free of the tacky, rubbery strands!")
		unbuckle_mob(buckled_mob)
		unalert_slug(buckled_mob)

/obj/effect/slug_glue/clean_blood(var/ignore = 0) //Remove with space cleaner.
	if(!ignore)
		qdel(src)
		return
	..()