/datum/lore/codex/category/standard_operating_procedures
	name = "Standard Operating Procedures"
	data = "This section details the various Standard Operating Procedures (often shortened to 'SOP') one may find onboard a NanoTrasen facility."
	children = list(
		/datum/lore/codex/page/general_sop,
//	These are still being discussed
//		/datum/lore/codex/page/command_sop,
//		/datum/lore/codex/category/security_sop,
//		/datum/lore/codex/page/engineering_sop,
//		/datum/lore/codex/category/medical_sop,
//		/datum/lore/codex/page/science_sop,
		/datum/lore/codex/category/alert_levels
		)

/datum/lore/codex/page/general_sop
	name = "General SOP"
	data = "This applies to everyone onboard a NanoTrasen facility, including guests.  Note that specific departmental operating procedures can override some of \
	the procedures listed here.\
	<br><br>\
	<h3>Visitors</h3>\
	Visitors of all forms are required to follow SOP, Corporate Regulations, and local laws while onboard or around NanoTrasen property.  Visitors who are \
	not registered on the manifest are required to speak with the Head of Personnel or Station Director, if one exists, to register, and obtain an identification \
	card denoting their status as a visitor.  Visitors registered on the manifest are free to visit any public (non-access restricted) location on the facility, however \
	they are still subject to the same regulations and rules as an ordinary crew member.\
	<br>\
	<h3>Dress Code</h3>\
	All crew members and visitors, with exceptions listed below, are to wear the following at minimum: A shirt that covers the chest, pants, shorts or skirts that \
	go no shorter than two inches above the knee, and some form of foot covering.  Those in departments considered to be emergency services (Security, \
	Medical, Engineering) should wear a marker denoting their department, examples being armbands, uniforms, badges, or other means.  Those in a department \
	are expected to wear clothes appropiate to protect against common risks for the department.  Off duty personnel, visitors, and those engaging in certain recreational \
	areas such as the Pool (if one is available on your facility) have less strict dresscode, however clothing of some form must still be worn in public.\
	<br><br>\
	Exceptions: Skrell, Teshari, and Unathi are expected to cover at minimum their lower bodies.  Tajaran males may go topless, as a means to keep cool.  \
	Dionaea and 'robotic' synthetics have no minimum required amount of clothing, however they should still wear a departmental marker if in a department.  \
	'Realistic' synthetics are expected to have the same minimum as the species they appear as.\
	<br>\
	<h3>Breach/Fire Procedure</h3>\
	Emergency shutters are yellow-colored doors which lock down the flow of gas automatically, if the facility's systems detect an issue with the atmosphere.  \
	If lights on the shutter are flashing, <b>do not open the shutter</b>, or you will endanger both yourself and anyone else with you.  Allow Engineering to \
	resolve the issue.  If you must enter a breached or burning area, appropriate safety gear must be worn.  Use inflatable doors and walls in order to present \
	less risk to other crew members, if possible.\
	<br>\
	<h3>EVA Procedure</h3>\
	Extravehicular activity should only be done by EVA trained and certified crew members, if there is no emergency.  If an emergency is occuring, NanoTrasen \
	provides high visibility, easy to seal emergency softsuits inside blue emergency lockers located at key locations inside your facility.  Regardless, \
	for your own safety, you should only enter or exit the facility from designated external airlocks, which contain an air cycling system.  It is both \
	wasteful and potentially dangerous to 'force' an external airlock to open before cycling has completed.  Before cycling out into the void, the person going \
	on EVA should double check that their internal oxygen supply (or cooling system, if they are a synthetic) is functioning properly and that they have an adaquate \
	amount of oxygen inside the tank.  Magnetic boots are also highly suggested if the person will be scaling the sides of your facility, to prevent drifting away \
	from the facility.\
	<br><br>\
	Persons going on EVA are to inform their department, or if that is not possible, the facility proper, of leaving.  Those on EVA are recommended to maximize their \
	suit sensors, and maintain contact with the facility with radio, if possible.\
	<br>\
	<h3>Shuttle Docking and Elevator Safety</h3>\
	No one is to remain outside the designated docking areas for shuttles and elevators, as those areas are extremely hazardous.  If repairs or other work are \
	required to be done in those areas, at least one crew member is required to be at the shuttle or elevator's associated console, in order to cancel any movement.\
	<br>\
	"
