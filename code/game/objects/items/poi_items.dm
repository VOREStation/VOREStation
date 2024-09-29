
/obj/item/poi
	icon = 'icons/obj/objects.dmi'
	desc = "This is definitely something cool."

/datum/category_item/catalogue/information/objects/pascalb
	name = "Object - Pascal B Steel Shaft Cap"
	desc = "In the year 1957, the United States of America - an Earth nation - performed a series \
	of earth nuclear weapons tests codenamed 'Operation Plumbbob', which remain the largest and \
	longest running nuclear test series performed on the American continent. Test data included \
	various altitude detonations, effects on several materials and structures at various \
	distances, and the effects of radiation on military hardware and the human body. \
	<br><br>\
	On the 27th of August that year, in a test named 'Pascal-B' a 300t nuclear payload \
	was buried in a shaft capped by a 900kg steel plate cap. The test was intended to \
	verify the safety of underground detonation, but the shaft was not sufficient to \
	contain the shockwave. According to experiment designer Robert Brownlee, the steel \
	cap was propelled upwards at a velocity of 240,000km/h - over six times Earth's \
	escape velocity. The cap appeared in only one frame of high-speed camera recording. \
	<br><br>\
	It had been theorized that the cap had exited earth's atmosphere and entered orbit. \
	It would seem the cap traveled farther than had been possibly imagined."
	value = CATALOGUER_REWARD_MEDIUM

/obj/item/poi/pascalb
	icon_state = "pascalb"
	name = "misshapen manhole cover"
	desc = "The top of this twisted chunk of metal is faintly stamped with a five pointed star. 'Property of US Army, Pascal B - 1957'."
	catalogue_data = list(/datum/category_item/catalogue/information/objects/pascalb)

/obj/item/poi/pascalb/New()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/item/poi/pascalb/process()
	SSradiation.radiate(src, 5)

/obj/item/poi/pascalb/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/category_item/catalogue/information/objects/oldreactor
	name = "Object - Zorren Fission Reactor Rack"
	desc = "Prior to Humanity's arrival in the virgo-erigone space, introducing advanced phoron technologies, \
	the native Zorren relied upon refurbished, reverse-engineered precursor technology. \
	As much of precursor technology is powered by yet incomprehensible technologies, something reliable was needed. \
	What better to power one's ships - but fission; a technology whose development was driven by war and economic need alike. \
	Stable, requiring only the most minimal supervision - Fission technology soon became ubiqutious.\
	<br><br>\
	However, as accidents were not uncommon due to the inherent dangers of space travel and the \
	nature of reactor racks such as this one fully containing the unstable fuel material, many \
	fission vessels were built capable of jettisoning their entire engine sections as it was seen \
	as preferable to evacuating a ship's crew and potentially losing the entire craft and its cargo. \
	<br><br>\
	Exact details as to where or when this reactor rack hails from are difficult to determine. \
	Based on fissile material ratios, its age can be put between fifty to over a hundred years old. \
	Although not a piece of precursor technology, the various kingdoms of Virgo prime \
	still welcome return of their lost resources and machinery."
	value = CATALOGUER_REWARD_MEDIUM

/obj/structure/closet/crate/oldreactor
	name = "fission reactor rack"
	desc = "Used in older models of nuclear reactors, essentially a cooling rack for high volumes of radioactive material."
	icon = 'icons/obj/closets/poireactor.dmi'
	closet_appearance = null
	catalogue_data = list(/datum/category_item/catalogue/information/objects/oldreactor)
	climbable = FALSE

	starts_with = list(
		/obj/item/fuel_assembly/deuterium = 6)

/obj/item/poi/brokenoldreactor
	icon_state = "poireactor_broken"
	name = "ruptured fission reactor rack"
	desc = "This broken hunk of machinery looks extremely dangerous."
	catalogue_data = list(/datum/category_item/catalogue/information/objects/oldreactor)

/obj/item/poi/brokenoldreactor/New()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/item/poi/brokenoldreactor/process()
	SSradiation.radiate(src, 25)

