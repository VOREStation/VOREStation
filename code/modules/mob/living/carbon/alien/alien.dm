/mob/living/carbon/alien
	name = "alien"
	desc = "What IS that?"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alien"
	pass_flags = PASSTABLE
	health = 100
	maxHealth = 100
	mob_size = 4
	blocks_emissive = EMISSIVE_BLOCK_UNIQUE

	inventory_panel_type = null // Disable inventory

	var/adult_form
	var/dead_icon
	var/amount_grown = 0
	var/max_grown = 200
	var/time_of_birth
	var/language
	var/death_msg = "lets out a waning guttural screech, green blood bubbling from its maw."
	var/can_namepick_as_adult = 0
	var/adult_name
	var/instance_num

/mob/living/carbon/alien/Initialize(mapload)
	. = ..()

	time_of_birth = world.time

	add_verb(src, /mob/living/proc/ventcrawl)
	add_verb(src, /mob/living/proc/hide)

	instance_num = rand(1, 1000)
	name = "[initial(name)] ([instance_num])"
	real_name = name
	regenerate_icons()

	if(language)
		add_language(language)

	gender = NEUTER

/mob/living/carbon/alien/u_equip(obj/item/W as obj)
	return

/mob/living/carbon/alien/restrained()
	return 0

/mob/living/carbon/alien/cannot_use_vents()
	return

/mob/living/carbon/alien/get_default_language()
	if(default_language)
		return default_language
	return GLOB.all_languages["Xenomorph"]

/mob/living/carbon/alien/say_quote(var/message, var/datum/language/speaking = null)
	var/verb = "hisses"
	var/ending = copytext(message, length(message))

	if(speaking && (speaking.name != "Galactic Common")) //this is so adminbooze xenos speaking common have their custom verbs,
		verb = speaking.get_spoken_verb(ending)          //and use normal verbs for their own languages and non-common languages
	else
		if(ending == "!")
			verb = "roars"
		else if(ending == "?")
			verb = "hisses curiously"
	return verb
