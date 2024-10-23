
//WickedTempest: Chakat Tempest
/obj/item/implant/reagent_generator/tempest
	generated_reagents = list("milk" = 2)
	reagent_name = "milk"
	usable_volume = 1000

	empty_message = list("Your breasts are almost completely drained!")
	full_message = list("Your teats feel heavy and swollen!")
	emote_descriptor = list("squeezes milk", "tugs on Tempest's breasts, milking them")
	self_emote_descriptor = list("squeeze")
	random_emote = list("moos quietly")
	verb_name = "Milk"
	verb_desc = "Grab Tempest's nipples and milk them into a container! May cause blushing and groaning."

/obj/item/implanter/reagent_generator/tempest
	implant_type = /obj/item/implant/reagent_generator/tempest


//Hottokeeki: Belle Day
/obj/item/implant/reagent_generator/belle
	generated_reagents = list("milk" = 2)
	reagent_name = "milk"
	usable_volume = 5000

	empty_message = list("Your breasts and or udder feel almost completely drained!", "You're feeling a liittle on the empty side...")
	full_message = list("You're due for a milking; your breasts and or udder feel heavy and swollen!", "Looks like you've got some full tanks!")
	emote_descriptor = list("squeezes milk", "tugs on Belle's breasts/udders, milking them", "extracts milk")
	self_emote_descriptor = list("squeeze", "extract")
	random_emote = list("moos", "mrours", "groans softly")
	verb_name = "Milk"
	verb_desc = "Obtain Belle's milk and put it into a container! May cause blushing and groaning, or arousal."

/obj/item/implanter/reagent_generator/belle
	implant_type = /obj/item/implant/reagent_generator/belle

//Gowst: Eldi Moljir
//Eldi iz coolest elf-dorf.
/obj/item/implant/reagent_generator/eldi
	name = "lactation implant"
	desc = "This is an implant that allows the user to lactate."
	generated_reagents = list("milk" = 2)
	reagent_name = "milk"
	usable_volume = 1000

	empty_message = list("Your breasts feel unusually empty.", "Your chest feels lighter - your milk supply is empty!", "Your milk reserves have run dry.", "Your grateful nipples ache as the last of your milk leaves them.")
	full_message = list("Your breasts ache badly - they are swollen and feel fit to burst!", "You need to be milked! Your breasts feel bloated, eager for release.", "Your milky breasts are starting to leak...")
	emote_descriptor = list("squeezes Eldi's nipples, milking them", "milks Eldi's breasts", "extracts milk")
	self_emote_descriptor = list("squeeze out", "extract")
	random_emote = list("surpresses a moan", "gasps sharply", "bites her lower lip")
	verb_name = "Milk"
	verb_desc = "Grab Eldi's breasts and milk her, storing her fresh, warm milk in a container. This will undoubtedly turn her on."

/obj/item/implanter/reagent_generator/eldi
	implant_type = /obj/item/implant/reagent_generator/eldi

//Vorrarkul: Theodora Lindt
/obj/item/implant/reagent_generator/vorrarkul
	generated_reagents = list("chocolate_milk" = 2)
	reagent_name = "chocalate milk"
	usable_volume = 1000

	empty_message = list("Your nipples are sore from being milked!")
	full_message = list("Your breasts are full, their sweet scent emanating from your chest!")
	emote_descriptor = list("squeezes chocolate milk from Theodora", "tugs on Theodora's nipples, milking them", "kneads Theodora's breasts, milking them")
	self_emote_descriptor = list("squeeze", "knead")
	random_emote = list("moans softly", "gives an involuntary squeal")
	verb_name = "Milk"
	verb_desc = "Grab Theodora's breasts and extract delicious chocolate milk from them!"

/obj/item/implanter/reagent_generator/vorrarkul
	implant_type = /obj/item/implant/reagent_generator/vorrarkul

//Lycanthorph: Savannah Dixon
/obj/item/implant/reagent_generator/savannah
	generated_reagents = list("milk" = 2)
	reagent_name = "milk"
	usable_volume = 1000

	empty_message = list("Your nipples are sore from being milked!", "Your breasts feel drained, milk is no longer leaking from your nipples!")
	full_message = list("Your breasts are full, their sweet scent emanating from your chest!", "Your breasts feel full, milk is starting to leak from your nipples, filling the air with it's sweet scent!")
	emote_descriptor = list("squeezes sweet milk from Savannah", "tugs on Savannah's nipples, milking them", "kneads Savannah's breasts, milking them")
	self_emote_descriptor = list("squeeze", "knead")
	random_emote = list("lets out a soft moan", "gives an involuntary squeal")
	verb_name = "Milk"
	verb_desc = "Grab Savannah's breasts and extract sweet milk from them!"

/obj/item/implanter/reagent_generator/savannah
	implant_type = /obj/item/implant/reagent_generator/savannah

//SpoopyLizz: Roiz Lizden
//I made this! Woo!
//implant
//--------------------
/obj/item/implant/reagent_generator/roiz
	name = "egg laying implant"
	desc = "This is an implant that allows the user to lay eggs."
	generated_reagents = list("egg" = 2)
	usable_volume = 500
	transfer_amount = 50

	empty_message = list("Your lower belly feels smooth and empty. Sorry, we're out of eggs!", "The reduced pressure in your lower belly tells you there are no more eggs.")
	full_message = list("Your lower belly looks swollen with irregular bumps, and it feels heavy.", "Your lower abdomen feels really heavy, making it a bit hard to walk.")
	emote_descriptor = list("an egg right out of Roiz's lower belly!", "into Roiz' belly firmly, forcing him to lay an egg!", "Roiz really tight, who promptly lays an egg!")
	var/verb_descriptor = list("squeezes", "pushes", "hugs")
	var/self_verb_descriptor = list("squeeze", "push", "hug")
	var/short_emote_descriptor = list("lays", "forces out", "pushes out")
	self_emote_descriptor = list("lay", "force out", "push out")
	random_emote = list("hisses softly with a blush on his face", "yelps in embarrassment", "grunts a little")
	assigned_proc = /mob/living/carbon/human/proc/use_reagent_implant_roiz

/obj/item/implant/reagent_generator/roiz/post_implant(mob/living/carbon/source)
	START_PROCESSING(SSobj, src)
	to_chat(source, span_notice("You implant [source] with \the [src]."))
	add_verb(source, assigned_proc)
	return 1

/obj/item/implanter/reagent_generator/roiz
	implant_type = /obj/item/implant/reagent_generator/roiz

/mob/living/carbon/human/proc/use_reagent_implant_roiz()
	set name = "Lay Egg"
	set desc = "Force Roiz to lay an egg by squeezing into his lower body! This makes the lizard extremely embarrassed, and it looks funny."
	set category = "Object"
	set src in view(1)

	//do_reagent_implant(usr)
	if(!isliving(usr) || !usr.checkClickCooldown())
		return

	if(usr.incapacitated() || usr.stat > CONSCIOUS)
		return

	var/obj/item/implant/reagent_generator/roiz/rimplant
	for(var/obj/item/organ/external/E in organs)
		for(var/obj/item/implant/I in E.implants)
			if(istype(I, /obj/item/implant/reagent_generator))
				rimplant = I
				break
	if (rimplant)
		if(rimplant.reagents.total_volume <= rimplant.transfer_amount)
			to_chat(src, span_notice("[pick(rimplant.empty_message)]"))
			return

		new /obj/item/reagent_containers/food/snacks/egg/roiz(get_turf(src))

		var/index = rand(0,3)

		if (usr != src)
			var/emote = rimplant.emote_descriptor[index]
			var/verb_desc = rimplant.verb_descriptor[index]
			var/self_verb_desc = rimplant.self_verb_descriptor[index]
			usr.visible_message(span_notice("[usr] [verb_desc] [emote]"),
							span_notice("You [self_verb_desc] [emote]"))
		else
			visible_message(span_notice("[src] [pick(rimplant.short_emote_descriptor)] an egg."),
								span_notice("You [pick(rimplant.self_emote_descriptor)] an egg."))
		if(prob(15))
			visible_message(span_notice("[src] [pick(rimplant.random_emote)].")) // M-mlem.

		rimplant.reagents.remove_any(rimplant.transfer_amount)