/obj/item/poi/brokenoldreactor/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/category_item/catalogue/information/objects/growthcanister
	name = "Object - Growth Inhibitor 78-1"
	desc = "The production of Vatborn humans is a process which involves the synthesis of over two hundred \
	distinct chemical compounds. While most Vatborn are 'produced' as infants and merely genetically modified \
	to encourage rapid early maturation, the specific development of the controversial 'Expedited' Vatborn calls for \
	a far more intensive process.\
	<br><br>\
	Growth Inhibitor Type 78-1 is used in the rapid artificial maturation process to prevent the 'overdevelopment' of\
	particular cell structures in the Vatborn's body, halting the otherwise inevitable development of aggressive cancerous\
	growths which would be detrimental or lethal to the subject. Exposure to the compound in its pure form can cause\
	devastating damage to living tissue, ceasing all regenerative activity in an organism's cells. While immediate effects\
	can be halted by recent medical innovations, exposure can severely shorten a sapient's life expectancy.\
	<br><br>\
	Although the Sol-Procyon Commonwealth nominally disapproves of the usage of Vatborn slaves, \
	calling it barbaric and citing it as demonstration of the moral corruption distance from the \
	Core can drive the likes of the Elysian Colonies - the Periphery remains a secluded region, \
	a challenge when it comes to proper staffing. Oddly, despite its prowess otherwise, \
	the cataloguer fails to identify the owner or manufacturer of this canister."
	value = CATALOGUER_REWARD_MEDIUM

/obj/structure/prop/poicanister
	name = "Ruptured Chemical Canister"
	desc = "A cracked open chemical canister labelled 'Growth Inhibitor 78-1'"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "yellow-1"
	catalogue_data = list(/datum/category_item/catalogue/information/objects/growthcanister)
	anchored = FALSE
	density = TRUE


/obj/item/poi/broken_drone_circuit
	name = "Central Processing Strata"	//Ideally we spawn this as loot for robotic enemies
	desc = "The pinnacle of artifical intelligence which can be achieved using classical computer science. \n \
	This one seems somewhat damaged. Perhaps a trained roboticist could extract its memories?"
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/drones)
	icon = 'icons/obj/module.dmi'
	icon_state = "mainboard"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3, TECH_DATA = 4)
	var/drone_name = ""	//Randomly picked unless pre-defined. Used by tool examines
	var/examine_multitool = "TEST_multi - CONTACT DEV"	//Read by attacking with multitool
	var/examine_canalyzer = "TEST_canalyzer spoken - CONTACT DEV"	//Read by attacking with cyborg analyzer. Define in New() if using vars
	var/examine_canalyzer_printed = ""	//If we want different formatting or more detals for printed. By default unused
	var/wirecutted = FALSE
	var/unscrewed = FALSE
	var/unlocked = FALSE
	var/fried = FALSE
	var/has_paper = FALSE


/obj/item/poi/broken_drone_circuit/New()
	drone_name = "[pick(list("ADA","DOS","GNU","MAC","WIN","NJS","SKS","DRD","IOS","CRM","IBM","TEX","LVM","BSD",))]-[rand(1000, 9999)]]"
	var/new_canalyzer = "[drone_name] [examine_canalyzer]"	//Only way I could think to dynamically insert drone name here
	examine_canalyzer = new_canalyzer

