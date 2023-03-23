////////////////////////
// For sergals and stuff
////////////////////////
// Note: Creating a sub-datum to group all vore stuff together
// would require us to exclude that datum from the global list.

/datum/sprite_accessory/hair

	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN) //This lets all races use the default hairstyles.

/datum/sprite_accessory/hair/astolfo
	name = "Astolfo"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_astolfo"

/datum/sprite_accessory/hair/awoohair
	name = "Shoulder-length Messy"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "momijihair"

/datum/sprite_accessory/hair/citheronia
	name = "Citheronia Hair (Kira72)"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "citheronia_hair"
	ckeys_allowed = list("Kira72")
	do_colouration = 0

/datum/sprite_accessory/hair/taramaw
	name = "Hairmaw (Liquidfirefly)"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "maw_hair"
	ckeys_allowed = list("liquidfirefly")
	do_colouration = 0

/datum/sprite_accessory/hair/citheronia_colorable
	name = "Citheronia Hair"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "citheronia_hair_c"
	do_colouration = 1

/datum/sprite_accessory/hair/sergal_plain
	name = "Sergal Plain"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "serg_plain"
	species_allowed = list(SPECIES_SERGAL)

/datum/sprite_accessory/hair/sergal_medicore
	name = "Sergal Medicore"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "serg_medicore"
	species_allowed = list(SPECIES_SERGAL)

/datum/sprite_accessory/hair/sergal_tapered
	name = "Sergal Tapered"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "serg_tapered"
	species_allowed = list(SPECIES_SERGAL)

/datum/sprite_accessory/hair/sergal_fairytail
	name = "Sergal Fairytail"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "serg_fairytail"
	species_allowed = list(SPECIES_SERGAL)

/datum/sprite_accessory/hair/braid
	name = "Floorlength Braid"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_braid"

/datum/sprite_accessory/hair/twindrills
	name = "Twin Drills"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_twincurl"

/datum/sprite_accessory/hair/crescent_moon
	name = "Crescent-Moon"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "crescent_moon"

/datum/sprite_accessory/hair/bald
	name = "Bald"
	icon_state = "bald"
	gender = MALE
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN) //Lets all the races be bald if they want.

/datum/sprite_accessory/hair/ponytail6_fixed
	name = "Ponytail 6 but fixed"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_ponytail6"
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_NEVREAN, SPECIES_AKULA,SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)

/datum/sprite_accessory/hair/una_hood
	name = "Cobra Hood"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "soghun_hood"

/datum/sprite_accessory/hair/una_spines_long
	name = "Long Unathi Spines"
	icon_state = "soghun_longspines"
	species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN) //Xenochimera get most hairstyles since they're abominations.

/datum/sprite_accessory/hair/una_spines_short
	name = "Short Unathi Spines"
	icon_state = "soghun_shortspines"
	species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/una_frills_long
	name = "Long Unathi Frills"
	icon_state = "soghun_longfrills"
	species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/una_frills_short
	name = "Short Unathi Frills"
	icon_state = "soghun_shortfrills"
	species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/una_horns
	name = "Unathi Horns"
	icon_state = "soghun_horns"
	species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/una_bighorns
	name = "Unathi Big Horns"
	icon_state = "unathi_bighorn"
	species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/una_smallhorns
	name = "Unathi Small Horns"
	icon_state = "unathi_smallhorn"
	species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/una_ramhorns
	name = "Unathi Ram Horns"
	icon_state = "unathi_ramhorn"
	species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/una_sidefrills
	name = "Unathi Side Frills"
	icon_state = "unathi_sidefrills"
	species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/una_doublehorns
	name = "Double Unathi Horns"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "soghun_dubhorns"
	species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/una_quinthorns
	name = "Quintiple Unathi Horns"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "unathi_quintiple_horns"
	species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears
	name = "Tajaran Ears"
	icon_state = "ears_plain"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_clean
	name = "Tajara Clean"
	icon_state = "hair_clean"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_bangs
	name = "Tajara Bangs"
	icon_state = "hair_bangs"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_braid
	name = "Tajara Braid"
	icon_state = "hair_tbraid"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_shaggy
	name = "Tajara Shaggy"
	icon_state = "hair_shaggy"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_mohawk
	name = "Tajaran Mohawk"
	icon_state = "hair_mohawk"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_plait
	name = "Tajara Plait"
	icon_state = "hair_plait"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_straight
	name = "Tajara Straight"
	icon_state = "hair_straight"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_long
	name = "Tajara Long"
	icon_state = "hair_long"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_rattail
	name = "Tajara Rat Tail"
	icon_state = "hair_rattail"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_spiky
	name = "Tajara Spiky"
	icon_state = "hair_tajspiky"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_messy
	name = "Tajara Messy"
	icon_state = "hair_messy"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_curls
	name = "Tajaran Curly"
	icon_state = "hair_curly"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_wife
	name = "Tajaran Housewife"
	icon_state = "hair_wife"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_victory
	name = "Tajaran Victory Curls"
	icon_state = "hair_victory"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_bob
	name = "Tajaran Bob"
	icon_state = "hair_tbob"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj_ears_fingercurl
	name = "Tajaran Finger Curls"
	icon_state = "hair_fingerwave"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)


