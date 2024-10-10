/mob/living/simple_mob/vore/ddraig
	name = "ddraig"
	desc = "A massive drake-like creature with dark purple scales and a seemingly exposed skull."
	tt_desc = "Draconis glamoris"
	icon = 'icons/mob/vore96x96.dmi'
	icon_dead = "ddraig-dead"
	icon_living = "ddraig"
	icon_state = "ddraig"
	icon_rest = "ddraig_rest"
	faction = FACTION_GLAMOUR
	catalogue_data = list(/datum/category_item/catalogue/fauna/ddraig)
	old_x = -32
	old_y = 0
	vis_height = 92
	melee_damage_lower = 20
	melee_damage_upper = 15
	friendly = list("nudges", "sniffs on", "rumbles softly at", "nuzzles")
	default_pixel_x = -32
	pixel_x = -32
	pixel_y = 0
	response_help = "bumps"
	response_disarm = "shoves"
	response_harm = "bites"
	movement_cooldown = 1
	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 25
	maxHealth = 1000
	attacktext = list("mauled")
	see_in_dark = 8
	minbodytemp = 0
	ai_holder_type = /datum/ai_holder/simple_mob/vore/ddraig
	max_buckled_mobs = 1
	mount_offset_y = 32
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	minbodytemp = 0

	var/flames
	var/firebreathtimer
	var/charge_warmup = 3 SECOND
	var/tf_warmup = 2 SECOND

	special_attack_min_range = 2
	special_attack_max_range = 6
	special_attack_cooldown = 15 SECONDS

	var/leap_warmup = 2 SECOND // How long the leap telegraphing is.
	var/leap_sound = 'sound/weapons/spiderlunge.ogg'

/mob/living/simple_mob/vore/ddraig

	vore_bump_chance = 25
	vore_digest_chance = 50
	vore_escape_chance = 5
	vore_pounce_chance = 100
	vore_active = 1
	vore_icons = 3
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_capacity = 3
	swallowTime = 50
	vore_ignores_undigestable = TRUE
	vore_default_mode = DM_DIGEST
	vore_pounce_maxhealth = 125
	vore_bump_emote = "tries to devour"

/mob/living/simple_mob/vore/ddraig/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount
	verbs |= /mob/living/proc/toggle_rider_reins
	verbs |= /mob/living/proc/set_size
	verbs |= /mob/living/proc/polymorph
	verbs |= /mob/living/proc/glamour_invisibility
	movement_cooldown = -1

/mob/living/simple_mob/vore/ddraig/init_vore()
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "Despite the jaws of the dragon not being particular visible, once they begin to part it reveals a rather vast maw. More than wide enough to engulf your head and upper body, the ddraig lifts you effortlessly from the ground, standing up to full height with only your legs dangling from the beast's mouth. Inside you are engulfed in the wet, slimy and hot slobber of the creature. A massive tongue beneath your body curls over you to taste and lather every inch on offer. Soon enough, the dragon tosses its head backwards, sending your body beyond the throat, wrapped in the rippled lining of the creatures gullet for a slow, dark descent into the abyss below. It is a long journey through that seemingly endless neck, but eventually you are deposited in the creature's stomach. Little sound from the outside makes it inside, all drowned out by the cacophony of bodily functions groaning, burbling and beating around you. Despite the size of the beast, the gut is not massive, the walls clench down tight around your helplessly trapped body. The stomach lining grinds roughly over your body, smearing you in a slurry of slimy fluids."
	B.vore_sound = "Tauric Swallow"
	B.release_sound = "Pred Escape"
	B.mode_flags = DM_FLAG_THICKBELLY
	B.fancy_vore = 1
	B.selective_preference = DM_DIGEST
	B.vore_verb = "devour"
	B.digest_brute = 3
	B.digest_burn = 2
	B.digest_oxy = 0
	B.selectchance = 50
	B.absorbchance = 0
	B.escapechance = 3
	B.escape_stun = 5
	B.contamination_color = "grey"
	B.contamination_flavor = "Wet"
	B.emote_lists[DM_DIGEST] = list(
		"The ddraig coos contentedly as the walls crush and squeeze over your body!",
		"As the ddraig moves about, it becomes more difficult to keep yourself upright, being forced to turn and slip of the slime slickened stomach lining.",
		"You can't make out any sound from the outside as the gut grumbled and reverberates over your body.",
		"As the thinning air begins to make you feel dizzy, menacing bworps and grumbles fill that dark, constantly shifting organ!",
		"The constant, rhythmic kneading and massaging starts to take its toll along with the muggy heat, making you feel weaker and weaker!",
		"The slender creature has no issue showing off the weak movements of you inside, even the churning of the gut itself tosses you about, all bumps so very visible on its flesh.")

