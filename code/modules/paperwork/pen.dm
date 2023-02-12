/* Pens!
 * Contains:
 *		Pens
 *		Coloured Pens
 *		Fountain Pens
 *		Multi Pen
 *		Reagent Pens
 *		Blade Pens
 *		Sleepy Pens
 *		Parapens
 *		Chameleon Pen
 *		Crayons
 */

/*
 * Pens
 */
/obj/item/weapon/pen
	name = "pen"
	desc = "It's a normal black ink pen."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 0
	w_class = ITEMSIZE_TINY
	throw_speed = 7
	throw_range = 15
	matter = list(MAT_STEEL = 10)
	attack_verb = list("stabbed")
	var/colour = "black"	//what colour the ink is!
	pressure_resistance = 2
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/weapon/pen/attack_self(var/mob/user)
	if(!user.checkClickCooldown())
		return
	user.setClickCooldown(1 SECOND)
	to_chat(user, "<span class='notice'>Click.</span>")
	playsound(src, 'sound/items/penclick.ogg', 50, 1)

/*
 * Coloured Pens
 */
/obj/item/weapon/pen/blue
	desc = "It's a normal blue ink pen."
	icon_state = "pen_blue"
	colour = "blue"

/obj/item/weapon/pen/red
	desc = "It's a normal red ink pen."
	icon_state = "pen_red"
	colour = "red"

/*
 * Fountain Pens
 */
/obj/item/weapon/pen/fountain
	desc = "A well made fountain pen, with a faux wood body."
	icon_state = "pen_fountain"

/obj/item/weapon/pen/fountain2
	desc = "A well made fountain pen, with a faux wood body. This one has golden accents."
	icon_state = "pen_fountain"

/obj/item/weapon/pen/fountain3
	desc = "A well made expesive rosewood pen with golden accents. Very pretty."
	icon_state = "pen_fountain"

/obj/item/weapon/pen/fountain4
	desc = "A well made and expensive fountain pen. This one has silver accents."
	icon_state = "blues_fountain"

/obj/item/weapon/pen/fountain5
	desc = "A well made and expensive fountain pen. This one has gold accents."
	icon_state = "blueg_fountain"

/obj/item/weapon/pen/fountain6
	desc = "A well made and expensive fountain pen. The nib is quite sharp."
	icon_state = "command_fountain"

/obj/item/weapon/pen/fountain7
	desc = "A well made and expensive fountain pen made from gold."
	icon_state = "gold_fountain"

/obj/item/weapon/pen/fountain8
	desc = "A well made and expensive fountain pen."
	icon_state = "black_fountain"

/obj/item/weapon/pen/fountain9
	desc = "A well made and expensive fountain pen made for gesturing."
	icon_state = "mime_fountain"


/*
 * Multi Pen
 */
/obj/item/weapon/pen/multi
	desc = "It's a pen with multiple colors of ink!"
	var/selectedColor = 1
	var/colors = list("black","blue","red")

/obj/item/weapon/pen/AltClick(mob/user)
	to_chat(user, "<span class='notice'>Click.</span>")
	playsound(src, 'sound/items/penclick.ogg', 50, 1)
	return

/obj/item/weapon/pen/multi/attack_self(mob/user)
	if(++selectedColor > 3)
		selectedColor = 1

	colour = colors[selectedColor]

	if(colour == "black")
		icon_state = "pen"
	else
		icon_state = "pen_[colour]"

	to_chat(user, "<span class='notice'>Changed color to '[colour].'</span>")

/obj/item/weapon/pen/invisible
	desc = "It's an invisble pen marker."
	icon_state = "pen"
	colour = "white"

/*
 * Reagent Pens
 */

/obj/item/weapon/pen/reagent
	flags = OPENCONTAINER
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/weapon/pen/reagent/New()
	..()
	create_reagents(30)

/obj/item/weapon/pen/reagent/attack(mob/living/M as mob, mob/user as mob)

	if(!istype(M))
		return

	. = ..()

	if(M.can_inject(user,1))
		if(reagents.total_volume)
			if(M.reagents)
				var/contained = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(M, 30, CHEM_BLOOD)
				add_attack_logs(user,M,"Injected with [src.name] containing [contained], trasferred [trans] units")

/*
 * Blade Pens
 */
/obj/item/weapon/pen/blade
	desc = "It's a normal black ink pen."
	description_antag = "This pen can be transformed into a dangerous melee and thrown assassination weapon with an Alt-Click.\
	When active, it cannot be caught safely."
	name = "pen"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 3
	w_class = ITEMSIZE_TINY
	throw_speed = 7
	throw_range = 15
	armor_penetration = 20

	var/active = 0
	var/active_embed_chance = 0
	var/active_force = 15
	var/active_throwforce = 30
	var/active_w_class = ITEMSIZE_NORMAL
	var/active_icon_state
	var/default_icon_state

/obj/item/weapon/pen/blade/Initialize()
	. = ..()
	active_icon_state = "[icon_state]-x"
	default_icon_state = icon_state

