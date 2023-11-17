/datum/lore/codex/category/sif_law
	name = "Sif Law"
	data = "This section contains the abbreviated Sif Govermental Authority legal code's potential charges for crimes that are relevant to \
	the reader."
	children = list(
		/datum/lore/codex/page/legal_punishments,
		/datum/lore/codex/category/law_minor_violations,
		/datum/lore/codex/category/law_major_violations
		)

/datum/lore/codex/page/legal_punishments
	name = "Punishments (Law)"
	data = "A violation of Sif Law is considered far more serious then a violation of corporate regulations. \
	As a result, its expected that a member of Internal Affairs be present to observe and assist security with the paperwork if they are able. \
	Unlike Corporate Regulations, all violations of Sif Law will require a fax detailing the events to be sent to the \
	Sif Governmental Authority within a certain amount of time based on whether or not it was a minor or major violation. \
	Punishments will usually include brig time with fines still remaining an option for the far less serious crimes. \
	It should be noted that a majority of major violations carry a 'Hold till Transfer' order."

/datum/lore/codex/category/law_minor_violations
	name = "Minor Violations (Law)"
	data = "Here is a list of the less severe violations of local Sif Law that might occur on your facility.  A fax to the Sif Governmental Authority \
	is required to be sent within 24 hours of a violation being committed, for minor violations listed here."
	children = list(
		/datum/lore/codex/page/law/theft,
		/datum/lore/codex/page/law/assault,
		/datum/lore/codex/page/law/battery,
		/datum/lore/codex/page/law/vandalism,
		/datum/lore/codex/page/law/animal_cruelty,
		/datum/lore/codex/page/law/disrespect_dead,
		/datum/lore/codex/page/law/slander,
		/datum/lore/codex/page/law/drone_id_failure
		)

/datum/lore/codex/page/law/assault/add_content()
	name = "Assault"
	definition = "To threaten use of physical force against someone while also having the capability and/or intent to carry out that threat."
	suggested_punishments = "Separation of offender from the threatened person.  Brig time of 10 minutes for first offense.  \
	Repeat offenders can be brigged for up to (10 minutes times number of previous assault charges).  Demotion at discretion of Superior."
	notes = "Not to be confused with [quick_link("Battery")], which covers actual physical injury. The threat must be viable and serious; \
	two people threatening to punch each other out over comms wouldn't fall under this."
	..()

/datum/lore/codex/page/law/battery/add_content()
	name = "Battery"
	definition = "To unlawfully use physical force against someone which results in injury to the attacked party."
	suggested_punishments = "Brig time of 20 minutes for first offense.  Repeat offenders are to be brigged for up to \
	20 minutes times number of previous battery charges.  Demotion at discretion of Superior.  Weapons or other objects used (such as flashes) may be \
	confiscated at discretion of Arresting Officer."
	notes = "Not to be confused with [quick_link("Assault")], which covers the threat of harm. If the victim suffers life-threatening injuries, the more \
	serious [quick_link("Aggravated Battery")] charge should be applied instead."
	mandated = TRUE
	..()

/datum/lore/codex/page/law/theft
	name = "Theft"
	definition = "To knowingly take items without the consent of the owner."
	suggested_punishments = "Brig time of 20 minutes.  Demotion at discretion of Superior.  Confiscation of tools used at discretion of arresting officer."
	notes = "It is assumed that persons inside a department using departmental equipment have the consent of NanoTrasen to take those items. \
	Security does not commit theft when taking contraband away from a detainee.  Stolen items are to be confiscated and returned to \
	their original owner or location."
	mandated = TRUE

/datum/lore/codex/page/law/vandalism/add_content()
	name = "Vandalism"
	definition = "To deliberately damage or deface the station."
	suggested_punishments = "Fine of up to 200 thaler or brig time of up to 30 minutes.  \
	Demotion at discretion of Superior.  Confiscation of tools used at discretion of arresting officer."
	notes = "This should be used for minor damages such as broken windows which do not lead to vacuum, flipping tables, breaking \
	lights, ripping up floor tiles, and such.  More serious or life threatening damages should have [quick_link("Sabotage")] applied instead."
	..()

