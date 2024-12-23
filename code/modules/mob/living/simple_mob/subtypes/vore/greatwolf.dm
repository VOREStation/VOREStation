/mob/living/simple_mob/vore/greatwolf
	name = "great white wolf"
	desc = "A massive white wolf, with piercing green eyes. Much like a dire wolf, but bigger. Passive, until you give it a reason to not be."
	catalogue_data = list(/datum/category_item/catalogue/fauna/greatwolf)
	tt_desc = "Canis lupus greatus"
	icon = 'icons/mob/vore128x64.dmi'
	icon_dead = "whitewolf-dead"
	icon_living = "whitewolf"
	icon_state = "whitewolf"
	icon_rest = "whitewolf-rest"
	faction = FACTION_SIF
	has_eye_glow = TRUE
	meat_amount = 40 //Big dog, lots of meat
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	old_x = -48
	old_y = 0
	vis_height = 92
	melee_damage_lower = 20
	melee_damage_upper = 15
	friendly = list("nudges", "sniffs on", "rumbles softly at", "slobberlicks")
	default_pixel_x = -48
	pixel_x = -48
	pixel_y = 0
	response_help = "pets"
	response_disarm = "shoves"
	response_harm = "smacks"
	movement_cooldown = -1
	harm_intent_damage = 10
	melee_damage_lower = 10
	melee_damage_upper = 20
	maxHealth = 500
	attacktext = list("chomped")
	see_in_dark = 8
	minbodytemp = 0
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate
	max_buckled_mobs = 1
	mount_offset_y = 32
	mount_offset_x = -16
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	max_tox = 0 // for virgo3b survivability

/mob/living/simple_mob/vore/greatwolf

	vore_bump_chance = 25
	vore_digest_chance = 5
	vore_escape_chance = 5
	vore_pounce_chance = 25
	vore_active = 1
	vore_icons = 2
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_capacity = 2
	swallowTime = 50
	vore_ignores_undigestable = TRUE
	vore_default_mode = DM_HEAL
	vore_pounce_maxhealth = 125
	vore_bump_emote = "tries to snap up"

/mob/living/simple_mob/vore/greatwolf/black
	name = "great black wolf"
	desc = "A massive black wolf with a sandy colored underside, and intimidating amber eyes. Much like a dire wolf, but bigger. Passive, until you give it a reason to not be."
	icon_dead = "blackwolf-dead"
	icon_living = "blackwolf"
	icon_state = "blackwolf"
	icon_rest = "blackwolf-rest"

/mob/living/simple_mob/vore/greatwolf/grey
	name = "great grey wolf"
	desc = "Shouldn't he have a sword or something?"
	icon_dead = "sifwolf-dead"
	icon_living = "sifwolf"
	icon_state = "sifwolf"
	icon_rest = "blackwolf-rest"
	maxHealth = 900 //boss, with air quotes
	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 25

/datum/category_item/catalogue/fauna/greatwolf
	name = "Sivian Fauna - Great Wolf"
	desc = "Classification: Canis lupus greatus\
	<br><br>\
	Canis Lupus Greatus, or Great Wolf, is a very large predator not beleived to be native to Sif (because it's a wolf, duh), but it has been never been found anywhere else. Despite their size, they are gentle, unless disturbed.\
	The majority of a great white wolf's long life is spent much the same as ordinary wolves. However, great wolves usually do not trouble themselves with small prey like humans, \
	usually preferring instead to hunt Saviks and Kururaks, and sometimes, leopardmanders or invasive red dragons. \
	Though usually docile towards humans and other large sapients, neesless to say, these wolves possess great strength and a lethal bite. \
	a provoked great wolf can be a danger to even the most hardy of explorers due to its speed, crushing bite, and sometimes, it's appetite. \
	The great wolves have been hunted to near extinction by poachers due to its extremely valuable hide. They are very rare, as one would expect, and generally cautious around people."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/vore/greatwolf/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	add_verb(src, /mob/living/simple_mob/proc/animal_mount)
	add_verb(src, /mob/living/proc/toggle_rider_reins)
	movement_cooldown = -1.5

/mob/living/simple_mob/vore/greatwolf/MouseDrop_T(mob/living/M, mob/living/user)
	return


