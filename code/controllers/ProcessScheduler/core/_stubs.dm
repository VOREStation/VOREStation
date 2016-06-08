/**
 * _stubs.dm
 *
 * This file contains constructs that the process scheduler expects to exist
 * in a standard ss13 fork.
 */

/**
 * logTheThing
 *
 * In goonstation, this proc writes a message to either the world log or diary.
 *
 * Blame Keelin.
 */
/proc/logTheThing(type, source, target, text, diaryType)
	if(diaryType)
		log_debug("Diary: \[[diaryType]:[type]] [text]")
	else
		log_debug("Log: \[[type]] [text]")
