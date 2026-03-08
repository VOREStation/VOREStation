/** This structure acts as a source of moisture loving cell lines,
as well as a location where a hidden item can sometimes be retrieved
at the cost of risking a vicious bite.**/
/obj/structure/moisture_trap
	name = "moisture trap"
	desc = "A device installed in order to control moisture in poorly ventilated areas.\nThe stagnant water inside basin seems to produce serious biofouling issues when improperly maintained.\nThis unit in particular seems to be teeming with life!\nWho thought mother Gaia could assert herself so vigorously in this sterile and desolate place?"
	icon_state = "moisture_trap"
	anchored = TRUE
	density = FALSE
	///This var stores the hidden item that might be able to be retrieved from the trap
	var/obj/item/hidden_item
	///This var determines if there is a chance to receive a bite when sticking your hand into the water.
//	var/critter_infested = TRUE
	///A subtle loop which plays a drop of water sound every once in a while
	var/datum/looping_sound/drip/drip_sfx
	///weighted loot table for what loot you can find inside the moisture trap.
	///the actual loot isn't that great and should probably be improved and expanded later.
	var/static/list/loot_table = list(
		/obj/item/reagent_containers/food/snacks/meat/human = 35,
		/obj/item/trash/raisins = 5,
		/obj/item/trash/candy/gums = 5,
		/obj/item/trash/chips = 5,
		/obj/item/bone/skull = 5,
		/obj/item/bone/skull/unathi = 5,
		/obj/item/handcuffs = 4,
		/obj/item/handcuffs/cable = 1,
		/obj/item/handcuffs/fuzzy = 1,
		/obj/item/handcuffs/cable/blue = 1,
		/obj/item/handcuffs/cable/green = 1,
		/obj/item/handcuffs/legcuffs = 2,
		/obj/item/coin/platinum = 10,
		/obj/item/material/knife = 5,
	)


/obj/structure/moisture_trap/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/fish_safe_storage)
//	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MOIST, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 20)
//	if(prob(40))
//		critter_infested = FALSE
	if(prob(75))
		var/picked_item = pick_weight(loot_table)
		hidden_item = new picked_item(src)

	var/datum/fish_source/moisture_trap/fish_source = new
	if(prob(50)) // 50% chance there's another item to fish out of there
		var/picked_item = pick_weight(loot_table)
		fish_source.fish_table[picked_item] = 5
		fish_source.fish_counts[picked_item] = 1;
	AddComponent(/datum/component/fishing_spot, fish_source)
