var/list/lunchables_lunches_ = list(/obj/item/food/sandwich,
								/obj/item/food/slice/meatbread/filled,
								/obj/item/food/slice/tofubread/filled,
								/obj/item/food/slice/creamcheesebread/filled,
								/obj/item/food/slice/margherita/filled,
								/obj/item/food/slice/meatpizza/filled,
								/obj/item/food/slice/mushroompizza/filled,
								/obj/item/food/slice/vegetablepizza/filled,
								/obj/item/food/pineappleslice/filled,
								/obj/item/food/tastybread,
								/obj/item/food/bagelplain,
								/obj/item/food/bagelsunflower,
								/obj/item/food/bagelcheese,
								/obj/item/food/bagelraisin,
								/obj/item/food/bagelpoppy,
								/obj/item/food/croissant,
								/obj/item/food/corn_dog,
								/obj/item/food/liquidfood,
								/obj/item/food/liquidprotein,
								/obj/item/food/liquidvitamin,
								/obj/item/food/jellysandwich/cherry,
								/obj/item/food/tossedsalad,
								/obj/item/food/rosesalad,
								/obj/item/food/boiledegg,
								/obj/item/food/locust_cooked,
								/obj/item/food/spicedmeatbun,
								/obj/item/food/quicheslice/filled,
								/obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose,
								/obj/item/food/packaged/sausageroll,
								/obj/item/food/packaged/pasty,
								/obj/item/food/packaged/scotchegg,
								/obj/item/food/packaged/porkpie)

var/list/lunchables_snacks_ = list(/obj/item/food/donut/plain/jelly,
								/obj/item/food/donut/plain/jelly/cherryjelly,
								/obj/item/food/muffin,
								/obj/item/food/popcorn,
								/obj/item/food/sosjerky,
								/obj/item/food/unajerky,
								/obj/item/food/no_raisin,
								/obj/item/food/packaged/spacetwinkie,
								/obj/item/food/cheesiehonkers,
								/obj/item/food/poppypretzel,
								/obj/item/food/carrotfries,
								/obj/item/food/candiedapple,
								/obj/item/food/applepie,
								/obj/item/food/cherrypie,
								/obj/item/food/plumphelmetbiscuit,
								/obj/item/food/appletart,
								/obj/item/food/slice/carrotcake/filled,
								/obj/item/food/slice/cheesecake/filled,
								/obj/item/food/slice/plaincake/filled,
								/obj/item/food/slice/orangecake/filled,
								/obj/item/food/slice/limecake/filled,
								/obj/item/food/slice/lemoncake/filled,
								/obj/item/food/slice/chocolatecake/filled,
								/obj/item/food/slice/birthdaycake/filled,
								/obj/item/food/watermelonslice,
								/obj/item/food/slice/applecake/filled,
								/obj/item/food/slice/pumpkinpie/filled,
								/obj/item/food/keylimepieslice/filled,
								/obj/item/food/browniesslice/filled,
								/obj/item/food/skrellsnacks,
								/obj/item/food/mint/admints,
								/obj/item/food/roastedpeanuts,
								/obj/item/food/sugarcookie,
								/obj/item/food/eggroll,
								/obj/item/food/fruitsalad,
								/obj/item/food/honeybun,
								/obj/item/food/custardbun,
								/obj/item/food/honeytoast,
								/obj/item/food/cookie,
								/obj/item/food/fruitbar,
								/obj/item/food/semki,
								/obj/item/food/salo,
								/obj/item/food/weebonuts,
								/obj/item/food/ricecake,
								/obj/item/food/packaged/lunacake,
								/obj/item/food/packaged/darklunacake,
								/obj/item/food/packaged/mochicake,
								/obj/item/food/packaged/spacetwinkie,
								/obj/item/storage/box/jaffacake,
								/obj/item/storage/box/winegum,
								/obj/item/storage/box/custardcream,
								/obj/item/storage/box/bourbon
								)