/datum/category_item/catalogue/fauna/ddraig
	name = "Extra-Realspace Fauna - Ddraig"
	desc = "Classification: Draconis glamoris\
	<br><br>\
	A massive dragon-like creature found to reside in the glamour, also known as whitespace. The ddraig is considered a rarity, even amongst this alien world, and often revered by other inhabitants. \
	It is rarely considered outright aggressive, but has been known to attack if it feels threatened. It is a sapiant creature and considered to be particularly intelligent. \
	It is a carnivorous creature and quite capable of hunting. Aside from the deadly claws and teeth, it is also able to breathe fire like realspace dragons, turn itself invisible at will, and transform other creatures temporarily."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/vore/ddraig/do_special_attack(atom/A)
	. = TRUE
	if(ckey)
		return
	var/specialattack = rand(1,3)
	if(specialattack == 1)
		lunge(A)
	if(specialattack == 2)
		firebreathstart(A)
	if(specialattack == 3)
		tfbeam(A)

/mob/living/simple_mob/vore/ddraig/proc/lunge(atom/A)	//Mostly copied from hunter.dm
	set waitfor = FALSE
	if(!isliving(A))
		return FALSE
	var/mob/living/L = A
	if(!L.devourable || !L.allowmobvore || !L.can_be_drop_prey || !L.throw_vore || L.unacidable)
		return FALSE

	set_AI_busy(TRUE)
	visible_message(span_warning("\The [src] rears back, ready to lunge!"))
	to_chat(L, span_danger("\The [src] focuses on you!"))
	// Telegraph, since getting stunned suddenly feels bad.
	do_windup_animation(A, leap_warmup)
	sleep(leap_warmup) // For the telegraphing.

	if(L.z != z)	//Make sure you haven't disappeared to somewhere we can't go
		set_AI_busy(FALSE)
		return FALSE

	// Do the actual leap.
	status_flags |= LEAPING // Lets us pass over everything.
	visible_message(span_critical("\The [src] leaps at \the [L]!"))
	throw_at(get_step(L, get_turf(src)), special_attack_max_range+1, 1, src)
	playsound(src, leap_sound, 75, 1)

	sleep(5) // For the throw to complete. It won't hold up the AI ticker due to waitfor being false.

	if(status_flags & LEAPING)
		status_flags &= ~LEAPING // Revert special passage ability.

	set_AI_busy(FALSE)
	if(Adjacent(L))	//We leapt at them but we didn't manage to hit them, let's see if we're next to them
		L.Weaken(2)	//get knocked down, idiot

/mob/living/simple_mob/vore/ddraig/proc/firebreathstart(var/atom/A) //Borrowed from le big dragon
	glow_toggle = 1
	set_light(glow_range, glow_intensity, glow_color) //Setting it here so the light starts immediately
	flames = 1
	set_AI_busy(TRUE)
	visible_message(span_warning("\The [src] opens its maw, emitting flames!"))
	do_windup_animation(A, charge_warmup)
	firebreathtimer = addtimer(CALLBACK(src, PROC_REF(firebreathend), A), charge_warmup, TIMER_STOPPABLE)
	playsound(src, "sound/magic/Fireball.ogg", 50, 1)

/mob/living/simple_mob/vore/ddraig/proc/firebreathend(var/atom/A)
	//make sure our target still exists and is on a turf
	if(QDELETED(A) || !isturf(get_turf(A)))
		set_AI_busy(FALSE)
		return
	var/obj/item/projectile/P = new /obj/item/projectile/bullet/dragon(get_turf(src))
	src.visible_message(span_danger("\The [src] spews fire at \the [A]!"))
	playsound(src, "sound/weapons/Flamer.ogg", 50, 1)
	P.launch_projectile(A, BP_TORSO, src)
	set_AI_busy(FALSE)
	glow_toggle = 0
	flames = 0

