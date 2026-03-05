/datum/decl/emote/visible
	key = "tail"
	emote_message_3p = "waves USER_THEIR tail."
	message_type = VISIBLE_MESSAGE

/datum/decl/emote/visible/scratch
	key = "scratch"
	check_restraints = TRUE
	emote_message_3p = "scratches."

/datum/decl/emote/visible/drool
	key = "drool"
	emote_message_3p = "drools."
	conscious = FALSE

/datum/decl/emote/visible/nod
	key = "nod"
	emote_message_3p_target = "nods USER_THEIR head at TARGET."
	emote_message_3p = "nods USER_THEIR head."

/datum/decl/emote/visible/sway
	key = "sways"
	emote_message_3p = "sways around dizzily."

/datum/decl/emote/visible/sulk
	key = "sulk"
	emote_message_3p = "sulks down sadly."

/datum/decl/emote/visible/dance
	key = "dance"
	check_restraints = TRUE
	emote_message_3p = "dances around happily."

/datum/decl/emote/visible/roll
	key = "roll"
	check_restraints = TRUE
	emote_message_3p = "rolls."

/datum/decl/emote/visible/shake
	key = "shake"
	emote_message_3p = "shakes USER_THEIR head."

/datum/decl/emote/visible/jump
	key = "jump"
	emote_message_3p = "jumps!"

/datum/decl/emote/visible/shiver
	key = "shiver"
	emote_message_3p = "shivers."
	conscious = FALSE

/datum/decl/emote/visible/collapse
	key = "collapse"
	emote_message_3p = "collapses!"

/datum/decl/emote/visible/collapse/do_extra(var/mob/user)
	..()
	if(istype(user))
		user.Paralyse(2)
		user.Sleeping(2)

/datum/decl/emote/visible/flash
	key = "flash"
	emote_message_3p = "flash USER_THEIR lights quickly."

/datum/decl/emote/visible/blink
	key = "blink"
	emote_message_3p = "blinks."

/datum/decl/emote/visible/airguitar
	key = "airguitar"
	check_restraints = TRUE
	emote_message_3p = "is strumming the air and headbanging like a safari chimp."

/datum/decl/emote/visible/blink_r
	key = "blink_r"
	emote_message_3p = "blinks rapidly."

/datum/decl/emote/visible/bow
	key = "bow"
	emote_message_3p_target = "bows to TARGET."
	emote_message_3p = "bows."

/datum/decl/emote/visible/salute
	key = "salute"
	emote_message_3p_target = "salutes TARGET."
	emote_message_3p = "salutes."
	check_restraints = TRUE

/datum/decl/emote/visible/flap
	key = "flap"
	check_restraints = TRUE
	emote_message_3p = "flaps USER_THEIR wings."

/datum/decl/emote/visible/aflap
	key = "aflap"
	check_restraints = TRUE
	emote_message_3p = "flaps USER_THEIR wings ANGRILY!"

/datum/decl/emote/visible/eyebrow
	key = "eyebrow"
	emote_message_3p = "raises an eyebrow."

/datum/decl/emote/visible/twitch
	key = "twitch"
	emote_message_3p = "twitches."
	conscious = FALSE

/datum/decl/emote/visible/twitch_v
	key = "twitch_v"
	emote_message_3p = "twitches violently."
	conscious = FALSE

/datum/decl/emote/visible/faint
	key = "faint"
	emote_message_3p = "faints."

/datum/decl/emote/visible/faint/do_extra(var/mob/user)
	. = ..()
	if(iscarbon(user) && !user.sleeping)
		user.Sleeping(10)

/datum/decl/emote/visible/frown
	key = "frown"
	emote_message_3p = "frowns."

/datum/decl/emote/visible/blush
	key = "blush"
	emote_message_3p = "blushes."

/datum/decl/emote/visible/wave
	key = "wave"
	emote_message_3p_target = "waves at TARGET."
	emote_message_3p = "waves."
	check_restraints = TRUE

/datum/decl/emote/visible/glare
	key = "glare"
	emote_message_3p_target = "glares at TARGET."
	emote_message_3p = "glares."

/datum/decl/emote/visible/stare
	key = "stare"
	emote_message_3p_target = "stares at TARGET."
	emote_message_3p = "stares."

/datum/decl/emote/visible/look
	key = "look"
	emote_message_3p_target = "looks at TARGET."
	emote_message_3p = "looks."

/datum/decl/emote/visible/point
	key = "point"
	check_restraints = TRUE
	emote_message_3p_target = "points to TARGET."
	emote_message_3p = "points."

/datum/decl/emote/visible/raise
	key = "raise"
	check_restraints = TRUE
	emote_message_3p = "raises a hand."

/datum/decl/emote/visible/grin
	key = "grin"
	emote_message_3p_target = "grins at TARGET."
	emote_message_3p = "grins."

/datum/decl/emote/visible/shrug
	key = "shrug"
	emote_message_3p = "shrugs."

/datum/decl/emote/visible/smile
	key = "smile"
	emote_message_3p_target = "smiles at TARGET."
	emote_message_3p = "smiles."

/datum/decl/emote/visible/pale
	key = "pale"
	emote_message_3p = "goes pale for a second."

/datum/decl/emote/visible/tremble
	key = "tremble"
	emote_message_3p = "trembles in fear!"

/datum/decl/emote/visible/wink
	key = "wink"
	emote_message_3p_target = "winks at TARGET."
	emote_message_3p = "winks."

