/obj/item/clothing/accessory
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/inventory/accessory/item.dmi'
	icon_state = "bluetie"
	item_state_slots = list(slot_r_hand_str = "", slot_l_hand_str = "")
	appearance_flags = RESET_COLOR	// Stops has_suit's color from being multiplied onto the accessory
	slot_flags = SLOT_TIE
	w_class = ITEMSIZE_SMALL
	var/slot = ACCESSORY_SLOT_DECOR
	var/obj/item/clothing/has_suit = null		// The suit the tie may be attached to
	var/image/inv_overlay = null				// Overlay used when attached to clothing.
	var/image/mob_overlay = null
	var/overlay_state = null
	var/concealed_holster = 0
	var/mob/living/carbon/human/wearer = null 	// To check if the wearer changes, so species spritesheets change properly.
	var/list/on_rolled = list()					// Used when jumpsuit sleevels are rolled ("rolled" entry) or it's rolled down ("down"). Set to "none" to hide in those states.
	sprite_sheets = list(SPECIES_TESHARI = 'icons/inventory/accessory/mob_teshari.dmi') //Teshari can into webbing, too!
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/clothing/accessory/Destroy()
	on_removed()
	return ..()

/obj/item/clothing/accessory/proc/get_inv_overlay()
	if(!inv_overlay)
		var/tmp_icon_state = "[overlay_state? "[overlay_state]" : "[icon_state]"]"
		if(icon_override)
			if("[tmp_icon_state]_tie" in cached_icon_states(icon_override))
				tmp_icon_state = "[tmp_icon_state]_tie"
			inv_overlay = image(icon = icon_override, icon_state = tmp_icon_state, dir = SOUTH)
		else
			inv_overlay = image(icon = INV_ACCESSORIES_DEF_ICON, icon_state = tmp_icon_state, dir = SOUTH)

		inv_overlay.color = src.color
		inv_overlay.appearance_flags = appearance_flags	// Stops has_suit's color from being multiplied onto the accessory
	return inv_overlay

/obj/item/clothing/accessory/proc/get_mob_overlay()
	if(!istype(loc,/obj/item/clothing/))	//don't need special handling if it's worn as normal item.
		return
	var/tmp_icon_state = "[overlay_state? "[overlay_state]" : "[icon_state]"]"
	if(ishuman(has_suit.loc))
		wearer = has_suit.loc
	else
		wearer = null

	if(istype(loc,/obj/item/clothing/under))
		var/obj/item/clothing/under/C = loc
		if(on_rolled["down"] && C.rolled_down > 0)
			tmp_icon_state = on_rolled["down"]
		else if(on_rolled["rolled"] && C.rolled_sleeves > 0)
			tmp_icon_state = on_rolled["rolled"]

	if(icon_override)
		if("[tmp_icon_state]_mob" in cached_icon_states(icon_override))
			tmp_icon_state = "[tmp_icon_state]_mob"
		mob_overlay = image("icon" = icon_override, "icon_state" = "[tmp_icon_state]")
	else if(wearer && LAZYACCESS(sprite_sheets, wearer.species.get_bodytype(wearer))) //Teshari can finally into webbing, too!
		mob_overlay = image("icon" = sprite_sheets[wearer.species.get_bodytype(wearer)], "icon_state" = "[tmp_icon_state]")
	else
		mob_overlay = image("icon" = INV_ACCESSORIES_DEF_ICON, "icon_state" = "[tmp_icon_state]")
	if(addblends)
		var/icon/base = new/icon("icon" = mob_overlay.icon, "icon_state" = mob_overlay.icon_state)
		var/addblend_icon = new/icon("icon" = mob_overlay.icon, "icon_state" = src.addblends)
		if(color)
			base.Blend(src.color, ICON_MULTIPLY)
		base.Blend(addblend_icon, ICON_ADD)
		mob_overlay = image(base)
	else
		mob_overlay.color = src.color

	mob_overlay.appearance_flags = appearance_flags	// Stops has_suit's color from being multiplied onto the accessory
	return mob_overlay

