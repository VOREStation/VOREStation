/mob/living/simple_mob/vox
	min_oxy = 0
	max_oxy = 0
	min_tox = 5
	max_tox = 0
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0 //breathe N2
	max_n2 = 0

	species_sounds = "Vox"
	pain_emote_1p = list("shriek")
	pain_emote_3p = list("shrieks")

/mob/living/simple_mob/vox/armalis
	name = "serpentine alien"
	real_name = "serpentine alien"
	desc = "A one-eyed, serpentine creature, half-machine, easily nine feet from tail to beak!"
	icon = 'icons/mob/vox.dmi'
	icon_state = "armalis"
	icon_living = "armalis"
	maxHealth = 500
	health = 500
	response_harm = "slashes at the"
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 40
	attacktext = "slammed its enormous claws into"
	movement_cooldown = 2
	attack_sound = 'sound/weapons/bladeslice.ogg'
	status_flags = 0
	max_oxy = 0

	var/armour = null
	var/amp = null
	var/quills = 3

/mob/living/simple_mob/vox/armalis/death(var/gibbed = FALSE)
	..(TRUE)
	var/turf/gloc = get_turf(loc)
	visible_message(span_bolddanger("[src] shudders violently and explodes!"),span_warning("You feel your body rupture!"))
	gib()
	explosion(gloc, -1, -1, 3, 5)
	qdel(src)

/mob/living/simple_mob/vox/armalis/attackby(var/obj/item/O as obj, var/mob/user as mob)
	base_attack_cooldown = 5
	if(O.force)
		if(O.force >= 25)
			var/damage = O.force
			if (O.damtype == HALLOSS)
				damage = 0
			health -= damage
			for(var/mob/M in viewers(src, null))
				if ((M.client && !( M.blinded )))
					M.show_message(span_danger("[src] has been attacked with the [O] by [user]. "))
		else
			for(var/mob/M in viewers(src, null))
				if ((M.client && !( M.blinded )))
					M.show_message(span_danger("The [O] bounces harmlessly off of [src]. "))
	else
		to_chat(usr, span_warning("This weapon is ineffective, it does no damage."))
		for(var/mob/M in viewers(src, null))
			if ((M.client && !( M.blinded )))
				M.show_message(span_warning("[user] gently taps [src] with the [O]. "))

/mob/living/simple_mob/vox/armalis/verb/fire_quill(mob/target as mob in oview())


	set name = "Fire quill"
	set desc = "Fires a viciously pointed quill at a high speed."
	set category = "Alien"

	if(quills<=0)
		return

	to_chat(src, span_warning("You launch a razor-sharp quill at [target]!"))
	for(var/mob/O in oviewers())
		if ((O.client && !( O.blinded )))
			to_chat(O, span_warning("[src] launches a razor-sharp quill at [target]!"))

	var/obj/item/arrow/quill/Q = new(loc)
	Q.add_fingerprint(ckey)
	Q.throw_at(target,10,30)
	quills--

	spawn(100)
		to_chat(src, span_warning("You feel a fresh quill slide into place."))
		quills++

/mob/living/simple_mob/vox/armalis/verb/message_mob()
	set category = "Alien"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null

	targets += getmobs() //Fill list, prompt user with list
	target = tgui_input_list(src, "Select a creature!", "Speak to creature", targets)
	text = tgui_input_text(src, "What would you like to say?", "Speak to creature")

	if (!target || !text)
		return

	var/mob/M = targets[target]

	if(istype(M, /mob/observer/dead) || M.stat == DEAD)
		to_chat(src, "Not even the armalis can speak to the dead.")
		return

	to_chat(M, span_notice("Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]"))
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.name == "Vox")
			return
		to_chat(H, span_warning("Your nose begins to bleed..."))
		H.drip(1)

/mob/living/simple_mob/vox/armalis/verb/shriek()
	set category = "Alien"
	set name = "Shriek"
	set desc = "Give voice to a psychic shriek."

/mob/living/simple_mob/vox/armalis/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O,/obj/item/vox/armalis_armour))
		user.drop_item(O)
		armour = O
		movement_cooldown = 4
		maxHealth += 200
		health += 200
		visible_message(span_notice("[src] is quickly outfitted in [O] by [user]."),span_notice("You quickly outfit [src] in [O]."))
		regenerate_icons()
		return
	if(istype(O,/obj/item/vox/armalis_amp))
		user.drop_item(O)
		amp = O
		visible_message(span_notice("[src] is quickly outfitted in [O] by [user]."),span_notice("You quickly outfit [src] in [O]."))
		regenerate_icons()
		return
	return ..()

/mob/living/simple_mob/vox/armalis/regenerate_icons()
	..()
	overlays = list()
	if(armour)
		var/icon/armour = image('icons/mob/vox.dmi',"armour")
		movement_cooldown = 4
		overlays += armour
	if(amp)
		var/icon/amp = image('icons/mob/vox.dmi',"amplifier")
		overlays += amp
	return

/obj/item/vox/armalis_armour

	name = "strange armour"
	desc = "Hulking reinforced armour for something huge."
	icon = 'icons/inventory/suit/item.dmi'
	icon_state = "armalis_armour"
	item_state = "armalis_armour"

/obj/item/vox/armalis_amp

	name = "strange lenses"
	desc = "A series of metallic lenses and chains."
	icon = 'icons/inventory/head/item.dmi'
	icon_state = "amp"
	item_state = "amp"