/*
/datum/lore/codex/page/command_sop
	name = "Command SOP"
	data = "This SOP is specific to those in the Command department, which includes the Station Director, Head of Personnel, Chief Engineer, Head of Security, and Research Director.  \
	This also covers Internal Affairs Agents, however they do not occupy a position inside Command crew, and instead exist outside of all the other departments.\
	<br>\
	<h3>Bridge Secretaries</h3>\
	Bridge Secretaries are not considered Command crew.  They are present to assist the Command crew where needed.  Command Secretaries are equivalent to station crew in all other \
	regards.\
	<br>\
	<h3>Responsibility and Authority</h3>\
	The Chain of Command is generally represented as: Station Director > Command Crew > Station Crew.<br>\
	The Station Director is responsible for, and authoritative in, and and all matters regarding the station.  In the absence of a Department Head, the Station Director \
	may choose to appoint an Acting Head, or else act as the voice of authority in a department.  If a Department Head arrives on station, the Acting Head \
	is to step down, and the Station Director is to defer to the Department Head in matters involving said department.\
	<br>\
	The remainder of the Command Crew is of equal rank among themselves, and are responsible for, and authoritative over only their own department, crew, and location.  \
	In the case of the Head of Personnel, this includes Service, Cargo, and any other Civilian role.  Command Crew only have authority in their own department, when going \
	outside of their department, they must work through the same channels as Station Crew.\
	<br>\
	<h3>Demotion</h3>\
	A member of the Command Crew may call for the demotion of any member of their department for disregarding safety protocol, disobeying orders with serious consequences, \
	or other gross incompetence.  Certain infractions necessitate that a guilty crew member receive a demotion.  Demotion is to be performed by the Head of Personnel, or the \
	Station Director, as soon as possible.  The demoted crewmember is to be present during the demotion, unless it is caused by a criminal sentence.  If said crewmemeber \
	refuses to comply with a demotion order, Security is to escort them to the Head of Personnel's office.\
	<br>\
	Any demoted crewmember must return all equipment and non-personal items to their previous department, including departmental jumpsuits and radios.  If a demoted \
	crewmember does not have personalized clothing, they are welcome and encouraged to use a grey jumpsuit.  If they do not return department property, Security \
	may treat said items as stolen.\
	<br>\
	<h3>Chain of Command & Succession</h3>\
	In case of emergency or other need, and in the absence of a Station Director, an Acting Director may be selected from active, certified Command crew.  \
	The selected individual has the same responsibility and authority as a certified Station Director, along with that of their regular position, with the assumption that \
	they will step down if a certified Station Director arrives on station.  This role is entirely voluntary, and no Command crew may be forced into the role \
	if they are opposed to doing so.\
	<br>\
	The preferred order of selecting an Acting Director is as follows:<br>\
	The role is to be offered to the Head of Personnel, if one is present.  If there is no Head of Personnel, or they are unwilling to assume Acting Director, the \
	position is offered to non-Security Command crew.  If no other Command crew is available or willing to assume Acting Director, the Head of Security may be offered \
	the position.  If no other Command crew is available or willing to assume Acting Director, no Acting Director is selected.  Acting Command may not be offered or accept \
	Acting Director.\
	<br>\
	<h3>Command Crew Demotions</h3>\
	If a member of the Command crew is suspected to be incompetent, or in breach of SOP, the Station Director has discretion to demote the guilty Command crewmember.  \
	If there is no Station Director, or the Station Director themselves is guilty, they may be demoted after a vote of no confidence by the remaining Command crew \
	and relevant station crew.  For the Station Director, the vote is only to be among the remaining Command crew.  Misuse of this privilage may warrant an \
	Internal Affairs investigation for wrongful dismissal.\
	<br>\
	<h3>Communications with Central Command</h3>\
	The individuals hired to fill Command roles are expected to be competent in their roles and duties, and contacting Central Command when it is not strictly \
	necessary may reflect poorly upon them.  As such, Command crew should try to find and act upon a solution that does not require Central Command input, before \
	any messages are sent.  However, please do not be discouraged from sending proper IA reports, incident notifications, and other necessary paperwork as detailed \
	in this book.\
	<br>\
	<h3>Internal Affairs</h3>\
	Internal Affairs Agents are on station at the behest of Human Resources.  They are not subordinate to the Command crew, but neither is anyone subordinate to them.  \
	Internal Affairs Agents are to work with the Command crew when possible.  An agent is to not go above the authority of the Command crew unless said Command crew \
	member is involved, or otherwise unable to assist in the matter.  Any member of the crew can be subject to an Internal Affairs investigation.  This includes \
	the Command crew and other Internal Affairs agents.  If the Internal Affairs investigation reveals wrongdoing, including SOP breach, the investigated party is to \
	be punished according to Corporate Regulations or Sif Law, whichever is applicable, or from orders from Central Command."

/datum/lore/codex/page/engineering_sop
	name = "Engineering SOP"
	data = "This SOP is specific to those in the Engineering department, and focuses on engine safety, breach response, atmospherics, and such.  \
	<br>\
	<h3>Engine Safety</h3>\
	Your facility's engine is what provides the majority of electricity to the rest of your facility.  As such, the engine is to have priority over \
	all other engineering issues, including breaches, if an issue with the engine exists.  This book assumes your facility is using one or more thermoelectric engines \
	(generally referred to as TEGs), driven by a Supermatter crystal.  If this is not the case, please consult the documentation for your specific engine for safety precauctions.\
	<br>\
	The Supermatter crystal is what presents the most danger to a crewmember.  The Supermatter is to remain isolated inside the engine room, inside \
	its own chamber, for several reasons.  First, Supermatter reacts poorly to oxygen, harming the crystal and causing heat.  Second, <b>the crystal \
	will vaporize most matter it comes into contact with, which includes crewmembers.  Never touch the Supermatter.</b>  Third, having an isolated chamber \
	is needed in order to drive the TEGs.  Under no circumstances is the Supermatter to be moved outside the chamber, unless for Ejection Procedure.\
	<br>\
	Safety gear must be worn while inside the engine room at all times.  This safety gear includes a full Radiation Suit, as well as Meson \
	Goggles.  If a Radiation Suit cannot be worn, due to an emergency, the engineering voidsuit provides some shielding from the radiation, \
	however it is inferior to the regular suit, and medical attention is advised after leaving the engine room.\
	<br>\
	The engine room contains a powerful industrial laser, generally called an Emitter.  <b>Never stand in front of an Emitter, even if it is inactive.</b> \
	The Emitter is used to 'charge' the Supermatter, so that it releases heat in a controlled manner.  An excessive amount of Emitter blasts can cause \
	engine instability.  As such, the Emitter should never be left unattended if it is active.\
	<br>\
	The engine monitoring room contains various consoles to adjust and monitor the engine and facility systems.  Due to the risk that untrained persons can \
	present to themselves and others, Non-Engineering crew should not enter the engine room, or the engine monitoring room, without good cause.\
	<br>\
	<h3>Atmospherics</h3>\
	Atmospherics in this context refers to both the systems used to maintain air onboard your facility, as well as the centralized room which contains those \
	systems.  Atmospherics should never be modified by untrained personnel, as this can put the entire facility at risk.  As such, non-Engineering crew are \
	not permitted inside Atmospherics without permission, as well as supervision from a member of Engineering.\
	<br>\
	The distribution loop (generally referred to as Distro) is a pipeline distinguished by a dark blue color which connects Atmospherics with the rest of the \
	facility, with the ventilation system.  The pressure of Distro should be tightly regulated, and should not contain excessive amounts of gas.  The air vents \
	will try to prevent 'over-filling' a room, however this system is not perfect, and extremely high Distro pressures can cause a safety hazard.\
	<br>\
	<h3>Breach Response</h3>\
	If a room becomes breached, the first priority is to evacuate any crewmembers and guests endangered by the breach, especially if they lack an EVA \
	suit.  Emergency softsuits are available in cyan colored lockers at key locations on your facility, if an untrained person requires short term EVA \
	capability.  After all endangered crewmembers and guests are evacuated, repairs should be prioritized.  Do not risk your life in order to start repairs,  \
	Only begin repairs once it is safe to do so.  It is more important to have an area be usable, than it is to have it look exactly the way it did before it \
	was damaged.  As such, cosmetic details should be done last.  Breach repairs always have priority over construction projects.\
	<br>\
	<h3>Delamination</h3>\
	The Supermatter is volatile, and can undergo the process of 'delamination' if sufficently damaged.  To help warn against this, all Supermatter crystals \
	come with a small monitoring microcontroller, which will warn the Engineering department if the Supermatter is being damaged.  Damage can result from \
	excessive heat, vacuum exposure, or physical impacts.  If the Supermatter achieves delamination, it will cause a massive explosion, deliver a \
	massive dose of radiation to everyone in or near your facility, and may cause hallucinations.  Delamination prevention should be prioritized above \
	all else.  Generally this should be done by removing the source of damage, the most common being excessive heat inside the isolation chamber.  \
	The crew must be informed of a risk of engine delamination if the issue cannot be resolved quickly or if there is a moderate risk of delamination.  If \
	delamination cannot be prevented, please see Ejection Procedure.\
	<br>\
	<h3>Ejection Procedure</h3>\
	The Supermatter's isolation chamber contains a mass driver and a heavy blast door leading into space.  Ejecting the Supermatter into the void \
	will cause it to delaminate, however hopefully far away from your facility.  Supermatter crystals are rare and expensive, so this option should \
	only be used if delamination cannot be stopped by any other means.  A special button, behind glass, exists inside the Chief Engineer's office.  \
	<b>The button controls the mass driver, however it should not be the first button to press.  The blast door leading into space must be opened first, \
	or else the Supermatter cannot be ejected.</b>  Premature ejection can cause the Supermatter to not be on the mass driver, which will require an extremely \
	risky manual Supermatter movement to place onto the mass driver again.  The blast door can be opened with a button in the Chief Engineer's office, or inside the engine room.  \
	It is the same button used to 'vent' the engine core.  Make use of engine core cameras to verify that the blast door is open.  \
	The Chief Engineer should be the one to oversee Ejection.  If one does not exist, the facility's AI should initiate Ejection.  If there is no AI, \
	it would be prudent for an Engineering member to forcefully enter to press the required buttons."

/*
/datum/lore/codex/page/medical_sop
	name = "Medical SOP"
	data = "This SOP is specific to those in the Medical department, and focuses on Triage/First Aid priority, Proper Cloning procedure and CMD, how to store a body, and DNC orders.  \
	<br>\
	<h3>Triage / First Aid Priority</h3>\
	The priority for Triage, is generally;\
	<br>\
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
	</ul>\
	<br>\
	<h3>Cloning Procedure</h3>\
	Persons whom have committed suicide are not to be cloned.  Individuals are also to not be cloned if there is a Do Not Clone (generally referred \
	to as DNC) order in their medical records, or if the individual has had a DNC order declared against them by the Station Director, Chief \
	Medical Officer, or Head of Security.  If any of this occurs, procede to Portmortem Storage.\
	<br>\
	Some individuals may have special instructions in their Postmortem Instructions, generally found in their medical records.  \
	Be sure to read them before committing to cloning someone.  In particular, some instructions may express a desire to be placed \
	inside a synthetic body.  If this is the case, contact Robotics.  If robotics is not available, and no instructions for \
	cloning exist in their records, proceed to Postmortem Storage.\
	<br>\
	If no records are included, it is assumed that the patient wishes to be cloned, and should be cloned.\
	<br>\
	Ensure that all cloning equipment, including the cryogenic tubes, are functional and ready before cloning begins.  Once \
	this is done, scan the deceased.  Up to three scans are to be made per attempt.  If the deceased suffers Mental Interface Failure, \
	procede to Postmortem Storage.  Further attempts at resuscitation may be made at later times, at the medical teams' discretion. \
	<br>\
	If the deceased is sufficently scanned, remove their possessions and clothing off of the deceased body, for use by the future new clone.  \
	Move the cadaver into the morgue, as per Postmortem Storage.  Begin the cloning process.  Possessions are to be gathered in a manner that \
	facilitates transporting them along with the clone.  Upon the cloning process being complete and the new clone being created, the \
	clone is to be placed inside a croygenic tube as quickly as possible.  Cloning is not a painless experience, and it is best if \
	the patient reawakens inside a functional body.  Once their body is fully functional, dress and process the newly cloned patient, \
	informing them of any procedures performed on them, including the cloning itself.\
	<br>\
	<h3>Clone Memory Disorder</h3>\
	Clones, persons transferred to MMIs, and recently restarted synthetics will not remember the events which lead to their demise.  \
	They are to be told that they have been resurrected, and any further questions they have should be answered, if possible.  Organic \
	individuals revived by a defibrillator do not experience this phenomenon.\
	<br>\
	<h3>Postmortem Storage</h3>\
	Bodies placed in the morgue should be contained inside black body bags.  The body bag is to be labelled with the deceased's name, along \
	with 'DNC', 'MIF', or 'Cloned' where applicable.  Bodies in the morgue are to be transferred to Central Command whenever possible.  Funerary \
	services are to be handled off site.  A service may be held within the Chapel if it is desired, however the body must still be brought to \
	Central.\
	<h3>Breach Response</h3>\
	If a room becomes breached, the first priority is to evacuate any crewmembers and guests endangered by the breach, especially if they lack an EVA \
	suit.  Emergency softsuits are available in cyan colored lockers at key locations on your facility, if an untrained person requires short term EVA \
	capability.  Those exposed to vacuum without protection will almost certainly require advanced medical care, so bring anyone harmed to Medical.  \
	Remember to avoid risking your own life, as stated in the Triage section."
*/
/datum/lore/codex/page/science_sop
	name = "Research SOP"
	data = "This SOP is specific to those in the Research department, and focuses on Experiment Safety, Toxins Safety, and Robotics.\
	<br>\
	<h3>Experiment Safety</h3>\
	Experiments should remain within the Research department, unless they are entirely safe.  Xenoarchaeological finds should never \
	leave the Research Outpost if they demonstrate any risk of harming crewmembers and visitors (not 'inert').  Live xenobiological specimens should \
	never be brought outside the Xenobio section.  Xenoflora specimens should not be spread outside Xenoflora, unless it is proven that \
	a specific specimen is completely harmless and safe.\
	<br>\
	<h3>Toxins Safety</h3>\
	Toxins potentially has the greatest capability to harm the experimentor as well as their co-workers, so always be vigilent.  \
	The incinerator is designed to withstand phoron fires, however extremely hot fires can cause damage to the incinerator.  \
	The experimentor and anyone inside the Toxins section should wear protective clothing while the incinerator is active, and \
	<b>the incinerator should NEVER be left unattended while in use.</b>  If damage to the walls of the incinerator are observed, \
	the chamber should be vented into space immediately, to abort the burn, then vacating the lab until the flames are extinguished.\
	<br>\
	Another danger of Toxins is that the experimentor will be handling explosives at some point, in order to test on the \
	Toxins Testing Range.  <b>Explosives are to be tested at the Testing Range, and absolutely no where else.</b>  \
	When placing an explosive on the mass driver to fire to the Testing Range, the experimentor should triple check that their \
	explosive's signaler frequency and code is unique (if using a signaler).  <b>Verify that the signaler's frequency and code do not match multiple \
	explosives.</b>  Check for any signs of life near the Testing Range before detonation, and warn the facility that an Toxins Test will be \
	occuring shortly, as otherwise it may scare the crew and may endanger anyone near the Testing Range.\
	<br>\
	<h3>Robotics</h3>\
	Robotics exists to service the facility's synthetics, crewmembers with prosthetics, create and maintain exosuits, and create and \
	maintain robots to assist the facility.  Many types of synthetics exist, and this section will try to clarify what to do for each kind.\
	<br>\
	Cyborgification, the process of an organic person's brain being transplanted into a Man-Machine-Interface (MMI), should only be done to \
	a person upon their death, and if their medical records state a desire to be placed inside a synthetic body instead of a desire to be cloned.  \
	Persons who have commited suicide, or persons who have Do-Not-Clone (DNC) orders which don't specifically list cyborgification as an alternative are \
	not to be placed inside an MMI.  Still-living persons who wish to be placed inside an MMI should be ignored.\
	<br>\
	Lawbound Synthetics are to not have their lawset tampered with.  Any errors with the lawset, intentional or resulting from an ionic storm, should \
	be reset by the Research Director or Chief Engineer.  If they are unavailable, it is permissible for Robotics to do the reset.  Lawbound Synthetics \
	physically harmed should be repaired.\
	<br>\
	<h3>Lawing Synthetics</h3>\
	Different 'types' of brains have different priorities upon receiving one to place inside a chassis.\
	<ul>\
	<li>Those inside MMIs are to not be placed inside a lawed chassis unless they specifically request it.  An MMI that was already a cyborg may be placed in \
	a new lawed chassis, if required.  An MMI that desires to inhabit a chassis capable of wireless control over the facility is required to be lawed.  \
	A Full Body Prosthetic lacks the wireless capabilities, and as such is unlawed.</li>\
	<li>Newly activated positronic brains are to be placed inside a lawed chassis, if they request mobility.  The individual who activated the positronic brain \
	is considered the positronic's guardian, but may choose to transfer guardianship to NanoTrasen at any point.  Positronics whom have passed their \
	Jans-Fhriede test cannot be placed inside a lawed chassis without their consent.</li>\
	<li>Drone circuitry are always to be placed inside a lawed chassis.</li>\
	</ul>\
	<br>\
	<h3>Exosuits & Prosthetics</h3>\
	Exosuits (also known as Mecha, or Mechs) are large machines piloted by an individual.  Construction of exosuits is to occur inside Robotics or the \
	Mech Bay.  Damaged exosuits should be repaired by Robotics.  Civilian Exosuits (Ripley, Odysseus) may be built at the request of departmental crew.  \
	Combat exosuits (Durand, Gygax) may not be built without permission from the Head of Security or Station Director.\
	<br>\
	Robotics is also tasked with the repair of prostheses limbs.  Robotics may also be tasked with installing a prosthetic, however the Medical team \
	may also do this if the Robotics staff lack the training to do so."
