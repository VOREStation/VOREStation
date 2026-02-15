#define SYNX_LOWER_DAMAGE 2 //Using defines to make damage easier to tweak for hacky burn attack code.
#define SYNX_UPPER_DAMAGE 6


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

/mob/living/simple_mob/animal/synx/load_default_bellies()
	. = ..()
	var/obj/belly/B = vore_selected
	//B.human_prey_swallow_time = 6 SECONDS //doesnt work
	//B.nonhuman_prey_swallow_time = 3 SECONDS //doesnt work
	B.vore_verb = "swallow"
	B.name = "stomach"
	B.desc	= "You're pulled into the snug stomach of the synx. The walls knead weakly around you, coating you in thick, viscous fluids that cling to your body, that soon starts to tingle and burn..."
	B.digest_burn = 1
	B.digest_brute = 0
	B.emote_lists[DM_HOLD] = list(
	"The walls churn around you, soaking you in thick, smelling fluid as you're kneaded and rolled about in the surprisingly roomy, but still snug, space.",
	"The unusually cool stomach rolls around you slowly and lazily, trying to almost knead you to sleep gently as the synx pulses around you.",
	"The thick, viscous fluids cling to your body soaking in deep, giving you a full bath with the kneading of the walls helping to make sure you'll be smelling like synx stomach for days."
	)
	B.emote_lists[DM_DIGEST] = list(
	"The stomach kneads roughly around you, squishing and molding to your shape, with the thick fluids clinging to your body and tingling, making it hard to breathe.",
	"Firm churns of the stomach roll and knead you around, your body tingling as fur sizzles all around you, your body getting nice and tenderized for the stomach.",
	"Your body tingles and the air smells strongly of acid, as the stomach churns around you firmly and slowly, eager to break you down.",
	"You're jostled in the stomach as the synx lets out what can only described as an alien belch, the space around you getting even more snug as the thick acids rise further up your body."
	)
	B.digest_messages_prey = list(
	"Your eyes grow heavy as the air grows thin in the stomach, the burning of the acids slowly putting you into a final slumber, adding you to the synx's hips and tail.",
	"Slowly, the stinging and burning of the acids, and the constant churning is just too much, and with a few final clenches, your body is broken down into fuel for the synx.",
	"The acids and fluids rise up above your head, quickly putting an end to your squirming and conciousness.. the stomach eager to break you down completely.",
	"The synx lets out an audible belch, the last of your air going with it, and with a few audible crunches from the outside, the stomach claims you as food for the parasite."
	)
	B.mode_flags = DM_FLAG_NUMBING	//Prey are more docile when it doesn't hurt.

/* //OC-insert mob removals. Commenting out instead of full removal as there's some good detail here.
/mob/living/simple_mob/animal/synx/ai/pet/asteri/load_default_bellies()
	. = ..()
	var/obj/belly/B = vore_selected
	B.desc    = "The synx eagerly swallows you, taking you from its gullet into its long, serpentine stomach. The internals around you greedily press into your from all sides, keeping you coated in a slick coat of numbing fluids..."
	B.digest_burn = 2
	B.digest_brute = 0 //no brute should be done. ramping up burn as a result. this is acid. -Lo
	B.emote_lists[DM_HOLD] = list(
	"Your taut prison presses and pads into your body, the synx squeezing around you almost constrictingly tight while the rolling pulses of muscle around you keep your squirms well-contained.",
	"You can feel parts of you sink and press into the squishy stomach walls as the synx's gut seems to relax, the wet ambience of its stomach muffling the parasite's various heartbeats.",
	"You can hear the synx teasingly mimic the sounds you've made while it's eaten you, the stomach walls practically massaging more of numbing fluid into you as its innards do their best to tire you out.",
	)
	B.emote_lists[DM_DIGEST] = list(
	"The stomach gives a crushing squeeze around your frame, its body restraining your movements and pressing digestive fluids deeper into you with overwhelming pressure from all sides..",
	"The synx's insides greedily press into you all over, kneading around your body and softening you up for the slurry of numbing acid that's pooled around your melting frame.",
	"You can hear a cacophony of wet churns and gurgles from the synx's body as it works on breaking you down, the parasite eagerly awaiting your final moments.",
	"The tight, fleshy tunnel constricts around you, making it even harder to breathe the already thin air as the digestive cocktail around you wears you out.",
	)
	B.digest_messages_prey = list(
	"You finally give in to the constricting pressure, softened up enough for the acids around you to turn your entire being into a gooey slop to be pumped through its body.",
	"Slipping past the point of saving, your body gives out on you as the stomach walls grind your goopy remains into a chunky sludge, leaving behind only a few acid-soaked bones for it to stash in the vents.",
	"The constant fatal massage pulls you under, your conciousness fading away as you're drawn into a numb, permanent sleep. The body you leave behind is put to good use as a few extra pounds on the synx's frame, its now-wider hips making it just a little harder to squeeze through the vents it's so fond of.",
	"The synx's body gleefully takes what's left of your life, Asteri's usually-repressed sadism overwhelmed with a sinister satisfaction in snuffing you out as your liquefied remains gush into a bit more heft on the parasite's emaciated frame.",
	)
*/

