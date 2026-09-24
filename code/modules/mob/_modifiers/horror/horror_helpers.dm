/datum/modifier/redspace_drain/proc/replace_eyes(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/eyes/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/eyes/new_organ = new /obj/item/organ/internal/eyes/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_heart(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/heart/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/heart/new_organ = new /obj/item/organ/internal/heart/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_lungs(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/lungs/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/lungs/new_organ = new /obj/item/organ/internal/lungs/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_liver(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/liver/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/liver/new_organ = new /obj/item/organ/internal/liver/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_kidneys(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/kidneys/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/kidneys/new_organ = new /obj/item/organ/internal/kidneys/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_appendix(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/appendix/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/appendix/new_organ = new /obj/item/organ/internal/appendix/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_voicebox(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/voicebox/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/voicebox/new_organ = new /obj/item/organ/internal/voicebox/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_spleen(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/spleen/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/spleen/new_organ = new /obj/item/organ/internal/spleen/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_stomach(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/stomach/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/stomach/new_organ = new /obj/item/organ/internal/stomach/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_intestine(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/intestine/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/intestine/new_organ = new /obj/item/organ/internal/intestine/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"
