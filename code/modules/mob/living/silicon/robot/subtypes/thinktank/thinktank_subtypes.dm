/mob/living/silicon/robot/platform/explorer
	name = "recon platform"
	desc = "A large quadrupedal AI platform, colloquially known as a 'think-tank' due to the flexible onboard intelligence. This one is lightly armoured and fitted with all-terrain wheels."
	modtype = "Recon"
	module = /obj/item/weapon/robot_module/robot/platform/explorer

/mob/living/silicon/robot/platform/explorer/Initialize()
	. = ..()
	laws = new /datum/ai_laws/explorer

/mob/living/silicon/robot/platform/explorer/welcome_client()
	..()
	if(client) // ganbatte tachikoma-san
		to_chat(src, SPAN_NOTICE("You are tasked with supporting the Exploration and Science staff as they unearth the secrets of the planet. Do your best!"))

/obj/effect/landmark/robot_platform/explorer
	platform_type = /mob/living/silicon/robot/platform/explorer

/mob/living/silicon/robot/platform/cargo
	name = "logistics platform"
	desc = "A large quadrupedal AI platform, colloquially known as a 'think-tank' due to the flexible onboard intelligence. This one has an expanded storage compartment."
	modtype = "Logistics"
	module = /obj/item/weapon/robot_module/robot/platform/cargo
	max_stored_atoms = 3

/mob/living/silicon/robot/platform/cargo/welcome_client()
	..()
	if(client)
		to_chat(src, SPAN_NOTICE("You are tasked with supporting the Cargo and Supply staff as they handle operational logistics. Do your best!"))

/obj/effect/landmark/robot_platform/cargo
	platform_type = /mob/living/silicon/robot/platform/cargo