//Cameron653: Jasmine Lizden
/obj/item/implant/reagent_generator/jasmine
	name = "egg laying implant"
	desc = "This is an implant that allows the user to lay eggs."
	generated_reagents = list("egg" = 2)
	usable_volume = 500
	transfer_amount = 50

	empty_message = list("Your lower belly feels flat, empty, and somewhat rough!", "Your lower belly feels completely empty, no more bulges visible... At least, for the moment!")
	full_message = list("Your lower belly is stretched out, smooth,and heavy, small bulges visible from within!", "It takes considerably more effort to move yourself, the large bulges within your gut most likely the cause!")
	emote_descriptor = list("an egg from Jasmine's tauric belly!", "into Jasmine's gut, forcing her to lay a considerably large egg!", "Jasmine with a considerable amount of force, causing an egg to slip right out of her!")
	var/verb_descriptor = list("squeezes", "pushes", "hugs")
	var/self_verb_descriptor = list("squeeze", "push", "hug")
	var/short_emote_descriptor = list("lays", "forces out", "pushes out")
	self_emote_descriptor = list("lay", "force out", "push out")
	random_emote = list("hisses softly with a blush on her face", "bites down on her lower lip", "lets out a light huff")
	assigned_proc = /mob/living/carbon/human/proc/use_reagent_implant_jasmine

/obj/item/implant/reagent_generator/jasmine/post_implant(mob/living/carbon/source)
	START_PROCESSING(SSobj, src)
	to_chat(source, span_notice("You implant [source] with \the [src]."))
	add_verb(source, assigned_proc)
	return 1

/obj/item/implanter/reagent_generator/jasmine
	implant_type = /obj/item/implant/reagent_generator/jasmine

/mob/living/carbon/human/proc/use_reagent_implant_jasmine()
	set name = "Lay Egg"
	set desc = "Cause Jasmine to lay an egg by squeezing her tauric belly!"
	set category = "Object"
	set src in view(1)

	//do_reagent_implant(usr)
	if(!isliving(usr) || !usr.checkClickCooldown())
		return

	if(usr.incapacitated() || usr.stat > CONSCIOUS)
		return

	var/obj/item/implant/reagent_generator/jasmine/rimplant
	for(var/obj/item/organ/external/E in organs)
		for(var/obj/item/implant/I in E.implants)
			if(istype(I, /obj/item/implant/reagent_generator))
				rimplant = I
				break
	if (rimplant)
		if(rimplant.reagents.total_volume <= rimplant.transfer_amount)
			to_chat(src, span_notice("[pick(rimplant.empty_message)]"))
			return

		new /obj/item/reagent_containers/food/snacks/egg/roiz(get_turf(src))

		var/index = rand(0,3)

		if (usr != src)
			var/emote = rimplant.emote_descriptor[index]
			var/verb_desc = rimplant.verb_descriptor[index]
			var/self_verb_desc = rimplant.self_verb_descriptor[index]
			usr.visible_message(span_notice("[usr] [verb_desc] [emote]"),
							span_notice("You [self_verb_desc] [emote]"))
		else
			visible_message(span_notice("[src] [pick(rimplant.short_emote_descriptor)] an egg."),
								span_notice("You [pick(rimplant.self_emote_descriptor)] an egg."))
		if(prob(15))
			visible_message(span_notice("[src] [pick(rimplant.random_emote)]."))

		rimplant.reagents.remove_any(rimplant.transfer_amount)

//Draycu: Schae Yonra
/obj/item/implant/reagent_generator/yonra
	name = "egg laying implant"
	desc = "This is an implant that allows the user to lay eggs."
	generated_reagents = list("egg" = 2)
	usable_volume = 500
	transfer_amount = 50

	empty_message = list("Your feathery lower belly feels smooth and empty. For now...", "The lack of clacking eggs in your abdomen lets you know you're free to continue your day as normal.",  "The reduced pressure in your lower belly tells you there are no more eggs.", "With a soft sigh, you can feel your lower body is empty.  You know it will only be a matter of time before another batch fills you up again, however.")
	full_message = list("Your feathery lower belly looks swollen with irregular bumps, and feels very heavy.", "Your feathery covered lower abdomen feels really heavy, making it a bit hard to walk.", "The added weight from your collection of eggs constantly reminds you that you'll have to lay soon!", "The sounds of eggs clacking as you walk reminds you that you will have to lay soon!")
	emote_descriptor = list("an egg right out of Yonra's feathery crotch!", "into Yonra's belly firmly, forcing her to lay an egg!", ", making Yonra gasp and softly moan while an egg slides out.")
	var/verb_descriptor = list("squeezes", "pushes", "hugs")
	var/self_verb_descriptor = list("squeeze", "push", "hug")
	var/short_emote_descriptor = list("lays", "forces out", "pushes out")
	self_emote_descriptor = list("lay", "force out", "push out")
	random_emote = list("hisses softly with a blush on her face", "yelps in embarrassment", "grunts a little")
	assigned_proc = /mob/living/carbon/human/proc/use_reagent_implant_yonra

