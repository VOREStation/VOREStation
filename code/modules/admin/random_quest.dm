/mob/proc/quest_from_above(var/specific_quest)
	var/list/quests = list("Search",
							"Collect",
							"Drink",
							"Eat",
							"Visit",
							"Clean",
							"Wear",
							"Pet")
	var/list/searchables = list("Trash Piles",
								"Lockers",
								"Backpacks",
								"Trash Cans and Disposal Units",
								"Co-worker's Pockets")
	var/list/collectables = list("Rare Coins",
								"Figurines",
								"Protein Shakes",
								"Non-Lethal Weapons",
								"Sunglasses",
								"Mega Nukies",
								"Kinky Toys",
								"Plushies")
	var/list/locations = list("Redgate Locations",
								"High Security Areas",
								"Medbay Rooms",
								"Security Rooms",
								"Maintenance Rooms",
								"Command Rooms",
								"Engineering Rooms",
								"Deep Space Locations",
								"Research Rooms")
	var/list/pets = list("Mice",
						"Mothroaches",
						"Canines",
						"Plushies",
						"Felines",
						"Lizards",
						"Co-workers")
	var/complete_quest
	if(!specific_quest)
		var/chosen_one = pick(quests)
		var/chosen_two
		var/number_of_times
		switch(chosen_one)
			if("Search")
				chosen_two = pick(searchables)
				number_of_times = rand(4,10)
				complete_quest = "[chosen_one] [number_of_times] [chosen_two]!"
			if("Collect")
				chosen_two = pick(collectables)
				number_of_times = rand(3,10)
				complete_quest = "[chosen_one] [number_of_times] [chosen_two]!"
			if("Drink")
				var/list/drink_list = typesof(/obj/item/reagent_containers/food/drinks)
				var/obj/item/reagent_containers/food/drinks/pick_drink = pick(drink_list)
				chosen_two = pick_drink.name
				number_of_times = rand(2,6)
				complete_quest = "[chosen_one] [number_of_times] [chosen_two]s!"
			if("Eat")
				var/list/snack_list = typesof(/obj/item/reagent_containers/food/snacks)
				var/obj/item/reagent_containers/food/snacks/pick_snack = pick(snack_list)
				chosen_two = pick_snack.name
				number_of_times = rand(2,6)
				complete_quest = "[chosen_one] [number_of_times] [chosen_two]s!"
			if("Visit","Clean")
				chosen_two = pick(locations)
				number_of_times = rand(2,8)
				complete_quest = "[chosen_one] [number_of_times] [chosen_two]!"
			if("Wear")
				var/clothing_options = typesof(/obj/item/clothing)
				var/obj/item/clothing/clothing_one = pick(clothing_options)
				var/obj/item/clothing/clothing_two = pick(clothing_options)
				var/obj/item/clothing/clothing_three = pick(clothing_options)
				complete_quest = "[chosen_one] as many of the following as you can find: [clothing_one.name], [clothing_two.name] and [clothing_three.name]!"
			if("Pet")
				chosen_two = pick(pets)
				number_of_times = rand(2,5)
				complete_quest = "[chosen_one] [number_of_times] [chosen_two]!"
	else
		complete_quest = specific_quest

	to_chat(src, span_notice(span_huge("You have been granted a quest from above!")))
	to_chat(src, span_notice("From somewhere deep inside yourself, a quest has been conjured. You feel a compulsion to complete the following activity:"))
	to_chat(src, span_boldnotice("[complete_quest]"))
	to_chat(src, span_notice(span_small("Please note that this is just a bit of fun, you should not use this an excuse to break rules or cause major disruptions for other players.")))

	log_and_message_admins("[src.ckey] playing as [src.name] has been given the quest: [complete_quest]")
