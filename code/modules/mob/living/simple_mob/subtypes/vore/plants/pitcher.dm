#define NUTRITION_FRUIT 250 //The amount of nutrition needed to produce a fruit
#define NUTRITION_PITCHER 3 * NUTRITION_FRUIT //The amount of nutrition needed to produce a new pitcher
#define NUTRITION_MEAT 50 //The amount of nutrition provided by slabs of meat
#define PITCHER_SATED 250 //The amount of nutrition needed before the pitcher will attempt to grow fruit.
#define PITCHER_HUNGRY 150 //The nutrition cap under which the pitcher actively attempts to lure prey.

GLOBAL_LIST_INIT(pitcher_plant_lure_messages, list(
	"The pitcher plant smells lovely, beckoning you closer.",
	"The sweet scent wafting from the pitcher plant  makes your mouth water.",
	"You feel an urge to investigate the pitcher plant closely.",
	"You find yourself staring at the pitcher plant without really thinking about it.",
	"Doesn't the pitcher plant smell amazing?")) //Messages sent to nearby players if the pitcher is trying to lure prey. This is global to prevent a new list every time a new pitcher plant spawns.

//Pitcher plants, a passive carnivorous plant mob for xenobio and space vine spawning.
//Consider making immune to space vine entangling. Check entangle_immunity in the old CHOMPstation github for an example.
/mob/living/simple_mob/vore/pitcher_plant
	name = "pitcher plant"
	desc = "A carnivorous pitcher plant, bigger than a man."
	tt_desc = "Sarraceniaceae gigantus"

	icon_state = "pitcher_plant"
	icon_living = "pitcher_plant"
	icon_dead = "pitcher_plant_dead"
	icon = 'icons/mob/vore.dmi'

	anchored = 1 // Rooted plant. Only killing it will let you move it.
	maxHealth = 200
	health = 200
	a_intent = I_HELP // While this is already help by default, I'm leaving this variable here as a reminder that disarm will prevent players from swapping places with the pitcher, but interfere with vore bump.
	faction = FACTION_PLANTS // Makes plant-b-gone deadly.
	ai_holder_type = /datum/ai_holder/simple_mob/passive/pitcher //It's a passive carnivorous plant, it can't detect or interact with people.

	min_oxy = 0 //Immune to atmos because so are space vines. This is arbitrary and can be tweaked if desired.
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	meat_type = /obj/item/reagent_containers/food/snacks/pitcher_fruit // Allows pitcher plants to be chopped up and replanted. Probably.
	meat_amount = 1 // And allows you to replant them should you so please.

	melee_damage_upper = 0 //This shouldn't attack people but if it does (admemes) no damage can be dealt.
	melee_damage_lower = 0

	armor = list(
				"melee" = 0,
				"bullet" = 0,
				"laser" = -50, // Okay fine fire type beats plant type
				"energy" = 0,
				"bomb" = 0,
				"bio" = -100, // Poison kills the plant good.
				"rad" = 100)

	var/fruit = FALSE //Has the pitcher produced a fruit?
	var/meat = 0 //How many units of meat is the plant digesting? Separate from actual vore mechanics.
	var/meatspeed = 5 //How many units of meat is converted to nutrition each tick?
	var/pitcher_metabolism = 0.1 //How much nutriment does the pitcher lose every 2 seconds? 0.1 should be around 30 every 10 minutes.
	var/scent_strength = 5 //How much can a hungry pitcher confuse nearby people?
	var/last_lifechecks = 0 //Timing variable to limit vore/hungry proc calls
	var/list/pitcher_plant_lure_messages = null
	can_be_drop_prey = FALSE

/mob/living/simple_mob/vore/pitcher_plant //Putting vore variables separately because apparently that's tradition.
	vore_bump_chance = 100
	vore_bump_emote = "slurps up" //Not really a good way to make the grammar work with a passive vore plant.
	vore_active = 1
	vore_icons = 1
	vore_capacity = 1
	vore_pounce_chance = 5 // Either this makes mobs sometimes get eaten for attacking it or nothing happens and I don't know which it is.
	swallowTime = 3 //3 deciseconds. This is intended to be nearly instant, e.g. victim trips and falls in.
	vore_ignores_undigestable = 0
	vore_default_mode = DM_DIGEST

