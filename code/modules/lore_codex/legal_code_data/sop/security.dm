/datum/lore/codex/category/security_sop
	name = "Security SOP"
	data = "This SOP is specific to those in the Security department, and focuses on proper arrest procedure, processing, escalation of force, and such."
	children = list(
		/datum/lore/codex/page/sop_arrest,
		/datum/lore/codex/page/sop_processing,
		/datum/lore/codex/page/sop_brigging,
		/datum/lore/codex/page/sop_solitary,
		/datum/lore/codex/page/sop_prisoner_rights,
		/datum/lore/codex/page/sop_sec_alert_levels,
		/datum/lore/codex/page/sop_escalation,
		/datum/lore/codex/page/sop_hostage
		)

/datum/lore/codex/page/sop_arrest
	name = "Arrest Procedure"
	data = "Security is responsible for the health and safety of anyone they arrest.  Unless the safety of any crewmember if threatened, all attempts at arrest \
	are to follow this procedure.\
	<br><br>\
	Set the suspect to Arrest in their security records (Can be done with a SecHUD).  Locate the suspect.  Inform them that you are arresting them, \
	as well as the charges they are being arrested under.  The following steps assume that the suspect does not respond to the arresting \
	officer in a violent manner.  If they follow orders given by the arresting officer, they are considered compliant.  If they do not respond, \
	or attempt to non-violently resist arrest, they are considered non-compliant.  Applying handcuffs is at the discretion of the arresting officer, \
	but the following is strongly recommended.\
	<br><br>\
	If the suspect is compliant, ask them to follow you.  Handcuffs are not required if the subject is complaint and not likely to attempt escape.  \
	If the suspect is compliant, but likely to attempt escaping arrest, inform them that you will be handcuffing them.  If they continue to comply, \
	do so.  If the suspect is non-compliant, the arresting officer may attempt to complete the arrest using Less-than-Lethal force.  \
	Resisting Arrest may be added to the suspect's punishment if they are found guilty of other crimes.  Return to the brig with the \
	suspect for processing."

/datum/lore/codex/page/sop_processing
	name = "Processing"
	data = "Processing is the responsibility of the Arresting Officer, or the " + JOB_WARDEN + " if the " + JOB_WARDEN + " chooses to do so.  The suspect is to be informed \
	again of the cause for their arrest, and that they will be searched.  Suspects are assumed to be innocent until they are proven guilty.  \
	They are to be thoroughly searched.  They may not be stripped of their inner clothing, though pockets are to be emptied.  \
	Any and all found contraband is to be confiscated, and anything that may be used to escape the brig is to be confiscated until the suspect's release.\
	<br><br>\
	Assess the suspect's guilt.  Contraband found in the search may be used as evidence at the discretion of the Arresting Officer.  If the \
	suspect is found innocent, all non-contraband is to be returned to them, and they are to be released.  If instead they are found guilty and \
	brig time is required by the type of violation they are guilty of, or have chosen brig time as an alternative to a fine if possible, they \
	are now considered a Prisoner, and further processing is the responsibility of the " + JOB_WARDEN + ", if one is present.  If no " + JOB_WARDEN + " is present, the \
	Arresting Officer is to continue processing.\
	<br><br>\
	The Prisoner is to be informed of their Sentencing Options, if available.  These will vary depending on the violation in question, and \
	the exact circumstances involved.  For minor violations of Corp Regs, generally the Prisoner will have a choice of paying a Fine, or \
	serving time within the brig.  For major violations, generally a demotion is recommended, however this is at the discretion of the Prisoner's \
	Superior, and not the Arresting Officer.  For minor violations of Sif Law, the same rules generally apply as if it was a minor Corp Reg violation, however \
	major Law violations generally require a long brig sentence, or Holding until Transfer, as well as a fax to the VGA.  See the specific violation contained \
	in this book for more details."

/datum/lore/codex/page/sop_brigging
	name = "Brigging"
	data = "The Prisoner is to remain handcuffed during this process, until noted.  Set their security record to Incarcerated.  They are to be brought to an available cell.  \
	The cell timer should be set to the prisoner's sentencing time at this point, but not engaged.  They are to be brought into the cell.  If their sentence time is Hold until Transfer, \
	they are to be stripped, and dressed in the provided orange jumpsuit and shoes.  <u>Prisoners are entitled to keep their communication devices \
	(Radio, PDA, and Communicator), so long as they do not abuse them.</u>  Prisoners sentenced to Holding until Transfer who have access to sensitive \
	department channels are to have their radio replaced with a general use radio.  The prisoner's possessions are to be placed in the cell's locker, \
	which will open upon their release.\
	<br><br>\
	The " + JOB_WARDEN + " or processing officer is to set the cell timer, uncuff the Prisoner, and exit the cell, in any order desired.  If the Prisoner is non-compliant, the " + JOB_WARDEN + " can activate \
	the cell's mounted flash, to incapacitate the Prisoner.  The " + JOB_WARDEN + " may use up to Less-than-Lethal force to Prisoners resisting.  Once the \
	Prisoner is secure, and the handcuffs recovered, the " + JOB_WARDEN + " may elect to open the communal brig for said prisoner.  It is recommended to do this.  If multiple Prisoners are present, \
	the " + JOB_WARDEN + " is to assess the threat posed by all prisoners as a group, to the Security team and to themselves, before allowing any Prisoner to access \
	the communal brig.\
	<br><br>\
	The " + JOB_WARDEN + " is to check in on all prisoners frequently, to ensure they remain contained and healthy.  This can be accomplished with the use of \
	cameras.  They are to also keep track of the sentencing time for all their prisoners, and be on location to escort them out of the brig when \
	their time is up and they have returned to their normal clothing.  The Prisoner's possessions are to be returned to the Prisoner at this time, and \
	their security record must be set to Released."

