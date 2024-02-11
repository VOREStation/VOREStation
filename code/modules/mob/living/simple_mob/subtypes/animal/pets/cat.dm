var/list/_cat_default_emotes = list(
	/decl/emote/visible,
	/decl/emote/visible/scratch,
	/decl/emote/visible/drool,
	/decl/emote/visible/nod,
	/decl/emote/visible/sway,
	/decl/emote/visible/sulk,
	/decl/emote/visible/twitch,
	/decl/emote/visible/twitch_v,
	/decl/emote/visible/dance,
	/decl/emote/visible/roll,
	/decl/emote/visible/shake,
	/decl/emote/visible/jump,
	/decl/emote/visible/shiver,
	/decl/emote/visible/collapse,
	/decl/emote/visible/spin,
	/decl/emote/visible/sidestep,
	/decl/emote/audible,
	/decl/emote/audible/hiss,
	/decl/emote/audible/whimper,
	/decl/emote/audible/gasp,
	/decl/emote/audible/scretch,
	/decl/emote/audible/choke,
	/decl/emote/audible/moan,
	/decl/emote/audible/gnarl,
	/decl/emote/audible/purr,
	/decl/emote/audible/purrlong
)

/mob/living/simple_mob/animal/passive/cat
	name = "cat"
	desc = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	tt_desc = "E Felis silvestris catus"
	icon = 'icons/mob/pets.dmi'
	icon_state = "cat2"
	item_state = "cat2"

	movement_cooldown = -1

	meat_amount = 1
	see_in_dark = 6 // Not sure if this actually works.
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	holder_type = /obj/item/weapon/holder/cat
	mob_size = MOB_SMALL

	has_langs = list(LANGUAGE_ANIMAL)

	var/mob/living/friend = null // Our best pal, who we'll follow. Meow.
	var/named = FALSE //have I been named yet?
	var/friend_name = null //VOREStation Edit - Lock befriending to this character

/mob/living/simple_mob/animal/passive/cat/Initialize()
	icon_living = "[initial(icon_state)]"
	icon_dead = "[initial(icon_state)]_dead"
	icon_rest = "[initial(icon_state)]_rest"
	update_icon()
	return ..()

/mob/living/simple_mob/animal/passive/cat/get_available_emotes()
	return global._cat_default_emotes.Copy()

/mob/living/simple_mob/animal/passive/cat/handle_special()
	if(!stat && prob(2)) // spooky
		var/mob/observer/dead/spook = locate() in range(src, 5)
		if(spook)
			var/turf/T = get_turf(spook)
			var/list/visible = list()
			for(var/obj/O in T.contents)
				if(!O.invisibility && O.name)
					visible += O
			if(visible.len)
				var/atom/A = pick(visible)
				visible_emote("suddenly stops and stares at something unseen[istype(A) ? " near [A]":""].")

// Instakills mice.
/mob/living/simple_mob/animal/passive/cat/apply_melee_effects(var/atom/A)
	if(ismouse(A))
		var/mob/living/simple_mob/animal/passive/mouse/mouse = A
		if(mouse.getMaxHealth() < 20) // In case a badmin makes giant mice or something.
			mouse.splat()
			visible_emote(pick("bites \the [mouse]!", "toys with \the [mouse].", "chomps on \the [mouse]!"))
	else
		..()

/mob/living/simple_mob/animal/passive/cat/IIsAlly(mob/living/L)
	if(L == friend) // Always be pals with our special friend.
		return TRUE

	. = ..()

	if(.) // We're pals, but they might be a dirty mouse...
		if(ismouse(L))
			return FALSE // Cats and mice can never get along.

/mob/living/simple_mob/animal/passive/cat/verb/become_friends()
	set name = "Become Friends"
	set category = "IC"
	set src in view(1)

	var/mob/living/L = usr
	if(!istype(L))
		return // Fuck off ghosts.

	if(friend)
		if(friend == usr)
			to_chat(L, span("notice", "\The [src] is already your friend! Meow!"))
			return
		else
			to_chat(L, span("warning", "\The [src] ignores you."))
			return

	//VOREStation Edit Start - Adds friend_name var checks
	if(!friend_name || L.real_name == friend_name)
		friend = L
		face_atom(L)
		to_chat(L, span("notice", "\The [src] is now your friend! Meow."))
		visible_emote(pick("nuzzles [friend].", "brushes against [friend].", "rubs against [friend].", "purrs."))

		if(has_AI())
			var/datum/ai_holder/AI = ai_holder
			AI.set_follow(friend)
	else
		to_chat(L, span("notice", "[src] ignores you."))
	//VOREStation Edit End


//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_mob/animal/passive/cat/runtime
	name = "Runtime"
	desc = "Her fur has the look and feel of velvet, and her tail quivers occasionally."
	tt_desc = "E Felis silvestris medicalis" // a hypoallergenic breed produced by NT for... medical purposes? Sure.
	gender = FEMALE
	icon_state = "cat"
	item_state = "cat"
	named = TRUE
	holder_type = /obj/item/weapon/holder/cat/runtime
	makes_dirt = 0 //Vorestation Edit

/mob/living/simple_mob/animal/passive/cat/kitten
	name = "kitten"
	desc = "D'aaawwww!"
	icon_state = "kitten"
	item_state = "kitten"
	gender = NEUTER
	holder_type = /obj/item/weapon/holder/cat/kitten //VOREStation Edit

/mob/living/simple_mob/animal/passive/cat/kitten/Initialize()
	if(gender == NEUTER)
		gender = pick(MALE, FEMALE)
	return ..()

