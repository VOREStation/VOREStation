/obj/item/implant/vrlanguage
	name = "language"
	desc = "Allows the user to understand and speak almost all known languages.."
	var/uses = 1

/obj/item/implant/vrlanguage/get_data()
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

/obj/item/implant/vrlanguage/trigger(emote, mob/source as mob)
	if (src.uses < 1)
		return 0
	if (emote == "smile")
		src.uses--
		to_chat(source,span_notice("You suddenly feel as if you can understand other languages!"))
		source.add_language(LANGUAGE_UNATHI)
		source.add_language(LANGUAGE_SIIK)
		source.add_language(LANGUAGE_SKRELLIAN)
		source.add_language(LANGUAGE_ANIMAL)
		source.add_language(LANGUAGE_SCHECHI)
		source.add_language(LANGUAGE_BIRDSONG)
		source.add_language(LANGUAGE_SAGARU)
		source.add_language(LANGUAGE_CANILUNZT)
		source.add_language(LANGUAGE_SOL_COMMON) //In case they're giving a xenomorph an implant or something.
		source.add_language(LANGUAGE_TAVAN)

/obj/item/implant/vrlanguage/post_implant(mob/source)
	source.mind.store_memory("A implant can be activated by using the smile emote, <B>say *smile</B> to attempt to activate.", 0, 0)
	to_chat(source,"The implanted language implant can be activated by using the smile emote, <B>say *smile</B> to attempt to activate.")
	return 1

//////////////////////////////
//	Size Control Implant
//////////////////////////////
/obj/item/implant/sizecontrol
	name = "size control implant"
	desc = "Implant which allows to control host size via voice commands."
	icon_state = "implant_evil"
	var/owner
	var/active = TRUE

/obj/item/implant/sizecontrol/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b>L3-WD Size Controlling Implant<BR>
<b>Life:</b>1-2 weeks after implanting<BR>
<HR>
<b>Function:</b> Resizes the host whenever specific verbal command is received<BR>"}
	return dat

/obj/item/implant/sizecontrol/hear_talk(mob/M, list/message_pieces)
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

/obj/item/implant/sizecontrol/see_emote(mob/living/M, message, m_type)
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


/obj/item/implant/sizecontrol/hear(var/msg)
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



/obj/item/implant/sizecontrol/post_implant(mob/source, mob/living/user = usr)
	if(source != user)
		owner = user


/obj/item/implant/sizecontrol/emp_act(severity)
	if(istype(imp_in, /mob/living))
		var/newsize = pick(RESIZE_HUGE,RESIZE_BIG,RESIZE_NORMAL,RESIZE_SMALL,RESIZE_TINY,RESIZE_A_HUGEBIG,RESIZE_A_BIGNORMAL,RESIZE_A_NORMALSMALL,RESIZE_A_SMALLTINY)
		var/mob/living/H = imp_in
		H.resize(newsize)

/obj/item/implanter/sizecontrol
	name = "size control implant"
	desc = "Implant which allows to control host size via voice commands."
	description_info = {"Only accessible by those who implanted the victim. Self-implanting allows everyone to change host size. The following special commands are available:
'Shrink' - host size decreases.
'Grow' - host size increases.
'Resize (NUMBER)' - for accurate size control.
'Ignore' - keywords in the speech won't have any effect.
'Implant-toggle' - toggles implant."}

/obj/item/implanter/sizecontrol/New()
	src.imp = new /obj/item/implant/sizecontrol( src )
	..()
	update()
	return


//////////////////////////////
//	Compliance Implant
//////////////////////////////
/obj/item/implanter/compliance
	name = "compliance implant"
	desc = "Implant which allows for implanting 'laws' or 'commands' in the host. Has a miniature keyboard for typing laws into."
	description_info = {"An implant that allows for a 'law' or 'command' to be uploaded in the implanted host.
In un-modified organics, this is performed through manipulation of the nervous system and release of chemicals to ensure continued compliance.
In synthetics or modified organics, this implant uploads a virus to any compatible hardware.
Due to the small chemical capacity of the implant, the life of the implant is relatively small, wearing off within 24 hours or sooner."}

	description_fluff = "Due to the illegality of these types of implants, they are often made in clandestine facilities with a complete lack of quality control \
	and as such, may malfunction or simply not work whatsoever. After loyalty implants were outlawed in many civilized areas of space, an abundance of readily \
	available implanters and implants became available for purchase on the black market, with some deciding to modify them. Now, they are often used by illegal \
	entities to perform espionage and in some parts of space are used off the books for interrogation. Most of the makers of these modified implants have put in \
	safeties to prevent lethal or actively harmful commands from being input to lessen the severity of the crime if they are caught. This one has a golden stamp \
	with the shape of a star on it, the letters 'KE' in black text on it."

/obj/item/implanter/compliance/New()
	src.imp = new /obj/item/implant/compliance( src )
	..()
	update()
	return

/obj/item/implanter/compliance/attack_self(mob/user)
	if(istype(imp,/obj/item/implant/compliance))
		var/obj/item/implant/compliance/implant = imp
		var/newlaws = tgui_input_text(user, "Please Input Laws", "Compliance Laws", "", multiline = TRUE, prevent_enter = TRUE)
		newlaws = sanitize(newlaws,2048)
		if(newlaws)
			to_chat(user,"You set the laws to: <br>" + span_notice("[newlaws]"))
			implant.laws = newlaws //Organic
	else //No using other implants.
		to_chat(user,span_notice("A red warning pops up on the implanter's micro-screen: 'INVALID IMPLANT DETECTED.'"))


/obj/item/implant/compliance
	name = "compliance implant"
	desc = "Implant which allows for forcing obedience in the host."
	icon_state = "implant_evil"
	var/active = TRUE
	var/laws = "CHANGE BEFORE IMPLANTATION"
	var/nif_payload = /datum/nifsoft/compliance

/obj/item/implant/compliance/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b>Compliance Implant<BR>
<b>Life:</b>24 Hours<BR>
<HR>
<b>Function:</b> Forces a subject to follow a set of laws.<BR>
<HR>
<b>Set Laws:</b>[laws]"}
	return dat

/obj/item/implant/compliance/post_implant(mob/source, mob/living/user = usr)
	if(!ishuman(source)) //No compliance implanting non-humans.
		return

	var/mob/living/carbon/human/target = source
	if(!target.nif || target.nif.stat != NIF_WORKING) //No nif or their NIF is broken.
		to_chat(target, span_notice("You suddenly feel compelled to follow the following commands: [laws]"))
		to_chat(target, span_notice("((OOC NOTE: Commands that go against server rules should be disregarded and ahelped.))"))
		to_chat(target, span_notice("((OOC NOTE: Your new commands can be checked at any time by using the 'notes' command in chat. Additionally, if you did not agree to this, you are not compelled to follow the implant.))"))
		target.add_memory(laws)
		return
	else //You got a nif...Upload time.
		new nif_payload(target.nif,laws)
		to_chat(target, span_notice("((OOC NOTE: Commands that go against server rules should be disregarded and ahelped.))"))
		to_chat(target, span_notice("((OOC NOTE: If you did not agree to this, you are not compelled to follow the laws.))"))
