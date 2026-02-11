/datum/pai_sprite
	var/name = DEVELOPER_WARNING_NAME
	var/hidden = FALSE

	var/sprite_icon = null
	var/sprite_icon_state = null
	var/has_eye_color = TRUE
	var/flying = FALSE
	var/belly_states = 1

	var/can_rest = TRUE // We really shouldn't be permitting this... eventually. Remove when all sprite can rest.
	var/resting_belly = TRUE

	var/holo_projector = FALSE // Special AI hologram-like handling
	var/holo_eyes_icon_state = null

	var/pixel_x = 0
	var/pixel_y = 0
	var/icon_x = 32
	var/icon_y = 32
	var/vis_height = 32

// PAI sprites
/datum/pai_sprite/drone
	name = PAI_DEFAULT_CHASSIS
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-repairbot"

/datum/pai_sprite/cat
	name = "Cat"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-cat"

/datum/pai_sprite/mouse
	name = "Mouse"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-mouse"

/datum/pai_sprite/monkey
	name = "Monkey"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-monkey"

/datum/pai_sprite/borgi
	name = "Borgi"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-borgi"
	has_eye_color = FALSE

/datum/pai_sprite/fox
	name = "Fox"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-fox"
	has_eye_color = FALSE

/datum/pai_sprite/parrot
	name = "Parrot"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-parrot"
	has_eye_color = FALSE
	flying = TRUE

/datum/pai_sprite/rabbit
	name = "Rabbit"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-rabbit"
	has_eye_color = FALSE

/datum/pai_sprite/bear
	name = "Bear"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-bear"

/datum/pai_sprite/fennec
	name = "Fennec"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-fen"
	belly_states = 0

/datum/pai_sprite/type_zero
	name = "Type Zero"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-typezero"

/datum/pai_sprite/raccoon
	name = "Raccoon"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-raccoon"

/datum/pai_sprite/raptor
	name = "Raptor"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-raptor"

/datum/pai_sprite/corgi
	name = "Corgi"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-corgi"
	has_eye_color = FALSE

/datum/pai_sprite/bat
	name = "Bat"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-bat"
	flying = TRUE

/datum/pai_sprite/butterfly
	name = "Butterfly"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-butterfly"
	flying = TRUE
	belly_states = 0

/datum/pai_sprite/hawk
	name = "Hawk"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-hawk"
	has_eye_color = FALSE
	flying = TRUE
	belly_states = 0

/datum/pai_sprite/duffel
	name = "Duffel"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "pai-duffel"
	has_eye_color = FALSE

/datum/pai_sprite/cyber_elf
	name = "Cyber Elf"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "cyberelf"
	flying = TRUE
	resting_belly = FALSE

/datum/pai_sprite/catslug
	name = "Catslug"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "catslug"
	resting_belly = FALSE

/datum/pai_sprite/car
	name = "Car"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "car"

/datum/pai_sprite/type_one
	name = "Type One"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "typeone"

/datum/pai_sprite/type_thirteen
	name = "Type Thirteen"
	sprite_icon = 'icons/mob/pai.dmi'
	sprite_icon_state = "13"
	holo_projector = TRUE
	holo_eyes_icon_state = "type13-eyes"

// Large pai sprites
/datum/pai_sprite/large
	pixel_x = -16
	icon_x = 64
	icon_y = 64
	vis_height = 64

/datum/pai_sprite/large/dire_wolf
	name = "Dire wolf"
	sprite_icon = 'icons/mob/pai_64x64.dmi'
	sprite_icon_state = "pai-diredog"

/datum/pai_sprite/large/horse_lune
	name = "Horse (Lune)"
	sprite_icon = 'icons/mob/pai_64x64.dmi'
	sprite_icon_state = "pai-horse_lune"
	can_rest = FALSE // FIX ME!
	resting_belly = FALSE

/datum/pai_sprite/large/horse_soleil
	name = "Horse (Soleil)"
	sprite_icon = 'icons/mob/pai_64x64.dmi'
	sprite_icon_state = "pai-horse_soleil"
	can_rest = FALSE // FIX ME!
	resting_belly = FALSE

/datum/pai_sprite/large/dragon
	name = "Dragon"
	sprite_icon = 'icons/mob/pai_64x64.dmi'
	sprite_icon_state = "pai-pdragon"
	can_rest = FALSE // FIX ME!
	resting_belly = FALSE

/datum/pai_sprite/large/rat
	name = "Rat"
	sprite_icon = 'icons/mob/pai_64x64.dmi'
	sprite_icon_state = "rat"

/datum/pai_sprite/large/panther
	name = "Panther"
	sprite_icon = 'icons/mob/pai_64x64.dmi'
	sprite_icon_state = "panther"

/datum/pai_sprite/large/teppi
	name = "Teppi"
	sprite_icon = 'icons/mob/pai_64x64.dmi'
	sprite_icon_state = "teppi"

/datum/pai_sprite/large/protogen_dog
	name = "Protogen Dog"
	sprite_icon = 'icons/mob/pai_64x64.dmi'
	sprite_icon_state = "pai-protodog"
