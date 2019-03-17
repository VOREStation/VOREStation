//Additional fusion reagents. These likely don't have any other use aside from the RUST, but if you want to make stuff with 'em, be my guest.

/datum/reagent/helium3
	name = "helium-3"
	description = "A colorless, odorless, tasteless and generally inert gas used in fusion reactors. Non-radioactive."
	id = "helium-3"
	reagent_state = GAS
	color = "#808080"

/obj/structure/reagent_dispensers/he3
	name = "fueltank"
	desc = "A fueltank."
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("helium-3",1000)