/mob/living/simple_mob/vore/ddraig/proc/tfbeam(var/atom/A)
	if(!isturf(get_turf(A)))
		return
	set_AI_busy(TRUE)
	visible_message(span_warning("\The [src] begins to shimmer with a rainbow hue!"))
	do_windup_animation(A, tf_warmup)
	sleep(tf_warmup)
	set_AI_busy(FALSE)
	var/obj/item/projectile/P = new /obj/item/projectile/beam/mouselaser/ddraig(get_turf(src))
	src.visible_message(span_danger("\The [src] breathes a beam at \the [A]!"))
	playsound(src, "sound/weapons/sparkle.ogg", 50, 1)
	P.launch_projectile(A, BP_TORSO, src)

/obj/item/projectile/beam/mouselaser/ddraig
	tf_admin_pref_override = TRUE //It will TF them regardless of their prefs because it is only very temporary
	icon_state = "rainbow"
	muzzle_type = /obj/effect/projectile/muzzle/rainbow
	tracer_type = /obj/effect/projectile/tracer/rainbow
	impact_type = /obj/effect/projectile/impact/rainbow

/obj/item/projectile/beam/mouselaser/ddraig/on_hit(var/atom/target)
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

			spawn(30 SECONDS)
				new_mob.revert_mob_tf() //TF them back after 30 seconds, basically takes them out of the fight for a short time.

/obj/item/projectile/beam/mouselaser/ddraig/spawn_mob(var/mob/living/target)
	var/list/tf_list = list(/mob/living/simple_mob/animal/passive/mouse,
		/mob/living/simple_mob/animal/passive/mouse/rat,
		/mob/living/simple_mob/vore/alienanimals/dustjumper,
		/mob/living/simple_mob/vore/woof,
		/mob/living/simple_mob/animal/passive/dog/corgi,
		/mob/living/simple_mob/animal/passive/cat,
		/mob/living/simple_mob/animal/passive/chicken,
		/mob/living/simple_mob/animal/passive/cow,
		/mob/living/simple_mob/animal/passive/lizard,
		/mob/living/simple_mob/vore/rabbit,
		/mob/living/simple_mob/animal/passive/fox,
		/mob/living/simple_mob/vore/fennec,
		/mob/living/simple_mob/animal/passive/fennec,
		/mob/living/simple_mob/vore/fennix,
		/mob/living/simple_mob/vore/redpanda,
		/mob/living/simple_mob/animal/passive/opossum,
		/mob/living/simple_mob/vore/horse,
		/mob/living/simple_mob/animal/space/goose,
		/mob/living/simple_mob/vore/sheep)
	tf_type = pick(tf_list)
	if(!ispath(tf_type))
		return
	var/new_mob = new tf_type(get_turf(target))
	return new_mob

/datum/ai_holder/simple_mob/vore/ddraig
	var/used_invis = 0
	can_flee = TRUE
	flee_when_dying = FALSE

/datum/ai_holder/simple_mob/vore/find_target(list/possible_targets, has_targets_list)
	if(!vore_hostile)
		return ..()
	if(!isanimal(holder))	//Only simplemobs have the vars we need
		return ..()
	var/mob/living/simple_mob/H = holder
	if(H.vore_fullness >= H.vore_capacity)	//Don't beat people up if we're full
		return ..()
	ai_log("find_target() : Entered.", AI_LOG_TRACE)

	. = list()
	if(!has_targets_list)
		possible_targets = list_targets()
	var/list/valid_mobs = list()
	for(var/mob/living/possible_target in possible_targets)
		if(!can_attack(possible_target))
			continue
		if(istype(target,/mob/living/simple_mob) && !check_attacker(target)) //Do not target simple mobs who didn't attack you (disengage with TF'd mobs)
			continue
		. |= possible_target
		if(!isliving(possible_target))
			continue
		if(vore_check(possible_target))
			valid_mobs |= possible_target

	var/new_target
	if(valid_mobs.len)
		new_target = pick(valid_mobs)
	else if(hostile)
		new_target = pick(.)
	if(!new_target)
		return null
	give_target(new_target)
	return new_target

/datum/ai_holder/simple_mob/vore/ddraig/engage_target()
	ai_log("engage_target() : Entering.", AI_LOG_DEBUG)

	if(holder.cloaked)
		set_stance(STANCE_FLEE)
		return

	if((holder.health < (holder.maxHealth / 4)) && !used_invis)
		holder.cloak()
		used_invis = 1
		step_away(holder, target, 8)
		step_away(holder, target, 8)
		step_away(holder, target, 8)
		step_away(holder, target, 8)
		step_away(holder, target, 8)
		spawn(60 SECONDS)
			holder.uncloak()

	if(istype(target,/mob/living/simple_mob) && !check_attacker(target)) //Immediately disengage with TF'd mobs so you don't one shot the poor guy you turned into a mouse.
		lose_target()

	// Can we still see them?
	if(!target || !can_attack(target))
		ai_log("engage_target() : Lost sight of target.", AI_LOG_TRACE)
		if(lose_target()) // We lost them (returns TRUE if we found something else to do)
			ai_log("engage_target() : Pursuing other options (last seen, or a new target).", AI_LOG_TRACE)
			return

	var/distance = get_dist(holder, target)
	ai_log("engage_target() : Distance to target ([target]) is [distance].", AI_LOG_TRACE)
	holder.face_atom(target)
	last_conflict_time = world.time

	// Do a 'special' attack, if one is allowed.