//Skrell 'hairstyles' - these were requested for a chimera and screw it, if one wants to eat seafood, go nuts
/datum/sprite_accessory/hair/skr_tentacle_veryshort
	name = "Skrell Very Short Tentacles"
	icon_state = "skrell_hair_veryshort"
	species_allowed = list(SPECIES_SKRELL, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
	gender = MALE

/datum/sprite_accessory/hair/skr_tentacle_short
	name = "Skrell Short Tentacles"
	icon_state = "skrell_hair_short"
	species_allowed = list(SPECIES_SKRELL, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/skr_tentacle_average
	name = "Skrell Average Tentacles"
	icon_state = "skrell_hair_average"
	species_allowed = list(SPECIES_SKRELL, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/skr_tentacle_verylong
	name = "Skrell Long Tentacles"
	icon_state = "skrell_hair_verylong"
	species_allowed = list(SPECIES_SKRELL, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
	gender = FEMALE

// Vulpa stuffs

/datum/sprite_accessory/hair/vulp_hair_none
	name = "None"
	icon_state = "bald"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_kajam
	name = "Kajam"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "kajam"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_keid
	name = "Keid"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "keid"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_adhara
	name = "Adhara"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "adhara"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_kleeia
	name = "Kleeia"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "kleeia"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_mizar
	name = "Mizar"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "mizar"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_apollo
	name = "Apollo"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "apollo"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_belle
	name = "Belle"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "belle"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_bun
	name = "Vulp Bun"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "bun"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_jagged
	name = "Jagged"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "jagged"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_curl
	name = "Curl"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "curl"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_hawk
	name = "Hawk"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hawk"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_anita
	name = "Anita"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "anita"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_short
	name = "Short"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "short"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_spike
	name = "Spike"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "spike"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

//xeno stuffs
/datum/sprite_accessory/hair/xeno_head_drone_color
	name = "Drone dome"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "cxeno_drone"
	species_allowed = list(SPECIES_XENOHYBRID)
	gender = NEUTER
// figure this one out for better coloring
/datum/sprite_accessory/hair/xeno_head_sentinel_color
	name = "Sentinal dome"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "cxeno_sentinel"
	species_allowed = list(SPECIES_XENOHYBRID)
	gender = NEUTER

/datum/sprite_accessory/hair/xeno_head_queen_color
	name = "Queen dome"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "cxeno_queen"
	species_allowed = list(SPECIES_XENOHYBRID)
	gender = NEUTER

/datum/sprite_accessory/hair/xeno_head_hunter_color
	name = "Hunter dome"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "cxeno_hunter"
	species_allowed = list(SPECIES_XENOHYBRID)
	gender = NEUTER

/datum/sprite_accessory/hair/xeno_head_praetorian_color
	name = "Praetorian dome"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "cxeno_praetorian"
	species_allowed = list(SPECIES_XENOHYBRID)
	gender = NEUTER

// Shadekin stuffs

/datum/sprite_accessory/hair/shadekin_hair_short
	name = "Shadekin Short Hair"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "shadekin_short"
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)
	gender = NEUTER

/datum/sprite_accessory/hair/shadekin_hair_poofy
	name = "Shadekin Poofy Hair"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "shadekin_poofy"
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)
	gender = NEUTER

/datum/sprite_accessory/hair/shadekin_hair_long
	name = "Shadekin Long Hair"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "shadekin_long"
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)
	gender = NEUTER

/datum/sprite_accessory/hair/shadekin_hair_rivyr
	name = "Rivyr Hair"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "shadekin_rivyr"
	ckeys_allowed = list("verysoft")
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)
	gender = NEUTER

/datum/sprite_accessory/hair/slicker
	name = "Slicker"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_slicker"

/datum/sprite_accessory/facial_hair
	icon = 'icons/mob/human_face_or_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN) //This lets all races use the facial hair styles.

/datum/sprite_accessory/facial_hair/shaved
	name = "Shaved"
	icon_state = "bald"
	gender = NEUTER
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN) //This needed to be manually defined, apparantly.

/datum/sprite_accessory/facial_hair/neck_fluff
	name = "Neck Fluff"
	icon = 'icons/mob/human_face_or_vr.dmi'
	icon_state = "facial_neckfluff"
	gender = NEUTER
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN)

/datum/sprite_accessory/facial_hair/vulp_none
	name = "None"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "none"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_blaze
	name = "Blaze"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_blaze"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_vulpine
	name = "Vulpine"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_vulpine"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_earfluff
	name = "Earfluff"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_earfluff"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_mask
	name = "Mask"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_mask"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_patch
	name = "Patch"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_patch"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_ruff
	name = "Ruff"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_ruff"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_kita
	name = "Kita"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_kita"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_swift
	name = "Swift"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_swift"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/*
////////////////////////////
/  =--------------------=  /
/  == Misc Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

// Yes, I have to add all of this just to make some glowy hair.
// No, this isn't a character creation option, but... I guess in the future it could be, if anyone wants that?

/datum/sprite_accessory/hair_accessory
	name = "You should not see this..."
	icon = 'icons/mob/vore/hair_accessories_vr.dmi'
	do_colouration = 0 // Set to 1 to blend (ICON_ADD) hair color

	var/ignores_lighting = 0 // Whether or not this hair accessory will ignore lighting and glow in the dark.
	color_blend_mode = ICON_ADD // Only appliciable if do_coloration = 1
	var/desc = "You should not see this..."

/datum/sprite_accessory/hair_accessory/verie_hair_glow
	name = "veries hair glow"
	desc = ""
	icon_state = "verie_hair_glow"
	ignores_lighting = 1
	//ckeys_allowed = list("vitoras") // This probably won't come into play EVER but better safe than sorry
