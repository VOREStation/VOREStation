/obj/item/clothing/head/helmet/space/void/zaddat
	name = "\improper Hegemony Shroud helmet"
	desc = "A Hegemony-designed utilitarian environment suit helmet, still common among the Spacer Zaddat."
	icon_state = "zaddat_hegemony"
	item_state_slots = list(slot_r_hand_str = "syndicate", slot_l_hand_str = "syndicate")
	body_parts_covered = HEAD|FACE|EYES
	slowdown = 0.5
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 70) //realistically would have some armor but balance.
	siemens_coefficient = 1

	species_restricted = list(SPECIES_ZADDAT, SPECIES_PROMETHEAN) //on request from maintainer

/obj/item/clothing/suit/space/void/zaddat
	name = "\improper Hegemony Shroud"
	desc = "A Hegemony environment suit, still favored by the Spacer Zaddat because of its durability and ease of manufacture."
	slowdown = 1
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 70)
	siemens_coefficient = 1
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_ALL_TANKS)
	icon_state = "zaddat_hegemony"
	helmet = new/obj/item/clothing/head/helmet/space/void/zaddat //shrouds come with helmets built-in
	var/has_been_customized = FALSE

	species_restricted = list(SPECIES_ZADDAT, SPECIES_PROMETHEAN)

	breach_threshold = 12

/obj/item/clothing/suit/space/void/zaddat/verb/custom_suit()
	set name = "Customize Shroud"
	set category = "Object"
	set desc = "Pick an appearence for your Shroud."

	var/mob/M = usr
	var/suit_style = null

	if(has_been_customized)
		to_chat(M, "This Shroud has already been customized!")
		return 0

	suit_style = tgui_input_list(M, "Which suit style would you like?", "Suit Style", list("Engineer", "Spacer", "Knight", "Fashion", "Bishop", "Hegemony", "Rugged", "Soft"))
	switch(suit_style)
		if("Engineer")
			name = "\improper Engineer's Guild Shroud"
			base_name = "\improper Engineer's Guild Shroud"
			desc = "This rugged Shroud was created by the Xozi Engineering Guild."
			icon_state = "zaddat_engie"
			item_state = "zaddat_engie"
			if(helmet)
				helmet.name = "\improper Engineer's Guild Shroud helmet"
				helmet.desc = "A Shroud helmet designed for good visibility in low-light environments."
				helmet.icon_state = "zaddat_engie"
				helmet.item_state = "zaddat_engie"
		if("Spacer")
			name = "\improper Spacer's Guild Shroud"
			base_name = "\improper Spacer's Guild Shroud"
			desc = "The blue plastic Shroud worn by members of the Zaddat Spacer's Guild."
			icon_state = "zaddat_spacer"
			item_state = "zaddat_spacer"
			if(helmet)
				helmet.name = "\improper Spacer's Guild Shroud helmet"
				helmet.desc = "A cool plastic-and-glass helmet designed after popular adventure fiction."
				helmet.icon_state = "zaddat_spacer"
				helmet.item_state = "zaddat_spacer"
		if("Knight")
			name = "\improper Knight's Shroud"
			base_name = "\improper Knight's Shroud"
			desc = "This distinctive steel-plated Shroud was popularized by the Noble Guild."
			icon_state = "zaddat_knight"
			item_state = "zaddat_knight"
			if(helmet)
				helmet.name = "\improper Knight's Shroud helm"
				helmet.desc = "This spaceworthy helmet was patterned after the knight's helmets used by Zaddat before their discovery by the Unathi."
				helmet.icon_state = "zaddat_knight"
				helmet.item_state = "zaddat_knight"
		if("Fashion")
			name = "\improper Avazi House Shroud"
			base_name = "\improper Avazi House Shroud"
			desc = "The designers of the Avazi Fashion House are among the most renowned in Zaddat society, and their Shroud designs second to none."
			icon_state = "zaddat_fashion"
			item_state = "zaddat_fashion"
			if(helmet)
				helmet.name = "\improper Avazi House Shroud helmet"
				helmet.desc = "The Avazi Fashion House recently designed this popular Shroud helmet, designed to pleasingly frame a Zaddat's face."
				helmet.icon_state = "zaddat_fashion"
				helmet.item_state = "zaddat_fashion"
		if("Bishop")
			name = "\improper Bishop-patterned Shroud"
			base_name = "\improper Bishop-patterned Shroud"
			desc = "The bold designers of the Dzaz Fashion House chose to make this Bishop-themed Shroud design as a commentary on the symbiotic nature of Vanax and human culture. Allegedly."
			icon_state = "zaddat_bishop"
			item_state = "zaddat_bishop"
			if(helmet)
				helmet.name = "\improper Bishop-patterned Shroud helmet"
				helmet.desc = "The Shroud helmet that inspired a dozen lawsuits."
				helmet.icon_state = "zaddat_bishop"
				helmet.item_state = "zaddat_bishop"
		if("Rugged")
			name = "rugged Shroud"
			base_name = "rugged Shroud"
			desc = "This Shroud was patterned after from First Contact era human voidsuits."
			icon_state = "zaddat_rugged"
			item_state = "zaddat_rugged"
			if(helmet)
				helmet.name = "rugged Shroud helmet"
				helmet.desc = "Supposedly, this helmet should make humans more comfortable and familiar with the Zaddat."
				helmet.icon_state = "zaddat_rugged"
				helmet.item_state = "zaddat_rugged"
		if("Soft")
			name = "\improper soft Shroud"
			base_name = "\improper soft Shroud"
			desc = "Material and design is chosen for practical reasons, making it take as little space as possible when stowed whilst also providing reasonable comfort when worn for long periods."
			icon_state = "zaddat_soft"
			item_state = "zaddat_soft"
			if(helmet)
				helmet.name = "\improper soft Shroud hood"
				helmet.desc = "Not as solid as a proper helmet, but works nonetheless."
				helmet.icon_state = "zaddat_soft"
				helmet.item_state = "zaddat_soft"

	to_chat(M, "You finish customizing your Shroud. Looking good!")
	has_been_customized = TRUE
	M.regenerate_icons()
	return 1
