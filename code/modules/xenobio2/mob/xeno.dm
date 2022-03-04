//First we define certain flags, can be expanded upon later.

/*
Basic definition of creatures for Xenobiology
Also includes Life and New
*/

/mob/living/simple_mob/xeno
	name = "Xeno"
	real_name = "Xeno"
	faction = "xeno"	//Needs to be set.
	desc = "Something's broken, yell at someone."
	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = list("hit")
	attack_sound = null
	friendly = "touches"
	environment_smash = 0

	var/datum/xeno/traits/traitdat	//Trait datum.

	var/internal_vol = 1000 //Internal volume for ingesting/injected reagents

	var/obj/temp_chem_holder //Used in handle_reagents()

	var/mutable = NOMUT //Flag for mutation.
	var/nameVar = "Blah"
	var/mut_instability = 0
	var/stasis = 0
	var/mut_level = 0 //How mutated a specimen is. Irrelevant while mutable = NOMUT.
	var/mut_max = 100000
	var/colored = 1
	var/maleable = MIN_MALEABLE //How easy is it to manipulate traitdat.traits after it's alive.
	var/stability = 0	//Used in gene manipulation

	//Traits that might not be maleable.
	var/list/chemreact = list()
	var/hunger_factor = 10
	var/chromatic = 0
	var/starve_damage = 0

	//Used for speech learning
	var/list/speech_buffer = list()

	var/list/default_chems = list()


//Life additions
/mob/living/simple_mob/xeno/Life()
	if(stasis)
		stasis--
		if(stasis < 0)
			stasis = 0
		return 0

	..()
	if(!(stat == DEAD))
		handle_reagents()
		if((mut_level >= mut_max) && !(mutable & NOMUT))
			Mutate()
			mut_level -= mut_max

		ProcessSpeechBuffer()

		//Have to feed the xenos somehow.
		if(nutrition < 0)
			nutrition = 0
		if((nutrition > 0 ) && traitdat.traits[TRAIT_XENO_EATS])
			if(nutrition >= 300)
				adjust_nutrition(-hunger_factor)
		else
			if(traitdat.traits[TRAIT_XENO_EATS])
				health = starve_damage

		return 1	//Everything worked okay.

/mob/living/simple_mob/xeno/Initialize()

	traitdat = new()

	ProcessTraits()

	. = ..()
	if(colored)
		color = traitdat.get_trait(TRAIT_XENO_COLOR)
	create_reagents(internal_vol)
	temp_chem_holder = new()
	temp_chem_holder.create_reagents(20)
	nutrition = 350
	for(var/R in default_chems)
		traitdat.chems[R] = default_chems[R]

	traitdat.source = name

	if(!health)
		set_stat(DEAD)

/mob/living/simple_mob/xeno/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/beam/stun/xeno))
		var/obj/item/projectile/beam/stun/xeno/hit = Proj
		stasis += hit.stasisforce
	..()

/mob/living/simple_mob/xeno/Destroy()
	traitdat.Destroy()	//Let's clean up after ourselves.
	traitdat = null
	..()