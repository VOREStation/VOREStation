/datum/decl/emote/audible
	key = "burp"
	emote_message_3p = "burps."
	message_type = AUDIBLE_MESSAGE

/datum/decl/emote/audible/New()
	. = ..()
	// Snips the 'USER' from 3p emote messages for radio.
	if(!emote_message_radio && emote_message_3p)
		emote_message_radio = emote_message_3p
	if(!emote_message_radio_synthetic && emote_message_synthetic_3p)
		emote_message_radio_synthetic = emote_message_synthetic_3p

/datum/decl/emote/audible/deathgasp_alien
	key = "adeathgasp"
	emote_message_3p = "lets out a waning guttural screech, green blood bubbling from its maw."

/datum/decl/emote/audible/whimper
	key = "whimper"
	emote_message_3p = "whimpers."

/datum/decl/emote/audible/gasp
	key = "gasp"
	emote_message_3p = "gasps."
	conscious = FALSE

/datum/decl/emote/audible/gasp/get_emote_sound(var/atom/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/vol = H.species.gasp_volume
		var/s = get_species_sound(get_gendered_sound(H))["gasp"]
		if(!s && !(get_species_sound(H.species.species_sounds) == "None")) // Failsafe, so we always use the default gasp/etc sounds. None will cancel out anyways.
			if(H.identifying_gender == FEMALE)
				s = get_species_sound("Human Female")["gasp"]
			else // Update this if we ever get herm/etc sounds.
				s = get_species_sound("Human Male")["gasp"]
		return list(
				"sound" = s,
				"vol" = vol,
				"volchannel" = VOLUME_CHANNEL_SPECIES_SOUNDS
			)

/datum/decl/emote/audible/scretch
	key = "scretch"
	emote_message_3p = "scretches."

/datum/decl/emote/audible/choke
	key = "choke"
	emote_message_3p = "chokes."
	conscious = FALSE

/datum/decl/emote/audible/gnarl
	key = "gnarl"
	emote_message_3p = "gnarls and shows USER_THEIR teeth."

/datum/decl/emote/audible/multichirp
	key = "mchirp"
	emote_message_3p = "chirps a chorus of notes!"
	emote_sound = 'sound/voice/multichirp.ogg'

/datum/decl/emote/audible/alarm
	key = "alarm"
	emote_message_1p = "You sound an alarm."
	emote_message_3p = "sounds an alarm."

/datum/decl/emote/audible/alert
	key = "alert"
	emote_message_1p = "You let out a distressed noise."
	emote_message_3p = "lets out a distressed noise."

/datum/decl/emote/audible/notice
	key = "notice"
	emote_message_1p = "You play a loud tone."
	emote_message_3p = "plays a loud tone."

/datum/decl/emote/audible/boop
	key = "boop"
	emote_message_1p = "You boop."
	emote_message_3p = "boops."

/datum/decl/emote/audible/beep
	key = "bbeep"
	emote_message_3p = "You beep."
	emote_message_3p = "beeps."
	emote_sound = 'sound/machines/twobeep.ogg'

/datum/decl/emote/audible/sniff
	key = "sniff"
	emote_message_3p = "sniffs."

/datum/decl/emote/audible/snore
	key = "snore"
	emote_message_3p = "snores."
	conscious = FALSE

/datum/decl/emote/audible/whimper
	key = "whimper"
	emote_message_3p = "whimpers."

/datum/decl/emote/audible/yawn
	key = "yawn"
	emote_message_3p = "yawns."

/datum/decl/emote/audible/clap
	key = "clap"
	emote_message_3p = "claps."

/datum/decl/emote/audible/chuckle
	key = "chuckle"
	emote_message_3p = "chuckles."

/datum/decl/emote/audible/cry
	key = "cry"
	emote_message_3p = "cries."

/datum/decl/emote/audible/sigh
	key = "sigh"
	emote_message_3p = "sighs."

/datum/decl/emote/audible/laugh
	key = "laugh"
	emote_message_3p_target = "laughs at TARGET."
	emote_message_3p = "laughs."

/datum/decl/emote/audible/mumble
	key = "mumble"
	emote_message_3p = "mumbles!"

/datum/decl/emote/audible/grumble
	key = "grumble"
	emote_message_3p = "grumbles!"

/datum/decl/emote/audible/groan
	key = "groan"
	emote_message_3p = "groans!"
	conscious = FALSE

/datum/decl/emote/audible/moan
	key = "moan"
	emote_message_3p = "moans!"
	conscious = FALSE

/datum/decl/emote/audible/giggle
	key = "giggle"
	emote_message_3p = "giggles."

/datum/decl/emote/audible/grunt
	key = "grunt"
	emote_message_3p = "grunts."

/datum/decl/emote/audible/bug_hiss
	key = "bhiss"
	emote_message_3p_target = "hisses at TARGET."
	emote_message_3p = "hisses."
	emote_sound = 'sound/voice/bughiss.ogg'

/datum/decl/emote/audible/bug_buzz
	key = "bbuzz"
	emote_message_3p = "buzzes USER_THEIR wings."
	emote_sound = 'sound/voice/BugBuzz.ogg'

/datum/decl/emote/audible/bug_chitter
	key = "chitter"
	emote_message_3p = "chitters."
	emote_sound = 'sound/voice/bug.ogg'

/datum/decl/emote/audible/roar
	key = "roar"
	emote_message_3p = "roars!"

/datum/decl/emote/audible/bellow
	key = "bellow"
	emote_message_3p = "bellows!"

/datum/decl/emote/audible/howl
	key = "howl"
	emote_message_3p = "howls!"

/datum/decl/emote/audible/wheeze
	key = "wheeze"
	emote_message_3p = "wheezes."

/datum/decl/emote/audible/hiss
	key = "hiss"
	emote_message_3p_target = "hisses softly at TARGET."
	emote_message_3p = "hisses softly."

/datum/decl/emote/audible/chirp
	key = "chirp"
	emote_message_3p = "chirps!"
	emote_sound = 'sound/misc/nymphchirp.ogg'

/datum/decl/emote/audible/crack
	key = "crack"
	emote_message_3p = "cracks USER_THEIR knuckles."
	emote_sound = 'sound/voice/knuckles.ogg'

/datum/decl/emote/audible/squish
	key = "squish"
	emote_sound = 'sound/effects/slime_squish.ogg' //Credit to DrMinky (freesound.org) for the sound.
	emote_message_3p = "squishes."
	sound_vary = FALSE

/datum/decl/emote/audible/warble
	key = "warble"
	emote_sound = 'sound/effects/warble.ogg' // Copyright CC BY 3.0 alienistcog (freesound.org) for the sound.
	emote_message_3p = "warbles."

/datum/decl/emote/audible/croon
	key = "croon"
	emote_message_3p = "croons..."
	emote_sound = list('sound/voice/croon1.ogg', 'sound/voice/croon2.ogg')

/datum/decl/emote/audible/lwarble
	key = "lwarble"
	emote_message_3p = "lets out a low, throaty warble!"
	emote_sound = 'sound/voice/lwarble.ogg'

/datum/decl/emote/audible/croak_skrell
	key = "scroak"
	emote_message_3p = "croaks!"
	emote_sound = 'sound/voice/croak_skrell.ogg'

/datum/decl/emote/audible/vox_shriek
	key = "shriek"
	emote_message_3p = "SHRIEKS!"
	emote_sound = 'sound/voice/shriek1.ogg'

/datum/decl/emote/audible/caw
	key = "caw"
	emote_message_1p = "You caw!"
	emote_message_3p = "caws!"
	emote_message_1p_target = "You caw at TARGET."
	emote_message_3p_target = "caws at TARGET."
	emote_sound = 'sound/voice/emotes/caw1.ogg' // Copyright Sampling+ 1.0 Vixuxx (freesound.org) for the source audio.

/datum/decl/emote/audible/caw2
	key = "caw2"
	emote_message_3p = "caws."
	emote_sound = 'sound/voice/emotes/caw2.ogg'  // Copyright CC0 1.0 Universal, by Jofae on freesound.org.


/datum/decl/emote/audible/caw_m
	key = "caw_m"
	emote_message_3p = "caws multiple times."
	emote_sound = 'sound/voice/emotes/caw_multiple.ogg' // Copyright CC0 1.0 Universal, by Ambientsoundapp on freesound.org.

/datum/decl/emote/audible/gwah
	key = "gwah"
	emote_message_3p = "gwah."
	emote_sound = 'sound/voice/emotes/gwah.ogg' // Copyright CC0 1.0 Universal, by Ambientsoundapp on freesound.org.


/datum/decl/emote/audible/purr
	key = "purr"
	emote_message_3p = "purrs."
	emote_sound = 'sound/voice/cat_purr.ogg'

/datum/decl/emote/audible/purrlong
	key = "purrl"
	emote_message_3p = "purrs."
	emote_sound = 'sound/voice/cat_purr_long.ogg'

/datum/decl/emote/audible/fennecscream
	key = "fennecscream"
	emote_message_3p = "screeches!"

/datum/decl/emote/audible/zoom
	key = "zoom"
	emote_message_3p = "zooms."

/datum/decl/emote/audible/teshsqueak
	key = "surprised"
	emote_message_1p = "You chirp in surprise!"
	emote_message_3p = "chirps in surprise!"
	emote_message_1p_target = "You chirp in surprise at TARGET!"
	emote_message_3p_target = "chirps in surprise at TARGET!"
	emote_sound = 'sound/voice/teshsqueak.ogg' // Copyright CC BY 3.0 InspectorJ (freesound.org) for the source audio.
	sound_vary = FALSE

/datum/decl/emote/audible/teshchirp
	key = "tchirp"
	emote_message_1p = "You chirp!"
	emote_message_3p = "chirps!"
	emote_message_1p_target = "You chirp at TARGET!"
	emote_message_3p_target = "chirps at TARGET!"
	emote_sound = 'sound/voice/teshchirp.ogg' // Copyright Sampling+ 1.0 Incarnidine (freesound.org) for the source audio.

/datum/decl/emote/audible/teshtrill
	key = "trill"
	emote_message_1p = "You trill."
	emote_message_3p = "trills."
	emote_message_1p_target = "You trill at TARGET."
	emote_message_3p_target = "trills at TARGET."
	emote_sound = 'sound/voice/teshtrill.ogg' // Copyright CC BY-NC 3.0 Arnaud Coutancier (freesound.org) for the source audio.

/datum/decl/emote/audible/teshscream
	key = "teshscream"
	emote_message_1p = "You scream!"
	emote_message_3p = "screams!"
	emote_sound = 'sound/voice/teshscream.ogg'

/datum/decl/emote/audible/prbt
	key = "prbt"
	emote_message_1p = "You prbt."
	emote_message_3p = "prbts."
	emote_message_1p_target = "You prbt at TARGET."
	emote_message_3p_target = "prbts at TARGET."
	emote_sound = 'sound/voice/prbt.ogg'

//Some Spooky sounds.
/datum/decl/emote/audible/evil_laugh
	key = "evillaugh"
	emote_message_3p = "laughs!"
	emote_sound = 'sound/mob/spooky/laugh.ogg'

/datum/decl/emote/audible/evil_no
	key = "evilno"
	emote_message_3p = "says no!"
	emote_sound = 'sound/mob/spooky/no.ogg'

/datum/decl/emote/audible/evil_breathing
	key = "evilbreath"
	emote_message_3p = "breaths heavily!"
	emote_sound = 'sound/mob/spooky/breath1.ogg'

/datum/decl/emote/audible/evil_breathing_2
	key = "evilbreath2"
	emote_message_3p = "breaths heavily!"
	emote_sound = 'sound/mob/spooky/breath2.ogg'

/datum/decl/emote/audible/goodripsound
	key = "goodripsound"
	emote_message_3p = "drips goo."

/datum/decl/emote/audible/goodripsound/do_extra(var/mob/user)
	..()
	var/goo_sounds = list (
			'sound/mob/spooky/decay1.ogg',
			'sound/mob/spooky/decay2.ogg',
			'sound/mob/spooky/decay3.ogg',
			'sound/mob/spooky/corrosion1.ogg',
			'sound/mob/spooky/corrosion2.ogg',
			'sound/mob/spooky/corrosion3.ogg'
			)
	var/sound = pick(goo_sounds)
	playsound(user.loc, sound, 100, 1)
