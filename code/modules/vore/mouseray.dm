/obj/item/gun/energy/mouseray
	name = "mouse ray"
	desc = "A mysterious looking ray gun..."
	icon = 'icons/obj/mouseray.dmi'
	icon_state = "mouseray"
	item_state = "mouseray"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_guns_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_guns_vr.dmi')
	fire_sound = 'sound/weapons/wave.ogg'
	charge_cost = 240
	projectile_type = /obj/item/projectile/beam/mouselaser
	origin_tech = list(TECH_BLUESPACE = 4)
	battery_lock = 1
	firemodes = list()
	var/tf_type = /mob/living/simple_mob/animal/passive/mouse	//This type is what kind of mob it will try to turn people into!
	var/cooldown = 0											//automatically set when used
	var/cooldown_time = 15 SECONDS								//the amount of time between shots
	var/tf_admin_pref_override = FALSE							//Overrides pref checks
	var/tf_allow_select = FALSE									//Toggles if the gun is able to pick between things in the 'tf_possible_types' variable
	var/tf_possible_types = list(								//The different types of mob the gun can pick between
		"mouse" = /mob/living/simple_mob/animal/passive/mouse,
		"rat" = /mob/living/simple_mob/animal/passive/mouse/rat,
		"dust jumper" = /mob/living/simple_mob/vore/alienanimals/dustjumper
		)

/obj/item/gun/energy/mouseray/attack_self(mob/user)
	. = ..()
	if(tf_allow_select)
		pick_type()

/obj/item/gun/energy/mouseray/proc/pick_type()
	var/choice = tgui_input_list(usr, "Select a type to turn things into.", "[src.name]", tf_possible_types)
	if(!choice)
		return
	tf_type = tf_possible_types[choice]
	to_chat(usr, "<span class='notice'>You selected [choice].</span>")

/obj/item/gun/energy/mouseray/Fire(atom/target, mob/living/user, clickparams, pointblank, reflex)
	if(world.time < cooldown)
		to_chat(usr, "<span class='warning'>\The [src] isn't ready yet.</span>")
		return
	. = ..()

/obj/item/gun/energy/mouseray/Fire_userless(atom/target)
	if(world.time < cooldown)
		return
	. = ..()

/obj/item/gun/energy/mouseray/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/beam/mouselaser/G = .
	cooldown = world.time + cooldown_time
	if(tf_type)
		G.tf_type = tf_type
	if(tf_admin_pref_override)
		G.tf_admin_pref_override = tf_admin_pref_override

/obj/item/gun/energy/mouseray/update_icon()
	if(charge_meter)
		var/ratio = power_supply.charge / power_supply.maxcharge

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, 0.25) * 100, 25)

		icon_state = "[initial(icon_state)][ratio]"

/obj/item/projectile/beam/mouselaser
	name = "metamorphosis beam"
	icon_state = "xray"
	nodamage = 1
	damage = 0
	range = 7
	check_armour = "laser"
	can_miss = FALSE
	var/tf_type = /mob/living/simple_mob/animal/passive/mouse
	var/tf_admin_pref_override = FALSE

	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni

/obj/item/projectile/beam/mouselaser/on_hit(var/atom/target)
	var/mob/living/M = target
	if(!istype(M))
		return
	if(target != firer)	//If you shot yourself, you probably want to be TFed so don't bother with prefs.
		if(!M.allow_spontaneous_tf && !tf_admin_pref_override)
			return
	if(M.tf_mob_holder)
		var/mob/living/ourmob = M.tf_mob_holder
		if(ourmob.ai_holder)
			var/datum/ai_holder/our_AI = ourmob.ai_holder
			our_AI.set_stance(STANCE_IDLE)
		M.tf_mob_holder = null
		ourmob.ckey = M.ckey
		var/turf/get_dat_turf = get_turf(target)
		ourmob.loc = get_dat_turf
		ourmob.forceMove(get_dat_turf)
		ourmob.vore_selected = M.vore_selected
		M.vore_selected = null
		for(var/obj/belly/B as anything in M.vore_organs)
			B.loc = ourmob
			B.forceMove(ourmob)
			B.owner = ourmob
			M.vore_organs -= B
			ourmob.vore_organs += B

		ourmob.Life(1)
		if(ishuman(M))
			for(var/obj/item/W in M)
				if(istype(W, /obj/item/implant/backup) || istype(W, /obj/item/nif))
					continue
				M.drop_from_inventory(W)

		qdel(target)
		return
	else
		if(M.stat == DEAD)	//We can let it undo the TF, because the person will be dead, but otherwise things get weird.
			return
		var/mob/living/new_mob = spawn_mob(M)
		new_mob.faction = M.faction

		if(new_mob && isliving(new_mob))
			for(var/obj/belly/B as anything in new_mob.vore_organs)
				new_mob.vore_organs -= B
				qdel(B)
			new_mob.vore_organs = list()
			new_mob.name = M.name
			new_mob.real_name = M.real_name
			for(var/lang in M.languages)
				new_mob.languages |= lang
			M.copy_vore_prefs_to_mob(new_mob)
			new_mob.vore_selected = M.vore_selected
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(ishuman(new_mob))
					var/mob/living/carbon/human/N = new_mob
					N.gender = H.gender
					N.identifying_gender = H.identifying_gender
				else
					new_mob.gender = H.gender
			else
				new_mob.gender = M.gender
				if(ishuman(new_mob))
					var/mob/living/carbon/human/N = new_mob
					N.identifying_gender = M.gender

			for(var/obj/belly/B as anything in M.vore_organs)
				B.loc = new_mob
				B.forceMove(new_mob)
				B.owner = new_mob
				M.vore_organs -= B
				new_mob.vore_organs += B

			new_mob.ckey = M.ckey
			if(M.ai_holder && new_mob.ai_holder)
				var/datum/ai_holder/old_AI = M.ai_holder
				old_AI.set_stance(STANCE_SLEEP)
				var/datum/ai_holder/new_AI = new_mob.ai_holder
				new_AI.hostile = old_AI.hostile
				new_AI.retaliate = old_AI.retaliate
			M.loc = new_mob
			M.forceMove(new_mob)
			new_mob.tf_mob_holder = M

/obj/item/projectile/beam/mouselaser/proc/spawn_mob(var/mob/living/target)
	if(!ispath(tf_type))
		return
	var/new_mob = new tf_type(get_turf(target))
	return new_mob

/mob/living
	var/mob/living/tf_mob_holder = null

/mob/living/proc/revert_mob_tf()
	if(!tf_mob_holder)
		return
	var/mob/living/ourmob = tf_mob_holder
	if(ourmob.ai_holder)
		var/datum/ai_holder/our_AI = ourmob.ai_holder
		our_AI.set_stance(STANCE_IDLE)
	tf_mob_holder = null
	ourmob.ckey = ckey
	var/turf/get_dat_turf = get_turf(src)
	ourmob.loc = get_dat_turf
	ourmob.forceMove(get_dat_turf)
	ourmob.vore_selected = vore_selected
	vore_selected = null
	for(var/obj/belly/B as anything in vore_organs)
		B.loc = ourmob
		B.forceMove(ourmob)
		B.owner = ourmob
		vore_organs -= B
		ourmob.vore_organs += B

	ourmob.Life(1)

	if(ishuman(src))
		for(var/obj/item/W in src)
			if(istype(W, /obj/item/implant/backup) || istype(W, /obj/item/nif))
				continue
			src.drop_from_inventory(W)

	qdel(src)


/mob/living/proc/handle_tf_holder()
	if(!tf_mob_holder)
		return
	if(stat != tf_mob_holder.stat)
		if(stat == DEAD)
			tf_mob_holder.death(FALSE, null)
		if(tf_mob_holder.stat == DEAD)
			death()