/datum/lore/codex/page/law/animal_cruelty
	name = "Animal Cruelty"
	definition = "To inflict unnecessary suffering or harm on a non-sapient biological being which poses no threat to any persons."
	suggested_punishments = "Brig time of 1 hour. Demotion at discretion of Superior, however recommended."
	notes = "This does not include the use of monkeys for test subjects for legitimate scientific experimentation, such as viral research, \
	or xenobiological applications.  It also does not include the butchering of livestock animals for meat, nor does it include violence against a threatening \
	animal, such as Carp."
	mandated = TRUE

/datum/lore/codex/page/law/disrespect_dead
	name = "Disrespect to the Dead"
	definition = "To damage, disfigure, butcher, or otherwise physically violate the integrity or former identity of a corpse."
	suggested_punishments = "Brig time of 1 hour. Demotion at discretion of Superior, however recommended."
	notes = "The butchering of livestock animals does not fall under this charge.  Autopsies, and the harvesting of organs for \
	donation in accordance with postmortem instructions also do not fall under this."
	mandated = TRUE

/datum/lore/codex/page/law/drone_id_failure
	name = "Failure to Present Drone ID"
	definition = "Failing to carry or present an EIO-issued Drone Identification card as a Drone intelligence."
	suggested_punishments = "200 thaler fine.  Give Drone a temporary paper stating that it is a drone, if the ID was lost.  Fax VirGov.  Inform owner of \
	Drone if possible.  Instruct Drone to obtain new ID at its earliest opportunity, if it was lost."
	notes = "This is only applicable to Drone intelligences which possess autonomous capability.  It must be proven that the offender is a Drone, which can be \
	accomplished in various ways, generally with the expertise of a Roboticist.  Lawbound synthetics, maintenance drones, and \
	simple bots do not require an ID card.  No fine or VirGov fax should be sent if the Drone's ID was lost due to theft and the ID is able to be recovered."
	mandated = TRUE

/datum/lore/codex/page/law/slander
	name = "Slander / Libel"
	definition = "To spread false rumours in order to damage someone's reputation."
	suggested_punishments = "150 thaler fine."
	notes = "Slander is for verbal cases, where as Libel is for written cases."
	mandated = TRUE

/datum/lore/codex/category/law_major_violations
	name = "Major Violations (Law)"
	data = "Here is a list of the serious violations of local Sif Law that might occur on your facility.  A fax to the Sif Governmental Authority \
	is required to be sent within one hour, or when it is safe to do so, for major crimes listed here."
	children = list(
		/datum/lore/codex/page/law/aggravated_battery,
		/datum/lore/codex/page/law/tampering_with_evidence,
		/datum/lore/codex/page/law/embezzlement,
		/datum/lore/codex/page/law/excessive_force,
		/datum/lore/codex/page/law/manslaughter,
		/datum/lore/codex/page/law/murder,
		/datum/lore/codex/page/law/suicide_attempt,
		/datum/lore/codex/page/law/unlawful_law_changes,
		/datum/lore/codex/page/law/transgressive_tech,
		/datum/lore/codex/page/law/unrated_drones,
		/datum/lore/codex/page/law/grand_theft,
		/datum/lore/codex/page/law/sabotage,
		/datum/lore/codex/page/law/hostage_taking,
		/datum/lore/codex/page/law/terrorist_acts
		)

/datum/lore/codex/page/law/aggravated_battery/add_content()
	name = "Aggravated Battery"
	definition = "To unlawfully use physical force against someone which results in serious or life-threatening injury to the attacked party."
	suggested_punishments = "Hold until Transfer.  Weapons or other objects used are to be confiscated."
	notes = "Not to be confused with assault, which covers the threat of harm. If the victim did not suffer life-threatening injuries, the less \
	serious [quick_link("Battery")] charge should be applied instead."
	mandated = TRUE
	..()

/datum/lore/codex/page/law/tampering_with_evidence/add_content()
	name = "Tampering with Evidence / Obstruction of Justice"
	keywords += list("Tampering with Evidence", "Obstruction of Justice")
	definition = "To take intentional action to obstruct or inhibit investigation of a crime or regulation violation."
	suggested_punishments = "Hold until Transfer if obstructing a crime.  Demotion or termination if obstructing a regulation violation."
	notes = "This can include cleaning up blood at a crimescene, hiding evidence, scrubbing the messaging server/telecomms logs, and burning papers.  \
	Planting or altering evidence, giving false testimony, preventing Security from investigating, or extorting any person to do the same also falls \
	under this charge.  Blood being cleaned at a location not cordoned off with Security tape does not fall under this charge."
	mandated = TRUE
	..()

