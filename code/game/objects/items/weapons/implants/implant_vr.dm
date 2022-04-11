/obj/item/weapon/implant/vrlanguage
	name = "language"
	desc = "Allows the user to understand and speak almost all known languages.."
	var/uses = 1

/obj/item/weapon/implant/vrlanguage/get_data()
	var/dat = {"
		<b>Implant Specifications:</b><BR>
		<b>Name:</b> Language Implant<BR>
		<b>Life:</b> One day.<BR>
		<b>Important Notes:</b> Personnel with this implant can speak almost all known languages.<BR>
		<HR>
		<b>Implant Details:</b> Subjects injected with implant can understand and speak almost all known languages.<BR>
		<b>Function:</b> Contains specialized nanobots to stimulate the brain so the user can speak and understand previously unknown languages.<BR>
		<b>Special Features:</b> Will allow the user to understand almost all languages.<BR>
		<b>Integrity:</b> Implant can only be used once before the nanobots are depleted."}
	return dat

/obj/item/weapon/implant/vrlanguage/trigger(emote, mob/source as mob)
	if (src.uses < 1)
		return 0
	if (emote == "smile")
		src.uses--
		to_chat(source,"<span class='notice'>You suddenly feel as if you can understand other languages!</span>")
		source.add_language(LANGUAGE_CHIMPANZEE)
		source.add_language(LANGUAGE_NEAERA)
		source.add_language(LANGUAGE_STOK)
		source.add_language(LANGUAGE_FARWA)
		source.add_language(LANGUAGE_UNATHI)
		source.add_language(LANGUAGE_SIIK)
		source.add_language(LANGUAGE_SKRELLIAN)
		source.add_language(LANGUAGE_SCHECHI)
		source.add_language(LANGUAGE_BIRDSONG)
		source.add_language(LANGUAGE_SAGARU)
		source.add_language(LANGUAGE_CANILUNZT)
		source.add_language(LANGUAGE_SLAVIC)
		source.add_language(LANGUAGE_SOL_COMMON) //In case they're giving a xenomorph an implant or something.
		source.add_language(LANGUAGE_TAVAN) 

/obj/item/weapon/implant/vrlanguage/post_implant(mob/source)
	source.mind.store_memory("A implant can be activated by using the smile emote, <B>say *smile</B> to attempt to activate.", 0, 0)
	to_chat(source,"The implanted language implant can be activated by using the smile emote, <B>say *smile</B> to attempt to activate.")
	return 1

//////////////////////////////
//	Size Control Implant
//////////////////////////////
/obj/item/weapon/implant/sizecontrol
	name = "size control implant"
	desc = "Implant which allows to control host size via voice commands."
	icon_state = "implant_evil"
	var/owner
	var/active = TRUE

/obj/item/weapon/implant/sizecontrol/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b>L3-WD Size Controlling Implant<BR>
<b>Life:</b>1-2 weeks after implanting<BR>
<HR>
<b>Function:</b> Resizes the host whenever specific verbal command is received<BR>"}
	return dat

/obj/item/weapon/implant/sizecontrol/hear_talk(mob/M, list/message_pieces)
	if(M == imp_in)
		return
	if(owner)
		if(M != owner)
			return
	var/msg = multilingual_to_message(message_pieces)
	if(findtext(msg,"ignore"))
		return
	var/list/replacechars = list("&#39;" = "",">" = "","<" = "","(" = "",")" = "", "~" = "")
	msg = replace_characters(msg, replacechars)
	hear(msg)
	return

/obj/item/weapon/implant/sizecontrol/see_emote(mob/living/M, message, m_type)
	if(M == imp_in)
		return
	if(owner)
		if(M != owner)
			return
	var/list/replacechars = list("&#39;" = "",">" = "","<" = "","(" = "",")" = "", "~" = "")
	message = replace_characters(message, replacechars)
	var/static/regex/say_in_me = new/regex("(&#34;)(.*?)(&#)", "g")
	while(say_in_me.Find(message))
		if(findtext(say_in_me.match,"ignore"))
			return
		hear(say_in_me.group[2])


/obj/item/weapon/implant/sizecontrol/hear(var/msg)
	if (malfunction)
		return

	if(istype(imp_in, /mob/living))
		var/mob/living/H = imp_in
		if(findtext(msg,"implant-toggle"))
			active = !active
		if(active)
			if(findtext(msg,"grow"))
				H.resize(min(H.size_multiplier*1.5, 2))
			else if(findtext(msg,"shrink"))
				H.resize(max(H.size_multiplier*0.5, 0.25))
			else if(findtext(msg, "resize"))
				var/static/regex/size_mult = new/regex("\\d+")
				if(size_mult.Find(msg))
					var/resizing_value = text2num(size_mult.match)
					H.resize(CLAMP(resizing_value/100 , 0.25, 2))



/obj/item/weapon/implant/sizecontrol/post_implant(mob/source, mob/living/user = usr)
	if(source != user)
		owner = user


/obj/item/weapon/implant/sizecontrol/emp_act(severity)
	if(istype(imp_in, /mob/living))
		var/newsize = pick(RESIZE_HUGE,RESIZE_BIG,RESIZE_NORMAL,RESIZE_SMALL,RESIZE_TINY,RESIZE_A_HUGEBIG,RESIZE_A_BIGNORMAL,RESIZE_A_NORMALSMALL,RESIZE_A_SMALLTINY)
		var/mob/living/H = imp_in
		H.resize(newsize)

/obj/item/weapon/implanter/sizecontrol
	name = "size control implant"
	desc = "Implant which allows to control host size via voice commands."
	description_info = {"Only accessable by those who implanted the victim. Self-implanting allows everyone to change host size. The following special commands are available:
'Shrink' - host size decreases.
'Grow' - host size increases.
'Resize (NUMBER)' - for accurate size control.
'Ignore' - keywords in the speech won't have any effect.
'Implant-toggle' - toggles implant."}

/obj/item/weapon/implanter/sizecontrol/New()
	src.imp = new /obj/item/weapon/implant/sizecontrol( src )
	..()
	update()
	return