/datum/lore/codex/page/sop_solitary
	name = "Solitary Confinement"
	data = "Solitary confinement is only to be used with prisoners possessing Hold until Transfer sentences that cannot be trusted with access to the normal \
	brig, due to attempts at escaping, or posing a threat to other prisoners, or themselves.  A prisoner is to never be placed inside Solitary as a first course of \
	action.  Prisoners inside Solitary are to still be checked up on by the " + JOB_WARDEN + "."

// Sad that we need this page to exist.
/datum/lore/codex/page/sop_prisoner_rights
	name = "Prisoners' Rights"
	data = "Prisoners are still under the protections of local Sif Law and Corporate Regulations, and still have their Sapient Rights (if applicable), sans their freedom of movement.  \
	Prisoners are entitled to have their communication devices (Radio, PDA, Communicator), provided they do not abuse them.  Departmental radios must be \
	exchanged for general radios, if the prisoner has been sentenced to Holding until Transfer, or otherwise has been demoted by their Superior.  Prisoners \
	are also entitled to receive medical care.  Their timer continues to run while they are outside their cell in order to receive medical treatment, if \
	leaving is needed."

/datum/lore/codex/page/sop_sec_alert_levels
	name = "Alert Levels for Security"
	data = "For Green, Lethal weaponry are to be hidden, except in emergencies.  Non-lethal weaponry such as tasers may be worn on the belt or suit.  \
	Officers may wear their armor vest if desired.  Helmets are permitted but not recommended.  Weaponry and specialized armor from the Armory should \
	be returned if there is no pressing need for them to be deployed.\
	<br>\
	For Blue, Security may have weapons visible, but not drawn unless needed.  Body armor and helmets are recommended bot not mandatory.  \
	Weaponry and specialized armor are allowed to be given out to security officers, with clearance from the " + JOB_WARDEN + " or " + JOB_HEAD_OF_SECURITY + ".\
	<br>\
	For Red, Security may have weapons drawn at all times, however properly handling of weapons should not be disregarded.  Body armor and \
	helmets are mandatory.  Specialized armor may be distributed by the " + JOB_WARDEN + " and " + JOB_HEAD_OF_SECURITY + ", when appropriate."

/datum/lore/codex/page/sop_escalation
	name = "Escalation of Force"
	data = "Safety > Passive > Less-than-Lethal > Neutralize\
	<br>\
	<ul>\
	<li>\[0\] <b>Safety</b>: If a crewmember (including the Arresting Officer) is in clear and immediate danger, officers may disregard steps \[1\] and \[2\], \
	and proceed to \[3\] Neutralize.</li>\
	<li>\[1\] <b>Passive</b>: Suspects are to be detailed verbally, with zero or minimal injury, and under their own power, if possible.  At this level for \
	force, an Officer is permitted to use tasers, pepperspray, flashes, and stunbatons.</li>\
	<li>\[2\] <b>Less-than-Lethal</b>: Suspect may be detained with minimal force, causing as little injury as possible.  The Arresting Officer must still \
	attempt to engage the suspect verbally before discharging a weapon.  At this level for force, an officer is permitted to use rubber rounds.</li>\
	<li>\[3\] <b>Neutralize</b>: Suspects may be detained through use of extreme force.  This is only valid for suspects which present a lethal risk to any persons, \
	including the Arresting Officer.  Officers who kill a suspect in the arrest may be tried for manslaughter or murder, if the circumstances were unjustified.  \
	Lethals may be used, if no other option presents itself.  If the suspect becomes incapacitated or otherwise unable to present a lethal risk to anyone, \
	further lethal force may constitute a Murder charge.</li>\
	</ul>"

/datum/lore/codex/page/sop_hostage
	name = "Hostage Response"
	data = "In the event of a serious hostage situation, the hostage's life is the highest priority.  Do not do anything that will present \
	undue risk to the hostage, or otherwise will get them killed.  Negotiation should be the first response, as opposed to violently rushing the hostage taker."
