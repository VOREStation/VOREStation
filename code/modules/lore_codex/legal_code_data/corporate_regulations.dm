/datum/lore/codex/category/corporate_regulations
	name = "Corporate Regulations"
	data = "Corporate Regulations are rules set by us, NanoTrasen, that all visitors and employees must follow while working at \
	or otherwise on-board a NanoTrasen installation, which if you are reading this, you likely are at one.  Corporate Regulations, \
	commonly shortened to Corp Regs by employees, is common throughout NanoTrasen's other holdings.  Offenses against Corp Regs can \
	range from things like littering, to disrespecting a Head of Staff, to failing to follow a valid order from a superior.  \
	All NanoTrasen employees must follow these regulations, no one is above them, not even the Station Director.  \
	The only exception for this is Asset Protection."
	children = list(
		/datum/lore/codex/page/corporate_punishments,
		/datum/lore/codex/category/contraband,
		/datum/lore/codex/category/corporate_minor_violations,
		/datum/lore/codex/category/corporate_major_violations
		)

/datum/lore/codex/category/contraband
	name = "Contraband"
	data = "Here is a list of various types of 'contraband' that are prohibited from being brought onto the facility."
	children = list(
		/datum/lore/codex/page/not_contraband,
		/datum/lore/codex/page/contraband_controlled,
		/datum/lore/codex/page/contraband_restricted
		)

/datum/lore/codex/page/not_contraband
	name = "Not Contraband"
	data = "Here is a list of objects which are not actually contraband onboard NanoTrasen facilities in Vir, despite popular belief.\
	<ul>\
	<li><b>Blades or other Equipment</b> which the possessor needs in order to fulfil their role onboard the facility, \
	such as a kitchen knife for culinary personnel.</li>\
	<li><b>Handheld Flashes</b>, which are useful for self-defense, as well as building certain machinery.</li>\
	<li><b></b></li>\
	</ul>"

/datum/lore/codex/page/contraband_controlled
	name = "Controlled Objects"
	data = "A 'controlled' object is contraband that NanoTrasen has deemed harmful, or otherwise undesired for the \
	facility, but which is not illegal by Law or dangerous to possess.  Vessels docking with the facility which possess these \
	objects are required to keep them onboard their vessel.  Visitors who board the facility with these objects are required to \
	surrender them, or otherwise have them confiscated, however they may have them back upon leaving.\
	<br><br>\
	The following objects are 'controlled'.\
	<ul>\
	<li><b>Recreational Drugs</b>, which includes Ambrosia.</li>\
	<li><b>Non-Lethal Weaponry</b>, for persons not authorized to handle them, such as Security or Command Staff.  This includes Stun Batons, Tasers, Pepper-Spray, \
	Flashbangs</li>\
	<li><b></b></li>\
	<li><b></b></li>\
	</ul>"

/datum/lore/codex/page/contraband_restricted
	name = "Restricted Objects"
	data = "A 'restricted' object is contraband which Nanotrasen deems dangerous to the welfare of the facility as a whole, \
	such as a deadly weapon, <u>by someone not authorized to handle it.</u>  Vessels docking with the facility which possess these \
	objects are required to keep them onboard their vessel.  Possessing restricted objects is a much more serious issue, and \
	as such, possession can consititute a brig sentence, and the permanent confiscation of the objects in question.\
	<br><br>\
	The following objects are 'restricted'.\
	<ul>\
	<li><b>Deadly Weapons</b>, which is defined as objects which are designed to kill or otherwise severely injure a person.</li>\
	<li><b>Lethal Guns</b>, meaning guns which possess the capability to kill someone.  Functional ballistic weaponry can be loaded \
	with ammunition that is lethal, meaning it falls under this.  Energy weapons lacking a lethal mode, such as tasers, do not fall under this.  \
	Weapons which emit electromagnetic pulses, sometimes called 'Ionic' weapons, are considered lethal, as they are lethal to synthetics.</li>\
	<li><b>Narcotic Drugs</b>, such as Mindbreaker.</li>\
	<li><b>Illicit Identification Cards</b>, which includes forgeries, as well as ID cards designed to tamper with electronics.</li>\
	</ul>"