/datum/decl/emote/visible/hug
	key = "hug"
	check_restraints = TRUE
	emote_message_3p_target = "hugs TARGET."
	emote_message_3p = "hugs USER_SELF."
	check_range = 1

/datum/decl/emote/visible/dap
	key = "dap"
	check_restraints = TRUE
	emote_message_3p_target = "gives daps to TARGET."
	emote_message_3p = "sadly can't find anybody to give daps to, and daps USER_SELF."

/datum/decl/emote/visible/bounce
	key = "bounce"
	emote_message_3p = "bounces in place."

/datum/decl/emote/visible/jiggle
	key = "jiggle"
	emote_message_3p = "jiggles!"

/datum/decl/emote/visible/lightup
	key = "light"
	emote_message_3p = "lights up for a bit, then stops."

/datum/decl/emote/visible/vibrate
	key = "vibrate"
	emote_message_3p = "vibrates!"

/datum/decl/emote/visible/deathgasp_robot
	key = "rdeathgasp"
	emote_message_3p = "shudders violently for a moment, then becomes motionless, USER_THEIR eyes slowly darkening."

/datum/decl/emote/visible/handshake
	key = "handshake"
	check_restraints = TRUE
	emote_message_3p_target = "shakes hands with TARGET."
	emote_message_3p = "shakes hands with USER_SELF."
	check_range = 1

/datum/decl/emote/visible/handshake/get_emote_message_3p(var/atom/user, var/atom/target, var/extra_params)
	if(target && !user.Adjacent(target))
		return "holds out USER_THEIR hand out to TARGET."
	return ..()

/datum/decl/emote/visible/signal
	key = "signal"
	emote_message_3p_target = "signals at TARGET."
	emote_message_3p = "signals."
	check_restraints = TRUE

/datum/decl/emote/visible/signal/get_emote_message_3p(var/mob/living/user, var/atom/target, var/extra_params)
	if(istype(user) && (!user.get_active_hand() || !user.get_inactive_hand()))
		var/t1 = round(text2num(extra_params))
		if(isnum(t1) && t1 <= 5)
			return "raises [t1] finger\s."
	return .. ()

/datum/decl/emote/visible/afold
	key = "afold"
	check_restraints = TRUE
	emote_message_3p = "folds USER_THEIR arms."

/datum/decl/emote/visible/alook
	key = "alook"
	emote_message_3p = "looks away."

/datum/decl/emote/visible/hbow
	key = "hbow"
	emote_message_3p = "bows USER_THEIR head."

/datum/decl/emote/visible/hip
	key = "hip"
	check_restraints = TRUE
	emote_message_3p = "puts USER_THEIR hands on USER_THEIR hips."

/datum/decl/emote/visible/holdup
	key = "holdup"
	check_restraints = TRUE
	emote_message_3p = "holds up USER_THEIR palms."

/datum/decl/emote/visible/hshrug
	key = "hshrug"
	emote_message_3p = "gives a half shrug."

/datum/decl/emote/visible/crub
	key = "crub"
	check_restraints = TRUE
	emote_message_3p = "rubs USER_THEIR chin."

/datum/decl/emote/visible/eroll
	key = "eroll"
	emote_message_3p = "rolls USER_THEIR eyes."
	emote_message_3p_target = "rolls USER_THEIR eyes at TARGET."

/datum/decl/emote/visible/erub
	key = "erub"
	check_restraints = TRUE
	emote_message_3p = "rubs USER_THEIR eyes."

/datum/decl/emote/visible/fslap
	key = "fslap"
	check_restraints = TRUE
	emote_message_3p = "slaps USER_THEIR forehead."

/datum/decl/emote/visible/ftap
	key = "ftap"
	emote_message_3p = "taps USER_THEIR foot."

/datum/decl/emote/visible/hrub
	key = "hrub"
	check_restraints = TRUE
	emote_message_3p = "rubs USER_THEIR hands together."

/datum/decl/emote/visible/hspread
	key = "hspread"
	check_restraints = TRUE
	emote_message_3p = "spreads USER_THEIR hands."

/datum/decl/emote/visible/pocket
	key = "pocket"
	check_restraints = TRUE
	emote_message_3p = "shoves USER_THEIR hands in USER_THEIR pockets."

/datum/decl/emote/visible/rsalute
	key = "rsalute"
	check_restraints = TRUE
	emote_message_3p = "returns the salute."

/datum/decl/emote/visible/rshoulder
	key = "rshoulder"
	emote_message_3p = "rolls USER_THEIR shoulders."

/datum/decl/emote/visible/squint
	key = "squint"
	emote_message_3p = "squints."
	emote_message_3p_target = "squints at TARGET."

/datum/decl/emote/visible/tfist
	key = "tfist"
	emote_message_3p = "tightens USER_THEIR hands into fists."

/datum/decl/emote/visible/tilt
	key = "tilt"
	emote_message_3p = "tilts USER_THEIR head."

/datum/decl/emote/visible/goodrip
	key = "goodrip"
	emote_message_3p = "drips goo."

/datum/decl/emote/visible/goodrip/do_extra(var/mob/user)
	..()
	new /obj/effect/decal/cleanable/blood/oil(user)
	var/goo_sounds = list (
			'sound/mob/spooky/decay1.ogg',
			'sound/mob/spooky/decay2.ogg',
			'sound/mob/spooky/decay3.ogg'
			)
	var/sound = pick(goo_sounds)
	playsound(user.loc, sound, 100, 1)