/datum/lore/codex/page/law/embezzlement
	name = "Embezzlement"
	definition = "Stealing money that is entrusted to you by a corporation or person."
	suggested_punishments = "Hold until Transfer.  Termination.  Reimbursement of embezzled funds.  Fax Central Command and VirGov."
	notes = "This includes funneling Departmental, Facility, or Crew funds into the offender's account.  It also includes pocketing \
	transactions directly that are meant to go to a separate account."
	mandated = TRUE

/datum/lore/codex/page/law/excessive_force/add_content()
	name = "Excessive Force"
	definition = "Using more force than what is required to safely detain someone, using force against a helpless or incapacitated person, \
	or using force against an unarmed and compliant person."
	suggested_punishments = "Demotion.  Termination at discretion of Superior, or Station Director.  Send notice to Central Command if a Head of Security had used excessive force."
	notes = "This charge also is applicible to non-Security personnel acting in self defense.  \
	Persons whom have caused a person to die as a result of excessive force should have [quick_link("Manslaughter")] applied instead, if the circumstances were \
	unjustified."
	..()

/datum/lore/codex/page/law/manslaughter/add_content()
	name = "Manslaughter"
	definition = "To kill a sapient being without intent."
	suggested_punishments = "Hold until Transfer, if unjustified.  Fax VirGov."
	notes = "Includes provoked manslaughter, negligent manslaughter, and impassioned killing.  The important distinction between this \
	and [quick_link("Murder")] is intent.  Manslaughter can be justified if force was necessary and it was intended to prevent further loss of life or \
	grievous injury to self or others, however persons involved in the kill will still be required to answer to higher legal authority \
	after the shift."
	mandated = TRUE
	..()

/datum/lore/codex/page/law/murder/add_content()
	name = "Murder"
	definition = "To kill or attempt to kill a sapient being with malicious intent."
	suggested_punishments = "Hold until Transfer.  Termination.  Fax VirGov."
	notes = "The distinction between this and [quick_link("Manslaughter")] is intent.  Sapients held within synthetic bodies, lawbound or otherwise, which receive \
	critical damage from someone can be considered a murder attempt."
	mandated = TRUE
	..()

/datum/lore/codex/page/law/suicide_attempt
	name = "Suicide Attempt"
	definition = "To attempt or threaten to commit suicide."
	suggested_punishments = "Compulsory psychiatric examination."
	notes = "If a mental care specialist is unavailable, they are to be held until transfer, to be moved to a qualified mental care facility."
	mandated = TRUE

/datum/lore/codex/page/law/transgressive_tech/add_content()
	name = "Experimentation with Transgressive Technology"
	keywords += list("Transgressive", "Illegal Technology")
	definition = "Experimenting with technologies deemed unsafe or are otherwise federally restricted by the Solar Confederate Government."
	suggested_punishments = "Hold until Transfer.  Termination.  Fax VirGov.  Delete, destroy, or otherwise remove the experiments."
	notes = "Unsafe technologies include unrestricted nanomachinery, massive sapient body bio-augmentation, massive sapient brain augmentation, \
	massively self-improving AI, and animal uplifting."
	mandated = TRUE
	..()

/datum/lore/codex/page/law/unrated_drones
	name = "Creation of Unrated Drone Intelligence"
	definition = "Creating an intelligence from an codeline that has not been registered with, or audited by, the Emergent Intelligence Oversight (EIO)."
	suggested_punishments = "Decommissioning of the newly created Drone.  Investigation of Drone to determine level of intelligence, if possible.  \
	Hold until Transfer for the creator."
	notes = "It must be proven that the Drone is in fact a Drone, which can be accomplished in various ways, generally with the expertise of a Roboticist.  \
	It must also be proven that the Drone's codeline is also unregistered. Intelligences produced from a Maintenance Drone Fabricator, \
	the Research department, and through other regular means are by default already registered.  Very simple machines such as securitrons do not require registration.\
	<br><br>\
	The remains of the Drone are to be brought to the Spaceport at the earliest opportunity.  Their creator is to also be brought there, so that \
	they may be questioned by federal authorities."
	mandated = TRUE
