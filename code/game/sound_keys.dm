/**
# sound_effect datum
* use for when you need multiple sound files to play at random in a playsound
* see var documentation below
* initialized and added to sfx_datum_by_key in /datum/controller/subsystem/sounds/init_sound_keys()
*/
/datum/sound_effect
	/// sfx key define with which we are associated with, see code\__DEFINES\sound.dm
	var/key
	/// list of paths to our files, use the /assoc subtype if your paths are weighted
	var/list/file_paths

/datum/sound_effect/proc/return_sfx()
	return pick(file_paths)

/datum/sound_effect/assoc

/datum/sound_effect/assoc/return_sfx()
	return pickweight(file_paths)

/// CORE SFX

/datum/sound_effect/shatter
	key = SFX_SHATTER
	file_paths = list(
		'sound/effects/glass/glassbr1.ogg',
		'sound/effects/glass/glassbr2.ogg',
		'sound/effects/glass/glassbr3.ogg',
	)

/datum/sound_effect/explosion
	key = SFX_EXPLOSION
	file_paths = list(
		'sound/effects/explosion/explosion1.ogg',
		'sound/effects/explosion/explosion2.ogg',
		'sound/effects/explosion/explosion3.ogg',
		'sound/effects/explosion/explosion4.ogg',
		'sound/effects/explosion/explosion5.ogg',
		'sound/effects/explosion/explosion6.ogg',
	)

/datum/sound_effect/sparks
	key = SFX_SPARKS
	file_paths = list(
		'sound/effects/sparks/sparks1.ogg',
		'sound/effects/sparks/sparks2.ogg',
		'sound/effects/sparks/sparks3.ogg',
		'sound/effects/sparks/sparks4.ogg',
		'sound/effects/sparks/sparks5.ogg',
		'sound/effects/sparks/sparks6.ogg',
		'sound/effects/sparks/sparks7.ogg',
	)

/datum/sound_effect/rustle
	key = SFX_RUSTLE
	file_paths = list(
		'sound/effects/rustle/rustle1.ogg',
		'sound/effects/rustle/rustle2.ogg',
		'sound/effects/rustle/rustle3.ogg',
		'sound/effects/rustle/rustle4.ogg',
		'sound/effects/rustle/rustle5.ogg',
	)

/datum/sound_effect/punch
	key = SFX_PUNCH
	file_paths = list(
		'sound/items/weapons/punch1.ogg',
		'sound/items/weapons/punch2.ogg',
		'sound/items/weapons/punch3.ogg',
		'sound/items/weapons/punch4.ogg',
	)

/datum/sound_effect/clown_step
	key = SFX_CLOWN_STEP
	file_paths = list(
		'sound/effects/footstep/clownstep1.ogg',
		'sound/effects/footstep/clownstep2.ogg',
	)

/datum/sound_effect/swing_hit
	key = SFX_SWING_HIT
	file_paths = list(
		'sound/items/weapons/genhit1.ogg',
		'sound/items/weapons/genhit2.ogg',
		'sound/items/weapons/genhit3.ogg',
	)

/datum/sound_effect/hiss
	key = SFX_HISS
	file_paths = list(
		'sound/mob/non-humanoids/hiss/hiss1.ogg',
		'sound/mob/non-humanoids/hiss/hiss2.ogg',
		'sound/mob/non-humanoids/hiss/hiss3.ogg',
		'sound/mob/non-humanoids/hiss/hiss4.ogg',
	)

/datum/sound_effect/page_turn
	key = SFX_PAGE_TURN
	file_paths = list(
		'sound/effects/page_turn/pageturn1.ogg',
		'sound/effects/page_turn/pageturn2.ogg',
		'sound/effects/page_turn/pageturn3.ogg',
	)

/datum/sound_effect/ricochet
	key = SFX_RICOCHET
	file_paths = list(
		'sound/items/weapons/effects/ric1.ogg',
		'sound/items/weapons/effects/ric2.ogg',
		'sound/items/weapons/effects/ric3.ogg',
		'sound/items/weapons/effects/ric4.ogg',
		'sound/items/weapons/effects/ric5.ogg',
	)

