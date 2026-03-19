/mob/living/simple_mob/animal/synx //Player controlled variant
	//on inteligence https://synx.fandom.com/wiki/Behavior/Intelligence //keeping this here for player controlled synxes.
	name = "Synx"
	desc = "A cold blooded, genderless, parasitic eel from the more distant and stranger areas of the cosmos. Plain, white, perpetually grinning and possessing a hunger as enthusiastic and endless as humanity's sense of exploration."
	tt_desc = "synxus pergulus"

	//Synx species belongs to ChimeraSynx , Base sprites made by: SpitefulCrow
	icon = 'icons/mob/synx_modular.dmi'//giving synxes their own DMI file!
	icon_state = "synx_living"
	icon_living = "synx_living"
	icon_dead = "synx_dead"
	mob_bump_flag = SIMPLE_ANIMAL //This not existing was breaking vore bump for some reason.
	parasitic = TRUE //Digestion immunity var

	var/list/speak = list()
	var/speak_chance = 0 //MAy have forgotten to readd that.
	//Synx speech code overrides normal speech code but is still a x in 200 chance of triggereing, as all mobs do.
	//VAR$ SETUP
	//annoying for player controlled synxes.
	var/realname = null
	var/poison_per_bite = 1 //Even with 2 this was OP with a 99% injection chance
	var/poison_chance = 99.666
	var/poison_type = "synxchem"//inaprovalin, but evil
	var/transformed_state = "synx_t"
	var/stomach_distended_state = "synx_s"
	var/transformed = FALSE
	var/memorysize = 50 //Var for how many messages synxes remember if they know speechcode
	var/list/voices = list()
	var/acid_damage_lower = SYNX_LOWER_DAMAGE - 1 //Variables for a hacky way to change to burn damage when they vomit up their stomachs. Set to 1 less than melee damage because it takes a minimum of 1 brute damage for this to activate.
	var/acid_damage_upper = SYNX_UPPER_DAMAGE - 1
	var/stomach_distended = 0 //Check for whether or not the synx has vomitted up its stomach.
	var/forcefeedchance = 20 //This needs to be defined in the parent because code.
	// Recycling bigdragon code for modular system. Hope this works! -Azel
		//Sprites are layered ontop of one-another in order of this list
	var/list/overlay_colors = list(
		"Body" = "#FFFFFF",
		"Horns" = "#FFFFFF",
		"Marks" = "#FFFFFF",
		"Eyes" = "#FFFFFF"
	)
	//If you add any more, it's as easy as adding the icons to these lists
	var/list/body_styles = list(
		"Normal"
	)
	var/body
	var/list/horn_styles = list(
		"None",
		"Curved",
		"Straight",
		"Nub",
		"Capra",
	)
	var/horns
	var/list/marking_styles = list(
		"None",
		"Basic",
		"Star",
		"Short",
		"Long",
	)
	var/markings
	var/list/eye_styles = list(
		"Normal"
	)
	var/eyes
//TODO: Add more customization options, these are pretty scarce
	faction = "Synx"

	//intelligence_level = SA_ANIMAL
	ai_holder_type = null //added for player controlled variant only.

	maxHealth = 75 //Lowered from 150. 150 is wayyy too high for a noodly stealth predator. - Lo
	health = 75
	movement_cooldown = 6
	see_in_dark = 6
	grab_resist = 2 //slippery. %  grabwill not work. Should be 10-20%. -Lo
	armor = list(			// will be determined
				"melee" = 0, //Changed from 20.They don't have scales or armor. -LO
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0, //Same as above. -LO
				"bio" = 50, //Nerfed from 100. They should have some protection against these things, but 100 is pushing it. -Lo
				"rad" = 100) //Keeping 100 rad armor as mobs cannot easily get radiation storm announcements. If this is reduced it'd be a good idea to make it 100 for the ai types.
	has_hands = 1
	pass_flags = PASSTABLE

	/*
	response_help  = "pokes the synx, shifting the fur-like bristles on its body."
	response_disarm = "gently pushes aside the synx, dislodging a clump of bristly hair in your hand. The substance quickly melts upon contact with your sweat."
	response_harm   = "tries to hit the synx. This tears out an area of fur which firmly melts upon contact, covering you in something sticky."
	*/
	// I dont think the person who wrote the above descriptions realized what they were used for, because they dont work at all. Leaving these commented incase someone wants to reimplement this properly someday.
	response_help = "pokes"
	response_disarm = "awkwardly shoves"
	//Leaving response_harm the same as default; "hits".

	melee_damage_lower = SYNX_LOWER_DAMAGE //Massive damage reduction, will be balanced with toxin injection/ //LO-  Made up for in skills. Toxin injection does not technically cause damage with these guys. Stomach acid does when they disegage their stomach from their mouths does, but that could be done differently.
	melee_damage_upper = SYNX_UPPER_DAMAGE
	attacktext = list("clawed") // "You are [attacktext] by the mob!"
	var/distend_attacktext = list("smacked")
	var/initial_attacktext = list("clawed") //I hate needing to do it this way.
	friendly = list("prods") // "The mob [friendly] the person."
	attack_armor_pen = 0			// How much armor pen this attack has. //Changed from 40. -Lo
	attack_sharp = 1
	attack_edge = 1
	attack_armor_type = "melee" //Default is melee but I'm stating this explicitly to make it more obvious to anybody reading this

//Vore stuff//leaving most of this here even though its no going to be an AI controlled variant.
	vore_active = 1
	vore_capacity = 2
	vore_pounce_chance = 50
	vore_bump_chance = 10
	vore_bump_emote = "Slowly wraps its tongue around, and slides its drooling maw over the head of"
	vore_standing_too = 1 //I believe this lets it vore standing people, rather than only resting.
	vore_ignores_undigestable = 0 //Synx don't care if you digest or not, you squirm fine either way.
	vore_default_mode = DM_HOLD
	vore_digest_chance = 45		// Chance to switch to digest mode if resisted
	vore_absorb_chance = 0
	vore_escape_chance = 10
	vore_icons = SA_ICON_LIVING //no vore icons //TODO: Implement these, I have the sprites done but they're unnecessary for core function rn and I'd rather get this into a working state first -Azel
	swallowTime = 6 SECONDS //Enter the eel you nerd

//Shouldn't be affected by lack of atmos, it's a space eel. //nah lets give him some temperature

	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323		//Above 50 Degrees Celcius
	min_oxy = 0
	max_oxy = 0 //Maybe add a max
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0 //Maybe add a max
	min_n2 = 0
	max_n2 = 0 //Maybe add a max
	// TODO: Set a max temperature of about 20-30 above room temperatures. Synx don't like the heat.


/mob/living/simple_mob/animal/synx/Initialize(mapload)
	. = ..()
	src.adjust_nutrition(src.max_nutrition)
	build_icons(1)
	if(!voremob_loaded)
		voremob_loaded = TRUE
		init_vore()
	mob_radio = new /obj/item/radio/headset/mob_headset(src)	//We always give radios to spawned mobs anyway

/mob/living/simple_mob/animal/synx/get_available_emotes()
	. = ..()
	. |= GLOB.human_default_emotes //Synx are great at mimicking

/mob/living/simple_mob/animal/synx/ai //AI controlled variant

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate
