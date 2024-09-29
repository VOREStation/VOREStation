/datum/category_item/catalogue/fauna/squirrel
	name = "Alien Wildlife - Squirrel"
	desc = "Squirrels are said to have originated from Sol III, they typically have thick fur covering most of their bodies and are well known\
	to have long, extremely bushy tails. Squirrels have been spread through space primarily by accident when they sneak aboard landed vessels. \
	While squirrels can live in many places, they thrive in temperate environments with a seasonal cycle. They seem to be almost hard wired to follow \
	the seasons, shedding fur in the spring, gathering food and packing on weight in autumn, and hybernating in winter. They may still attempt to follow \
	these cycles even in places without seasons, which can be stressful to them. Life in space and on the various worlds they now inhabit has over time \
	changed the humble squirrel, as with a more extreme lifestyle, they have adapted to endure much harsher climates and threats in the autumn and winter months."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/squirrel
	name = "squirrel"
	desc = "A furry creature with a long fluffy tail, dark eyes, and a cute pink nose."
	tt_desc = "Sciuridae"
	icon_state = "squirrel"
	icon_living = "squirrel"
	icon_dead = "squirrel_dead"
	icon_rest = "squirrel_rest"
	icon = 'icons/mob/alienanimals_x32.dmi'
	color = "#76462c"

	faction = FACTION_ANIMAL
	maxHealth = 40
	health = 40
	movement_cooldown = -1
	meat_amount = 1
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	response_help = "pets"
	response_disarm = "slaps"
	response_harm = "punches"

	harm_intent_damage = 2
	melee_damage_lower = 1
	melee_damage_upper = 5

	catalogue_data = list(/datum/category_item/catalogue/fauna/squirrel)
	vis_height = 32

	attacktext = list("nipped", "squeaked at")
	friendly = list("nuzzles", "nibbles", "leans on")

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/edible

	has_langs = list(LANGUAGE_ANIMAL)
	say_list_type = /datum/say_list/squirrel

	mob_size = MOB_SMALL
	softfall = TRUE

	var/static/list/overlays_cache = list()
	var/do_seasons = TRUE
	var/picked_color = FALSE

	allow_mind_transfer = TRUE

/////////////////////////////////////// Vore stuff///////////////////////////////////////////

	swallowTime = 4 SECONDS
	vore_active = 1
	vore_capacity = 1
	vore_bump_chance = 1
	vore_bump_emote	= "pounces on"
	vore_ignores_undigestable = 0
	vore_default_mode = DM_SELECT
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "Stomach"
	vore_default_contamination_flavor = "Wet"
	vore_default_contamination_color = "grey"
	vore_default_item_mode = IM_DIGEST