/datum/sound_effect/terminal_type
	key = SFX_TERMINAL_TYPE
	file_paths = list(
		'sound/machines/terminal/terminal_button01.ogg',
		'sound/machines/terminal/terminal_button02.ogg',
		'sound/machines/terminal/terminal_button03.ogg',
		'sound/machines/terminal/terminal_button04.ogg',
		'sound/machines/terminal/terminal_button05.ogg',
		'sound/machines/terminal/terminal_button06.ogg',
		'sound/machines/terminal/terminal_button07.ogg',
		'sound/machines/terminal/terminal_button08.ogg',
	)

/datum/sound_effect/can_open
	key = SFX_CAN_OPEN
	file_paths = list(
		'sound/items/can/can_open1.ogg',
		'sound/items/can/can_open2.ogg',
		'sound/items/can/can_open3.ogg',
		'sound/items/can/can_open4.ogg',
	)

/datum/sound_effect/bullet_miss
	key = SFX_BULLET_MISS
	file_paths = list(
		'sound/items/weapons/bulletflyby.ogg',
		'sound/items/weapons/bulletflyby2.ogg',
		'sound/items/weapons/bulletflyby3.ogg',
	)

/datum/sound_effect/sm_calm
	key = SFX_SM_CALM
	file_paths = list(
		'sound/machines/sm/accent/normal/1.ogg',
		'sound/machines/sm/accent/normal/2.ogg',
		'sound/machines/sm/accent/normal/3.ogg',
		'sound/machines/sm/accent/normal/4.ogg',
		'sound/machines/sm/accent/normal/5.ogg',
		'sound/machines/sm/accent/normal/6.ogg',
		'sound/machines/sm/accent/normal/7.ogg',
		'sound/machines/sm/accent/normal/8.ogg',
		'sound/machines/sm/accent/normal/9.ogg',
		'sound/machines/sm/accent/normal/10.ogg',
		'sound/machines/sm/accent/normal/11.ogg',
		'sound/machines/sm/accent/normal/12.ogg',
		'sound/machines/sm/accent/normal/13.ogg',
		'sound/machines/sm/accent/normal/14.ogg',
		'sound/machines/sm/accent/normal/15.ogg',
		'sound/machines/sm/accent/normal/16.ogg',
		'sound/machines/sm/accent/normal/17.ogg',
		'sound/machines/sm/accent/normal/18.ogg',
		'sound/machines/sm/accent/normal/19.ogg',
		'sound/machines/sm/accent/normal/20.ogg',
		'sound/machines/sm/accent/normal/21.ogg',
		'sound/machines/sm/accent/normal/22.ogg',
		'sound/machines/sm/accent/normal/23.ogg',
		'sound/machines/sm/accent/normal/24.ogg',
		'sound/machines/sm/accent/normal/25.ogg',
		'sound/machines/sm/accent/normal/26.ogg',
		'sound/machines/sm/accent/normal/27.ogg',
		'sound/machines/sm/accent/normal/28.ogg',
		'sound/machines/sm/accent/normal/29.ogg',
		'sound/machines/sm/accent/normal/30.ogg',
		'sound/machines/sm/accent/normal/31.ogg',
		'sound/machines/sm/accent/normal/32.ogg',
		'sound/machines/sm/accent/normal/33.ogg',
		//'sound/machines/sm/supermatter1.ogg',
		//'sound/machines/sm/supermatter2.ogg',
		//'sound/machines/sm/supermatter3.ogg',
	)

