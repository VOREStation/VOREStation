/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/

/datum/sprite_accessory

	var/icon			// the icon file the accessory is located in
	var/icon_state		// the icon_state of the accessory
	var/preview_state	// a custom preview state for whatever reason

	var/name = "ERROR - FIXME" // the preview name of the accessory

	// Determines if the accessory will be skipped or included in random hair generations
	var/gender = NEUTER

	// Restrict some styles to specific species. Set to null to perform no checking.
	var/list/species_allowed = list()

	// Whether or not the accessory can be affected by colouration
	var/do_colouration = 1

	var/color_blend_mode = ICON_MULTIPLY	// If checked.

	// Ckey of person allowed to use this, if defined.
	var/list/ckeys_allowed = null

	/// Should this sprite block emissives?
	var/em_block = FALSE

	var/list/hide_body_parts = list() //Uses organ tag defines. Bodyparts in this list do not have their icons rendered, allowing for more spriter freedom when doing taur/digitigrade stuff.

/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

/datum/sprite_accessory/hair
	icon = 'icons/mob/Human_face_m.dmi'	  // default icon for all hairs
	var/icon_add = 'icons/mob/human_face.dmi'
	var/flags

/datum/sprite_accessory/hair/eighties
	name = "80s"
	icon_state = "hair_80s"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/afro
	name = "Afro"
	icon_state = "hair_afro"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/afro2
	name = "Afro 2"
	icon_state = "hair_afro2"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/afro_large
	name = "Afro, Big"
	icon_state = "hair_bigafro"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/afropuffdouble
	name = "Afropuff, Double"
	icon_state = "hair_afropuffdouble"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/afropuffleft
	name = "Afropuff, Left"
	icon_state = "hair_afropuffleft"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/afropuffright
	name = "Afropuff, Right"
	icon_state = "hair_afropuffright"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/angelique
	name = "Angelique"
	icon_state = "hair_angelique"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/antonio
	name = "Antonio"
	icon_state = "hair_antonio"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/aradia
	name = "Aradia"
	icon_state = "hair_aradia"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/messyhair
	name = "All Up"
	icon_state = "hair_messyhair"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/amazon
	name = "Amazon"
	icon_state = "hair_amazon"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/antenna
	name = "Antenna"
	icon_state = "hair_antenna"

/datum/sprite_accessory/hair/astolfo
	name = "Astolfo"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "hair_astolfo"

/datum/sprite_accessory/hair/averagejoe
	name = "Average Joe"
	icon_state = "hair_averagejoe"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/bald
	name = "Bald"
	icon_state = "bald"
	flags = HAIR_VERY_SHORT
	species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_VOX,SPECIES_TESHARI)

/datum/sprite_accessory/hair/baldfade
	name = "Balding Fade"
	icon_state = "hair_baldfade"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/balding
	name = "Balding Hair"
	icon_state = "hair_e"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/band
	name = "Band"
	icon_state = "hair_band"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/beachwave
	name = "Beach Waves"
	icon_state = "hair_beachwave"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bedhead
	name = "Bedhead"
	icon_state = "hair_bedhead"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bedhead2
	name = "Bedhead 2"
	icon_state = "hair_bedheadv2"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bedhead3
	name = "Bedhead 3"
	icon_state = "hair_bedheadv3"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bedheadlong
	name = "Bedhead Long"
	icon_state = "hair_long_bedhead"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bedheadlongest
	name = "Bedhead Longest"
	icon_state = "hair_longest_bedhead"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/beehive
	name = "Beehive"
	icon_state = "hair_beehive"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/beehive2
	name = "Beehive 2"
	icon_state = "hair_beehive2"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bieber
	name = "Bieber"
	icon_state = "hair_bieb"

/datum/sprite_accessory/hair/belenko
	name = "Belenko"
	icon_state = "hair_belenko"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/belenkotied
	name = "Belenko Tied"
	icon_state = "hair_belenkotied"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bigcurls
	name = "Big Curls"
	icon_state = "hair_bigcurls"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bob
	name = "Bob"
	icon_state = "hair_bobcut"
	species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bobcutalt
	name = "Bob Chin Length"
	icon_state = "hair_bobcutalt"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/midb
	name = "Bob, Mid-length"
	icon_state = "hair_midb"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bobcurl
	name = "Bobcurl"
	icon_state = "hair_bobcurl"
	species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bowl
	name = "Bowl"
	icon_state = "hair_bowlcut"

/datum/sprite_accessory/hair/bowlcut2
	name = "Bowl 2"
	icon_state = "hair_bowlcut2"

/datum/sprite_accessory/hair/bowlcut2
	name = "Bowl, Overeye"
	icon_state = "hair_overeyebowl"

/datum/sprite_accessory/hair/grandebraid
	name = "Braid Grande"
	icon_state = "hair_grande"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/braid2
	name = "Braid Long"
	icon_state = "hair_hbraid"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/longbraid
	name = "Braid Long, Alt"
	icon_state = "hair_longbraid"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/longbraidalt
	name = "Braid Long, Alt 2"
	icon_state = "hair_braidalt"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/mbraid
	name = "Braid Medium"
	icon_state = "hair_shortbraid"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/braid
	name = "Braid Floorlength"
	icon_state = "hair_braid"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/front_braid
	name = "Braided front"
	icon_state = "hair_braidfront"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/braidtail
	name = "Braided Tail"
	icon_state = "hair_braidtail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bun
	name = "Bun"
	icon_state = "hair_bun"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bun2
	name = "Bun 2"
	icon_state = "hair_bun2"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bun3
	name = "Bun 3"
	icon_state = "hair_bun3"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/bunhead
	name = "Bun Head "
	icon_state = "hair_bunhead"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/doublebun
	name = "Bun Double"
	icon_state = "hair_doublebun"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/tightbun
	name = "Bun Tight"
	icon_state = "hair_tightbun"
	flags = HAIR_VERY_SHORT | HAIR_TIEABLE

/datum/sprite_accessory/hair/business
	name = "Business Hair"
	icon_state = "hair_business"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/business2
	name = "Business Hair 2"
	icon_state = "hair_business2"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/business3
	name = "Business Hair 3"
	icon_state = "hair_business3"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/business4
	name = "Business Hair 4"
	icon_state = "hair_business4"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/buzz
	name = "Buzzcut"
	icon_state = "hair_buzzcut"
	flags = HAIR_VERY_SHORT
	species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)

/datum/sprite_accessory/hair/celebcurls
	name = "Celeb Curls"
	icon_state = "hair_celebcurls"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/citheronia_colorable
	name = "Citheronia"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "citheronia_hair_c"
	do_colouration = 1

/datum/sprite_accessory/hair/crono
	name = "Chrono"
	icon_state = "hair_toriyama"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/cia
	name = "CIA"
	icon_state = "hair_cia"

/datum/sprite_accessory/hair/coffeehouse
	name = "Coffee House Cut"
	icon_state = "hair_coffeehouse"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/combover
	name = "Combover"
	icon_state = "hair_combover"

/datum/sprite_accessory/hair/cornbun
	name = "Cornbun"
	icon_state = "hair_cornbun"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/country
	name = "Country"
	icon_state = "hair_country"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/crew
	name = "Crewcut"
	icon_state = "hair_crewcut"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/curls
	name = "Curls"
	icon_state = "hair_curls"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/cut
	name = "Cut Hair"
	icon_state = "hair_c"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/darcy
	name = "Darcy"
	icon_state = "hair_darcy"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/dave
	name = "Dave"
	icon_state = "hair_dave"

/datum/sprite_accessory/hair/devillock
	name = "Devil Lock"
	icon_state = "hair_devilock"

/datum/sprite_accessory/hair/dirk
	name = "Dirk"
	icon_state = "hair_dirk"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/donutbun
	name = "Donut Bun"
	icon_state = "hair_donutbun"

/datum/sprite_accessory/hair/dreadlocks
	name = "Dreadlocks"
	icon_state = "hair_dreads"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/dreadslong
	name = "Dreads Long"
	icon_state = "hair_dreadslong"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/dreadslongalt
	name = "Dreads Long, Alt"
	icon_state = "hair_dreadlongalt"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/mahdrills
	name = "Drillruru"
	icon_state = "hair_drillruru"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/elize
	name = "Elize"
	icon_state = "hair_elize"

/datum/sprite_accessory/hair/emo
	name = "Emo"
	icon_state = "hair_emo"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/emo2
	name = "Emo Alt"
	icon_state = "hair_emo2"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/fringeemo
	name = "Emo Fringe"
	icon_state = "hair_emofringe"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/halfshaved
	name = "Emo Half-Shaved"
	icon_state = "hair_halfshaved"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/halfshavedlong
	name = "Emo Half-Shaved Long"
	icon_state = "hair_halfshavedL"

/datum/sprite_accessory/hair/emoright
	name = "Emo Mid-length"
	icon_state = "hair_emoright"

/datum/sprite_accessory/hair/longemo
	name = "Emo Long"
	icon_state = "hair_emolong"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/equius
	name = "Equius"
	icon_state = "hair_equius"

/datum/sprite_accessory/hair/fabio
	name = "Fabio"
	icon_state = "hair_fabio"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/highfade
	name = "Fade High"
	icon_state = "hair_highfade"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/medfade
	name = "Fade Medium"
	icon_state = "hair_medfade"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/lowfade
	name = "Fade Low"
	icon_state = "hair_lowfade"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/partfade
	name = "Fade Parted"
	icon_state = "hair_shavedpart"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/familyman
	name = "Family Man"
	icon_state = "hair_thefamilyman"

/datum/sprite_accessory/hair/father
	name = "Father"
	icon_state = "hair_father"

/datum/sprite_accessory/hair/feather
	name = "Feather"
	icon_state = "hair_feather"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/feferi
	name = "Feferi"
	icon_state = "hair_feferi"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/flair
	name = "Flaired Hair"
	icon_state = "hair_flair"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/flipped
	name = "Flipped"
	icon_state = "hair_flipped"

/datum/sprite_accessory/hair/sargeant
	name = "Flat Top"
	icon_state = "hair_sargeant"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/braid
	name = "Floorlength Braid"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "hair_braid"

/datum/sprite_accessory/hair/flowhair
	name = "Flow Hair"
	icon_state = "hair_f"

