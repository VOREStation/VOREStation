//This mob's design and details belong to Kira72 on discord and BYOND. Please consult them before making changes to the discriptions and abilities of the mob,
//and please respect their wishes to keep the mob in line with their vision for it. This is not any sort of formal copyright notice, but a polite request.

/mob/living/simple_mob/vore/scel
	name = "scel"
	desc = "A large serpentine creature with malleable and shadowy-black flesh covering most of it's body. The soft substance seems solid, but hardly seems to stay in a singular shape. There are numerous spots of neon-bright colour that's visible through translucent patches across their body."
	catalogue_data = list(/datum/category_item/catalogue/fauna/scel)
	tt_desc = "Voidwyrm"
	icon = 'icons/mob/vore_scel.dmi'
	icon_dead = "scel_orange-dead"
	icon_living = "scel_orange"
	icon_state = "scel_orange"
	icon_rest = "scel_orange-rest"
	faction = FACTION_SCEL
	old_x = -48
	old_y = 0
	vis_height = 92
	friendly = list("nudges", "sniffs on", "rumbles softly at", "nuzzles")
	default_pixel_x = -48
	pixel_x = -48
	pixel_y = 0
	response_help = "bumps"
	response_disarm = "shoves"
	response_harm = "attacks"
	movement_cooldown = 0
	harm_intent_damage = 15
	melee_damage_lower = 5
	melee_damage_upper = 15
	maxHealth = 400
	attacktext = list("slammed")
	see_in_dark = 8
	minbodytemp = 0
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate
	max_buckled_mobs = 1
	mount_offset_y = 32
	mount_offset_x = -16
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE

	special_attack_min_range = 2
	special_attack_max_range = 4
	special_attack_cooldown = 30 SECONDS

	appendage_color = "#000000"

	var/leap_warmup = 2 SECOND // How long the leap telegraphing is.
	var/leap_sound = 'sound/weapons/spiderlunge.ogg'

	var/random_skin = 1
	var/list/skins = list(
		"scel_orange",
		"scel_blue",
		"scel_purple",
		"scel_red",
		"scel_green"
	)

	allow_mind_transfer = TRUE

/mob/living/simple_mob/vore/scel/New()
	..()
	if(random_skin)
		icon_living = pick(skins)
		icon_rest = "[icon_living]-rest"
		icon_dead = "[icon_living]-dead"
		update_icon()

/mob/living/simple_mob/vore/scel

	vore_bump_chance = 25
	vore_digest_chance = 50
	vore_escape_chance = 5
	vore_pounce_chance = 100
	vore_active = 1
	vore_icons = 1
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_capacity = 1
	swallowTime = 50
	vore_ignores_undigestable = FALSE
	vore_default_mode = DM_SELECT
	vore_pounce_maxhealth = 125
	vore_bump_emote = "tries to devour"

/mob/living/simple_mob/vore/scel/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount
	verbs |= /mob/living/proc/toggle_rider_reins
	verbs |= /mob/living/proc/glow_toggle
	verbs |= /mob/living/proc/glow_color
	verbs |= /mob/living/proc/long_vore
	verbs |= /mob/living/proc/target_lunge
	movement_cooldown = -1

