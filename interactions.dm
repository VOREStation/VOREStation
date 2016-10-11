/****** Interactions code by HONKERTRON feat TestUnit ********
** Contains a lot ammount of ERP and MEHANOYEBLYA **
***********************************/
/***ATMTA STATION 13 ERP CODE TRANSLATION**/

/****PORT VARIABLE AND FUNCTION NOTES||||PLEASE READ|||**/
//penis synonyms: 'cock', 'shaft', 'member', 'rod', 'dick'
//sorry if they sound corny
//var/staminaloss is in living_defines.dm
//var/HEADCOVERSMOUTH is defined in _defines/mobs.dm or flags.dm
//proc/to_chat() is defined in _macros.dm
//var/underwear and var/undershirt is defined in /carbon/human/human_defines.dm
//var/genitals and var/anus is defined in species.dm
//var/obj/effect/decal/cleanable/cum is defined in \game\objects\effects\decals\Cleanable\misc.dm, make sure to use the obj\effects\decals\Cleanable\cum.dmi
//var/anus is defined in species.dm
//human/proc/get_age_pitch() is defined in human.dm
//flags.dm is ported to mobs.dm, but should I place them in flags.dm?
//EDIT humans.dm to include new options for more interactions
//H = User
//P = Partner
//Changes are designated by a 'ATMTA port' (without quotes). CTRL+F to find the changes
/**END OF PORT NOTES**/

//********ISSUES********/
/*****************

UNFINISHED:
--Make code more modular.
--Not all races from vorestation are implemented yet, but can be fixed by toggling a flag and adding a statement
--Replace 'their' with [H. gender = MALE? "his": "her"] if possible.
--Check for grammar, spelling errors after translation is finished
--Machine translations unsurprisingly sound pecular and awkward. So fix them
--Not coded for all species (akula, promethean, teshari, lamia)
FIXED:
--Translated and decoded human.dm dialogue into english
--oral, vaginal, blowjob, dildo, and anal lines finished
--Cum spawns, just toggle misc.dm from honk/code/game/objects/effects/decals/Cleanable/misc.dm. What you can alternatively do is copy and paste it into code/game/objects/effects/decals/Cleanable/misc.dm
--Windows initializes and functions work. Due to it being placed in human.dm
--Buttons should be readjusted to simple words
--prints DNA with Texture (C.blood_DNA) since obj/effect/decal/cleanable/cum is defined in human.dm
*****/
/mob/living/carbon/human/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(M == src || src == usr || M!= usr) 	return
	if(usr.restrained()) 	return

	var/mob/living/carbon/human/H = usr
	H.partner = src
	make_interaction(machine)

/mob/proc/make_interaction()
	return

//Distant interactions
/mob/living/carbon/human/verb/interact(mob/M as mob)
	set name = "Interact"
	set category = "IC"

	if(istype(M,/mob/living/carbon/human) && usr!= M)
		partner = M
		make_interaction(machine)
//species genital flags
/*Example race*/
// /datum/species/race
//  genitals =1
//  anus =1
/*end of example race*/
/datum/species/human
	genitals = 1
	anus = 1

/datum/species/plasmaman
	anus = 1

/datum/species/kidan
	anus = 1

/datum/species/wryn
	anus = 1

/datum/species/unathi
	genitals = 1
	anus = 1

/datum/species/tajaran
	genitals = 1
	anus = 1

/datum/species/vulpkanin
	genitals = 1
	anus = 1

/datum/species/human/skrell
	genitals = 1
	anus= 1
//races from eros codebase
/datum/species/akula
	genitals =1
	anus=1
/datum/species/Promethean
	genitals =1
	anus =1
/datum/species/Lamia
	genitals =1
	anus =1
/datum/species/Teshari
	genitals=1
	anus=1
/datum/species/Diona
	genitals =1
	anus =1
/datum/species/monkey
	genitals = 1
	anus = 1
//end of ported races

/datum/species/monkey/skrell
	genitals = 0

/mob/living/carbon/human/proc/is_nude()
	return (!wear_suit && !w_uniform && underwear == "Nude") ? 1 : 0
/mob/living/carbon/human/make_interaction()
	set_machine(src)
	var/mob/living/carbon/human/H = usr
	var/mob/living/carbon/human/P = H.partner
	var/obj/item/organ/external/temp = H.organs_by_name ["r_hand"]
	var/hashands =(temp && temp.is_usable())
	if(!hashands)
		temp = H.organs_by_name ["l_hand"]
		hashands =(temp && temp.is_usable())
	temp = P.organs_by_name ["r_hand"]
	var/hashands_p =(temp && temp.is_usable())
	if(!hashands_p)
		temp = P.organs_by_name ["l_hand"]
		hashands =(temp && temp.is_usable())
	var/mouthfree =!((H.head &&(H.head.flags & HEADCOVERSMOUTH)) ||(H.wear_mask &&(H.wear_mask.flags & MASKCOVERSMOUTH)))
	var/mouthfree_p =!((P.head &&(P.head.flags & HEADCOVERSMOUTH)) ||(P.wear_mask &&(P.wear_mask.flags & MASKCOVERSMOUTH)))
	var/haspenis =((H.gender == MALE && H.potenzia> -1 && H.species.genitals))
	var/haspenis_p =((P.gender == MALE && P.potenzia> -1 && P.species.genitals))
	var/hasvagina =(H.gender == FEMALE && H.species.genitals && H.species.name!= "Unathi" && H.species.name!= "Stok")
	var/hasvagina_p =(P.gender == FEMALE  && P.species.genitals && P.species.name!= "Unathi" && P.species.name!= "Stok")
	var/hasanus_p = P.species.anus
	var/isnude = H.is_nude()
	var/isnude_p = P.is_nude()

	H.lastfucked = null
	H.lfhole = ","

	var/dat = "<B><HR> <FONT size = 3> INTERACTIONS - [H.partner] </FONT> </B> <BR><HR>"
	//just some russian letter in cyrillic, probably means, "I"
	//var/ya = "&#1103;"
	var/ya = "I";
	dat += {"• <A href='?src=\ref[usr];interaction=bow'> bows. </A><BR>"}

