/datum/design_techweb/board/atm
	name = "atm circuit"
	desc = "The circuit board for a ATM."
	id = "bankmachine"
	build_path = /obj/item/circuitboard/atm
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/board/fax
	name = "fax machine circuit"
	desc = "The circuit board for a fax machine."
	id = "fax"
	build_path = /obj/item/circuitboard/fax
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/board/photocopier
	name = "photocopier circuit"
	desc = "The circuit board for a photocopier."
	id = "photocopier"
	build_path = /obj/item/circuitboard/photocopier
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/board/papershredder
	name = "papershredder circuit"
	desc = "The circuit board for a papershredder."
	id = "papershredder"
	build_path = /obj/item/circuitboard/papershredder
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/board/guest_pass
	name = "guestpass console Board"
	desc = "The circuit board for a guest pass console."
	id = "guestpass"
	build_path = /obj/item/circuitboard/guestpass
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/intercom
	name = "intercom circuit"
	desc = "The circuit board for a radio intercom."
	id = "intercom"
	build_type = AUTOLATHE | IMPRINTER // Simple circuit
	build_path = /obj/item/circuitboard/intercom
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/pda_cartridge/janitor
	id = "cart_janitor"
	build_path = /obj/item/cartridge/janitor
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ashtray
	name = "ashtray"
	desc = "An ashtray."
	id = "ashtray"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 250)
	build_path = /obj/item/material/ashtray
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/glasstray
	name = "glass ashtray"
	desc = "An shinier ashtray."
	id = "glasstray"
	build_type = PROTOLATHE
	materials = list(MAT_GLASS = 250)
	build_path = /obj/item/material/ashtray/glass
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE


// glasses
