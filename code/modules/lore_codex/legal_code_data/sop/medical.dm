/datum/lore/codex/category/medical_sop
	name = "Medical SOP"
	data = "This SOP is specific to those in the Medical department, and focuses on Triage/First Aid priority, Proper Cloning procedure and CMD, how to store a body, and DNC orders."
	children = list(
		/datum/lore/codex/page/sop_triage,
		/datum/lore/codex/page/sop_cloning,
		/datum/lore/codex/page/sop_cmd,
		/datum/lore/codex/page/sop_postmortem,
		/datum/lore/codex/page/sop_medical_breach
		)

/datum/lore/codex/page/sop_triage
	name = "Triage / First Aid Priority"
	data = "The priority for Triage, is generally;\
	<br><br>\
	Safety > Dying > Wounded > Injured > Dead\
	<br>\
	<ul>\
	<li>\[0\] <b>Safety</b>: Upon arrival at the scene, first assess if it is safe to begin treatment and recovery. Your safety is the most important part of \
	performing first aid; a wounded medic is worse than useless, they're now a patient.</li>\
	<li>\[1\] <b>Dying</b>: These patients are non-responsive and critical, but are still alive. Stasis bag them for transport back to the medical bay.</li>\
	<li>\[2\] <b>Wounded</b>: These patients are Severely Injured, but not yet in danger of dying. Anyone who is unable to travel to the medical bay under their \
	own power who, and who is not also dying, falls under this diagnosis. Treat these as appropriate for their injuries, being wary of worsening vital signs, and \
	prepare to transport them back to medical if necessary.</li>\
	<li>\[3\] <b>Injured</b>: These patients are injured, but not in need of immediate medical treatment. If possible, treat them on scene.</li>\
	<li>\[4\] <b>Dead</b>: The dead are to be gathered in body bags, and returned to the medical bay in preparation for postmortem instructions.</li>\
	</ul>"

/datum/lore/codex/page/sop_cloning
	name = "Cloning Procedures"
	data = "Persons whom have committed suicide are not to be cloned, without authorization from the Chief Medical Officer.  \
	The Chief Medical Officer is fully responsible if they choose to clone a person whom has committed suicide.  \
	Individuals are also to not be cloned if there is a Do Not Clone (generally referred to as DNC) order in their medical records, \
	or if the individual has had a DNC order declared against them by the " + JOB_SITE_MANAGER + ", Chief Medical Officer, or " + JOB_HEAD_OF_SECURITY + ".  \
	If any of this occurs, procede to Portmortem Storage.\
	<br><br>\
	Some individuals may have special instructions in their Postmortem Instructions, generally found in their medical records.  \
	Be sure to read them before committing to cloning someone.  In particular, some instructions may express a desire to be placed \
	inside a synthetic body.  If this is the case, contact Robotics.  If robotics is not available, and no instructions for \
	cloning exist in their records, proceed to Postmortem Storage.\
	<br><br>\
	If no records are included, it is assumed that the patient wishes to be cloned, and should be cloned.\
	<br><br>\
	Ensure that all cloning equipment, including the cryogenic tubes, are functional and ready before cloning begins.  Once \
	this is done, scan the deceased.  Up to three scans are to be made per attempt.  If the deceased suffers Mental Interface Failure, \
	procede to Postmortem Storage.  Further attempts at resuscitation may be made at later times, at the medical teams' discretion. \
	<br><br>\
	If the deceased is sufficently scanned, remove their possessions and clothing off of the deceased body, for use by the future new clone.  \
	Move the cadaver into the morgue, as per Postmortem Storage.  Begin the cloning process.  Possessions are to be gathered in a manner that \
	facilitates transporting them along with the clone.  Upon the cloning process being complete and the new clone being created, the \
	clone is to be placed inside a croygenic tube as quickly as possible.  Cloning is not a painless experience, and it is best if \
	the patient reawakens inside a functional body.  Once their body is fully functional, dress and process the newly cloned patient, \
	informing them of any procedures performed on them, including the cloning itself."

/datum/lore/codex/page/sop_cmd
	name = "Clone Memory Disorder"
	data = "Clones, persons transferred to MMIs, and recently restarted synthetics will not remember the events which lead to their demise.  \
	They are to be told that they have been resurrected, and any further questions they have should be answered, if possible.  Organic \
	individuals revived by a defibrillator do not experience this phenomenon."

/datum/lore/codex/page/sop_postmortem
	name = "Postmortem Storage"
	data = "Deceased persons should be kept in the morgue, and should be contained inside black body bags.  The body bag is to be labelled with the deceased's name, along \
	with 'DNC', 'MIF', or 'Cloned' where applicable.  Bodies in the morgue are to be transferred to Central Command whenever possible.  Funerary \
	services are to be handled off site.  A service may be held within the Chapel if it is desired, however the body must still be brought to \
	Central."

/datum/lore/codex/page/sop_medical_breach
	name = "Breach Response (Medical)"
	data = "If a room becomes breached, the first priority is to evacuate any crewmembers and guests endangered by the breach, especially if they lack an EVA \
	suit.  Emergency softsuits are available in cyan colored lockers at key locations on your facility, if an untrained person requires short term EVA \
	capability.  Those exposed to vacuum without protection will almost certainly require advanced medical care, so bring anyone harmed to Medical.  \
	Remember to avoid risking your own life, as stated in the Triage section."