/datum/sound_effect/sm_delam
	key = SFX_SM_DELAM
	file_paths = list(
		'sound/machines/sm/accent/delam/1.ogg',
		'sound/machines/sm/accent/delam/2.ogg',
		'sound/machines/sm/accent/delam/3.ogg',
		'sound/machines/sm/accent/delam/4.ogg',
		'sound/machines/sm/accent/delam/5.ogg',
		'sound/machines/sm/accent/delam/6.ogg',
		'sound/machines/sm/accent/delam/7.ogg',
		'sound/machines/sm/accent/delam/8.ogg',
		'sound/machines/sm/accent/delam/9.ogg',
		'sound/machines/sm/accent/delam/10.ogg',
		'sound/machines/sm/accent/delam/11.ogg',
		'sound/machines/sm/accent/delam/12.ogg',
		'sound/machines/sm/accent/delam/13.ogg',
		'sound/machines/sm/accent/delam/14.ogg',
		'sound/machines/sm/accent/delam/15.ogg',
		'sound/machines/sm/accent/delam/16.ogg',
		'sound/machines/sm/accent/delam/17.ogg',
		'sound/machines/sm/accent/delam/18.ogg',
		'sound/machines/sm/accent/delam/19.ogg',
		'sound/machines/sm/accent/delam/20.ogg',
		'sound/machines/sm/accent/delam/21.ogg',
		'sound/machines/sm/accent/delam/22.ogg',
		'sound/machines/sm/accent/delam/23.ogg',
		'sound/machines/sm/accent/delam/24.ogg',
		'sound/machines/sm/accent/delam/25.ogg',
		'sound/machines/sm/accent/delam/26.ogg',
		'sound/machines/sm/accent/delam/27.ogg',
		'sound/machines/sm/accent/delam/28.ogg',
		'sound/machines/sm/accent/delam/29.ogg',
		'sound/machines/sm/accent/delam/30.ogg',
		'sound/machines/sm/accent/delam/31.ogg',
		'sound/machines/sm/accent/delam/32.ogg',
		'sound/machines/sm/accent/delam/33.ogg',
		//'sound/machines/sm/supermatter1.ogg',
		//'sound/machines/sm/supermatter2.ogg',
		//'sound/machines/sm/supermatter3.ogg',
	)

/datum/sound_effect/thunder
	key = SFX_THUNDER
	file_paths = list(
		'sound/effects/thunder/thunder1.ogg',
		'sound/effects/thunder/thunder2.ogg',
		'sound/effects/thunder/thunder3.ogg',
		'sound/effects/thunder/thunder4.ogg',
		'sound/effects/thunder/thunder5.ogg',
		'sound/effects/thunder/thunder6.ogg',
		'sound/effects/thunder/thunder7.ogg',
		'sound/effects/thunder/thunder8.ogg',
		'sound/effects/thunder/thunder9.ogg',
		'sound/effects/thunder/thunder10.ogg'
	)

/datum/sound_effect/fracture
	key = SFX_FRACTURE
	file_paths = list(
		'sound/effects/bonebreak1.ogg',
		'sound/effects/bonebreak2.ogg',
		'sound/effects/bonebreak3.ogg',
		'sound/effects/bonebreak4.ogg',
	)

/datum/sound_effect/mechstep
	key = SFX_MECHSTEP
	file_paths = list(
		'sound/mecha/mechstep1.ogg',
		'sound/mecha/mechstep2.ogg',
	)

//			if ("keyboard") soundin = pick('sound/effects/keyboard/keyboard1.ogg','sound/effects/keyboard/keyboard2.ogg','sound/effects/keyboard/keyboard3.ogg', 'sound/effects/keyboard/keyboard4.ogg')
//			if ("button") soundin = pick('sound/machines/button1.ogg','sound/machines/button2.ogg','sound/machines/button3.ogg','sound/machines/button4.ogg')
//			if ("switch") soundin = pick('sound/machines/switch1.ogg','sound/machines/switch2.ogg','sound/machines/switch3.ogg','sound/machines/switch4.ogg')

/datum/sound_effect/casing_sound
	key = SFX_CASING_SOUNDS
	file_paths = list(
		'sound/weapons/casingfall1.ogg',
		'sound/weapons/casingfall2.ogg',
		'sound/weapons/casingfall3.ogg',
	)

/datum/sound_effect/pickaxe
	key = SFX_PICKAXE
	file_paths = list(
		'sound/weapons/mine/pickaxe1.ogg',
		'sound/weapons/mine/pickaxe2.ogg',
		'sound/weapons/mine/pickaxe3.ogg',
		'sound/weapons/mine/pickaxe4.ogg',
	)

/datum/sound_effect/generic_drop
	key = SFX_GENERIC_DROP
	file_paths = list(
		'sound/items/drop/generic1.ogg',
		'sound/items/drop/generic2.ogg',
	)

/datum/sound_effect/generic_pickup
	key = SFX_GENERIC_PICKUP
	file_paths = list(
		'sound/items/pickup/generic1.ogg',
		'sound/items/pickup/generic2.ogg',
		'sound/items/pickup/generic3.ogg',
	)