/obj/item/poi/broken_drone_circuit/attackby(obj/item/I as obj, mob/living/user as mob)
	if(!istype(user))
		return FALSE
	if(fried)
		to_chat(user, span_warning("[src] is covered in black marks. You feel there's nothing more you can do..."))
		return FALSE

	var/turf/message_turf = get_turf(user)	//We use this to ensure everyone can see it!
	if(istype(I, /obj/item/tool/screwdriver))
		unscrewed = !unscrewed
		to_chat(user, "You screw the blackbox panel [unscrewed ? "off" : "on"]")

	if(istype(I, /obj/item/tool/wirecutters))
		wirecutted = !wirecutted
		to_chat(user, "You [wirecutted ? "cut" : "mend"] the power wire to the blackbox")

	if(istype(I, /obj/item/paper) && unscrewed)
		if(!has_paper)
			to_chat(user, "You feed the debug printer some paper")
			has_paper = TRUE
			qdel(I)
		else
			to_chat(user, span_notice("[src] cannot hold more than 1 sheet of paper."))

	if(istype(I, /obj/item/multitool))
		if(!unscrewed && !wirecutted)
			to_chat(user, span_notice("You cannot access the debug interface with the panel screwed on!"))
		else if(unscrewed && !wirecutted)
			message_turf.audible_message(message = examine_multitool,
			deaf_message = "<b>[src]</b> flashes red repeatedly", runemessage= "Beep! Beep!")
			to_chat(user, span_warning("The components spark from the multitool's unregulated pulse. \
			Perhaps it'd been better to use more sophisticated tools..."))
			fried = TRUE
			message_turf.visible_message(message = "<b>[src]</b> FLASHES VIOLENTLY!",
			blind_message = "ZAP!", runemessage = "CRACKLE!")
			var/used_hand = user.get_organ(user.get_active_hand())
			user.electrocute_act(10,def_zone = used_hand)
		else if(wirecutted)	//The security circuit is accessible outside the special panel, so we don't care for screwdrivers
			to_chat(user, span_notice("You modify the security settings."))
			unlocked = TRUE

	if(istype(I, /obj/item/robotanalyzer))
		if(!unscrewed)
			to_chat(user, span_notice("You cannot access the debug interface with the panel screwed on!"))
		else if(wirecutted)
			to_chat(user, span_notice("You only receive garbled data. Perhaps you should reconnect the wires?"))
		else if(!unlocked)
			to_chat(user, span_danger("Security protocols seemingly engage, purging and bricking the circuit!\n \
			Perhaps, it would've been a good idea to disconnect some wires while pulsing the security circuit..."))
		else
			if(!has_paper)
				message_turf.visible_message(message = "<b>[src]</b> displays, 'PAPER NOT BIN'",
				blind_message = "you hear VERY ANGRY beeping.", runemessage = "BEEP BEEP!")
				message_turf.audible_message(message = "<b>[src]</b> recites, \n '[examine_canalyzer]'",
				deaf_message = "<b>[src]</b> flashes green!", runemessage= "Ping!")
			else
				message_turf.audible_message(message = "<b>[src]</b> rattles loudly as it prints",
				deaf_message = "<b>[src]</b> flashes green!", runemessage= "RATTLE RATTLE")
				var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
				P.name = "[drone_name] blackbox transcript"
				P.info = "[examine_canalyzer_printed ? examine_canalyzer_printed : examine_canalyzer]"
				has_paper = FALSE


	return ..()

/obj/item/poi/broken_drone_circuit/attack_self(mob/living/user as mob)


	user.visible_message(message = "[user] is studiously examining [src]", self_message = "You take your time to analyze the circuit...")
	var/message = ""
	if(fried)
		message += "Amidst the scorch mark, you barely make out [drone_name] stenciled on the board... \n"
		to_chat(user, message)
		return FALSE
	else
		message += "You see [drone_name] stenciled onto the board on close inspection! This looks like a secure drone intelligence strata. \n"


	if(unlocked)
		message += "The power logic to the blackbox is scorched. Whatever secrets lie in the blackbox are yours for taking! \n"
	else if(wirecutted)
		message += "The power wire to the blackbox has been cut. It's safe to pulse the circuit with power, the blackbox won't fry. \n"

	else if(!unscrewed && !wirecutted)
		message += "The blackbox is intact, it seems to have a direct wire into the PSU. Strange... \n"

	else if(unscrewed && !wirecutted)
		message += "Some manner of hardwired logic seems to connect the PSU into the databanks. There is no step-down circuit. \n \
		It looks like a single pulse will fry this system for good\n"
	if(unscrewed && !has_paper)
		message += "Looks like there's a printer without any paper in it."


	if(do_after(user, delay = 5 SECONDS))
		to_chat(user, message)



	..()
