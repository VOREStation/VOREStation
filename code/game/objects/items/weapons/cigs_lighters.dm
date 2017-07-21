//cleansed 9/15/2012 17:48

/*
CONTAINS:
MATCHES
CIGARETTES
CIGARS
SMOKING PIPES
CHEAP LIGHTERS
ZIPPO

CIGARETTE PACKETS ARE IN FANCY.DM
*/

//For anything that can light stuff on fire
/obj/item/weapon/flame
	var/lit = 0

/proc/isflamesource(A)
	if(istype(A, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = A
		return (WT.isOn())
	else if(istype(A, /obj/item/weapon/flame))
		var/obj/item/weapon/flame/F = A
		return (F.lit)
	else if(istype(A, /obj/item/device/assembly/igniter))
		return 1
	return 0

///////////
//MATCHES//
///////////
/obj/item/weapon/flame/match
	name = "match"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	var/burnt = 0
	var/smoketime = 5
	w_class = ITEMSIZE_TINY
	origin_tech = list(TECH_MATERIAL = 1)
	slot_flags = SLOT_EARS
	attack_verb = list("burnt", "singed")

/obj/item/weapon/flame/match/process()
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		burn_out()
		return
	if(location)
		location.hotspot_expose(700, 5)
		return

/obj/item/weapon/flame/match/dropped(mob/user as mob)
	//If dropped, put ourselves out
	//not before lighting up the turf we land on, though.
	if(lit)
		spawn(0)
			var/turf/location = src.loc
			if(istype(location))
				location.hotspot_expose(700, 5)
			burn_out()
	return ..()

/obj/item/weapon/flame/match/proc/burn_out()
	lit = 0
	burnt = 1
	damtype = "brute"
	icon_state = "match_burnt"
	item_state = "cigoff"
	name = "burnt match"
	desc = "A match. This one has seen better days."
	processing_objects.Remove(src)

//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/smokable
	name = "smokable item"
	desc = "You're not sure what this is. You should probably ahelp it."
	body_parts_covered = 0
	var/lit = 0
	var/icon_on
	var/type_butt = null
	var/chem_volume = 0
	var/max_smoketime = 0	//Related to sprites
	var/smoketime = 0
	var/is_pipe = 0		//Prevents a runtime with pipes
	var/matchmes = "USER lights NAME with FLAME"
	var/lightermes = "USER lights NAME with FLAME"
	var/zippomes = "USER lights NAME with FLAME"
	var/weldermes = "USER lights NAME with FLAME"
	var/ignitermes = "USER lights NAME with FLAME"
	var/brand

/obj/item/clothing/mask/smokable/New()
	..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15
	if(smoketime && !max_smoketime)
		max_smoketime = smoketime

/obj/item/clothing/mask/smokable/proc/smoke(amount)
	if(smoketime > max_smoketime)
		smoketime = max_smoketime
	smoketime -= amount
	if(reagents && reagents.total_volume) // check if it has any reagents at all
		if(ishuman(loc))
			var/mob/living/carbon/human/C = loc
			if (src == C.wear_mask && C.check_has_mouth()) // if it's in the human/monkey mouth, transfer reagents to the mob
				reagents.trans_to_mob(C, REM, CHEM_INGEST, 0.2) // Most of it is not inhaled... balance reasons.
		else // else just remove some of the reagents
			reagents.remove_any(REM)

/obj/item/clothing/mask/smokable/process()
	var/turf/location = get_turf(src)
	smoke(1)
	if(smoketime < 1)
		die()
		return
	if(location)
		location.hotspot_expose(700, 5)

/obj/item/clothing/mask/smokable/update_icon()
	if(lit)
		icon_state = "[initial(icon_state)]_on"
		item_state = "[initial(item_state)]_on"
	else if(smoketime < max_smoketime)
		if(is_pipe)
			icon_state = initial(icon_state)
			item_state = initial(item_state)
		else
			icon_state = "[initial(icon_state)]_burnt"
			item_state = "[initial(item_state)]_burnt"
	if(ismob(loc))
		var/mob/living/M = loc
		M.update_inv_wear_mask(0)
		M.update_inv_l_hand(0)
		M.update_inv_r_hand(1)
	..()

/obj/item/clothing/mask/smokable/examine(mob/user)
	..()
	if(is_pipe)
		return
	var/smoke_percent = round((smoketime / max_smoketime) * 100)
	switch(smoke_percent)
		if(90 to INFINITY)
			user << "[src] is still fresh."
		if(60 to 90)
			user << "[src] has a good amount of burn time remaining."
		if(30 to 60)
			user << "[src] is about half finished."
		if(10 to 30)
			user << "[src] is starting to burn low."
		else
			user << "[src] is nearly burnt out!"


/obj/item/clothing/mask/smokable/proc/light(var/flavor_text = "[usr] lights the [name].")
	if(!src.lit)
		src.lit = 1
		damtype = "fire"
		if(reagents.get_reagent_amount("phoron")) // the phoron explodes when exposed to fire
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("phoron") / 2.5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		if(reagents.get_reagent_amount("fuel")) // the fuel explodes, too, but much less violently
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("fuel") / 5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		flags &= ~NOREACT // allowing reagents to react after being lit
		reagents.handle_reactions()
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		update_icon()
		set_light(2, 0.25, "#E38F46")
		processing_objects.Add(src)

/obj/item/clothing/mask/smokable/proc/die(var/nomessage = 0)
	var/turf/T = get_turf(src)
	set_light(0)
	processing_objects.Remove(src)
	if (type_butt)
		var/obj/item/butt = new type_butt(T)
		transfer_fingerprints_to(butt)
		if(brand)
			butt.desc += " This one is \a [brand]."
		if(ismob(loc))
			var/mob/living/M = loc
			if (!nomessage)
				to_chat(M, "<span class='notice'>Your [name] goes out.</span>")
			M.remove_from_mob(src) //un-equip it so the overlays can update
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
		qdel(src)
	else
		new /obj/effect/decal/cleanable/ash(T)
		if(ismob(loc))
			var/mob/living/M = loc
			if (!nomessage)
				M << "<span class='notice'>Your [name] goes out, and you empty the ash.</span>"
			lit = 0
			icon_state = initial(icon_state)
			item_state = initial(item_state)
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
			smoketime = 0
			reagents.clear_reagents()
			name = "empty [initial(name)]"

/obj/item/clothing/mask/smokable/proc/quench()
	lit = 0
	processing_objects.Remove(src)
	update_icon()

/obj/item/clothing/mask/smokable/attack(mob/living/carbon/human/H, mob/user, def_zone)
	if(lit && H == user && istype(H))
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(H, "<span class='warning'>\The [blocked] is in the way!</span>")
			return 1
		to_chat(H, "<span class='notice'>You take a drag on your [name].</span>")
		smoke(5)
		return 1
	return ..()

/obj/item/clothing/mask/smokable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(isflamesource(W))
		var/text = matchmes
		if(istype(W, /obj/item/weapon/flame/match))
			text = matchmes
		else if(istype(W, /obj/item/weapon/flame/lighter/zippo))
			text = zippomes
		else if(istype(W, /obj/item/weapon/flame/lighter))
			text = lightermes
		else if(istype(W, /obj/item/weapon/weldingtool))
			text = weldermes
		else if(istype(W, /obj/item/device/assembly/igniter))
			text = ignitermes
		text = replacetext(text, "USER", "[user]")
		text = replacetext(text, "NAME", "[name]")
		text = replacetext(text, "FLAME", "[W.name]")
		light(text)

/obj/item/clothing/mask/smokable/attack(var/mob/living/M, var/mob/living/user, def_zone)
	if(istype(M) && M.on_fire)
		user.do_attack_animation(M)
		light("<span class='notice'>[user] coldly lights the [name] with the burning body of [M].</span>")
		return 1
	else
		return ..()

/obj/item/clothing/mask/smokable/water_act(amount)
	if(amount >= 5)
		quench()

/obj/item/clothing/mask/smokable/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cig"
	item_state = "cig"
	throw_speed = 0.5
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("burnt", "singed")
	type_butt = /obj/item/weapon/cigbutt
	chem_volume = 15
	max_smoketime = 300
	smoketime = 300
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to light their NAME with FLAME.</span>"
	zippomes = "<span class='rose'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER casually lights the NAME with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME.</span>"

/obj/item/clothing/mask/smokable/cigarette/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

	if(istype(W, /obj/item/weapon/melee/energy/sword))
		var/obj/item/weapon/melee/energy/sword/S = W
		if(S.active)
			light("<span class='warning'>[user] swings their [W], barely missing their nose. They light their [name] in the process.</span>")

	return

/obj/item/clothing/mask/smokable/cigarette/afterattack(obj/item/weapon/reagent_containers/glass/glass, mob/user as mob, proximity)
	..()
	if(!proximity)
		return
	if(istype(glass)) //you can dip cigarettes into beakers
		var/transfered = glass.reagents.trans_to_obj(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the message
			user << "<span class='notice'>You dip \the [src] into \the [glass].</span>"
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				user << "<span class='notice'>[glass] is empty.</span>"
			else
				user << "<span class='notice'>[src] is full.</span>"

/obj/item/clothing/mask/smokable/cigarette/attack_self(mob/user as mob)
	if(lit == 1)
		if(user.a_intent == I_HURT)
			user.visible_message("<span class='notice'>[user] drops and treads on the lit [src], putting it out instantly.</span>")
			die(1)
		else
			user.visible_message("<span class='notice'>[user] puts out \the [src].</span>")
			quench()
	return ..()

////////////
// CIGARS //
////////////
/obj/item/clothing/mask/smokable/cigarette/cigar
	name = "premium cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigar2"
	type_butt = /obj/item/weapon/cigbutt/cigarbutt
	throw_speed = 0.5
	item_state = "cigar"
	max_smoketime = 1500
	smoketime = 1500
	chem_volume = 20
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to offend their NAME by lighting it with FLAME.</span>"
	zippomes = "<span class='rose'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER insults NAME by lighting it with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME with the power of science.</span>"

/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	name = "\improper Cohiba Robusto cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2"

/obj/item/clothing/mask/smokable/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	icon_state = "cigar2"
	max_smoketime = 7200
	smoketime = 7200
	chem_volume = 30

/obj/item/weapon/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "cigbutt"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	throwforce = 1

/obj/item/weapon/cigbutt/New()
	..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	transform = turn(transform,rand(0,360))

/obj/item/weapon/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon_state = "cigarbutt"

/obj/item/clothing/mask/smokable/cigarette/cigar/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/smokable/pipe
	name = "smoking pipe"
	desc = "A pipe, for smoking. Made of fine, stained cherry wood."
	icon_state = "pipe"
	item_state = "pipe"
	smoketime = 0
	chem_volume = 50
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to light their NAME with FLAME.</span>"
	zippomes = "<span class='rose'>With much care, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER recklessly lights NAME with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME with the power of science.</span>"
	is_pipe = 1

/obj/item/clothing/mask/smokable/pipe/New()
	..()
	name = "empty [initial(name)]"

/obj/item/clothing/mask/smokable/pipe/attack_self(mob/user as mob)
	if(lit == 1)
		if(user.a_intent == I_HURT)
			user.visible_message("<span class='notice'>[user] empties the lit [src] on the floor!.</span>")
			die(1)
		else
			user.visible_message("<span class='notice'>[user] puts out \the [src].</span>")
			quench()

/obj/item/clothing/mask/smokable/pipe/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/melee/energy/sword))
		return

	..()

	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/grown/G = W
		if (!G.dry)
			user << "<span class='notice'>[G] must be dried before you stuff it into [src].</span>"
			return
		if (smoketime)
			user << "<span class='notice'>[src] is already packed.</span>"
			return
		max_smoketime = 1000
		smoketime = 1000
		if(G.reagents)
			G.reagents.trans_to_obj(src, G.reagents.total_volume)
		name = "[G.name]-packed [initial(name)]"
		qdel(G)

	else if(istype(W, /obj/item/weapon/flame/lighter))
		var/obj/item/weapon/flame/lighter/L = W
		if(L.lit)
			light("<span class='notice'>[user] manages to light their [name] with [W].</span>")

	else if(istype(W, /obj/item/weapon/flame/match))
		var/obj/item/weapon/flame/match/M = W
		if(M.lit)
			light("<span class='notice'>[user] lights their [name] with their [W].</span>")

	else if(istype(W, /obj/item/device/assembly/igniter))
		light("<span class='notice'>[user] fiddles with [W], and manages to light their [name] with the power of science.</span>")

	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

/obj/item/clothing/mask/smokable/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A nicotine delivery system popularized by folksy backwoodsmen, kept popular in the modern age and beyond by space hipsters."
	icon_state = "cobpipe"
	item_state = "cobpipe"
	chem_volume = 35

/////////
//ZIPPO//
/////////
/obj/item/weapon/flame/lighter
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon = 'icons/obj/items.dmi'
	icon_state = "lighter-g"
	item_state = "lighter-g"
	w_class = ITEMSIZE_TINY
	throwforce = 4
	flags = CONDUCT
	slot_flags = SLOT_BELT
	attack_verb = list("burnt", "singed")
	var/base_state

/obj/item/weapon/flame/lighter/zippo
	name = "\improper Zippo lighter"
	desc = "The zippo."
	icon = 'icons/obj/zippo.dmi'
	icon_state = "zippo"
	item_state = "zippo"

/obj/item/weapon/flame/lighter/random
	New()
		icon_state = "lighter-[pick("r","c","y","g")]"
		item_state = icon_state
		base_state = icon_state

/obj/item/weapon/flame/lighter/attack_self(mob/living/user)
	if(!base_state)
		base_state = icon_state
	if(!lit)
		lit = 1
		icon_state = "[base_state]on"
		item_state = "[base_state]on"
		if(istype(src, /obj/item/weapon/flame/lighter/zippo) )
			user.visible_message("<span class='rose'>Without even breaking stride, [user] flips open and lights [src] in one smooth movement.</span>")
		else
			if(prob(95))
				user.visible_message("<span class='notice'>After a few attempts, [user] manages to light the [src].</span>")
			else
				user << "<span class='warning'>You burn yourself while lighting the lighter.</span>"
				if (user.get_left_hand() == src)
					user.apply_damage(2,BURN,"l_hand")
				else
					user.apply_damage(2,BURN,"r_hand")
				user.visible_message("<span class='notice'>After a few attempts, [user] manages to light the [src], they however burn their finger in the process.</span>")

		set_light(2)
		processing_objects.Add(src)
	else
		lit = 0
		icon_state = "[base_state]"
		item_state = "[base_state]"
		if(istype(src, /obj/item/weapon/flame/lighter/zippo) )
			user.visible_message("<span class='rose'>You hear a quiet click, as [user] shuts off [src] without even looking at what they're doing.</span>")
		else
			user.visible_message("<span class='notice'>[user] quietly shuts off the [src].</span>")

		set_light(0)
		processing_objects.Remove(src)
	return


/obj/item/weapon/flame/lighter/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(lit == 1)
		M.IgniteMob()
		msg_admin_attack("[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] and lit them on fire (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	if(istype(M.wear_mask, /obj/item/clothing/mask/smokable/cigarette) && user.zone_sel.selecting == O_MOUTH && lit)
		var/obj/item/clothing/mask/smokable/cigarette/cig = M.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			if(istype(src, /obj/item/weapon/flame/lighter/zippo))
				cig.light("<span class='rose'>[user] whips the [name] out and holds it for [M].</span>")
			else
				cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights the [cig.name].</span>")
	else
		..()

/obj/item/weapon/flame/lighter/process()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)
	return

//Here we add Zippo skins.

/obj/item/weapon/flame/lighter/zippo/black
	name = "\improper holy Zippo lighter"
	desc = "Only in regards to Christianity, that is."
	icon_state = "blackzippo"

/obj/item/weapon/flame/lighter/zippo/blue
	name = "\improper blue Zippo lighter"
	icon_state = "bluezippo"

/obj/item/weapon/flame/lighter/zippo/engraved
	name = "\improper engraved Zippo lighter"
	icon_state = "engravedzippo"
	item_state = "zippo"

/obj/item/weapon/flame/lighter/zippo/gold
	name = "\improper golden Zippo lighter"
	icon_state = "goldzippo"

/obj/item/weapon/flame/lighter/zippo/moff
	name = "\improper moth Zippo lighter"
	desc = "Too cute to be a Tymisian."
	icon_state = "moffzippo"

/obj/item/weapon/flame/lighter/zippo/red
	name = "\improper red Zippo lighter"
	icon_state = "redzippo"

/obj/item/weapon/flame/lighter/zippo/ironic
	name = "\improper ironic Zippo lighter"
	desc = "What a quiant idea."
	icon_state = "ironiczippo"

/obj/item/weapon/flame/lighter/zippo/capitalist
	name = "\improper capitalist Zippo lighter"
	desc = "Made of gold and obsidian, this is truly not worth however much you spent on it."
	icon_state = "cappiezippo"

/obj/item/weapon/flame/lighter/zippo/rainbow
	name = "\improper rainbow Zippo lighter"
	icon_state = "rainbowzippo"