/obj/item/implant/reagent_generator/yonra/post_implant(mob/living/carbon/source)
	START_PROCESSING(SSobj, src)
	to_chat(source, span_notice("You implant [source] with \the [src]."))
	add_verb(source, assigned_proc)
	return 1

/obj/item/implanter/reagent_generator/yonra
	implant_type = /obj/item/implant/reagent_generator/yonra

/mob/living/carbon/human/proc/use_reagent_implant_yonra()
	set name = "Lay Egg"
	set desc = "Force Yonra to lay an egg by squeezing into her lower body! This makes the Teshari stop whatever she is doing at the time, greatly embarassing her."
	set category = "Object"
	set src in view(1)

	//do_reagent_implant(usr)
	if(!isliving(usr) || !usr.checkClickCooldown())
		return

	if(usr.incapacitated() || usr.stat > CONSCIOUS)
		return

	var/obj/item/implant/reagent_generator/yonra/rimplant
	for(var/obj/item/organ/external/E in organs)
		for(var/obj/item/implant/I in E.implants)
			if(istype(I, /obj/item/implant/reagent_generator))
				rimplant = I
				break
	if (rimplant)
		if(rimplant.reagents.total_volume <= rimplant.transfer_amount)
			to_chat(src, span_notice("[pick(rimplant.empty_message)]"))
			return

		new /obj/item/reagent_containers/food/snacks/egg/teshari(get_turf(src))

		var/index = rand(0,3)

		if (usr != src)
			var/emote = rimplant.emote_descriptor[index]
			var/verb_desc = rimplant.verb_descriptor[index]
			var/self_verb_desc = rimplant.self_verb_descriptor[index]
			usr.visible_message(span_notice("[usr] [verb_desc] [emote]"),
							span_notice("You [self_verb_desc] [emote]"))
		else
			visible_message(span_notice("[src] [pick(rimplant.short_emote_descriptor)] an egg."),
								span_notice("You [pick(rimplant.self_emote_descriptor)] an egg."))
		if(prob(15))
			visible_message(span_notice("[src] [pick(rimplant.random_emote)]."))

		rimplant.reagents.remove_any(rimplant.transfer_amount)

/obj/item/reagent_containers/food/snacks/egg/teshari
	name = "teshari egg"
	desc = "It's a large teshari egg."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "tesh_egg"
	filling_color = "#FDFFD1"
	volume = 12

/obj/item/reagent_containers/food/snacks/egg/teshari/New()
	..()
	reagents.add_reagent("egg", 10)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/egg/teshari/tesh2
	icon_state = "tesh_egg_2"

//Konabird: Rischi
/obj/item/implant/reagent_generator/rischi
	name = "egg laying implant"
	desc = "This is an implant that allows the user to lay eggs."
	generated_reagents = list("egg" = 2)
	usable_volume = 3000 //They requested 1 egg every ~30 minutes.
	transfer_amount = 3000

	empty_message = list("Your abdomen feels normal and taught, like usual.", "The lack of eggs in your abdomen leaves your belly flat and smooth.",  "The reduced pressure in your belly tells you there are no more eggs.", "With a soft sigh, you can feel your body is empty of eggs.  You know it will only be a matter of time before an egg forms once again, however.")
	full_message = list("Your lower abdomen feels a bit swollen", "You feel a pressure within your abdomen, and a broody mood slowly creeps over you.", "You can feel the egg inside of you shift as you move, the needy feeling to lay slowly growing stronger!", "You can feel the egg inside of you, swelling out your normally taught abdomen considerably. You'll definitely need to lay soon!")
	emote_descriptor = list("Rischi, causing the small female to squeak and wriggle, an egg falling from between her legs!", "Rischi's midsection, forcing her to lay an egg!", "Rischi, the Teshari huffing and grunting as an egg is squeezed from her body!")
	var/verb_descriptor = list("squeezes", "squashes", "hugs")
	var/self_verb_descriptor = list("squeeze", "push", "hug")
	var/short_emote_descriptor = list("lays", "forces out", "pushes out")
	self_emote_descriptor = list("lay", "force out", "push out")
	random_emote = list("trembles and huffs, panting from the exertion.", "sees what has happened and covers her face with both hands!", "whimpers softly, her legs shivering, knees pointed inward from the feeling.")
	assigned_proc = /mob/living/carbon/human/proc/use_reagent_implant_rischi

