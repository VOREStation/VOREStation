/*
 * Player speaking list, character creation
*/
GLOBAL_LIST_INIT(talk_sound, list('sound/talksounds/a.ogg','sound/talksounds/b.ogg','sound/talksounds/c.ogg','sound/talksounds/d.ogg','sound/talksounds/e.ogg','sound/talksounds/f.ogg','sound/talksounds/g.ogg','sound/talksounds/h.ogg'))
GLOBAL_LIST_INIT(xeno_speak_sound, list('sound/talksounds/xeno/xenotalk.ogg', 'sound/talksounds/xeno/xenotalk2.ogg', 'sound/talksounds/xeno/xenotalk3.ogg'))
GLOBAL_LIST_INIT(keyboard_sound, list('sound/effects/keyboard/keyboard1.ogg','sound/effects/keyboard/keyboard2.ogg','sound/effects/keyboard/keyboard3.ogg', 'sound/effects/keyboard/keyboard4.ogg'))
GLOBAL_LIST_INIT(bodyfall_sound, list('sound/effects/bodyfall1.ogg','sound/effects/bodyfall2.ogg','sound/effects/bodyfall3.ogg','sound/effects/bodyfall4.ogg'))
GLOBAL_LIST_INIT(teppi_sound, list('sound/voice/teppi/gyooh1.ogg', 'sound/voice/teppi/gyooh2.ogg', 'sound/voice/teppi/gyooh3.ogg', 'sound/voice/teppi/gyooh4.ogg', 'sound/voice/teppi/gyooh5.ogg', 'sound/voice/teppi/gyooh6.ogg', 'sound/voice/teppi/snoot1.ogg', 'sound/voice/teppi/snoot2.ogg'))
GLOBAL_LIST_INIT(emote_sound, list('sound/talksounds/me_a.ogg','sound/talksounds/me_b.ogg','sound/talksounds/me_c.ogg','sound/talksounds/me_d.ogg','sound/talksounds/me_e.ogg','sound/talksounds/me_f.ogg'))

GLOBAL_LIST_INIT(wf_speak_lure_sound, list ('sound/talksounds/wf/lure_1.ogg', 'sound/talksounds/wf/lure_2.ogg', 'sound/talksounds/wf/lure_3.ogg', 'sound/talksounds/wf/lure_4.ogg', 'sound/talksounds/wf/lure_5.ogg'))
GLOBAL_LIST_INIT(wf_speak_lyst_sound, list ('sound/talksounds/wf/lyst_1.ogg', 'sound/talksounds/wf/lyst_2.ogg', 'sound/talksounds/wf/lyst_3.ogg', 'sound/talksounds/wf/lyst_4.ogg', 'sound/talksounds/wf/lyst_5.ogg', 'sound/talksounds/wf/lyst_6.ogg'))
GLOBAL_LIST_INIT(wf_speak_void_sound, list ('sound/talksounds/wf/void_1.ogg', 'sound/talksounds/wf/void_2.ogg', 'sound/talksounds/wf/void_3.ogg'))
GLOBAL_LIST_INIT(wf_speak_vomva_sound, list ('sound/talksounds/wf/vomva_1.ogg', 'sound/talksounds/wf/vomva_2.ogg', 'sound/talksounds/wf/vomva_3.ogg', 'sound/talksounds/wf/vomva_4.ogg'))

/hook/startup/proc/create_talk_sound_map()
	GLOB.talk_sound_map["beep-boop"] = GLOB.talk_sound // first is DEFAULT
	GLOB.talk_sound_map["goon speak 1"] =list('sound/talksounds/goon/speak_1.ogg', 'sound/talksounds/goon/speak_1_ask.ogg', 'sound/talksounds/goon/speak_1_exclaim.ogg')
	GLOB.talk_sound_map["goon speak 2"] = list('sound/talksounds/goon/speak_2.ogg', 'sound/talksounds/goon/speak_2_ask.ogg', 'sound/talksounds/goon/speak_2_exclaim.ogg')
	GLOB.talk_sound_map["goon speak 3"] = list('sound/talksounds/goon/speak_3.ogg', 'sound/talksounds/goon/speak_3_ask.ogg', 'sound/talksounds/goon/speak_3_exclaim.ogg')
	GLOB.talk_sound_map["goon speak 4"] = list('sound/talksounds/goon/speak_4.ogg', 'sound/talksounds/goon/speak_4_ask.ogg', 'sound/talksounds/goon/speak_4_exclaim.ogg')
	GLOB.talk_sound_map["goon speak blub"] = list('sound/talksounds/goon/blub.ogg', 'sound/talksounds/goon/blub_ask.ogg', 'sound/talksounds/goon/blub_exclaim.ogg')
	GLOB.talk_sound_map["goon speak bottalk"] = list('sound/talksounds/goon/bottalk_1.ogg', 'sound/talksounds/goon/bottalk_2.ogg', 'sound/talksounds/goon/bottalk_3.ogg', 'sound/talksounds/goon/bottalk_4.wav')
	GLOB.talk_sound_map["goon speak buwoo"] = list('sound/talksounds/goon/buwoo.ogg', 'sound/talksounds/goon/buwoo_ask.ogg', 'sound/talksounds/goon/buwoo_exclaim.ogg')
	GLOB.talk_sound_map["goon speak cow"] = list('sound/talksounds/goon/cow.ogg', 'sound/talksounds/goon/cow_ask.ogg', 'sound/talksounds/goon/cow_exclaim.ogg')
	GLOB.talk_sound_map["goon speak lizard"] = list('sound/talksounds/goon/lizard.ogg', 'sound/talksounds/goon/lizard_ask.ogg', 'sound/talksounds/goon/lizard_exclaim.ogg')
	GLOB.talk_sound_map["goon speak pug"] = list('sound/talksounds/goon/pug.ogg', 'sound/talksounds/goon/pug_ask.ogg', 'sound/talksounds/goon/pug_exclaim.ogg')
	GLOB.talk_sound_map["goon speak pugg"] = list('sound/talksounds/goon/pugg.ogg', 'sound/talksounds/goon/pugg_ask.ogg', 'sound/talksounds/goon/pugg_exclaim.ogg')
	GLOB.talk_sound_map["goon speak roach"] = list('sound/talksounds/goon/roach.ogg', 'sound/talksounds/goon/roach_ask.ogg', 'sound/talksounds/goon/roach_exclaim.ogg')
	GLOB.talk_sound_map["goon speak skelly"] = list('sound/talksounds/goon/skelly.ogg', 'sound/talksounds/goon/skelly_ask.ogg', 'sound/talksounds/goon/skelly_exclaim.ogg')
	GLOB.talk_sound_map["xeno speak"] = GLOB.xeno_speak_sound