/mob/living/simple_mob/vore/greatwolf/attackby(var/obj/item/O, var/mob/user) // Trade food for people!
	if(istype(O, /obj/item/reagent_containers/food))
		qdel(O)
		playsound(src,'sound/vore/gulp.ogg', rand(10,50), 1)
		if(!has_AI())//No autobarf on player control.
			return
		if(istype(O, /obj/item/reagent_containers/food/snacks/donut) && istype(src, /mob/living/simple_mob/vore/greatwolf/black))
			to_chat(user,span_notice("The huge wolf begrudgingly accepts your offer in exchange for it's catch."))
			release_vore_contents()
		else if(prob(2)) //Small chance to get prey out from white doggos
			to_chat(user,span_notice("The huge wolf accepts your offer for their catch."))
			release_vore_contents()
		return
	. = ..()

/mob/living/simple_mob/vore/greatwolf/init_vore()
	if(!voremob_loaded)
		return
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The moment the wolf gets its jaws around you, it scoops you right up off of the ground, and greedily scarfs you down with a few swift gulps. Your small frame alone is hardly enough to make him look somewhat plump as you slop wetly into that dark, hot chamber, although the dense squish is rather comfortable. The thick, humid air is tinged with the smell of digested meat, and the surrounding flesh wastes no time in clenching and massaging down over its newfound fodder."
	B.vore_sound = "Tauric Swallow"
	B.release_sound = "Pred Escape"
	B.mode_flags = DM_FLAG_NUMBING | DM_FLAG_THICKBELLY | DM_FLAG_AFFECTWORN
	B.fancy_vore = 1
	B.vore_verb = "slurp"
	B.contamination_color = "grey"
	B.contamination_flavor = "Wet"

	B.emote_lists[DM_HOLD] = list(
		"The wolf's idle wandering helps its stomach gently churn around you, slimily squelching against your figure.",
		"The lupine predator takes a moment to intentionally clench its gut around you, encapsulating you in a strange, fleshy hug.",
		"Some hot, viscous slime oozes down over your form, helping slicken you up during your stay.",
		"During a moment of relative silence, you can hear the beast's soft, relaxed breathing as it casually goes about its day.",
		"The thick, humid atmosphere within the wolf's hanging belly works in tandem with its steady heartbeat to soothe you.",
		"Your surroundings sway from side to side as the wolf wanders about, looking for its next treat.")

	B.emote_lists[DM_DIGEST] = list(
		"The wolf huffs in annoyance before clenching those soft wrinkled walls tight against your form, lathering you in digestive enzymes!",
		"As the beast wanders about, you're forced to slip and slide around amidst a pool of thick digestive goop!",
		"You can barely hear the wolf let out a pleased growl as its stomach eagerly gurgles around its newfound meal!",
		"As the thinning air begins to make you feel dizzy, menacing bworps and grumbles fill that dark, constantly shifting organ!",
		"The constant, rhythmic kneading and massaging starts to take its toll along with the muggy heat, making you feel weaker and weaker!",
		"The wolf happily wanders around while digesting its meal, slow calculated motions suggesting the beast is still on the hunt.")

	B.struggle_messages_outside = list(
		"%pred's %belly wobbles ever so slightly with a squirming meal.",
		"%pred's %belly jostles subtly with movement.",
		"%pred's %belly briefly swells downward as someone pushes from inside.",
		"%pred's %belly sloshes and churns noisily with a trapped victim.",
		"%pred's %belly swells in a few places as someone pushes from inside.",
		"%pred's %belly sloshes around.",
		"%pred's %belly sloshes and sways softly.",
		"%pred's %belly lets out a wet squelch as a few rounded shapes appear on its surface for a moment.")

	B.struggle_messages_inside = list(
		"Your squirming seems to please the canine, though it's hard to tell whether or not it's helping get you out or not.",
		"Your struggles only cause %pred's %belly to groan and gurgle softly around you.",
		"Your movement only causes %pred's %belly to clench down upon you, smothering you briefly in thick gutflesh.",
		"Your motion causes %pred's %belly to rumble irritably as you sink hands into the thick flesh.",
		"You fidget around awkwardly inside of %pred's %belly.",
		"You shove against the walls of %pred's %belly, making it briefly swell outward.",
		"You jostle %pred's %belly with movement, earning yourself another tight smothering squeeze in the process.",
		"You squirm inside of %pred's %belly, making it sway from side to side.")