/datum/sound_effect/bodyfall_sounds
	key = SFX_BODYFALL
	file_paths = list(
		'sound/effects/bodyfall/bodyfall1.ogg',
		'sound/effects/bodyfall/bodyfall2.ogg',
		'sound/effects/bodyfall/bodyfall3.ogg',
		'sound/effects/bodyfall/bodyfall4.ogg'
	)

/datum/sound_effect/teppi_sounds
	key = SFX_TEPPI
	file_paths = list(
		'sound/voice/teppi/gyooh1.ogg',
		'sound/voice/teppi/gyooh2.ogg',
		'sound/voice/teppi/gyooh3.ogg',
		'sound/voice/teppi/gyooh4.ogg',
		'sound/voice/teppi/gyooh5.ogg',
		'sound/voice/teppi/gyooh6.ogg',
		'sound/voice/teppi/snoot1.ogg',
		'sound/voice/teppi/snoot2.ogg'
	)

/datum/sound_effect/emote_sounds
	key = SFX_EMOTE
	file_paths = list(
		'sound/talksounds/me_a.ogg',
		'sound/talksounds/me_b.ogg',
		'sound/talksounds/me_c.ogg',
		'sound/talksounds/me_d.ogg',
		'sound/talksounds/me_e.ogg',
		'sound/talksounds/me_f.ogg'
	)

/// VORE SFX

/datum/sound_effect/hunger_sounds
	key = SFX_HUNGER_SOUNDS
	file_paths = list(
		'sound/vore/growl1.ogg',
		'sound/vore/growl2.ogg',
		'sound/vore/growl3.ogg',
		'sound/vore/growl4.ogg',
		'sound/vore/growl5.ogg',
	)

/datum/sound_effect/classic_digestion_sounds
	key = SFX_CLASSIC_DIGESTION_SOUNDS
	file_paths = list(
		'sound/vore/digest1.ogg',
		'sound/vore/digest2.ogg',
		'sound/vore/digest3.ogg',
		'sound/vore/digest4.ogg',
		'sound/vore/digest5.ogg',
		'sound/vore/digest6.ogg',
		'sound/vore/digest7.ogg',
		'sound/vore/digest8.ogg',
		'sound/vore/digest9.ogg',
		'sound/vore/digest10.ogg',
		'sound/vore/digest11.ogg',
		'sound/vore/digest12.ogg',
	)

/datum/sound_effect/classic_death_sounds
	key = SFX_CLASSIC_DEATH_SOUNDS
	file_paths = list(
		'sound/vore/death1.ogg',
		'sound/vore/death2.ogg',
		'sound/vore/death3.ogg',
		'sound/vore/death4.ogg',
		'sound/vore/death5.ogg',
		'sound/vore/death6.ogg',
		'sound/vore/death7.ogg',
		'sound/vore/death8.ogg',
		'sound/vore/death9.ogg',
		'sound/vore/death10.ogg',
	)

/datum/sound_effect/classic_struggle_sounds
	key = SFX_CLASSIC_STRUGGLE_SOUNDS
	file_paths = list(
		'sound/vore/squish1.ogg',
		'sound/vore/squish2.ogg',
		'sound/vore/squish3.ogg',
		'sound/vore/squish4.ogg',
	)

/datum/sound_effect/belches
	key = SFX_BELCHES
	file_paths = list(
		'sound/vore/belches/belch1.ogg',
		'sound/vore/belches/belch2.ogg',
		'sound/vore/belches/belch3.ogg',
		'sound/vore/belches/belch4.ogg',
		'sound/vore/belches/belch5.ogg',
		'sound/vore/belches/belch6.ogg',
		'sound/vore/belches/belch7.ogg',
		'sound/vore/belches/belch8.ogg',
		'sound/vore/belches/belch9.ogg',
		'sound/vore/belches/belch10.ogg',
		'sound/vore/belches/belch11.ogg',
		'sound/vore/belches/belch12.ogg',
		'sound/vore/belches/belch13.ogg',
		'sound/vore/belches/belch14.ogg',
		'sound/vore/belches/belch15.ogg',
	)

/datum/sound_effect/fancy_prey_struggle
	key = SFX_FANCY_PREY_STRUGGLE
	file_paths = list(
		'sound/vore/sunesound/prey/struggle_01.ogg',
		'sound/vore/sunesound/prey/struggle_02.ogg',
		'sound/vore/sunesound/prey/struggle_03.ogg',
		'sound/vore/sunesound/prey/struggle_04.ogg',
		'sound/vore/sunesound/prey/struggle_05.ogg',
	)

