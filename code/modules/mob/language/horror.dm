/datum/language/redspace
	name = LANGUAGE_REDSPACE
	desc = "An incurable corruption spread to one's mind and body. It's all you can speak, now. Why would you want to speak anything else?"
	speech_verb = "wails"
	colour = "cult"
	key = "F"
	flags = RESTRICTED | NONVERBAL | HIVEMIND | NO_STUTTER
	//copy and past cultish because i'm lazy...Nobody but people with it should be able to hear you say it anyway.
	syllables = list("ire","ego","nahlizet","certum","veri","jatkaa","mgar","balaq", "karazet", "geeri", \
		"orkan", "allaq", "sas'so", "c'arta", "forbici", "tarem", "n'ath", "reth", "sh'yro", "eth", "d'raggathnor", \
		"mah'weyh", "pleggh", "at", "e'ntrath", "tok-lyr", "rqa'nap", "g'lt-ulotf", "ta'gh", "fara'qha", "fel", "d'amar det", \
		"yu'gular", "faras", "desdae", "havas", "mithum", "javara", "umathar", "uf'kal", "thenar", "rash'tla", \
		"sektath", "mal'zua", "zasan", "therium", "viortia", "kla'atu", "barada", "nikt'o", "fwe'sh", "mah", "erl", "nyag", "r'ya", \
		"gal'h'rfikk", "harfrandid", "mud'gib", "il", "fuu", "ma'jin", "dedo", "ol'btoh", "n'ath", "reth", "sh'yro", "eth", \
		"d'rekkathnor", "khari'd", "gual'te", "nikka", "nikt'o", "barada", "kla'atu", "barhah", "hra" ,"zar'garis", "spiri", "malum")

//Special, spooky effects when you speak.
/datum/language/redspace/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	if(prob(10))
		speaker.hallucination += 5

	if(prob(5))
		speaker.visible_message(span_danger("[speaker] suddenly " + pick("writhes", "twitches", "shudders", "quivers", "contorts unnaturally")))
	else if(ishuman(speaker))
		var/mob/living/carbon/human/human_speaker = speaker
		if(prob(1))
			human_speaker.drip(1)
			var/turf/T = get_turf(human_speaker)
			if(T)
				var/obj/effect/spider/spiderling/non_growing/horror/spider = new /obj/effect/spider/spiderling/non_growing/horror(get_turf(human_speaker))
				spider.faction = human_speaker.faction
				spider.color = "[human_speaker.species.blood_color]"
				spider.name = "writhing tendril mass"
				spider.desc = "A small, writhing mass of flesh and tendrils."
				var/obj/item/organ/external/head/head = human_speaker.get_organ(BP_HEAD)
				if(head)
					speaker.visible_message(span_danger("[speaker] opens [speaker.p_their()] mouth to speak and a writing mass of tendrils crawls out."))
				else
					speaker.visible_message(span_danger("[speaker] acts as if [speaker.p_theyre()] attempting to speak, only for a writing mass of tendrils to crawl out of [speaker.p_their()] neck hole."))
	var/datum/modifier/redspace_corruption/corruption = speaker.get_modifier_of_type(/datum/modifier/redspace_corruption)
	if(corruption)
		speaker_mask = corruption.speech_name
	else
		speaker_mask = speaker.real_name
	..(speaker, message, speaker_mask)