/datum/lore/codex/page/corporate_punishments
	name = "Punishments (Corporate)"
	data = "Violations of Corporate Regulations can be resolved in a wide variety of ways.  The Command staff on-board the facility \
	have discretion to decide on what form of punishment to use, however it is advised for the punishment to fit the severity of the \
	infraction.  To help with this, each violation has a suggested punishment alongside it.\
	<br><br>\
	The punishments that Command is allowed to use are;<br>\
	<ul>\
	<li><b>Fines</b> are the preferred penalty to be used for minor Corp Reg violations.  If someone is unable or unwilling to pay the fine, \
	the punishment may be substituted with time spent inside the brig.</li><br>\
	<li><b>Brig time</b> is acceptable as an alternative to monetary fines, at the offender's discretion.  Brig time and fines cannot be used together.  \
	Brig time may also be used for repeat offenders.</li><br>\
	<li><b>Write-ups to Central Command</b> may be recommended or mandated for specific offenses.  Internal Affairs is to ensure that this is \
	adhered to, and assist if needed.</li><br>\
	<li><b>Reassignments</b> as a form of punishment may be done by the Station Director, with consent from both the offender and the offender's \
	Superior, if one exists.  Generally the new role for the offender is usually considered something menial or related to their offense, for example: \
	Janitor, Miner, Cook, Gardener.  This punishment can be especially fitting for certain violations such as someone who made graffiti being reassigned to janitorial duties.</li><br>\
	<li><b>Demotions</b> may be done by the offender's Superior, at their discretion.  The Station Director may also do this, \
	however the Director is recommended to defer to the offender's direct Superior if one exists.</li><br>\
	<li><b>Terminations of employment</b> from NanoTrasen can only be issued by the Station Director.  This is the most severe corporate punishment available. \
	It should be noted that visitors and other non-employees cannot be terminated, obviously.  Central Command must be informed of the termination, if one is applied.</li>\
	<li><b>Hold until Transfer</b> is an option reserved for the Station Director only for repeat offenders, for serious violations of Regulations, or it the offender poses a \
	credible threat to the station or crew.</li>\
	</ul>"

// Minor Violations area
/datum/lore/codex/category/corporate_minor_violations
	name = "Minor Violations (Corporate)"
	data = "Here is a list of the less severe violations of Corporate Regulations that might occur.  We wish to emphasize that for \
	the minor corporate violations, the local Command team has a lot more discretion to choose a suitable punishment, however \
	punishments which are much more severe or lax than the suggested punishment listed within may be worthy of an Internal Affairs investigation."
	children = list(
		/datum/lore/codex/page/law/minor_trespass,
		/datum/lore/codex/page/law/petty_company_theft,
		/datum/lore/codex/page/law/misuse_of_comms,
		/datum/lore/codex/page/law/disrespecting_head,
		/datum/lore/codex/page/law/failure_to_execute_order,
		/datum/lore/codex/page/law/littering,
		/datum/lore/codex/page/law/graffiti,
		/datum/lore/codex/page/law/false_complaint,
		/datum/lore/codex/page/law/breaking_sop_minor,
		/datum/lore/codex/page/law/resisting_arrest,
		/datum/lore/codex/page/law/control_contraband,
		/datum/lore/codex/page/law/indecent_exposure,
		/datum/lore/codex/page/law/hooliganism
		)

/datum/lore/codex/page/law/minor_trespass
	name = "Minor Trespass"
	definition = "Being in an area which a person does not have access to, and does not have permission to be in."
	suggested_punishments = "Removal from area. Fine of up to 150 thaler or brig time of up to 10 minutes at discretion of \
	arresting officer. Demotion at discretion of Superior.  Confiscation of tools used at discretion of arresting officer."
	suggested_brig_time = 10 MINUTES
	suggested_fine = 150
	notes = "Remember that people can either break in, sneak in, or be let in. Always check that the suspect wasn't let in to \
	do a job by someone with access, or were given access on their ID. Trespassing and theft often committed together; \
	both sentences should be applied."