/datum/sprite_accessory/hair/longfringe
	name = "Fringe Long"
	icon_state = "hair_longfringe"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/longestalt
	name = "Fringe Longer"
	icon_state = "hair_vlongfringe"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/fringetail
	name = "Fringetail"
	icon_state = "hair_fringetail"
	flags = HAIR_TIEABLE|HAIR_VERY_SHORT

/datum/sprite_accessory/hair/froofy_long
	name = "Froofy Long"
	icon_state = "hair_froofy_long"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/gamzee
	name = "Gamzee"
	icon_state = "hair_gamzee"

/datum/sprite_accessory/hair/gelled
	name = "Gelled Back"
	icon_state = "hair_gelled"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/gentle
	name = "Gentle"
	icon_state = "hair_gentle"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/gentle2
	name = "Gentle 2, Long"
	icon_state = "hair_gentle2long"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/glammetal
	name = "Glam Metal Long"
	icon_state = "hair_glammetal"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/glossy
	name = "Glossy"
	icon_state = "hair_glossy"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/halfbang
	name = "Half-banged Hair"
	icon_state = "hair_halfbang"

/datum/sprite_accessory/hair/halfbangalt
	name = "Half-banged Hair Alt"
	icon_state = "hair_halfbang_alt"

/datum/sprite_accessory/hair/hightight
	name = "High and Tight"
	icon_state = "hair_hightight"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/himecut
	name = "Hime Cut"
	icon_state = "hair_himecut"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/himeup
	name = "Hime Updo"
	icon_state = "hair_himeup"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/shorthime
	name = "Hime Cut Short"
	icon_state = "hair_shorthime"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/hitop
	name = "Hitop"
	icon_state = "hair_hitop"

/datum/sprite_accessory/hair/jade
	name = "Jade"
	icon_state = "hair_jade"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/jane
	name = "Jane"
	icon_state = "hair_jane"

/datum/sprite_accessory/hair/jensen
	name = "Jensen"
	icon_state = "hair_jensen"

/datum/sprite_accessory/hair/jessica
	name = "Jessica"
	icon_state = "hair_jessica"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/joestar
	name = "Joestar"
	icon_state = "hair_joestar"

/datum/sprite_accessory/hair/judge
	name = "Judge"
	icon_state = "hair_judge"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/kagami
	name = "Kagami"
	icon_state = "hair_kagami"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/kanaya
	name = "Kanaya"
	icon_state = "hair_kanaya"

/datum/sprite_accessory/hair/keanu
	name = "Keanu Hair"
	icon_state = "hair_keanu"

/datum/sprite_accessory/hair/kusangi
	name = "Kusanagi Hair"
	icon_state = "hair_kusanagi"

/datum/sprite_accessory/hair/long
	name = "Long Hair Shoulder-length"
	icon_state = "hair_b"
	flags = HAIR_TIEABLE
/*
/datum/sprite_accessory/hair/longish
	name = "Longer Hair"
	icon_state = "hair_b2"
	flags = HAIR_TIEABLE
*/

/datum/sprite_accessory/hair/longer
	name = "Long Hair"
	icon_state = "hair_vlong"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/longeralt2
	name = "Long Hair Alt 2"
	icon_state = "hair_longeralt2"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sidepartlongalt
	name = "Long Side Part"
	icon_state = "hair_longsidepart"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/longest
	name = "Very Long Hair"
	icon_state = "hair_longest"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/lowbraid
	name = "Low Braid"
	icon_state = "hair_hbraid"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/manbun
	name = "Manbun"
	icon_state = "hair_manbun"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/marysue
	name = "Mary Sue"
	icon_state = "hair_marysue"

/datum/sprite_accessory/hair/mia
	name = "Mia"
	icon_state = "hair_mia"

/datum/sprite_accessory/hair/mialong
	name = "Mia Long"
	icon_state = "hair_mialong"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/miles
	name = "Miles Hair"
	icon_state = "hair_miles"

/datum/sprite_accessory/hair/modern
	name = "Modern"
	icon_state = "hair_modern"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/mohawk
	name = "Mohawk"
	icon_state = "hair_d"
	species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)

/datum/sprite_accessory/hair/regulationmohawk
	name = "Mohawk Regulation"
	icon_state = "hair_shavedmohawk"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/reversemohawk
	name = "Mohawk Reverse"
	icon_state = "hair_reversemohawk"

/datum/sprite_accessory/hair/mohawkunshaven
	name = "Mohawk Unshaven"
	icon_state = "hair_unshaven_mohawk"

/datum/sprite_accessory/hair/mulder
	name = "Mulder"
	icon_state = "hair_mulder"

/datum/sprite_accessory/hair/nepeta
	name = "Nepeta"
	icon_state = "hair_nepeta"

/datum/sprite_accessory/hair/newyou
	name = "New You"
	icon_state = "hair_newyou"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/nia
	name = "Nia"
	icon_state = "hair_nia"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/nitori
	name = "Nitori"
	icon_state = "hair_nitori"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/odango
	name = "Odango"
	icon_state = "hair_odango"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ombre
	name = "Ombre"
	icon_state = "hair_ombre"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/oxton
	name = "Oxton"
	icon_state = "hair_oxton"

/datum/sprite_accessory/hair/longovereye
	name = "Overeye Long"
	icon_state = "hair_longovereye"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/shortovereye
	name = "Overeye Short"
	icon_state = "hair_shortovereye"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/veryshortovereyealternate
	name = "Overeye Very Short, Alternate"
	icon_state = "hair_veryshortovereyealternate"

/datum/sprite_accessory/hair/veryshortovereye
	name = "Overeye Very Short"
	icon_state = "hair_veryshortovereye"

/datum/sprite_accessory/hair/parted
	name = "Parted"
	icon_state = "hair_parted"

/datum/sprite_accessory/hair/partedalt
	name = "Parted Alt"
	icon_state = "hair_partedalt"


/datum/sprite_accessory/hair/pixie
	name = "Pixie Cut"
	icon_state = "hair_pixie"

/datum/sprite_accessory/hair/pompadour
	name = "Pompadour"
	icon_state = "hair_pompadour"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/dandypomp
	name = "Pompadour Dandy"
	icon_state = "hair_dandypompadour"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ponytail1
	name = "Ponytail 1"
	icon_state = "hair_ponytail"
	flags = HAIR_TIEABLE|HAIR_VERY_SHORT

/datum/sprite_accessory/hair/ponytail2
	name = "Ponytail 2"
	icon_state = "hair_pa"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ponytail3
	name = "Ponytail 3"
	icon_state = "hair_ponytail3"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ponytail4
	name = "Ponytail 4"
	icon_state = "hair_ponytail4"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ponytail5
	name = "Ponytail 5"
	icon_state = "hair_ponytail5"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ponytail6
	name = "Ponytail 6"
	icon_state = "hair_ponytail6"
	flags = HAIR_TIEABLE|HAIR_VERY_SHORT

/datum/sprite_accessory/hair/sharpponytail
	name = "Ponytail Sharp"
	icon_state = "hair_sharpponytail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/spikyponytail
	name = "Ponytail Spiky"
	icon_state = "hair_spikyponytail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/poofy
	name = "Poofy"
	icon_state = "hair_poofy"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/poofy2
	name = "Poofy 2"
	icon_state = "hair_poofy2"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/proper
	name = "Proper"
	icon_state = "hair_proper"

/datum/sprite_accessory/hair/quiff
	name = "Quiff"
	icon_state = "hair_quiff"

/datum/sprite_accessory/hair/nofade
	name = "Regulation Cut"
	icon_state = "hair_nofade"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/newyou
	name = "New You"
	icon_state = "hair_newyou"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rockandroll
	name = "Rock and Roll"
	icon_state = "hair_rockandroll"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rockstarcurls
	name = "Rockstar Curls"
	icon_state = "hair_rockstarcurls"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/ronin
	name = "Ronin"
	icon_state = "hair_ronin"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rosa
	name = "Rosa"
	icon_state = "hair_rosa"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rose
	name = "Rose"
	icon_state = "hair_rose"

/datum/sprite_accessory/hair/rows
	name = "Rows"
	icon_state = "hair_rows1"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/rows2
	name = "Rows 2"
	icon_state = "hair_rows2"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rowbun
	name = "Row Bun"
	icon_state = "hair_rowbun"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rowdualbraid
	name = "Row Dual Braid"
	icon_state = "hair_rowdualtail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/rowbraid
	name = "Row Braid"
	icon_state = "hair_rowbraid"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/roxy
	name = "Roxy"
	icon_state = "hair_roxy"

/datum/sprite_accessory/hair/sabitsuki
	name = "Sabitsuki"
	icon_state = "hair_sabitsuki"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/scully
	name = "Scully"
	icon_state = "hair_scully"

/datum/sprite_accessory/hair/shavehair
	name = "Shaved Hair"
	icon_state = "hair_shaved"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/shortbangs
	name = "Short Bangs"
	icon_state = "hair_shortbangs"

/datum/sprite_accessory/hair/shortflip
	name = "Short Flip"
	icon_state = "hair_shortflip"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/short
	name = "Short Hair"	  // try to capatilize the names please~
	icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/short2
	name = "Short Hair 2"
	icon_state = "hair_shorthair3"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/short3
	name = "Short Hair 3"
	icon_state = "hair_shorthair4"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/awoohair
	name = "Shoulder-length Messy"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "momijihair"

/datum/sprite_accessory/hair/shy
	name = "Shy"
	icon_state = "hair_shy"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sideponytail
	name = "Side Ponytail"
	icon_state = "hair_stail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sideponytail4 //Not happy about this... but it's for the save files.
	name = "Side Ponytail 2"
	icon_state = "hair_ponytailf"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sideponytail5
	name = "Side Ponytail 3"
	icon_state = "hair_sidetail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sideponytail6
	name = "Side Ponytail 4"
	icon_state = "hair_sidetail2"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sideponytail2
	name = "Shoulder One"
	icon_state = "hair_oneshoulder"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sideponytail3
	name = "Shoulder Tress"
	icon_state = "hair_tressshoulder"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/sideundercut
	name = "Side Undercut"
	icon_state = "hair_sideundercut"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/skinhead
	name = "Skinhead"
	icon_state = "hair_skinhead"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/sleeze
	name = "Sleeze"
	icon_state = "hair_sleeze"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/protagonist
	name = "Slightly Long"
	icon_state = "hair_protagonist"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/spiky
	name = "Spiky"
	icon_state = "hair_spikey"
	species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)