/mob/living/simple_mob/vore/squirrel/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.digest_mode = DM_SELECT
	B.mode_flags = DM_FLAG_THICKBELLY
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 1
	B.digest_burn = 1
	B.escapechance = 35

	if(icon == 'icons/mob/alienanimals_x32.dmi')
		B.desc = "With a final gulp, the cool air of the outside world is replaced with the incredibly tight, hot, and humid insides of the squirrel. \
		The slick flesh that surrounds you barely gives you room to move, and constantly flexes over your form as the rest of you is pushed inside of the \
		cramped, organic space.  The stomach you now inhabited seemed quite content to treat you like the tiny rodent's normal diet of nuts and berries, \
		constantly squeezing in an attempt to compact you down, to better fit in your new home."
		B.emote_lists[DM_DIGEST] = list(
			"Low grumbles fill your ears as the squirrel's stomach begins the herculean task of digesting you.",
			"The squirrel's stomach begins to secrete fluids that make your skin tingle on contact.",
			"The fleshy organ clenches tightly around you in its attempts to soften you up!",
			"As the squirrel's stomach flexes and kneads around you, your body begins to feel weaker, and more sluggish, as the digestive organ slowly takes its toll on you.",
			"The squirrel lets out a faint burp, causing what air remains to grow thin, and harder to breathe.",
			"The swampy air stings your lungs as you attempt to draw another stomach acid tinged breath.",
			"Tingling stomach slimes drip over your softening form, slowly converting you into nutrients for the small rodent.",
			"You cant help but feel like a nut, given the squirrel's stomach seems to have no issue with treating you like one."
			)

		B.emote_lists[DM_HOLD] = list(
			"The squirrel insides that surround you gently sway from side to side as the squirrel goes on with its day.",
			"Various harmless stomach fluids pool around you, as you sit within the belly of the squirrel.",
			"The rapid heartbeat of the squirrel thrums in your ears, still faintly audible, even over the grumbles of the stomach you now inhabit.",
			"The oppressively snug, sauna-like squirrel insides you're trapped within weakly compress around your body, restricting your ability to move at all, before eventually relaxing once again.",
			"The gastric chamber momentarily grows tighter as the squirrel lets out a barely audible burp, and remains that way until the squirrel gulps down more air for you.  Likely in an attempt to get you to start squirming once again.",
			"A series of muted impacts from the outside can be felt as the squirrel moves around, likely from the overstuffed rodent bumping into objects in the environment that you no longer inhabit.",
			"A pair of small paws can be felt pressing in towards you, it almost feels as if the squirrel is rubbing its belly, and enjoying having you all to itself.",
			"The squirrel can be heard chittering quietly as you try to move around.  It almost sounds like it's laughing at you as you try to escape."
			)

		B.digest_messages_prey = list(
			"Your body finally succumbs to the squirrel's stomach.  Your nutrient rich remains are pumped deeper into the rodent's body, to help it bulk up for winter...",
			"You black out in the dark, murky depths of the squirrel.  The next time you're seen, will be as extra layers of softness on the soon to be pudgy rodent's body.",
			"As your consciousness fades away, and your stuggling comes to an end, you can hear faint squeaking as the lucky rodent goes on with its day, content with having claimed you as its dinner."
			)
	else
		B.desc = "With relative ease, you slid down the throat of the massive rodent, and came to a rest deep inside its spacious tummy!  Immediately, the gluttonous rodent's stomach begins to squeeze and compress you into a more manageable shape, all in an attempt to keep you down, deep within the squirrel's gastric embrace.  The air is humid, the slick walls are powerful, and oppressive, and the stomach fluids you're soaking in cling to every inch of your body.  Unfortunately for you, you're squirrel food."
		B.emote_lists[DM_DIGEST] = list(
			"The squirrel's stomach seems content to treat you like a very large nut, as it works to soften you up to feed the squirrel for the long winter.",
			"Tingling fluids drip over your form as the squirrel's body attempts to work yours down into a more usable form.",
			"The squirrel lets out a clearly audible burp, what remains of the acrid air burns your lungs as the squirrel's stomach becomes less hospitable.",
			"The stomach fluids pooling around you cause your skin to tingle relentlessly as you're slowly worked into a less solid form",
			"Moving within the squirrel's stomach is becoming increasingly difficult, as the tree climbing mammal's digestive system slowly converts you into fuel for further tree climbing!",
			"Another powerful clench presses you down into the bottom of the stomach, and massaging more of the stomach acids into your already weakened form.",
			"Your body aches from the constant abuse the stomach is putting it through.  Soon, you'll be nothing more than nutrients for the lucky squirrel!",
			"The sounds of the outside world are drowned out by the constant grumbles and gurgles of this fleshy prison, as you're put through the slow process of digesting a nutrient rich slurry."
			)

		B.emote_lists[DM_HOLD] = list(
			"The powerful stomach walls surrounding you press inwards so tightly you can hardly move, before relaxing, and letting you resume struggling against this squirrel's insides.",
			"The sauna-like insides slowly sap your strength, as hot, harmless stomach fluids pool around you, turning the stomach into a personal hot tub.",
			"The heartbeat of the massive squirrel thunders in your ears like a drum, clearly audible inbetween powerful clenches from the fleshy walls that surround you.",
			"The air in your fleshy prison rushes out as the squirrel burps up what air is in its stomach, causing the already compact insides to grow even tighter.  Moments later, your host gulps down more air for you.  It clearly enjoys your struggles, and attempts to escape.",
			"Even though the squirrel wasn't digesting you, your body is so weak from the constant squeezing and churning, that you find it difficult to push out against those flexing insides",
			"A pair of heavy paws could be felt pressing down on you, likely from the squirrel trying to tire you out, so you can be kept in its sweltering insides for even longer!",
			"Above the constant groans of the stomach, and squish of flesh, you can hear the squirrel chittering in response to your movements.  Clearly it enjoys having you all to itself!",
			"Your gastric prison rocks gently as the squirrel moves around, exploring the outside world that it easily stole you away from!"
			)

		B.digest_messages_prey = list(
			"At long last, you succumb to the stomach you were trapped in, which breaks you apart, and pumps your nutrient rich remains deeper into the squirrel, to help feed the rodent throughout the long winter months.",
			"Darkness slowly overtakes your consciousness as the stomach takes its toll on you.  Soon, what's left of you will be melted down, and added to the squirrel's form as a layer of soft fat, to keep it warm throughout the coming winter!",
			"The murky insides around you are the last sensation you know, as the squirrel's stomach melts you down into a nutrient rich broth to be pumped deeper into the squirrel's body.  At least you were a big help to the lucky rodent that turned you into its dinner!"
			)