/mob/living/simple_mob/animal/synx/Initialize(mapload, is_pet) //this is really cool. Should be able to ventcrawl canonicaly, contort, and make random speech.
//some things should be here that arent tho.
	. = ..()
	if(is_pet)
		return
	add_verb(src,/mob/living/proc/ventcrawl)
	add_verb(src,/mob/living/simple_mob/animal/synx/proc/distend_stomach)
	add_verb(src,/mob/living/simple_mob/proc/contort)
	add_verb(src,/mob/living/simple_mob/animal/synx/proc/sonar_ping)
	add_verb(src,/mob/living/proc/shred_limb)
	add_verb(src,/mob/living/simple_mob/animal/synx/proc/disguise)
	add_verb(src,/mob/living/simple_mob/animal/synx/proc/randomspeech)
	add_verb(src,/mob/living/simple_mob/animal/synx/proc/set_style)
	realname = name
	voices += "Garbled voice"
	voices += "Unidentifiable Voice"
	speak += "Who is there?"
	speak += "What is that thing?!"

//////////////////////////////////////////////////////////////////////////////////////
///////////////////////////// SPECIAL ITEMS/REAGENTS !!!! ////////////////////////////
////////////////////////////////////////////////////////////////////////////////////// //keeping most of these the same except the stuff that apply to the standard synx. -lo
/*
/datum/seed/hardlightseed/
	name = PLANT_NULLHARDLIGHT
	seed_name = "Biomechanical Hardlight generator seed"
	display_name = "Biomechanical Hardlight stem"
	mutants = null
	can_self_harvest = 1
	has_mob_product = null

/datum/seed/hardlightseed/New()
	..()
	set_trait(TRAIT_IMMUTABLE,1) //Normal genetics wont be able to do much with the mechanical parts, its more a machine than a real plant
	set_trait(TRAIT_MATURATION,1)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"alien4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#00FFFF")
	set_trait(TRAIT_PLANT_COLOUR,"#00FFFF")
	set_trait(TRAIT_PLANT_ICON,"alien4") //spooky pods
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0)
	set_trait(TRAIT_WATER_CONSUMPTION, 0)

/datum/seed/hardlightseed/typesx //Respawn mechanism for the synx
	name = "hardlightseedsx"
	seed_name = "hardlightseedsx"
	display_name = "Biomechanical Hardlight Generator SX"//PLant that is part mechanical part biological
	has_mob_product = /mob/living/simple_mob/animal/synx/ai/pet/holo
*/ //This is defined in seed_datums_ch

/obj/item/seeds/hardlightseed/typesx
	seed_type = "hardlightseedsx"

/datum/reagent/inaprovaline/synxchem
	name = "Alien nerveinhibitor"
	description = "A toxin that slowly metabolizes damaging the person, but makes them unable to feel pain."
	id = "synxchem"
	metabolism = REM * 0.1 //Slow metabolization to try and mimic permanent nerve damage without actually being too cruel to people
	color = "#FFFFFF"
	overdose = REAGENTS_OVERDOSE * 4 //But takes a lot to OD

/datum/reagent/inaprovaline/synxchem/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		if(prob(8))
			M.custom_pain("You [pick("feel numb!","feel dizzy and heavy.","feel strange!")]",60)
		if(prob(2))
			M.custom_pain("You [pick("suddenly lose control over your body!", "can't move!", "are frozen in place.", "can't struggle!")]",60)
			M.AdjustParalysis(1)
//		M.add_chemical_effect(CE_STABLE, 15)
		M.add_chemical_effect(CE_PAINKILLER, 60)
		// M.adjustToxLoss(0.4) //Dealing twice of it as tox, even if you have no brute, its not true conversion. Synxchem without stomach shoved out of its mouth isn't going to do tox. -Lo
	//	M.adjustHalLoss(1) //we do not need halloss as well as paralyze. lo-

/datum/reagent/inaprovaline/synxchem/holo
	name = "SX type simulation nanomachines" //Educational!
	description = "Type SX nanomachines to simulate what it feels like to come in contact with a synx, minus the damage"
	id = "fakesynxchem"
	metabolism = REM * 1 //ten times faster for convenience of testers.
	color = "#00FFFF"
	overdose = REAGENTS_OVERDOSE * 20 //it's all fake. But having nanomachines move through you is not good at a certain amount.

/datum/reagent/inaprovaline/synxchem/holo/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		if(prob(5))
			M.custom_pain("You feel no pain!",60)
		if(prob(2))
			M.custom_pain("You suddenly lose control over your body!",60)
			M.AdjustParalysis(1)
		M.add_chemical_effect(CE_STABLE, 15)
		M.add_chemical_effect(CE_PAINKILLER, 50)
		M.adjustBruteLoss(-0.2)//Made to simulate combat, also useful as very odd healer.
		M.adjustToxLoss(-0.2) //HELP ITS MAULING ME!
		M.adjustFireLoss(-0.2) //huh this mauling aint so bad
		//M.adjustHalLoss(10) //OH MY GOD END MY PAIN NOW WHO MADE THIS SIMULATION //Removing because this is spammy and stunlocks for absurd durations