/datum/sprite_accessory/hair/straightlong
	name = "Straight Long"
	icon_state = "hair_straightlong"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/suave
	name = "Suave"
	icon_state = "hair_suave"

/datum/sprite_accessory/hair/suavetwo
	name = "Suave 2"
	icon_state = "hair_suave2"

/datum/sprite_accessory/hair/sweepshave
	name = "Sweep Shave"
	icon_state = "hair_sweepshave"

/datum/sprite_accessory/hair/sweptfringe
	name = "Swept Fringe"
	icon_state = "hair_sweptfringe"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/terezi
	name = "Terezi"
	icon_state = "hair_terezi"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/thinning
	name = "Thinning"
	icon_state = "hair_thinning"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/thinningfront
	name = "Thinning Front"
	icon_state = "hair_thinningfront"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/thinningback
	name = "Thinning Back"
	icon_state = "hair_thinningrear"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/topknot
	name = "Topknot"
	icon_state = "hair_topknot"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/trimflat
	name = "Trimmed Flat Top"
	icon_state = "hair_trimflat"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/trimmed
	name = "Trimmed"
	icon_state = "hair_trimmed"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/twindrills
	name = "Twin Drills"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "hair_twincurl"

/datum/sprite_accessory/hair/twintail
	name = "Twintail"
	icon_state = "hair_twintail"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/twinbob
	name = "Twinbun Bob"
	icon_state = "hair_bunbob"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/undercut1
	name = "Undercut"
	icon_state = "hair_undercut1"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/undercut2
	name = "Undercut Swept Right"
	icon_state = "hair_undercut2"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/undercut3
	name = "Undercut Swept Left"
	icon_state = "hair_undercut3"
	gender = MALE
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/longundercut
	name = "Undercut Long"
	icon_state = "hair_undercutlong"
	flags = HAIR_VERY_SHORT

/datum/sprite_accessory/hair/unkept
	name = "Unkept"
	icon_state = "hair_unkept"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/updo
	name = "Updo"
	icon_state = "hair_updo"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/vegeta
	name = "Vegeta"
	icon_state = "hair_toriyama2"

/datum/sprite_accessory/hair/vriska
	name = "Vriska"
	icon_state = "hair_vriska"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/vivi
	name = "Vivi"
	icon_state = "hair_vivi"

/datum/sprite_accessory/hair/volaju
	name = "Volaju"
	icon_state = "hair_volaju"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/wisp
	name = "Wisp"
	icon_state = "hair_wisp"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/zieglertail
	name = "Zieglertail"
	icon_state = "hair_ziegler"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/zone
	name = "Zone Braid"
	icon_state = "hair_zone"
	flags = HAIR_TIEABLE

/datum/sprite_accessory/hair/una_hood
	name = "Cobra Hood"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "soghun_hood"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/una_doublehorns
	name = "Double Unathi Horns"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "soghun_dubhorns"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/sergal_plain
	name = "Sergal Plain"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "serg_plain"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/sergal_medicore
	name = "Sergal Medicore"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "serg_medicore"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/sergal_tapered
	name = "Sergal Tapered"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "serg_tapered"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/sergal_fairytail
	name = "Sergal Fairytail"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "serg_fairytail"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

// Vulpa stuffs

/datum/sprite_accessory/hair/vulp_hair_none
	name = "None"
	icon_state = "bald"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_kajam
	name = "Kajam"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "kajam"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_keid
	name = "Keid"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "keid"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_adhara
	name = "Adhara"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "adhara"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_kleeia
	name = "Kleeia"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "kleeia"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_mizar
	name = "Mizar"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "mizar"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_apollo
	name = "Apollo"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "apollo"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_belle
	name = "Belle"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "belle"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_bun
	name = "Vulp Bun"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "bun"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_jagged
	name = "Jagged"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "jagged"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_curl
	name = "Curl"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "curl"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_hawk
	name = "Hawk"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "hawk"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_anita
	name = "Anita"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "anita"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_short
	name = "Short"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "short"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_spike
	name = "Spike"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "spike"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

//xeno stuffs
/datum/sprite_accessory/hair/xeno_head_drone_color
	name = "Drone dome"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "cxeno_drone"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER
// figure this one out for better coloring
/datum/sprite_accessory/hair/xeno_head_sentinel_color
	name = "Sentinal dome"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "cxeno_sentinel"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/xeno_head_queen_color
	name = "Queen dome"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "cxeno_queen"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/xeno_head_hunter_color
	name = "Hunter dome"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "cxeno_hunter"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/xeno_head_praetorian_color
	name = "Praetorian dome"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "cxeno_praetorian"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

// Shadekin stuffs

/datum/sprite_accessory/hair/shadekin_hair_short
	name = "Shadekin Short Hair"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "shadekin_short"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/shadekin_hair_poofy
	name = "Shadekin Poofy Hair"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "shadekin_poofy"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/shadekin_hair_long
	name = "Shadekin Long Hair"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_add = 'icons/mob/human_face_alt_add.dmi'
	icon_state = "shadekin_long"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/*
shaved
	name = "Shaved"
	icon_state = "bald"
	gender = NEUTER
	species_allowed = list(SPECIES_HUMAN, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
*/
/datum/sprite_accessory/facial_hair/neck_fluff
	name = "Neck Fluff"
	icon = 'icons/mob/human_face_or_alt.dmi'
	icon_state = "facial_neckfluff"
	gender = NEUTER
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/facial_hair/vulp_none
	name = "None"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_state = "none"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/facial_hair/vulp_blaze
	name = "Blaze"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_state = "vulp_facial_blaze"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/facial_hair/vulp_vulpine
	name = "Vulpine"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_state = "vulp_facial_vulpine"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/facial_hair/vulp_earfluff
	name = "Earfluff"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_state = "vulp_facial_earfluff"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/facial_hair/vulp_mask
	name = "Mask"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_state = "vulp_facial_mask"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/facial_hair/vulp_patch
	name = "Patch"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_state = "vulp_facial_patch"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/facial_hair/vulp_ruff
	name = "Ruff"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_state = "vulp_facial_ruff"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/facial_hair/vulp_kita
	name = "Kita"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_state = "vulp_facial_kita"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/facial_hair/vulp_swift
	name = "Swift"
	icon = 'icons/mob/human_face_alt.dmi'
	icon_state = "vulp_facial_swift"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER
	color_blend_mode = ICON_MULTIPLY