/datum/lore/codex/page/law/petty_company_theft/add_content()
	name = "Petty Theft of Company Property"
	keywords += list("Petty Theft")
	definition = "Taking or using the Company's property without permission, which is of low value."
	suggested_punishments = "Return of stolen item(s). Fine of up to 200 thaler or brig time of up to 20 minutes.  Demotion at discretion of Superior."
	suggested_brig_time = 20 MINUTES
	suggested_fine = 200
	notes = "This is for theft of company belongings which are of a relatively low value, such as low-end medical equipment, tools, clothing, \
	not paying for food/drink, and such.  It is assumed that persons inside a department using departmental equipment have the consent of NanoTrasen to take those items.  \
	Theft from a person, or if stolen objects were not of a trivial worth, falls under [quick_link("Theft")] instead.  \
	[quick_link("Grand Theft")] is reserved for extremely valuable or dangerous objects being stolen."
	..()

/datum/lore/codex/page/law/misuse_of_comms/add_content()
	name = "Misuse of Public Communications"
	keywords += list("Misuse of Comms")
	definition = "Repetitively using the radio, PDA relays, or other public communication methods as a means to annoy, disturb, \
	slander, or otherwise verbally abuse others, and ignoring requests to stop."
	suggested_punishments = "Confiscation of radio <u>if they fail to stop when asked</u>. Demotion at discretion of Superior."
	notes = "Using languages besides Galactic Common on the radio can consitute Misuse of Public Communications if the station is on Blue alert or higher."
	..()

/datum/lore/codex/page/law/failure_to_execute_order
	name = "Failure to Execute an Order"
	definition = "Refusing to follow a valid, lawful order of a Superior, when able to do so, as an employee of NanoTrasen."
	suggested_punishments = "50 thaler fine. Demotion at discretion of Superior."
	suggested_fine = 50
	notes = "For this charge to apply, the order must be lawful, reasonable, and the person being ordered to do it must have been able to do so.  \
	This includes orders from someone who is not necessarily the direct superior of the offender, but has authority in that context, for instance the Chief Engineer \
	giving an order about engineering matters."

/datum/lore/codex/page/law/littering
	name = "Littering"
	definition = "Failing to throw garbage away, or otherwise creating a mess."
	suggested_punishments = "50 thaler fine issued to litterer.  Demotion at discretion of Superior <u>for extreme cases or repeat offenders</u>."
	suggested_fine = 50

/datum/lore/codex/page/law/graffiti
	name = "Graffiti"
	definition = "Defacing Company property, or otherwise writing or drawing on Company property without authorization."
	suggested_punishments = "Up to 150 thaler fine issued to to those responsible. Cleanup of graffiti. Demotion at discretion of Superior."
	suggested_fine = 150
	notes = "This applies for a wide variety of forms of graffiti, including writing on the walls or the floor, or drawing on the floor \
	with painting tools.  Authorization for painting or otherwise altering the floor or walls' appearance can be granted by Command staff."

/datum/lore/codex/page/law/false_complaint
	name = "Filing a False Complaint"
	definition = "Knowingly filing a complaint which is false, and in bad faith, to Internal Affairs, Command, or Security."
	suggested_punishments = "Fine of 250 thaler.  Demotion at discretion of Superior."
	suggested_fine = 250
	notes = "If someone's complaint is merely incorrect but not maliciously so, it does not count for this charge."

/datum/lore/codex/page/law/breaking_sop_minor
	name = "Breaking Standard Operating Procedure (Minor)"
	definition = "Actively and willfully disregarding the station's Standard Operating Procedures, without risking serious threat to station property or crew."
	suggested_punishments = "Fine of 100 thaler. Demotion at discretion of Superior."
	suggested_fine = 100
	notes = "This includes refusal to activate suit sensors on blue or red alert."

