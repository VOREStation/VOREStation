/datum/language/diona_local
	name = LANGUAGE_ROOTLOCAL
	desc = "A complex language known instinctively by Dionaea, 'spoken' by emitting modulated radio waves. This version uses high frequency waves for quick communication at short ranges."
	speech_verb = "creaks and rustles"
	ask_verb = "creaks"
	exclaim_verb = "rustles"
	colour = "soghun"
	key = "q"
	machine_understands = 0
	flags = WHITELISTED // RESTRICTED would make this completely unavailable from character select
	syllables = list("hs","zt","kr","st","sh")

/datum/language/diona_local/get_random_name()
	var/new_name = "[pick(list("To Sleep Beneath","Wind Over","Embrace of","Dreams of","Witnessing","To Walk Beneath","Approaching the"))]"
	new_name += " [pick(list("the Void","the Sky","Encroaching Night","Planetsong","Starsong","the Wandering Star","the Empty Day","Daybreak","Nightfall","the Rain"))]"
	return new_name

/datum/language/diona_global
	name = LANGUAGE_ROOTGLOBAL
	desc = "A complex language known instinctively by Dionaea, 'spoken' by emitting modulated radio waves. This version uses low frequency waves for slow communication at long ranges."
	key = "w"
	machine_understands = 0
	flags = WHITELISTED | HIVEMIND // RESTRICTED would make this completely unavailable from character select

/datum/language/unathi
	name = LANGUAGE_UNATHI
	desc = "The common language of the Moghes Hegemony, composed of sibilant hisses and rattles. Spoken natively by Unathi."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "roars"
	colour = "soghun"
	key = "o"
	flags = WHITELISTED
	space_chance = 40
	syllables = list(
		"za", "az", "ze", "ez", "zi", "iz", "zo", "oz", "zu", "uz", "zs", "sz",
 		"ha", "ah", "he", "eh", "hi", "ih", "ho", "oh", "hu", "uh", "hs", "sh",
 		"la", "al", "le", "el", "li", "il", "lo", "ol", "lu", "ul", "ls", "sl",
 		"ka", "ak", "ke", "ek", "ki", "ik", "ko", "ok", "ku", "uk", "ks", "sk",
 		"sa", "as", "se", "es", "si", "is", "so", "os", "su", "us", "ss", "ss",
 		"ra", "ar", "re", "er", "ri", "ir", "ro", "or", "ru", "ur", "rs", "sr",
 		"a",  "a",  "e",  "e",  "i",  "i",  "o",  "o",  "u",  "u",  "s",  "s"
	)

/datum/language/unathi/get_random_name()

	var/new_name = ..()
	while(findtextEx(new_name,"sss",1,null))
		new_name = replacetext(new_name, "sss", "ss")
	return capitalize(new_name)

/datum/language/tajaran
	name = LANGUAGE_SIIK
	desc = "The most prevalant language of Meralar, composed of expressive yowls and chirps. Native to the Tajaran."
	speech_verb = "mrowls"
	ask_verb = "mrowls"
	exclaim_verb = "yowls"
	colour = "tajaran"
	key = "j"
	flags = WHITELISTED
	syllables = list("mrr","rr","tajr","kir","raj","kii","mir","kra","ahk","nal","vah","khaz","jri","ran","darr",
	"mi","jri","dynh","manq","rhe","zar","rrhaz","kal","chur","eech","thaa","dra","jurl","mah","sanu","dra","ii'r",
	"ka","aasi","far","wa","baq","ara","qara","zir","saam","mak","hrar","nja","rir","khan","jun","dar","rik","kah",
	"hal","ket","jurl","mah","tul","cresh","azu","ragh","mro","mra","mrro","mrra")

/datum/language/tajaran/get_random_name(var/gender)
	var/new_name = ..(gender,1)
	if(prob(50))
		new_name += " [pick(list("Hadii","Kaytam","Nazkiin","Zhan-Khazan","Hharar","Njarir'Akhan","Faaira'Nrezi","Rhezar","Mi'dynh","Rrhazkal","Bayan","Al'Manq","Mi'jri","Chur'eech","Sanu'dra","Ii'rka"))]"
	else
		new_name += " [..(gender,1)]"
	return new_name