/obj/item/implant/reagent_generator/rischi/post_implant(mob/living/carbon/source)
	START_PROCESSING(SSobj, src)
	to_chat(source, span_notice("You implant [source] with \the [src]."))
	add_verb(source, assigned_proc)
	return 1

/obj/item/implanter/reagent_generator/rischi
	implant_type = /obj/item/implant/reagent_generator/rischi

/mob/living/carbon/human/proc/use_reagent_implant_rischi()
	set name = "Lay Egg"
	set desc = "Force Rischi to lay an egg by squeezing her! What a terribly rude thing to do!"
	set category = "Object"
	set src in view(1)

	//do_reagent_implant(usr)
	if(!isliving(usr) || !usr.checkClickCooldown())
		return

	if(usr.incapacitated() || usr.stat > CONSCIOUS)
		return

	var/obj/item/implant/reagent_generator/rischi/rimplant
	for(var/obj/item/organ/external/E in organs)
		for(var/obj/item/implant/I in E.implants)
			if(istype(I, /obj/item/implant/reagent_generator))
				rimplant = I
				break
	if (rimplant)
		if(rimplant.reagents.total_volume <= rimplant.transfer_amount)
			to_chat(src, span_notice("[pick(rimplant.empty_message)]"))
			return

		new /obj/item/reagent_containers/food/snacks/egg/teshari/tesh2(get_turf(src))

		var/index = rand(0,3)

		if (usr != src)
			var/emote = rimplant.emote_descriptor[index]
			var/verb_desc = rimplant.verb_descriptor[index]
			var/self_verb_desc = rimplant.self_verb_descriptor[index]
			usr.visible_message(span_notice("[usr] [verb_desc] [emote]"),
							span_notice("You [self_verb_desc] [emote]"))
		else
			visible_message(span_notice("[src] falls to her knees as the urge to lay overwhelms her, letting out a whimper as she [pick(rimplant.short_emote_descriptor)] an egg from between her legs."),
								span_notice("You fall to your knees as the urge to lay overwhelms you, letting out a whimper as you [pick(rimplant.self_emote_descriptor)] an egg from between your legs."))
		if(prob(15))
			visible_message(span_notice("[src] [pick(rimplant.random_emote)]."))

		rimplant.reagents.remove_any(rimplant.transfer_amount)

/*
/obj/item/implant/reagent_generator/pumila_nectar //Bugged. Two implants at once messes things up.
	generated_reagents = list("honey" = 2)
	reagent_name = "honey"
	usable_volume = 5000

	empty_message = list("You appear to be all out of nectar", "You feel as though you are lacking a majority of your nectar.")
	full_message = list("You appear to be full of nectar.", "You feel as though you are full of nectar!")
	emote_descriptor = list("squeezes nectar", "extracts nectar")
	self_emote_descriptor = list("squeeze", "extract")
	verb_name = "Extract Honey"
	verb_desc = "Obtain pumila's nectar and put it into a container!"

/obj/item/implanter/reagent_generator/pumila_nectar
	implant_type = /obj/item/implant/reagent_generator/pumila_nectar
*/
//Egg item
//-------------
/obj/item/reagent_containers/food/snacks/egg/roiz
	name = "lizard egg"
	desc = "It's a large lizard egg."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "egg_roiz"
	filling_color = "#FDFFD1"
	volume = 12

/obj/item/reagent_containers/food/snacks/egg/roiz/New()
	..()
	reagents.add_reagent("egg", 9)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/egg/roiz/attackby(obj/item/W as obj, mob/user as mob)
	if(istype( W, /obj/item/pen/crayon ))
		var/obj/item/pen/crayon/C = W
		var/clr = C.colourName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(user, span_warning("The egg refuses to take on this color!"))
			return

		to_chat(user, span_notice("You color \the [src] [clr]"))
		icon_state = "egg_roiz_[clr]"
		desc = "It's a large lizard egg. It has been colored [clr]!"
		if (clr == "rainbow")
			var/number = rand(1,4)
			icon_state = icon_state + num2text(number, 0)
	else
		..()

/obj/item/reagent_containers/food/snacks/friedegg/roiz
	name = "fried lizard egg"
	desc = "A large, fried lizard egg, with a touch of salt and pepper. It looks rather chewy."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "friedegg"
	volume = 12