/mob/living/simple_mob/vore/scel/init_vore()
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The strange beast pounces atop of you, pinning you with it's hefty weight, the greedy stomach sloshing atop you before it looms closer, with that maw stretching almost impossibly wide and easily enveloping your body. The jaws of the scel are solid and fleshy, preventing any movement. Immediately you are embraced into the tight pull of oily black flesh, and you are rapidly dragged down into the humid, more malleable depths of the creature! Splashing down into a thick, ominously bubbling sludge, you fall into place as food among the remnants of previous meals. As you settle, you are completely hidden away inside of it's serpentine body, left to complete darkness and the sounds of squelching bodily functions. Movement is not difficult as the flesh around you is easily pushed back, but it quickly snaps back into place to keep you constrained. Slowly, the neon liquid that you could see from the outside of the creature begins to seep into the chamber. With that hefty stomach bloated with yet another meal, a lazy burp signals its meal complete. Leaving you to simmer in its depths as it continues its prowling..."
	B.vore_sound = "Tauric Swallow"
	B.release_sound = "Pred Escape"
	B.mode_flags = DM_FLAG_THICKBELLY
	B.belly_fullscreen = "a_anim_belly"
	B.fancy_vore = 1
	B.selective_preference = DM_SELECT
	B.vore_verb = "devour"
	B.digest_brute = 1
	B.digest_burn = 2
	B.digest_oxy = 0
	B.digestchance = 50
	B.absorbchance = 0
	B.escapechance = 10
	B.escape_stun = 5
	B.contamination_color = "grey"
	B.contamination_flavor = "Wet"
	B.emote_lists[DM_DIGEST] = list(
		"The walls smother and press against you with a marshmallowy softness. Mechanically compressing you in waves to ease in your digestion.",
		"As the scel slithers about, you feel the squishy walls around you roll over your form, causing the pool of digestive liquids to splash and churn against you.",
		"Curious sounds can be heard muffled through the flesh as the creature pokes and prods at it's groaning gut.",
		"As the thinning air begins to make you feel dizzy, menacing bworps and grumbles fill that dark, constantly shifting organ!",
		"The constant, rhythmic kneading and massaging starts to take its toll along with the muggy heat, easing your body to sink more into the bubbling pool around you!",
		"The vibrant neon liquid pools over your body, it bubbles over your helpless figure as it steadily melts you down. All to churn you up to add an extra little weight to this strange beast.",
		"The alien serpent seems to be kneading and massaging it's noisy stomach, sloshing noisily as you are shoved about inside.",
		"The creature seems to stretch and arch their body for a moment, tightening you against those slick walls. For a brief moment, you can almost see the outside world.",
		"The walls of this well-padded gut rumbles as the Scel lets out a crass belch. Forcing the walls of this roiling belly tighter against you as it works to digest you!")
	B.digest_messages_prey = "The greedy walls compress around you as the Scel gives out an audible belch, taking with it the last of your air. You slowly slip under the bubbling and caustic tide of sludge as it overtakes your body. Your senses fade as the walls lazily ripple around you, reducing your body to a hot churning slop. The Scel's belly softens and rounds as you slowly amount to little more than some extra soft pudge on the lazy wryms body!"
	B.struggle_messages_outside = list(
		"The Scel stifles a belch before bringing a long tentacle to knead over its distended belly. It's noisily churning and gurgling, with every movement from within eliciting a loud slosh or squelch.",
		"The shadowy serpent lets out a crass belch as its roiling, bulging belly slowly and noisily digests a wriggling meal. If you squint, you can just barely see the shilouette of someone!",
		"The Scel clenches it's wriggling middle, sending that lumpy bulge further down along it's body! The distinct shape fading into its chubby body.",
		"With a long and lazy stretch, the Scel causes the walls of its stomach to compress around their squirming meal, revealing the slowly digesting shape of someone!",
		"The Scel's well-rounded belly bubbles and groans, making wet gurgling noises as it sloshes in its attempts to digest an uncooperative meal!")
	B.struggle_messages_inside = list(
		"Your squirming and struggling just serves to kick the churning liquid around you in rough waves of digestive enzymes!",
		"Your movements just prompt the strange creature shoves a tendril into their gut, causing the walls to compress into you and knocking you off balance.",
		"You simply slide against the slick black flesh and splash back down into the neon-colored goop, doing little but to coat yourself in those roiling waves.",
		"The slurry around you bubbles ominously, before a rush of air blasts past you and a rumbling belch shakes the walls, tightening against you even more.",
		"The belly doesn't react to your wriggling at all, with a constant stream of 'blurps', 'blorbles', and 'groans'. The noisy stomach compresses you from all angles as it works to digest you like everything else that enters this gut.",
		"You shove at the pudgy walls with all your strength, almost catching a vague glimpse of the outside world, before the Scel clenches their stomach, sending you bounding back inside as the stomach sloshes.")
	B.examine_messages = list(
		"The belly of the creature sags outwards, pushing out against its flexible flesh. It rumbles contently..",
		"The Scel looks quite content right now, with multiple black tendrils rubbing over the sloshing, groaning mass of its gut.",
		"A soft belch escapes the jaws of the alien creature as its soft and lumpy belly works to digest its latest meal.")