/mob/living/proc/copy_vore_prefs_to_mob(var/mob/living/new_mob)
	//For primarily copying vore preference settings from a carbon mob to a simplemob
	//It can be used for other things, but be advised, if you're using it to put a simplemob into a carbon mob, you're gonna be overriding a bunch of prefs
	new_mob.ooc_notes = ooc_notes
	new_mob.ooc_notes_likes = ooc_notes_likes
	new_mob.ooc_notes_dislikes = ooc_notes_dislikes
	new_mob.digestable = digestable
	new_mob.devourable = devourable
	new_mob.absorbable = absorbable
	new_mob.feeding = feeding
	new_mob.can_be_drop_prey = can_be_drop_prey
	new_mob.can_be_drop_pred = can_be_drop_pred
	new_mob.allow_inbelly_spawning = allow_inbelly_spawning
	new_mob.digest_leave_remains = digest_leave_remains
	new_mob.allowmobvore = allowmobvore
	new_mob.permit_healbelly = permit_healbelly
	new_mob.noisy = noisy
	new_mob.selective_preference = selective_preference
	new_mob.appendage_color = appendage_color
	new_mob.appendage_alt_setting = appendage_alt_setting
	new_mob.drop_vore = drop_vore
	new_mob.stumble_vore = stumble_vore
	new_mob.slip_vore = slip_vore
	new_mob.throw_vore = throw_vore
	new_mob.food_vore = food_vore
	new_mob.resizable = resizable
	new_mob.show_vore_fx = show_vore_fx
	new_mob.step_mechanics_pref = step_mechanics_pref
	new_mob.pickup_pref = pickup_pref
	new_mob.vore_taste = vore_taste
	new_mob.vore_smell = vore_smell
	new_mob.nutrition_message_visible = nutrition_message_visible
	new_mob.allow_spontaneous_tf = allow_spontaneous_tf
	new_mob.eating_privacy_global = eating_privacy_global
	new_mob.allow_mimicry = allow_mimicry
	new_mob.text_warnings = text_warnings
	new_mob.allow_mind_transfer = allow_mind_transfer

/////SUBTYPES/////

/obj/item/gun/energy/mouseray/medical		//This just changes people back, it can't TF people into anything without shenanigans
	name = "recombobulation ray"
	desc = "The Type Gamma Medical Recombobulation ray! A mysterious looking ray gun! It works to change people who have had their form significantly altered back into their original forms!"

	icon_state = "medray"
	item_state = "mouseray"
	charge_meter = FALSE
	charge_cost = 0
	tf_type = null
	projectile_type = /obj/item/projectile/beam/mouselaser/reversion

/obj/item/gun/energy/mouseray/medical/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/beam/mouselaser/reversion/G = .
	cooldown = world.time + cooldown_time
	if(tf_admin_pref_override)
		G.tf_admin_pref_override = tf_admin_pref_override


/obj/item/projectile/beam/mouselaser/reversion
	name = "recombobulation beam"
	tf_admin_pref_override = FALSE

/obj/item/projectile/beam/mouselaser/reversion/on_hit(var/atom/target)
	if(istype(target,/obj/item)) //Are we shooting an item?
		var/obj/item/O = target
		if(O.possessed_voice.len) //Does the object have a voice? AKA, if someone inhabiting it?
			for(var/mob/living/M in O.possessed_voice)
				if(M.tf_mob_holder) //Is this item possessed by IC methods?
					if(istype(M.loc, /obj/item/clothing)) //Are they in clothes? Delete the item then revert them.
						qdel(O)
						M.revert_mob_tf() //Voices can't eat, so this is the least intensive way to revert them.
					else
						M.forceMove(get_turf(O)) //Non-clothing items require a bit extra work since they don't drop contents when qdeleted.
						qdel(O)
						M.revert_mob_tf()
				else
					continue //In case they have multiple voices through adminbus.
		else
			return
	var/mob/living/M = target
	if(!istype(M))
		return
	if(target != firer)	//If you shot yourself, you probably want to be TFed so don't bother with prefs.
		if(!M.allow_spontaneous_tf && !tf_admin_pref_override)
			firer.visible_message("<span class='warning'>\The [src] buzzes impolitely.</span>")
			return
	if(M.tf_mob_holder)
		var/mob/living/ourmob = M.tf_mob_holder
		if(ourmob.ai_holder)
			var/datum/ai_holder/our_AI = ourmob.ai_holder
			our_AI.set_stance(STANCE_IDLE)
		M.tf_mob_holder = null
		ourmob.ckey = M.ckey
		var/turf/get_dat_turf = get_turf(target)
		ourmob.loc = get_dat_turf
		ourmob.forceMove(get_dat_turf)
		ourmob.vore_selected = M.vore_selected
		M.vore_selected = null
		for(var/obj/belly/B as anything in M.vore_organs)
			B.loc = ourmob
			B.forceMove(ourmob)
			B.owner = ourmob
			M.vore_organs -= B
			ourmob.vore_organs += B

		ourmob.Life(1)

		if(ishuman(M))
			for(var/obj/item/W in M)
				if(istype(W, /obj/item/implant/backup) || istype(W, /obj/item/nif))
					continue
				M.drop_from_inventory(W)

		qdel(target)
		firer.visible_message("<span class='notice'>\The [shot_from] boops pleasantly.</span>")
		return
	else
		firer.visible_message("<span class='warning'>\The [shot_from] buzzes impolitely.</span>")

/obj/item/gun/energy/mouseray/admin		//NEVER GIVE THIS TO ANYONE
	name = "experimental metamorphosis ray"
	cooldown_time = 5 SECONDS
	tf_allow_select = TRUE
	charge_meter = FALSE
	charge_cost = 0
	icon_state = "adminray"

/obj/item/gun/energy/mouseray/metamorphosis
	name = "metamorphosis ray"
	tf_allow_select = TRUE
	tf_possible_types = list(
		"mouse" = /mob/living/simple_mob/animal/passive/mouse,
		"rat" = /mob/living/simple_mob/animal/passive/mouse/rat,
		"dust jumper" = /mob/living/simple_mob/vore/alienanimals/dustjumper,
		"woof" = /mob/living/simple_mob/vore/woof,
		"corgi" = /mob/living/simple_mob/animal/passive/dog/corgi,
		"cat" = /mob/living/simple_mob/animal/passive/cat,
		"chicken" = /mob/living/simple_mob/animal/passive/chicken,
		"cow" = /mob/living/simple_mob/animal/passive/cow,
		"lizard" = /mob/living/simple_mob/animal/passive/lizard,
		"rabbit" = /mob/living/simple_mob/vore/rabbit,
		"fox" = /mob/living/simple_mob/animal/passive/fox,
		"fennec" = /mob/living/simple_mob/vore/fennec,
		"cute fennec" = /mob/living/simple_mob/animal/passive/fennec,
		"fennix" = /mob/living/simple_mob/vore/fennix,
		"red panda" = /mob/living/simple_mob/vore/redpanda,
		"opossum" = /mob/living/simple_mob/animal/passive/opossum,
		"horse" = /mob/living/simple_mob/vore/horse,
		"goose" = /mob/living/simple_mob/animal/space/goose,
		"sheep" = /mob/living/simple_mob/vore/sheep
		)

