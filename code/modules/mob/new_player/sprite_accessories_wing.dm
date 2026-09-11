/*
////////////////////////////
/  =--------------------=  /
/  == Wing Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/wing
	name = DEVELOPER_WARNING_NAME
	icon = 'icons/mob/human_races/sprite_accessories/wings.dmi'
	do_colouration = FALSE //Set to 1 to enable coloration using the tail color.

	color_blend_mode = ICON_ADD // Only appliciable if do_coloration = 1
	em_block = TRUE
	var/extra_overlay // Icon state of an additional overlay to blend in.
	var/extra_overlay2 //Tertiary.
	var/clothing_can_hide = TRUE // If true, clothing with HIDETAIL hides it. If the clothing is bulky enough to hide a tail, it should also hide wings.
	// var/show_species_tail = 1 // Just so // TODO - Seems not needed ~Leshana
	var/desc = DEVELOPER_WARNING_NAME
	var/ani_state // State when flapping/animated
	var/extra_overlay_w // Flapping state for extra overlay
	var/extra_overlay2_w

	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJARAN, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN, SPECIES_LLEILL, SPECIES_HANNER, SPECIES_SPARKLE, SPECIES_PROMETHEAN, SPECIES_ZORREN_DARK)

	var/wing_offset = 0
	var/multi_dir = FALSE		// Does it use different sprites at different layers? _front will be added for sprites on low layer, _back to high layer

/datum/sprite_accessory/wing/featheredlarge //Made by Natje!
	name = "large feathered wings (colorable)"
	icon_state = "feathered2"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/spider_legs //Not really /WINGS/ but they protrude from the back, kinda. Might as well have them here.
	name = "spider legs"
	icon_state = "spider-legs"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/moth
	name = "moth wings"
	icon_state = "moth"

/datum/sprite_accessory/wing/mothc
	name = "moth wings, colorable"
	icon_state = "moth"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/dragonfly
	name = "dragonfly"
	icon_state = "dragonfly"
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/feathered
	name = "feathered wings, colorable"
	icon_state = "feathered"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/feathered_medium
	name = "medium feathered wings, colorable" // Keekenox made these feathery things with a little bit more shape to them than the other wings. They are medium sized wing boys.
	icon_state = "feathered3"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/bat_black
	name = "bat wings, black"
	icon_state = "bat-black"

/datum/sprite_accessory/wing/bat_color
	name = "bat wings, colorable"
	icon_state = "bat-color"
	do_colouration = TRUE

/datum/sprite_accessory/wing/bat_red
	name = "bat wings, red"
	icon_state = "bat-red"

/datum/sprite_accessory/wing/bat_purpley
	name = "bat wings, purple"
	icon_state = "bat-purple"

/datum/sprite_accessory/wing/harpywings
	name = "harpy wings, colorable"
	icon_state = "harpywings"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY


/datum/sprite_accessory/wing/mantisarms
	name = "Mantis arms"
	icon_state = "mantisarms_s"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/harpywings_alt
	name = "harpy wings alt, archeopteryx"
	icon_state = "harpywings_alt"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "harpywings_altmarkings"

/datum/sprite_accessory/wing/harpywings_alt_neckfur
	name = "harpy wings alt, archeopteryx & neckfur"
	icon_state = "harpywings_alt"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "harpywings_altmarkings"
	extra_overlay2 = "neckfur"

/datum/sprite_accessory/wing/harpywings_bat
	name = "harpy wings, bat"
	icon_state = "harpywings_bat"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "harpywings_batmarkings"

/datum/sprite_accessory/wing/harpywings_bat_neckfur
	name = "harpy wings, bat & neckfur"
	icon_state = "harpywings_bat"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "harpywings_batmarkings"
	extra_overlay2 = "neckfur"

/datum/sprite_accessory/wing/harpyarmwings
	name = "harpy arm wings, colorable"
	icon_state = "harpyarmwings"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/harpyarmwings_alt
	name = "harpy arm wings alt, colorable"
	icon_state = "harpyarmwings_alt"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/harpyarmwings_alt_neckfur
	name = "harpy arm wings alt & neckfur"
	icon_state = "harpyarmwings_alt"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "neckfur"

/datum/sprite_accessory/wing/harpyarmwings_bat
	name = "harpy arm wings, bat"
	icon_state = "harpyarmwings_bat"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "harpyarmwings_batmarkings"

/datum/sprite_accessory/wing/harpyarmwings_bat_neckfur
	name = "harpy arm wings, bat & neckfur"
	icon_state = "harpyarmwings_bat"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "harpyarmwings_batmarkings"
	extra_overlay2 = "neckfur"

/datum/sprite_accessory/wing/neckfur
	name = "neck fur"
	icon_state = "neckfur"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "neckfur_markings"

/datum/sprite_accessory/wing/neckfur_noback
	name = "neck fur (without back part)"
	icon_state = "neckfur_noback"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "neckfur_markings"

/datum/sprite_accessory/wing/feathered
	name = "feathered wings, colorable"
	icon_state = "feathered"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/beewings
	name = "bee wings"
	icon_state = "beewings"

/datum/sprite_accessory/wing/liquidfirefly_gazer //I g-guess this could be considered wings?
	name = "gazer eyestalks"
	icon_state = "liquidfirefly-eyestalks"
	//ckeys_allowed = list("liquidfirefly","seiga") //At request.

/datum/sprite_accessory/wing/liquidfirefly_gazer_gray //Original sprite is from liquidfirefly, greyscale version is *not*
	name = "gazer eyestalks, colorable"
	icon_state = "eyestalkc"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "eyestalkc_eyes"

/datum/sprite_accessory/wing/moth_full
	name = "moth antenna and wings"
	icon_state = "moth_full"

/datum/sprite_accessory/wing/moth_full_gray
	name = "moth antenna and wings, colorable"
	icon_state = "moth_full_gray"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/snag
	name = "xenomorph backplate"
	icon_state = "snag-backplate"

/datum/sprite_accessory/wing/sepulchre_c_yw
	name = "demon wings (colorable)"
	icon_state = "sepulchre_wingsc"
	do_colouration = TRUE

/datum/sprite_accessory/wing/sepulchre_c_yw_w
	name = "demon wings (colorable, whitescale)"
	icon_state = "sepulchre_wingsc_w"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/cyberdragon
	name = "Cyber dragon wing (colorable)"
	icon_state = "cyberdragon_s"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/cyberdragon_red
	name = "Cyber dragon wing (red)"
	icon_state = "cyberdragon_red_s"
	do_colouration = FALSE

/datum/sprite_accessory/wing/cyberdoe
	name = "Cyber doe wing"
	icon_state = "cyberdoe_s"
	do_colouration = FALSE

/datum/sprite_accessory/wing/drago_wing
	name = "Cybernetic Dragon wings"
	icon_state = "drago_wing"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "drago_wing_2"

/datum/sprite_accessory/wing/aeromorph_flat
	name = "aeromorph wings, flat"
	icon_state = "aeromorph_flat"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "aeromorph_flat_1"
	extra_overlay2 = "aeromorph_flat_2"

/datum/sprite_accessory/wing/teshbee
	name = "Teshari bee wings"
	icon_state = "beewings_tesh"

/datum/sprite_accessory/wing/teshdragonfly
	name = "Teshari dragonfly wings"
	icon_state = "dragonfly_tesh"

/datum/sprite_accessory/wing/snail_shell
	name = "snail shell, colorable"
	icon_state = "snail_shell"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "snail_shell_markings"

/datum/sprite_accessory/wing/sectdrone_wing //We should some day make a variable to make some wings not be able to fly
	name = "Sect drone wings (To use with bodytype marking)"
	icon_state = "sectdrone_wing"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/winglets //smol wingarms at the elbow
	name = "feathered winglets"
	icon_state = "winglets"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/wingarms_speckles
	name = "wingarms, speckled"
	icon_state = "wingarms_speckles"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "wingarms_speckles-speckles"

/datum/sprite_accessory/wing/wingarms_2tone
	name = "wingarms, 2 colors"
	icon_state = "wingarms_2tone"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "wingarms_2tone-1"

/datum/sprite_accessory/wing/feather2_speckles
	name = "large feathered wings, speckled"
	icon_state = "feather2_speckles"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "feather2_speckles-speckles"

/datum/sprite_accessory/wing/feather2_tricolor
	name = "large feathered wings, tricolor"
	icon_state = "feather2_tricolor"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "feather2_tricolor-1"
	extra_overlay2 = "feather2_tricolor-2"

/datum/sprite_accessory/wing/speckled_tricolor
	name = "large speckled leather wings, tricolor"
	// not ckey locked, just couldn't think of a better icon state name
	icon_state = "shadow_tricolor"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "shadow_tricolor-1"
	extra_overlay2 = "shadow_tricolor-2"

/datum/sprite_accessory/wing/speckled_tricolor
	name = "large speckled leather wings, tricolor, sparkling"
	// not ckey locked, just couldn't think of a better icon state name
	icon_state = "shadow_tricolor"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "shadow_tricolor-1"
	extra_overlay2 = "shadow_tricolor-2-sparkle"

// dino wings
/datum/sprite_accessory/wing/pterodactyl_wings
	name = "pterodactyl wings"
	icon_state = "pterodactyl_wing_frame"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "pterodactyl_wing_membrane"

/datum/sprite_accessory/wing/kaiju_spines_a
	name = "kaiju spines A, colorable"
	icon_state = "kaiju_spikes_a"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/kaiju_spines_a_glow
	name = "kaiju spines A, colorable, glow"
	icon_state = "kaiju_spikes_a"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "kaiju_spikes_a_glow"

/datum/sprite_accessory/wing/cyberangel
	name = "Cyber angel wing (colorable)"
	icon_state = "cyber_angel"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/dragon2
	name = "Dragon wings, large, colorable"
	icon_state = "dragon_2"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "dragon_2_mark"

/datum/sprite_accessory/wing/snagc
	name = "xenomorph backplate, colorable"
	icon_state = "csnag-backplate"
	do_colouration = TRUE

/datum/sprite_accessory/wing/snagc2
	name = "xenomorph backplate, colorable 2"
	icon_state = "csnag-backplate-2"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/xeno_queen
	name = "xenomorph backplate (queen)"
	icon_state = "xeno_queen"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/snail
	name = "Snail shell"
	icon_state = "snail_shell_new"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/xeno_standard_backplate
	name = "Xenomorph backplate (standard)"
	icon_state = "xeno_standard"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/xeno_royal_backplate
	name = "Xenomorph backplate (royal)"
	icon_state = "xeno_royal"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/xeno_down_backplate
	name = "Xenomorph backplate (down)"
	icon_state = "xeno_down"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/cloakwings
	name = "Cloaking Moth Wings with Eyes (Colorable)"
	icon_state = "cloakmoth"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "cloakmoth_eyes"

/datum/sprite_accessory/wing/cybertendrils
	name = "Cyber Tendrils"
	icon_state = "cybertendrils"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "cybertendrils_plugs"

/datum/sprite_accessory/wing/jet_wing
	name = "Aeromorph Jet Wings (Colorable)"
	icon_state = "jet_wing"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "jet_wing_1"
	extra_overlay2 = "jet_wing_2"

/datum/sprite_accessory/wing/mothwings_clockwork
	name = "Moth Wings (Clockwork)"
	icon_state = "mothwings_clockwork"

/datum/sprite_accessory/wing/mothwings_monarch
	name = "Moth Wings (Monarch)"
	icon_state = "mothwings_monarch"

/datum/sprite_accessory/wing/mothwings_luna
	name = "Moth Wings (Luna)"
	icon_state = "mothwings_luna"

/datum/sprite_accessory/wing/mothwings_atlas
	name = "Moth Wings (Atlas)"
	icon_state = "mothwings_atlas"

/datum/sprite_accessory/wing/mothwings_plain
	name = "Moth Wings (Plain)"
	icon_state = "mothwings_plain"

/datum/sprite_accessory/wing/mothwings_redish
	name = "Moth Wings (Redish)"
	icon_state = "mothwings_redish"

/datum/sprite_accessory/wing/mothwings_royal
	name = "Moth Wings (Royal)"
	icon_state = "mothwings_royal"

/datum/sprite_accessory/wing/mothwings_gothic
	name = "Moth Wings (Gothic)"
	icon_state = "mothwings_gothic"

/datum/sprite_accessory/wing/mothwings_lovers
	name = "Moth Wings (Lovers)"
	icon_state = "mothwings_lovers"

/datum/sprite_accessory/wing/mothwings_whitefly
	name = "Moth Wings (Whitefly)"
	icon_state = "mothwings_whitefly"

/datum/sprite_accessory/wing/mothwings_burntoff
	name = "Moth Wings (Burnt Off)"
	icon_state = "mothwings_burntoff"

/datum/sprite_accessory/wing/mothwings_firewatch
	name = "Moth Wings (Firewatch)"
	icon_state = "mothwings_firewatch"

/datum/sprite_accessory/wing/mothwings_deathhhead
	name = "Moth Wings (Deathhead)"
	icon_state = "mothwings_deathhead"

/datum/sprite_accessory/wing/mothwings_poison
	name = "Moth Wings (Poison)"
	icon_state = "mothwings_poison"

/datum/sprite_accessory/wing/mothwings_ragged
	name = "Moth Wings (Ragged)"
	icon_state = "mothwings_ragged"

/datum/sprite_accessory/wing/mothwings_moonfly
	name = "Moth Wings (Moonfly)"
	icon_state = "mothwings_moonfly"

/datum/sprite_accessory/wing/mothwings_snow
	name = "Moth Wings (Snow)"
	icon_state = "mothwings_snow"

/datum/sprite_accessory/wing/mothwings_angel
	name = "Moth Wings (angel)"
	icon_state = "mothwings_angel"

/datum/sprite_accessory/wing/mothwings_no_antennae_colorable
	name = "Moth Wings (Colorable)"
	icon_state = "mothwings_no_antennae_color"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/mothwings_luna_colorable
	name = "Moth Wings (Luna, Colorable)"
	icon_state = "mothwings_luna_colorable"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/sect_drone_alt
	name = "Sect drone wings Alt. (To use with bodytype marking)"
	icon = 'icons/mob/human_races/sprite_accessories/wings64.dmi'
	icon_state = "sectdrone_wing_alt"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	wing_offset = 16

/datum/sprite_accessory/wing/sect_drone_alt_nomark
	name = "Sect drone wings Alt."
	icon = 'icons/mob/human_races/sprite_accessories/wings64.dmi'
	icon_state = "sectdrone_wing_alt_nomark"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	wing_offset = 16

/datum/sprite_accessory/wing/taurdragon
	name = "Taur wings (Draconian)"
	icon = 'icons/mob/human_races/sprite_accessories/wings64.dmi'
	icon_state = "taurdrake_wing"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	wing_offset = 16

/datum/sprite_accessory/wing/large_harpy_wings_ch
	name = "Harpy arm-wings(Large)"
	icon = 'icons/mob/human_races/sprite_accessories/wings64.dmi'
	icon_state = "Harpy_wings"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	wing_offset = 16

/datum/sprite_accessory/wing/naga_wings
	name = "Naga wings"
	icon = 'icons/mob/human_races/sprite_accessories/wings64.dmi'
	icon_state = "naga_wing"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	wing_offset = 16

/datum/sprite_accessory/wing/sloogshell
	name = "Sloog shell"
	icon = 'icons/mob/human_races/sprite_accessories/wings64.dmi'
	icon_state = "sloogshell"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	wing_offset = 16

/datum/sprite_accessory/wing/xeno_queen_new
	name = "xenomorph backplate (queen, new)"
	icon_state = "xeno_queen_new"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY

//exclusive wings
/datum/sprite_accessory/wing/kara
	name = "Pterokara wings"
	icon_state = "feathered_kara"
	ckeys_allowed = list("satinisle")

/datum/sprite_accessory/wing/sepulchre
	name = "demon wings (Sepulchre)"
	icon_state = "sepulchre_wings"
	ckeys_allowed = list("sepulchre")

/datum/sprite_accessory/wing/miria_fluffdragon
	name = "fluffdragon wings (Miria Masters)"
	icon_state = "miria-fluffdragontail"
	ckeys_allowed = list("miriamasters")

/datum/sprite_accessory/wing/scree
	name = "green taj wings (Scree)"
	icon_state = "scree-wings"
	ckeys_allowed = list("scree")

/datum/sprite_accessory/wing/kerena
	name = "wingwolf wings (Kerena)"
	icon_state = "kerena-wings"
	ckeys_allowed = list("somekindofpony")

/datum/sprite_accessory/wing/shock //Unable to split the tail from the wings in the sprite, so let's just classify it as wings.
	name = "pharoah hound tail (Shock Diamond)"
	icon_state = "shock"
	ckeys_allowed = list("icowom")

/datum/sprite_accessory/wing/citheroniamoth
	name = "citheronia wings"
	icon_state = "citheronia_wings"
	ckeys_allowed = list("kira72")