/datum/language/tajaranakhani
	name = LANGUAGE_AKHANI
	desc = "The language of the sea-faring Njarir'Akhan Tajaran. Borrowing some elements from Siik, the language is distinctly more structured."
	speech_verb = "chatters"
	ask_verb = "mrowls"
	exclaim_verb = "wails"
	colour = "akhani"
	key = "h"
	flags = WHITELISTED
	syllables = list("mrr","rr","marr","tar","ahk","ket","hal","kah","dra","nal","kra","vah","dar","hrar", "eh",
	"ara","ka","zar","mah","ner","zir","mur","hai","raz","ni","ri","nar","njar","jir","ri","ahn","kha","sir",
	"kar","yar","kzar","rha","hrar","err","fer","rir","rar","yarr","arr","ii'r","jar","kur","ran","rii","ii",
	"nai","ou","kah","oa","ama","uuk","bel","chi","ayt","kay","kas","akor","tam","yir","enai")

/datum/language/tajsign
	name = LANGUAGE_ALAI
	desc = "A standardized Tajaran sign language that was developed in Zarraya and gradually adopted by other nations, incorporating \
			hand gestures and movements of the ears and tail."
	signlang_verb = list("gestures with their hands", "gestures with their ears and tail", "gestures with their ears, tail and hands")
	colour = "tajaran"
	key = "l"
	flags = WHITELISTED | SIGNLANG | NO_STUTTER //nonverbal define was not needed here, and i need to use it ~Layne

/datum/language/tajsign/broadcast(var/mob/living/speaker, var/message, var/speaker_mask)
	log_say("(SIGN) [message]", speaker)
	speaker.say_signlang(message, pick(signlang_verb), src)

/datum/language/tajsign/can_speak_special(var/mob/speaker)	// TODO: If ever we make external organs assist languages, convert this over to the new format
	var/list/allowed_species = list(SPECIES_TAJ, SPECIES_TESHARI)	// Need a tail and ears and such to use this.
	if(ishuman(speaker))
		var/obj/item/organ/external/hand/hands = locate() in speaker //you can't sign without hands
		if(!hands)
			return FALSE
		if(ishuman(speaker))
			var/mob/living/human/H = speaker
			if(H.species.get_bodytype(H) in allowed_species)
				return TRUE

	return FALSE

/datum/language/skrell
	name = LANGUAGE_SKRELLIAN
	desc = "A set of warbles and hums, the language itself a complex mesh of both melodic and rhythmic components, exceptionally capable of conveying intent and emotion of the speaker."
	speech_verb = "warbles"
	ask_verb = "warbles"
	exclaim_verb = "sings"
	whisper_verb = "hums"
	colour = "skrell"
	key = "k"
	space_chance = 30
	flags = WHITELISTED
	syllables = list("qr","qrr","xuq","qil","quum","xuqm","vol","xrim","zaoo","qu-uu","qix","qoo","zix")

/datum/language/skrellfar
	name = LANGUAGE_SKRELLIANFAR
	desc = "The most common language among the Skrellian Far Kingdoms. Has an even higher than usual concentration of inaudible phonemes."
	speech_verb = "warbles"
	ask_verb = "warbles"
	exclaim_verb = "sings"
	whisper_verb = "hums"
	colour = "skrellfar"
	key = "p"
	space_chance = 30
	flags = WHITELISTED
	syllables = list("qr","qrr","xuq","qil","quum","xuqm","vol","xrim","zaoo","qu-uu","qix","qoo","zix", "...", "oo", "q", "nq", "x", "xq", "ll", "...", "...", "...") //should sound like there's holes in it

/datum/language/skrell/get_random_name(var/gender)
	var/list/first_names = file2list('config/names/first_name_skrell.txt')
	var/list/last_names = file2list('config/names/last_name_skrell.txt')
	return "[pick(first_names)] [pick(last_names)]"