/datum/lore/codex/page/law/resisting_arrest
	name = "Resisting Arrest"
	definition = "Noncompliance with an Arresting Officer, whom has cause, and is following SOP."
	suggested_punishments = "Fine of up to 200 thaler, or brig time extention up to 20 minutes. Demotion at discretion of Superior."
	suggested_fine = 200
	suggested_brig_time = 20 MINUTES
	notes = "If this disputed, an Internal Affairs Agent (if available) is to be the impartial mediator."

/datum/lore/codex/page/law/control_contraband
	name = "Possession of a Controlled Item (Contraband)"
	definition = "Carrying an object which NanoTrasen has deemed harmful, or otherwise undesired for the \
	station, but which is not illegal by Law or dangerous to possess."
	suggested_punishments = "Confiscation of the controlled items if brought onboard. The owner may have the items back when they leave the station."
	notes = "Visitors boarding the station with controlled items must leave the item outside the station (e.g. their vessel), or surrender \
	it to the Security team for the duration of their stay.  A list of contraband is provided inside this book."

/datum/lore/codex/page/law/disrespecting_head
	name = "Disrespecting a Head of Staff"
	definition = "Knowingly insulting, belittling, offending, or otherwise disrespecting a Head of Staff of NanoTrasen, while also \
	an employee of NanoTrasen."
	suggested_punishments = "Fine of up to 100 thaler. Demotion at discretion of Superior."
	suggested_fine = 100
	notes = "Accidential cases resulting from, for example, ignorance of a species' culture, invalidates this charge."

/datum/lore/codex/page/law/indecent_exposure
	name = "Indecent Exposure"
	definition = "To be intentionally and publicly unclothed in public."
	suggested_punishments = "Fine of 150 thaler. Demotion at discretion of Superior."
	suggested_fine = 150
	notes = "Exceptions are allowed based on species.  See the Dress Code section of General SOP for more details."

/datum/lore/codex/page/law/hooliganism
	name = "Hooliganism"
	definition = "To intentionally engage in disruptive behavior such as belligerent drunkenness, disorderly shouting, or aggressive assembly. "
	suggested_punishments = "Fine of 100 thaler or brig time of 15 minutes. Demotion at discretion of Superior."
	suggested_fine = 100
	notes = "People who are intoxicated and being an annoyance can be brigged until they become sober, at the discretion of the Arresting Officer."

// Major Violations area
/datum/lore/codex/category/corporate_major_violations
	name = "Major Violations (Corporate)"
	data = "Here is a list of the more severe violations of Corporate Regulations that might occur.  If someone is guilty of \
	a violation listed here, it is highly recommended that a report be sent to your local Central Command."
	children = list(
		/datum/lore/codex/page/law/major_trespass,
		/datum/lore/codex/page/law/i_am_the_law,
		/datum/lore/codex/page/law/abuse_of_office,
		/datum/lore/codex/page/law/restricted_contraband,
		/datum/lore/codex/page/law/breaking_sop_major,
		/datum/lore/codex/page/law/neglect_of_duty,
		/datum/lore/codex/page/law/deception,
		/datum/lore/codex/page/law/wrongful_dismissal,
		/datum/lore/codex/page/law/abuse_of_confiscated_equipment

		)

/datum/lore/codex/page/law/major_trespass/add_content()
	name = "Major Trespass"
	keywords += list("Infiltration")
	definition = "Being in an restricted, or otherwise dangerous (to themselves or others) area which they do not have access to, \
	and do not have permission to be in."
	suggested_punishments = "Demotion.  Termination at discretion of Station Admin.  Send notice to Central Command."
	notes = "Also sometimes called Infiltration.  Such areas include the AI upload/core, Armory, Engine, Atmospherics, Virology, Bridge, Station Admin's office.  \
	Other areas may warrant the [quick_link("Minor Trespass")] charge instead."
	..()

/datum/lore/codex/page/law/i_am_the_law/add_content()
	name = "Exceeding Official Powers"
	definition = "Acting beyond what is allowed by Corporate Regulations  or Standard Operating Procedure, generally as a member of Command or Security."
	suggested_punishments = "Demotion or termination at discretion of Station Admin.  Send notice to Central Command if a Head of Staff or Station Director had exceeded their powers."
	notes = "The difference between this and [quick_link("Abuse of Office")] is that generally this charge is for instances of someone using their position to go beyond their \
	assigned role, or generally acting 'above the regulations'."
	mandated = TRUE
	..()