/mob/living/simple_mob/vore/scel/do_special_attack(atom/A)
	. = TRUE
	if(ckey)
		return
	if(prob(50))
		lunge(A)
	else
		tongue(A)

/mob/living/simple_mob/vore/scel/proc/lunge(atom/A)	//Mostly copied from hunter.dm
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

/mob/living/simple_mob/vore/scel/proc/tongue(atom/A)
	var/obj/item/projectile/P = new /obj/item/projectile/beam/appendage(get_turf(src))
	src.visible_message(span_danger("\The [src] launches a black appendage at \the [A]!"))
	playsound(src, "sound/effects/slime_squish.ogg", 50, 1)
	P.launch_projectile(A, BP_TORSO, src)

/datum/category_item/catalogue/fauna/scel
	name = "Extra-Realspace Fauna - Scel"
	desc = "Classification: Voidwyrm\
	<br><br>\
	Scel, colloquially known as Voidwyrms, are creatures originating from outside of realspace, typically found at extradimensional breaches such as redpsace tears or within redgate locations. \
	While they are known to appear in many variants, the serpentine shape with antennae or whiskers is known to be the most common, due to being the closest and most accurate approximation of their natural forms from their home reality. \
	Scel bodies, contrary to popular belief, are not slime. They are solid matter, but are still incredibly malleable, which they use to 'shapeshift' when desired. The shifting is limited to just their figure. A scel attempting to look human would still have black squishy flesh and glowing eyes and spots for example. \
	Various other appendages seem to manifest at will, growing out of their body when needed. Tentacles are by-far the most preferred and commonly seen, but hardened legs and even clawed hands have been seen. While able to shapeshift into even human or animal shapes, it is always in shape only, and certain traits are universal. \
	Six eyes that match the color of their 'Goo', universally black and lacking in bones, and no body heat at all, typically matching the temperature of whatever environment they find themselves in. \
	Organs and bones as we understand them are nonexistant, and their body is made up of two main quantifiable substances. The black 'Flesh' that makes up the majority of their matter. It is solid yet incredibly malleable to the touch, and has been described as feeling 'slick'. \
	The next is the viscous liquid that seems to be the source of their color. This liquid seems to fulfill many properties for the Scel, shifting in transluscent pockets inside of their body. \
	Both their flesh and 'goo' dissipate into a fine black mist within hours of being seperated from its host, or the death of the subject. \
	Scel are sapient, and are therefore hard to predict, many have been immediately hostile, while a rare few have even taught themselves our language. Contact has been sparse though. What has been discovered is that most Scel seem to act independantly, with no formal governance. \
	Their alien mindset seems to have difficulty adapting to our world, further causing contact attempts to degrade into misunderstandings. \
	Scel, once breached into realspace, seem incredibly hesitant to return to their own reality, and are likely to be found in places with little to no natural light, as it seems to confuse their senses."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/vore/scel/orange
	icon_dead = "scel_orange-dead"
	icon_living = "scel_orange"
	icon_state = "scel_orange"
	icon_rest = "scel_orange-rest"
	random_skin = 0

/mob/living/simple_mob/vore/scel/blue
	icon_dead = "scel_blue-dead"
	icon_living = "scel_blue"
	icon_state = "scel_blue"
	icon_rest = "scel_blue-rest"
	random_skin = 0

/mob/living/simple_mob/vore/scel/purple
	icon_dead = "scel_purple-dead"
	icon_living = "scel_purple"
	icon_state = "scel_purple"
	icon_rest = "scel_purple-rest"
	random_skin = 0

/mob/living/simple_mob/vore/scel/green
	icon_dead = "scel_green-dead"
	icon_living = "scel_green"
	icon_state = "scel_green"
	icon_rest = "scel_green-rest"
	random_skin = 0

/mob/living/simple_mob/vore/scel/red
	icon_dead = "scel_red-dead"
	icon_living = "scel_red"
	icon_state = "scel_red"
	icon_rest = "scel_red-rest"
	random_skin = 0