/obj/item/reagent_containers/food/snacks/friedegg/roiz/New()
	..()
	reagents.add_reagent("protein", 9)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/boiledegg/roiz
	name = "boiled lizard egg"
	desc = "A hard boiled lizard egg. Be careful, a lizard detective may hatch!"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "egg_roiz"
	volume = 12

/obj/item/reagent_containers/food/snacks/boiledegg/roiz/New()
	..()
	reagents.add_reagent("protein", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chocolateegg/roiz
	name = "chocolate lizard egg"
	desc = "Such huge, sweet, fattening food. You feel gluttonous just looking at it."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "chocolateegg_roiz"
	filling_color = "#7D5F46"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 5)
	volume = 18

/obj/item/reagent_containers/food/snacks/chocolateegg/roiz/New()
	..()
	reagents.add_reagent("sugar", 6)
	reagents.add_reagent("coco", 6)
	reagents.add_reagent("milk", 2)
	bitesize = 2

//SilverTalisman: Evian
/obj/item/implant/reagent_generator/evian
	emote_descriptor = list("an egg right out of Evian's lower belly!", "into Evian' belly firmly, forcing him to lay an egg!", "Evian really tight, who promptly lays an egg!")
	var/verb_descriptor = list("squeezes", "pushes", "hugs")
	var/self_verb_descriptor = list("squeeze", "push", "hug")
	var/short_emote_descriptor = list("lays", "forces out", "pushes out")
	self_emote_descriptor = list("lay", "force out", "push out")
	random_emote = list("hisses softly with a blush on his face", "yelps in embarrassment", "grunts a little")
	assigned_proc = /mob/living/carbon/human/proc/use_reagent_implant_evian

/obj/item/implant/reagent_generator/evian/post_implant(mob/living/carbon/source)
	START_PROCESSING(SSobj, src)
	to_chat(source, span_notice("You implant [source] with \the [src]."))
	add_verb(source, assigned_proc)
	return 1

/obj/item/implanter/reagent_generator/evian
	implant_type = /obj/item/implant/reagent_generator/evian

/mob/living/carbon/human/proc/use_reagent_implant_evian()
	set name = "Lay Egg"
	set desc = "Force Evian to lay an egg by squeezing into his lower body! This makes the lizard extremely embarrassed, and it looks funny."
	set category = "Object"
	set src in view(1)

	//do_reagent_implant(usr)
	if(!isliving(usr) || !usr.checkClickCooldown())
		return

	if(usr.incapacitated() || usr.stat > CONSCIOUS)
		return

	var/obj/item/implant/reagent_generator/evian/rimplant
	for(var/obj/item/organ/external/E in organs)
		for(var/obj/item/implant/I in E.implants)
			if(istype(I, /obj/item/implant/reagent_generator))
				rimplant = I
				break
	if (rimplant)
		if(rimplant.reagents.total_volume <= rimplant.transfer_amount)
			to_chat(src, span_notice("[pick(rimplant.empty_message)]"))
			return

		new /obj/item/reagent_containers/food/snacks/egg/roiz/evian(get_turf(src)) //Roiz/evian so it gets all the functionality

		var/index = rand(0,3)

		if (usr != src)
			var/emote = rimplant.emote_descriptor[index]
			var/verb_desc = rimplant.verb_descriptor[index]
			var/self_verb_desc = rimplant.self_verb_descriptor[index]
			usr.visible_message(span_notice("[usr] [verb_desc] [emote]"),
							span_notice("You [self_verb_desc] [emote]"))
		else
			visible_message(span_notice("[src] [pick(rimplant.short_emote_descriptor)] an egg."),
								span_notice("You [pick(rimplant.self_emote_descriptor)] an egg."))
		if(prob(15))
			visible_message(span_notice("[src] [pick(rimplant.random_emote)].")) // M-mlem.

		rimplant.reagents.remove_any(rimplant.transfer_amount)

/obj/item/reagent_containers/food/snacks/egg/roiz/evian
	name = "dragon egg"
	desc = "A quite large dragon egg!"
	icon_state = "egg_roiz_yellow"


/obj/item/reagent_containers/food/snacks/egg/roiz/evian/attackby(obj/item/W as obj, mob/user as mob)
	if(istype( W, /obj/item/pen/crayon)) //No coloring these ones!
		return
	else
		..()
