var/global/list/_slime_default_emotes = list(
	/decl/emote/audible/moan,
	/decl/emote/visible/twitch,
	/decl/emote/visible/sway,
	/decl/emote/visible/shiver,
	/decl/emote/visible/bounce,
	/decl/emote/visible/jiggle,
	/decl/emote/visible/lightup,
	/decl/emote/visible/vibrate,
	/decl/emote/slime,
	/decl/emote/slime/pout,
	/decl/emote/slime/sad,
	/decl/emote/slime/angry,
	/decl/emote/slime/frown,
	/decl/emote/slime/smile
)

// The top-level slime defines. Xenobio slimes and feral slimes will inherit from this.
/mob/living/simple_mob/slime
	name = "slime"
	desc = "It's a slime."
	tt_desc = "A Macrolimbus vulgaris"
	icon = 'icons/mob/slime2.dmi'
	icon_state = "slime baby"
	icon_living = "slime baby"
	icon_dead = "slime baby dead"
	var/shiny = FALSE // If true, will add a 'shiny' overlay.
	var/icon_state_override = null // Used for special slime appearances like the rainbow slime.
	color = "#CACACA"
	glow_range = 3
	glow_intensity = 2
	gender = NEUTER

	faction = "slime" // Note that slimes are hostile to other slimes of different color regardless of faction (unless Unified).
	maxHealth = 150
	movement_cooldown = 0
	pass_flags = PASSTABLE
	makes_dirt = FALSE	// Goop
	mob_class = MOB_CLASS_SLIME

	response_help = "pets"

	organ_names = /decl/mob_organ_names/slime

	// Atmos stuff.
	minbodytemp = T0C-30
	heat_damage_per_tick = 0
	cold_damage_per_tick = 40

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 0
	shock_resist = 0.5 // Slimes are resistant to electricity, and it actually charges them.
	taser_kill = FALSE
	water_resist = 0 // Slimes are very weak to water.

	melee_damage_lower = 10
	melee_damage_upper = 15
	base_attack_cooldown = 10 // One attack a second.
	attack_sound = 'sound/weapons/bite.ogg'
	attacktext = list("glomped")
	speak_emote = list("chirps")
	friendly = list("pokes")

	ai_holder_type = /datum/ai_holder/simple_mob/melee
	say_list_type = /datum/say_list/slime

	var/cores = 1 // How many cores you get when placed in a Processor.
	var/obj/item/clothing/head/hat = null // The hat the slime may be wearing.
	var/slime_color = "grey" // Used for updating the name and for slime color-ism.
	var/unity = FALSE // If true, slimes will consider other colors as their own.  Other slimes will see this slime as the same color as well.
	var/coretype = /obj/item/slime_extract/grey // What core is inside the slime, and what you get from the processor.
	var/reagent_injected = null // Some slimes inject reagents on attack.  This tells the game what reagent to use.
	var/injection_amount = 5 // This determines how much.
	var/mood = ":3" // Icon to use to display 'mood', as an overlay.

	can_enter_vent_with = list(/obj/item/clothing/head)

/mob/living/simple_mob/slime/get_available_emotes()
	return global._slime_default_emotes

/datum/say_list/slime
	speak = list("Blorp...", "Blop...")
	emote_see = list("bounces", "jiggles", "sways")
	emote_hear = list("squishes")

/mob/living/simple_mob/slime/Initialize()
	verbs += /mob/living/proc/ventcrawl
	update_mood()
	glow_color = color
	handle_light()
	update_icon()
	return ..()

/mob/living/simple_mob/slime/Destroy()
	if(hat)
		drop_hat()
	return ..()

/mob/living/simple_mob/slime/death()
	// Make dead slimes stop glowing.
	glow_toggle = FALSE
	handle_light()
	..()

/mob/living/simple_mob/slime/revive()
	// Make revived slimes resume glowing.
	glow_toggle = initial(glow_toggle)
	handle_light()
	..()

