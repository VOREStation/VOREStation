// Noise "language", for audible emotes.
/datum/language/noise
	name = "Noise"
	desc = "Noises"
	key = ""
	flags = RESTRICTED|NONGLOBAL|INNATE|NO_TALK_MSG|NO_STUTTER

/datum/language/noise/format_message(message, verb)
	return "<span class='message'><span class='[colour]'>[message]</span></span>"

/datum/language/noise/format_message_plain(message, verb)
	return message

/datum/language/noise/format_message_radio(message, verb)
	return "<span class='[colour]'>[message]</span>"

/datum/language/noise/get_talkinto_msg_range(message)
	// if you make a loud noise (screams etc), you'll be heard from 4 tiles over instead of two
	return (copytext(message, length(message)) == "!") ? 4 : 2

// 'basic' language; spoken by default.
/datum/language/common
	name = LANGUAGE_GALCOM
	desc = "The common galactic tongue, engineered for cross-species communication."
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "0"
	flags = RESTRICTED
	syllables = list(
"vol", "zum", "coo","zoo","bi","do","ooz","ite","og","re","si","ite","ish",
"ar","at","on","ee","east","ma","da", "rim")

//TODO flag certain languages to use the mob-type specific say_quote and then get rid of these.
/datum/language/common/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims","shouts","yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb

// Galactic common languages (systemwide accepted standards).
/datum/language/trader
	name = LANGUAGE_TRADEBAND
	desc = "Spoken by the humans of the upper-class Sagittarius Heights, Tradeband was designed to be pleasing to both humans and their Skrellian trading partners."
	speech_verb = "enunciates"
	colour = "say_quote"
	key = "2"
	syllables = list(
"fea","vea","vei","veh","vee","feh","fa","soa","su","sua","sou","se","seh","twa","twe","twi",
"ahm","lea","lee","nae","nah","pa","pau","fae","fai","soh","mou","ahe","ll","ea","ai","thi",
"hie","zei","zie","ize","ehy","uy","oya","dor","di","ja","ej","er","um","in","qu","is","re",
"nt","ti","us","it","en","at","tu","te","ri","es","et","ra","ta","an","ni","li","on","or","se",
"am","ae","ia","di","ue","em","ar","ui","st","si","de","ci","iu","ne","pe","co","os","ur","ru")

/datum/language/terminus
	name = LANGUAGE_TERMINUS
	desc = "A soft language spoken by the people of the sparsely populated, socially-conscious Precursors' Crypt region."
	speech_verb = "mentions"
	exclaim_verb = "insinuates"
	colour = "terminus"
	key = "4"
	flags = WHITELISTED
	syllables = list ("die", "en", "skei", "van", "son", "der", "aar", "ch", "op", "ruk", "aa", "be", "ne", "het",
 	"ek", "ras", "ver", "zan", "das", "waa", "geb", "vol", "lu", "min", "breh", "rus", "stv", "ee", "goe", "sk",
 	"la", "ver", "we", "ge", "luk", "an", "ar", "at", "es", "et", "bel", "du", "jaa", "ch", "kk", "gh", "ll", "uu", "wat")

// Criminal language.
/datum/language/gutter
	name = LANGUAGE_GUTTER
	desc = "Gutter originated as a Thieves' Cant of sorts during the early colonization era. The language eventually spread from the cartels and triads to the disenfranchised people of the Bowl."
	speech_verb = "growls"
	colour = "rough"
	key = "3"
	space_chance = 45
	syllables = list (
"gra","ba","ba","breh","bra","rah","dur","ra","ro","gro","go","ber","bar","geh","heh", "gra",
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
"zong", "zou", "zuan", "zui", "zun", "zuo", "zu", "al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
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
"his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi")

/datum/language/sign
	name = LANGUAGE_SIGN
	desc = "A sign language commonly used for those who are deaf or mute."
	signlang_verb = list("gestures")
	colour = "say_quote"
	key = "s"
	flags = SIGNLANG|NO_STUTTER|NONVERBAL

/datum/language/sign/can_speak_special(var/mob/speaker)
	var/obj/item/organ/external/hand/hands = locate() in speaker //you can't sign without hands
	return (hands || !iscarbon(speaker))
