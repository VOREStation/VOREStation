
//Original Casino Code created by Shadowfire117#1269 - Ported from CHOMPstation
//Modified by GhostActual#2055 for use with VOREstation

/obj/machinery/chemical_dispenser/premium
	name = "premium drink dispensary"
	desc = "A specialty dispenser unit designed with Bluespace Technology."
	icon = 'icons/obj/casino.dmi'
	icon_state = "premiumdispenser"
	ui_title = "Premium Drink Dispensary"
	accept_drinking = 1
	var/max_cartridges = 90

/obj/machinery/chemical_dispenser/premium/full
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/lemon_lime,
			/obj/item/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/reagent_containers/chem_disp_cartridge/orange,
			/obj/item/reagent_containers/chem_disp_cartridge/lime,
			/obj/item/reagent_containers/chem_disp_cartridge/sodawater,
			/obj/item/reagent_containers/chem_disp_cartridge/tonic,
			/obj/item/reagent_containers/chem_disp_cartridge/beer,
			/obj/item/reagent_containers/chem_disp_cartridge/kahlua,
			/obj/item/reagent_containers/chem_disp_cartridge/whiskey,
			/obj/item/reagent_containers/chem_disp_cartridge/redwine,
			/obj/item/reagent_containers/chem_disp_cartridge/whitewine,
			/obj/item/reagent_containers/chem_disp_cartridge/vodka,
			/obj/item/reagent_containers/chem_disp_cartridge/gin,
			/obj/item/reagent_containers/chem_disp_cartridge/rum,
			/obj/item/reagent_containers/chem_disp_cartridge/tequila,
			/obj/item/reagent_containers/chem_disp_cartridge/vermouth,
			/obj/item/reagent_containers/chem_disp_cartridge/cognac,
			/obj/item/reagent_containers/chem_disp_cartridge/cider,
			/obj/item/reagent_containers/chem_disp_cartridge/ale,
			/obj/item/reagent_containers/chem_disp_cartridge/mead,
			/obj/item/reagent_containers/chem_disp_cartridge/water,
			/obj/item/reagent_containers/chem_disp_cartridge/ice,
			/obj/item/reagent_containers/chem_disp_cartridge/coffee,
			/obj/item/reagent_containers/chem_disp_cartridge/cream,
			/obj/item/reagent_containers/chem_disp_cartridge/tea,
			/obj/item/reagent_containers/chem_disp_cartridge/icetea,
			/obj/item/reagent_containers/chem_disp_cartridge/cola,
			/obj/item/reagent_containers/chem_disp_cartridge/smw,
			/obj/item/reagent_containers/chem_disp_cartridge/dr_gibb,
			/obj/item/reagent_containers/chem_disp_cartridge/spaceup,
			/obj/item/reagent_containers/chem_disp_cartridge/tonic,
			/obj/item/reagent_containers/chem_disp_cartridge/sodawater,
			/obj/item/reagent_containers/chem_disp_cartridge/lemon_lime,
			/obj/item/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/reagent_containers/chem_disp_cartridge/orange,
			/obj/item/reagent_containers/chem_disp_cartridge/lime,
			/obj/item/reagent_containers/chem_disp_cartridge/watermelon,
			/obj/item/reagent_containers/chem_disp_cartridge/lemon,
			/obj/item/reagent_containers/chem_disp_cartridge/coffee,
			/obj/item/reagent_containers/chem_disp_cartridge/cafe_latte,
			/obj/item/reagent_containers/chem_disp_cartridge/soy_latte,
			/obj/item/reagent_containers/chem_disp_cartridge/hot_coco,
			/obj/item/reagent_containers/chem_disp_cartridge/milk,
			/obj/item/reagent_containers/chem_disp_cartridge/cream,
			/obj/item/reagent_containers/chem_disp_cartridge/tea,
			/obj/item/reagent_containers/chem_disp_cartridge/ice,
			/obj/item/reagent_containers/chem_disp_cartridge/mint,
			/obj/item/reagent_containers/chem_disp_cartridge/orange,
			/obj/item/reagent_containers/chem_disp_cartridge/lemon,
			/obj/item/reagent_containers/chem_disp_cartridge/lime,
			/obj/item/reagent_containers/chem_disp_cartridge/berry,
			/obj/item/reagent_containers/chem_disp_cartridge/greentea,
			/obj/item/reagent_containers/chem_disp_cartridge/decaf
		)