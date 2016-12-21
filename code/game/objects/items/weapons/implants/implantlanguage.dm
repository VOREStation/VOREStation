//These allow someone to speak a language they are otherwise physically incapable of speaking or hearing
//They don't, at the moment, grant knowledge of the language
//The can_speak_special checks should check for the presence of the implants.

/obj/item/weapon/implant/language
	name = "GalCom language implant"
	desc = "An implant allowing someone to speak and hear the range of frequencies used in Galactic Common, as well as produce any phonemes that they usually cannot. Only helps with hearing and producing sounds, not understanding them."

/obj/item/weapon/implant/language/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Vey-Med L-1 Galactic Common Implant<BR>
<b>Life:</b> 5 years<BR>
<b>Important Notes:</b> Affects hearing and speech.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Allows a being otherwise incapable to both hear the frequencies Galactic Common is generally spoken at, as well as to produce the phonemes of the language.<BR>
<b>Special Features:</b> None.<BR>
<b>Integrity:</b> Implant will function for expected life, barring physical damage."}
	return dat

/obj/item/weapon/implant/language/eal
	name = "EAL language implant"
	desc = "An implant allowing an organic to both hear and speak Encoded Audio Language accurately. Only helps with hearing and producing sounds, not understanding them."

/obj/item/weapon/implant/language/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Vey-Med L-2 Encoded Audio Language Implant<BR>
<b>Life:</b> 5 years<BR>
<b>Important Notes:</b> Affects hearing and speech.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Allows an organic to accurately process and speak Encoded Audio Language.<BR>
<b>Special Features:</b> None.<BR>
<b>Integrity:</b> Implant will function for expected life, barring physical damage."}
	return dat