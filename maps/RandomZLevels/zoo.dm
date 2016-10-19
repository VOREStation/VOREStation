// -- Areas -- //

/area/awaymission/zoo
	icon_state = "green"
	requires_power = 0
	lighting_use_dynamic = 0
	ambience = list('sound/ambience/ambispace.ogg','sound/music/title2.ogg','sound/music/space.ogg','sound/music/main.ogg','sound/music/traitor.ogg')

/area/awaymission/zoo/solars
	icon_state = "yellow"

/area/awaymission/zoo/tradeship
	icon_state = "purple"

/area/awaymission/zoo/syndieship
	icon_state = "red"

/area/awaymission/zoo/pirateship
	icon_state = "bluenew"

/obj/machinery/vending/food
	name = "Food-O-Mat"
	desc = "A technological marvel, supposedly able to cook or mix a large variety of food or drink."
	icon_state = "boozeomat"
	icon_deny = "boozeomat-deny"
	products = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice = 4,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice = 4,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice = 4,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cream = 4,
					/obj/item/weapon/reagent_containers/food/drinks/milk = 4,
					/obj/item/weapon/reagent_containers/food/drinks/cans/cola = 8,
					/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater = 15,
					/obj/item/weapon/reagent_containers/food/drinks/flask/barflask = 2,
					/obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask = 2,
					/obj/item/weapon/reagent_containers/food/drinks/ice = 9,
					/obj/item/weapon/reagent_containers/food/drinks/tea = 10,
					/obj/item/weapon/reagent_containers/food/snacks/appletart = 4,
					/obj/item/weapon/reagent_containers/food/snacks/cheeseburger = 10,
					/obj/item/weapon/reagent_containers/food/snacks/creamcheesebreadslice = 10,
					/obj/item/weapon/reagent_containers/food/snacks/grilledcheese = 10,
					/obj/item/weapon/reagent_containers/food/snacks/hotdog = 10,
					/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato = 10,
					/obj/item/weapon/reagent_containers/food/snacks/margheritaslice = 10,
					/obj/item/weapon/reagent_containers/food/snacks/muffin = 10,
					/obj/item/weapon/reagent_containers/food/snacks/omelette = 10,
					/obj/item/weapon/reagent_containers/food/snacks/pastatomato = 10,
					/obj/item/weapon/reagent_containers/food/snacks/tofuburger = 10,
					/obj/item/weapon/reagent_containers/food/snacks/waffles = 10
					)
	contraband = list(/obj/item/weapon/reagent_containers/food/snacks/mysterysoup = 10)
	vend_delay = 15

/obj/item/weapon/paper/zoo
	name = "\improper Quarterly Report"
	info = {"<i>There's nothing but spreadsheets and budget reports on this document, apparently regarding a zoo owned by NanoTrasen.</i>"}

/obj/item/weapon/paper/zoo/pirate
	name = "odd note"

/obj/item/weapon/paper/zoo/pirate/volk
	info = {"Lady Nebula,<br><br>We can't keep these animals here permanently. We're running out of food and they're getting hungry.
			Ma'isi went missing last night when we sent her to clean up the petting zoo. This morning, we found Tajaran hair in the
			horse shit. I can't speak for everyone, but I'm out. If these animals break loose, we're all fucking dead. Please get
			some extra rations of meat before the carnivores realize the electrified grilles don't work right now.<br><br>-Volk"}

/obj/item/weapon/paper/zoo/pirate/nebula
	info = {"Volk,<br><br>Throw some prisoners into the cages, then. The client took too long to pay up anyway.<br><br>-Lady Nebula"}

/obj/item/weapon/paper/zoo/pirate/haveyouseen
	info = {"Has anyone seen Za'med? I sent him to get something out of the tool shed and he hasn't come back.<br><br>-Meesei"}

/obj/item/weapon/paper/zoo/pirate/warning
	info = {"Attention crew,<br><br>Since apparently you fucking idiots didn't notice, that bulltaur who delivered the bears was
			Jarome Rognvaldr. I'm sorry, maybe you scabs forgot? Does the name Jarome the Bottomless ring any fucking bells? If he's
			seen again without a laser bolt hole through his fucking skull, I'm shoving anyone on guard duty up Zed's arse. Are we
			clear?<br><br>-Lady Nebula"}