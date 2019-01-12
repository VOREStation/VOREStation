/mob/living/simple_animal/corgi/show_inv(mob/user as mob)
	user.set_machine(src)
	if(user.stat) return

	var/dat = 	"<div align='center'><b>Inventory of [name]</b></div><p>"
	if(inventory_head)
		dat +=	"<br><b>Head:</b> [inventory_head] (<a href='?src=\ref[src];remove_inv=head'>Remove</a>)"
	else
		dat +=	"<br><b>Head:</b> <a href='?src=\ref[src];add_inv=head'>Nothing</a>"
	if(inventory_back)
		dat +=	"<br><b>Back:</b> [inventory_back] (<a href='?src=\ref[src];remove_inv=back'>Remove</a>)"
	else
		dat +=	"<br><b>Back:</b> <a href='?src=\ref[src];add_inv=back'>Nothing</a>"

	user << browse(dat, text("window=mob[];size=325x500", name))
	onclose(user, "mob[real_name]")
	return

/mob/living/simple_animal/corgi/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(inventory_head && inventory_back)
		//helmet and armor = 100% protection
		if( istype(inventory_head,/obj/item/clothing/head/helmet) && istype(inventory_back,/obj/item/clothing/suit/armor) )
			if( O.force )
				usr << "<span class='warning'>This animal is wearing too much armor. You can't cause them any damage.</span>"
				for (var/mob/M in viewers(src, null))
					M.show_message("<span class='warning'><B>[user] hits [src] with the [O], however [src] is too armored.</B></span>")
			else
				usr << "<span class='warning'>This animal is wearing too much armor. You can't reach its skin.</span>"
				for (var/mob/M in viewers(src, null))
					M.show_message("<span class='warning'>[user] gently taps [src] with the [O].</span>")
			if(prob(15))
				visible_emote("looks at [user] with [pick("an amused","an annoyed","a confused","a resentful", "a happy", "an excited")] expression on \his face")
			return
	..()

/mob/living/simple_animal/corgi/Topic(href, href_list)
	if(usr.stat) return

	//Removing from inventory
	if(href_list["remove_inv"])
		if(!Adjacent(usr))
			return
		var/remove_from = href_list["remove_inv"]
		switch(remove_from)
			if("head")
				if(inventory_head)
					name = real_name
					desc = initial(desc)
					speak = list("YAP", "Woof!", "Bark!", "AUUUUUU")
					speak_emote = list("barks", "woofs")
					emote_hear = list("barks", "woofs", "yaps","pants")
					emote_see = list("shakes its head", "shivers")
					desc = "It's a corgi."
					inventory_head.loc = src.loc
					inventory_head = null
					regenerate_icons()
				else
					to_chat(usr, "<span class='warning'>There is nothing to remove from its [remove_from].</span>")
					return
			if("back")
				if(inventory_back)
					inventory_back.loc = src.loc
					inventory_back = null
					regenerate_icons()
				else
					to_chat(usr, "<span class='warning'>There is nothing to remove from its [remove_from].</span>")
					return

	//Adding things to inventory
	else if(href_list["add_inv"])
		if(!Adjacent(usr))
			return
		var/add_to = href_list["add_inv"]
		if(!usr.get_active_hand())
			usr << "<span class='warning'>You have nothing in your hand to put on its [add_to].</span>"
			return
		switch(add_to)
			if("head")
				if(inventory_head)
					usr << "<span class='warning'>It's is already wearing something.</span>"
					return
				else
					place_on_head(usr.get_active_hand())

					var/obj/item/item_to_add = usr.get_active_hand()
					if(!item_to_add)
						return

					var/list/allowed_types = list(
						/obj/item/weapon/bedsheet,
						/obj/item/clothing/glasses/sunglasses,
						/obj/item/clothing/head/caphat,
						/obj/item/clothing/head/that,
						/obj/item/clothing/head/beret,
						/obj/item/clothing/head/nursehat,
						/obj/item/clothing/head/pirate,
						/obj/item/clothing/head/ushanka,
						/obj/item/clothing/head/chefhat,
						/obj/item/clothing/head/wizard,
						/obj/item/clothing/head/wizard/fake,
						/obj/item/clothing/head/hardhat,
						/obj/item/clothing/head/hardhat/white,
						/obj/item/clothing/head/helmet,
						/obj/item/clothing/head/helmet/space/santahat,
						/obj/item/clothing/head/collectable/chef,
						/obj/item/clothing/head/collectable/police,
						/obj/item/clothing/head/collectable/wizard,
						/obj/item/clothing/head/collectable/rabbitears,
						/obj/item/clothing/head/collectable/beret,
						/obj/item/clothing/head/collectable/pirate,
						/obj/item/clothing/head/collectable/hardhat,
						/obj/item/clothing/head/collectable/captain,
						/obj/item/clothing/head/collectable/paper,
						/obj/item/clothing/head/soft
					)

					if( ! ( item_to_add.type in allowed_types ) )
						usr << "<span class='warning'>It doesn't seem too keen on wearing that item.</span>"
						return

					usr.drop_item()

					place_on_head(item_to_add)

			if("back")
				if(inventory_back)
					usr << "<span class='warning'>It's already wearing something.</span>"
					return
				else
					var/obj/item/item_to_add = usr.get_active_hand()
					if(!item_to_add)
						return

					//Corgis are supposed to be simpler, so only a select few objects can actually be put
					//to be compatible with them. The objects are below.

					var/list/allowed_types = list(
						/obj/item/clothing/suit/armor/vest,
						/obj/item/device/radio
					)

					if( ! ( item_to_add.type in allowed_types ) )
						usr << "<span class='warning'>This object won't fit.</span>"
						return

					usr.drop_item()
					item_to_add.loc = src
					src.inventory_back = item_to_add
					regenerate_icons()
	else
		..()