/mob/living/simple_mob/slime/update_icon()
	..() // Do the regular stuff first.

	if(stat != DEAD)
		// General slime shine.
		var/image/I = image(icon, src, "slime light")
		I.appearance_flags = RESET_COLOR
		add_overlay(I)

		// 'Shiny' overlay, for gemstone-slimes.
		if(shiny)
			I = image(icon, src, "slime shiny")
			I.appearance_flags = RESET_COLOR
			add_overlay(I)

		// Mood overlay.
		I = image(icon, src, "aslime-[mood]")
		I.appearance_flags = RESET_COLOR
		add_overlay(I)

	// Hat simulator.
	if(hat)
		var/hat_state = hat.item_state ? hat.item_state : hat.icon_state
		var/image/I = image('icons/inventory/head/mob.dmi', src, hat_state)
		I.pixel_y = -7 // Slimes are small.
		I.appearance_flags = RESET_COLOR | KEEP_APART
		I.blend_mode = BLEND_OVERLAY
		add_overlay(I)

// Controls the 'mood' overlay. Overrided in subtypes for specific behaviour.
/mob/living/simple_mob/slime/proc/update_mood()
	mood = "feral" // This is to avoid another override in the /feral subtype.

/mob/living/simple_mob/slime/proc/unify()
	unity = TRUE

// Interface override, because slimes are supposed to attack other slimes of different color regardless of faction.
// (unless Unified, of course).
/mob/living/simple_mob/slime/IIsAlly(mob/living/L)
	. = ..()
	if(istype(L, /mob/living/simple_mob/slime)) // Slimes should care about their color subfaction compared to another's.
		var/mob/living/simple_mob/slime/S = L
		if(S.unity || src.unity)
			return TRUE
		if(S.slime_color == src.slime_color)
			return TRUE
		else
			return FALSE
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.species, /datum/species/monkey))	// Monke always food
			return FALSE
	// The other stuff was already checked in parent proc, and the . variable will implicitly return the correct value.

// Slimes regenerate passively.
/mob/living/simple_mob/slime/handle_special()
	adjustOxyLoss(-1)
	adjustToxLoss(-1)
	adjustFireLoss(-1)
	adjustCloneLoss(-1)
	adjustBruteLoss(-1)

// Clicked on by empty hand.
/mob/living/simple_mob/slime/attack_hand(mob/living/L)
	if(L.a_intent == I_GRAB && hat)
		remove_hat(L)
	else
		..()

// Clicked on while holding an object.
/mob/living/simple_mob/slime/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/clothing/head)) // Handle hat simulator.
		give_hat(I, user)
		return

	//VOREStation Edit Start
	var/can_miss = TRUE
	for(var/item_type in allowed_attack_types)
		if(istype(I, item_type))
			can_miss = FALSE
			break
	//VOREStation Edit End

	// Otherwise they're probably fighting the slime.
	if(prob(25) && can_miss)	//VOREStation Edit
		visible_message(span("warning", "\The [user]'s [I] passes right through \the [src]!"))
		user.setClickCooldown(user.get_attack_speed(I))
		return
	..()

// Called when hit with an active slimebaton (or xeno taser).
// Subtypes react differently.
/mob/living/simple_mob/slime/proc/slimebatoned(mob/living/user, amount)
	return

// Hat simulator
/mob/living/simple_mob/slime/proc/give_hat(var/obj/item/clothing/head/new_hat, var/mob/living/user)
	if(!istype(new_hat))
		to_chat(user, span("warning", "\The [new_hat] isn't a hat."))
		return
	if(hat)
		to_chat(user, span("warning", "\The [src] is already wearing \a [hat]."))
		return
	else
		user.drop_item(new_hat)
		hat = new_hat
		new_hat.forceMove(src)
		to_chat(user, span("notice", "You place \a [new_hat] on \the [src].  How adorable!"))
		update_icon()
		return

/mob/living/simple_mob/slime/proc/remove_hat(var/mob/living/user)
	if(!hat)
		to_chat(user, "<span class='warning'>\The [src] doesn't have a hat to remove.</span>")
	else
		hat.forceMove(get_turf(src))
		user.put_in_hands(hat)
		to_chat(user, "<span class='warning'>You take away \the [src]'s [hat.name].  How mean.</span>")
		hat = null
		update_icon()

/mob/living/simple_mob/slime/proc/drop_hat()
	if(!hat)
		return
	hat.forceMove(get_turf(src))
	hat = null
	update_icon()

/mob/living/simple_mob/slime/speech_bubble_appearance()
	return "slime"

/mob/living/simple_mob/slime/proc/squish()
	playsound(src, 'sound/effects/slime_squish.ogg', 50, 0)
	visible_message("<b>\The [src]</b> squishes!")

/decl/mob_organ_names/slime
	hit_zones = list("cytoplasmic membrane")