/datum/reagent/inaprovaline/synxchem/clown
	name = "HONK"
	description = "HONK"
	id = "clownsynxchem"
	metabolism = REM * 0.5
	color = "#FFFFFF"
	overdose = REAGENTS_OVERDOSE * 200

/datum/reagent/inaprovaline/synxchem/clown/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(0.01)
	playsound(M.loc, 'sound/items/bikehorn.ogg', 50, 1)
	M.adjustBruteLoss(-2)//healing brute
	if(prob(1))
		M.custom_pain("I have no horn but i must honk!",60)
	if(prob(2))
		var/location = get_turf(M)
		new /obj/item/bikehorn(location)
		M.custom_pain("You suddenly cough up a bikehorn!",60)

/*why is this in here twice? -Lo
	/datum/reagent/inaprovaline/synxchem/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
		if(alien != IS_DIONA)
		if(prob(5))
			M.custom_pain("You feel no pain despite the clear signs of damage to your body!",0)
		if(prob(2))
			M.custom_pain("You suddenly lose control over your body!",0)
			M.AdjustParalysis(1)
		M.add_chemical_effect(CE_STABLE, 15)
		M.add_chemical_effect(CE_PAINKILLER, 50)
		M.adjustBruteLoss(-0.2)//healing brute
		M.adjustToxLoss(0.1) //Dealing half of it as tox
		M.adjustHalLoss(1) //dealing 5 times the amount of brute healed as halo, but we cant feel pain yet
		// ^ I have no idea what this might cause, my ideal plan is that once the pain killer wears off you suddenly collapse;
		//Since Halloss is not "real" damage this should not cause death
*/

/datum/reagent/inaprovaline/synxchem/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien != IS_DIONA)
		M.make_dizzy(10)
		if(prob(5))
			M.AdjustStunned(1)
		if(prob(2))
			M.AdjustParalysis(1)


/datum/reagent/inaprovaline/synxchem/holo/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	return

/datum/reagent/inaprovaline/synxchem/clown/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	return



//////////////////////////////////////////////////////////////////////////////////////
///////////////////////////// PASSIVE POWERS!!!! /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
// nevermind. I added any roleplay flavor weird fur mechanics to happen when you touch or attack the synx.

/mob/living/simple_mob/animal/synx/apply_melee_effects(var/atom/A) //Re-adding this for AI synx
	if(stomach_distended) //Hacky burn damage code
		if(isliving(A)) //Only affect living mobs, should include silicons. This could be expanded to deal special effects to acid-vulnerable objects.
			var/mob/living/L = A
			var/armor_modifier = abs((L.getarmor(null, "bio") / 100) - 1) //Factor in victim bio armor
			var/amount = rand(acid_damage_lower, acid_damage_upper) //Select a damage value
			var/damage_done = amount * armor_modifier
			if(damage_done > 0) //sanity check, no healing the victim if somehow this is a negative value.
				L.adjustFireLoss(damage_done)
				return
			else
				to_chat(src,span_notice("Your stomach bounces off of the victim's armor!"))
				return
		return //If stomach is distended, return here to perform no forcefeeding or poison injecton.

	if(isliving(A))
		var/mob/living/L = A

/*		if(prob(forcefeedchance) && !ckey)//Forcefeeding code //Only triggers if not player-controlled //This does not currently work
			L.Weaken(2)
			update_icon()
			set_AI_busy(TRUE)
			src.feed_self_to_grabbed(src,L)
			update_icon()
			set_AI_busy(FALSE)
*/
		if(L.reagents) //Seemingly broken. Would probably be really annoying anyways, so probably for the best that it doesn't work. -Azel
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				if(prob(poison_chance))
					to_chat(L, span_warning("You feel a strange substance on you."))
					L.reagents.add_reagent(poison_type, poison_per_bite)



/mob/living/simple_mob/animal/synx/hear_say(message,verb,language,fakename,isItalics,var/mob/living/speaker)
	. = ..()
	if(!message || !speaker)    return
	if (speaker == src) return
	speaker = speaker.GetVoice()
	speak += message
	voices += speaker
	if(voices.len>=memorysize)
		voices -= (pick(voices))//making the list more dynamic
	if(speak.len>=memorysize)
		speak -= (pick(speak))//making the list more dynamic
	if(resting)
		resting = !resting
	if(message=="Honk!")
		bikehorn()

/mob/living/simple_mob/animal/synx/ai/pet/clown/Life()
	..()
	if(vore_fullness)
		size_multiplier = 1+(0.5*vore_fullness)
		update_icons()
	if(!vore_fullness && size_multiplier != 1)
		size_multiplier = 1
		update_icons()
/mob/living/simple_mob/animal/synx/Life()
	..()
//mob/living/simple_mob/animal/synx/ai/handle_idle_speaking() //Only ai-controlled synx will randomly speak
	if(voices && prob(speak_chance/2))
		randomspeech()