/obj/item/gun/energy/mouseray/metamorphosis/advanced
	name = "advanced metamorphosis ray"
	tf_possible_types = list(
		"mouse" = /mob/living/simple_mob/animal/passive/mouse,
		"rat" = /mob/living/simple_mob/animal/passive/mouse/rat,
		"giant rat" = /mob/living/simple_mob/vore/aggressive/rat,
		"dust jumper" = /mob/living/simple_mob/vore/alienanimals/dustjumper,
		"woof" = /mob/living/simple_mob/vore/woof,
		"corgi" = /mob/living/simple_mob/animal/passive/dog/corgi,
		"cat" = /mob/living/simple_mob/animal/passive/cat,
		"chicken" = /mob/living/simple_mob/animal/passive/chicken,
		"cow" = /mob/living/simple_mob/animal/passive/cow,
		"lizard" = /mob/living/simple_mob/animal/passive/lizard,
		"rabbit" = /mob/living/simple_mob/vore/rabbit,
		"fox" = /mob/living/simple_mob/animal/passive/fox,
		"fennec" = /mob/living/simple_mob/vore/fennec,
		"cute fennec" = /mob/living/simple_mob/animal/passive/fennec,
		"fennix" = /mob/living/simple_mob/vore/fennix,
		"red panda" = /mob/living/simple_mob/vore/redpanda,
		"opossum" = /mob/living/simple_mob/animal/passive/opossum,
		"horse" = /mob/living/simple_mob/vore/horse,
		"goose" = /mob/living/simple_mob/animal/space/goose,
		"sheep" = /mob/living/simple_mob/vore/sheep,
		"space bumblebee" = /mob/living/simple_mob/vore/bee,
		"space bear" = /mob/living/simple_mob/animal/space/bear,
		"voracious lizard" = /mob/living/simple_mob/vore/aggressive/dino,
		"giant frog" = /mob/living/simple_mob/vore/aggressive/frog,
		"jelly blob" = /mob/living/simple_mob/vore/jelly,
		"wolf" = /mob/living/simple_mob/vore/wolf,
		"direwolf" = /mob/living/simple_mob/vore/wolf/direwolf,
		"great wolf" = /mob/living/simple_mob/vore/greatwolf,
		"sect queen" = /mob/living/simple_mob/vore/sect_queen,
		"sect drone" = /mob/living/simple_mob/vore/sect_drone,
		"panther" = /mob/living/simple_mob/vore/aggressive/panther,
		"giant snake" = /mob/living/simple_mob/vore/aggressive/giant_snake,
		"deathclaw" = /mob/living/simple_mob/vore/aggressive/deathclaw,
		"otie" = /mob/living/simple_mob/vore/otie,
		"mutated otie" =/mob/living/simple_mob/vore/otie/feral,
		"red otie" = /mob/living/simple_mob/vore/otie/red,
		"defanged xenomorph" = /mob/living/simple_mob/vore/xeno_defanged,
		"catslug" = /mob/living/simple_mob/vore/alienanimals/catslug,
		"monkey" = /mob/living/carbon/human/monkey,
		"wolpin" = /mob/living/carbon/human/wolpin,
		"sparra" = /mob/living/carbon/human/sparram,
		"saru" = /mob/living/carbon/human/sergallingm,
		"sobaka" = /mob/living/carbon/human/sharkm,
		"farwa" = /mob/living/carbon/human/farwa,
		"neaera" = /mob/living/carbon/human/neaera,
		"stok" = /mob/living/carbon/human/stok,
		"weretiger" = /mob/living/simple_mob/vore/weretiger,
		"dragon" = /mob/living/simple_mob/vore/bigdragon/friendly,
		"leopardmander" = /mob/living/simple_mob/vore/leopardmander
		)

/obj/item/gun/energy/mouseray/metamorphosis/advanced/random
	name = "unstable metamorphosis ray"
	tf_allow_select = FALSE

/obj/item/gun/energy/mouseray/metamorphosis/advanced/random/Fire(atom/target, mob/living/user, clickparams, pointblank, reflex)
	if(world.time < cooldown)
		to_chat(usr, "<span class='warning'>\The [src] isn't ready yet.</span>")
		return
	var/choice = pick(tf_possible_types)
	tf_type = tf_possible_types[choice]
	. = ..()

