/obj/item/organ/internal/appendix/horror
	name = "mass"
	color = "#660000"
	desc = "A twisted, warped version of a appendix covered in thick, red, pulsating tendrils."
	decays = FALSE
	can_reject = FALSE
	meat_type = /obj/item/reagent_containers/food/snacks/meat/worm
/obj/item/organ/internal/appendix/horror/Initialize(mapload)
	. = ..()
	adjust_scale(1.5,1.5)

/obj/item/organ/internal/appendix/horror/process()
	..()
	if(!owner) return
	if(is_bruised()) //They heal theirselves.
		damage -= 1
	if(owner.life_tick % 60 == 0 && prob(10))
		to_chat(owner, span_cult("You hear a whispering coming from your torso... " + pick("'You should come back'", "'Come back'", "'We're so empty without you'", "'You could stay forever'", "'Become one with us'")))

/obj/item/organ/internal/eyes/horror
	name = "orbits"
	color = "#660000"
	desc = "A twisted, warped version of eyes covered in thick, red, pulsating tendrils."
	innate_flash_protection = FLASH_PROTECTION_VULNERABLE //It's VERY good at seeing things...And it doesn't like light.
	decays = FALSE
	can_reject = FALSE
	meat_type = /obj/item/reagent_containers/food/snacks/meat/worm

/obj/item/organ/internal/eyes/horror/process()
	..()
	if(!owner)
		return
	if(is_bruised()) //They heal theirselves.
		damage -= 1
	//Get our spooky vision
	if(!owner.has_modifier_of_type(/datum/modifier/redsight))
		owner.add_modifier(/datum/modifier/redsight)
	if(owner.life_tick % 60 == 0 && prob(5))
		owner.drip(1)
		to_chat(owner, span_cult("Your eyes tear up and blood drips down your face."))
		owner.automatic_custom_emote(VISIBLE_MESSAGE, "blinks, a drop of blood trailing from their eye!", check_stat = FALSE)


/obj/item/organ/internal/heart/horror
	name = "mass"
	color = "#660000"
	desc = "A twisted, warped version of a heart covered in thick, red, pulsating tendrils."
	standard_pulse_level = PULSE_NONE //It's just quivering and pushing blood through in some strange method.
	decays = FALSE
	can_reject = FALSE
	meat_type = /obj/item/reagent_containers/food/snacks/meat/worm

/obj/item/organ/internal/heart/horror/process()
	..()
	if(!owner)
		return
	if(is_bruised()) //They heal theirselves.
		damage -= 1
	if(owner.life_tick % 20 == 0 && prob(5))
		owner.reagents.add_reagent(REAGENT_ID_NUMBENZYME, 0.2) //Lasts for 20 ticks. Their health hud will randomly go '?'
	if(owner.life_tick % 60 == 0)
		owner.reagents.add_reagent(REAGENT_ID_SPACEACILLIN, 1) //Keeping its host alive. 1u = 20 ticks

/obj/item/organ/internal/intestine/horror
	name = "mass"
	color = "#660000"
	desc = "A twisted, warped version of intestines covered in thick, red, pulsating tendrils."
	decays = FALSE
	can_reject = FALSE
	meat_type = /obj/item/reagent_containers/food/snacks/meat/worm
	var/escaping = FALSE
	var/escaping_attempts = 0
	var/entering_vent = FALSE
	var/obj/machinery/atmospherics/unary/vent_pump/entry_vent

/obj/item/organ/internal/intestine/horror/process()
	..()
	if(!owner && !escaping) return
	if(is_bruised()) //They heal theirselves.
		damage -= 1
	if(escaping && entry_vent)
		if(get_dist(src, entry_vent) <= 1 && !entering_vent)
			audible_message("[src] slithers into the [entry_vent.name]!", "You hear a wet, squelching sound.")
			entering_vent = TRUE
			mouse_opacity = 0 //No clicky
			fade_towards(entry_vent,45)
			QDEL_IN(src, 45)
		else if(!entering_vent)
			escaping_attempts += 1
			if(escaping_attempts >= 5)
				entry_vent = null
				escaping = FALSE //We tried and failed...
				escaping_attempts = 0
				audible_message("[src] stops squirming around.")


/obj/item/organ/internal/intestine/horror/Destroy()
	entry_vent = null
	. = ..()

/obj/item/organ/internal/intestine/horror/handle_organ_mod_special(var/removed = FALSE)
	..()
	if(removed)
		for(var/obj/machinery/atmospherics/unary/vent_pump/v in view(7,src))
			if(!v.welded)
				entry_vent = v
				audible_message("[src] tries to slither away!")
				walk_to(src, entry_vent, 1, 5)
				escaping = TRUE
				break

/obj/item/organ/internal/kidneys/horror
	name = "mass"
	color = "#660000"
	desc = "A twisted, warped version of kidneys covered in thick, red, pulsating tendrils."
	decays = FALSE
	can_reject = FALSE
	meat_type = /obj/item/reagent_containers/food/snacks/meat/worm

/obj/item/organ/internal/kidneys/horror/process()
	..()
	if(!owner) return
	if(is_bruised()) //They heal theirselves.
		damage -= 1

	var/datum/reagent/coffee = locate(/datum/reagent/drink/coffee) in owner.reagents.reagent_list
	if(coffee && owner.ingested)
		for(var/datum/reagent/drink/coffee/R in owner.ingested.reagent_list)
			R.holder.remove_reagent(REAGENT_ID_COFFEE, REM)
			owner.bloodstr.add_reagent(REAGENT_ID_HYPERZINE, REM)


