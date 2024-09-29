/obj/item/reagent_containers/food/drinks/glass2/attackby(obj/item/I as obj, mob/user as mob)
	if(extras.len >= 2) return ..() // max 2 extras, one on each side of the drink

	if(istype(I, /obj/item/glass_extra))
		var/obj/item/glass_extra/GE = I
		if(can_add_extra(GE))
			extras += GE
			user.remove_from_mob(GE)
			GE.loc = src
			to_chat(user, "<span class=notice>You add \the [GE] to \the [src].</span>")
			update_icon()
		else
			to_chat(user, "<span class=warning>There's no space to put \the [GE] on \the [src]!</span>")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/fruit_slice))
		if(!rim_pos)
			to_chat(user, "<span class=warning>There's no space to put \the [I] on \the [src]!</span>")
			return
		var/obj/item/reagent_containers/food/snacks/fruit_slice/FS = I
		extras += FS
		user.remove_from_mob(FS)
		FS.pixel_x = 0 // Reset its pixel offsets so the icons work!
		FS.pixel_y = 0
		FS.loc = src
		to_chat(user, "<span class=notice>You add \the [FS] to \the [src].</span>")
		update_icon()
	else
		return ..()

/obj/item/reagent_containers/food/drinks/glass2/attack_hand(mob/user as mob)
	if(src != user.get_inactive_hand())
		return ..()

	if(!extras.len)
		to_chat(user, "<span class=warning>There's nothing on the glass to remove!</span>")
		return

	var/choice = tgui_input_list(user, "What would you like to remove from the glass?", "Removal Choice", extras)
	if(!choice || !(choice in extras))
		return

	if(user.put_in_active_hand(choice))
		to_chat(user, "<span class=notice>You remove \the [choice] from \the [src].</span>")
		extras -= choice
	else
		to_chat(user, "<span class=warning>Something went wrong, please try again.</span>")

	update_icon()

/obj/item/glass_extra
	name = "generic glass addition"
	desc = "This goes on a glass."
	var/glass_addition
	var/glass_desc
	var/glass_color
	w_class = ITEMSIZE_TINY
	icon = DRINK_ICON_FILE

/obj/item/glass_extra/stick
	name = "stick"
	desc = "This goes in a glass."
	glass_addition = "stick"
	glass_desc = "There is a stick in the glass."
	icon_state = "stick"

/obj/item/glass_extra/straw
	name = "straw"
	desc = "This goes in a glass."
	glass_addition = "straw"
	glass_desc = "There is a straw in the glass."
	icon_state = "straw"

// This isn't great code, so if you're doing something that happens many times or isn't user-initiated
// like this is, where it'll likely happen 0-4 times a shift, then don't copy this pattern.
/obj/item/glass_extra/straw/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(ismob(target) && proximity_flag)
		// Clicked protean blob
		if(istype(target, /mob/living/simple_mob/protean_blob))
			sipp_mob(target, user, "liquid_protean")
			return
		// Clicked humanoid
		else if(ishuman(target))
			var/mob/living/carbon/human/H = target
			var/speciesname = H.species?.name
			switch(speciesname)
				if(SPECIES_PROTEAN)
					sipp_mob(target, user, "liquid_protean")
					return
				if(SPECIES_PROMETHEAN)
					sipp_mob(target, user, "nutriment")
					return
	return ..()

/obj/item/glass_extra/straw/proc/sipp_mob(mob/living/victim, mob/user, reagent_type = "nutriment")
	if(victim.health <= 0)
		to_chat(user, "<span class='warning'>There's not enough of [victim] left to sip on!</span>")
		return
	
	user.visible_message("<b>[user]</b> starts sipping on [victim] with [src]!", "You start sipping on [victim] with [src].")
	if(!do_after(user, 3 SECONDS, victim, exclusive = TASK_ALL_EXCLUSIVE))
		return

	user.visible_message("<b>[user]</b> sips some of [victim] with [src]!", "You take a sip of [victim] with [src]. Yum!")
	if(victim.vore_taste)
		to_chat(user, "<b>[victim]</b> tastes like... [victim.vore_taste]!")
	
	victim.apply_damage(5, used_weapon = "straw")
	
	// If you're human you get the reagent
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.ingested.add_reagent(reagent_type, 2)
	// Anything else just gets some nutrition
	else if(isliving(user))
		var/mob/living/L = user
		L.adjust_nutrition(30)

#undef DRINK_ICON_FILE