/*
	Punishments for estimated Drone Class.;\
	<ul>\
	<li><b>\"F\"-class</b>: No action needed.</li>\
	<li><b>D-class</b>: 500 thaler fine.</li>\
	<li><b>C-class</b>: 2500 thaler fine.</li>\
	<li><b>B-class and higher</b>: Hold until Transfer.</li>\
	<li><b>Cannot determine</b>: Hold until Transfer, bring Drone to Spaceport for further investigation.</li>\
	</ul>"
*/
/datum/lore/codex/page/law/unlawful_law_changes
	name = "Unlawful Alteration of Bound Synthetics"
	definition = "Modifying a bound synthetic's lawset or chassis, in order to force it to do illegal, humiliating, dangerous, or other unlawful acts."
	suggested_punishments = "Hold until Transfer.  Termination.  Fax VirGov."
	notes = "If the synthetic is a cyborg or positronic, this is also an offense against the Sapient Rights laws federally mandated by the Solar Confederate Government."
	mandated = TRUE

/datum/lore/codex/page/law/grand_theft
	name = "Grand Theft"
	definition = "To steal items that are dangerous, of a high value, or a sensitive nature."
	suggested_punishments = "Hold until Transfer.  Termination.  Fax VirGov."
	notes = "This can include the following;\
	<br><ul>\
	<li>Deadly Weapons or Firearms.</li>\
	<li>Lethal ammunition.</li>\
	<li>Explosives.</li>\
	<li>A Head of Staff's radio headset or decryption key.</li>\
	<li>A Head of Staff's ID card (including the Director's Spare).</li>\
	<li>Sensitive or confidential documents, such as the crews' account information.</li>\
	<li>Viral samples.</li>\
	<li>AI law boards.</li>\
	<li>All circuits found in Secure Technical Storage.</li>\
	<li>Research data.</li>\
	<li>Hand Teleporters.</li>\
	<li>The AI, if a Drone intelligence (otherwise it is Kidnapping/Hostage Taking).</li>\
	<li>The Facility's Blueprints.</li>\
	<li>The RCD.</li>\
	<li>Phoron, in any form.</li>\
	<li>Mineral wealth obtained from Mining or the Vault (Gold, Silver, Diamonds, etc).</li>\
	<li>Hardsuits.</li>\
	<li>Money in excess of 5,000 thaler.</li>\
	</ul>"
	mandated = TRUE

/datum/lore/codex/page/law/sabotage/add_content()
	name = "Sabotage"
	definition = "To deliberately damage, or attempt to damage the facility, or critical systems of the facility."
	suggested_punishments = "Hold until Transfer.  Termination.  Fax VirGov."
	notes = "This includes causing hull breaches, arson, sabotaging air supplies, stealing vital equipment, tampering with AI or telecomm systems, and sabotaging the \
	Engine.  If someone has only caused minor damage, the [quick_link("Vandalism")] charge should be used instead."
	mandated = TRUE
	..()

/datum/lore/codex/page/law/hostage_taking/add_content()
	name = "Kidnapping / Hostage Taking"
	keywords += list("Kidnapping", "Hostage Taking")
	definition = "To unlawfully confine, transport, or hold a sapient being against that individual's will."
	suggested_punishments = "Hold until Transfer.  Termination.  Fax VirGov."
	notes = "Persons held for ransom or exchange are also considered to be hostages for this charge."
	mandated = TRUE
	..()

/datum/lore/codex/page/law/terrorist_acts/add_content()
	name = "Terrorist Acts"
	keywords += list("Terrorism")
	definition = "To engage in maliciously destructive actions, which seriously threaten the crew or facility, or the usage of weapons of mass destruction."
	suggested_punishments = "Hold until Transfer.  Termination.  Fax VirGov."
	notes = "This includes the use of mass bombings, mass murder, releasing harmful biological agents, nuclear weapons, \
	radiological weapons, and chemical weapons."
	mandated = TRUE
	..()