/mob/living/simple_mob/vore/pitcher_plant/load_default_bellies()
	. = ..()
	var/obj/belly/B = vore_selected
	B.desc	= "You leaned a little too close to the pitcher plant, stumbling over the lip and splashing into a puddle of liquid filling the bottom of the cramped pitcher. You squirm madly, righting yourself and scrabbling at the walls in vain as the slick surface offers no purchase. The dim light grows dark as the pitcher's cap lowers, silently sealing the exit. With a sinking feeling, you realize you won't be able to push the exit open even if you could somehow climb that high, leaving you helplessly trapped in the slick, tingling fluid. The ONLY POSSIBLE WAY OUT is if someone either kills this thing or lowers a lifeline down to help. Maybe some string, a wire, or a good rope would do the trick..."
	B.digest_burn = 0.1 // Sloowwwwww churns
	B.digest_brute = 0.1 // Okay so I know there's no physical churning because it's a plant just trust me on this you want both of these
	B.vore_verb = "trip"
	B.name = "pitcher"
	B.mode_flags = DM_FLAG_THICKBELLY
	B.wet_loop = 0 // As nice as the fancy internal sounds are, this is a plant.
	B.digestchance = 0
	B.escapechance = 0
	B.fancy_vore = 1
	B.vore_sound = "Squish2"
	B.release_sound = "Pred Escape"
	B.contamination_color = "purple"
	B.contamination_flavor = "Wet"

	B.emote_lists[DM_HOLD] = list(
		"Slick fluid trickles over you, carrying threads of sweetness.",
		"Everything is still, dark, and quiet. Your breaths echo quietly.",
		"The surrounding air feels thick and humid.")
	B.emote_lists[DM_DIGEST] = list(
		"The slimy puddle stings faintly. It seems the plant has no need to quickly break down victims.",
		"The humid air settles in your lungs, keeping each breath more labored than the last.",
		"Fluid drips onto you, burning faintly as your body heat warms it.",
		"Digestive enzymes itch at your flesh as you are slowly dissolved into soupy nutrients."
		)
	B.emote_lists[DM_DRAIN] = list(
		"Each bead of slick fluid running down your body leaves you feeling weaker.",
		"It's cramped and dark, the air thick and heavy. Your limbs feel like lead.",
		"Strength drains from your frame. The cramped chamber feels easier to settle into with each passing moment.")
	B.struggle_messages_inside = list(
		"The narrow shape of the pitcher plant's stomach make it impossible to get any leverage. You can't escape.",
		"You struggle and push against the slick and slimy plant flesh surrounding you, but it's no use. There's no way out by yourself.",
		"Other predators would probably be getting queasy by now with all that fussing. Unfortunately, this thing just doesn't care. You're plant food.",
		"Squirm and struggle all you want, you're no closer to freedom. Nothing you're doing is working.",
		"You're just exhausting yourself with all this resistance, and the fumes of the plant's stomach are making you lightheaded.",
		"All that exertion is just making you exhausted. For something with no muscles, it seems perfectly built for keeping you in its gut.",
		"You literally can't escape by yourself. All you can do is wait for rescue and hope this dreadfully slow digestion doesn't snuff you out first.",
		"You can't reach the lid of the pitcher plant to pry yourself out. Even if you could, the walls are too slippery. If only someone could lower a string or a wire or a rope for you to grab on!",
		"The waxy walls are far too slippery for you to climb your way out, and trying to do so only drenches you in even more stinging slime.",
		"Although you try your best to claw your way to freedom, the pitcher's gut is too smooth and too tough for you to get any progress."
	)
	B.struggle_messages_outside = list(
		"Struggles from inside %pred cause its bulbous form to slosh from side-to-side. They might need some help to escape.",
		"You notice someone moving inside that pitcher plant! However, they clearly can't get out on their own.",
		"%pred's stomach shifts and slushes as someone inside of it tries in vain to escape. It doesn't look like they can, though.",
		"%pred seems unpertubed by the stubborn movement of its prey. They clearly aren't getting out on their own.")

/mob/living/simple_mob/vore/pitcher_plant/Life()
	. = ..()
	if(!.)
		return

	var/lastmeat = meat //If Life procs every 2 seconds that means it takes 20 seconds to digest a steak
	meat = max(0,meat - meatspeed) //Clamp it to zero
	adjust_nutrition(lastmeat - meat) //If there's no meat, this will just be zero.
	if(nutrition >= PITCHER_SATED + NUTRITION_FRUIT)
		if(prob(10)) //Should be about once every 20 seconds.
			grow_fruit()
	var/lastnutrition = nutrition
	adjust_nutrition(-pitcher_metabolism)
	adjustBruteLoss(nutrition - lastnutrition)
	adjustToxLoss((nutrition - lastnutrition) * 3)
	if(nutrition < pitcher_metabolism)
		adjustToxLoss(pitcher_metabolism)
	if(world.time > last_lifechecks + 30 SECONDS)
		last_lifechecks = world.time
		vore_checks()
		handle_hungry()
	if (!anchored)
		anchored = 1 // If it's alive, it should root itself back down and once again be impossible to move.