//when user attached an accessory to S
/obj/item/clothing/accessory/proc/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(!istype(S))
		return
	has_suit = S
	src.forceMove(S)
	has_suit.add_overlay(get_inv_overlay())

	if(user)
		to_chat(user, "<span class='notice'>You attach \the [src] to \the [has_suit].</span>")
		add_fingerprint(user)

/obj/item/clothing/accessory/proc/on_removed(var/mob/user)
	if(!has_suit)
		return
	has_suit.cut_overlay(get_inv_overlay())
	has_suit = null
	if(user)
		usr.put_in_hands(src)
		add_fingerprint(user)
	else if(get_turf(src))		//We actually exist in space
		forceMove(get_turf(src))

//default attackby behaviour
/obj/item/clothing/accessory/attackby(obj/item/I, mob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user as mob)
	if(has_suit)
		return	//we aren't an object on the ground so don't call parent
	..()

/obj/item/clothing/accessory/tie
	name = "blue tie"
	icon_state = "bluetie"
	slot = ACCESSORY_SLOT_TIE

/obj/item/clothing/accessory/tie/red
	name = "red tie"
	icon_state = "redtie"

/obj/item/clothing/accessory/tie/blue_clip
	name = "blue tie with a clip"
	icon_state = "bluecliptie"

/obj/item/clothing/accessory/tie/blue_long
	name = "blue long tie"
	icon_state = "bluelongtie"

/obj/item/clothing/accessory/tie/red_clip
	name = "red tie with a clip"
	icon_state = "redcliptie"

/obj/item/clothing/accessory/tie/red_long
	name = "red long tie"
	icon_state = "redlongtie"

/obj/item/clothing/accessory/tie/black
	name = "black tie"
	icon_state = "blacktie"

/obj/item/clothing/accessory/tie/darkgreen
	name = "dark green tie"
	icon_state = "dgreentie"

/obj/item/clothing/accessory/tie/yellow
	name = "yellow tie"
	icon_state = "yellowtie"

/obj/item/clothing/accessory/tie/navy
	name = "navy tie"
	icon_state = "navytie"

/obj/item/clothing/accessory/tie/white
	name = "white tie"
	icon_state = "whitetie"

/obj/item/clothing/accessory/tie/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"

/obj/item/clothing/accessory/bowtie
	name = "red bow tie"
	desc = "Snazzy!"
	icon_state = "redbowtie"
	slot = ACCESSORY_SLOT_TIE

/obj/item/clothing/accessory/bowtie/black
	name = "black bow tie"
	icon_state = "blackbowtie"

/obj/item/clothing/accessory/bowtie/white
	name = "white bow tie"
	icon_state = "whitebowtie"

/obj/item/clothing/accessory/stethoscope
	name = "stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon_state = "stethoscope"
	slot = ACCESSORY_SLOT_TIE

/obj/item/clothing/accessory/stethoscope/do_surgery(mob/living/carbon/human/M, mob/living/user)
	if(user.a_intent != I_HELP) //in case it is ever used as a surgery tool
		return ..()
	attack(M, user) //default surgery behaviour is just to scan as usual
	return 1

/obj/item/clothing/accessory/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.a_intent == I_HELP)
			var/body_part = parse_zone(user.zone_sel.selecting)
			if(body_part)
				var/their = "their"
				switch(M.gender)
					if(MALE)	their = "his"
					if(FEMALE)	their = "her"

				var/sound = "heartbeat"
				var/sound_strength = "cannot hear"
				var/heartbeat = 0
				var/obj/item/organ/internal/heart/heart = M.internal_organs_by_name[O_HEART]
				if(heart && !(heart.robotic >= ORGAN_ROBOT))
					heartbeat = 1
				if(M.stat == DEAD || (M.status_flags&FAKEDEATH))
					sound_strength = "cannot hear"
					sound = "anything"
				else
					switch(body_part)
						if(BP_TORSO)
							sound_strength = "hear"
							sound = "no heartbeat"
							if(heartbeat)
								if(heart.is_bruised() || M.getOxyLoss() > 50)
									sound = "[pick("odd noises in","weak")] heartbeat"
								else
									sound = "healthy heartbeat"

							var/obj/item/organ/internal/heart/L = M.internal_organs_by_name[O_LUNGS]
							if(!L || M.losebreath)
								sound += " and no respiration"
							else if(M.is_lung_ruptured() || M.getOxyLoss() > 50)
								sound += " and [pick("wheezing","gurgling")] sounds"
							else
								sound += " and healthy respiration"
						if(O_EYES,O_MOUTH)
							sound_strength = "cannot hear"
							sound = "anything"
						else
							if(heartbeat)
								sound_strength = "hear a weak"
								sound = "pulse"

				user.visible_message("[user] places [src] against [M]'s [body_part] and listens attentively.", "You place [src] against [their] [body_part]. You [sound_strength] [sound].")
				return
	return ..(M,user)