/obj/item/weapon/pen/blade/AltClick(mob/user)
	..()
	if(active)
		deactivate(user)
	else
		activate(user)

	to_chat(user, "<span class='notice'>You [active ? "de" : ""]activate \the [src]'s blade.</span>")

/obj/item/weapon/pen/blade/proc/activate(mob/living/user)
	if(active)
		return
	active = 1
	icon_state = active_icon_state
	embed_chance = active_embed_chance
	force = active_force
	throwforce = active_throwforce
	sharp = TRUE
	edge = TRUE
	w_class = active_w_class
	playsound(src, 'sound/weapons/saberon.ogg', 15, 1)
	damtype = SEARING
	catchable = FALSE

	attack_verb |= list(\
		"slashed",\
		"cut",\
		"shredded",\
		"stabbed"\
		)

/obj/item/weapon/pen/blade/proc/deactivate(mob/living/user)
	if(!active)
		return
	playsound(src, 'sound/weapons/saberoff.ogg', 15, 1)
	active = 0
	icon_state = default_icon_state
	embed_chance = initial(embed_chance)
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	w_class = initial(w_class)
	damtype = BRUTE
	catchable = TRUE
	attack_verb = initial(attack_verb)

/obj/item/weapon/pen/blade/blue
	desc = "It's a normal blue ink pen."
	icon_state = "pen_blue"
	colour = "blue"

/obj/item/weapon/pen/blade/red
	desc = "It's a normal red ink pen."
	icon_state = "pen_red"
	colour = "red"

/obj/item/weapon/pen/blade/fountain
	desc = "A well made fountain pen, with a faux wood body."
	icon_state = "pen_fountain"

/*
 * Sleepy Pens
 */
/obj/item/weapon/pen/reagent/sleepy
	desc = "It's a black ink pen with a sharp point and a carefully engraved \"Waffle Co.\""
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/weapon/pen/reagent/sleepy/New()
	..()
	reagents.add_reagent("chloralhydrate", 1)	//VOREStation Edit
	reagents.add_reagent("stoxin", 14)	//VOREStation Add


/*
 * Parapens
 */
/obj/item/weapon/pen/reagent/paralysis
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/weapon/pen/reagent/paralysis/New()
	..()
	reagents.add_reagent("zombiepowder", 5)
	reagents.add_reagent("cryptobiolin", 10)

/*
 * Chameleon Pen
 */
/obj/item/weapon/pen/chameleon
	var/signature = ""

/obj/item/weapon/pen/chameleon/attack_self(mob/user as mob)
	/*
	// Limit signatures to official crew members
	var/personnel_list[] = list()
	for(var/datum/data/record/t in data_core.locked) //Look in data core locked.
		personnel_list.Add(t.fields["name"])
	personnel_list.Add("Anonymous")

	var/new_signature = tgui_input_list(usr, "Enter new signature pattern.", "New Signature", personnel_list)
	if(new_signature)
		signature = new_signature
	*/
	signature = sanitize(tgui_input_text(usr, "Enter new signature. Leave blank for 'Anonymous'", "New Signature", signature))

/obj/item/weapon/pen/proc/get_signature(var/mob/user)
	return (user && user.real_name) ? user.real_name : "Anonymous"

/obj/item/weapon/pen/chameleon/get_signature(var/mob/user)
	return signature ? signature : "Anonymous"

/obj/item/weapon/pen/chameleon/verb/set_colour()
	set name = "Change Pen Colour"
	set category = "Object"

	var/list/possible_colours = list ("Yellow", "Green", "Pink", "Blue", "Orange", "Cyan", "Red", "Invisible", "Black")
	var/selected_type = tgui_input_list(usr, "Pick new colour.", "Pen Colour", possible_colours)

	if(selected_type)
		switch(selected_type)
			if("Yellow")
				colour = COLOR_YELLOW
			if("Green")
				colour = COLOR_LIME
			if("Pink")
				colour = COLOR_PINK
			if("Blue")
				colour = COLOR_BLUE
			if("Orange")
				colour = COLOR_ORANGE
			if("Cyan")
				colour = COLOR_CYAN
			if("Red")
				colour = COLOR_RED
			if("Invisible")
				colour = COLOR_WHITE
			else
				colour = COLOR_BLACK
		to_chat(usr, "<span class='info'>You select the [lowertext(selected_type)] ink container.</span>")


/*
 * Crayons
 */
/obj/item/weapon/pen/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonred"
	w_class = ITEMSIZE_TINY
	attack_verb = list("attacked", "coloured")
	colour = "#FF0000" //RGB
	var/shadeColour = "#220000" //RGB
	var/uses = 30 //0 for unlimited uses
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/weapon/pen/crayon/New()
	name = "[colourName] crayon"

/obj/item/weapon/pen/crayon/marker
	name = "marker"
	desc = "A chisel-tip permanent marker. Hopefully non-toxic."
	icon_state = "markerred"

/obj/item/weapon/pen/crayon/marker/New()
	name = "[colourName] marker"