/mob/living/simple_mob/vore/pitcher_plant/Initialize(mapload)
	. = ..()
	pitcher_plant_lure_messages = GLOB.pitcher_plant_lure_messages


/mob/living/simple_mob/vore/pitcher_plant/death()
	..()
	anchored = 0
	if(fruit)
		new /obj/item/reagent_containers/food/snacks/pitcher_fruit(get_turf(src))
		fruit = FALSE

/mob/living/simple_mob/vore/pitcher_plant/proc/grow_fruit() //This proc handles the pitcher turning nutrition into fruit (and new pitchers).
	if(!fruit)
		if(nutrition >= PITCHER_SATED + NUTRITION_FRUIT)
			fruit = TRUE
			adjust_nutrition(-NUTRITION_FRUIT)
			return
		else
			return
	if(fruit)
		if(nutrition >= PITCHER_SATED + NUTRITION_PITCHER)
			var/turf/T = safepick(circleviewturfs(src, 2))
			if(T.density) //No spawning in walls
				return
			else if(src.loc ==T)
				return
			else
				new /mob/living/simple_mob/vore/pitcher_plant(get_turf(T))
				fruit = FALSE //No admeming this to spawn endless pitchers.
				adjust_nutrition(-NUTRITION_PITCHER)

/mob/living/simple_mob/vore/pitcher_plant/attack_hand(mob/living/user)
	if(user.a_intent == I_HELP)
		if(fruit)
			to_chat(user, span_infoplain("You pick a fruit from \the [src]."))
			var/obj/F = new /obj/item/reagent_containers/food/snacks/pitcher_fruit(get_turf(user)) //Drops at the user's feet if put_in_hands fails
			fruit = FALSE
			user.put_in_hands(F)
		else
			to_chat(user, span_infoplain("The [src] hasn't grown any fruit yet!"))
	else
		..()

/mob/living/simple_mob/vore/pitcher_plant/examine(mob/user)
	. = ..()
	if(fruit)
		. += "A plump fruit glistens beneath \the [src]'s cap."

/mob/living/simple_mob/vore/pitcher_plant/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/reagent_containers/food/snacks/meat))
		if(meat > NUTRITION_FRUIT - NUTRITION_MEAT) //Can't exceed 250
			to_chat(user, span_infoplain("The [src] is full!"))
			return
		else
			meat += NUTRITION_MEAT
			qdel(O)
			return
	if(istype(O, /obj/item/stack/cable_coil)) //How to free people without killing the pitcher. I guess cable is SS13 rope.
		var/mob/living/carbon/human/H
		var/N = 0
		for(H in vore_selected.contents) //Only works for carbons, RIP mice. Should pick the first human the code finds.
			user.visible_message(span_infoplain("[user] uses a loop of wire to try fishing someone out of \the [src]."), span_infoplain("You use a loop of wire to try snagging someone trapped in \the [src]..."))
			if(do_after(user, rand(3 SECONDS, 7 SECONDS))) //You can just spam click to stack attempts if you feel like abusing it.
				if(prob(15))
					user.visible_message(span_notice("[user] pulls a sticky [H] free from \the [src]."), span_infoplain("You heft [H] free from \the [src]."))
					LAZYSET(prey_excludes, H, world.time)
					vore_selected.release_specific_contents(H)
					N = 1
					addtimer(CALLBACK(src, PROC_REF(removeMobFromPreyExcludes), WEAKREF(H)), 1 MINUTES)
					break
				else
					to_chat(user, span_notice("The victim slips from your grasp!"))
					N = 1
					break //We need to terminate the loop after each outcome or this could loop through multiple bellies. Of course, there should only be one belly, but leave this here anyway just in case.
		if(!N)
			to_chat(user, span_infoplain("The pitcher is empty."))
	if(istype(O, /obj/item/newspaper))
		user.visible_message(span_notice("[user] baps \the [src], but it doesn't seem to do anything."), span_notice("You whap \the [src] with a rolled up newspaper."))
		to_chat(user, span_notice("Weird. That usually works. Maybe you can fish out its victim with some string or wire or something? Or maybe kill the thing with some plant-b-gone. Both would probably be safer than hacking it up with a person still inside."))
		return // You can't newspaper people to freedom like you do with other mobs, but since that doesn't work, fucking tell people.
	..()