//If(Adjacent(P))
//dat += {"• <A href='?src=\ref[src];interaction=handshake'> greet. </A> <BR>"}
//else
//dat += {"• <A href='?src=\ref[src];interaction=wave'> greet. </A> <BR>"}

//ERP AND EMOTE TEXTBOX WINDOW START
	if(hashands)
		dat += {"<font size = 3> <B> Hand Gestures </B> </font> <BR>"}
		if(Adjacent(P))
			dat += {"• <A href='?src=\ref[usr];interaction=handshake'> Shake hand. </A> <BR>"}
			dat += {"• <A href='?src=\ref[usr];interaction=hug'> Hug </A> <BR>"}
			dat += {"• <A href='?src=\ref[usr];interaction=cheer'> Cheer </A> <BR>"}
			dat += {"• <A href='?src=\ref[usr];interaction=five'> Hi-five </A> <BR>"}
			if(hashands_p)
				dat += {"• <A href='?src=\ref[src];interaction=give'> Give Item </A> <BR>"}
			dat += {"• <A href='?src=\ref[usr];interaction=slap'> <font color = red> Bitch-slap! </font> </A> <BR>"}
			if(isnude_p)
				if(hasanus_p)
					dat += {"• <A href='?src=\ref[usr];interaction=assslap'> Ass slap! </A> <BR>"}
				if(hasvagina_p)
					dat += {"• <A href='?src=\ref[usr];interaction=fingering'> Finger Pussy. </A> <BR>"}
			if(P.species.name == "Tajaran")
				dat += {"• <A href='?src=\ref[usr];interaction=pull'> <font color = red> Yank Tail. </font> </A> <BR>"}
				if(P.can_inject(H, 1))
					dat += {"• <A href='?src=\ref[usr];interaction=pet'> Pet Head. </A> <BR>"}
			dat += {"• <A href='?src=\ref[usr];interaction=knock'> <font color = red> Knock Head </font> </A> <BR>"}
		dat += {"• <A href='?src=\ref[usr];interaction=fuckyou'> <font color = red> Flip Obscene Middle Finger. </font> </A> <BR>"}
		dat += {"• <A href='?src=\ref[usr];interaction=threaten'> <font color = red> Threaten. </font> </A> <BR>"}

	if(mouthfree)
		dat += {"<font size = 3> <B> Facial Gestures </B> </font> <BR>"}
		dat += {"• <A href='?src=\ref[usr];interaction=kiss'> Kiss </A> <BR>"}
		if(Adjacent(P))
			if(mouthfree_p)
				if(H.species.name == "Tajaran")
					dat += {"• <A href='?src=\ref[usr];interaction=lick'> Lick Cheek </A> <BR>"}
			if(isnude_p)
				if(haspenis_p)
					dat += {"• <A href='?src=\ref[usr];interaction=blowjob'> <font color = purple> Suck Cock. </font> </A> <BR>"}
				if(hasvagina_p)
					dat += {"• <A href='?src=\ref[usr];interaction=vaglick'> <font color = purple> Lick Pussy </font> </A> <BR>"}
				if(hasanus_p)
					dat += {"• <A href='?src=\ref[usr];interaction=asslick'> <font color = purple> Rim Anus. </font> </A> <BR>"}
			dat += {"• <A href='?src=\ref[usr];interaction=spit'> <font color = red> Spit </font> </A> <BR>"}
		dat += {"• <A href='?src=\ref[usr];interaction=tongue'> <font color = red> Stick Out Tongue </font> </A> <BR>"}

	if(isnude && usr.loc == H.partner.loc)
		if(haspenis && hashands)
			dat += {"<font size = 3> <B> Penetration Gestures </B> </font> <BR>"}
			if(isnude_p)
				if(hasvagina_p)
					dat += {"• <A href='?src=\ref[usr];interaction=vaginal'> <font color = purple> Fuck Pussy </font> </A> <BR>"}
				if(hasanus_p)
					dat += {"• <A href='?src=\ref[usr];interaction=anal'> <font color = purple> Fuck Anus. </font> </A> <BR>"}
				if(mouthfree_p)
					dat += {"• <A href='?src=\ref[usr];interaction=oral'> <font color = purple> Oral fuck. </font> </A> <BR>"}
	if(isnude && usr.loc == H.partner.loc && hashands)
		if(hasvagina && haspenis_p)
			dat += {"<font size = 3> <B> Mount: </B> </font> <BR>"}
			dat += {"• <A href='?src=\ref[usr];interaction=mount'> <font color = purple> Ride! </font> </A> <BR> <HR>"}

	var/datum/browser/popup = new(usr, "interactions", "Interactions", 340, 480)
	popup.set_content(dat)
	popup.open()
//ERP TEXTBOX WINDOW END

//INTERACTIONS
/mob/living/carbon/human
	var/mob/living/carbon/human/partner
	var/mob/living/carbon/human/lastfucked
	var/lfhole
	var/potenzia = 10
	var/resistenza = 200
	var/lust = 0
	var/erpcooldown = 0
	var/multiorgasms = 0
	var/lastmoan