//Medals
/obj/item/clothing/accessory/medal
	name = "bronze medal"
	desc = "A bronze medal."
	icon_state = "bronze"
	slot = ACCESSORY_SLOT_MEDAL
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/clothing/accessory/medal/conduct
	name = "distinguished conduct medal"
	desc = "A bronze medal awarded for distinguished conduct. Whilst a great honor, this is most basic award on offer. It is often awarded by a captain to a member of their crew."

/obj/item/clothing/accessory/medal/bronze_heart
	name = "bronze heart medal"
	desc = "A bronze heart-shaped medal awarded for sacrifice. It is often awarded posthumously or for severe injury in the line of duty."
	icon_state = "bronze_heart"

/obj/item/clothing/accessory/medal/nobel_science
	name = "nobel sciences award"
	desc = "A bronze medal which represents significant contributions to the field of science or engineering."

/obj/item/clothing/accessory/medal/silver
	name = "silver medal"
	desc = "A silver medal."
	icon_state = "silver"

/obj/item/clothing/accessory/medal/silver/valor
	name = "medal of valor"
	desc = "A silver medal awarded for acts of exceptional valor."

/obj/item/clothing/accessory/medal/silver/security
	name = "robust security award"
	desc = "An award for distinguished combat and sacrifice in defence of corporate commercial interests. Often awarded to security staff."

/obj/item/clothing/accessory/medal/gold
	name = "gold medal"
	desc = "A prestigious golden medal."
	icon_state = "gold"

/obj/item/clothing/accessory/medal/gold/captain
	name = "medal of captaincy"
	desc = "A golden medal awarded exclusively to those promoted to the rank of captain. It signifies the codified responsibilities of a captain, and their undisputable authority over their crew."

/obj/item/clothing/accessory/medal/gold/heroism
	name = "medal of exceptional heroism"
	desc = "An extremely rare golden medal awarded only by high ranking officials. To recieve such a medal is the highest honor and as such, very few exist. This medal is almost never awarded to anybody but distinguished veteran staff."

// Base type for 'medals' found in a "dungeon" submap, as a sort of trophy to celebrate the player's conquest.
/obj/item/clothing/accessory/medal/dungeon

/obj/item/clothing/accessory/medal/dungeon/alien_ufo
	name = "alien captain's medal"
	desc = "It vaguely like a star. It looks like something an alien captain might've worn. Probably."
	icon_state = "alien_medal"

//Scarves

/obj/item/clothing/accessory/scarf
	name = "green scarf"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	icon_state = "greenscarf"
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/scarf/red
	name = "red scarf"
	icon_state = "redscarf"

/obj/item/clothing/accessory/scarf/darkblue
	name = "dark blue scarf"
	icon_state = "darkbluescarf"

/obj/item/clothing/accessory/scarf/purple
	name = "purple scarf"
	icon_state = "purplescarf"

/obj/item/clothing/accessory/scarf/yellow
	name = "yellow scarf"
	icon_state = "yellowscarf"

/obj/item/clothing/accessory/scarf/orange
	name = "orange scarf"
	icon_state = "orangescarf"

/obj/item/clothing/accessory/scarf/lightblue
	name = "light blue scarf"
	icon_state = "lightbluescarf"

/obj/item/clothing/accessory/scarf/white
	name = "white scarf"
	icon_state = "whitescarf"

/obj/item/clothing/accessory/scarf/black
	name = "black scarf"
	icon_state = "blackscarf"

