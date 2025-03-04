SUBSYSTEM_DEF(mail)
	name = "Mail"
	wait = 60 SECONDS
	priority = FIRE_PRIORITY_SUPPLY

	flags = SS_NO_TICK_CHECK | SS_NO_INIT

	var/mail_waiting = 0					// Pending mail
	var/mail_per_process = 0.55				// Mail to be generated
	var/admin_mail = list()					// Mail added by Spawn Mail

/datum/controller/subsystem/mail/fire()
	mail_waiting += mail_per_process

/*	Generates a box of mail. Depending on the time that has passed between shuttles being called, it will send more or less mail and dependant on a small random number to simulate inflation
	Whenever the cargo shuttle gets sent back to the station, it will add the mail crate if there's any mail to be sent to the station.

	Only alive, active and NT employeers should be getting mail.
*/

/datum/controller/subsystem/mail/proc/create_mail()
	// Spawn crate
	var/obj/structure/closet/crate/mail/mailcrate = new(pick(SSsupply.get_clear_turfs()))
	// Collect recipients
	var/list/mail_recipients = list()
	for(var/mob/living/carbon/human/player_human in player_list)
		if(player_human.stat != DEAD && player_human.client && player_human.client.inactivity <= 10 MINUTES && !player_is_antag(player_human.mind)) // Only alive, active and NT employeers should be getting mail.
			mail_recipients += player_human

	// Creates mail for all the mail waiting to arrive, if there's nobody to receive it, it will be a chance of junk mail.
	for(var/mail_iterator in 1 to mail_waiting)
		if(!mail_recipients.len && prob(60)) // Oh, no mail for our Employees? Well don't just sent them all the junk.
			continue
		var/obj/item/mail/new_mail
		if(prob(70))
			new_mail = new /obj/item/mail(mailcrate)
		else
			new_mail = new /obj/item/mail/envelope(mailcrate)
		var/mob/living/carbon/human/mail_to
		if(mail_recipients.len)
			mail_to = pick(mail_recipients)
			new_mail.initialize_for_recipient(mail_to)
			mail_recipients -= mail_to
		else
			new_mail.junk_mail()
	// Admin mail
	if(admin_mail)
		for(var/obj/item/mail/ad_mail in admin_mail)
			ad_mail.loc = mailcrate
		clearlist(admin_mail)
	mail_waiting = 0
	return mailcrate
