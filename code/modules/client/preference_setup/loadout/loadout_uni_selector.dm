/*
/datum/gear/uniform_selector/BLANK
	display_name = "BLANK's Uniform Selector"
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
	"runner's turtleneck"=/obj/item/clothing/under/rank/neo_runner
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