/datum/lore/codex/page/law/abuse_of_office/add_content()
	name = "Abuse of Office"
	definition = "Doing illegal, immoral, or otherwise disallowed actions, in an official capacity, placing their own interests ahead of the interests of the Company."
	suggested_punishments = "Demotion.  Termination at discretion of Station Admin.  Send notice to Central Command if a Head of Staff or Station Director had abused their office."
	notes = "The difference between this and [quick_link("Exceeding Official Powers")] is that this charge is for instances of someone using their authority to adversely \
	affect another crewmember or visitor unlawfully by using their authority, or otherwise empowering themselves for their own personal gain."
	mandated = TRUE
	..()

/datum/lore/codex/page/law/restricted_contraband
	name = "Possession of a Restricted Item"
	definition = "Carrying an object which Nanotrasen deems dangerous to the welfare of the station as a whole, such as a deadly weapon, by someone not authorized to handle it."
	suggested_punishments = "Confiscation of the restricted item, and notice be sent to Central Command.  Persons may be detained and investigated if deemed necessary."
	notes = "Visitors boarding the station with restricted items must leave the item outside the station (e.g. vessel), or surrender it to the Security team.  \
	A list of restricted items are provided inside this book.\
	<br><br>\
	Roles authorized to handle a weapon by default include; Station Director, Head of Personnel, Head of Security, Security Officers, Detectives, and anyone possessing \
	a valid weapon permit."

/datum/lore/codex/page/law/breaking_sop_major
	name = "Breaking Standard Operation Procedure (Major)"
	definition = "Actively and willfully disregarding the station's Standard Operating Procedures, where the probable effects includes death or destruction."
	suggested_punishments = "30 minutes to 1 hour of Brig time.  Demotion left to discretion of Superior, but strongly suggested.  Termination at discretion of Station Director."
	suggested_brig_time = 1 HOUR
	notes = "This includes non-compliance to orders from Emergency Responders, entering breached areas without proper EVA gear."

/datum/lore/codex/page/law/neglect_of_duty
	name = "Neglect of Duty"
	definition = "To fail to meet satisfactory work standards."
	suggested_punishments = "Demotion at discretion of Superior.  Termination at discretion of Station Director."
	notes = "This includes accidents, refusing or failing to work, or simply not providing a reasonable amount of productivity, when the offender is capable of work.  This charge \
	is meant to be applied only by Command staff to their subordinates, and not from individual Security Officers."

/datum/lore/codex/page/law/deception
	name = "Deception"
	definition = "To lie in an official report."
	suggested_punishments = "Demotion.  Termination at discretion of Station Director.  Notify Central Command."
	notes = "This includes lying or withholding information to your superior in a report or lying to the crew about a situation."
	mandated = TRUE

/datum/lore/codex/page/law/wrongful_dismissal
	name = "Wrongful Dismissal"
	definition = "To demote, dismiss, terminate, or otherwise reduce a crewmember's rank for no valid, or a knowingly false reason."
	suggested_punishments = "Demotion.  Termination at discretion of Station Director.  Notify Central Command."
	notes = "An Internal Affairs Agent is required to do an investigation in order to conclude if this has occurred or not.  Security cannot \
	give this charge out on their own."
	mandated = TRUE

/datum/lore/codex/page/law/abuse_of_confiscated_equipment
	name = "Abuse of Confiscated Equipment"
	definition = "To take and use equipment confiscated as evidence or contraband, generally as a member of Security or Command."
	suggested_punishments = "Demotion of the user.  Termination at discretion of Station Director.  Return confiscated equipment to evidence storage."
	notes = "Security shouldn't be using evidence for anything but evidence, and should never use contraband.  This is meant for people misusing evidence for personal use.  Evidence stolen \
	in order to cover up a crime would fall under Theft or Tampering with Evidence."