/datum/language/human
	name = LANGUAGE_SOL_COMMON
	desc = "A bastardized hybrid of many languages, including Chinese, English, French, and more; it is the common language of the Sol system."
	speech_verb = "says"
	whisper_verb = "whispers"
	colour = "solcom"
	key = "1"
	flags = WHITELISTED
	//syllables are at the bottom of the file

/datum/language/human/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims","shouts","yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb

/datum/language/human/get_random_name(var/gender)
	if (prob(80))
		if(gender==FEMALE)
			return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else
			return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
	else
		return ..()

/datum/language/machine
	name = LANGUAGE_EAL
	desc = "An efficient language of encoded tones developed by positronics."
	speech_verb = "whistles"
	ask_verb = "chirps"
	exclaim_verb = "whistles loudly"
	colour = "changeling"
	key = "6"
	flags = NO_STUTTER
	syllables = list("beep","beep","beep","beep","beep","boop","boop","boop","bop","bop","dee","dee","doo","doo","hiss","hss","buzz","buzz","bzz","ksssh","keey","wurr","wahh","tzzz","shh","shk")
	space_chance = 10

/datum/language/machine/get_random_name()
	if(prob(70))
		return "[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[rand(100, 999)]"
	else
		return pick(ai_names)

/datum/language/teshari
	name = LANGUAGE_SCHECHI
	desc = "A trilling language spoken by the diminutive Teshari."
	speech_verb = "chirps"
	ask_verb = "chirrups"
	exclaim_verb = "trills"
	colour = "alien"
	key = "v"
	flags = WHITELISTED
	space_chance = 50
	syllables = list(
			"ca", "ra", "ma", "sa", "na", "ta", "la", "sha", "scha", "a", "a",
			"ce", "re", "me", "se", "ne", "te", "le", "she", "sche", "e", "e",
			"ci", "ri", "mi", "si", "ni", "ti", "li", "shi", "schi", "i", "i"
		)

/datum/language/teshari/get_random_name(gender)
	return ..(gender, 2, 4, 1.5)


/datum/language/zaddat
	name = LANGUAGE_ZADDAT
	desc = "A harsh buzzing language created by the Zaddat following their exodus from their homeworld."
	speech_verb = "buzzes"
	ask_verb = "buzzes"
	exclaim_verb = "croaks"
	colour = "zaddat"
	key = "z"
	flags = WHITELISTED
	space_chance = 20
	syllables = list("z", "dz", "i", "iv", "ti", "az", "hix", "xo", "av", "xo", "x", "za", "at", "vi")

/datum/language/promethean
	name = LANGUAGE_PROMETHEAN
	desc = "A complex language composed of guttural noises and bioluminescent signals"
	signlang_verb = list("flickers","flashes","rapidly flashes a light","quickly flickers a light")
	speech_verb = "gurgles"
	ask_verb = "gurgles"
	exclaim_verb = "gurgles"
	colour = "promethean"
	key = "t"
	flags = WHITELISTED | NONVERBAL
	space_chance = 20
	syllables = list("gur","gul","gug","gel","ger","geg","gir","gil","gig","gor","gol","gog","ug","ul","ur","uu","el","eg","er","oe","ig","il","ir","oi","og","ol","or","oo")