/datum/sound_effect/fancy_digest_pred
	key = SFX_FANCY_DIGEST_PRED
	file_paths = list(
		'sound/vore/sunesound/pred/digest_01.ogg',
		'sound/vore/sunesound/pred/digest_02.ogg',
		'sound/vore/sunesound/pred/digest_03.ogg',
		'sound/vore/sunesound/pred/digest_04.ogg',
		'sound/vore/sunesound/pred/digest_05.ogg',
		'sound/vore/sunesound/pred/digest_06.ogg',
		'sound/vore/sunesound/pred/digest_07.ogg',
		'sound/vore/sunesound/pred/digest_08.ogg',
		'sound/vore/sunesound/pred/digest_09.ogg',
		'sound/vore/sunesound/pred/digest_10.ogg',
		'sound/vore/sunesound/pred/digest_11.ogg',
		'sound/vore/sunesound/pred/digest_12.ogg',
		'sound/vore/sunesound/pred/digest_13.ogg',
		'sound/vore/sunesound/pred/digest_14.ogg',
		'sound/vore/sunesound/pred/digest_15.ogg',
		'sound/vore/sunesound/pred/digest_16.ogg',
		'sound/vore/sunesound/pred/digest_17.ogg',
		'sound/vore/sunesound/pred/digest_18.ogg',
	)

/datum/sound_effect/fancy_death_pred
	key = SFX_FANCY_DEATH_PRED
	file_paths = list(
		'sound/vore/sunesound/pred/death_01.ogg',
		'sound/vore/sunesound/pred/death_02.ogg',
		'sound/vore/sunesound/pred/death_03.ogg',
		'sound/vore/sunesound/pred/death_04.ogg',
		'sound/vore/sunesound/pred/death_05.ogg',
		'sound/vore/sunesound/pred/death_06.ogg',
		'sound/vore/sunesound/pred/death_07.ogg',
		'sound/vore/sunesound/pred/death_08.ogg',
		'sound/vore/sunesound/pred/death_09.ogg',
		'sound/vore/sunesound/pred/death_10.ogg',
	)

/datum/sound_effect/fancy_digest_prey
	key = SFX_FANCY_DIGEST_PREY
	file_paths = list(
		'sound/vore/sunesound/prey/digest_01.ogg',
		'sound/vore/sunesound/prey/digest_02.ogg',
		'sound/vore/sunesound/prey/digest_03.ogg',
		'sound/vore/sunesound/prey/digest_04.ogg',
		'sound/vore/sunesound/prey/digest_05.ogg',
		'sound/vore/sunesound/prey/digest_06.ogg',
		'sound/vore/sunesound/prey/digest_07.ogg',
		'sound/vore/sunesound/prey/digest_08.ogg',
		'sound/vore/sunesound/prey/digest_09.ogg',
		'sound/vore/sunesound/prey/digest_10.ogg',
		'sound/vore/sunesound/prey/digest_11.ogg',
		'sound/vore/sunesound/prey/digest_12.ogg',
		'sound/vore/sunesound/prey/digest_13.ogg',
		'sound/vore/sunesound/prey/digest_14.ogg',
		'sound/vore/sunesound/prey/digest_15.ogg',
		'sound/vore/sunesound/prey/digest_16.ogg',
		'sound/vore/sunesound/prey/digest_17.ogg',
		'sound/vore/sunesound/prey/digest_18.ogg',
	)

/datum/sound_effect/fancy_death_prey
	key = SFX_FANCY_DEATH_PREY
	file_paths = list(
		'sound/vore/sunesound/prey/death_01.ogg',
		'sound/vore/sunesound/prey/death_02.ogg',
		'sound/vore/sunesound/prey/death_03.ogg',
		'sound/vore/sunesound/prey/death_04.ogg',
		'sound/vore/sunesound/prey/death_05.ogg',
		'sound/vore/sunesound/prey/death_06.ogg',
		'sound/vore/sunesound/prey/death_07.ogg',
		'sound/vore/sunesound/prey/death_08.ogg',
		'sound/vore/sunesound/prey/death_09.ogg',
		'sound/vore/sunesound/prey/death_10.ogg',
	)