/mob/living/simple_mob/vore/pitcher_plant/proc/vore_checks()
	if(ckey) //This isn't intended to be a playable mob but skip all of this if it's player-controlled.
		return
	if(vore_selected && vore_selected.contents.len) //Looping through all (potential) vore bellies would be more thorough but probably not worth the processing power if this check happens every 30 seconds.
		var/mob/living/L
		var/N = 0
		var/hasdigestable = 0
		var/hasindigestable = 0
		for(L in vore_selected.contents)
			if(istype(L, /mob/living/carbon/human/monkey))
				L.nutrition = 0 //No stuffing monkeys with protein shakes for massive nutrition.
			if(!L.digestable)
				vore_selected.digest_mode = DM_DRAIN
				N = 1
				hasindigestable = 1
				continue
			else
				vore_selected.digest_mode = DM_DIGEST
				N = 1
				hasdigestable = 1
				continue
		if(hasdigestable && hasindigestable)
			vore_selected.digest_mode = DM_DIGEST //Let's digest until we digest all the digestable prey, then move onto draining indigestable prey.
		if(!N)
			vore_selected.release_all_contents() //If there's no prey, spit out everything.

/mob/living/simple_mob/vore/pitcher_plant/proc/handle_hungry() //Let's run this check every 30 seconds. This is how a hungry pitcher tries to lure prey.
	if(nutrition <= PITCHER_HUNGRY) //Is sanity check another way to say redundancy?
		var/turf/T = get_turf(src)
		var/cardinal_turfs = T.CardinalTurfs()

		for(var/mob/living/carbon/human/H in oview(2, src))
			if(!istype(H) || !isliving(H) || H.stat == DEAD) //Living mobs only
				continue
			if(isSynthetic(H) || !H.species.breath_type || H.internal) //Exclude species which don't breathe or have internals.
				continue
			if(src.Adjacent(H)) //If they can breathe and are next to the pitcher, confuse them.
				to_chat(H,span_red("The sweet, overwhelming scent from \the [src] makes your senses reel!"))
				H.Confuse(scent_strength)
				continue
			else
				to_chat(H, span_red("[pick(pitcher_plant_lure_messages)]"))

		for(var/turf/simulated/TR in cardinal_turfs)
			TR.wet_floor(1) //Same effect as water. Slip into plant, get ate.
	else
		return
/mob/living/simple_mob/vore/pitcher_plant/Crossed(atom/movable/AM as mob|obj) //Yay slipnoms
	if(AM.is_incorporeal())
		return
	if(istype(AM, /mob/living) && will_eat(AM) && !istype(AM, type) && prob(vore_bump_chance) && !ckey)
		animal_nom(AM)
	..()

/datum/ai_holder/simple_mob/passive/pitcher
	wander = 0

/obj/item/reagent_containers/food/snacks/pitcher_fruit //As much as I want to tie hydroponics harvest code to the mob, this is simpler (albeit kinda hacky).
	name = "squishy fruit"
	desc = "A tender, fleshy fruit with a thin skin. Said to have an intensely sweet flavor, and also a narcotic paralyzing effect."
	icon = 'icons/obj/hydroponics_products.dmi'
	icon_state = "treefruit-product"
	color = "#a839a2"
	trash = /obj/item/seeds/pitcherseed
	nutriment_amt = 1
	nutriment_desc = list("pineapple" = 1)
	w_class = ITEMSIZE_SMALL
	var/datum/seed/seed = null
	var/obj/item/seeds/pit = null

/obj/item/reagent_containers/food/snacks/pitcher_fruit/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PITCHERNECTAR, 5)
	reagents.add_reagent(REAGENT_ID_PARALYZE_FLUID, 5) // Something worth harvesting the fruits for.
	bitesize = 1
	pit = new /obj/item/seeds/pitcherseed(src.contents)
	seed = pit.seed

/obj/item/reagent_containers/food/snacks/pitcher_fruit/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(istype(O,/obj/machinery/microwave))
		return ..()
	if(istype (O, /obj/machinery/seed_extractor))
		pit.loc = O.loc //1 seed, perhaps balanced because you can get the reagents and the seed. Can be increased if desirable.
		qdel(src)
	if(!(proximity && O.is_open_container()))
		return
	to_chat(user, span_notice("You squeeze \the [src], juicing it into \the [O]."))
	reagents.trans_to(O, reagents.total_volume)
	user.drop_from_inventory(src)
	pit.loc = user.loc
	qdel(src)

/obj/item/reagent_containers/food/snacks/pitcher_fruit/attack_self(mob/user)
	to_chat(user, span_notice("You plant the fruit."))
	new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(get_turf(user),src.seed)
	GLOB.seed_planted_shift_roundstat++
	qdel(src)
	return

#undef NUTRITION_FRUIT
#undef NUTRITION_PITCHER
#undef NUTRITION_MEAT
#undef PITCHER_SATED
#undef PITCHER_HUNGRY