//	if(prob(special_attack_prob) && (distance >= special_attack_min_range) && (distance <= special_attack_max_range))
	if(holder.ICheckSpecialAttack(target))
		ai_log("engage_target() : Attempting a special attack.", AI_LOG_TRACE)
		on_engagement(target)
		if(special_attack(target)) // If this fails, then we try a regular melee/ranged attack.
			ai_log("engage_target() : Successful special attack. Exiting.", AI_LOG_DEBUG)
			return

	// Stab them.
	else if(distance <= 1 && !pointblank)
		ai_log("engage_target() : Attempting a melee attack.", AI_LOG_TRACE)
		on_engagement(target)
		melee_attack(target)

	else if(distance <= 1 && !holder.ICheckRangedAttack(target)) // Doesn't have projectile, but is pointblank
		ai_log("engage_target() : Attempting a melee attack.", AI_LOG_TRACE)
		on_engagement(target)
		melee_attack(target)

	// Shoot them.
	else if(holder.ICheckRangedAttack(target) && (distance <= max_range(target)) )
		on_engagement(target)
		if(firing_lanes && !test_projectile_safety(target))
			// Nudge them a bit, maybe they can shoot next time.
			var/turf/T = get_step(holder, pick(cardinal))
			if(T)
				holder.IMove(T) // IMove() will respect movement cooldown.
				holder.face_atom(target)
			ai_log("engage_target() : Could not safely fire at target. Exiting.", AI_LOG_DEBUG)
			return

		ai_log("engage_target() : Attempting a ranged attack.", AI_LOG_TRACE)
		ranged_attack(target)

	// Run after them.
	else if(!stand_ground)
		ai_log("engage_target() : Target ([target]) too far away. Exiting.", AI_LOG_DEBUG)
		set_stance(STANCE_APPROACH)

////////////////////////////Player controlled verbs///////////////////////////////