var/list/lunchables_drinks_ = list(/obj/item/food/drinks/cans/cola,
								/obj/item/food/drinks/cans/waterbottle,
								/obj/item/food/drinks/cans/decaf_cola,
								/obj/item/food/drinks/cans/space_mountain_wind,
								/obj/item/food/drinks/cans/dr_gibb,
								/obj/item/food/drinks/cans/dr_gibb_diet,
								/obj/item/food/drinks/cans/starkist,
								/obj/item/food/drinks/cans/starkistdecaf,
								/obj/item/food/drinks/cans/space_up,
								/obj/item/food/drinks/cans/lemon_lime,
								/obj/item/food/drinks/cans/iced_tea,
								/obj/item/food/drinks/cans/grape_juice,
								/obj/item/food/drinks/cans/tonic,
								/obj/item/food/drinks/cans/sodawater,
								/obj/item/food/drinks/cans/gingerale,
								/obj/item/food/drinks/cans/root_beer,
								/obj/item/food/drinks/cans/sarsaparilla,
								/obj/item/food/drinks/cans/straw_cola,
								/obj/item/food/drinks/cans/apple_cola,
								/obj/item/food/drinks/cans/lemon_cola,
								/obj/item/food/drinks/cans/nukie_peach,
								/obj/item/food/drinks/cans/nukie_pear,
								/obj/item/food/drinks/cans/nukie_cherry,
								/obj/item/food/drinks/cans/nukie_melon,
								/obj/item/food/drinks/cans/nukie_banana,
								/obj/item/food/drinks/cans/nukie_rose,
								/obj/item/food/drinks/cans/nukie_lemon,
								/obj/item/food/drinks/cans/nukie_fruit
								)

// This default list is a bit different, it contains items we don't want
var/list/lunchables_drink_reagents_ = list(/datum/reagent/drink/nothing,
										/datum/reagent/drink/doctor_delight,
										/datum/reagent/drink/dry_ramen,
										/datum/reagent/drink/hell_ramen,
										/datum/reagent/drink/hot_ramen,
										/datum/reagent/drink/soda/nuka_cola,
										/datum/reagent/drink/coffee/nukie/mega,
										/datum/reagent/drink/coffee/nukie/mega/sight,
										/datum/reagent/drink/coffee/nukie/mega/heart,
										/datum/reagent/drink/coffee/nukie/mega/nega,
										/datum/reagent/drink/coffee/nukie/mega/shock,
										/datum/reagent/drink/coffee/nukie/mega/fast,
										/datum/reagent/drink/coffee/nukie/mega/high,
										/datum/reagent/drink/coffee/nukie/mega/shrink,
										/datum/reagent/drink/coffee/nukie/mega/grow)


// This default list is a bit different, it contains items we don't want
var/list/lunchables_ethanol_reagents_ = list(/datum/reagent/ethanol/acid_spit,
											/datum/reagent/ethanol/atomicbomb,
											/datum/reagent/ethanol/beepsky_smash,
											/datum/reagent/ethanol/coffee,
											/datum/reagent/ethanol/hippies_delight,
											/datum/reagent/ethanol/hooch,
											/datum/reagent/ethanol/thirteenloko,
											/datum/reagent/ethanol/manhattan_proj,
											/datum/reagent/ethanol/neurotoxin,
											/datum/reagent/ethanol/pwine,
											/datum/reagent/ethanol/threemileisland,
											/datum/reagent/ethanol/toxins_special,
											/datum/reagent/ethanol/voxdelight,
											/datum/reagent/ethanol/soemmerfire,
											/datum/reagent/ethanol/slimeshot)

/proc/lunchables_lunches()
	if(!(lunchables_lunches_[lunchables_lunches_[1]]))
		lunchables_lunches_ = init_lunchable_list(lunchables_lunches_)
	return lunchables_lunches_

/proc/lunchables_snacks()
	if(!(lunchables_snacks_[lunchables_snacks_[1]]))
		lunchables_snacks_ = init_lunchable_list(lunchables_snacks_)
	return lunchables_snacks_

/proc/lunchables_drinks()
	if(!(lunchables_drinks_[lunchables_drinks_[1]]))
		lunchables_drinks_ = init_lunchable_list(lunchables_drinks_)
	return lunchables_drinks_

/proc/lunchables_drink_reagents()
	if(!(lunchables_drink_reagents_[lunchables_drink_reagents_[1]]))
		lunchables_drink_reagents_ = init_lunchable_reagent_list(lunchables_drink_reagents_, /datum/reagent/drink)
	return lunchables_drink_reagents_

/proc/lunchables_ethanol_reagents()
	if(!(lunchables_ethanol_reagents_[lunchables_ethanol_reagents_[1]]))
		lunchables_ethanol_reagents_ = init_lunchable_reagent_list(lunchables_ethanol_reagents_, /datum/reagent/ethanol)
	return lunchables_ethanol_reagents_

/proc/init_lunchable_list(var/list/lunches)
	. = list()
	for(var/obj/O as anything in lunches)
		var/name = strip_improper(initial(O.name))
		.[name] = O
	return sortAssoc(.)

/proc/init_lunchable_reagent_list(var/list/banned_reagents, var/reagent_types)
	. = list()
	for(var/reagent_type in subtypesof(reagent_types))
		if(reagent_type in banned_reagents)
			continue
		var/datum/reagent/reagent = reagent_type
		.[initial(reagent.name)] = initial(reagent.id)
	return sortAssoc(.)