/mob/living/simple_mob/animal/passive/cat/black
	icon_state = "cat3"
	item_state = "cat3"

/mob/living/simple_mob/animal/passive/cat/bones
	name = "Bones"
	desc = "That's Bones the cat. He's a laid back, black cat. Meow."
	gender = MALE
	icon_state = "cat3"
	item_state = "cat3"
	named = TRUE
	holder_type = /obj/item/weapon/holder/cat/fluff/bones

// SPARKLY
/mob/living/simple_mob/animal/passive/cat/bluespace
	name = "bluespace cat"
	desc = "Shiny cat, shiny cat, it's not your fault."
	tt_desc = "E Felis silvestris argentum"
	icon_state = "bscat"
	icon_living = "bscat"
	icon_rest = null
	icon_dead = null
	makes_dirt = 0
	holder_type = /obj/item/weapon/holder/cat/bluespace

/mob/living/simple_mob/animal/passive/cat/bluespace/death()
	animate(src, alpha = 0, color = "#0000FF", time = 0.5 SECOND)
	spawn(0.5 SECOND)
		qdel(src)

/mob/living/simple_mob/animal/passive/cat/bread
	name = "bread cat"
	desc = "Brought lunch to work."
	tt_desc = "E Felis silvestris breadinum"
	icon_state = "breadcat"
	icon_living = "breadcat"
	icon_rest = "breadcat_rest"
	icon_dead = "breadcat_dead"
	//icon_sit = "breadcat_sit"
	makes_dirt = 0
	holder_type = /obj/item/weapon/holder/cat/breadcat

/mob/living/simple_mob/animal/passive/cat/original
	name = "original cat"
	desc = "Donut steal."
	tt_desc = "E Felis silvestris originalis"
	icon_state = "original"
	icon_living = "original"
	icon_rest = "original_rest"
	icon_dead = "original_dead"
	//icon_sit = "original_sit"
	makes_dirt = 0
	holder_type = /obj/item/weapon/holder/cat/original

/mob/living/simple_mob/animal/passive/cat/cak
	name = "cak"
	desc = "Optimal combination of things?"
	tt_desc = "E Felis silvestris dessertus"
	icon_state = "cak"
	icon_living = "cak"
	icon_rest = "cak_rest"
	icon_dead = "cak_dead"
	//icon_sit = "cak_sit"
	makes_dirt = 0
	holder_type = /obj/item/weapon/holder/cat/cak

/mob/living/simple_mob/animal/passive/cat/space
	name = "space cat"
	desc = "Did someone write a song about this cat?"
	tt_desc = "E Felis silvestris stellaris"
	icon_state = "spacecat"
	icon_living = "spacecat"
	icon_rest = "spacecat_rest"
	icon_dead = "spacecat_dead"
	//icon_sit = "spacecat_sit"
	holder_type = /obj/item/weapon/holder/cat/spacecat
	makes_dirt = 0

	minbodytemp = 0				// Minimum "okay" temperature in kelvin
	maxbodytemp = 900			// Maximum of above
	heat_damage_per_tick = 3	// Amount of damage applied if animal's body temperature is higher than maxbodytemp
	cold_damage_per_tick = 2	// Same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp

	min_oxy = 0					// Oxygen in moles, minimum, 0 is 'no minimum'
	max_oxy = 0					// Oxygen in moles, maximum, 0 is 'no maximum'
	min_tox = 0					// Phoron min
	max_tox = 0					// Phoron max
	min_co2 = 0					// CO2 min
	max_co2 = 0					// CO2 max
	min_n2 = 0					// N2 min
	max_n2 = 0					// N2 max
	unsuitable_atoms_damage = 2	// This damage is taken when atmos doesn't fit all the requirements above

/datum/say_list/cat
	speak = list("Meow!","Esp!","Purr!","HSSSSS")
	emote_hear = list("meows","mews")
	emote_see = list("shakes their head", "shivers")
	say_maybe_target = list("Meow?","Mew?","Mao?")
	say_got_target = list("MEOW!","HSSSS!","REEER!")

/mob/living/simple_mob/animal/passive/cat/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/pen) || istype(W, /obj/item/device/flashlight/pen))
		if(named)
			to_chat(user, "<span class='notice'>\The [name] already has a name!</span>")
		else
			var/tmp_name = sanitizeSafe(tgui_input_text(user, "Give \the [name] a name", "Name", null, MAX_NAME_LEN), MAX_NAME_LEN)
			if(length(tmp_name) > 50)
				to_chat(user, "<span class='notice'>The name can be at most 50 characters long.</span>")
			else
				to_chat(user, "<span class='notice'>You name \the [name]. Meow!</span>")
				name = tmp_name
				named = TRUE
	else
		..()

/obj/item/weapon/cat_box
	name = "faintly purring box"
	desc = "This box is purring faintly. You're pretty sure there's a cat inside it."
	icon = 'icons/obj/storage.dmi'
	icon_state = "box"
	var/cattype = /mob/living/simple_mob/animal/passive/cat

/obj/item/weapon/cat_box/attack_self(var/mob/user)
	var/turf/catturf = get_turf(src)
	to_chat(user, "<span class='notice'>You peek into \the [name]-- and a cat jumps out!</span>")
	new cattype(catturf)
	new /obj/item/stack/material/cardboard(catturf) //if i fits i sits
	qdel(src)

/obj/item/weapon/cat_box/black
	cattype = /mob/living/simple_mob/animal/passive/cat/black
