/obj/structure/undies_wardrobe
	name = "underwear wardrobe"
	desc = "Holds item of clothing you shouldn't be showing off in the hallways."
	icon = 'icons/obj/closet.dmi'
	icon_state = "cabinet_closed"
	density = 1

/obj/structure/undies_wardrobe/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = user
	if(!ishuman(user) || (H.species && !(H.species.appearance_flags & HAS_UNDERWEAR)))
		user << "<span class='warning'>Sadly there's nothing in here for you to wear.</span>"
		return 0

	var/utype = alert("Which section do you want to pick from?",,"Underwear", "Undershirts", "Socks",)
	var/list/selection
	switch(utype)
		if("Underwear")
			utype = alert("Which section do you want to pick from?",, "Top", "Bottom",)
			switch(utype)
				if("Top")
					selection = underwear_top_t
				if("Bottom")
					selection = underwear_bottom_t
		if("Undershirts")
			selection = undershirt_t
		if("Socks")
			selection = socks_t
	var/pick = input("Select the style") as null|anything in selection
	if(pick)
		if(get_dist(src,user) > 1)
			return
		if(utype == "Undershirts")
			H.undershirt = selection[pick]
		else if(utype == "Socks")
			H.socks = selection[pick]
		else if(utype == "Top")
			H.underwear_top = selection[pick]
		else
			H.underwear_bottom = selection[pick]
		H.update_body(1)

	return 1