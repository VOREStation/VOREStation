/*
/datum/gear/uniform_selector/BLANK
	display_name = "DEPT - BLANK's Uniforms"
	description = "Select from a range of outfits available to all BLANK personnel."
	allowed_roles = list("")
	path =
	slot = slot_w_uniform
	sort_category = "Uniform Selectors"
	cost = 2

/datum/gear/uniform_selector/BLANK/New()
	..()
	var/list/selector_uniforms = list(
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))
*/

/datum/gear/uniform_selector/site_manager
	display_name = "Command - Site Manager's Uniforms"
	description = "Select from a range of outfits available to all Site Managers."
	allowed_roles = list("Site Manager")
	path = /obj/item/clothing/under/dress/dress_cap
	slot = slot_w_uniform
	sort_category = "Uniform Selectors"
	cost = 2

/datum/gear/uniform_selector/site_manager/New()
	..()
	var/list/selector_uniforms = list(
	"uniform w/ dress"=/obj/item/clothing/under/dress/dress_cap,
	"KHI uniform"=/obj/item/clothing/under/rank/khi/cmd,
	"ST: Original Series Command"=/obj/item/clothing/under/rank/trek/command,
	"ST: Next Generation Command"=/obj/item/clothing/under/rank/trek/command/next,
	"ST: Voyager Command"=/obj/item/clothing/under/rank/trek/command/voy,
	"ST: DS9 Command"=/obj/item/clothing/under/rank/trek/command/ds9,
	"ST: Enterprise Command"=/obj/item/clothing/under/rank/trek/command/ent,
	"voidsuit underlayer"=/obj/item/clothing/under/undersuit/command
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/uniform_selector/head_of_personnel
	display_name = "Command - Head of Personnel's Uniforms"
	description = "Select from a range of outfits available to all Heads of Personnel."
	allowed_roles = list("Head of Personnel")
	path = /obj/item/clothing/under/dress/dress_hop
	slot = slot_w_uniform
	sort_category = "Uniform Selectors"
	cost = 2

/datum/gear/uniform_selector/head_of_personnel/New()
	..()
	var/list/selector_uniforms = list(
	"uniform w/ dress"=/obj/item/clothing/under/dress/dress_hop,
	"HR director"=/obj/item/clothing/under/dress/dress_hr,
	"KHI uniform"=/obj/item/clothing/under/rank/khi/cmd,
	"ST: Original Series Command"=/obj/item/clothing/under/rank/trek/command,
	"ST: Next Generation Command"=/obj/item/clothing/under/rank/trek/command/next,
	"ST: Voyager Command"=/obj/item/clothing/under/rank/trek/command/voy,
	"ST: DS9 Command"=/obj/item/clothing/under/rank/trek/command/ds9,
	"ST: Enterprise Command"=/obj/item/clothing/under/rank/trek/command/ent,
	"voidsuit underlayer"=/obj/item/clothing/under/undersuit/command
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/uniform_selector/security
	display_name = "Security - Basic Uniforms"
	description = "Select from a range of outfits available to all Security personnel."
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")
	path = /obj/item/clothing/under/rank/security/corp
	slot = slot_w_uniform
	sort_category = "Uniform Selectors"
	cost = 2

/datum/gear/uniform_selector/security/New()
	..()
	var/list/selector_uniforms = list(
	"undersuit, modernized"=/obj/item/clothing/under/rank/security/modern,
	"KHI uniform"=/obj/item/clothing/under/rank/khi/sec,
	"voidsuit underlayer"=/obj/item/clothing/under/undersuit/sec,
	"skirt"=/obj/item/clothing/under/rank/security/skirt,
	"turtleneck"=/obj/item/clothing/under/rank/security/turtleneck,
	"corporate"=/obj/item/clothing/under/rank/security/corp,
	"navy blue"=/obj/item/clothing/under/rank/security/navyblue,
	"Proxima Centauri Risk Control"=/obj/item/clothing/under/corp/pcrc,
	"TG&C jumpsuit"=/obj/item/clothing/under/rank/neo_sec_red,
	"TG&C jumpskirt"=/obj/item/clothing/under/rank/neo_sec_red_skirt,
	"TG&C blue jumpsuit"=/obj/item/clothing/under/rank/neo_sec_blue,
	"TG&C white"=/obj/item/clothing/under/rank/neo_sec_suit,
	"TG&C blue"=/obj/item/clothing/under/rank/neo_sec_suit_blue,
	"TG&C turtleneck"=/obj/item/clothing/under/rank/neo_sec_turtle_red,
	"TG&C turtleneck & skirt"=/obj/item/clothing/under/rank/neo_sec_turtle_red_skirt,
	"TG&C blue turtleneck"=/obj/item/clothing/under/rank/neo_sec_turtle_blue,
	"TG&C blue turtleneck & skirt"=/obj/item/clothing/under/rank/neo_sec_turtle_blue_skirt,
	"corrections officer"=/obj/item/clothing/under/rank/neo_corrections,
	"corrections officer w/ skirt"=/obj/item/clothing/under/rank/neo_corrections_skirt,
	"runner's turtleneck"=/obj/item/clothing/under/rank/neo_runner,
	"ST: Original Series Ops"=/obj/item/clothing/under/rank/trek/engsec,
	"ST: Next Generation Ops"=/obj/item/clothing/under/rank/trek/engsec/next,
	"ST: Voyager Ops"=/obj/item/clothing/under/rank/trek/engsec/voy,
	"ST: DS9 Ops"=/obj/item/clothing/under/rank/trek/engsec/ds9,
	"ST: Enterprise Ops"=/obj/item/clothing/under/rank/trek/engsec/ent
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/uniform_selector/security_warden
	display_name = "Security - Warden's Uniforms"
	description = "Select from a range of outfits available to Wardens."
	allowed_roles = list("Head of Security","Warden")
	path = /obj/item/clothing/under/rank/warden/corp
	slot = slot_w_uniform
	sort_category = "Uniform Selectors"
	cost = 2

/datum/gear/uniform_selector/security_warden/New()
	..()
	var/list/selector_uniforms = list(
	"skirt"=/obj/item/clothing/under/rank/warden/skirt,
	"corporate"=/obj/item/clothing/under/rank/warden/corp,
	"navy blue"=/obj/item/clothing/under/rank/warden/navyblue,
	"TG&C jumpsuit"=/obj/item/clothing/under/rank/neo_warden_red,
	"TG&C jumpskirt"=/obj/item/clothing/under/rank/neo_warden_red_skirt,
	"TG&C blue jumpsuit"=/obj/item/clothing/under/rank/neo_warden_blue
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/uniform_selector/security_detective
	display_name = "Security - Detective's Uniforms"
	description = "Select from a range of outfits available to all Detectives."
	allowed_roles = list("Head of Security","Detective")
	path = /obj/item/clothing/under/det/corporate
	slot = slot_w_uniform
	sort_category = "Uniform Selectors"
	cost = 2

/datum/gear/uniform_selector/security_detective/New()
	..()
	var/list/selector_uniforms = list(
	"skirt"=/obj/item/clothing/under/det/skirt,
	"corporate"=/obj/item/clothing/under/det/corporate
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/uniform_selector/security_head
	display_name = "Security - Head's Uniforms"
	description = "Select from a range of outfits available to all Heads of Security."
	allowed_roles = list("Head of Security")
	path = /obj/item/clothing/under/rank/head_of_security/corp
	slot = slot_w_uniform
	sort_category = "Uniform Selectors"
	cost = 2

/datum/gear/uniform_selector/security_head/New()
	..()
	var/list/selector_uniforms = list(
	"skirt"=/obj/item/clothing/under/rank/head_of_security/skirt,
	"corporate"=/obj/item/clothing/under/rank/head_of_security/corp,
	"navy blue"=/obj/item/clothing/under/rank/head_of_security/navyblue,
	"voidsuit underlayer"=/obj/item/clothing/under/undersuit/sec/hos,
	"TG&C jumpsuit"=/obj/item/clothing/under/rank/neo_hos_red,
	"TG&C jumpskirt"=/obj/item/clothing/under/rank/neo_hos_red_skirt,
	"TG&C turtleneck"=/obj/item/clothing/under/rank/neo_hos_blackred,
	"TG&C turtleneck & skirt"=/obj/item/clothing/under/rank/neo_hos_blackred_skirt,
	"TG&C parade uniform"=/obj/item/clothing/under/rank/neo_hos_parade,
	"TG&C parade uniform, feminine"=/obj/item/clothing/under/rank/neo_hos_parade_fem,
	"TG&C blue"=/obj/item/clothing/under/rank/neo_hos_blue,
	"TG&C blue turtleneck"=/obj/item/clothing/under/rank/neo_hos_blackblue,
	"TG&C blue turtleneck & skirt"=/obj/item/clothing/under/rank/neo_hos_blackblue_skirt,
	"TG&C blue parade uniform"=/obj/item/clothing/under/rank/neo_hos_parade_blue,
	"TG&C blue parade uniform, feminine"=/obj/item/clothing/under/rank/neo_hos_parade_blue_fem
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/uniform_selector/quartermaster
	display_name = "Cargo - Quartermaster's Uniforms"
	description = "Select from a range of outfits available to all Quartermasters."
	allowed_roles = list("Quartermaster")
	path = /obj/item/clothing/under/rank/cargo/jeans
	slot = slot_w_uniform
	sort_category = "Uniform Selectors"
	cost = 2

/datum/gear/uniform_selector/quartermaster/New()
	..()
	var/list/selector_uniforms = list(
	"skirt"=/obj/item/clothing/under/rank/cargo/skirt,
	"jeans"=/obj/item/clothing/under/rank/cargo/jeans,
	"jeans, feminine cut"=/obj/item/clothing/under/rank/cargo/jeans/female,
	"KHI uniform"=/obj/item/clothing/under/rank/khi/crg,
	"TG&C jumpsuit"=/obj/item/clothing/under/rank/neo_qm,
	"TG&C jumpskirt"=/obj/item/clothing/under/rank/neo_qm_skirt,
	"TG&C casualwear"=/obj/item/clothing/under/rank/neo_qm_jacket,
	"TG&C button-up"=/obj/item/clothing/under/rank/neo_qm_white,
	"TG&C button-up w/ skirt"=/obj/item/clothing/under/rank/neo_qm_white_skirt,
	"TG&C turtleneck"=/obj/item/clothing/under/rank/neo_qm_turtle,
	"TG&C turtleneck w/ skirt"=/obj/item/clothing/under/rank/neo_qm_turtle_skirt,
	"TG&C gorka suit"=/obj/item/clothing/under/rank/neo_qm_gorka
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/uniform_selector/cargo_general
	display_name = "Cargo - Basic Uniforms"
	description = "Select from a range of outfits available to all Cargo personnel."
	allowed_roles = list("Cargo Technician","Shaft Miner","Quartermaster")
	path = /obj/item/clothing/under/rank/cargotech/jeans
	slot = slot_w_uniform
	sort_category = "Uniform Selectors"
	cost = 2

/datum/gear/uniform_selector/cargo_general/New()
	..()
	var/list/selector_uniforms = list(
	"skirt"=/obj/item/clothing/under/rank/cargotech/skirt,
	"jeans"=/obj/item/clothing/under/rank/cargotech/jeans,
	"jeans, feminine cut"=/obj/item/clothing/under/rank/cargotech/jeans/female,
	"KHI uniform"=/obj/item/clothing/under/rank/khi/crg,
	"TG&C shorts"=/obj/item/clothing/under/rank/neo_cargo_shorts,
	"TG&C skirt"=/obj/item/clothing/under/rank/neo_cargo_skirt,
	"TG&C miner's uniform"=/obj/item/clothing/under/rank/neo_miner,
	"TG&C hunter's uniform"=/obj/item/clothing/under/rank/neo_miner_fauna,
	"TG&C jumpsuit"=/obj/item/clothing/under/rank/neo_cargo,
	"TG&C utility uniform"=/obj/item/clothing/under/rank/neo_util_cargo,
	"TG&C dark"=/obj/item/clothing/under/rank/neo_cargo_dark,
	"TG&C casual"=/obj/item/clothing/under/rank/neo_cargo_casual,
	"TG&C turtleneck"=/obj/item/clothing/under/rank/neo_cargo_turtle,
	"TG&C turtleneck w/ skirt"=/obj/item/clothing/under/rank/neo_cargo_turtle_skirt,
	"TG&C gorka suit"=/obj/item/clothing/under/rank/neo_cargo_gorka,
	"customs officer"=/obj/item/clothing/under/rank/neo_cargo_customs
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))