//Syllable Lists
/*
	This list really long, mainly because I can't make up my mind about which mandarin syllables should be removed,
	and the english syllables had to be duplicated so that there is roughly a 50-50 weighting.
	The other 3 languages were duplicated just so they could show occasionally.

	Sources:
	http://www.sttmedia.com/syllablefrequency-english
	http://www.sttmedia.com/syllablefrequency-spanish
	http://www.sttmedia.com/syllablefrequency-russian
	http://www.sttmedia.com/syllablefrequency-french
	http://www.chinahighlights.com/travelguide/learning-chinese/pinyin-syllables.htm
*/
/datum/language/human/syllables = list(
"a", "ai", "an", "ang", "ao", "ba", "bai", "ban", "bang", "bao", "bei", "ben", "beng", "bi", "bian", "biao",
"bie", "bin", "bing", "bo", "bu", "ca", "cai", "can", "cang", "cao", "ce", "cei", "cen", "ceng", "cha", "chai",
"chan", "chang", "chao", "che", "chen", "cheng", "chi", "chong", "chou", "chu", "chua", "chuai", "chuan", "chuang", "chui", "chun",
"chuo", "ci", "cong", "cou", "cu", "cuan", "cui", "cun", "cuo", "da", "dai", "dan", "dang", "dao", "de", "dei",
"den", "deng", "di", "dian", "diao", "die", "ding", "diu", "dong", "dou", "du", "duan", "dui", "dun", "duo", "e",
"ei", "en", "er", "fa", "fan", "fang", "fei", "fen", "feng", "fo", "fou", "fu", "ga", "gai", "gan", "gang",
"gao", "ge", "gei", "gen", "geng", "gong", "gou", "gu", "gua", "guai", "guan", "guang", "gui", "gun", "guo", "ha",
"hai", "han", "hang", "hao", "he", "hei", "hen", "heng", "hm", "hng", "hong", "hou", "hu", "hua", "huai", "huan",
"huang", "hui", "hun", "huo", "ji", "jia", "jian", "jiang", "jiao", "jie", "jin", "jing", "jiong", "jiu", "ju", "juan",
"jue", "jun", "ka", "kai", "kan", "kang", "kao", "ke", "kei", "ken", "keng", "kong", "kou", "ku", "kua", "kuai",
"kuan", "kuang", "kui", "kun", "kuo", "la", "lai", "lan", "lang", "lao", "le", "lei", "leng", "li", "lia", "lian",
"liang", "liao", "lie", "lin", "ling", "liu", "long", "lou", "lu", "luan", "lun", "luo", "ma", "mai", "man", "mang",
"mao", "me", "mei", "men", "meng", "mi", "mian", "miao", "mie", "min", "ming", "miu", "mo", "mou", "mu", "na",
"nai", "nan", "nang", "nao", "ne", "nei", "nen", "neng", "ng", "ni", "nian", "niang", "niao", "nie", "nin", "ning",
"niu", "nong", "nou", "nu", "nuan", "nuo", "o", "ou", "pa", "pai", "pan", "pang", "pao", "pei", "pen", "peng",
"pi", "pian", "piao", "pie", "pin", "ping", "po", "pou", "pu", "qi", "qia", "qian", "qiang", "qiao", "qie", "qin",
"qing", "qiong", "qiu", "qu", "quan", "que", "qun", "ran", "rang", "rao", "re", "ren", "reng", "ri", "rong", "rou",
"ru", "rua", "ruan", "rui", "run", "ruo", "sa", "sai", "san", "sang", "sao", "se", "sei", "sen", "seng", "sha",
"shai", "shan", "shang", "shao", "she", "shei", "shen", "sheng", "shi", "shou", "shu", "shua", "shuai", "shuan", "shuang", "shui",
"shun", "shuo", "si", "song", "sou", "su", "suan", "sui", "sun", "suo", "ta", "tai", "tan", "tang", "tao", "te",
"teng", "ti", "tian", "tiao", "tie", "ting", "tong", "tou", "tu", "tuan", "tui", "tun", "tuo", "wa", "wai", "wan",
"wang", "wei", "wen", "weng", "wo", "wu", "xi", "xia", "xian", "xiang", "xiao", "xie", "xin", "xing", "xiong", "xiu",
"xu", "xuan", "xue", "xun", "ya", "yan", "yang", "yao", "ye", "yi", "yin", "ying", "yong", "you", "yu", "yuan",
"yue", "yun", "za", "zai", "zan", "zang", "zao", "ze", "zei", "zen", "zeng", "zha", "zhai", "zhan", "zhang", "zhao",
"zhe", "zhei", "zhen", "zheng", "zhi", "zhong", "zhou", "zhu", "zhua", "zhuai", "zhuan", "zhuang", "zhui", "zhun", "zhuo", "zi",
"zong", "zou", "zuan", "zui", "zun", "zuo", "zu",
"al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
"le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to",
"ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin",
"his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi",
"al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
"le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to",
"ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin",
"his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi",
"al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
"le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to",
"ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin",
"his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi",
"al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
"le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to",
"ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin",
"his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi",
"al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
"le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to",
"ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin",
"his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi",
"al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
"le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to",
"ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin",
"his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi",
"ah", "be", "bo", "eh", "ep", "et", "ka", "ko", "ha", "he", "ho", "ob", "oh", "op", "oc", "ot", "pa", "pe", "ct", "ta", "te", "to",
"vse", "tak", "nak", "no", "epo", "pre", "kan", "dly", "ime", "sha", "kur", "yey", "khi", "yeg", "ne",
"ion", "ne", "nas", "v",
"ah", "be", "bo", "eh", "ep", "et", "ka", "ko", "ha", "he", "ho", "ob", "oh", "op", "oc", "ot", "pa", "pe", "ct", "ta", "te", "to",
"vse", "tak", "nak", "no", "epo", "pre", "kan", "dly", "ime", "sha", "kur", "yey", "khi", "yeg", "ne",
"ion", "ne", "nas", "v",
"ah", "be", "bo", "eh", "ep", "et", "ka", "ko", "ha", "he", "ho", "ob", "oh", "op", "oc", "ot", "pa", "pe", "ct", "ta", "te", "to",
"vse", "tak", "nak", "no", "epo", "pre", "kan", "dly", "ime", "sha", "kur", "yey", "khi", "yeg", "ne",
"ion", "ne", "nas", "v",
"ai", "an", "ar", "au", "ce", "ch", "co", "de", "em", "en", "er", "es", "et", "eu", "il", "in", "is", "la", "le",
"ma", "me", "ne", "ns", "nt", "on", "ou", "pa", "qu", "ra", "re", "se", "te", "ti", "tr", "ue", "ur", "us", "ve",
"tou", "e", "eve", "hen", "son", "non", "not", "le",
"ai", "an", "ar", "au", "ce", "ch", "co", "de", "em", "en", "er", "es", "et", "eu", "il", "in", "is", "la", "le",
"ma", "me", "ne", "ns", "nt", "on", "ou", "pa", "qu", "ra", "re", "se", "te", "ti", "tr", "ue", "ur", "us", "ve",
"tou", "e", "eve", "hen", "son", "non", "not", "le",
"ai", "an", "ar", "au", "ce", "ch", "co", "de", "em", "en", "er", "es", "et", "eu", "il", "in", "is", "la", "le",
"ma", "me", "ne", "ns", "nt", "on", "ou", "pa", "qu", "ra", "re", "se", "te", "ti", "tr", "ue", "ur", "us", "ve",
"tou", "e", "eve", "hen", "son", "non", "not", "le",
"ad", "al", "an", "ar", "as", "ci", "co", "de", "do", "el", "en", "er", "es", "ie", "in", "la", "lo", "me", "na",
"no", "nt", "or", "os", "pa", "qu", "ra", "re", "ro", "se", "st", "ta", "te", "to", "ue", "un",
"tod", "ser", "su", "no", "nue", "el",
"ad", "al", "an", "ar", "as", "ci", "co", "de", "do", "el", "en", "er", "es", "ie", "in", "la", "lo", "me", "na",
"no", "nt", "or", "os", "pa", "qu", "ra", "re", "ro", "se", "st", "ta", "te", "to", "ue", "un",
"tod", "ser", "su", "no", "nue", "el",
"ad", "al", "an", "ar", "as", "ci", "co", "de", "do", "el", "en", "er", "es", "ie", "in", "la", "lo", "me", "na",
"no", "nt", "or", "os", "pa", "qu", "ra", "re", "ro", "se", "st", "ta", "te", "to", "ue", "un",
"tod", "ser", "su", "no", "nue", "el")