/obj/item/clothing/accessory/scarf/zebra
	name = "zebra scarf"
	icon_state = "zebrascarf"

/obj/item/clothing/accessory/scarf/christmas
	name = "christmas scarf"
	icon_state = "christmasscarf"

/obj/item/clothing/accessory/scarf/stripedred
	name = "striped red scarf"
	icon_state = "stripedredscarf"

/obj/item/clothing/accessory/scarf/stripedgreen
	name = "striped green scarf"
	icon_state = "stripedgreenscarf"

/obj/item/clothing/accessory/scarf/stripedblue
	name = "striped blue scarf"
	icon_state = "stripedbluescarf"

/obj/item/clothing/accessory/scarf/teshari/neckscarf
	name = "small neckscarf"
	desc = "a neckscarf that is too small for a human's neck"
	icon_state = "tesh_neckscarf"
	species_restricted = list(SPECIES_TESHARI)

//bracelets

/obj/item/clothing/accessory/bracelet
	name = "bracelet"
	desc = "A simple silver bracelet with a clasp."
	icon = 'icons/inventory/accessory/item.dmi'
	icon_state = "bracelet"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_TIE
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/bracelet/slap
	name = "slap bracelet"
	desc = "Banned in schools! Popular with children and in poorly managed corporate events!"
	icon_state = "slap"

/obj/item/clothing/accessory/bracelet/beaded
	name = "beaded bracelet"
	desc = "Made from loose beads with a center hole and connected by a piece of string or elastic band through said holes."
	icon_state = "beaded"

/obj/item/clothing/accessory/bracelet/friendship
	name = "friendship bracelet"
	desc = "A beautiful friendship bracelet in all the colors of the rainbow."
	icon_state = "friendbracelet"

/obj/item/clothing/accessory/bracelet/friendship/verb/dedicate_bracelet()
	set name = "Dedicate Bracelet"
	set category = "Object"
	set desc = "Dedicate your friendship bracelet to a special someone."
	var/mob/M = usr
	if(!M.mind)
		return 0

	var/input = sanitizeSafe(input(usr, "Who do you want to dedicate the bracelet to?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		desc = "A beautiful friendship bracelet in all the colors of the rainbow. It's dedicated to [input]."
		to_chat(M, "You dedicate the bracelet to [input], remembering the times you've had together.")
		return 1


/obj/item/clothing/accessory/bracelet/material
	icon_state = "materialbracelet"

/obj/item/clothing/accessory/bracelet/material/New(var/newloc, var/new_material)
	..(newloc)
	if(!new_material)
		new_material = MAT_STEEL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] bracelet"
	desc = "A bracelet made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/accessory/bracelet/material/get_material()
	return material

/obj/item/clothing/accessory/bracelet/material/wood/New(var/newloc)
	..(newloc, "wood")

/obj/item/clothing/accessory/bracelet/material/plastic/New(var/newloc)
	..(newloc, "plastic")

/obj/item/clothing/accessory/bracelet/material/iron/New(var/newloc)
	..(newloc, "iron")

/obj/item/clothing/accessory/bracelet/material/steel/New(var/newloc)
	..(newloc, "steel")

/obj/item/clothing/accessory/bracelet/material/silver/New(var/newloc)
	..(newloc, "silver")

/obj/item/clothing/accessory/bracelet/material/gold/New(var/newloc)
	..(newloc, "gold")

/obj/item/clothing/accessory/bracelet/material/platinum/New(var/newloc)
	..(newloc, "platinum")

/obj/item/clothing/accessory/bracelet/material/phoron/New(var/newloc)
	..(newloc, "phoron")

/obj/item/clothing/accessory/bracelet/material/glass/New(var/newloc)
	..(newloc, "glass")

	..()

/obj/item/clothing/accessory/bracelet/material/sifwood/New(var/newloc)
	..(newloc, "sifwood")

/obj/item/clothing/accessory/bracelet/material/copper/New(var/newloc)
	..(newloc, "copper")

/obj/item/clothing/accessory/bracelet/material/bronze/New(var/newloc)
	..(newloc, "bronze")

/obj/item/clothing/accessory/halfcape
	name = "half cape"
	desc = "A tasteful half-cape, suitible for European nobles and retro anime protagonists."
	icon_state = "halfcape"
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/fullcape
	name = "full cape"
	desc = "A gaudy full cape. You're thinking about wearing it, aren't you?"
	icon_state = "fullcape"
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/sash
	name = "sash"
	desc = "A plain, unadorned sash."
	icon_state = "sash"
	slot = ACCESSORY_SLOT_OVER

//Gaiter scarves
/obj/item/clothing/accessory/gaiter
	name = "red neck gaiter"
	desc = "A slightly worn neck gaiter, it's loose enough to be worn comfortably like a scarf. Commonly used by outdoorsmen and mercenaries, both to keep warm and keep debris away from the face."
	icon_state = "gaiter_red"
	slot_flags = SLOT_MASK | SLOT_TIE
	body_parts_covered = FACE
	w_class = ITEMSIZE_SMALL
	slot = ACCESSORY_SLOT_INSIGNIA // snowflakey, i know, shut up
	item_flags = FLEXIBLEMATERIAL
	var/breath_masked = FALSE
	var/obj/item/clothing/mask/breath/breathmask
	action_button_name = "Pull On Gaiter"

/obj/item/clothing/accessory/gaiter/update_clothing_icon()
	. = ..()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_mask()

/obj/item/clothing/accessory/gaiter/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/clothing/mask/breath))
		to_chat(user, SPAN_NOTICE("You tuck [I] behind [src]."))
		breathmask = I
		breath_masked = TRUE
		user.drop_from_inventory(I, drop_location())
		I.forceMove(src)
		item_flags &= ~FLEXIBLEMATERIAL
	. = ..()