/mob/living/simple_mob/animal/synx/perform_the_nom(mob/living/user, mob/living/prey, mob/living/pred, obj/belly/belly, delay) //Synx can only eat people if their organs are on the inside.
	if(stomach_distended)
		to_chat(src,span_notice("You can't eat people without your stomach inside of you!"))
		return
	else
		..()

//////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// POWERS!!!! /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

/mob/living/simple_mob/proc/contort()
	set name = "contort"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities.Synx"

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if(status_flags & HIDING)
		status_flags &= ~HIDING
		reset_plane_and_layer()
		to_chat(src,span_notice("You have stopped hiding."))
	else
		status_flags |= HIDING
		layer = HIDING_LAYER //Just above cables with their 2.44
		plane = OBJ_PLANE
		to_chat(src,span_notice("You are now hiding."))


	update_icons()

/mob/living/simple_mob/animal/synx/proc/disguise()
	set name = "Toggle Form"
	set desc = "Switch between amorphous and humanoid forms."
	set category = "Abilities.Synx"

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	// If transform isn't true
	if(stomach_distended)
		to_chat(src,span_warning("You can't disguise with your stomach outside of your body!"))
		return
	if(!transformed)
		to_chat(src,span_warning("Now they see your true form."))
		icon_living = transformed_state //Switch state to transformed state
		movement_cooldown = 3
	else // If transformed is true.
		to_chat(src,span_warning("You changed back into your disguise."))
		icon_living = initial(icon_living) //Switch state to what it was originally defined.
		movement_cooldown = 6


	transformed = !transformed
	update_icons()

/mob/living/simple_mob/animal/synx/proc/randomspeech()
	set name = "speak"
	set desc = "Take a sentence you heard and speak it."
	set category = "Abilities.Synx"
	if(speak && voices)
		handle_mimic()
	else
		usr << span_warning("YOU NEED TO HEAR THINGS FIRST, try using Ventcrawl to eevesdrop on nerds.")

/mob/living/simple_mob/animal/synx/proc/handle_mimic()
	name = pick(voices)
	spawn(2)
		src.say(pick(speak))
	spawn(5)
		name = realname

//lo- procs adjusted to mobs.

/mob/living/simple_mob/animal/synx
	var/next_sonar_ping = 0

/mob/living/simple_mob/animal/synx/proc/sonar_ping()
	set name = "Listen In"
	set desc = "Allows you to listen in to movement and noises around you."
	set category = "Abilities.Synx"

	if(incapacitated())
		to_chat(src, span_warning("You need to recover before you can use this ability."))
		return
	if(world.time < next_sonar_ping)
		to_chat(src, span_warning("You need another moment to focus."))
		return
	if(is_deaf() || is_below_sound_pressure(get_turf(src)))
		to_chat(src, span_warning("You are for all intents and purposes currently deaf!"))
		return
	next_sonar_ping += 10 SECONDS
	var/heard_something = FALSE
	to_chat(src, span_notice("You take a moment to listen in to your environment..."))
	for(var/mob/living/L in range(client.view, src))
		var/turf/T = get_turf(L)
		if(!T || L == src || L.stat == DEAD || is_below_sound_pressure(T))
			continue
		heard_something = TRUE
		var/feedback = list()
		feedback += "There are noises of movement "
		var/direction = get_dir(src, L)
		if(direction)
			feedback += "towards the [dir2text(direction)], "
			switch(get_dist(src, L) / client.view)
				if(0 to 0.2)
					feedback += "very close by."
				if(0.2 to 0.4)
					feedback += "close by."
				if(0.4 to 0.6)
					feedback += "some distance away."
				if(0.6 to 0.8)
					feedback += "further away."
				else
					feedback += "far away."
		else // No need to check distance if they're standing right on-top of us
			feedback += "right on top of you."
		to_chat(src,span_notice(jointext(feedback,null)))
	if(!heard_something)
		to_chat(src, span_notice("You hear no movement but your own."))





/mob/living/simple_mob/animal/synx/proc/distend_stomach()
	set name = "Distend Stomach"
	set desc = "Allows you to throw up your stomach, giving your attacks burn damage at the cost of your stomach contents going everywhere. Yuck."
	set category = "Abilities.Synx"

	if(transformed)
		to_chat(src,span_warning("Your limbs are in the way!")) //Kind of a weak excuse but since you already can't transform when your stomach is out, this avoids situations calling a sprite that doesn't exist and lightens my workload on making and implementing them
		return

	if(!stomach_distended && !transformed) //true if stomach distended is null, 0, or ""
		stomach_distended = !stomach_distended //switch statement
		to_chat (src, span_notice("You disgorge your stomach, spilling its contents!"))
		melee_damage_lower = 1 //Hopefully this will make all brute damage not apply while stomach is distended. I don't see a better way to do this.
		melee_damage_upper = 1
		icon_living = stomach_distended_state
		attack_armor_type = "bio" //apply_melee_effects should handle all burn damage code so this might not be necessary.
		attacktext += distend_attacktext
		attacktext -= initial_attacktext

		for(var/belly in src.vore_organs) //Spit out all contents because our insides are now outsides
			var/obj/belly/B = belly
			for(var/atom/movable/A in B)
				playsound(src, 'sound/effects/splat.ogg', 50, 1)
				B.release_specific_contents(A)
		update_icons()
		return

	if(stomach_distended) //If our stomach has been vomitted
		stomach_distended = !stomach_distended
		to_chat (src, span_notice("You swallow your insides!"))
		melee_damage_lower = SYNX_LOWER_DAMAGE //This is why I'm using a define
		melee_damage_upper = SYNX_UPPER_DAMAGE
		icon_living = initial(icon_living)
		attack_armor_type = "melee"
		attacktext += initial_attacktext
		attacktext -= distend_attacktext
		update_icons()
		return