/mob/living/simple_animal/corgi/proc/place_on_head(obj/item/item_to_add)
	item_to_add.loc = src
	src.inventory_head = item_to_add
	regenerate_icons()

	//Various hats and items (worn on his head) change Ian's behaviour. His attributes are reset when a HAT is removed.
	switch(inventory_head && inventory_head.type)
		if(/obj/item/clothing/head/caphat, /obj/item/clothing/head/collectable/captain)
			name = "Captain [real_name]"
			desc = "Probably better than the last captain."
/*
		if(/obj/item/clothing/head/accessory/kitty, /obj/item/clothing/head/collectable/kitty)
			name = "Runtime"
			emote_see = list("coughs up a furball", "stretches")
			emote_hear = list("purrs")
			speak = list("Purrr", "Meow!", "MAOOOOOW!", "HISSSSS", "MEEEEEEW")
			desc = "It's a cute little kitty-cat! ... wait ... what the hell?"
		if(/obj/item/clothing/head/accessory/bunny, /obj/item/clothing/head/collectable/rabbitears)
			name = "Hoppy"
			emote_see = list("twitches its nose", "hops around a bit")
			desc = "This is hoppy. It's a corgi-...urmm... bunny rabbit"
*/
		if(/obj/item/clothing/head/beret, /obj/item/clothing/head/collectable/beret)
			name = "Yann"
			desc = "Mon dieu! C'est un chien!"
			speak = list("le woof!", "le bark!", "JAPPE!!")
			emote_see = list("cowers in fear", "surrenders", "plays dead","looks as though there is a wall in front of him")
/*
		if(/obj/item/clothing/head/det_hat)
			name = "Detective [real_name]"
			desc = "[name] sees through your lies..."
			emote_see = list("investigates the area","sniffs around for clues","searches for scooby snacks")
*/
		if(/obj/item/clothing/head/nursehat)
			name = "Nurse [real_name]"
			desc = "[name] needs 100cc of beef jerky...STAT!"
		if(/obj/item/clothing/head/pirate, /obj/item/clothing/head/collectable/pirate)
			name = "[pick("Ol'","Scurvy","Black","Rum","Gammy","Bloody","Gangrene","Death","Long-John")] [pick("kibble","leg","beard","tooth","poop-deck","Threepwood","Le Chuck","corsair","Silver","Crusoe")]"
			desc = "Yaarghh!! Thar' be a scurvy dog!"
			emote_see = list("hunts for treasure","stares coldly...","gnashes his tiny corgi teeth")
			emote_hear = list("growls ferociously", "snarls")
			speak = list("Arrrrgh!!","Grrrrrr!")
		if(/obj/item/clothing/head/ushanka)
			name = "[pick("Comrade","Commissar","Glorious Leader")] [real_name]"
			desc = "A follower of Karl Barx."
			emote_see = list("contemplates the failings of the capitalist economic model", "ponders the pros and cons of vangaurdism")
		if(/obj/item/clothing/head/collectable/police)
			name = "Officer [real_name]"
			emote_see = list("drools","looks for donuts")
			desc = "Stop right there criminal scum!"
		if(/obj/item/clothing/head/wizard/fake,	/obj/item/clothing/head/wizard,	/obj/item/clothing/head/collectable/wizard)
			name = "Grandwizard [real_name]"
			speak = list("YAP", "Woof!", "Bark!", "AUUUUUU", "EI  NATH!")
		if(/obj/item/weapon/bedsheet)
			name = "\improper Ghost"
			speak = list("WoooOOOooo~","AUUUUUUUUUUUUUUUUUU")
			emote_see = list("stumbles around", "shivers")
			emote_hear = list("howls","groans")
			desc = "Spooky!"
		if(/obj/item/clothing/head/helmet/space/santahat)
			name = "Rudolph the Red-Nosed Corgi"
			emote_hear = list("barks christmas songs", "yaps")
			desc = "He has a very shiny nose."
		if(/obj/item/clothing/head/soft)
			name = "Corgi Tech [real_name]"
			desc = "The reason your yellow gloves have chew-marks."