/obj/item/gun/energy/mouseray/woof
	name = "woof ray"
	tf_type = /mob/living/simple_mob/vore/woof

/obj/item/gun/energy/mouseray/corgi
	name = "corgi ray"
	tf_type = /mob/living/simple_mob/animal/passive/dog/corgi

/obj/item/gun/energy/mouseray/cat
	name = "cat ray"
	tf_type = /mob/living/simple_mob/animal/passive/cat

/obj/item/gun/energy/mouseray/chicken
	name = "chicken ray"
	tf_type = /mob/living/simple_mob/animal/passive/chicken

/obj/item/gun/energy/mouseray/lizard
	name = "lizard ray"
	tf_type = /mob/living/simple_mob/animal/passive/lizard

/obj/item/gun/energy/mouseray/rabbit
	name = "rabbit ray"
	tf_type = /mob/living/simple_mob/vore/rabbit

/obj/item/gun/energy/mouseray/fennec
	name = "fennec ray"
	tf_type = /mob/living/simple_mob/animal/passive/fennec

/obj/item/gun/energy/mouseray/monkey
	name = "monkey ray"
	tf_type = /mob/living/carbon/human/monkey

/obj/item/gun/energy/mouseray/wolpin
	name = "wolpin ray"
	tf_type = /mob/living/carbon/human/wolpin

/obj/item/gun/energy/mouseray/otie
	name = "otie ray"
	tf_type = /mob/living/simple_mob/vore/otie

/obj/item/gun/energy/mouseray/direwolf
	name = "dire wolf ray"
	tf_type = /mob/living/simple_mob/vore/wolf/direwolf

/obj/item/gun/energy/mouseray/giantrat
	name = "giant rat ray"
	tf_type = /mob/living/simple_mob/vore/aggressive/rat

/obj/item/gun/energy/mouseray/redpanda
	name = "red panda ray"
	tf_type = /mob/living/simple_mob/vore/redpanda

/obj/item/gun/energy/mouseray/catslug
	name = "catslug ray"
	tf_type = /mob/living/simple_mob/vore/alienanimals/catslug

/obj/item/gun/energy/mouseray/teppi
	name = "teppi ray"
	tf_type = /mob/living/simple_mob/vore/alienanimals/teppi


/////RANDOM SPAWNER/////

/obj/random/mouseray
	name = "random ray"
	icon = 'icons/mob/randomlandmarks.dmi'
	icon_state = "fanc_trejur"
	spawn_nothing_percentage = 0

/obj/random/mouseray/item_to_spawn()
	return pick(prob(300);/obj/item/gun/energy/mouseray,
				prob(50);/obj/item/gun/energy/mouseray/corgi,
				prob(50);/obj/item/gun/energy/mouseray/woof,
				prob(50);/obj/item/gun/energy/mouseray/cat,
				prob(50);/obj/item/gun/energy/mouseray/chicken,
				prob(50);/obj/item/gun/energy/mouseray/lizard,
				prob(50);/obj/item/gun/energy/mouseray/rabbit,
				prob(50);/obj/item/gun/energy/mouseray/fennec,
				prob(5);/obj/item/gun/energy/mouseray/monkey,
				prob(5);/obj/item/gun/energy/mouseray/wolpin,
				prob(5);/obj/item/gun/energy/mouseray/otie,
				prob(5);/obj/item/gun/energy/mouseray/direwolf,
				prob(5);/obj/item/gun/energy/mouseray/giantrat,
				prob(50);/obj/item/gun/energy/mouseray/redpanda,
				prob(5);/obj/item/gun/energy/mouseray/catslug,
				prob(1);/obj/item/gun/energy/mouseray/metamorphosis,
				prob(1);/obj/item/gun/energy/mouseray/metamorphosis/advanced/random
				)