/mob/living/proc/polymorph()
	set name = "Polymorph"
	set desc = "Take the form of a non-humanoid creature."
	set category = "Abilities"

	var/list/beast_options = list("Rabbit" = /mob/living/simple_mob/vore/rabbit,
									"Red Panda" = /mob/living/simple_mob/vore/redpanda,
									"Fennec" = /mob/living/simple_mob/vore/fennec,
									"Giant Frog" = /mob/living/simple_mob/vore/aggressive/frog,
									"Giant Rat" = /mob/living/simple_mob/vore/aggressive/rat,
									"Wolf" = /mob/living/simple_mob/vore/wolf,
									"Dire Wolf" = /mob/living/simple_mob/vore/wolf/direwolf,
									"Fox" = /mob/living/simple_mob/animal/passive/fox/beastmode,
									"Panther" = /mob/living/simple_mob/vore/aggressive/panther,
									"Giant Snake" = /mob/living/simple_mob/vore/aggressive/giant_snake,
									"Otie" = /mob/living/simple_mob/vore/otie,
									"Squirrel" = /mob/living/simple_mob/vore/squirrel,
									"Raptor" = /mob/living/simple_mob/vore/raptor,
									"Giant Bat" = /mob/living/simple_mob/vore/bat,
									"Horse" = /mob/living/simple_mob/vore/horse,
									"Horse (Big)" = /mob/living/simple_mob/vore/horse/big,
									"Kelpie" = /mob/living/simple_mob/vore/horse/kelpie,
									"Bear" = /mob/living/simple_mob/animal/space/bear/brown/beastmode,
									"Seagull" = /mob/living/simple_mob/vore/seagull,
									"Sheep" = /mob/living/simple_mob/vore/sheep,
									"Azure Tit" = /mob/living/simple_mob/animal/passive/bird/azure_tit/beastmode,
									"Robin" = /mob/living/simple_mob/animal/passive/bird/european_robin/beastmode,
									"Cat" = /mob/living/simple_mob/animal/passive/cat/black/beastmode,
									"Tamaskan Dog" = /mob/living/simple_mob/animal/passive/dog/tamaskan,
									"Corgi" = /mob/living/simple_mob/animal/passive/dog/corgi,
									"Bull Terrier" = /mob/living/simple_mob/animal/passive/dog/bullterrier,
									"Duck" = /mob/living/simple_mob/animal/sif/duck,
									"Cow" = /mob/living/simple_mob/animal/passive/cow,
									"Chicken" = /mob/living/simple_mob/animal/passive/chicken,
									"Goat" = /mob/living/simple_mob/animal/goat,
									"Penguin" = /mob/living/simple_mob/animal/passive/penguin,
									"Goose" = /mob/living/simple_mob/animal/space/goose
									)

	var/chosen_beast = tgui_input_list(src, "Which form would you like to take?", "Choose Beast Form", beast_options)

	if(!chosen_beast)
		return


	var/mob/living/M = src
	log_debug("polymorph start")
	if(!istype(M))
		log_debug("polymorph istype")
		return

	if(M.stat)	//We can let it undo the TF, because the person will be dead, but otherwise things get weird.
		log_debug("polymorph stat")
		to_chat(src, span_warning("You can't do that in your condition."))
		return

	if(M.health <= 10)	//We can let it undo the TF, because the person will be dead, but otherwise things get weird.
		log_debug("polymorph injured")
		to_chat(src, span_warning("You are too injured to transform into a beast."))
		return

	visible_message("<b>\The [src]</b> begins significantly shifting their form.")
	if(!do_after(src, 10 SECONDS, src, exclusive = TASK_USER_EXCLUSIVE))
		visible_message("<b>\The [src]</b> ceases shifting their form.")
		return 0

	var/image/coolanimation = image('icons/obj/glamour.dmi', null, "animation")
	coolanimation.plane = PLANE_LIGHTING_ABOVE
	src.overlays += coolanimation
	spawn(10)
		src.overlays -= coolanimation

		log_debug("polymorph not dead")
		var/mob/living/new_mob = spawn_polymorph_mob(beast_options[chosen_beast])
		new_mob.faction = M.faction

		if(new_mob && isliving(new_mob))
			log_debug("polymorph new_mob")
			for(var/obj/belly/B as anything in new_mob.vore_organs)
				log_debug("polymorph new_mob belly")
				new_mob.vore_organs -= B
				qdel(B)
			new_mob.vore_organs = list()
			new_mob.name = M.name
			new_mob.real_name = M.real_name
			new_mob.verbs |= /mob/living/proc/revert_beast_form
			new_mob.verbs |= /mob/living/proc/set_size
			for(var/lang in M.languages)
				new_mob.languages |= lang
			M.copy_vore_prefs_to_mob(new_mob)
			new_mob.vore_selected = M.vore_selected
			if(ishuman(M))
				log_debug("polymorph ishuman part2")
				var/mob/living/carbon/human/H = M
				if(ishuman(new_mob))
					log_debug("polymorph ishuman(newmob)")
					var/mob/living/carbon/human/N = new_mob
					N.gender = H.gender
					N.identifying_gender = H.identifying_gender
				else
					log_debug("polymorph gender else")
					new_mob.gender = H.gender
			else
				log_debug("polymorph gender else 2")
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
			new_mob.visible_message("<b>\The [src]</b> has transformed into \the [chosen_beast]!")

/mob/living/proc/spawn_polymorph_mob(var/chosen_beast)
	log_debug("polymorph proc spawn mob")
	var/tf_type = chosen_beast
	log_debug("polymorph [tf_type]")
	if(!ispath(tf_type))
		log_debug("polymorph tf_type fail")
		return
	log_debug("polymorph tf_type pass")
	var/new_mob = new tf_type(get_turf(src))
	return new_mob

/mob/living/proc/glamour_invisibility()
	set name = "Invisibility"
	set desc = "Change your appearance to match your surroundings, becoming completely invisible to the naked eye."
	set category = "Abilities"

	if(stat)
		to_chat(src, span_warning("You can't go invisible when weakened like this."))
		return

	if(!cloaked)
		cloak()
		to_chat(src, span_warning("Your skin shimmers and shifts around you, hiding you from the naked eye."))
	else
		uncloak()
		to_chat(src, span_warning("The shifting of your skin settles down and you become visible once again."))