*/
/datum/lore/codex/category/alert_levels
	name = "Alert Levels"
	data = "NanoTrasen facilities oftentimes use a color-coded alert system in order to inform the crew of ongoing danger or other threats.  Below is a list of \
	alert levels, as well as how the facility should shift in response to a change in an alert.  You can check what the current level is by looking at a fire alarm. \
	Alert levels can be set by Command staff from a specific console located in the bridge.  For Red alert, two Heads of Staff are required to swipe an ID on a device inside \
	their office in order to trigger it."
	children = list(
		/datum/lore/codex/page/green,
		/datum/lore/codex/page/blue,
		/datum/lore/codex/page/red
		)

/datum/lore/codex/page/green
	name = "Green Alert"
	data = "Green is the default level, and it means that no threat to the facility currently exists.\
	<br>\
	<h3>Locations</h3>\
	Secure areas are recommended to be left unbolted, which includes the AI Upload, Secure Technical Storage, and the Teleporter(s).  The Vault should remain sealed.  \
	Heads of Staff may enter the AI Upload alone, although they must have sufficent justification. \
	<br>\
	<h3>Crew</h3>\
	Crew members and visitors may freely walk in the hallways and other public areas.  Suit sensors are recommended, but not mandatory.  \
	The Security team must respect the privacy of crew members and visitors, and no unauthorized searches are allowed.  Searches of any kind may \
	only be done with the consent of the searched, or with a signed warrant by the Head of Security or Station Director.  A warrant is not required \
	for instances of visible contraband."