/*
///////////////////////////////////
/  =---------------------------=  /
/  == Facial Hair Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/facial_hair
	icon = 'icons/mob/Human_face.dmi'
	color_blend_mode = ICON_ADD
	em_block = TRUE

/datum/sprite_accessory/facial_hair/shaved
	name = "Shaved"
	icon_state = "bald"
	gender = NEUTER
	species_allowed = list(SPECIES_HUMAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI,SPECIES_TAJ,SPECIES_SKRELL, "Machine", SPECIES_TESHARI, SPECIES_TESHARI,SPECIES_PROMETHEAN)

/datum/sprite_accessory/facial_hair/watson
	name = "Watson Mustache"
	icon_state = "facial_watson"

/datum/sprite_accessory/facial_hair/hogan
	name = "Hulk Hogan Mustache"
	icon_state = "facial_hogan" //-Neek

/datum/sprite_accessory/facial_hair/vandyke
	name = "Van Dyke Mustache"
	icon_state = "facial_vandyke"

/datum/sprite_accessory/facial_hair/chaplin
	name = "Square Mustache"
	icon_state = "facial_chaplin"

/datum/sprite_accessory/facial_hair/selleck
	name = "Selleck Mustache"
	icon_state = "facial_selleck"

/datum/sprite_accessory/facial_hair/neckbeard
	name = "Neckbeard"
	icon_state = "facial_neckbeard"

/datum/sprite_accessory/facial_hair/fullbeard
	name = "Full Beard"
	icon_state = "facial_fullbeard"

/datum/sprite_accessory/facial_hair/longbeard
	name = "Long Beard"
	icon_state = "facial_longbeard"

/datum/sprite_accessory/facial_hair/vlongbeard
	name = "Very Long Beard"
	icon_state = "facial_wise"

/datum/sprite_accessory/facial_hair/elvis
	name = "Elvis Sideburns"
	icon_state = "facial_elvis"
	species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)

/datum/sprite_accessory/facial_hair/abe
	name = "Abraham Lincoln Beard"
	icon_state = "facial_abe"

/datum/sprite_accessory/facial_hair/chinstrap
	name = "Chinstrap"
	icon_state = "facial_chin"

/datum/sprite_accessory/facial_hair/hip
	name = "Hipster Beard"
	icon_state = "facial_hip"

/datum/sprite_accessory/facial_hair/gt
	name = "Goatee"
	icon_state = "facial_gt"

/datum/sprite_accessory/facial_hair/jensen
	name = "Adam Jensen Beard"
	icon_state = "facial_jensen"

/datum/sprite_accessory/facial_hair/volaju
	name = "Volaju"
	icon_state = "facial_volaju"

/datum/sprite_accessory/facial_hair/dwarf
	name = "Dwarf Beard"
	icon_state = "facial_dwarf"

/datum/sprite_accessory/facial_hair/threeOclock
	name = "3 O-clock Shadow"
	icon_state = "facial_3oclock"

/datum/sprite_accessory/facial_hair/threeOclockstache
	name = "3 O-clock Shadow and Moustache"
	icon_state = "facial_3oclockmoustache"

/datum/sprite_accessory/facial_hair/fiveOclock
	name = "5 O-clock Shadow"
	icon_state = "facial_5oclock"

/datum/sprite_accessory/facial_hair/fiveOclockstache
	name = "5 O-clock Shadow and Moustache"
	icon_state = "facial_5oclockmoustache"

/datum/sprite_accessory/facial_hair/sevenOclock
	name = "7 O-clock Shadow"
	icon_state = "facial_7oclock"

/datum/sprite_accessory/facial_hair/sevenOclockstache
	name = "7 O-clock Shadow and Moustache"
	icon_state = "facial_7oclockmoustache"

/datum/sprite_accessory/facial_hair/mutton
	name = "Mutton Chops"
	icon_state = "facial_mutton"

/datum/sprite_accessory/facial_hair/muttonstache
	name = "Mutton Chops and Moustache"
	icon_state = "facial_muttonmus"

/datum/sprite_accessory/facial_hair/walrus
	name = "Walrus Moustache"
	icon_state = "facial_walrus"

/datum/sprite_accessory/facial_hair/croppedbeard
	name = "Full Cropped Beard"
	icon_state = "facial_croppedfullbeard"

/datum/sprite_accessory/facial_hair/chinless
	name = "Chinless Beard"
	icon_state = "facial_chinlessbeard"

/datum/sprite_accessory/facial_hair/tribeard
	name = "Tribeard"
	icon_state = "facial_tribeard"

/datum/sprite_accessory/facial_hair/moonshiner
	name = "Moonshiner"
	icon_state = "facial_moonshiner"

/datum/sprite_accessory/facial_hair/martial
	name = "Martial Artist"
	icon_state = "facial_martialartist"
/*
///////////////////////////////////
/  =---------------------------=  /
/  == Alien Style Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

//Unathi Head-Bits

/datum/sprite_accessory/hair/una
	name = "Long Unathi Spines"
	icon_state = "soghun_longspines"
	species_allowed = list(SPECIES_UNATHI)

/datum/sprite_accessory/hair/una/spines_short
	name = "Short Unathi Spines"

/datum/sprite_accessory/hair/una/frills_long
	name = "Long Unathi Frills"
	icon_state = "soghun_longfrills"

/datum/sprite_accessory/hair/una/frills_short
	name = "Short Unathi Frills"
	icon_state = "soghun_shortfrills"

/datum/sprite_accessory/hair/una/horns
	name = "Unathi Horns"
	icon_state = "soghun_horns"

/datum/sprite_accessory/hair/una/bighorns
	name = "Unathi Big Horns"
	icon_state = "unathi_bighorn"

/datum/sprite_accessory/hair/una/smallhorns
	name = "Unathi Small Horns"
	icon_state = "unathi_smallhorn"

/datum/sprite_accessory/hair/una/ramhorns
	name = "Unathi Ram Horns"
	icon_state = "unathi_ramhorn"

/datum/sprite_accessory/hair/una/sidefrills
	name = "Unathi Side Frills"
	icon_state = "unathi_sidefrills"

//Skrell 'hairstyles'

/datum/sprite_accessory/hair/skr
	name = "Tentacles, Average"
	icon_state = "skrell_short"
	species_allowed = list(SPECIES_SKRELL, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/skr/pullback
	name = "Tentacles, Average, Pullback"
	icon_state = "skrell_short_pullback"

/datum/sprite_accessory/hair/skr/very_short
	name = "Tentacles, Short"
	icon_state = "skrell_very_short"

/datum/sprite_accessory/hair/skr/long
	name = "Tentacles, Long"
	icon_state = "skrell_long"

/datum/sprite_accessory/hair/skr/long/pullback
	name = "Tentacles, Long, Pullback"
	icon_state = "skrell_long_pullback"

/datum/sprite_accessory/hair/skr/long/scarf
	name = "Tentacles, Long, Scarf"
	icon_state = "skrell_long_scarf"

/datum/sprite_accessory/hair/skr/long/wavy
	name = "Tentacles, Long, Wavy"
	icon_state = "skrell_long_wavy"

/datum/sprite_accessory/hair/skr/very_long
	name = "Tentacles, Very Long"
	icon_state = "skrell_very_long"

/datum/sprite_accessory/hair/skr/very_long/pullback
	name = "Tentacles, Very Long, Pullback"
	icon_state = "skrell_very_long_pullback"

/datum/sprite_accessory/hair/skr/very_long/scarf
	name = "Tentacles, Very Long, Scarf"
	icon_state = "skrell_very_long_scarf"

/datum/sprite_accessory/hair/skr/very_long/wavy
	name = "Tentacles, Very Long, Wavy"
	icon_state = "skrell_very_long_wavy"

//Tajaran hairstyles
/datum/sprite_accessory/hair/taj
	name = "Tajaran Ears"
	icon_state = "ears_plain"
	species_allowed = list(SPECIES_TAJ)

/datum/sprite_accessory/hair/taj/bangs
	name = "Tajaran Bangs"
	icon_state = "hair_bangs"

/datum/sprite_accessory/hair/taj/bangs_alt
	name = "Tajaran Bangs (Alt)"
	icon_state = "hair_bangs_alt"

/datum/sprite_accessory/hair/taj/short_fringe
	name = "Tajaran Short Fringe"
	icon_state = "hair_shortfringe"

/datum/sprite_accessory/hair/taj/braid
	name = "Tajaran Braid"
	icon_state = "hair_tbraid"

/datum/sprite_accessory/hair/taj/clean
	name = "Tajaran Clean"
	icon_state = "hair_clean"

/datum/sprite_accessory/hair/taj/gman
	name = "Tajaran G-Man"
	icon_state = "hair_gman"

/datum/sprite_accessory/hair/taj/greaser
	name = "Tajaran Greaser"
	icon_state = "hair_greaser"

/datum/sprite_accessory/hair/taj/bun
	name = "Tajaran Bun"
	icon_state = "hair_tajbun"

/datum/sprite_accessory/hair/taj/bunsmall
	name = "Tajaran Bun (Small)"
	icon_state = "hair_tajsmallbun"

/datum/sprite_accessory/hair/taj/bunlow
	name = "Tajaran Bun (Low)"
	icon_state = "hair_tajbunlow"

/datum/sprite_accessory/hair/taj/bunlowsmall
	name = "Tajaran Bun (Low, Small)"
	icon_state = "hair_tajbunlowsmall"

/datum/sprite_accessory/hair/taj/_wedge
	name = "Tajaran Wedge"
	icon_state = "hair_wedge"

/datum/sprite_accessory/hair/taj/shaggy
	name = "Tajaran Shaggy"
	icon_state = "hair_shaggy"

/datum/sprite_accessory/hair/taj/mohawk
	name = "Tajaran Mohawk"
	icon_state = "hair_mohawk"

/datum/sprite_accessory/hair/taj/plait
	name = "Tajaran Plait"
	icon_state = "hair_plait"

/datum/sprite_accessory/hair/taj/_sidepony
	name = "Tajaran Side Ponytail"
	icon_state = "hair_sidepony"

/datum/sprite_accessory/hair/taj/straight
	name = "Tajaran Straight"
	icon_state = "hair_straight"

/datum/sprite_accessory/hair/taj/long
	name = "Tajaran Long"
	icon_state = "hair_long"

/datum/sprite_accessory/hair/taj/tresses
	name = "Tajaran Tresses"
	icon_state = "hair_tresses"

/datum/sprite_accessory/hair/taj/shoulderparted
	name = "Tajaran Shoulder Parted"
	icon_state = "hair_shoulderparted"

/datum/sprite_accessory/hair/taj/shoulderpartedsmall
	name = "Tajaran Shoulder Parted (Small)"
	icon_state = "hair_shoulderpartedsmall"

/datum/sprite_accessory/hair/taj/shoulderpartedlong
	name = "Tajaran Shoulder Parted (Long)"
	icon_state = "hair_shoulderpartedlong"

/datum/sprite_accessory/hair/taj/sidepartedleft
	name = "Tajaran Side Parted (Left)"
	icon_state = "hair_sidepartedleft"

/datum/sprite_accessory/hair/taj/sidepartedright
	name = "Tajaran Side Parted (Right)"
	icon_state = "hair_sidepartedright"

/datum/sprite_accessory/hair/taj/shoulderlength
	name = "Tajaran Shoulder Length"
	icon_state = "hair_shoulderlength"

/datum/sprite_accessory/hair/taj/shoulderlengthalt
	name = "Tajaran Shoulder Length (Alt)"
	icon_state = "hair_shoulderlengthalt"

/datum/sprite_accessory/hair/taj/cascading
	name = "Tajaran Cascading"
	icon_state = "hair_cascading"

/datum/sprite_accessory/hair/taj/cascadingalt
	name = "Tajaran Cascading (Alt)"
	icon_state = "hair_cascadingalt"

/datum/sprite_accessory/hair/taj/rattail
	name = "Tajaran Rat Tail"
	icon_state = "hair_rattail"

/datum/sprite_accessory/hair/taj/spiky
	name = "Tajaran Spiky"
	icon_state = "hair_tajspiky"

/datum/sprite_accessory/hair/taj/fringeup
	name = "Tajaran Fringe Spike"
	icon_state = "hair_fringeup"

/datum/sprite_accessory/hair/taj/messy
	name = "Tajaran Messy"
	icon_state = "hair_messy"

/datum/sprite_accessory/hair/taj/curls
	name = "Tajaran Curly"
	icon_state = "hair_curly"

/datum/sprite_accessory/hair/taj/curlsalt
	name = "Tajaran Curly, alt"
	icon_state = "hair_curlyalt"

/datum/sprite_accessory/hair/taj/mane
	name = "Tajaran Mane"
	icon_state = "hair_mane"

/datum/sprite_accessory/hair/taj/wife
	name = "Tajaran Housewife"
	icon_state = "hair_wife"

/datum/sprite_accessory/hair/taj/victory
	name = "Tajaran Victory Curls"
	icon_state = "hair_victory"

/datum/sprite_accessory/hair/taj/bob
	name = "Tajaran Bob"
	icon_state = "hair_tbob"
/datum/sprite_accessory/hair/taj/fingercurl
	name = "Tajaran Finger Curls"
	icon_state = "hair_fingerwave"

//Teshari things
/datum/sprite_accessory/hair/teshari
	name = "Teshari Default"
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "teshari_default"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/hair/teshari/altdefault
	name = "Teshari Alt. Default"
	icon_state = "teshari_ears"

/datum/sprite_accessory/hair/teshari/tight
	name = "Teshari Tight"
	icon_state = "teshari_tight"

/datum/sprite_accessory/hair/teshari/excited
	name = "Teshari Spiky"
	icon_state = "teshari_spiky"

/datum/sprite_accessory/hair/teshari/spike
	name = "Teshari Spike"
	icon_state = "teshari_spike"

/datum/sprite_accessory/hair/teshari/long
	name = "Teshari Overgrown"
	icon_state = "teshari_long"

/datum/sprite_accessory/hair/teshari/burst
	name = "Teshari Starburst"
	icon_state = "teshari_burst"

/datum/sprite_accessory/hair/teshari/shortburst
	name = "Teshari Short Starburst"
	icon_state = "teshari_burst_short"

/datum/sprite_accessory/hair/teshari/mohawk
	name = "Teshari Mohawk"
	icon_state = "teshari_mohawk"

/datum/sprite_accessory/hair/teshari/pointy
	name = "Teshari Pointy"
	icon_state = "teshari_pointy"

/datum/sprite_accessory/hair/teshari/upright
	name = "Teshari Upright"
	icon_state = "teshari_upright"

/datum/sprite_accessory/hair/teshari/mane
	name = "Teshari Mane"
	icon_state = "teshari_mane"

/datum/sprite_accessory/hair/teshari/droopy
	name = "Teshari Droopy"
	icon_state = "teshari_droopy"

/datum/sprite_accessory/hair/teshari/mushroom
	name = "Teshari Mushroom"
	icon_state = "teshari_mushroom"

/datum/sprite_accessory/hair/teshari/twies
	name = "Teshari Twies"
	icon_state = "teshari_twies"

/datum/sprite_accessory/hair/teshari/backstrafe
	name = "Teshari Backstrafe"
	icon_state = "teshari_backstrafe"

/datum/sprite_accessory/hair/teshari/_longway
	name = "Teshari Long way"
	icon_state = "teshari_longway"

/datum/sprite_accessory/hair/teshari/tree
	name = "Teshari Tree"
	icon_state = "teshari_tree"

/datum/sprite_accessory/hair/teshari/fluffymohawk
	name = "Teshari Fluffy Mohawk"
	icon_state = "teshari_fluffymohawk"

// Vox things
/datum/sprite_accessory/hair/vox
	name = "Long Vox braid"
	icon_state = "vox_longbraid"
	species_allowed = list(SPECIES_VOX)

/datum/sprite_accessory/hair/vox/braid_short
	name = "Short Vox Braid"
	icon_state = "vox_shortbraid"

/datum/sprite_accessory/hair/vox/quills_short
	name = "Short Vox Quills"
	icon_state = "vox_shortquills"

/datum/sprite_accessory/hair/vox/quills_kingly
	name = "Kingly Vox Quills"
	icon_state = "vox_kingly"

/datum/sprite_accessory/hair/vox/quills_mohawk
	name = "Quill Mohawk"
	icon_state = "vox_mohawk"

//Tajaran Facial Hair

/datum/sprite_accessory/facial_hair/taj
	name = "Tajaran Sideburns"
	icon_state = "facial_sideburns"
	species_allowed = list(SPECIES_TAJ)

/datum/sprite_accessory/facial_hair/taj/mutton
	name = "Tajaran Mutton"
	icon_state = "facial_mutton"

/datum/sprite_accessory/facial_hair/taj/pencilstache
	name = "Tajaran Pencilstache"
	icon_state = "facial_pencilstache"

/datum/sprite_accessory/facial_hair/taj/moustache
	name = "Tajaran Moustache"
	icon_state = "facial_moustache"

/datum/sprite_accessory/facial_hair/taj/goatee
	name = "Tajaran Goatee"
	icon_state = "facial_goatee"

/datum/sprite_accessory/facial_hair/taj/smallstache
	name = "Tajaran Smallsatche"
	icon_state = "facial_smallstache"

//unathi horn beards and the like

/datum/sprite_accessory/facial_hair/una
	name = "Unathi Chin Horn"
	icon_state = "facial_chinhorns"
	species_allowed = list(SPECIES_UNATHI)

/datum/sprite_accessory/facial_hair/una/hornadorns
	name = "Unathi Horn Adorns"
	icon_state = "facial_hornadorns"

/datum/sprite_accessory/facial_hair/una/spinespikes
	name = "Unathi Spine Spikes"
	icon_state = "facial_spikes"

/datum/sprite_accessory/facial_hair/una/dorsalfrill
	name = "Unathi Dorsal Frill"
	icon_state = "facial_dorsalfrill"


//Teshari face things
/datum/sprite_accessory/facial_hair/teshari
	name = "Teshari Beard"
	icon_state = "teshari_chin"
	species_allowed = list(SPECIES_TESHARI)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/teshari/scraggly
	name = "Teshari Scraggly"
	icon_state = "teshari_scraggly"


/datum/sprite_accessory/facial_hair/teshari/chops
	name = "Teshari Chops"
	icon_state = "teshari_gap"

/*
////////////////////////////
/  =--------------------=  /
/  ==  Body Markings   ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/marking
	icon = 'icons/mob/human_races/markings.dmi'
	do_colouration = 1 //Almost all of them have it, COLOR_ADD

	//Empty list is unrestricted. Should only restrict the ones that make NO SENSE on other species,
	//like Tajaran inner-ear coloring overlay stuff.
	species_allowed = list()
	//This lets all races use

	color_blend_mode = ICON_ADD

	var/genetic = TRUE
	var/organ_override = FALSE
	var/body_parts = list() //A list of bodyparts this covers, in organ_tag defines
	//Reminder: BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD

//Vox Exclusives
/datum/sprite_accessory/marking/vox
	icon = 'icons/mob/human_races/markings_vox.dmi'
	species_allowed = list(SPECIES_VOX)

/datum/sprite_accessory/marking/vox/voxbeak
	name = "Vox Beak (Normal)"
	icon_state = "vox_beak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vox/voxtalons
	name = "Vox scales"
	icon_state = "vox_talons"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_ARM,BP_L_ARM,BP_R_HAND,BP_L_HAND,BP_R_LEG,BP_L_LEG,BP_R_FOOT,BP_L_FOOT)

/datum/sprite_accessory/marking/vox/voxclaws
	name = "Vox Claws"
	icon_state = "Voxclaws"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vox/vox_alt
	name = "Vox Alternate"
	icon_state = "bay_vox"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)

/datum/sprite_accessory/marking/vox/vox_alt_eyes
	name = "Alternate Vox Eyes"
	icon_state = "bay_vox_eyes"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vox/voxscales
	name = "Alternate Vox scales"
	icon_state = "Voxscales"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_ARM,BP_L_ARM,BP_R_HAND,BP_L_HAND,BP_R_LEG,BP_L_LEG,BP_R_FOOT,BP_L_FOOT)

//Tattoos

/datum/sprite_accessory/marking/tat_rheart
	name = "Tattoo (Heart, R. Arm)"
	icon_state = "tat_rheart"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tat_lheart
	name = "Tattoo (Heart, L. Arm)"
	icon_state = "tat_lheart"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/tat_hive
	name = "Tattoo (Hive, Back)"
	icon_state = "tat_hive"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/tat_nightling
	name = "Tattoo (Nightling, Back)"
	icon_state = "tat_nightling"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/tat_campbell
	name = "Tattoo (Campbell, R.Arm)"
	icon_state = "tat_campbell"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tat_campbell/left
	name = "Tattoo (Campbell, L.Arm)"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/tat_campbell/rightleg
	name = "Tattoo (Campbell, R.Leg)"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/tat_campbell/leftleg
	name = "Tattoo (Campbell, L.Leg)"
	body_parts = list (BP_L_LEG)

/datum/sprite_accessory/marking/tat_silverburgh
	name = "Tattoo (Silverburgh, R.Leg)"
	icon_state = "tat_silverburgh"
	body_parts = list (BP_R_LEG)

/datum/sprite_accessory/marking/tat_silverburgh/left
	name = "Tattoo (Silverburgh, L.Leg)"
	icon_state = "tat_silverburgh"
	body_parts = list (BP_L_LEG)

/datum/sprite_accessory/marking/tat_tiger
	name = "Tattoo (Tiger Stripes, Body)"
	icon_state = "tat_tiger"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)

//New tats

/datum/sprite_accessory/marking/tat_belly
	name = "Tattoo (Belly)"
	icon_state = "tat_belly"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/tat_forrest_left
	name = "Tattoo (Forrest, Left Eye)"
	icon_state = "tat_forrest_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_forrest_right
	name = "Tattoo (Forrest, Right Eye)"
	icon_state = "tat_forrest_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_hunter_left
	name = "Tattoo (Hunter, Left Eye)"
	icon_state = "tat_hunter_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_hunter_right
	name = "Tattoo (Hunter, Right Eye)"
	icon_state = "tat_hunter_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_jaeger_left
	name = "Tattoo (Jaeger, Left Eye)"
	icon_state = "tat_jaeger_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_jaeger_right
	name = "Tattoo (Jaeger, Right Eye)"
	icon_state = "tat_jaeger_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_kater_left
	name = "Tattoo (Kater, Left Eye)"
	icon_state = "tat_kater_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_kater_right
	name = "Tattoo (Kater, Right Eye)"
	icon_state = "tat_kater_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_lujan_left
	name = "Tattoo (Lujan, Left Eye)"
	icon_state = "tat_lujan_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_lujan_right
	name = "Tattoo (Lujan, Right Eye)"
	icon_state = "tat_lujan_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_montana_left
	name = "Tattoo (Montana, Left Face)"
	icon_state = "tat_montana_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_montana_right
	name = "Tattoo (Montana, Right Face)"
	icon_state = "tat_montana_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_natasha_left
	name = "Tattoo (Natasha, Left Eye)"
	icon_state = "tat_natasha_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_natasha_right
	name = "Tattoo (Natasha, Right Eye)"
	icon_state = "tat_natasha_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_tamoko
	name = "Tattoo (Ta Moko, Face)"
	icon_state = "tat_tamoko"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_toshi_left
	name = "Tattoo (Toshi, Left Eye)"
	icon_state = "tat_toshi_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_toshi_right
	name = "Tattoo (Volgin, Right Eye)"
	icon_state = "tat_toshi_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_wings_back
	name = "Tattoo (Wings, Lower Back)"
	icon_state = "tat_wingsback"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/tilaka
	name = "Tilaka"
	icon_state = "tilaka"
	body_parts = list(BP_HEAD)


/datum/sprite_accessory/marking/bands
	name = "Color Bands"
	icon_state = "bands"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/bandsface
	name = "Color Bands (Face)"
	icon_state = "bandsface"
	body_parts = list(BP_HEAD)
	//species_allowed = list(SPECIES_TAJ,SPECIES_UNATHI)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/bandsface_human
	name = "Color Bands (Face)"
	icon_state = "bandshumanface"
	body_parts = list(BP_HEAD)
	//species_allowed = list(SPECIES_HUMAN,SPECIES_HUMAN_VATBORN,SPECIES_SKRELL)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/tiger_stripes
	name = "Tiger Stripes"
	icon_state = "tiger"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_GROIN)
	//species_allowed = list(SPECIES_TAJ) 			//Removing Polaris whitelits	//There's a tattoo for non-cats

/datum/sprite_accessory/marking/tigerhead
	name = "Tiger Stripes (Head, Minor)"
	icon_state = "tigerhead"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tigerface
	name = "Tiger Stripes (Head, Major)"
	icon_state = "tigerface"
	body_parts = list(BP_HEAD)
	//species_allowed = list(SPECIES_TAJ)			//Removing Polaris whitelits //There's a tattoo for non-cats

/datum/sprite_accessory/marking/backstripe
	name = "Back Stripe"
	icon_state = "backstripe"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/bindi
	name = "Bindi"
	icon_state = "bindi"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/blush
	name = "Blush"
	icon_state= "blush"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/bridge
	name = "Bridge"
	icon_state = "bridge"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/brow_left
	name = "Brow Left"
	icon_state = "brow_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/brow_left/teshari
	name = "Brow Left (Teshari)"
	icon_state = "brow_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/brow_right
	name = "Brow Right"
	icon_state = "brow_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/brow_right/teshari
	name = "Brow Right (Teshari)"
	icon_state = "brow_r_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/cheekspot_left
	name = "Cheek Spot (Left Cheek)"
	icon_state = "cheekspot_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/cheekspot_right
	name = "Cheek Spot (Right Cheek)"
	icon_state = "cheekspot_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/cheshire_left
	name = "Cheshire (Left Cheek)"
	icon_state = "cheshire_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/cheshire_right
	name = "Cheshire (Right Cheek)"
	icon_state = "cheshire_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/eyestripe
	name = "Eye Stripe"
	icon_state = "eyestripe"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/eyestripe/teshari
	name = "Eye Stripe (Teshari)"
	icon_state = "eyestripe_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/eyecorner_left
	name = "Eye Corner Left"
	icon_state = "eyecorner_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/eyecorner_left/teshari
	name = "Eye Corner Left (Teshari)"
	icon_state = "eyecorner_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/eyecorner_right
	name = "Eye Corner Right"
	icon_state = "eyecorner_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/eyecorner_right/teshari
	name = "Eye Corner Right (Teshari)"
	icon_state = "eyecorner_r_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/fullfacepaint
	name = "Full Face Paint"
	icon_state = "fullface"
	body_parts = list(BP_HEAD)
	//species_allowed = list(SPECIES_HUMAN,SPECIES_HUMAN_VATBORN,SPECIES_SKRELL)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/lips
	name = "Lips"
	icon_state = "lips"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/lowercheek_left
	name = "Lower Cheek Left"
	icon_state = "lowercheek_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/lowercheek_left
	name = "Lower Cheek Right"
	icon_state = "lowercheek_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/neck
	name = "Neck Cover"
	icon_state = "neck"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/neckthick
	name = "Neck Cover (Thick)"
	icon_state = "neckthick"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/nosestripe
	name = "Nose Stripe"
	icon_state = "nosestripe"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/nosestripe/teshari
	name = "Nose Stripe (Teshari)"
	icon_state = "nosestripe_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/nosetape
	name = "Nose Tape"
	icon_state = "nosetape"
	body_parts = list(BP_HEAD)
	genetic = FALSE

/datum/sprite_accessory/marking/nosetape/tesh
	name = "Nose Tape (Teshari)"
	icon_state = "nosetape_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_abdomen_left
	name = "Scar, Abdomen Left"
	icon_state = "scar_abdomen_l"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_abdomen_left/teshari
	name = "Scar, Abdomen Left (Teshari)"
	icon_state = "scar_abdomen_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_abdomen_right
	name = "Scar, Abdomen Right"
	icon_state = "scar_abdomen_r"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_abdomen_right/teshari
	name = "Scar, Abdomen Right (Teshari)"
	icon_state = "scar_abdomen_r_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_abdomen_small_left
	name = "Scar, Abdomen Small Left"
	icon_state = "scar_abdomensmall_l"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_abdomen_small_left/teshari
	name = "Scar, Abdomen Small Left (Teshari)"
	icon_state = "scar_abdomensmall_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_abdomen_small_right
	name = "Scar, Abdomen Small Right"
	icon_state = "scar_abdomensmall_r"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_abdomen_small_right/teshari
	name = "Scar, Abdomen Small Right (Teshari)"
	icon_state = "scar_abdomensmall_r_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_back_large
	name = "Scar, Back Large"
	icon_state = "scar_back_large"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_back_large/teshari
	name = "Scar, Back Large (Teshari)"
	icon_state = "scar_back_large_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_back_small
	name = "Scar, Back Small (Center)"
	icon_state = "scar_back_small"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_back_small/teshari
	name = "Scar, Back Small (Center)(Teshari)"
	icon_state = "scar_back_small_tesh"
	species_allowed = list(SPECIES_TESHARI)
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_back_small_upper_right
	name = "Scar, Back Small (Upper Right)"
	icon_state = "scar_back_small_ur"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_back_small_upper_left
	name = "Scar, Back Small (Upper Left)"
	icon_state = "scar_back_small_ul"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_back_small_lower_right
	name = "Scar, Back Small (Lower Right)"
	icon_state = "scar_back_small_lr"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_back_small_lower_left
	name = "Scar, Back Small (Lower Left)"
	icon_state = "scar_back_small_ll"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_chest_large_left
	name = "Scar, Chest Large (Left)"
	icon_state = "scar_chest_large_l"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_chest_large_left/teshari
	name = "Scar, Chest Large (Left)(Teshari)"
	icon_state = "scar_chest_large_l_tesh"
	species_allowed = list(SPECIES_TESHARI)
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_chest_large_right
	name = "Scar, Chest Large (Right)"
	icon_state = "scar_chest_large_r"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_chest_large_right/teshari
	name = "Scar, Chest Large (Right)(Teshari)"
	icon_state = "scar_chest_large_r_tesh"
	species_allowed = list(SPECIES_TESHARI)
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_chest_small_left
	name = "Scar, Chest Small (Left)"
	icon_state = "scar_chest_small_l"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_chest_small_left/teshari
	name = "Scar, Chest Small (Left)(Teshari)"
	icon_state = "scar_chest_small_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_chest_small_right
	name = "Scar, Chest Small (Right)"
	icon_state = "scar_chest_small_r"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_chest_small_right/teshari
	name = "Scar, Chest Small (Right)(Teshari)"
	icon_state = "scar_chest_small_r_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_belly
	name = "Scar, Belly"
	icon_state = "scar_belly"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_belly/teshari
	name = "Scar, Belly (Teshari)"
	icon_state = "scar_belly_tesh"
	species_allowed = list(SPECIES_TESHARI)
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_cheek_left
	name = "Scar, Cheek (Left)"
	icon_state = "scar_cheek_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_cheek_right
	name = "Scar, Cheek (Right)"
	icon_state = "scar_cheek_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_forehead_left
	name = "Scar, Forehead (Left)"
	icon_state = "scar_forehead_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_forehead_left/teshari
	name = "Scar, Forehead (Left)(Teshari)"
	icon_state = "scar_forehead_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_forehead_right
	name = "Scar, Forehead (Right)"
	icon_state = "scar_forehead_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_forehead_right/teshari
	name = "Scar, Forehead (Right)(Teshari)"
	icon_state = "scar_forehead_r_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_chin
	name = "Scar, Chin"
	icon_state = "scar_chin"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_muzzle_teshari
	name = "Scar, Muzzle"
	icon_state = "scar_muzzle_tesh"
	species_allowed = list(SPECIES_TESHARI)
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_eye_left
	name = "Scar, Over Eye (Left)"
	icon_state = "scar_eye_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_eye_left/teshari
	name = "Scar, Over Eye (Left)(Teshari)"
	icon_state = "scar_eye_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_eye_right
	name = "Scar, Over Eye (Right)"
	icon_state = "scar_eye_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_eye_right/teshari
	name = "Scar, Over Eye (Right)(Teshari)"
	icon_state = "scar_eye_r_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_arm_upper
	name = "Scar, Left Arm (Upper)"
	icon_state = "scar_arm_left_u"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/scar_left_arm_upper/teshari
	name = "Scar, Left Arm (Upper)(Teshari)"
	icon_state = "scar_arm_left_u_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_arm_lower
	name = "Scar, Left Arm (Lower)"
	icon_state = "scar_arm_left_l"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/scar_left_arm_lower/teshari
	name = "Scar, Left Arm (Lower)(Teshari)"
	icon_state = "scar_arm_left_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_arm_rear
	name = "Scar, Left Arm (Rear)"
	icon_state = "scar_arm_left_rear"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/scar_left_arm_rear/teshari
	name = "Scar, Left Arm (Rear)(Teshari)"
	icon_state = "scar_arm_left_rear_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_hand
	name = "Scar, Left Hand"
	icon_state = "scar_hand_left"
	body_parts = list(BP_L_HAND)

/datum/sprite_accessory/marking/scar_left_hand/teshari
	name = "Scar, Left Hand (Teshari)"
	icon_state = "scar_hand_left_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_arm_upper
	name = "Scar, Right Arm (Upper)"
	icon_state = "scar_arm_right_u"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/scar_right_arm_upper/teshari
	name = "Scar, Right Arm (Upper)(Teshari)"
	icon_state = "scar_arm_right_u_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_arm_lower
	name = "Scar, Right Arm (Lower)"
	icon_state = "scar_arm_right_l"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/scar_right_arm_lower/teshari
	name = "Scar, Right Arm (Lower)(Teshari)"
	icon_state = "scar_arm_right_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_arm_rear
	name = "Scar, Right Arm (Rear)"
	icon_state = "scar_arm_right_rear"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/scar_right_arm_rear/teshari
	name = "Scar, Right Arm (Rear)(Teshari)"
	icon_state = "scar_arm_right_rear_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_hand
	name = "Scar, Right Hand"
	icon_state = "scar_hand_right"
	body_parts = list(BP_R_HAND)

/datum/sprite_accessory/marking/scar_right_hand/teshari
	name = "Scar, Right Hand (Teshari)"
	icon_state = "scar_hand_right_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_leg_upper
	name = "Scar, Left Leg (Upper)"
	icon_state = "scar_leg_left_u"
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/scar_left_leg_upper/teshari
	name = "Scar, Left Leg (Upper)(Teshari)"
	icon_state = "scar_leg_left_u_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_leg_lower
	name = "Scar, Left Leg (Lower)"
	icon_state = "scar_leg_left_l"
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/scar_left_leg_lower/teshari
	name = "Scar, Left Leg (Lower)(Teshari)"
	icon_state = "scar_leg_left_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_leg_rear
	name = "Scar, Left Leg (Rear)"
	icon_state = "scar_leg_left_rear"
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/scar_left_leg_rear/teshari
	name = "Scar, Left Leg (Rear)(Teshari)"
	icon_state = "scar_leg_left_rear_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_foot
	name = "Scar, Left Foot"
	icon_state = "scar_left_foot"
	body_parts = list(BP_L_FOOT)

/datum/sprite_accessory/marking/scar_left_foot/teshari
	name = "Scar, Left Foot (Teshari)"
	icon_state = "scar_left_foot_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_leg_upper
	name = "Scar, Right Leg (Upper)"
	icon_state = "scar_right_leg_u"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/scar_right_leg_upper/teshari
	name = "Scar, Right Leg (Upper)(Teshari)"
	icon_state = "scar_right_leg_u_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_leg_lower
	name = "Scar, Right Leg (Lower)"
	icon_state = "scar_right_leg_l"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/scar_right_leg_lower/teshari
	name = "Scar, Right Leg (Lower)(Teshari)"
	icon_state = "scar_right_leg_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_leg_rear
	name = "Scar, Right Leg (Rear)"
	icon_state = "scar_right_leg_rear"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/scar_right_leg_rear/teshari
	name = "Scar, Right Leg (Rear)(Teshari)"
	icon_state = "scar_right_leg_rear_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_foot
	name = "Scar, Right Foot"
	icon_state = "scar_right_foot"
	body_parts = list(BP_R_FOOT)

/datum/sprite_accessory/marking/scar_right_foot/teshari
	name = "Scar, Right Foot (Teshari)"
	icon_state = "scar_right_foot_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/skull_paint
	name = "Skull Paint"
	icon_state = "skull"
	body_parts = list(BP_HEAD)
	genetic = FALSE

//Heterochromia

/datum/sprite_accessory/marking/heterochromia
	name = "Heterochromia (right eye)"
	icon_state = "heterochromia"
	body_parts = list(BP_HEAD)

//Taj/Unathi shared markings

/datum/sprite_accessory/marking/taj_paw_socks
	name = "Socks Coloration (Taj)"
	icon_state = "taj_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	//species_allowed = list(SPECIES_TAJ)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/una_paw_socks
	name = "Socks Coloration (Una)"
	icon_state = "una_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	//species_allowed = list(SPECIES_UNATHI)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/paw_socks
	name = "Socks Coloration (Generic)"
	icon_state = "pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	//species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/paw_socks_belly
	name = "Socks,Belly Coloration (Generic)"
	icon_state = "pawsocksbelly"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	//species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/belly_hands_feet
	name = "Hands,Feet,Belly Color (Minor)"
	icon_state = "bellyhandsfeetsmall"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	//species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/hands_feet_belly_full
	name = "Hands,Feet,Belly Color (Major)"
	icon_state = "bellyhandsfeet"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	//SPECIES_TAJ, SPECIES_UNATHI)				//Removing Polaris whitelits

/datum/sprite_accessory/marking/hands_feet_belly_full_female
	name = "Hands,Feet,Belly Color (Major, Female)"
	icon_state = "bellyhandsfeet_female"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	//species_allowed = list(SPECIES_TAJ)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/patches
	name = "Color Patches"
	icon_state = "patches"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)
	//species_allowed = list(SPECIES_TAJ)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/patchesface
	name = "Color Patches (Face)"
	icon_state = "patchesface"
	body_parts = list(BP_HEAD)
	//species_allowed = list(SPECIES_TAJ)				//Removing Polaris whitelits


	//Taj specific stuff
/datum/sprite_accessory/marking/taj_belly
	name = "Belly Fur (Taj)"
	icon_state = "taj_belly"
	body_parts = list(BP_TORSO)
	//species_allowed = list(SPECIES_TAJ)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/taj_bellyfull
	name = "Belly Fur Wide (Taj)"
	icon_state = "taj_bellyfull"
	body_parts = list(BP_TORSO)
	//species_allowed = list(SPECIES_TAJ)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/taj_earsout
	name = "Outer Ear (Taj)"
	icon_state = "taj_earsout"
	body_parts = list(BP_HEAD)
	//species_allowed = list(SPECIES_TAJ)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/taj_earsin
	name = "Inner Ear (Taj)"
	icon_state = "taj_earsin"
	body_parts = list(BP_HEAD)
	//species_allowed = list(SPECIES_TAJ)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/taj_nose
	name = "Nose Color (Taj)"
	icon_state = "taj_nose"
	body_parts = list(BP_HEAD)
	//species_allowed = list(SPECIES_TAJ)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/taj_crest
	name = "Chest Fur Crest (Taj)"
	icon_state = "taj_crest"
	body_parts = list(BP_TORSO)
	//species_allowed = list(SPECIES_TAJ)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/taj_muzzle
	name = "Muzzle Color (Taj)"
	icon_state = "taj_muzzle"
	body_parts = list(BP_HEAD)
	//species_allowed = list(SPECIES_TAJ)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/taj_face
	name = "Cheeks Color (Taj)"
	icon_state = "taj_face"
	body_parts = list(BP_HEAD)
	//species_allowed = list(SPECIES_TAJ)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/taj_all
	name = "All Taj Head (Taj)"
	icon_state = "taj_all"
	body_parts = list(BP_HEAD)
	//species_allowed = list(SPECIES_TAJ)			//Removing Polaris whitelits

	//Una specific stuff
/datum/sprite_accessory/marking/una_face
	name = "Face Color (Una)"
	icon_state = "una_face"
	body_parts = list(BP_HEAD)
	//species_allowed = list(SPECIES_UNATHI)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/una_facelow
	name = "Face Color Low (Una)"
	icon_state = "una_facelow"
	body_parts = list(BP_HEAD)
	//species_allowed = list(SPECIES_UNATHI)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/una_scutes
	name = "Scutes (Una)"
	icon_state = "una_scutes"
	body_parts = list(BP_TORSO)
	//species_allowed = list(SPECIES_UNATHI)			//Removing Polaris whitelits

	//Tesh stuff.

/datum/sprite_accessory/marking/teshi_fluff
	name = "Underfluff (Teshari)"
	icon_state = "teshi_fluff"
	body_parts = list(BP_HEAD, BP_TORSO, BP_GROIN, BP_R_LEG, BP_L_LEG)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/teshi_heterochromia
	name = "Heterochromia (Teshari) (right eye)"
	icon_state = "teshi_heterochromia"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

	//Diona stuff.

/datum/sprite_accessory/marking/diona_leaves
	name = "Leaves (Diona)"
	icon_state = "diona_leaves"
	body_parts = list(BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_TORSO, BP_GROIN, BP_HEAD)
	//species_allowed = list(SPECIES_DIONA)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/diona_thorns
	name = "Thorns (Diona)"
	icon_state = "diona_thorns"
	body_parts =list(BP_TORSO, BP_HEAD)
	//species_allowed = list(SPECIES_DIONA)			//Removing Polaris whitelits
	do_colouration = 0

/datum/sprite_accessory/marking/diona_flowers
	name = "Flowers (Diona)"
	icon_state = "diona_flowers"
	body_parts =list(BP_TORSO, BP_HEAD)
	//species_allowed = list(SPECIES_DIONA)			//Removing Polaris whitelits
	do_colouration = 0

/datum/sprite_accessory/marking/diona_moss
	name = "Moss (Diona)"
	icon_state = "diona_moss"
	body_parts =list(BP_TORSO)
	//species_allowed = list(SPECIES_DIONA)			//Removing Polaris whitelits
	do_colouration = 0

/datum/sprite_accessory/marking/diona_mushroom
	name = "Mushroom (Diona)"
	icon_state = "diona_mushroom"
	body_parts =list(BP_HEAD)
	//species_allowed = list(SPECIES_DIONA)			//Removing Polaris whitelits
	do_colouration = 0

/datum/sprite_accessory/marking/diona_antennae
	name = "Antennae (Diona)"
	icon_state = "diona_antennae"
	body_parts =list(BP_HEAD)
	//species_allowed = list(SPECIES_DIONA)			//Removing Polaris whitelits
	do_colouration = 0

//Skrell stuff.

/datum/sprite_accessory/marking/skrell
	name = "Countershading (Skrell)"
	icon_state = "skr_shade"
	body_parts = list(BP_TORSO, BP_GROIN, BP_HEAD)
	//species_allowed = list(SPECIES_SKRELL)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/skrell/stripes
	name = "Poison Dart Stripes (Skrell)"
	icon_state = "skr_stripes"
	body_parts = list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM, BP_TORSO)

//Cybernetic Augments, some species-limited due to sprite misalignment. /aug/ types are excluded from dna.

/datum/sprite_accessory/marking/aug
	name = "Augment (Backports, Back)"
	icon_state = "aug_backports"
	genetic = FALSE
	body_parts = list(BP_TORSO)
	species_allowed = list()			//Removing Polaris whitelits

/datum/sprite_accessory/marking/aug/diode
	name = "Augment (Backports Diode, Back)"
	icon_state = "aug_backportsdiode"

/datum/sprite_accessory/marking/aug/backportswide
	name = "Augment (Backports Wide, Back)"
	icon_state = "aug_backportswide"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/aug/backportswide/diode
	name = "Augment (Backports Wide Diode, Back)"
	icon_state = "aug_backportswidediode"

/datum/sprite_accessory/marking/aug/headcase
	name = "Augment (Headcase, Head)"
	icon_state = "aug_headcase"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/headcase_light
	name = "Augment (Headcase Light, Head)"
	icon_state = "aug_headcaselight"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/headport
	name = "Augment (Headport, Head)"
	icon_state = "aug_headport"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/headport/diode
	name = "Augment (Headport Diode, Head)"
	icon_state = "aug_headplugdiode"

/datum/sprite_accessory/marking/aug/lowerjaw
	name = "Augment (Lower Jaw, Head)"
	icon_state = "aug_lowerjaw"
	body_parts = list(BP_HEAD)
	species_allowed = list()			//Removing Polaris whitelits

/datum/sprite_accessory/marking/aug/scalpports
	name = "Augment (Scalp Ports)"
	icon_state = "aug_scalpports"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/scalpports/vertex_left
	name = "Augment (Scalp Port, Vertex Left)"
	icon_state = "aug_vertexport_l"

/datum/sprite_accessory/marking/aug/scalpports/vertex_right
	name = "Augment (Scalp Port, Vertex Right)"
	icon_state = "aug_vertexport_r"

/datum/sprite_accessory/marking/aug/scalpports/occipital_left
	name = "Augment (Scalp Port, Occipital Left)"
	icon_state = "aug_occipitalport_l"

/datum/sprite_accessory/marking/aug/scalpports/occipital_right
	name = "Augment (Scalp Port, Occipital Right)"
	icon_state = "aug_occipitalport_r"

/datum/sprite_accessory/marking/aug/scalpportsdiode
	name = "Augment (Scalp Ports Diode)"
	icon_state = "aug_scalpportsdiode"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/scalpportsdiode/vertex_left
	name = "Augment (Scalp Port Diode, Vertex Left)"
	icon_state = "aug_vertexportdiode_l"

/datum/sprite_accessory/marking/aug/scalpportsdiode/vertex_right
	name = "Augment (Scalp Port Diode, Vertex Right)"
	icon_state = "aug_vertexportdiode_r"

/datum/sprite_accessory/marking/aug/scalpportsdiode/occipital_left
	name = "Augment (Scalp Port Diode, Occipital Left)"
	icon_state = "aug_occipitalportdiode_l"

/datum/sprite_accessory/marking/aug/scalpportsdiode/occipital_right
	name = "Augment (Scalp Port Diode, Occipital Right)"
	icon_state = "aug_occipitalportdiode_r"

/datum/sprite_accessory/marking/aug/backside_left
	name = "Augment (Backside Left, Head)"
	icon_state = "aug_backside_l"

/datum/sprite_accessory/marking/aug/backside_left/side_diode
	name = "Augment (Backside Left Diode, Head)"
	icon_state = "aug_sidediode_l"

/datum/sprite_accessory/marking/aug/backside_right
	name = "Augment (Backside Right, Head)"
	icon_state = "aug_backside_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/backside_right/side_diode
	name = "Augment (Backside Right Diode, Head)"
	icon_state = "aug_sidediode_r"

/datum/sprite_accessory/marking/aug/side_deunan_left
	name = "Augment (Deunan, Side Left)"
	icon_state = "aug_sidedeunan_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/side_deunan_right
	name = "Augment (Deunan, Side Right)"
	icon_state = "aug_sidedeunan_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/side_kuze_left
	name = "Augment (Kuze, Side Left)"
	icon_state = "aug_sidekuze_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/side_kuze_left/side_diode
	name = "Augment (Kuze Diode, Side Left)"
	icon_state = "aug_sidekuzediode_l"

/datum/sprite_accessory/marking/aug/side_kuze_right
	name = "Augment (Kuze, Side Right)"
	icon_state = "aug_sidekuze_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/side_kuze_right/side_diode
	name = "Augment (Kuze Diode, Side Right)"
	icon_state = "aug_sidekuzediode_r"

/datum/sprite_accessory/marking/aug/side_kinzie_left
	name = "Augment (Kinzie, Side Left)"
	icon_state = "aug_sidekinzie_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/side_kinzie_right
	name = "Augment (Kinzie, Side Right)"
	icon_state = "aug_sidekinzie_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/side_shelly_left
	name = "Augment (Shelly, Side Left)"
	icon_state = "aug_sideshelly_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/side_shelly_right
	name = "Augment (Shelly, Side Right)"
	icon_state = "aug_sideshelly_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/chestports
	name = "Augment (Chest Ports)"
	icon_state = "aug_chestports"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/aug/chestports/teshari
	name = "Augment (Chest Ports)(Teshari)"
	icon_state = "aug_chestports_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/aug/abdomenports
	name = "Augment (Abdomen Ports)"
	icon_state = "aug_abdomenports"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/aug/abdomenports/teshari
	name = "Augment (Abdomen Ports)(Teshari)"
	icon_state = "aug_abdomenports_tesh"
	body_parts = list(BP_GROIN)
	species_allowed = list(SPECIES_TESHARI)

//bandages

/datum/sprite_accessory/marking/bandage
	name = "Bandage, Head 1"
	icon_state = "bandage1"
	body_parts = list(BP_HEAD)
	genetic = FALSE
	do_colouration = FALSE

/datum/sprite_accessory/marking/bandage/teshari
	name = "Bandage, Head 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/head2
	name = "Bandage, Head 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/head2/teshari
	name = "Bandage, Head 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/head3
	name = "Bandage, Head 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/head3/teshari
	name = "Bandage, Head 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/torso
	name = "Bandage, Torso 1"
	icon_state = "bandage1"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/bandage/torso/teshari
	name = "Bandage, Torso 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/torso/torso2
	name = "Bandage, Torso 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/torso/torso2/teshari
	name = "Bandage, Torso 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/torso/torso3
	name = "Bandage, Torso 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/torso/torso3/teshari
	name = "Bandage, Torso 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/groin
	name = "Bandage, Groin 1"
	icon_state = "bandage1"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/bandage/groin/teshari
	name = "Bandage, Groin 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/groin/groin2
	name = "Bandage, Groin 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/groin/groin2/teshari
	name = "Bandage, Groin 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/groin/groin3
	name = "Bandage, Groin 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/groin/groin3/teshari
	name = "Bandage, Groin 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_arm
	name = "Bandage, Left Arm 1"
	icon_state = "bandage1"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/bandage/l_arm/teshari
	name = "Bandage, Left Arm 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_arm/l_arm2
	name = "Bandage, Left Arm 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/l_arm/l_arm2/teshari
	name = "Bandage, Left Arm 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_arm/l_arm3
	name = "Bandage, Left Arm 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/l_arm/l_arm3/teshari
	name = "Bandage, Left Arm 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_hand
	name = "Bandage, Left Hand 1"
	icon_state = "bandage1"
	body_parts = list(BP_L_HAND)

/datum/sprite_accessory/marking/bandage/l_hand/teshari
	name = "Bandage, Left Hand 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_hand/l_hand2
	name = "Bandage, Left Hand 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/l_hand/l_hand_2/teshari
	name = "Bandage, Left Hand 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_hand/l_hand3
	name = "Bandage, Left Hand 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/r_arm
	name = "Bandage, Right Arm 1"
	icon_state = "bandage1"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/bandage/r_arm/teshari
	name = "Bandage, Right Arm 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_arm/r_arm2
	name = "Bandage, Right Arm 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/r_arm/r_arm2/teshari
	name = "Bandage, Right Arm 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_arm/r_arm3
	name = "Bandage, Right Arm 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/r_arm/r_arm3/teshari
	name = "Bandage, Right Arm 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_hand
	name = "Bandage, Right Hand 1"
	icon_state = "bandage1"
	body_parts = list(BP_R_HAND)

/datum/sprite_accessory/marking/bandage/r_hand/teshari
	name = "Bandage, Right Hand 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_hand/r_hand2
	name = "Bandage, Right Hand 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/r_hand/r_hand2/teshari
	name = "Bandage, Right Hand 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_hand/r_hand3
	name = "Bandage, Right Hand 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/l_leg
	name = "Bandage, Left Leg 1"
	icon_state = "bandage1"
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/bandage/l_leg/teshari
	name = "Bandage, Left Leg 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_leg/l_leg2
	name = "Bandage, Left Leg 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/l_leg/l_leg2/teshari
	name = "Bandage, Left Leg 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_leg/l_leg3
	name = "Bandage, Left Leg 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/l_leg/l_leg3/teshari
	name = "Bandage, Left Leg 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_foot
	name = "Bandage, Left Foot 1"
	icon_state = "bandage1"
	body_parts = list(BP_L_FOOT)

/datum/sprite_accessory/marking/bandage/l_foot/teshari
	name = "Bandage, Left Foot 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_foot/l_foot2
	name = "Bandage, Left Foot 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/l_foot/l_foot_2/teshari
	name = "Bandage, Left Foot 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_foot/l_foot3
	name = "Bandage, Left Foot 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/l_foot/l_foot_3/teshari
	name = "Bandage, Left Foot 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_leg
	name = "Bandage, Right Leg 1"
	icon_state = "bandage1"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/bandage/r_leg/teshari
	name = "Bandage, Right Leg 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_leg/r_leg2
	name = "Bandage, Right Leg 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/r_leg/r_leg2/teshari
	name = "Bandage, Right Leg 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_leg/r_leg3
	name = "Bandage, Right Leg 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/r_leg/r_leg3/teshari
	name = "Bandage, Right Leg 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_foot
	name = "Bandage, Right Foot 1"
	icon_state = "bandage1"
	body_parts = list(BP_R_FOOT)

/datum/sprite_accessory/marking/bandage/r_foot/teshari
	name = "Bandage, Right Foot 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_foot/r_foot2
	name = "Bandage, Right Foot 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/r_foot/r_foot2/teshari
	name = "Bandage, Right Foot 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_foot/r_foot3
	name = "Bandage, Rufgt Foot 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/r_foot/r_foot3/teshari
	name = "Bandage, Right Foot 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

//skin styles - WIP
//going to have to re-integrate this with surgery
//let the icon_state hold an icon preview for now

/datum/sprite_accessory/skin
	icon = 'icons/mob/human_races/r_human.dmi'

/datum/sprite_accessory/skin/human
	name = "Default human skin"
	icon_state = "default"
	//species_allowed = list(SPECIES_HUMAN,SPECIES_HUMAN_VATBORN)			//Removing Polaris whitelits

/datum/sprite_accessory/skin/human_tatt01
	name = "Tatt01 human skin"
	icon_state = "tatt1"
	//species_allowed = list(SPECIES_HUMAN,SPECIES_HUMAN_VATBORN)			//Removing Polaris whitelits

/datum/sprite_accessory/skin/tajaran
	name = "Default tajaran skin"
	icon_state = "default"
	icon = 'icons/mob/human_races/r_tajaran.dmi'
	//species_allowed = list(SPECIES_TAJ)			//Removing Polaris whitelits

/datum/sprite_accessory/skin/unathi
	name = "Default Unathi skin"
	icon_state = "default"
	icon = 'icons/mob/human_races/r_lizard.dmi'
	//species_allowed = list(SPECIES_UNATHI)			//Removing Polaris whitelits

/datum/sprite_accessory/skin/skrell
	name = "Default skrell skin"
	icon_state = "default"
	icon = 'icons/mob/human_races/r_skrell.dmi'
	//species_allowed = list(SPECIES_SKRELL)			//Removing Polaris whitelits