mob/living/carbon/human/proc/cum(mob/living/carbon/human/H as mob, mob/living/carbon/human/P as mob, 	var/hole = "floor")
	var/message = "ends up on the floor!"
	var/ya = "I"
	var/turf/T

	if(H.gender == MALE)
		var/datum/reagent/blood/source = H.get_blood(H.vessel)
		if(P)
			T = get_turf(P)
		else
			T = get_turf(H)
		if(H.multiorgasms <H.potenzia)
			var/obj/effect/decal/cleanable/cum/C= new (T)
			//Update cum information.
			C.blood_DNA = list()
			if(source.data["blood_type"])
				C.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
			else
				C.blood_DNA[source.data["blood_DNA"]] = "O +"

		if(H.species.genitals)
			if(hole == "mouth" || H.zone_sel.selecting == "mouth")
				message = pick("cums in [P]'s the mouth.","sprays a jet of semen on [P]'s face." ,"pumps load into [P]'s throat. ","semen drips to ends to the floor.")
			else if(hole == "vagina")
				message = pick("cum ends in [P]'s pussy", "fills up [P]'s with his pumping member, with cum finally spilling on the ground." ,"splurts multiple times inside the [P]'s pussy. As they lay on the ground, cum drips slowly from the orifice  of [P].")
			else if(hole == "anus")
				message = pick("cum fills up [P]'s asshole", "pulls shaft out of [P]'s ass, later profusely ejaculating on [P.gender == MALE?" his ":" her "] glutes.", "draw out cock from [P]'s ass and semen immediately descends to the floor.")
			else if(hole == "floor")
				message = "semen ends up on the floor!"
		else
			message = pick("ejaculates in a fit of orgasm", "closes his eyes and shivers" , "tenses up, and then suddenly relaxes as hot milk pours out," , "freezes, rolling his eyes in ectasy.")
		playsound(loc, "honk/sound/interactions/final_m [rand(1, 5)].ogg", 70, 1, 0, pitch = get_age_pitch())
		H.visible_message("<B> [H] [message] </B>")

		if(istype(P.loc,/obj/structure/closet))
			P.visible_message("<B>[H][message]</B>")
		H.lust = 5
		H.resistenza += 50

	else
		message = pick("ejaculates in a fit of orgasm", "closes eyes and shivers" , "tenses up, and then suddenly relaxes as hot milk pours out," , "freezes, rolling his eyes")
		H.visible_message("<B> [H] [message]. </B>")
		if(istype(P.loc, /obj/structure/closet))
			P.visible_message("<B>[H][message].</B>")
		playsound(loc, "honk/sound/interactions/final_f[rand(1, 3)].ogg", 90, 1, 0, pitch = get_age_pitch())
		var/delta = pick(20, 30, 40, 50)
		src.lust -= delta
	H.druggy = 60
	H.multiorgasms += 1
	if(H.multiorgasms == 1)
		add_logs(P, H, "came on")
	H.erpcooldown = rand(200, 450)
	if(H.multiorgasms> H.potenzia/3)
		if(H.staminaloss <P.potenzia * 4)
			H.staminaloss += H.potenzia
		if(H.staminaloss> 100)
			H.druggy = 300
			H.erpcooldown = 600
//ERP MECHANIC FUNCTION  START HERE