/obj/item/clothing/accessory/gaiter/AltClick(mob/user)
	. = ..()
	if(breath_masked && breathmask)
		to_chat(user, SPAN_NOTICE("You pull [breathmask] out from behind [src], and it drops to your feet."))
		breathmask.forceMove(drop_location())
		breathmask = null
		breath_masked = FALSE
		item_flags &= ~AIRTIGHT
		item_flags |= FLEXIBLEMATERIAL

/obj/item/clothing/accessory/gaiter/attack_self(mob/user)
	var/gaiterstring = "You pull [src] "
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]_up"
		gaiterstring += "up over your nose[breath_masked ? " and secure the mask tucked underneath." : "."]"
		if(breath_masked)
			item_flags |= AIRTIGHT
	else
		src.icon_state = initial(icon_state)
		gaiterstring += "down around your neck[breath_masked ? " and dislodge the mask tucked underneath." : "."]"
		body_parts_covered &= ~FACE
		if(breath_masked)
			item_flags &= ~AIRTIGHT
	to_chat(user, SPAN_NOTICE(gaiterstring))
	qdel(mob_overlay) // we're gonna need to refresh these
	update_clothing_icon()	//so our mob-overlays update

/obj/item/clothing/accessory/gaiter/tan
	name = "tan neck gaiter"
	icon_state = "gaiter_tan"

/obj/item/clothing/accessory/gaiter/gray
	name = "gray neck gaiter"
	icon_state = "gaiter_gray"

/obj/item/clothing/accessory/gaiter/green
	name = "green neck gaiter"
	icon_state = "gaiter_green"

/*
 * Pride Pins
 */
/obj/item/clothing/accessory/pride
	name = "pride pin"
	desc = "A pin displaying pride in one's identity."
	icon_state = "pride"
	slot = ACCESSORY_SLOT_MEDAL

/obj/item/clothing/accessory/pride/bi
	name = "bisexual pride pin"
	icon_state = "pride_bi"

/obj/item/clothing/accessory/pride/trans
	name = "transgender pride pin"
	icon_state = "pride_trans"

/obj/item/clothing/accessory/pride/ace
	name = "asexual pride pin"
	icon_state = "pride_ace"

/obj/item/clothing/accessory/pride/enby
	name = "nonbinary pride pin"
	icon_state = "pride_enby"

/obj/item/clothing/accessory/pride/pan
	name = "pansexual pride pin"
	icon_state = "pride_pan"