/obj/item/organ/internal/liver/horror
	name = "mass"
	color = "#660000"
	desc = "A twisted, warped version of a liver covered in thick, red, pulsating tendrils."
	decays = FALSE
	can_reject = FALSE
	meat_type = /obj/item/reagent_containers/food/snacks/meat/worm

/obj/item/organ/internal/liver/horror/process()
	..()
	if(!owner)
		return
	if(is_bruised()) //They heal theirselves.
		damage -= 1
	var/datum/reagent/toxin/toxins = locate(/datum/reagent/toxin) in owner.reagents.reagent_list
	if(toxins)
		for(var/datum/reagent/toxin/R in owner.bloodstr.reagent_list)
			R.holder.remove_reagent(R.id, REM)
			owner.bloodstr.add_reagent(REAGENT_ID_NECROXADONE, REM*5) //5 multiplier of toxins to biomass
			owner.bloodstr.add_reagent(REAGENT_ID_MORTIFERIN, REM*3) //3x multiplier

/obj/item/organ/internal/lungs/horror
	name = "mass"
	color = "#660000"
	desc = "A twisted, warped version of lungs covered in thick, red, pulsating tendrils."
	decays = FALSE
	can_reject = FALSE
	meat_type = /obj/item/reagent_containers/food/snacks/meat/worm

/obj/item/organ/internal/lungs/horror/process()
	..()
	if(!owner)
		return
	if(is_bruised()) //They heal theirselves.
		damage -= 1
	if(owner.life_tick % 60 == 0 && prob(10))
		to_chat(owner, span_cult("You feel something quivering in your chest, making breathing impossible!"))
		owner.AdjustLosebreath(10)
		owner.automatic_custom_emote(VISIBLE_MESSAGE, "gasps for air!", check_stat = TRUE)

/obj/item/organ/internal/spleen/horror
	name = "mass"
	color = "#660000"
	desc = "A twisted, warped version of a spleen covered in thick, red, pulsating tendrils."
	decays = FALSE
	can_reject = FALSE
	meat_type = /obj/item/reagent_containers/food/snacks/meat/worm
	spleen_efficiency = 5

/obj/item/organ/internal/spleen/horror/process()
	..()
	if(!owner)
		return
	if(is_bruised()) //They heal theirselves.
		damage -= 1
	if(owner.vessel.total_volume < owner.vessel.maximum_volume) //Bloodloss
		owner.bloodstr.add_reagent(REAGENT_ID_SYNTHBLOOD, REM) //Get a little bit of blood added into your blood stream (that then metabolizes into actual blood)

/obj/item/organ/internal/stomach/horror
	name = "mass"
	color = "#660000"
	desc = "A twisted, warped version of a stomach covered in thick, red, pulsating tendrils."
	decays = FALSE
	can_reject = FALSE
	meat_type = /obj/item/reagent_containers/food/snacks/meat/worm
	var/spider_chance = 10 //for admemes

/obj/item/organ/internal/stomach/horror/process()
	..()
	if(!owner)
		return
	if(is_bruised()) //They heal theirselves.
		damage -= 1
	if(owner.life_tick % 60 == 0 && prob(spider_chance))
		var/turf/T = get_turf(owner)
		if(T)
			to_chat(owner, span_cult("You feel something quivering in your chest!"))
			owner.vomit(10, TRUE)
			var/spiders_to_spawn = rand(3,5)
			for(var/i = 0 to spiders_to_spawn)
				var/obj/effect/spider/spiderling/non_growing/horror/spider = new /obj/effect/spider/spiderling/non_growing/horror(T)
				spider.faction = owner.faction
				spider.color = "[owner.species.blood_color]"
				spider.name = "writhing tendril mass"
				spider.desc = "A small, writhing mass of flesh and tendrils."

/obj/item/organ/internal/voicebox/horror
	name = "mass"
	color = "#660000"
	desc = "A twisted, warped version of a voicebox covered in thick, red, pulsating tendrils."
	decays = FALSE
	can_reject = FALSE
	meat_type = /obj/item/reagent_containers/food/snacks/meat/worm
	will_assist_languages = list(LANGUAGE_DAEMON)
	var/speak_chance = 25 //25% chance to speak Daemon every 10 ticks
	var/datum/language/daemon //Storage for demon language so we don't have to constantly set it.

/obj/item/organ/internal/voicebox/horror/Initialize(mapload)
	. = ..()
	daemon = GLOB.all_languages[LANGUAGE_DAEMON]

/obj/item/organ/internal/voicebox/horror/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)
	..()
	target.add_language(LANGUAGE_DAEMON) //Learn Daemon
	target.default_language = daemon //Begin speaking Daemon.

/obj/item/organ/internal/voicebox/horror/process()
	..()
	if(!owner)
		return
	if(is_bruised()) //They heal theirselves.
		damage -= 1
	if(owner.life_tick % 10 == 0 && prob(speak_chance))
		owner.default_language = daemon //Swap back to Daemon.
		if(prob(5)) //1/20 on a 1/4 chance. 1/80 chance every 10 ticks.
			owner.say(pick("Join us", "Become one with us", "Join the Flesh", "Come to us", "[owner.real_name] is just a vessel.", "You can be just like us."))