/datum/say_list/squirrel
	speak = list("Chitter","Squeak","Squee?","Chrrr...","Sqk!")
	emote_hear = list("sniffs", "scratches at something", "chitters")
	emote_see = list("sways its tail", "stretches", "yawns", "nibbles at something","scratches at something")
	say_maybe_target = list("Sqk?")
	say_got_target = list("SQUEAK!!!")

/mob/living/simple_mob/vore/squirrel/Initialize()
	. = ..()
	if(do_seasons)
		switch(world_time_season)
			if("spring")
				if(prob(1))
					winterize()
			if("summer")
			if("autumn")
				vore_bump_chance = 20
				if(prob(50))
					winterize()
					vore_bump_chance = 20
					return
			if("winter")
				winterize()
				return
	update_icon()

/mob/living/simple_mob/vore/squirrel/update_icon()
	. = ..()
	var/combine_key
	if(icon == 'icons/mob/alienanimals_x32.dmi')
		combine_key = "small"
	else
		combine_key = "big"

	combine_key = combine_key+icon_state
	var/image/extra_image = overlays_cache[combine_key]
	if(!extra_image)
		extra_image = image(icon,null,"[icon_state]_eye")
		extra_image.appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE
		overlays_cache[combine_key] = extra_image
	add_overlay(extra_image)

/mob/living/simple_mob/vore/squirrel/proc/winterize()
	desc = desc + " It looks all plumped up for winter! Adorable!"

	icon = 'icons/mob/alienanimals_96x64.dmi'

	maxHealth = 200
	health = 200
	movement_cooldown = 1
	meat_amount = 6
	harm_intent_damage = 1

	pixel_x = -32
	default_pixel_x = -32
	vis_height = 64

	swallowTime = 1 SECOND
	vore_capacity = 3
	vore_bump_chance = 5
	mob_size = MOB_LARGE
	update_icon()

/mob/living/simple_mob/vore/squirrel/verb/squirrel_color()
	set name = "Pick Color"
	set category = "Abilities"
	set desc = "You can set your color!"
	if(picked_color)
		to_chat(src, "<span class='notice'>You have already picked a color! If you picked the wrong color, ask an admin to change your picked_color variable to 0.</span>")
		return
	var/newcolor = input(usr, "Choose a color.", "", color) as color|null
	if(newcolor)
		color = newcolor
	picked_color = TRUE
	update_icon()

/mob/living/simple_mob/vore/squirrel/small
	do_seasons = FALSE

/mob/living/simple_mob/vore/squirrel/big
	do_seasons = FALSE

/mob/living/simple_mob/vore/squirrel/big/Initialize()
	. = ..()
	winterize()
