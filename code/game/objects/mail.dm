/obj/item/mail
	name = "mail"
	desc = "An officially postmarked, tamper-evident parcel regulated by CentCom and made of high-quality materials."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "mail_small"
	item_flags = NOBLUDGEON
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	// Destination tagging for the mail sorter.
	var/sortTag = 0
	// Who this mail is for and who can open it.
	var/datum/weakref/recipient
	// How many goodies this mail contains.
	var/goodie_count = 1
	// Goodies which can be given to anyone.
	// Weight sum will be 1000
	var/list/generic_goodies = list(
		/obj/item/spacecash/c50 = 75,
		/obj/item/reagent_containers/food/drinks/cans/cola = 75,
		/obj/item/reagent_containers/food/snacks/chips = 75,
		/obj/item/reagent_containers/food/drinks/coffee = 75,
		/obj/item/reagent_containers/food/drinks/tea = 75,
		/obj/item/reagent_containers/food/drinks/glass2/coffeemug/nt = 50,
		/obj/item/spacecash/c100 = 40,
		/obj/item/spacecash/c200 = 25,
		/obj/item/spacecash/c500 = 15,
		/obj/item/spacecash/c1000 = 5,
		/obj/item/reagent_containers/food/drinks/bluespace_coffee = 5
	)
	// Overlays (pure fluff)
	// Does the letter have the postmark overlay?
	var/postmarked = TRUE
	// Does the letter have a stamp overlay?
	var/stamped = TRUE
	// List of all stamp overlays on the letter.
	var/list/stamps = list()
	// Maximum number of stamps on the letter.
	var/stamp_max = 1
	// Physical offset of stamps on the object. X direction.
	var/stamp_offset_x = 0
	// Physical offset of stamps on the object. Y direction.
	var/stamp_offset_y = 2
	// If the mail is actively being opened right now
	var/opening = FALSE
	// If the mail has been scanned with a mail scanner
	var/scanned
	// Does it have a colored envelope?
	var/colored_envelope

/obj/item/mail/container_resist(mob/living/M)
	if(istype(M, /mob/living/voice)) return
	M.forceMove(get_turf(src))
	to_chat(M, span_warning("You climb out of \the [src]."))

/obj/item/mail/envelope
	name = "envelope"
	icon_state = "mail_large"
	goodie_count = 2
	stamp_max = 2
	stamp_offset_y = 5

/obj/item/mail/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_DISPOSING, PROC_REF(disposal_handling))

	// Icons
	// Add some random stamps.
	if(stamped == TRUE)
		var/stamp_count = rand(1, stamp_max)
		for(var/i = 1, i <= stamp_count, i++)
			stamps += list("stamp_[rand(2, 8)]")

/obj/item/mail/blank
	desc = "A blank envelope."
	description_info = "An object can be placed into the envelope, click on it with an empty hand to seal it. Alt-Click to retrieve the items from inside before sealing."
	stamped = FALSE
	postmarked = FALSE
	var/set_recipient = FALSE
	var/set_content = FALSE
	var/sealed = FALSE
	var/list/mail_recipients

/obj/item/mail/blank/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/pen) && sealed && !set_recipient)
		if(setRecipient(user))
			set_recipient = TRUE
		add_fingerprint(user)
		return

	if(!set_content && !sealed)
		if(!do_after(user, 1.5 SECONDS, target = user))
			set_content = FALSE
		user.drop_item()
		W.forceMove(src)
		to_chat(user, "Placed the [W] into the [src]")
		set_content = TRUE
		description_info = "Click with an empty hand to seal it, or Alt-Click to retrieve the object out."
		return
	return

/obj/item/mail/proc/setRecipient(mob/user)
	var/list/recipients = list()
	for(var/mob/living/player in player_list)
		if(!player_is_antag(player.mind) && player.mind.show_in_directory)
			recipients += player

	recipients = tgui_input_list(usr, "Choose recipient", "Recipients", recipients, recipients)

	if(recipients)
		initialize_for_recipient(recipients, preset_goodies = TRUE)
		return TRUE

/obj/item/mail/blank/AltClick(mob/user)
	if(sealed)
		return

	for(var/obj/stuff as anything in contents)
		if(isitem(stuff))
			user.put_in_hands(stuff)
		else
			stuff.forceMove(drop_location())
	set_content = FALSE
	description_info = initial(description_info)

/obj/item/mail/blank/ShiftClick(mob/user)
	..()
	if(!sealed)
		var/sender = tgui_input_text(user, "Write name", "Name", user.name)
		if(sender)
			desc = "A signed envelope, from [sender]."

/obj/item/mail/blank/attack_self(mob/user)
	if(!sealed)
		if(!do_after(user, 1.5 SECONDS, target = user))
			sealed = FALSE
		sealed = TRUE
		description_info = "Shift Click to add the sender's name to the envelope, or attack with a pen to set a receiver."
		return
	. = ..()

/obj/item/mail/update_icon()
	. = ..()
	cut_overlays()
	if(colored_envelope)
		var/image/envelope = image(icon, icon_state)
		envelope.color = colored_envelope
		add_overlay(envelope)
	var/bonus_stamp_offset = 0
	for(var/stamp in stamps)
		var/image/stamp_image = image(
			icon_state = stamp,
			pixel_x = stamp_offset_x,
			pixel_y = stamp_offset_y + bonus_stamp_offset
		)
		stamp_image.appearance_flags |= RESET_COLOR
		add_overlay(stamp_image)
		bonus_stamp_offset -= 5

	if(postmarked == TRUE)
		var/image/postmark_image = image(
			icon = icon,
			icon_state = "postmark",
			pixel_x = stamp_offset_x + rand(-4, 0),
			pixel_y = stamp_offset_y + rand(bonus_stamp_offset + 3, 1)
		)
		postmark_image.appearance_flags |= RESET_COLOR
		add_overlay(postmark_image)

/obj/item/mail/attackby(obj/item/W as obj, mob/user as mob)
	. = ..()
	// Destination tagging
	if(istype(W, /obj/item/destTagger))
		var/obj/item/destTagger/O = W
		if(O.currTag)
			if(src.sortTag != O.currTag)
				to_chat(user, span_notice("You have labeled the destination as [O.currTag]."))
				src.sortTag = O.currTag
				playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
				W.description_info = " It is labeled for [O.currTag]"
			else
				to_chat(user, span_notice("The mail is already labeled for [O.currTag]."))
		else
			to_chat(user, span_danger("You need to set a destination first!"))
		return

/obj/item/mail/attack_self(mob/user)
	if(!unwrap(user))
		return FALSE
	return after_unwrap(user)

/obj/item/mail/proc/unwrap(mob/user)
	if(recipient && user != recipient)
		to_chat(user, span_danger("You can't open somebody's mail! That's <em>illegal</em>"))
		return FALSE

	if(opening)
		to_chat(user, span_danger("You are already opening that!"))
		return FALSE

	opening = TRUE
	if(!do_after(user, 1.5 SECONDS, target = user))
		opening = FALSE
		return FALSE
	return TRUE

/obj/item/mail/proc/after_unwrap(mob/user)
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	for(var/obj/stuff as anything in contents)
		if(isitem(stuff))
			user.put_in_hands(stuff)
		else
			stuff.forceMove(drop_location())
	playsound(loc, 'sound/items/poster_ripped.ogg', 100, TRUE)
	qdel(src)

/obj/item/mail/proc/initialize_for_recipient(mob/new_recipient, var/preset_goodies = FALSE)
	recipient = new_recipient
	var/current_title = new_recipient.mind.role_alt_title ? new_recipient.mind.role_alt_title : new_recipient.mind.assigned_role
	name = "[initial(name)] for [new_recipient.real_name] ([current_title])"

	var/datum/job/this_job = SSjob.name_occupations[new_recipient.job]

	var/list/goodies = generic_goodies
	if(this_job)
		colored_envelope = this_job.get_mail_color()
		if(!preset_goodies)
			var/list/job_goodies = this_job.get_mail_goodies(new_recipient, current_title)
			if(LAZYLEN(job_goodies))
				if(this_job.get_mail_goodies())
					goodies = job_goodies
				else
					goodies += job_goodies

	if(!preset_goodies)
		for(var/iterator in 1 to goodie_count)
			var/target_good = pickweight(goodies)
			var/atom/movable/target_atom = new target_good(src)
			log_game("[key_name(new_recipient)] received [target_atom.name] in the mail ([target_good])")

	update_icon()
	return TRUE

/obj/item/mail/proc/disposal_handling(disposal_source, obj/structure/disposalholder/disposal_holder, obj/machinery/disposal/deliveryChute, hasmob)
	SIGNAL_HANDLER
	if(!hasmob)
		disposal_holder.destinationTag = sortTag

// Mail spawn for events
/datum/admins/proc/spawn_mail(var/object as text)
	set name = "Spawn Mail"
	set category = "Fun.Event Kit"
	set desc = "Spawn mail for a specific player, with a specific item."

	if(!check_rights(R_SPAWN)) return

	var/list/types = typesof(/atom)
	var/list/matches = new()
	var/list/recipients = list()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(matches.len==0)
		return
	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = tgui_input_list(usr, "Select an atom type", "Spawn Atom in Mail", matches)
		if(!chosen)
			return

	for(var/mob/living/player in player_list)
		recipients += player

	recipients = tgui_input_list(usr, "Choose recipient", "Recipients", recipients, recipients)

	if(!recipients)
		return

	var/shuttle_spawn = tgui_alert(usr, "Spawn mail at location or in the shuttle?", "Spawn mail", list("Location", "Shuttle"))
	if(!shuttle_spawn)
		return
	if(shuttle_spawn == "Shuttle")
		var/obj/item/mail/new_mail = new
		new_mail.initialize_for_recipient(recipients, TRUE)
		new chosen(new_mail)
		SSmail.admin_mail += new_mail
		log_and_message_admins("spawned [chosen] inside an envelope at the shuttle")
	else
		var/obj/item/mail/ground_mail = new /obj/item/mail(usr.loc)
		ground_mail.initialize_for_recipient(recipients, TRUE)
		new chosen(ground_mail)
		log_and_message_admins("spawned [chosen] inside an envelope at ([usr.x],[usr.y],[usr.z])")

	feedback_add_details("admin_verb","SM")

// Mail Crate
/obj/structure/closet/crate/mail
	name = "mail crate"
	desc = "An official mail crate from CentCom"
	points_per_crate = 0
	closet_appearance = /decl/closet_appearance/crate/nanotrasen

/obj/structure/closet/crate/mail/full/Initialize(mapload)
	. = ..()
	var/list/mail_recipients = list()
	for(var/mob/living/carbon/human/alive in player_list)
		if(alive.stat != DEAD && alive.client && alive.client.inactivity <= 10 MINUTES)
			mail_recipients += alive
	for(var/iterator in 1 to storage_capacity)
		var/obj/item/mail/new_mail
		if(prob(70))
			new_mail = new /obj/item/mail(src)
		else
			new_mail = new /obj/item/mail/envelope(src)
		var/mob/living/carbon/human/mail_to
		if(mail_to)
			new_mail.initialize_for_recipient(mail_to)
			mail_recipients -= mail_to
		else
			new_mail.junk_mail()

// Mailbag
/obj/item/storage/bag/mail
	name = "mail bag"
	desc = "A bag for letters, envelopes and other postage."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "mailbag"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = ITEMSIZE_NORMAL
	storage_slots = 31
	max_storage_space = 50
	max_w_class = ITEMSIZE_NORMAL
	use_to_pickup = TRUE
	allow_quick_gather = TRUE
	can_hold = list(
		/obj/item/mail,
		/obj/item/smallDelivery,
		/obj/item/paper,
		/obj/item/stolenpackage,
		/obj/item/contraband,
		/obj/item/mail_scanner,
		/obj/item/pen
	)

// Mail Scanner
/obj/item/mail_scanner
	name = "mail scanner"
	desc = "Sponsored by the Intergalactic Mail Service, this device logs mail deliveries in exchance for financial compensation."
	force = 0
	throwforce = 0
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "mail_scanner"
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	var/cargo_points = 5
	var/obj/item/mail/saved

/obj/item/mail_scanner/examine(mob/user)
	. = ..()
	. += span_notice("Scan a letter to log it into the active database, then scan the person you wish to hand the letter to. Correctly scanning the recipient of the letter logged into the active database will add points to the supply budget.")

/obj/item/mail_scanner/attack()
	return

/obj/item/mail_scanner/afterattack(atom/A, mob/user)
	if(istype(A, /obj/item/mail))
		var/obj/item/mail/saved_mail = A
		if(saved_mail.scanned)
			to_chat(user, span_danger("This letter has already been scanned!"))
			playsound(loc, 'sound/items/mail/maildenied.ogg', 50, TRUE)
			return
		to_chat(user, span_notice("Mail added to database"))
		playsound(loc, 'sound/items/mail/mailscanned.ogg', 50, TRUE)
		saved = A
		return
	if(isliving(A))
		var/mob/living/M = A

		if(!saved)
			to_chat(user, span_danger("No logged mail!"))
			playsound(loc, 'sound/items/mail/maildenied.ogg', 50, TRUE)
			return

		var/mob/living/recipient = saved.recipient

		if(M.stat == DEAD)
			to_chat(user, span_warning("Consent Verification failed: You can't deliver mail to a corpse!"))
			playsound(loc, 'sound/items/mail/maildenied.ogg', 50, TRUE)
			return
		if(M.real_name != recipient.real_name)
			to_chat(user, span_warning("Identity Verification failed: Target is not authorized recipient of this envelope!"))
			playsound(loc, 'sound/items/mail/maildenied.ogg', 50, TRUE)
			return
		if(!M.client)
			to_chat(user, span_warning("Consent Verification failed: The scanner does not accept orders from SSD crewmemmbers!"))
			playsound(loc, 'sound/items/mail/maildenied.ogg', 50, TRUE)
			return

		saved.scanned = TRUE
		saved = null

		cargo_points = rand(5, 10)
		to_chat(user, span_notice("Succesful delivery acknowledged! [cargo_points] points added to Supply."))
		playsound(loc, 'sound/items/mail/mailapproved.ogg', 50, TRUE)
		SSsupply.points += cargo_points

// JUNK MAIL STUFF

/obj/item/mail/junkmail/Initialize(mapload)
	. = ..()
	junk_mail()

/obj/item/mail/proc/junk_mail()

	var/obj/junk = /obj/item/paper/fluff/junkmail_generic
	var/special_name = FALSE

	if(prob(25))
		special_name = TRUE
		junk = pick(list(
			/obj/item/paper/pamphlet/gateway,
			/obj/item/paper/pamphlet/violent_video_games,
			/obj/item/paper/pamphlet/radstorm,
			/obj/item/paper/fluff/junkmail_redpill,
			/obj/effect/decal/cleanable/ash,
			/obj/item/paper/fluff/love_letter,
			/obj/item/reagent_containers/food/snacks/donkpocket/berry,
			/obj/item/reagent_containers/food/snacks/donkpocket/dankpocket,
			/obj/item/reagent_containers/food/snacks/donkpocket/gondola,
			/obj/item/reagent_containers/food/snacks/donkpocket/honk,
			/obj/item/reagent_containers/food/snacks/donkpocket/pizza,
			/obj/item/reagent_containers/food/snacks/donkpocket/spicy,
			/obj/item/reagent_containers/food/snacks/donkpocket/teriyaki,
			/obj/item/toy/figure,
			/obj/item/contraband/package,
			/obj/item/tool/screwdriver/sdriver,
			/obj/item/storage/briefcase/target_toy
		))

	var/list/junk_names = list(
		/obj/item/paper/pamphlet/gateway = "[initial(name)] for BRAVE adventurers",
		/obj/item/paper/pamphlet/violent_video_games = "[initial(name)] for the truth about the arcade CentComm doesn't want to hear",
		/obj/item/paper/pamphlet/radstorm = "[initial(name)] for the threats in space",
		/obj/item/paper/fluff/junkmail_redpill = "[initial(name)] for those feeling tired working at Nanotrasen",
		/obj/effect/decal/cleanable/ash = "[initial(name)] with INCREDIBLY IMPORTANT ARTIFACT- DELIVER TO SCIENCE DIVISION. HANDLE WITH CARE.",
		/obj/item/paper/fluff/love_letter = "[initial(name)] for STUPID CARGO MAILMEN.",
		/obj/item/reagent_containers/food/snacks/donkpocket/berry = "[initial(name)] with NEW BERRY-POCKET.",
		/obj/item/reagent_containers/food/snacks/donkpocket/dankpocket = "[initial(name)] with NEW DANK-POCKET.",
		/obj/item/reagent_containers/food/snacks/donkpocket/gondola = "[initial(name)] with NEW GONDOLA-POCKET.",
		/obj/item/reagent_containers/food/snacks/donkpocket/honk = "[initial(name)] with NEW HONK-POCKET.",
		/obj/item/reagent_containers/food/snacks/donkpocket/pizza = "[initial(name)] with NEW PIZZA-POCKET.",
		/obj/item/reagent_containers/food/snacks/donkpocket/spicy = "[initial(name)] with NEW SPICY-POCKET.",
		/obj/item/reagent_containers/food/snacks/donkpocket/teriyaki = "[initial(name)] with NEW TERIYAKI-POCKET.",
		/obj/item/toy/figure = "[initial(name)] from DoN**K*oC",
		/obj/item/contraband/package = "[pick("oddly shaped", "strangely wrapped", "weird", "bulging")] [initial(name)]",
		/obj/item/tool/screwdriver/sdriver = "[initial(name)] for Proffesor Who",
		/obj/item/storage/briefcase/target_toy = "[initial(name)] for SIMPATHY, SUCCESS, MANHATTAN, BELIEFS"
	)

	name = special_name ? junk_names[junk] : "important [initial(name)]"

	junk = new junk(src)
	update_icon()
	return TRUE

/obj/item/paper/fluff/junkmail_generic/Initialize(mapload)
	. = ..()
	info = pick(
		prob(5);"Hello! I am executive at Nanotrasen Nigel Takall. Due to accounting error all of my salary is stored in an account unreachable. In order to withdraw I am required to utilize your account to make a deposit to confirm my reality situation. In exchange for a temporary deposit I will give you a payment 1000 credits. All I need is access to your account. Will you be assistant please?",
		prob(5);"WE NEED YOUR BLOOD! WE ARE AN ANARCHO-COMMUNIST VAMPIRE COMMUNE. BLOOD ONLY LASTS 42 DAYS BEFORE IT GOES BAD! WE DO NOT HAVE NANOTRASEN STASIS! PLEASE, SEND BLOOD! THANK YOU! OR WE KILL YOU!",
		prob(5);"Triple deposits are waiting for you at MaxBet Online when you register to play with us. You can qualify for a 200% Welcome Bonus at MaxBet Online when you sign up today. Once you are a player with MaxBet, you will also receive lucrative weekly and monthly promotions. You will be able to enjoy over 450 top-flight casino games at MaxBet.",
		prob(5);"Hello !, I'm the former HoS of your deerest station accused by the Nanotrasen of being a traitor . I was the best we had to offer but it seems that nanotramsen has turned their back on me. I need 2000 credits to pay for my bail and then we can restore order on space station 14!",
		prob(5);"Hello, I noticed you riding in a 2555 Ripley and wondered if you'd be interested in selling. Low mileage mechs sell very well in our current market. Please call 223-334-3245 if you're interested",
		prob(5);"Resign Now. I'm on you now. You are fucking with me now Let's see who you are. Watch your back , bitch. Call me.  Don't be afraid, you piece of shit.  Stand up.  If you don't call, you're just afraid. And later: I already know where you live, I'm on you.  You might as well call me. You will see me. I promise.  Bro.",
		prob(5);"Clown Planet Is Going To Become Awesome Possum Again! If This Wasn't Sent To A Clown, Disregard. If This Was Sent To A Mime, Blow It Out Your Ass, Space Frenchie! Anyway! We Make Big Progress On Clown Planet After Stupid Mimes BLOW IT ALL TO SAM HELL!!!!! Sorry I Am Mad.. Anyway Come And Visit, Honkles! We Thought You Were Dead Long Time :^()",
		prob(5);"MONTHPEOPLE ARE REAL, THE NANOTRASEN DEEP STATE DOESN'T WANT YOU TO SEE THIS! I'VE SEEN THEM IN REAL LIFE, THEY HAVE HUGE EYEBALLS AND NO HEAD. THEY'RE SENTIENT CALENDARS. I'M NOT CRAZY. SEARCH THE CALENDAR INCIDENT ON NTNET. USE A PROXY! #BIGTRUTHS #WAKEYWAKEYSPACEMEN #21STOFSEPTEMBER",
		prob(5);"hello :wave::wave: nanotrasens! fuck :point_left::ok_hand: the syndicate! they :older_woman: got ☄ me :heart_eyes::cold_sweat: questioning my :pregnant_woman: loyalty to nanotraben! so :ok_hand::100: please :tired_face: lets :no_entry::eyes: gather our :camera_with_flash::poop: energy :sunglasses: and :moneybag::symbols: QUICK. :astonished: send this :wastebasket::point_left: to :sweat_drops::pill: 10 :joy::joy: other loyal :100: nanotraysens to :sweat_drops::thinking: show we :dog: dont :person_gesturing_no::no_entry_sign: take :shopping_bags: nothing from :joy: the ✝ syndicate!! bless your :point_right_tone2: heart :heart_eyes::broken_heart:",
		prob(5);"Hello, my name is Immigration officer Mimi Sashimi from the American-Felinid Homeworld consulate. It appears your current documents are either inaccurate if not entirely fraudulent. This action in it's current state is a federal offense as listed in the United Earth Commission charter section NY-4. Please pay a fine of 300,000 Space credits or $3000 United States Dollars or face deportation",
		prob(5);"Hi %name%, We are unable to validate your billing information for the next billing cycle of your subscription to HONK Weekly therefore we'll suspend your membership if we do not receive a response from you within 48 hours. Obviously we'd love to have you back, simply mail %address% to update your details and continue to enjoy all the best pranks & gags without interruption.",
		prob(5);"Loyal customer, DonkCo Customer Service. We appreciate your brand loyalty support. As such, it is our responsibility and pleasure to inform you of the status of your package. Your package for one \"Moth-Fuzz Parka\" has been delayed. Due to local political tensions, an animal rights group has seized and eaten your package. We appreciate the patience, DonkCo",
		prob(5);"MESSAGE FROM CENTCOMM HIGH COMMAND: DO NOT ACCEPT THE FRIEND REQUEST OF TICKLEBALLS THE CLOWN. HE IS NOT FUNNY AND ON TOP OF THAT HE WILL HACK YOUR NTNET ACCOUNT AND MAKE YOU UNFUNNY TOO. YOU WILL LOSE ALL YOUR SPACECREDITS!!!!! SPREAD THE WORD. ANYONE WHO BECOMES FRIENDS WITH TINKLEBALLS THE CLOWN IS GOING TO LOSE ALL OF THEIR SPACECREDITS AND LOOK LIKE A HUGE IDIOT.",
		prob(5);"i WAS A NORMAL BOY AND I CAME HOME FROM SCHOOL AND I WANTED TO PLAY SOME ORION TRAIL WHICH IS A VERY FUN GAME BUT WHEN WENT TO ARCADE MACHINE SOMETHING WAS WEIRD TEH LOGO HASD BLOD IN IT AND I BECAME VERY SCARE AND I CHECK OPTIONS AND TEHRES ONLY 1 \"GO BACK\" I CKLICK IT AND I SEE CHAT  SI EMPTY THERE'S ONLY ONE CHARACTER CALLED \"CLOSE TEH GAME  \" AND I GO TO ANOTHER MACHINE AND PLAY THERE BUT WHEN I PLAY GAME IS FULL OF BLOOD AND DEAD BODIES FROM SPACEMAN LOOK CLOSER AND SEE CLOWN AND CLOWN COMES CLOSER AND LOOKS AT ME AND SAYS \"DON'T SAY I DIKDNT' WWARN YOU\" AND CLOWN CLOSEUP APPEARS WITH BLOOD-RED HYPERREALISTIC EYES AND HE TELLS ME \"YOU WILL BE THE NEXT ONE\" AND ARCADE MACHINE POWER SHUT OFF AND THAT NITE CLOWN APPEAR AT MY WINDOW AND KILL ME AT 3 AM AND NOW IM DEAD AND YOU WILL BE TRHNE NEXT OEN UNLESS YOU PASTE THIS STORY TO 10 NTNET FRIENDS",
		)

/obj/item/paper/fluff/junkmail_redpill
	name = "smudged paper"
	icon_state = "scrap"

/obj/item/paper/fluff/junkmail_redpill/Initialize(mapload)
	. = ..()
	info = "You need to escape the simulation. Don't forget the numbers, they help you remember: '[rand(0,9)]*[rand(0,9)][rand(0,9)]...'"

/obj/item/paper/fluff/love_letter
	name = "love letter"
	icon_state = "paper_words"

/obj/item/paper/fluff/love_letter/Initialize(mapload)
	. = ..()
	info = "I HATE CARGO MAIL\n\"GRAA LEMME BREAK YOUR DOORS DOWN I GOTTA GIVE YOU MAIL\nREE YOU GOTTA GET YOUR MAIL I SORTED IT\nYOU'RE WASTIN YOUR TIME IF YOU DONT GET MAIL YOU NEED TO GET YOUR MAIL NOW\nWHY ARENT YO UGETTING YOUR MAIL RAAA\""

/obj/item/paper/fluff/junkmail_generic
	name = "important document"
	icon_state = "paper_words"