//H = User
//P = Partner
mob/living/carbon/human/proc/fuck(mob/living/carbon/human/H as mob, mob/living/carbon/human/P as mob, 	var/hole)
	var/ya = "I"
	var/message = ","

	switch(hole)

		if("vaglick")

			message = pick("opens the lower lips of [P].", "nudges [P]'s clit with tongue and makes way inside.")
			if(prob(35))
				switch(P.species.name)
					if("Human", "Slime People")
						message = pick("licks [P]'s pussy.", "cleans [P]'s pussy the tongue." , "nudges the clit of [P].", "caresses [P]'s pussy with a tongue." , "puts their tongue in [P]'s pussy ","cleans the juice from [P]'s lips with a tongue "," swirls tongue around [P]'s clit")
					if("Tajaran", "Vulpkanin")
						message = pick("lick [P].", "licks pussy of [P] with the tongue." , "nudges the clit of [P].", "caresses [P]'s pussy with a tongue." , "puts their tongue in [P]'s pussy ","cleans the juice from [P]'s lips with a tongue ","swirls tongue around [P]'s clit")
			if(H.lastfucked!= P || H.lfhole!= hole)
				H.lastfucked = P
				H.lfhole = hole
				add_logs(P, H, "licked")

			if(prob(5) && P.stat!= DEAD)
				H.visible_message("<font color = purple> <B>[H] [message]</B> </font>")
				P.lust += 10
			else
				H.visible_message("<font color = purple> [H] [message] </font>")
			if(istype(P.loc,/obj/structure/closet))
				P.visible_message("<font color = purple> [H] [message] </font>")
			if(P.stat!= DEAD && P.stat!= UNCONSCIOUS)
				P.lust += 10
				if(P.lust>= P.resistenza)
					P.cum(P,H)
				else
					P.moan()
			H.do_fucking_animation(P)

		if("fingering")

			message = pick("shoves fingers in the pussy of [P].", "tweaks [P]'s clit with two fingers.","rubs [P]'s labia.")
			if(prob(35))
				switch(P.species.name)
					if("Human", "Slime People")
						message = pick("rubs two fingers inside of [P]'s slimy lips.", "pulls [P]'s clit.", "pokes [P]'s vulva.", "caresses [P]'s lips with fingers." , "gently stroking [P]'s clit . "," he puts his fingers deep into the [P], weasel [ya] it from the inside. "," exploring the depths of [P]. ")
					if("Tajaran", "Vulpkanin")
						message = pick("rubs two fingers inside of [P]'s lips.", "pulls [P]'s clit.", "pokes [P]'s vulva.", "caresses [P]'s lips with fingers." , "gently stroking [P]'s. "," he puts his fingers deep into the [P], weasel [ya] it from the inside. "," exploring the depths of [P]. ")

			if(H.lastfucked!= P || H.lfhole!= hole)
				H.lastfucked = P
				H.lfhole = hole
				add_logs(P, H, "fingered")

			if(prob(5) && P.stat!= DEAD)
				H.visible_message("<font color = purple> <B> [H] [message] </B> </font>")
				P.lust += 8
			else
				H.visible_message("<font color = purple> [H] [message] </font>")
			if(istype(P.loc,/obj/structure/closet))
				P.visible_message("<font color = purple> [H] [message] </font>")
			if(P.stat!= DEAD && P.stat!= UNCONSCIOUS)
				P.lust += 8
				if(P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan()
			playsound(loc, "honk/sound/interactions/champ_fingering.ogg", 50, 1, -1)
			H.do_fucking_animation(P)
//blowjob is unfinished so far
		if("blowjob")

			switch(H.species.name)
				if("Human", "Skrell", "Grey", "Nucleation", "Plasmaman")
					message = pick("sucks [P]'s cock.", "sucks dick of [P].", "enlarges [P]'s member with their tongue.")
					if(prob(35))
						message = pick("kisses the abdomen of [P] and makes way for cock, covering their eyes with pleasure.", "yells, his eyes closed, without taking the [ya] member [P] mouth." , "caresses member [P] [ya] a tongue, holding the [ya] in his hand. "," licks member [P] throughout. "," immerses member [P] deeper into his mouth. "," tip of the [ya] tongue licking the head member [P]. "," spit on the tip of a member of the [P] and then takes it in her mouth. "," sucks a lollipop [P]. "," moving her head back and forth, stimulating the [ya] member [P]. "," thoroughly licks dick [P]. "," eyes closed, completely swallows baby [P]. "," he caresses member [P], succor [ya] himself with his hands. ")
					if(H.lastfucked!= P || H.lfhole!= hole)
						message = pick("wraps their lips around [P]'s member." , "starts sucking [P]'s shaft.")
						H.lastfucked = P
						H.lfhole = hole
						add_logs(P, H, "sucked")

				if("Unathi")
					message = pick("licks member of [P].", "stimulates the body [P] [ya] the tongue." , "The third member [P] on a [ya] tongue." , "pushing member [P] himself into the jaws of , old [ya] Referring not to catch it with his teeth. "," encourages member [P] [ya] the tongue. ")
					if(prob(35))
						message = pick("licks the abdomen of [P] and makes way for cock, covering their eyes in anticipation.", "shrieks, shuts eyes, and plungers [P]'s shaft with maw open.", "caresses [P]'s cock by swirling their tongue around it. ","directly licks [P]'s rods  throughout. "," plunges deeper [P]'s cock to crave it. "," swirls their tongue around the head of [P]'s cock. "," spits on the head of the [P]'s shaft, spreading saliva around while sucking. "," licks [P]'s shaft like a lollipop. "," rapidly moving their head back and forth, stimulating [P]'s dick. "," thoroughly licks [P]'s dick. "," shuts eyes, and paves way for completely swallowing [P]'s cock. "," caresses [P]'s member while playing with their own genitalia. ")
					if(H.lastfucked!= P || H.lfhole!= hole)
						message = pick("wraps their tongue around [P]'s member." , "starts sucking [P]'s shaft.")
						H.lastfucked = P
						H.lfhole = hole
						add_logs(P, H, "sucked")

				if("Tajaran", "Vulpkanin")
					message = pick("licks member of [P].", "encircles rough tongue around [P]'s pulsating shaft.", "gleefully opens their maw and makes way for  [P]'s cock, trying to avoid their teeth to contact" , "enlargens [P]'s member by circling their tongue around.")
					if(prob(35))
						message = pick("licks body of [P], shutting their eye in anticipation for cock.", "pants loudly, shuts their eyes as they take [P]'s member into their mouth.", "caresses [P]'s shaft with tongue, lightly gripping [P]'s balls. "," licks [P]'s cock throughout. "," deep throats [P]'s cock. "," circles tongue around [P]'s shaft head. "," salivates on the shaft of [P]'s cock and spreads it around. "," licks [P]'s cock like a lollipop. "," rapidly moves their head back and forth, stimulating [P]'s cock. "," thoroughly licks [P]'s dick by tongue polishing. "," closes eyes and sucks [P]'s cock. "," he lightly fondles [P]'s balls, sucking their cock while playing with their genitalia. ")
					if(H.lastfucked!= P || H.lfhole!= hole)
						message = pick("wraps their lips around [P]'s member." , "starts sucking [P]'s shaft.")
						H.lastfucked = P
						H.lfhole = hole
						add_logs(P, H, "sucked")

				if("Vox", "Vox Armalis")
					message = pick("licks [P]'s member.", "stimulates [P]'s." , "nuzzles [P]'s head." , "encircles tongue around [P]'s shaft. "," goes deeper into [P] with beak open. ")
					if(prob(35))
						message = pick("licks body of [P], covering their eyes with pleasure.", "gulps, his eyes closed and beak open, going further into [P]'s shaft." , "caresses [P]'s cock with their a tongue, while rubbing their with their wing. "," licks member of [P] throughout. "," immerses cock of [P] deeper their throat. "," licks [P]'s head with the tip of their tongue. "," spits on the tip of the [P]'s head to lubricate and goes further into throat. "," licks [P]'s cock like a lollipop. "," moves their head back and forth, stimulating [P]'s shaft. "," thoroughly licks the dick of [P]. "," eyes closed, completely swallows [P]'s cock. "," caresses [P]'s balls with their tongue. ")
					if(H.lastfucked!= P || H.lfhole!= hole)
						message = pick("wraps their tongue around [P]'s member." , "starts sucking [P]'s shaft.")
						H.lastfucked = P
						H.lfhole = hole
						add_logs(P, H, "sucked")

				if("Slime People")
					message = pick("sucks [P].", "sucks dick [P].", "lick member of [P] with tongue.")
					if(prob(35))
						message = pick("juicily kisses [P]'s shaft, covering their eyes with pleasure.", "gulps with their eyes closed, taking the member of [P] into their mouth." , "caresses member of [P] with their tongue, viscous mucus drips from the tip. "," licks member of [P] over the entire cock length, leaving a trail of slime behind. "," immerses member of [P] deeper into their mouth. "," licks the cock of [P] with tip of their tongue. "," wets [P]'s head with sticky mucus and then takes it into their throat. "," sucks [P]'s cock like a lollipop. "," moving their head back, stimulating [P]'s shaft. "," thoroughly licks member of [P]. "," shuts eyes, completely swallowing [P]'s shaft. "," caresses member of [P], sucking it with their hands. ")
					if(H.lastfucked!= P || H.lfhole!= hole)
						message = pick(" wraps member of [P] with their lips, enveloping it in slime." , "starts sucking [P]'s dick.")
						H.lastfucked = P
						H.lfhole = hole
						add_logs(P, H, "sucked")

				if("Kidan")
					return

				if("Wryn")
					return

			if(H.lust <6)
				H.lust += 6
			if(prob(5) && P.stat!= DEAD)
				H.visible_message("<font color = purple> <B> [H] [message] </B> </font>")
				P.lust += 10
			else
				H.visible_message("<font color = purple> [H] [message] </font>")
			if(istype(P.loc,/obj/structure/closet))
				P.visible_message("<font color = purple> [H] [message] </font>")
			if(P.stat!= DEAD && P.stat!= UNCONSCIOUS)
				P.lust += 10
				if(P.lust >= P.resistenza)
					P.cum(P, H, "mouth")
			playsound(loc, "honk/sound/interactions/bj [rand(1, 11)]. ogg", 50, 1, -1)
			H.do_fucking_animation(P)
			if(prob(P.potenzia))
				H.oxyloss += 3
				H.visible_message("<B> [H] </B> [pick(" chokes on the cock of [P] </B> "," nearly suffocates from the stream of semen in their throat "," coughs out a puddle of cum ")].")
				if(istype(P.loc,/obj/structure/closet))
					P.visible_message("<B> [H] </B> [pick(" chokes on the cock of [P] </B> "," nearly suffoctes from the stream of semen in their throat "," coughs out a puddle of cum ")].")

		if("vaginal")
//general fucking messages
			message = pick("fucks [P].", "pounds [P].", "hammers [P].")
			if(prob(35))
				switch(P.species.name)//special lines of fucking (aka "critical hits"!)
					if("Human")
						message = pick("roughly fucks [P].", "passionately pounds in love in [P]'s lower lips.", "pounds [P] with cock.", "pumps member inside of [P].","thrusts pelvis into [P]'s pussy. "," moans, pumping cock [P] further. "," deeply fucks [P]. "," skewers [P] with their shaft. "," sensually fucks [P]. ")
					if("Tajaran", "Vulpkanin")
						message = pick("roughly fucks the pussy of [P].", "is passionately in love with [P].", "suddenly thrusts into [P].", "enlarges [P]'s lips. "," hits [P] in the cervix using their shaft. "," moans, thrusting hips into [P]. "," shoves their cock into [P]'s pussy. "," skewer [P] with their cock dick. "," sensually fucks [P]. ")
					if("Slime People")
						message = pick("roughly fucks [P].", "passionately in love with [P].", "suddenly thrusts into [P].", "enlargens [P]'s lips. "," hits [P] in the cervix using their shaft. "," moans, thrusting hips into [P]. "," strongly pressed their cock [P]'s pussy. "," skewer [P] with their cock dick. "," sensually fucks [P]. ")
						playsound(loc, "honk/sound/interactions/champ [rand(1, 2)]. ogg", 50, 1, -1)
//first time
			if(H.lastfucked!= P || H.lfhole!= hole)
				message = pick("thrusts their cock into [P].", "shoves his member into [P]'s pussy.", "shafts his way into [P]'s pussy.", "mercilessly tears his rod into [P]'s pussy. ")
				H.lastfucked = P
				H.lfhole = hole
				add_logs(P, H, "fucked")

			if(prob(5) && P.stat!= DEAD)
				H.visible_message("<font color = purple> <B> [H] [message] </B> </font>")
				P.lust += H.potenzia * 2
			else
				H.visible_message("<font color = purple> [H] [message] </font>")
			if(istype(P.loc,/obj/structure/closet))
				P.visible_message("<font color = purple> [H] [message] </font>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 10
			if(H.lust >= H.resistenza)
				H.cum(H, P, "vagina")

			if(P.stat!= DEAD && P.stat!= UNCONSCIOUS)
				P.lust += H.potenzia * 0.5
				if(H.potenzia> 20)
					P.staminaloss += H.potenzia * 0.25
				if(P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan()
			H.do_fucking_animation(P)
			playsound(loc, "honk/sound/interactions/bang [rand(1, 3)]. ogg", 70, 1, -1)

		if("anal")

			message = pick("hammers [P]'s in the ass with their cock." , "pounds [P]'s asshole.", "fucks [P] in the ass.")
			if(prob(35))
				switch(P.species.name)
					if("Human", "Nucleation")
						message = pick("fucks [P]'s ass." , "thrusts member into [P]'s in asshole." , "digs through the depths of [P].", "tears through the asshole of [P]. "," launches its miner in the coal mines of [P]. ")
					if("Unathi")
						message = pick("drills [P]'s cloaca." , "thrusts member into [P]'s lizard pussy." , "digs through [P].", "tearing [P] point frantic friktsiymi. "," launches its miner in the coal mines [P]. ")
					if("Tajaran", "Vulpkanin")
						message = pick("pounds [P]'s tailhole." , "thrusts member into [P]'s tailhole.", "hammers [P]'s beast bum hidden under a fluffy tail." , "digs through [P] further in search of minerals. "," tears [P] further by going deeper. "," launches its miner in the coal mines [P]. ")
					if("Skrell", "Grey")
						message = pick("fucks [P]'s asshole!" , "thrusts member into [P]'s uranus." , "digs through the depths of [P].", "tears through the fractures of [P]. "," launches its miner in the coal mines [P]. ")
					if("Slime People")
						message = pick("fuck [P]'s jellyfilled ass." , "thrusts member [P] into mucus ." , " draws liquid as they pentrate through the ass of [P]. ")
						playsound(loc, "honk/sound/interactions/champ [rand(1, 2)]. ogg", 50, 1, -1)

			if(H.lastfucked!= P || H.lfhole!= hole)
				message = pick("mercilessly rips the anus of [P].", "thrusts member into [P]'s virgin ass.")
				H.lastfucked = P
				H.lfhole = hole
				add_logs(P, H, "fucked in anus")

			if(prob(5) && P.stat!= DEAD)
				H.visible_message("<font color = purple> <B> [H] [message] </B> </font>")
				P.lust += H.potenzia * 2
			else
				H.visible_message("<font color = purple> [H] [message] </font>")
			if(istype(P.loc,/obj/structure/closet))
				P.visible_message("<font color = purple> [H] [message] </font>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 12
			if(H.lust >= H.resistenza)
				H.cum(H, P, "anus")

			if(P.stat!= DEAD && P.stat!= UNCONSCIOUS)
				if(H.potenzia> 13)
					P.lust += H.potenzia * 0.25
					P.staminaloss += H.potenzia * 0.25
				else
					P.lust += H.potenzia * 0.75
				if(P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan()
			H.do_fucking_animation(P)
			playsound(loc, "honk/sound/interactions/bang [rand(1, 3)]. ogg", 70, 1, -1)

		if("oral")

			message = pick("fucks [P] by shoving their shaft down [P.gender == FEMALE?" her ":" his "] throat." , "fucks [P] orally.")
			if(prob(35))
				switch(P.species.name) //these lines are all different. I just replaced them since their lines had minor variatons, will change later
					if("Human", "Skrell", "Grey", "Plasmaman")
						message = pick("grabs [P]'s head and forces [P.gender == FEMALE?" her ":" him "] to suck their cock. [P] is mericilessly forced to take their member."," fucks [P] in the orally "," shoves [P] on their cock "," holds the head of [P] with two hands and forces their head down their cock. "," slaps [P], continuing to force the victim to suck their shaft. ",", growling through clenched teeth, [P] begrudgingly sucks cock from them")
					if("Unathi")
						message = pick("grabs [P]'s head and forces [P.gender == FEMALE?" her ":" him "] to suck their cock. [P] is mericilessly forced to take their member."," fucks [P] in the orally "," shoves [P] on their cock "," holds the head of [P] with two hands and forces their head down their cock. "," slaps [P], continuing to force the victim to suck their shaft. ",", growling through clenched teeth, [P] begrudgingly sucks cock from them")
					if("Tajaran", "Vulpkanin")
						message = pick("grabs [P]'s head and forces [P.gender == FEMALE?" her ":" him "] to suck their cock. [P] is mericilessly forced to take their member."," fucks [P] in the orally "," shoves [P] on their cock "," holds the head of [P] with two hands and forces their head down their cock. "," slaps [P], continuing to force the victim to suck their shaft. ",", growling through clenched teeth, [P] begrudgingly sucks cock from them")
					if("Vox", "Vox Armalis")
						message = pick("grabs [P]'s head and forces [P.gender == FEMALE?" her ":" him "] to suck their cock. [P] is mericilessly forced to take their member."," fucks [P] in the orally "," shoves [P] on their cock "," holds the head of [P] with two hands and forces their head down their cock. "," slaps [P], continuing to force the victim to suck their shaft. ",", growling through clenched teeth, [P] begrudgingly sucks cock from them")
					if("Slime People")
						message = pick("grabs [P]'s head and forces [P.gender == FEMALE?" her ":" him "] to suck their cock. [P] is mericilessly forced to take their member."," fucks [P] in the orally "," shoves [P] on their cock "," holds the head of [P] with two hands and forces their head down their cock. "," slaps [P], continuing to force the victim to suck their shaft. ",", growling through clenched teeth, [P] begrudgingly sucks cock from them")

			if(H.lastfucked!= P || H.lfhole!= hole)
				message = pick("unceremoniously pushes his dick in [P]'s throat.")
				H.lastfucked = P
				H.lfhole = hole
				add_logs(P, H, "fucked in mouth")

			if(prob(5) && H.stat!= DEAD)
				H.visible_message("<font color = purple> <B> [H] [message] </B> </font>")
				H.lust += 15
			else
				H.visible_message("<font color = purple> [H] [message] </font>")
			if(istype(P.loc,/obj/structure/closet))
				P.visible_message("<font color = purple> [H] [message] </font>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 15
			if(H.lust >= H.resistenza)
				H.cum(H, P, "mouth")

			H.do_fucking_animation(P)
			playsound(loc, "honk/sound/interactions/oral [rand(1, 2)]. ogg", 70, 1, -1)
			if(P.species.name == "Slime People")
				playsound(loc, "honk/sound/interactions/champ [rand(1, 2)]. ogg", 50, 1, -1)
			if(prob(H.potenzia))
				P.oxyloss += 3
				H.visible_message("<B> [P] </B> [pick(" chokes from the stream of cum by <B> [H] </B> "," suffocates from the amount of semen in their throats "," becomes alarmed by the huge amount of semen in their throats ")].")
				if(istype(P.loc,/obj/structure/closet))
					P.visible_message("<B> [P] </B> [pick(" chokes from the stream of cum by <B> [H] </B> "," suffocates from the amount of semen in their throats "," becomes alarmed by the huge amount of semen in their throats ")].")


		if("mount")

			message = pick("rides on the shaft of [P]", "thusts hips down on [P]'s", "hops on [P]'s cock", "rides [P]'s dick")
			if(prob(35))
				message = pick("saddles on [P], like a cowboy in the wild west!", "hops on [P]", "jumping on the cock of [P], strike [ya] [ya] camping on his smooth skin," , "joyfully bounces, delivered [ya] [ya] enjoy themselves and [P] "," put her pelvis in the [P] and crawl like fidget, "," doing somersaults on the genitals [P] "," skipping navalivaets [ya] to [P], taken [ya] in inside his penis, "," sprinkles their fold on the hook [P], giving [ya] it his pelvis "," admits Seb inside [ya] animal [P] ")

			if(H.lastfucked!= P || H.lfhole!= hole)
				message = pick("cautiously spreads their lower orifice on the shaft of [P]")
				H.lastfucked = P
				H.lfhole = hole
				add_logs(P, H, "fucked")

			if(prob(5) && P.stat!= DEAD)
				H.visible_message("<font color = purple> <B> [H] [message]. </B> </font>")
				P.lust += H.potenzia * 2
			else
				H.visible_message("<font color = purple> [H] [message]. </Font>")
			if(istype(P.loc,/obj/structure/closet))
				P.visible_message("<font color = purple> [H] [message]. </Font>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += P.potenzia
			if(P.potenzia> 20)
				H.staminaloss += P.potenzia * 0.25
			if(H.lust >= H.resistenza)
				H.cum(H, P)
			else
				H.moan()
			if(P.stat!= DEAD && P.stat!= UNCONSCIOUS)
				P.lust += H.potenzia
				if(P.lust >= P.resistenza)
					P.cum(P, H, "vagina")
				else
					P.moan()
			H.do_fucking_animation(P)
			playsound(loc, "honk/sound/interactions/bang [rand(1, 3)]. ogg", 70, 1, -1)
			if(H.species.name == "Slime People")
				playsound(loc, "honk/sound/interactions/champ [rand(1, 2)]. ogg", 50, 1, -1)

mob/living/carbon/human/proc/moan()
	var/ya = "I"
	var/mob/living/carbon/human/H = src
	switch(species.name)
		if("Human", "Skrell", "Slime People", "Grey", "Nucleation", "Plasmaman")
			if(prob(H.lust/H.resistenza * 65))
				var/message = pick("moans loudly in pleasure", "moans thoughtlessly", "rolls eyes passionately, dazed by love", "bites lip in desire")
				H.visible_message("<B> [H] </B> [message].")
				var/g = H.gender == FEMALE? "F": "m"
				var/moan = rand(1, 7)
				if(moan == lastmoan)
					moan--
				if(! istype(loc,/obj/structure/closet))
					playsound(loc, "honk/sound/interactions/moan_ [g] [moan] .ogg", 70, 1, 0, pitch = get_age_pitch())
				else if(g == "f")
					playsound(loc, "honk/sound/interactions/under_moan_f [rand(1, 4)]. ogg", 70, 1, 0, pitch = get_age_pitch())
				lastmoan = moan

				if(istype(H.head,/obj/item/clothing/head/kitty) || istype(H.head,/obj/item/clothing/head/collectable/kitty))
					playsound(loc, "honk/sound/interactions/purr_f [rand(1, 3)]. ogg", 70, 1, 0)

		if("Tajaran")
			if(prob(H.lust/src.resistenza * 70))
				var/message = pick("mews with sensation", "purrs with pleasure", "rolls eyes", "whimpers to beckon for more")
				H.visible_message("<B> [H] </B> [message].")
				playsound(loc, "honk/sound/interactions/purr [rand(1, 3)]. ogg", 70, 1, 0, pitch = get_age_pitch())

		if("Vulpkanin")
			if(prob(H.lust/src.resistenza * 70))
				var/message = pick("whimpers" , "whimpers with pleasure", "rolls eyes", "beckons for more")
				H.visible_message("<B> [H] </B> [message].")

		if("Unathi")
			if(prob(H.lust/H.resistenza * 70))
				var/message = pick("hisses softly" , "hissed in ectasy")
				H.visible_message("<B> [H] </B> [message].")

		if("Kidan", "Wryn")
			if(prob(H.lust/H.resistenza * 70))
				var/message = pick("chatters in pleasure", "shuts mandible in ectasy")
				H.visible_message("<B> [H] </B> [message].")


mob/living/carbon/human/proc/handle_lust()
	lust -= 4
	if(lust <= 0)
		lust = 0
		lastfucked = null
		lfhole = ""
		multiorgasms = 0
	if(lust == 0)
		erpcooldown -= 1
	if(erpcooldown <0)
		erpcooldown = 0

/mob/living/carbon/human/proc/do_fucking_animation(mob/living/carbon/human/P)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/final_pixel_y = initial(pixel_y)

	var/direction = get_dir(src, P)
	if(direction & NORTH)
		pixel_y_diff = 8
	else if(direction & SOUTH)
		pixel_y_diff = -8

	if(direction & EAST)
		pixel_x_diff = 8
	else if(direction & WEST)
		pixel_x_diff = -8

	if(pixel_x_diff == 0 && pixel_y_diff == 0)
		pixel_x_diff = rand(-3,3)
		pixel_y_diff = rand(-3,3)
		animate(src, pixel_x = pixel_x +pixel_x_diff, pixel_y = pixel_y +pixel_y_diff, time = 2)
		animate(pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)
		return

	animate(src, pixel_x = pixel_x +pixel_x_diff, pixel_y = pixel_y +pixel_y_diff, time = 2)
	animate(pixel_x = initial(pixel_x), pixel_y = final_pixel_y, time = 2)

/obj/item/weapon/enlarger
	name = "penis enlarger"
	desc = "Very special DNA mixture which helps YOU to enlarge your little captain."
	icon = 'icons/obj/items.dmi'
	icon_state = "dnainjector"
	item_state = "dnainjector"
	hitsound = null
	throwforce = 0
	w_class = 1
	throw_speed = 3
	throw_range = 15
	attack_verb = list("stabbed")

/obj/item/weapon/enlarger/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(istype(M,/mob/living/carbon/human) &&(M.gender == MALE))
		M.potenzia = 30
		to_chat(user, "<span class = 'warning'> Your penis extends! </span>")

	else if(istype(M,/mob/living/carbon/human) && M.gender == FEMALE)
		to_chat(user, "<span class = 'warning'> It did not affect you since you're female! </span>")

	..()

	qdel(src)

/obj/item/weapon/enlarger/attack_self(mob/user as mob)
	to_chat(user, "<span class = 'warning'> You break the syringe. Gooey mass is dripping on the floor. </span>")
	qdel(src)

/obj/item/weapon/dildo
	name = "dildo"
	desc = "Hm-m-m, deal thow"
	icon = 'icons/obj/items/dildo.dmi'
	icon_state = "dildo"
	item_state = "c_tube"
	throwforce = 0
	force = 10
	w_class = 1
	throw_speed = 3
	throw_range = 15
	attack_verb = list("slammed", "bashed", "whipped")
	var/hole = "vagina"//or "anus"
	var/rus_name = "dildo"
	var/ya = "I"
	var/pleasure = 10

/obj/item/weapon/dildo/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	var/hasvagina =(M.gender == FEMALE && M.species.genitals && M.species.name!= "Unathi" && M.species.name!= "Stok")
	var/hasanus = M.species.anus
	var/message = ","

	if(istype(M,/mob/living/carbon/human) && user.zone_sel.selecting == "groin" && M.is_nude())
		if(hole == "vagina" && hasvagina)
			if(user == M)
				message = pick("satisfy [ya] is SEB [ya] via [rus_name]", "pushes in SEB [ya] [rus_name]", "puts [rus_name] in its bosom")
		else
			message = pick("satisfy [ya] is [M] via [rus_name]", "pushes in [M] [rus_name]", "puts [rus_name] into the fold [M]")

		if(prob(5) && M.stat!= DEAD && M.stat!= UNCONSCIOUS)
			user.visible_message("<font color = purple> <B> [user] [message]. </B> </font>")
			M.lust += pleasure * 2

		else if(M.stat!= DEAD && M.stat!= UNCONSCIOUS)
			user.visible_message("<font color = purple> [user] [message]. </font>")
			M.lust += pleasure

		if(M.lust >= M.resistenza)
			M.cum(M, user, "floor")
		else
			M.moan()
		user.do_fucking_animation(M)
		playsound(loc, "honk/sound/interactions/bang [rand(4, 6)]. ogg", 70, 1, -1)

	else if(hole == "anus" && hasanus)
		if(user == M)
			message = pick("satisfies themselves anally using a [rus_name]," , "pushes [rus_name] their anus", "clean the chimney using the [rus_name]")
		else
			message = pick("satisfies [M] anally using a [rus_name]", "pushes [rus_name] in the ass of [M]", "clean the [M]'s chimney, using the [rus_name]")

		if(prob(5) && M.stat!= DEAD && M.stat!= UNCONSCIOUS)
			user.visible_message("<font color = purple> <B> [user] [message]. </B> </font>")
			M.lust += pleasure * 2

		else if(M.stat!= DEAD && M.stat!= UNCONSCIOUS)
			user.visible_message("<font color = purple> [user] [message]. </font>")
			M.lust += pleasure

		if(M.lust >= M.resistenza)
			M.cum(M, user, "floor")
		else
			M.moan()
		user.do_fucking_animation(M)
		playsound(loc, "honk/sound/interactions/bang [rand(4, 6)]. ogg", 70, 1, -1)

	else
		..()
else
	..()

/obj/item/weapon/dildo/attack_self(mob/user as mob)
	if(hole == "vagina")
		hole = "anus"
	else
		hole = "vagina"
	to_chat(user, "<span class = 'warning'> Hm-m-m. Maybe we should put it in [hole]?! </span>")