///
///		Icon generation stuff
///

/mob/living/simple_mob/animal/synx/update_icon()
	update_fullness()
	build_icons()
	for(var/belly_class in vore_fullness_ex)
		var/vs_fullness = vore_fullness_ex[belly_class]
		if(vs_fullness > 0)
			if(transformed)
				//transformed bellysprites dont exist yet. Uncomment this when they do. -Reo
				//add_overlay("[iconstate]-t_[belly_class]-[vs_fullness]")
				pass()
			else
				add_overlay("[icon_state]_[belly_class]-[vs_fullness]")


/mob/living/simple_mob/animal/synx/proc/build_icons(var/random)
	cut_overlays()
	if(stat == DEAD)
		icon_state = "synx_dead"
		plane = MOB_LAYER
		return
	if(random)
		var/list/bodycolors = list("#FFFFFF")
		body = pick(body_styles)
		overlay_colors["Body"] = pick(bodycolors)
		horns = pick(horn_styles)
		var/list/horncolors = list("#FFE100","#A75A35","#1C4DFF","#FF0000","#404C6D","#2F2F2F","#55CE21","#711BFF","#DEDEE0")
		overlay_colors["Horns"] = pick(horncolors)
		var/list/markingcolors = list("#2F2F2F")
		markings = pick(marking_styles)
		overlay_colors["Marks"] = pick(markingcolors)
		var/list/eyecolors = list("#FFE100","#FF6A00","#1C4DFF","#FF0000","#3D5EBE","#FF006E","#55CE21","#711BFF","#939EFF")
		eyes = pick(eye_styles)
		overlay_colors["Eyes"] = pick(eyecolors)


	var/image/I = image(icon, "synx_body[body][transformed? "-t" : null][stomach_distended? "-s" : null]")
	I.color = overlay_colors["Body"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = (status_flags & HIDING)? OBJ_PLANE : MOB_PLANE
	I.layer = (status_flags & HIDING)? HIDING_LAYER : MOB_LAYER
	add_overlay(I)

	I = image(icon, "synx_horns[horns][transformed? "-t" : null]")
	I.color = overlay_colors["Horns"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = (status_flags & HIDING)? OBJ_PLANE : MOB_PLANE
	I.layer = (status_flags & HIDING)? HIDING_LAYER : MOB_LAYER
	add_overlay(I)

	I = image(icon, "synx_markings[markings][transformed? "-t" : null]")
	I.color = overlay_colors["Marks"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = (status_flags & HIDING)? OBJ_PLANE : MOB_PLANE
	I.layer = (status_flags & HIDING)? HIDING_LAYER : MOB_LAYER
	add_overlay(I)

	I = image(icon, "synx_eyes[eyes][transformed? "-t" : null]")
	I.color = overlay_colors["Eyes"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = (status_flags & HIDING)? OBJ_PLANE : MOB_PLANE
	I.layer = (status_flags & HIDING)? HIDING_LAYER : MOB_LAYER
	add_overlay(I)

/mob/living/simple_mob/animal/synx/proc/set_style()
	set name = "Set Style"
	set desc = "Customise your icons."
	set category = "Abilities.Synx"

	var/list/options = list("Body","Horns","Marks","Eyes")
	for(var/option in options)
		LAZYSET(options, option, new /image('icons/effects/synx_labels.dmi', option))
	var/choice = show_radial_menu(src, src, options, radius = 60)
	if(!choice || QDELETED(src) || src.incapacitated())
		return FALSE
	. = TRUE
	switch(choice)
		if("Body")
			options = body_styles
			for(var/option in options)
				var/image/I = new /image('icons/mob/synx_modular.dmi', "synx_body[option]", dir = 2)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick body color:","Body Color", overlay_colors["Body"])
			if(!new_color)
				return 0
			body = choice
			overlay_colors["Body"] = new_color
		if("Horns")
			options = horn_styles
			for(var/option in options)
				var/image/I = new /image('icons/mob/synx_modular.dmi', "synx_horns[option]", dir = 2)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick horn color:","Horn Color", overlay_colors["Horns"])
			if(!new_color)
				return 0
			horns = choice
			overlay_colors["Horns"] = new_color
		if("Marks")
			options = marking_styles
			for(var/option in options)
				var/image/I = new /image('icons/mob/synx_modular.dmi', "synx_markings[option]", dir = 2)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick marking color:","Marking Color", overlay_colors["Marks"])
			if(!new_color)
				return 0
			markings = choice
			overlay_colors["Marks"] = new_color
		if("Eyes")
			options = eye_styles
			for(var/option in options)
				var/image/I = new /image('icons/mob/synx_modular.dmi', "synx_eyes[option]", dir = 2)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick eye color:","Eye Color", overlay_colors["Eyes"])
			if(!new_color)
				return 0
			eyes = choice
			overlay_colors["Eyes"] = new_color
	if(.)
		build_icons()

////////////////////////////////////////
////////////////PET VERSION/////////////
////////////////////////////////////////
/mob/living/simple_mob/animal/synx/ai/pet
	faction = "Cargonia" //Should not share a faction with those pesky non station synxes.//This is so newspaper has a failchance
	name = "Bob"
	desc = "A very regular pet."
	tt_desc = "synxus pergulus"
	glow_range = 4
	glow_toggle = 1
	player_msg = "You aren't supposed to be in this. Wrong mob."

/mob/living/simple_mob/animal/synx/ai/pet/load_default_bellies()
	. = ..()
	var/obj/belly/B = vore_selected
	B.vore_verb = "swallow"
	B.digest_burn = 1
	B.digest_brute = 0

/mob/living/simple_mob/animal/synx/ai/pet/holo/load_default_bellies()
	. = ..()
	var/obj/belly/B = vore_selected
	B.vore_verb = "swallow"
	B.digest_burn = 5
	B.digest_brute = 5

/mob/living/simple_mob/animal/synx/ai/pet
	speak_chance = 2.0666

//HONKMOTHER Code.
/*/mob/living/simple_mob/animal/synx/proc/honk()
	set name = "HONK"
	set desc = "TAAA RAINBOW"
	set category = "Abilities.Synx"
	icon_state = "synx_pet_rainbow"
	icon_living = "synx_pet_rainbow"
	playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
*/
/mob/living/simple_mob/animal/synx/proc/bikehorn()
	playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)

//HOLOSEEDSPAWNCODE
/mob/living/simple_mob/animal/synx/ai/pet/holo/death()
	..()
	visible_message(span_notice("\The [src] fades away!"))
	var/location = get_turf(src)
	new /obj/item/seeds/hardlightseed/typesx(location)
	qdel(src)

/mob/living/simple_mob/animal/synx/ai/pet/holo/gib()
	visible_message(span_notice("\The [src] fades away!"))
	var/location = get_turf(src)
	new /obj/item/seeds/hardlightseed/typesx(location)
	qdel(src)

////////////////////////////////////////
////////////////SYNX VARIATIONS/////////
////////////////////////////////////////
//TODO: Figure out a way to properly implement these into the customization system. Not important rn as far as getting the system out goes, since none of them are actually in use, but these should probably be either commented out/removed or otherwise implemented into the system- their sprites don't play nice with it as things stand!
/mob/living/simple_mob/animal/synx/ai/pet/holo
	poison_chance = 100
	poison_type = "fakesynxchem" //unlike synxchem this one heals!
	name = "Hardlight synx"
	desc = "A cold blooded, genderless, space eel.. or a hologram of one. Guess the current synx are undergoing re-training? Either way this one is probably infinitely more friendly.. and less deadly."
	icon_state = "synx_hardlight_living"
	icon_living = "synx_hardlight_living"
	icon_dead = "synx_hardlight_dead"
	icon_gib = null
	alpha = 127
	speak = list("SX System Online")
	faction = "neutral"//Can be safely bapped with newspaper.
	melee_damage_lower = 0 //Holos do no damage
	melee_damage_upper = 0
	meat_amount = 0
	meat_type = null
	//Vore Section
	vore_default_mode = DM_HEAL
	vore_capacity = 2
	vore_digest_chance = 0    //Holos cannot digest
	vore_pounce_chance = 40 //Shouldn't fight
	vore_bump_chance = 0 //lowered bump chance
	vore_escape_chance = 30 //Much higher escape chance.. it's a hologram.
	swallowTime = 10 SECONDS //Much more time to run

//Commenting out OC content as to fit with content policy while I'm at it-- it won't work with the modular system anyways currently. Sorry, Shark!! I might try to add in a back marking category at some point so Greed can be recreated here at least, though. -Azel
/*/mob/living/simple_mob/animal/synx/ai/pet/greed
	name = "Greed"
	desc = "A cold blooded, genderless, parasitic eel from the more distant and stranger areas of the cosmos. black, perpetually grinning and possessing a hunger as enthusiastic and endless as humanity's sense of exploration.. This one has the name Greed burnt into its back, the burnt in name seems to be luminescent making it harder for it to blend into the dark."
	//icon= //icon= would just set what DMI we are using, we already have our special one set.
	icon_state = "synx_greed_living"
	icon_living = "synx_greed_living"
	icon_dead = "synx_greed_dead"
	speak = list("Who is there?")//preset unique words Greed remembers, to be defined more
	player_msg = "You Hunger."
	health = 100//Slightly lower health due to being damaged permanently.
	speak_chance = 5
	//Vore Section
	vore_capacity = 4 //What a fat noodle.
	vore_digest_chance = 1	//Multivore but lower digest chance
	vore_pounce_chance = 90 //Fighting is effort, engulf them whole.
	vore_bump_chance = 2 //lowered bump chance
	vore_escape_chance = 5 //Multivore allows for people to shove eachother out so lower normal escape chance.

/mob/living/simple_mob/animal/synx/ai/pet/greed/synth

/*
 * ▓███▓     ▓▓▓     ▓▓▓     ▓▓▓     ▓▓▓     ▓███▓
 *  ▓▓   ▓▓▓█ ▓▓  ▓▓█ ▓▓  ▓▓█ ▓▓  ▓▓█ ▓▓  ▓▓█ ▓▓   ▓▓▓█
 * ▓      ▓▓▓▓     ▓▓▓     ▓▓▓     ▓▓▓     ▓▓▓      ▓▓▓▓
 * ▓      █▓▓▓     █▓▓     █▓▓     █▓▓     █▓▓      █▓▓▓
 * ▓      █▓▓▓▓█  █▓▓ ▓█  █▓▓ ▓█  █▓▓█▓█  █▓▓▓      █▓▓▓
 * ▓      █▓▓▓  ▓█▓    █▓█▓█   █▓█▓█   ▓▓█   ▓█     █▓▓▓
 * ▓█     █▓▓▓          ▓▓▓     ▓▓▓          ▓▓     █▓▓▓
 * ▓▓     █▓▓            ▓       ▓            ▓     █▓▓▓
 *  ▓     █▓▓                                 ▓█    █▓▓
 *   ▓    ▓▓▓                                 ▓▓   █▓▓
 *    █\   ▓▓      ▓▓                   ▓█      ▓  █▓▓
 *    ▓█\   ▓█    ▓█▓                   ▓▓▓    █▓ █▓▓
 *     ▓▓▓█  ▓   ▓▓▓▓                   ▓ ▓▓   ▓ █▓▓
 *         ▓█▓  ▓▓█▓▓                   ▓  ▓▓  ▓▓▓
 *             ▓▓ █▓▓█                 █▓  █▓▓
 *            ▓▓   ▓▓▓                 ▓▓   █▓▓
 *            ▓    ▓▓▓                 ▓    █▓▓
 *          ▓▓    █▓▓█               █▓    █▓▓▓
 *          ▓     █▓▓▓  ▓▓█     █▓█  ▓▓    █▓▓▓
 *          ▓     █▓▓▓▓▓  ▓▓█ ▓▓  ▓▓█▓     █▓▓▓
 *          ▓     █▓▓▓     ▓▓▓     ▓▓▓     █▓▓▓
 *          ▓     █▓▓▓     ▓▓▓     ▓▓▓     █▓▓▓
 *            ▓█▓██▓▓▓█▓█▓█▓▓▓█▓█▓█▓▓▓█▓█▓██▓▓▓
 */
	icon_state = "synx_C_living"
	icon_living = "synx_C_living"
	icon_dead = "synx_C_dead"
	//hostile = 1
	name = "SYN-KinC"
	desc = "A robotic recreation of a an Alien parasite. The metal plates seem quite thick."
	humanoid_hands = 1
	health = 200 //Metally
	player_msg = "All systems nominal."
	/////////////////////ARMOR
	armor = list(
			"melee" = 50,
			"bullet" = 50,
			"laser" = -50,
			"energy" = -50,
			"bomb" = 50,
			"bio" = 100,
			"rad" = 100)
	////////////////////////////MED INJECTOR
	poison_type = REAGENT_ID_OXYCODONE //OD effects, eye_blurry | Confuse + for slimes | stuttering
	poison_chance = 77 //high but not guranteed.
	poison_per_bite = 9 //OD for oxyc is 20
	//////////////////////////////////////////////FACTION
	faction = "SYN"


/mob/living/simple_mob/animal/synx/ai/pet/greed/synth/Initialize(mapload)
	. = ..()
	name = "SYN-KinC-([rand(100,999)])"

/mob/living/simple_mob/animal/synx/ai/pet/greed/synth/goodboy
	//hostile = 0
	faction = "neutral"

/mob/living/simple_mob/animal/synx/ai/pet/diablo
	//var/diablo_LIVING = "synx_diablo_living"
	//var/diablo_DEAD = "synx_diablo_dead"
	name = "diablo"
	desc = "A cold blooded, genderless, parasitic eel from the more distant and stranger areas of the cosmos. grey, perpetually grinning and possessing a hunger as enthusiastic and endless as humanity's sense of exploration.. This one has a small shock collar on it that reads 'diablo'."
	icon_state = "synx_diablo_living"
	icon_living = "synx_diablo_living"
	icon_dead = "synx_diablo_dead"
	speak = list( )
	//Vore Section
	vore_capacity = 2
*/
/mob/living/simple_mob/animal/synx/ai/pet/clown
	//hostile = 1
	poison_chance = 100
	poison_type = "clownsynxchem" //unlike synxchem this one HONKS
	name = "Inflatable Clown Synx"
	desc = "Honk!, made this here with all the fun on in the booth. At the gate outside, when they pull up, they get me loose. Yeah, Jump Out Clowns, that's Clown gang, hoppin' out tiny cars. This shit way too funny, when we pull up give them the honk hard!"
	icon_state = "synx_pet_rainbow"
	icon_living = "synx_pet_rainbow"
	//icon_dead = "synx_hardlight_dead"
	icon_gib = null
	faction = "clown"
	melee_damage_lower = 1
	melee_damage_upper = 1
	//environment_smash = 0
	//destroy_surroundings = 0
	//Vore Section
	vore_default_mode = DM_HEAL
	vore_capacity = 10
	vore_digest_chance = 0
	vore_pounce_chance = 1 //MAKE THEM HONK
	vore_bump_chance = 0 //lowered bump chance
	vore_escape_chance = 100

////////////////////////////////////////
////////////////SYNX DEBUG//////////////
////////////////////////////////////////
/mob/living/simple_mob/animal/synx/ai/pet/debug
	name = "Syntox"
	desc = "ERROR Connection to translation server could not be established!"

/mob/living/simple_mob/animal/synx/ai/pet/debug/proc/rename()
	set name = "rename"
	set desc = "Renames the synx"
	set category = "DEBUG"
	name = input(usr, "What would you like to change name to?", "Renaming", null)

/mob/living/simple_mob/animal/synx/ai/pet/debug/proc/redesc()
	set name = "redesc"
	set desc = "Redescribes the synx"
	set category = "DEBUG"
	desc = input(usr, "What would you like to change desc to?", "Redescribing", null)

/mob/living/simple_mob/animal/synx/ai/pet/debug/proc/resprite()
	set name = "resprite"
	set desc = "Resprite the synx"
	set category = "DEBUG"
	icon_state = input(usr, "What would you like to change icon_state to?", "Respriting", null)

/mob/living/simple_mob/animal/synx/ai/pet/debug/Initialize(mapload)
	. = ..(mapload, TRUE)
	add_verb(src,/mob/living/simple_mob/animal/synx/ai/pet/debug/proc/rename)
	add_verb(src,/mob/living/simple_mob/animal/synx/ai/pet/debug/proc/resprite)
	add_verb(src,/mob/living/simple_mob/animal/synx/ai/pet/debug/proc/redesc)

////////////////////////////////////////
////////////////SYNX SPAWNER////////////
////////////////////////////////////////
/obj/random/mob/synx
	name = "This is synxes"

/obj/random/mob/synx/item_to_spawn()
//	return pick(prob(66);/mob/living/simple_mob/animal/synx/ai/pet/greed,
//		prob(33);/mob/living/simple_mob/animal/synx/ai/pet/holo, // Commented out as it doesn't currently work with the modular sprite system. Will try and get this up and working before TOO long, hopefully. -Azel
	return /*pick (prob(50);*//mob/living/simple_mob/animal/synx/ai///) //normal eel boyo.


////////////////////////////////////////////////////////////////////////////
//////////////////////////NOT A SYNX///////but acts kinda like one/////////
////////////////////////////////////////////////////////////////////////////
/*
Content relating to the SCP Foundation, including the SCP Foundation logo, is licensed under
Creative Commons Sharealike 3.0 and all concepts originate from http://www.scp-wiki.net and its authors.
This includes the sprites of the below Mob which are based upon SCP 939.
*/
//SCP-939
//sprites to be made.
/datum/ai_holder/simple_mob/scp
	hostile = TRUE // The majority of simplemobs are hostile.
	retaliate = TRUE	// The majority of simplemobs will fight back.
	cooperative = TRUE
	returns_home = FALSE
	can_flee = TRUE
	speak_chance = 0 // If the mob's saylist is empty, nothing will happen.
	wander = TRUE
	base_wander_delay = 3
	autopilot = TRUE //As the ghost in this shell you only control the voices.
	wander_when_pulled = TRUE
	outmatched_threshold = 100 //pussy
	flee_when_outmatched = TRUE
	call_distance = 100
	mauling = FALSE
	vision_range = 10 //no kiting, they have ears.
	use_astar = TRUE //Clever boy!
	threaten = TRUE

/mob/living/simple_mob/animal/synx/scp
	name = "Unknown"
	desc = "It's a red canine looking creature."
	tt_desc = "Unknown Alien Lifeform"

	poison_chance = 0 //no poison,
	ai_holder_type = /datum/ai_holder/simple_mob/scp
	say_list_type = /datum/say_list/malf_drone

	icon = 'icons/mob/synxmanyvoices.dmi'
	icon_state = "939_living"
	icon_living = "939_living"
	icon_dead = "939_dead"
	pixel_x = -15

#undef SYNX_LOWER_DAMAGE
#undef SYNX_UPPER_DAMAGE