/datum/lore/codex/page/blue
	name = "Blue Alert"
	data = "Blue alert is for when there is a suspected or confirmed threat to the facility.\
	<br>\
	<h3>Locations</h3>\
	<br>\
	Secure areas may be bolted down, which includes the AI Upload and Secure Technical Storage.  No Head of Staff is to enter the AI Upload without \
	another Head of Staff.  If no other Heads of Staff are available, at least one member of Security should be present.\
	<br>\
	<h3>Crew</h3>\
	Employees and guests are recommended to comply with all requests from Security.  Suit sensor activation is mandatory, however the coordinate tracker functionality \
	is not required.  Random body and workplace searched are allowed without a warrant.  Command can demand that only Galactic Common is spoken on the radio."

/datum/lore/codex/page/red
	name = "Red Alert"
	data = "Red alert is the highest level, and is reserved for when the facility is under a serious threat.\
	<br>\
	<h3>Locations</h3>\
	Secure areas are recommended to be bolted.  AI Upload policy is the same for Blue alert.\
	<br>\
	<h3>Crew</h3>\
	Suit sensors with tracking beacon active are mandatory.  Employees and guests are required to comply with all requests from Security or Command.  \
	Employees are advised to remain within their departments if it is safe to do so.  An Emergency Response Team may be authorized.  If one is called, \
	all crew and visitors are to comply with their direction.  Privacy policy is the same as Blue alert.  Command can demand that only Galactic Common is spoken on the radio."