/obj/item/clothing/accessory/pride/lesbian
	name = "lesbian pride pin"
	icon_state = "pride_lesbian"

/obj/item/clothing/accessory/pride/intersex
	name = "intersex pride pin"
	icon_state = "pride_intersex"

/obj/item/clothing/accessory/pride/vore
	name = "vore pride pin"
	icon_state = "pride_vore"

//legbrace
/obj/item/clothing/accessory/legbrace
	name = "leg braces"
	desc = "A set of leg braces to help support weak legs"
	icon_state = "legbrace"
	gender = PLURAL

//necklaces
/obj/item/clothing/accessory/necklace
	icon_state = "necklace"
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_MASK | SLOT_TIE

/obj/item/clothing/accessory/necklace/New(var/newloc, var/new_material)
	. = ..(newloc)
	if(!new_material)
		new_material = MAT_STEEL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] necklace"
	desc = "A necklace of high-quality [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/accessory/necklace/get_material()
	return material

/obj/item/clothing/accessory/necklace/wood/New(var/newloc)
	..(newloc, "wood")

/obj/item/clothing/accessory/necklace/plastic/New(var/newloc)
	..(newloc, "plastic")

/obj/item/clothing/accessory/necklace/iron/New(var/newloc)
	..(newloc, "iron")

/obj/item/clothing/accessory/necklace/steel/New(var/newloc)
	..(newloc, "steel")

/obj/item/clothing/accessory/necklace/silver/New(var/newloc)
	..(newloc, "silver")

/obj/item/clothing/accessory/necklace/gold/New(var/newloc)
	..(newloc, "gold")

/obj/item/clothing/accessory/necklace/platinum/New(var/newloc)
	..(newloc, "platinum")

/obj/item/clothing/accessory/necklace/phoron/New(var/newloc)
	..(newloc, "phoron")

/obj/item/clothing/accessory/necklace/glass/New(var/newloc)
	..(newloc, "glass")

/obj/item/clothing/accessory/necklace/sifwood/New(var/newloc)
	..(newloc, "sifwood")

/obj/item/clothing/accessory/necklace/copper/New(var/newloc)
	..(newloc, "copper")

/obj/item/clothing/accessory/necklace/bronze/New(var/newloc)
	..(newloc, "bronze")

//neckercheif

/obj/item/clothing/accessory/neckerchief
	name = "neckerchief"
	desc = "A piece of cloth tied around the neck. A favorite of scouts, sailors and partisans everywhere."
	icon_state = "neckerchief"
	slot_flags = SLOT_MASK | SLOT_TIE

//watches

/obj/item/clothing/accessory/watch
	name = "watch"
	desc = "A Ward-Takahashi produced wristwatch, encased in black plastic and featuring a digital display synced to the current system time!"
	description_fluff = "For those who want too much time on their wrists instead."
	icon_state = "watch"
	slot_flags = SLOT_GLOVES | SLOT_TIE

/obj/item/clothing/accessory/watch/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "The watch shows that the time is [stationtime2text()]."

/obj/item/clothing/accessory/watch/silver
	name = "silver watch"
	desc = "A Gilthari ZeitMeister, a finely tuned wristwatch encased in silver."
	description_fluff = "To unleash the telemarketer in you!"
	icon_state = "watch_silver"

/obj/item/clothing/accessory/watch/gold
	name = "gold watch"
	desc = "A Gilthari ZeitMeister, a finely tuned wristwatch encased in <b>REAL</b> faux gold."
	description_fluff = "Be the jerk-ass pawn shop owner you'll never be."
	icon_state = "watch_gold"

/obj/item/clothing/accessory/watch/holo
	name = "holograpic watch"
	desc = "A Gilthari ZeitMeister deluxe, with a holographic screen."
	description_fluff = "The latest Gilthari technology!"
	icon_state = "watch_holo"

/obj/item/clothing/accessory/watch/leather
	name = "leather watch"
	desc = "A Gilthari ZeitMeister classic, a finely tuned wristwatch with a fancy leather strap."
	description_fluff = "Made from real synth leather."
	icon_state = "watch_leather"
