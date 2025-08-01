/*********************MANUALS (BOOKS)***********************/

/obj/item/book/manual
	icon = 'icons/obj/library.dmi'
	due_date = 0 // Game time in 1/10th seconds
	unique = 1   // 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified

/obj/item/book/manual/engineering_particle_accelerator
	name = "Particle Accelerator User's Guide"
	icon_state ="bookParticleAccelerator"
	item_state = "book15"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Particle Accelerator User's Guide"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Experienced User's Guide</h1>

				<h2>Setting up the accelerator</h2>

				<ol>
					<li>"} + span_bold("Wrench") + {" all pieces to the floor</li>
					<li>Add "} + span_bold("wires") + {" to all the pieces</li>
					<li>Close all the panels with your "} + span_bold("screwdriver") + {"</li>
				</ol>

				<h2>Using the accelerator</h2>

				<ol>
					<li>Open the control panel</li>
					<li>Set the speed to 2</li>
					<li>Start firing at the singularity generator</li>
					<li>"} + span_red(span_bold("When the singularity reaches a large enough size so it starts moving on it's own set the speed down to 0, but don't shut it off")) + {"</li>
					<li>Remember to wear a radiation suit when working with this machine... we did tell you that at the start, right?</li>
				</ol>

				</body>
			</html>
			"}


/obj/item/book/manual/supermatter_engine
	name = "Supermatter Engine Operating Manual"
	icon_state = "bookSupermatter"
	item_state = "book15"
	author = "Central Engineering Division"
	title = "Supermatter Engine Operating Manual"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>OPERATING MANUAL FOR MK 1 PROTOTYPE THERMOELECTRIC SUPERMATTER ENGINE 'TOMBOLA'</h1>
				<br>
				<h2>OPERATING PRINCIPLES</h2>
				<br>
				<li>The supermatter crystal serves as the fundamental power source of the engine. Upon being charged, it begins to emit large amounts of heat and radiation, as well and oxygen and phoron gas. As oxygen accelerates the reaction and reacts with phoron to start a fire, it must be filtered out. It's recommended to filter out all gases besides phoron for standard operation. </li>
				<br>
				<li>Gas in the reactor chamber housing the supermatter is circulated through the reactor loop, which passes through the filters and thermoelectric generators. The thermoelectric generators transfer heat from the reactor loop to the colder radiator loop, thereby generating power. Additional power is generated from internal turbines in the circulators.</li>
				<br>
				<li>Gas in the radiator loop is circulated through the radiator bank, located in space. This rapidly cools the air, preserving the temperature differential needed for power generation.</li>
				<br>
				<li>The MK 1 Prototype Thermoelectric Supermatter Engine is designed to operate at reactor temperatures of 3000K to 4000K and generate up to 1MW of power. Beyond 1MW, the thermoelectric generators will begin to lose power through electrical discharge, reducing efficiency, but additional power generation remains feasible.</li>
				<br>
				<li>The crystal structure of the supermatter will begin to liquefy if its temperature exceeds 5000K. This eventually results in a massive release of light, heat and radiation, disintegration of both the supermatter crystal and most of the surrounding area, and as as-of-yet poorly documented psychological effects on all animals within a 2km radius. Appropriate action should be taken to stabilize or eject the supermatter before such occurs.</li>
				<br>
				<h2>SUPERMATTER HANDLING</h2>
				<li>Do not expose supermatter to oxygen.</li>
				<li>Do not allow supermatter to contact any solid object apart from specially-designed supporting pallet.</li>
				<li>Do not directly view supermatter without meson goggles.</li>
				<li>While handles on pallet allow moving the supermatter via pulling, pushing should not be attempted.</li>
				<li>Note that prosthetics do not protect against radiation or viewing the supermatter.</li>
				<br>
				<h2>STANDARD STARTUP PROCEDURE</h2>
				<ol>
				<li>Fill reactor loop and radiator loop with two (2) standard canisters (1871.75 moles, 20 celsius) of phoron gas each.</li>
				<li>Fill the waste handling radiator loop with one (1) standard canister (1871.75 as well) of carbon dioxide gas.</li>
				<li>You can confirm your canisters got enough gas in them by using your PDA's "Gas Scanner" feature, you must enable it and press your PDA against the canister.</li>
				<li>Enable both the high power gas pumps near the thermo-electric generators and maximize the desired output.</li>
				<li>Enable both the omni-filters and ensure they are set to filter phoron back into the system.</li>
				<li>Enable the gas pump from the filters to waste handling and maximize the desired output.</li>
				<li>Close the monitoring room blast doors and open the reactor blast doors,</li>
				<li>Fire 12-16 pulses from emitter at supermatter crystal. The expected power output is around a megawatt. NOTE: It will take a few minutes to heat up.</li>
				<li>You can confirm desired power levels by checking the computer in the minotoring room, "Supermatter Monitoring". You want 300 EPR, more is safe but no higher than 700</li>
				<li>Close the reactor blast doors and keep the monitoring room blast doors closed to prevent radiation leaking.</li>
				</ol>
				<br>
				<h2>OPERATION AND MAINTENANCE</h2>
				<ol>
				<li>Ensure that radiation protection and meson goggles are worn at all times while working in the engine room.</li>
				<li>Ensure that reactor and radiator loops are undamaged and unobstructed.</li>
				<li>Ensure that, in a standard setup, only phoron is being filtered back into the system. Do not allow exhaust pressure to exceed 4500 kPa.</li>
				<li>Ensure that engine room Area Power Controller (APC) and engine Superconducting Magnetic Energy Storage unit (SMES) are properly charged.</li>
				<li>Ensure that reactor temperature does not exceed 5000K. In event of reactor temperature exceeding 5000K, see EMERGENCY COOLING PROCEDURE.</li>
				<li>In event of imminent and/or unavoidable delamination, see EJECTION PROCEDURE.</li>
				</ol>
				<br>
				<h2>EMERGENCY COOLING PROCEDURE</h2>
				<ol>
				<li>Open Emergency Cooling Valve 1 and Emergency Cooling Valve 2.</li>
				<li>When reactor temperature returns to safe operating levels, close Emergency Cooling Valve 1 and Emergency Cooling Valve 2.</li>
				<li>Adding additional gas to the loops can have a positive effect in reducing reactor temperature.</li>
				<li>If reactor temperature does not return to safe operating levels, see EJECTION PROCEDURE.</li>
				</ol>
				<br>
				<h2>EJECTION PROCEDURE</h2>
				<ol>
				<li>Ensure the engine room has power. The blast doors and ejection platform are unresponsive without power.</li>
				<li>Press Engine Ventilatory Control button to open engine core blast door to space.</li>
				<li>Press Emergency Core Eject button to eject supermatter crystal. NOTE: Attempting crystal ejection while engine core vent is closed will result in ejection failure.</li>
				<li>In event of ejection failure, "} + span_italics("pending") + {"</li>
				</ol>
				</body>
			</html>"}

// TESLA Engine

/obj/item/book/manual/tesla_engine
	name = "Tesla Operating Manual"
	icon_state ="bookTesla"
	item_state = "book15"
	author = "Engineering Encyclopedia"
	title = "Tesla Engine User's Guide"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>OPERATING MANUAL FOR MK 2 PROTOTYPE TESLA ENGINE &apos;EDISON&apos;S BANE&apos;</h1>
				<br>
				<h2>OPERATING PRINCIPLES</h2>
				<p>This big floaty ball of pure electricity can only be contained by the containment field. It periodically will discharge energy in the form of an electric shock which can be harvested for energy.</p>
				<p>When you shoot the energy ball with the Particle Accelerator, it gains energy, and when enough energy is accumulated a mini-energy ball that orbits the big energy ball will be formed. This can happen as many times as you let it, each mini-ball will send off an extra shock when the energy ball pulses. Be warned, the more mini-balls the energy ball has, the more shocks it sends out at once and the further it can travel each move.</p>
				<p>An energy ball will shoot bolts of electricity off at conductors, which it prioritizes in this order:
				<ol>
					<li>Tesla coils</li>
					<li>Grounding rods</li>
					<li>People and animals</li>
					<li>Machines</li>
				</ol>
				</p>
				<p>Tesla Coils will attract the energy ball&apos;s bolts. They will take half the power of the bolt (if they are connected to a wire node), pump it into the powernet it is hooked to, and then will send the other half of the power to the next available conductor, which follows the criteria listed above. Preferably, this will be another coil to harness more of the power and pump it into the grid.</p>
				<p>Grounding Rods are safety precautions to prevent the tesla bolts from hitting machinery or personnel. If the tesla is loose, being near one will usually keep you safe from direct shocks.</p>
				<br>
				<h2>STARTUP PROCEDURE</h2>
				<ol>
				<li>Bolt and weld down the Field Generators, ensuring they form a complete rectangle.</li>
				<li>Bolt and weld down the Emitters, ensuring their fire will strike the corner Field Generators</li>
				<li>Bolt down the Tesla Generator inside the rectangle formed by the Field Generators in a spot where it will be struck by fire from the Particle Accelerator</li>
				<li>Bolt down Telsa Coils and Grounding Rods</li>
				<li>Activate the Emitters</li>
				<li>Activate each of the Field Generators, then wait until the containment field has completely formed.</li>
				<li>Setup the Particle Accelerator (see our best seller "} + span_italics("&quot;Particle Accelerator User&apos;s Guide&quot;") + {"!) and activate it.</li>
				<li>After a short time the Telsa Generator will create an energy ball, being consumed in the process.</li>
				</ol>
				<br>
				<h2>OPERATION AND MAINTENANCE</h2>
				<ol>
				<li>Ensure that electrical protection and meson goggles are worn at all times while working in the engine room.</li>
				<li>Ensure that Telsa Coils and/or Grounding Rods are placed to safely collect or ground any and all shock.</li>
				<li>Ensure that all Emitters remain activated and have unobstructed lines of fire to the Field Generators.</li>
				<li>Do "} + span_bold("not") + {" let the Emitters run out of power.</li>
				</ol>
				<br>
				<h2>SHUTDOWN PROCEDURE</h2>
				<ol>
				<li>De-activate the Particle Accelerator.  The energy ball will begin to shrink and lose mini-balls.</li>
				<li>When the energy ball has completely dissipated, the Emitters can be de-activated.</li>
				</ol>
				<br>
				<h2>ENERGY BALL ESCAPE PROCEDURE</h2>
				<ol>
				<li>Do not let it escape.</li>
				<li>Have someone ready to blame when it does escape.</li>
				<li>Buy our forthcoming manual &quot;"} + span_italics("Celebrity Grounding Rod Shelters of the Galaxy") + {"&quot;</li>
				</ol>
				</body>
			</html>"}

//R-UST port
/obj/item/book/manual/rust_engine
	name = "R-UST Operating Manual"
	icon_state = "bookSupermatter"
	item_state = "book15"
	author = "Cindy Crawfish"
	title = "R-UST Operating Manual"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<br><br>
				<ol>
				<li>Put uranium in the portable generator near the gyrotron and turn it to full. This is to provide initial power to the core.</li>
				<li>Enable and max output on the SMES in the engine room. This is to power the gyrotron.</li>
				<li>Go into the control room, interact with the fusion core control console. Turn the field on and raise size to 501. Any bigger and it will start EMPing the doors. Any smaller and the fuel pellets might miss.</li>
				<li>Interact with the gyrotron control computer, set power as high as the SMES can support, usually around 4, and turn it on. This will start increasing the plasma temperature to the point where reactions can occur.</li>
				<li>Go into the engine room and insert a deuterium fuel assembly and a tritium fuel assembly into two of the fuel injectors. You can make deuterium rods in the fuel compressor if you want to play it safe.</li>
				<li>Go back to the control room and turn the fuel injectors on. This will start firing pellets into the field.</li>
				<li>Wait for reactions to start (plasma temperature will spike and fuel amounts will drop). Turn the gyrotron power down until it's keeping up with field instability. This will prevent cumulative instability from the deuterium-tritium reaction fucking up the field. If you're using straight deuterium instability isn't a problem and you can turn the gyrotron off.</li>
				<li>Configure the SMES, turn the PACMAN off before it explodes.</li>
				</ol>
				<br>
				"} + span_bold("NOTES FOR NEWBIES") + {"
				<br>
				Anything touching the field will mess with its stability and eventually cause it to rupture. Rupturing is bad. Use the gyrotron to keep instability down if you're running the engine on unstable fuel.
				<br><br>
				Likewise, no matter how sad the core seems, don't fucking hug it, you'll blow the field out and set the engine room on fire.
				</body>
			</html>"}

/obj/item/book/manual/engineering_singularity_safety
	name = "Singularity Safety in Special Circumstances"
	icon_state ="bookEngineeringSingularitySafety"
	item_state = "book15"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Singularity Safety in Special Circumstances"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>Singularity Safety in Special Circumstances</h1>

				<h2>Power outage</h2>

				A power problem has made the entire station lose power? Could be station-wide wiring problems or illegal power sinks. In any case follow these steps:

				<ol>
					<li>"} + span_bold(span_red("PANIC!")) + {"</li>
					<li>Get your ass over to engineering! "} + span_bold("QUICKLY!!!") + {"</li>
					<li>Get to the "} + span_bold("Area Power Controller") + {" which controls the power to the emitters.</li>
					<li>Swipe it with your "} + span_bold("ID card") + {" - if it doesn't unlock, continue with step 15.</li>
					<li>Open the console and disengage the cover lock.</li>
					<li>Pry open the APC with a "} + span_bold("Crowbar.") + {"</li>
					<li>Take out the empty "} + span_bold("power cell.") + {"</li>
					<li>Put in the new, "} + span_bold("full power cell") + {" - if you don't have one, continue with step 15.</li>
					<li>Quickly put on a "} + span_bold("Radiation suit.") + {"</li>
					<li>Check if the "} + span_bold("singularity field generators") + {" withstood the down-time - if they didn't, continue with step 15.</li>
					<li>Since disaster was averted you now have to ensure it doesn't repeat. If it was a powersink which caused it and if the engineering APC is wired to the same powernet, which the powersink is on, you have to remove the piece of wire which links the APC to the powernet. If it wasn't a powersink which caused it, then skip to step 14.</li>
					<li>Grab your crowbar and pry away the tile closest to the APC.</li>
					<li>Use the wirecutters to cut the wire which is connecting the grid to the terminal. </li>
					<li>Go to the bar and tell the guys how you saved them all. Stop reading this guide here.</li>
					<li>"} + span_bold("GET THE FUCK OUT OF THERE!!!") + {"</li>
				</ol>

				<h2>Shields get damaged</h2>

				<ol>
					<li>"} + span_bold("GET THE FUCK OUT OF THERE!!! FORGET THE WOMEN AND CHILDREN, SAVE YOURSELF!!!") + {"</li>
				</ol>
				</body>
			</html>
			"}


/obj/item/book/manual/hydroponics_pod_people
	name = "The Diona Harvest - From Seed to Market"
	icon_state ="bookHydroponicsPodPeople"
	item_state = "book5"
	author = "Farmer John"
	title = "The Diona Harvest - From Seed to Market"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h3>Growing a Diona</h3>

				Growing a Diona is easy!
				<p>
				<ol>
					<li>Take a syringe of blood from the body you wish to turn into a Diona.</li>
					<li>Inject 5 units of blood into the pack of dionaea-replicant seeds.</li>
					<li>Plant the seeds.</li>
					<li>Tend to the plants water and nutrition levels until it is time to harvest the Diona.</li>
				</ol>
				<p>
				Note that for a successful harvest, the body from which the blood was taken from must be dead BEFORE harvesting the pod, however the pod can be growing while they are still alive. Otherwise, the soul would not be able to migrate to the new Diona body.<br><br>

				It really is that easy! Good luck!

				</body>
				</html>
				"}


/obj/item/book/manual/medical_cloning
	name = "Cloning Techniques of the 24th Century"
	icon_state ="bookCloning"
	item_state = "book9"
	author = "Medical Journal, volume 3"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Cloning Techniques of the 24th Century"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				h3 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<H1>How to Clone People</H1>
				So there are 50 dead people lying on the floor, chairs are spinning like no tomorrow and you haven't the foggiest idea of what to do? Not to worry!
				This guide is intended to teach you how to clone people and how to do it right, in a simple, step-by-step process! If at any point of the guide you have a mental meltdown,
				genetics probably isn't for you and you should get a job-change as soon as possible before you're sued for malpractice.

				<ol>
					<li><a href='#1'>Acquire body</a></li>
					<li><a href='#2'>Strip body</a></li>
					<li><a href='#3'>Put body in cloning machine</a></li>
					<li><a href='#4'>Scan body</a></li>
					<li><a href='#5'>Clone body</a></li>
					<li><a href='#6'>Get clean Structural Enzymes for the body</a></li>
					<li><a href='#7'>Put body in morgue</a></li>
					<li><a href='#8'>Await cloned body</a></li>
					<li><a href='#9'>Cryo and use the clean SE injector</a></li>
					<li><a href='#10'>Give person clothes back</a></li>
					<li><a href='#11'>Send person on their way</a></li>
				</ol>

				<a name='1'><H3>Step 1: Acquire body</H3>
				This is pretty much vital for the process because without a body, you cannot clone it. Usually, bodies will be brought to you, so you do not need to worry so much about this step. If you already have a body, great! Move on to the next step.

				<a name='2'><H3>Step 2: Strip body</H3>
				The cloning machine does not like abiotic items. What this means is you can't clone anyone if they're wearing clothes or holding things, so take all of it off. If it's just one person, it's courteous to put their possessions in the closet.
				If you have about seven people awaiting cloning, just leave the piles where they are, but don't mix them around and for God's sake don't let people in to steal them.

				<a name='3'><h3>Step 3: Put body in cloning machine</h3>
				Grab the body and then put it inside the DNA modifier. If you cannot do this, then you messed up at Step 2. Go back and check you took EVERYTHING off - a commonly missed item is their headset.

				<a name='4'><h3>Step 4: Scan body</h3>
				Go onto the computer and scan the body by pressing 'Scan - &lt;Subject Name Here&gt;.' If you're successful, they will be added to the records (note that this can be done at any time, even with living people,
				so that they can be cloned without a body in the event that they are lying dead on port solars and didn't turn on their suit sensors)!
				If not, and it says "Error: Mental interface failure.", then they have left their bodily confines and are one with the spirits. If this happens, just shout at them to get back in their body,
				click 'Refresh' and try scanning them again. If there's no success, threaten them with gibbing.
				Still no success? Skip over to Step 7 and don't continue after it, as you have an unresponsive body and it cannot be cloned.
				If you got "Error: Unable to locate valid genetic data.", you are trying to clone a monkey - start over.

				<a name='5'><h3>Step 5: Clone body</h3>
				Now that the body has a record, click 'View Records,' click the subject's name, and then click 'Clone' to start the cloning process. Congratulations! You're halfway there.
				Remember not to 'Eject' the cloning pod as this will kill the developing clone and you'll have to start the process again.

				<a name='6'><h3>Step 6: Get clean SEs for body</h3>
				Cloning is a finicky and unreliable process. Whilst it will most certainly bring someone back from the dead, they can have any number of nasty disabilities given to them during the cloning process!
				For this reason, you need to prepare a clean, defect-free Structural Enzyme (SE) injection for when they're done. If you're a competent Geneticist, you will already have one ready on your working computer.
				If, for any reason, you do not, then eject the body from the DNA modifier (NOT THE CLONING POD) and take it next door to the Genetics research room. Put the body in one of those DNA modifiers and then go onto the console.
				Go into View/Edit/Transfer Buffer, find an open slot and click "SE" to save it. Then click 'Injector' to get the SEs in syringe form. Put this in your pocket or something for when the body is done.

				<a name='7'><h3>Step 7: Put body in morgue</h3>
				Now that the cloning process has been initiated and you have some clean Structural Enzymes, you no longer need the body! Drag it to the morgue and tell the Chef over the radio that they have some fresh meat waiting for them in there.
				To put a body in a morgue bed, simply open the tray, grab the body, put it on the open tray, then close the tray again. Use one of the nearby pens to label the bed "CHEF MEAT" in order to avoid confusion.

				<a name='8'><h3>Step 8: Await cloned body</h3>
				Now go back to the lab and wait for your patient to be cloned. It won't be long now, I promise.

				<a name='9'><h3>Step 9: Cryo and clean SE injector on person</h3>
				Has your body been cloned yet? Great! As soon as the guy pops out, grab them and stick them in cryo. Clonexadone and Cryoxadone help rebuild their genetic material. Then grab your clean SE injector and jab it in them. Once you've injected them,
				they now have clean Structural Enzymes and their defects, if any, will disappear in a short while.

				<a name='10'><h3>Step 10: Give person clothes back</h3>
				Obviously the person will be naked after they have been cloned. Provided you weren't an irresponsible little shit, you should have protected their possessions from thieves and should be able to give them back to the patient.
				No matter how cruel you are, it's simply against protocol to force your patients to walk outside naked.

				<a name='11'><h3>Step 11: Send person on their way</h3>
				Give the patient one last check-over - make sure they don't still have any defects and that they have all their possessions. Ask them how they died, if they know, so that you can report any foul play over the radio.
				Once you're done, your patient is ready to go back to work! Chances are they do not have Medbay access, so you should let them out of Genetics and the Medbay main entrance.

				<p>If you've gotten this far, congratulations! You have mastered the art of cloning. Now, the real problem is how to resurrect yourself after that traitor had his way with you for cloning his target.

				</body>
				</html>
				"}


/obj/item/book/manual/ripley_build_and_repair
	name = "APLU \"Ripley\" Construction and Operation Manual"
	icon_state ="book"
	item_state = "book"
	author = "Randall Varn, Einstein Engines Senior Mechanic"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "APLU \"Ripley\" Construction and Operation Manual"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ul.a {list-style-type: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<center>
				<br>
				<span style='font-size: 12px;'>"} + span_bold("Weyland-Yutani - Building Better Worlds") + {"</span>
				<h1>Autonomous Power Loader Unit \"Ripley\"</h1>
				</center>
				<h2>Specifications:</h2>
				<ul class="a">
				<li>"} + span_bold("Class:") + {" Autonomous Power Loader</li>
				<li>"} + span_bold("Scope:") + {" Logistics and Construction</li>
				<li>"} + span_bold("Weight:") + {" 820kg (without operator and with empty cargo compartment)</li>
				<li>"} + span_bold("Height:") + {" 2.5m</li>
				<li>"} + span_bold("Width:") + {" 1.8m</li>
				<li>"} + span_bold("Top speed:") + {" 5km/hour</li>
				<li>"} + span_bold("Operation in vacuum/hostile environment: Possible") + {"
				<li>"} + span_bold("Airtank volume:") + {" 500 liters</li>
				<li>"} + span_bold("Devices:") + {"
					<ul class="a">
					<li>Hydraulic clamp</li>
					<li>High-speed drill</li>
					</ul>
				</li>
				<li>"} + span_bold("Propulsion device:") + {" Powercell-powered electro-hydraulic system</li>
				<li>"} + span_bold("Powercell capacity:") + {" Varies</li>
				</ul>

				<h2>Construction:</h2>
				<ol>
					<li>Connect all exosuit parts to the chassis frame.</li>
					<li>Connect all hydraulic fittings and tighten them up with a wrench.</li>
					<li>Adjust the servohydraulics with a screwdriver.</li>
					<li>Wire the chassis (Cable is not included).</li>
					<li>Use the wirecutters to remove the excess cable if needed.</li>
					<li>Install the central control module (Not included. Use supplied datadisk to create one).</li>
					<li>Secure the mainboard with a screwdriver.</li>
					<li>Install the peripherals control module (Not included. Use supplied datadisk to create one).</li>
					<li>Secure the peripherals control module with a screwdriver.</li>
					<li>Install the internal armor plating (Not included due to corporate regulations. Can be made using 5 metal sheets).</li>
					<li>Secure the internal armor plating with a wrench.</li>
					<li>Weld the internal armor plating to the chassis.</li>
					<li>Install the external reinforced armor plating (Not included due to corporate regulations. Can be made using 5 reinforced metal sheets).</li>
					<li>Secure the external reinforced armor plating with a wrench.</li>
					<li>Weld the external reinforced armor plating to the chassis.</li>
				</ol>

				<h2>Additional Information:</h2>
				<ul>
					<li>The firefighting variation is made in a similar fashion.</li>
					<li>A firesuit must be connected to the firefighter chassis for heat shielding.</li>
					<li>Internal armor is plasteel for additional strength.</li>
					<li>External armor must be installed in 2 parts, totalling 10 sheets.</li>
					<li>Completed mech is more resilient against fire, and is a bit more durable overall.</li>
					<li>The Company is determined to ensure the safety of its <s>investments</s> employees.</li>
				</ul>
				</body>
			</html>
			"}


/obj/item/book/manual/research_and_development
	name = "Research and Development 101"
	icon_state = "rdbook"
	item_state = "book7"
	author = "Dr. L. Ight"
	title = "Research and Development 101"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				h3 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Science For Dummies</h1>
				So you want to further SCIENCE? Good man/woman/thing! However, SCIENCE is a complicated process even though it's quite easy. For the most part, it's a three step process:
				<ol>
					<li>"} + span_bold("Deconstruct") + {" items in the Destructive Analyzer to advance technology or improve the design.</li>
					<li>"} + span_bold("Build") + {" unlocked designs in the Protolathe and Circuit Imprinter.</li>
					<li>"} + span_bold("Repeat") + {"!</li>
				</ol>

				Those are the basic steps to furthering science. What do you do science with, however? Well, you have four major tools: R&D Console, the Destructive Analyzer, the Protolathe, and the Circuit Imprinter.

				<h2>The R&D Console</h2>
				The R&D console is the cornerstone of any research lab. It is the central system from which the Destructive Analyzer, Protolathe, and Circuit Imprinter (your R&D systems) are controlled. More on those systems in their own sections.
				On its own, the R&D console acts as a database for all your technological gains and new devices you discover. So long as the R&D console remains intact, you'll retain all that SCIENCE you've discovered. Protect it though,
				because if it gets damaged, you'll lose your data!
				In addition to this important purpose, the R&D console has a disk menu that lets you transfer data from the database onto disk or from the disk into the database.
				It also has a settings menu that lets you re-sync with nearby R&D devices (if they've become disconnected), lock the console from the unworthy,
				upload the data to all other R&D consoles in the network (all R&D consoles are networked by default), connect/disconnect from the network, and purge all data from the database.<br><br>

				"} + span_bold("NOTE:") + {" The technology list screen, circuit imprinter, and protolathe menus are accessible by non-scientists. This is intended to allow 'public' systems for the plebians to utilize some new devices.

				<h2>Destructive Analyzer</h2>
				This is the source of all technology. Whenever you put a handheld object in it, it analyzes it and determines what sort of technological advancements you can discover from it. If the technology of the object is equal or higher then your current knowledge,
				you can destroy the object to further those sciences.
				Some devices (notably, some devices made from the protolathe and circuit imprinter) aren't 100% reliable when you first discover them. If these devices break down, you can put them into the Destructive Analyzer and improve their reliability rather than further science.
				If their reliability is high enough, it'll also advance their related technologies.

				<h2>Circuit Imprinter</h2>
				This machine, along with the Protolathe, is used to actually produce new devices. The Circuit Imprinter takes glass and various chemicals (depends on the design) to produce new circuit boards to build new machines or computers. It can even be used to print AI modules.

				<h2>Protolathe</h2>
				This machine is an advanced form of the Autolathe that produce non-circuit designs. Unlike the Autolathe, it can use processed metal, glass, solid phoron, silver, gold, and diamonds along with a variety of chemicals to produce devices.
				The downside is that, again, not all devices you make are 100% reliable when you first discover them.

				<h2>Reliability and You</h2>
				As it has been stated, many devices, when they're first discovered, do not have a 100% reliability. Instead,
				the reliability of the device is dependent upon a base reliability value, whatever improvements to the design you've discovered through the Destructive Analyzer,
				and any advancements you've made with the device's source technologies. To be able to improve the reliability of a device, you have to use the device until it breaks beyond repair. Once that happens, you can analyze it in a Destructive Analyzer.
				Once the device reaches a certain minimum reliability, you'll gain technological advancements from it.

				<h2>Building a Better Machine</h2>
				Many machines produced from circuit boards inserted into a machine frames require a variety of parts to construct. These are parts like capacitors, batteries, matter bins, and so forth. As your knowledge of science improves, more advanced versions are unlocked.
				If you use these parts when constructing something, its attributes may be improved.
				For example, if you use an advanced matter bin when constructing an autolathe (rather than a regular one), it'll hold more materials. Experiment around with stock parts of various qualities to see how they affect the end results! Be warned, however:
				Tier 3 and higher stock parts don't have 100% reliability and their low reliability may affect the reliability of the end machine.
				</body>
			</html>
			"}

/obj/item/book/manual/robotics_cyborgs
	name = JOB_CYBORG + "s for Dummies"
	icon_state = "borgbook"
	item_state = "book1"
	author = "XISC"
	title = JOB_CYBORG + "s for Dummies"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Cyborgs for Dummies</h1>

				<h2>Chapters</h2>

				<ol>
					<li><a href="#Equipment">Cyborg Related Equipment</a></li>
					<li><a href="#Modules">Cyborg Modules</a></li>
					<li><a href="#Construction">Cyborg Construction</a></li>
					<li><a href="#Maintenance">Cyborg Maintenance</a></li>
					<li><a href="#Repairs">Cyborg Repairs</a></li>
					<li><a href="#Emergency">In Case of Emergency</a></li>
				</ol>


				<h2><a name="Equipment">Cyborg Related Equipment</h2>

				<h3>Exosuit Fabricator</h3>
				The Exosuit Fabricator is the most important piece of equipment related to cyborgs. It allows the construction of the core cyborg parts. Without these machines, cyborgs cannot be built. It seems that they may also benefit from advanced research techniques.

				<h3>Cyborg Recharging Station</h3>
				This useful piece of equipment will suck power out of the power systems to charge a cyborg's power cell back up to full charge.

				<h3>Robotics Control Console</h3>
				This useful piece of equipment can be used to immobilize or destroy a cyborg. A word of warning: Cyborgs are expensive pieces of equipment, do not destroy them without good reason, or the Company may see to it that it never happens again.


				<h2><a name="Modules">Cyborg Modules</h2>
				When a cyborg is created it picks out of an array of modules to designate its purpose. There are 6 different cyborg modules.

				<h3>Standard Cyborg</h3>
				The standard cyborg module is a multi-purpose cyborg. It is equipped with various modules, allowing it to do basic tasks.<br>A Standard Cyborg comes with:
				<ul>
				  <li>Crowbar</li>
				  <li>Stun Baton</li>
				  <li>Health Analyzer</li>
				  <li>Fire Extinguisher</li>
				</ul>

				<h3>Engineering Cyborg</h3>
				The Engineering cyborg module comes equipped with various engineering-related tools to help with engineering-related tasks.<br>An Engineering Cyborg comes with:
				<ul>
				  <li>A basic set of engineering tools</li>
				  <li>Metal Synthesizer</li>
				  <li>Reinforced Glass Synthesizer</li>
				  <li>An RCD</li>
				  <li>Wire Synthesizer</li>
				  <li>Fire Extinguisher</li>
				  <li>Built-in Optical Meson Scanners</li>
				</ul>

				<h3>Mining Cyborg</h3>
				The Mining Cyborg module comes equipped with the latest in mining equipment. They are efficient at mining due to no need for oxygen, but their power cells limit their time in the mines.<br>A Mining Cyborg comes with:
				<ul>
				  <li>Jackhammer</li>
				  <li>Shovel</li>
				  <li>Mining Satchel</li>
				  <li>Built-in Optical Meson Scanners</li>
				</ul>

				<h3>Security Cyborg</h3>
				The Security Cyborg module is equipped with effective security measures used to apprehend and arrest criminals without harming them a bit.<br>A Security Cyborg comes with:
				<ul>
				  <li>Stun Baton</li>
				  <li>Handcuffs</li>
				  <li>Taser</li>
				</ul>

				<h3>Janitor Cyborg</h3>
				The Janitor Cyborg module is equipped with various cleaning-facilitating devices.<br>A Janitor Cyborg comes with:
				<ul>
				  <li>Mop</li>
				  <li>Hand Bucket</li>
				  <li>Cleaning Spray Synthesizer and Spray Nozzle</li>
				</ul>

				<h3>Service Cyborg</h3>
				The service cyborg module comes ready to serve your human needs. It includes various entertainment and refreshment devices. Occasionally some service cyborgs may have been referred to as "Bros."<br>A Service Cyborg comes with:
				<ul>
				  <li>Shaker</li>
				  <li>Industrial Dropper</li>
				  <li>Platter</li>
				  <li>Beer Synthesizer</li>
				  <li>Zippo Lighter</li>
				  <li>Rapid-Service-Fabricator (Produces various entertainment and refreshment objects)</li>
				  <li>Pen</li>
				</ul>

				<h2><a name="Construction">Cyborg Construction</h2>
				Cyborg construction is a rather easy process, requiring a decent amount of metal and a few other supplies.<br>The required materials to make a cyborg are:
				<ul>
				  <li>Metal</li>
				  <li>Two Flashes</li>
				  <li>One Power Cell (Preferably rated to 15000w)</li>
				  <li>Some electrical wires</li>
				  <li>One Human Brain</li>
				  <li>One Man-Machine Interface</li>
				</ul>
				Once you have acquired the materials, you can start on construction of your cyborg.<br>To construct a cyborg, follow the steps below:
				<ol>
				  <li>Start the Exosuit Fabricators constructing all of the cyborg parts</li>
				  <li>While the parts are being constructed, take your human brain, and place it inside the Man-Machine Interface</li>
				  <li>Once you have a Robot Head, place your two flashes inside the eye sockets</li>
				  <li>Once you have your Robot Chest, wire the Robot chest, then insert the power cell</li>
				  <li>Attach all of the Robot parts to the Robot frame</li>
				  <li>Insert the Man-Machine Interface (With the Brain inside) into the Robot Body</li>
				  <li>Congratulations! You have a new cyborg!</li>
				</ol>

				<h2><a name="Maintenance">Cyborg Maintenance</h2>
				Occasionally Cyborgs may require maintenance of a couple types, this could include replacing a power cell with a charged one, or possibly maintaining the cyborg's internal wiring.

				<h3>Replacing a Power Cell</h3>
				Replacing a Power cell is a common type of maintenance for cyborgs. It usually involves replacing the cell with a fully charged one, or upgrading the cell with a larger capacity cell.<br>The steps to replace a cell are as follows:
				<ol>
				  <li>Unlock the Cyborg's Interface by swiping your ID on it</li>
				  <li>Open the Cyborg's outer panel using a crowbar</li>
				  <li>Remove the old power cell</li>
				  <li>Insert the new power cell</li>
				  <li>Close the Cyborg's outer panel using a crowbar</li>
				  <li>Lock the Cyborg's Interface by swiping your ID on it, this will prevent non-qualified personnel from attempting to remove the power cell</li>
				</ol>

				<h3>Exposing the Internal Wiring</h3>
				Exposing the internal wiring of a cyborg is fairly easy to do, and is mainly used for cyborg repairs.<br>You can easily expose the internal wiring by following the steps below:
				<ol>
					<li>Follow Steps 1 - 3 of "Replacing a Cyborg's Power Cell"</li>
					<li>Open the cyborg's internal wiring panel by using a screwdriver to unsecure the panel</li>
				</ol>
				To re-seal the cyborg's internal wiring:
				<ol>
					<li>Use a screwdriver to secure the cyborg's internal panel</li>
					<li>Follow steps 4 - 6 of "Replacing a Cyborg's Power Cell" to close up the cyborg</li>
				</ol>

				<h2><a name="Repairs">Cyborg Repairs</h2>
				Occasionally a Cyborg may become damaged. This could be in the form of impact damage from a heavy or fast-travelling object, or it could be heat damage from high temperatures, or even lasers or Electromagnetic Pulses (EMPs).

				<h3>Dents</h3>
				If a cyborg becomes damaged due to impact from heavy or fast-moving objects, it will become dented. Sure, a dent may not seem like much, but it can compromise the structural integrity of the cyborg, possibly causing a critical failure.
				Dents in a cyborg's frame are rather easy to repair, all you need is to apply a welding tool to the dented area, and the high-tech cyborg frame will repair the dent under the heat of the welder.

				<h3>Excessive Heat Damage</h3>
				If a cyborg becomes damaged due to excessive heat, it is likely that the internal wires will have been damaged. You must replace those wires to ensure that the cyborg remains functioning properly.<br>To replace the internal wiring follow the steps below:
				<ol>
					<li>Unlock the Cyborg's Interface by swiping your ID</li>
					<li>Open the Cyborg's External Panel using a crowbar</li>
					<li>Remove the Cyborg's Power Cell</li>
					<li>Using a screwdriver, expose the internal wiring of the Cyborg</li>
					<li>Replace the damaged wires inside the cyborg</li>
					<li>Secure the internal wiring cover using a screwdriver</li>
					<li>Insert the Cyborg's Power Cell</li>
					<li>Close the Cyborg's External Panel using a crowbar</li>
					<li>Lock the Cyborg's Interface by swiping your ID</li>
				</ol>
				These repair tasks may seem difficult, but are essential to keep your cyborgs running at peak efficiency.

				<h2><a name="Emergency">In Case of Emergency</h2>
				In case of emergency, there are a few steps you can take.

				<h3>"Rogue" Cyborgs</h3>
				If the cyborgs seem to become "rogue", they may have non-standard laws. In this case, use extreme caution.
				To repair the situation, follow these steps:
				<ol>
					<li>Locate the nearest robotics console</li>
					<li>Determine which cyborgs are "Rogue"</li>
					<li>Press the lockdown button to immobilize the cyborg</li>
					<li>Locate the cyborg</li>
					<li>Expose the cyborg's internal wiring</li>
					<li>Check to make sure the LawSync and AI Sync lights are lit</li>
					<li>If they are not lit, pulse the LawSync wire using a multitool to enable the cyborg's LawSync</li>
					<li>Proceed to a cyborg upload console. The Company usually places these in the same location as AI upload consoles.</li>
					<li>Use a "Reset" upload moduleto reset the cyborg's laws</li>
					<li>Proceed to a Robotics Control console</li>
					<li>Remove the lockdown on the cyborg</li>
				</ol>

				<h3>As a last resort</h3>
				If all else fails in a case of cyborg-related emergency, there may be only one option. Using a Robotics Control console, you may have to remotely detonate the cyborg.
				<h3>WARNING:</h3> Do not detonate a borg without an explicit reason for doing so. Cyborgs are expensive pieces of company equipment, and you may be punished for detonating them without reason.

				</body>
			</html>
		"}

/obj/item/book/manual/chef_recipes
	name = JOB_CHEF + " Recipes"
	icon_state = "cooked_book"
	item_state = "book16"
	author = "Victoria Ponsonby"
	title = JOB_CHEF + " Recipes"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Food for Dummies</h1>
				Here is a guide on basic food recipes and also how to not poison your customers accidentally.

				<h3>Basics:</h3>
				Knead an egg and some flour to make dough. Bake that to make a bun or flatten and cut it.

				<h3>Burger:</h3>
				Put a bun and some meat into the microwave and turn it on. Then wait.

				<h3>Bread:</h3>
				Put some dough and an egg into the microwave and then wait.

				<h3>Waffles:</h3>
				Add two lumps of dough and 10 units of sugar to the microwave and then wait.

				<h3>Popcorn:</h3>
				Add 1 corn to the microwave and wait.

				<h3>Meat Steak:</h3>
				Put a slice of meat, 1 unit of salt, and 1 unit of pepper into the microwave and wait.

				<h3>Meat Pie:</h3>
				Put a flattened piece of dough and some meat into the microwave and wait.

				<h3>Boiled Spaghetti:</h3>
				Put the spaghetti (processed flour) and 5 units of water into the microwave and wait.

				<h3>Donuts:</h3>
				Add some dough and 5 units of sugar to the microwave and wait.

				<h3>Fries:</h3>
				Add one potato to the processor, then bake them in the microwave.


				</body>
			</html>
			"}


/obj/item/book/manual/barman_recipes
	name = "Barman Recipes"
	desc = "For the enterprising drink server."
	icon_state = "barbook"
	item_state = "book14"
	author = "Sir John Rose"
	title = "Barman Recipes"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Drinks for Dummies</h1>
				Here's a guide for some basic drinks.

				<h3>Black Russian:</h3>
				Mix vodka and Kahlua into a glass.

				<h3>Cafe Latte:</h3>
				Mix milk and coffee into a glass.

				<h3>Classic Martini:</h3>
				Mix vermouth and gin into a glass.

				<h3>Gin Tonic:</h3>
				Mix gin and tonic into a glass.

				<h3>Grog:</h3>
				Mix rum and water into a glass.

				<h3>Irish Cream:</h3>
				Mix cream and whiskey into a glass.

				<h3>The Manly Dorf:</h3>
				Mix ale and beer into a glass.

				<h3>Mead:</h3>
				Mix enzyme, water, and sugar into a glass.

				<h3>Screwdriver:</h3>
				Mix vodka and orange juice into a glass.

				</body>
			</html>
			"}


/obj/item/book/manual/detective
	name = "The Film Noir: Proper Procedures for Investigations"
	icon_state ="bookDetective"
	item_state = "book8"
	author = "The Company"
	title = "The Film Noir: Proper Procedures for Investigations"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>Detective Work</h1>

				Between your bouts of self-narration and drinking whiskey on the rocks, you might get a case or two to solve.<br>
				To have the best chance to solve your case, follow these directions:
				<p>
				<ol>
					<li>Go to the crime scene. </li>
					<li>Take your scanner and scan EVERYTHING (Yes, the doors, the tables, even the dog). </li>
					<li>Once you are reasonably certain you have every scrap of evidence you can use, find all possible entry points and scan them, too. </li>
					<li>Return to your office. </li>
					<li>Using your forensic scanning computer, scan your scanner to upload all of your evidence into the database.</li>
					<li>Browse through the resulting dossiers, looking for the one that either has the most complete set of prints, or the most suspicious items handled. </li>
					<li>If you have 80% or more of the print (The print is displayed), go to step 10, otherwise continue to step 8.</li>
					<li>Look for clues from the suit fibres you found on your perpetrator, and go about looking for more evidence with this new information, scanning as you go. </li>
					<li>Try to get a fingerprint card of your perpetrator, as if used in the computer, the prints will be completed on their dossier.</li>
					<li>Assuming you have enough of a print to see it, grab the biggest complete piece of the print and search the security records for it. </li>
					<li>Since you now have both your dossier and the name of the person, print both out as evidence and get security to nab your baddie.</li>
					<li>Give yourself a pat on the back and a bottle of the ship's finest vodka, you did it!</li>
				</ol>
				<p>
				It really is that easy! Good luck!

				</body>
			</html>"}

/obj/item/book/manual/nuclear
	name = "Fission Mailed: Nuclear Sabotage 101"
	icon_state ="bookNuclear"
	item_state = "book8"
	author = "Stealth Assault Enterprises"
	title = "Fission Mailed: Nuclear Sabotage 101"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>Nuclear Explosives 101</h1>
				Hello and thank you for choosing Stealth Assault Enterprises for your nuclear information needs. Today's crash course will deal with the operation of a Nuclear Fission Device.<br><br>

				First and foremost, DO NOT TOUCH ANYTHING UNTIL THE BOMB IS IN PLACE. Pressing any button on the compacted bomb will cause it to extend and bolt itself into place. If this is done, to unbolt it, one must completely log in, which at this time may not be possible.<br>

				<h2>To make the nuclear device functional</h2>
				<ul>
					<li>Place the nuclear device in the designated detonation zone.</li>
					<li>Extend and anchor the nuclear device from its interface.</li>
					<li>Insert the nuclear authorisation disk into the slot.</li>
					<li>Type the numeric authorisation code into the keypad. This should have been provided.<br>
					"} + span_bold("Note") + {": If you make a mistake, press R to reset the device.
					<li>Press the E button to log on to the device.</li>
				</ul><br>

				You now have activated the device. To deactivate the buttons at anytime, for example when you've already prepped the bomb for detonation, remove the authentication disk OR press R on the keypad.<br><br>
				Now the bomb CAN ONLY be detonated using the timer. Manual detonation is not an option. Toggle off the SAFETY.<br>
				"} + span_bold("Note") + {": You wouldn't believe how many SAARE Operatives with doctorates have forgotten this step.<br><br>

				So use the - - and + + to set a detonation time between 5 seconds and 10 minutes. Then press the timer toggle button to start the countdown. Now remove the authentication disk so that the buttons deactivate.<br>
				"} + span_bold("Note") + {": THE BOMB IS STILL SET AND WILL DETONATE<br><br>

				Now before you remove the disk, if you need to move the bomb, you can toggle off the anchor, move it, and re-anchor.<br><br>

				Remember the order:<br>
				"} + span_bold("Disk, Code, Safety, Timer, Disk, RUN!") + {"<br><br>
				Intelligence Analysts believe that normal corporate procedure is for the Site Manager to secure the nuclear authentication disk.<br><br>

				Good luck!
				</body>
			</html>
			"}

/obj/item/book/manual/atmospipes
	name = "Pipes and You: Getting To Know Your Scary Tools"
	icon_state = "pipingbook"
	item_state = "book3"
	author = "Maria Crash, Senior Atmospherics Technician"
	title = "Pipes and You: Getting To Know Your Scary Tools"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Contents">Contents</a></h1>
				<ol>
					<li><a href="#Foreword">Author's Foreword</a></li>
					<li><a href="#Basic">Basic Piping</a></li>
					<li><a href="#Insulated">Insulated Pipes</a></li>
					<li><a href="#Devices">Atmospherics Devices</a></li>
					<li><a href="#HES">Heat Exchange Systems</a></li>
					<li><a href="#Final">Final Checks</a></li>
				</ol><br>

				<h1><a name="Foreword">"} + span_underline(span_bold("HOW TO NOT SUCK QUITE SO HARD AT ATMOSPHERICS")) + {"</a></h1><BR>
				"} + span_italics("Or: What the fuck does a \"pressure regulator\" do?") + {"<BR><BR>

				Alright. It has come to my attention that a variety of people are unsure of what a "pipe" is and what it does.
				Apparently, there is an unnatural fear of these arcane devices and their "gases." Spooky, spooky. So,
				this will tell you what every device constructable by an ordinary pipe dispenser within atmospherics actually does.
				You are not going to learn what to do with them to be the super best person ever, or how to play guitar with passive gates,
				or something like that. Just what stuff does.<BR><BR>


				<h1><a name="Basic">"} + span_bold("Basic Pipes") + {"</a></h1>
				"} + span_italics("The boring ones.") + {"<BR>
				Most ordinary pipes are pretty straightforward. They hold gas. If gas is moving in a direction for some reason, gas will flow in that direction.
				That's about it. Even so, here's all of your wonderful pipe options.<BR>

				<ul>
				<li>"} + span_bold("Straight pipes:") + {" They're pipes. One-meter sections. Straight line. Pretty simple. Just about every pipe and device is based around this
				standard one-meter size, so most things will take up as much space as one of these.</li>
				<li>"} + span_bold("Bent pipes:") + {" Pipes with a 90 degree bend at the half-meter mark. My goodness.</li>
				<li>"} + span_bold("Pipe manifolds:") + {" Pipes that are essentially a "T" shape, allowing you to connect three things at one point.</li>
				<li>"} + span_bold("4-way manifold:") + {" A four-way junction.</li>
				<li>"} + span_bold("Pipe cap:") + {" Caps off the end of a pipe. Open ends don't actually vent air, because of the way the pipes are assembled, so, uh, use them to decorate your house or something.</li>
				<li>"} + span_bold("Manual valve:") + {" A valve that will block off airflow when turned. Can't be used by the AI or cyborgs, because they don't have hands.</li>
				<li>"} + span_bold("Manual T-valve:") + {" Like a manual valve, but at the center of a manifold instead of a straight pipe.</li><BR><BR>
				</ul>

				An important note here is that pipes are now done in three distinct lines - general, supply, and scrubber. You can move gases between these with a universal adapter. Use the correct position for the correct location.
				Connecting scrubbers to a supply position pipe makes you an idiot who gives everyone a difficult job. Insulated and HE pipes don't go through these positions.

				<h1><a name="Insulated">"} + span_bold("Insulated Pipes") + {"</a></h1>
				<li>"} + span_italics("Bent pipes:") + {" Pipes with a 90 degree bend at the half-meter mark. My goodness.</li>
				<li>"} + span_italics("Pipe manifolds:") + {" Pipes that are essentially a "T" shape, allowing you to connect three things at one point.</li>
				<li>"} + span_italics("4-way manifold:") + {" A four-way junction.</li>
				<li>"} + span_italics("Pipe cap:") + {" Caps off the end of a pipe. Open ends don't actually vent air, because of the way the pipes are assembled, so, uh. Use them to decorate your house or something.</li>
				<li>"} + span_italics("Manual Valve:") + {" A valve that will block off airflow when turned. Can't be used by the AI or cyborgs, because they don't have hands.</li>
				<li>"} + span_italics("Manual T-Valve:") + {" Like a manual valve, but at the center of a manifold instead of a straight pipe.</li><BR><BR>

				<h1><a name="Insulated">"} + span_bold("Insulated Pipes") + {"</a></h1><BR>
				"} + span_italics("Special Public Service Announcement.") + {"<BR>
				Our regular pipes are already insulated. These are completely worthless. Punch anyone who uses them.<BR><BR>

				<h1><a name="Devices">"} + span_bold("Devices: ") + {"</a></h1>
				"} + span_italics("They actually do something.") + {"<BR>
				This is usually where people get frightened, afraid, and start calling on their gods and/or cowering in fear. Yes, I can see you doing that right now.
				Stop it. It's unbecoming. Most of these are fairly straightforward.<BR>

				<ul>
				<li>"} + span_bold("Gas pump:") + {" Take a wild guess. It moves gas in the direction it's pointing (marked by the red line on one end). It moves it based on pressure, the maximum output being 15000 kPa (kilopascals).
				Ordinary atmospheric pressure, for comparison, is 101.3 kPa, and the minimum pressure of room-temperature pure oxygen needed to not suffocate in a matter of minutes is 16 kPa
				(though 18 kPa is preferred when using internals with pure oxygen, for various reasons). A high-powered variant will move gas more quickly at the expense of consuming more power. Do not turn the distribution loop up to 15000 kPa.
				You will make engiborgs cry and the Chief Engineer will beat you.</li>
				<li>"} + span_bold("Pressure regulator:") + {" These replaced the old passive gates. You can choose to regulate pressure by input or output, and regulate flow rate. Regulating by input means that when input pressure is above the limit, gas will flow.
				Regulating by output means that when pressure is below the limit, gas will flow. Flow rate can be controlled.</li>
				<li>"} + span_bold("Unary vent:") + {" The basic vent used in rooms. It pumps gas into the room, but can't suck it back out. Controlled by the room's air alarm system.</li>
				<li>"} + span_bold("Scrubber:") + {" The other half of room equipment. Filters air, and can suck it in entirely in what's called a "panic siphon." Activating a panic siphon without very good reason will kill someone. Don't do it.</li>
				<li>"} + span_bold("Meter:") + {" A little box with some gauges and numbers. Fasten it to any pipe or manifold and it'll read you the pressure in it. Very useful.</li>
				<li>"} + span_bold("Gas mixer:") + {" Two sides are input, one side is output. Mixes the gases pumped into it at the ratio defined. The side perpendicular to the other two is "node 2," for reference, on non-mirrored mixers..
				Output is controlled by flow rate. There is also an "omni" variant that allows you to set input and output sections freely..</li>
				<li>"} + span_bold("Gas filter:") + {" Essentially the opposite of a gas mixer. One side is input. The other two sides are output. One gas type will be filtered into the perpendicular output pipe,
				the rest will continue out the other side. Can also output from 0-4500 kPa. The "omni" vairant allows you to set input and output sections freely.</li>
				</ul>

				<h1><a name="HES">"} + span_bold("Heat Exchange Systems") + {"</a></h1>
				"} + span_italics("Will not set you on fire.") + {"<BR>
				These systems are used to only transfer heat between two pipes. They will not move gases or any other element, but will equalize the temperature (eventually). Note that because of how gases work (remember: pv=nRt),
				a higher temperature will raise pressure, and a lower one will lower temperature.<BR>

				<li>"} + span_italics("Pipe:") + {" This is a pipe that will exchange heat with the surrounding atmosphere. Place in fire for superheating. Place in space for supercooling.</li>
				<li>"} + span_italics("Bent pipe:") + {" Take a wild guess.</li>
				<li>"} + span_italics("Junction:") + {" The point where you connect your normal pipes to heat exchange pipes. Not necessary for heat exchangers, but necessary for H/E pipes/bent pipes.</li>
				<li>"} + span_italics("Heat exchanger:") + {" These funky-looking bits attach to an open pipe end. Put another heat exchanger directly across from it, and you can transfer heat across two pipes without having to have the gases touch.
				This normally shouldn't exchange with the ambient air, despite being totally exposed. Just don't ask questions.</li><BR>

				That's about it for pipes. Go forth, armed with this knowledge, and try not to break, burn down, or kill anything. Please.


				</body>
			</html>
			"}

/obj/item/book/manual/evaguide
	name = "EVA Gear and You: Not Spending All Day Inside, 2nd Edition"
	icon_state = "evabook"
	item_state = "book14"
	author = "Maria Crash, Senior Atmospherics Technician"
	title = "EVA Gear and You: Not Spending All Day Inside, 2nd Edition"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Foreword">EVA Gear and You: Not Spending All Day Inside, 2nd Edition</a></h1>
				"} + span_italics("Or: How not to suffocate because there's a hole in your shoes") + {"<BR>

				<h2><a name="Contents">Contents</a></h2>
				<ol>
					<li><a href="#Foreword">A foreword on using EVA gear</a></li>
					<li><a href="#Softsuits">Use of Softsuits</a></li>
					<li><a href="#Voidsuits">Putting on a Voidsuit</a></li>
					<li><a href="#Hardsuits">Operation of Hardsuits</a></li>
					<li><a href="#Equipment">Cyclers and Other Modification Equipment</a></li>
					<li><a href="#Advice">Miscellaneous Advice</a></li>
					<li><a href="#Final">Final Checks</a></li>
				</ol>
				<br>

				EVA gear. Wonderful to use. It's useful for mining, engineering, and occasionally just surviving, if things are that bad. Most people have EVA training,
				but apparently there are some on a space station who don't. This guide should give you a basic idea of how to use this gear, safely. It's split into three main sections:
				softsuits, voidsuits, and hardsuits. General advice and instructions for modification are present as well.<BR><BR>

				One important point for synthetics and people using full-body prosthetics: You obviously don't need oxygen, but you do run the risk of overheating in vacuum.
				Rather than oxygen, use a suit cooling unit. Many emergency equipment stores don't hold them, unfortunately, but dedicated EVA stores will. Be aware of your heat tolerances.<BR><BR>

				<h2><a name="Softsuits">Softsuits and Emergency Equipment</a></h2>
				"} + span_italics("The bulkiest things this side of Alpha Centauri") + {"<BR>
				These suits are the both grey ones that are stored in EVA and orange emergency suits in emergency lockers. They're the more simple to get on, but are also a lot bulkier, and provide less protection from environmental hazards such as radiation or physical impact.
				As Medical, Engineering, Security, and Mining all have voidsuits of their own, these don't see much use outside of emergencies. In an emergency, knowing how to put one on can save your life.<BR><BR>

				First, take the suit. It should be in three pieces: A top, a bottom, and a helmet. Put the bottom on first, shoes and the like will fit in it. If you have magnetic boots, however,
				put them on on top of the suit's feet. Next, get the top on, as you would a shirt. It can be somewhat awkward putting these pieces on, due to the makeup of the suit,
				but to an extent they will adjust to you. You can then find the snaps and seals around the waist, where the two pieces meet. Fasten these, and double-check their tightness.
				The red indicators around the waist of the lower half will turn green when this is done correctly. Next, put on whatever breathing apparatus you're using, be it a gas mask or a breath mask. Make sure the oxygen tube is fastened into it.
				Put on the helmet now, straightforward, and make sure the tube goes into the small opening specifically for internals. Again, fasten seals around the neck, a small indicator light in the inside of the helmet should go from red to off when all is fastened.
				There is a small slot on the side of the suit where an emergency oxygen tank or extended emergency oxygen tank will fit,
				but it is recommended to have a full-sized tank on your back for EVA.<BR><BR>

				Important note: When using these, especially in emergencies, be aware of your surroundings! These suits can tear or breach more easily than any other type, especially in an environment with broken glass and metal everywhere.
				If your suit is breached, you will be in deep trouble. Pressure issues can inhibit breathing even with internals.<BR><BR>

				These suits tend to be wearable by most species. They're large and flexible. They might be pretty uncomfortable for some, though, so keep that in mind.<BR><BR>

				<h2><a name="Voidsuits">Voidsuits</a></h2>
				"} + span_italics("Heavy, uncomfortable, still the best option.") + {"<BR>
				These suits come in many specialized varieties. The most common are engineering, atmospherics, security, medical, and mining varieties.
				These provide a lot more protection than the standard suits, and depending on the specialization, can offer different protections.
				For example, security suits have armor plating, engineering suits have radiation protection, and atmospherics suits are rated for extremely high temperatures.<BR><BR>

				Similarly to the softsuits, these are split into three parts. Fastening the pant and top are mostly the same as the softsuits, with the exception that these are a bit heavier,
				though not as bulky. The helmet goes on differently, with the air tube feeding into the suit and out a hole near the left shoulder, while the helmet goes on turned ninety degrees counter-clockwise,
				and then is turned to face the front and sealed. There is a small button on the right side of the helmet that activates the helmet light.
				The tanks that fasten onto the side slot are emergency tanks, as well as full-sized oxygen tanks, leaving your back free for a backpack or satchel.<BR><BR>

				These suits generally only fit one species. NanoTrasen's are usually human-fitting by default, but there's equipment that can make modifications to the hardsuits to fit them to other species.<BR><BR>

				Later-model voidsuits can have magboots and helmets installed into the suit and deployed when needed. Check the operator's manual for individual suits to see how the helmets are installed.
				If a helmet is installed, you can skip it while putting the suit on, obviously. When deployed, it will deploy from the back of your neck, covering the head and sealing at the front.<BR><BR>

				<h2><a name="Hardsuits">Hardsuits/Rigs</a></h2>
				"} + span_italics("The fancy stuff.") + {"<BR>
				Proper hardsuits are the most complex sort of EVA equipment available, and blur the line between spacesuits and smaller exosuits. They're sometimes known as 'rigs' or 'powered armor'.
				These are the suits with the widest variety of uses, owing to the wide variety of equipment that can be installed on them. Like voidsuits, they come in different, specialized varieties, each one offering different protections and different equipment.
				Equipment that can be installed includes weapons, power tools, mining equipment, medical equipment, AI assistants, and more.<BR><BR>

				Putting these on is relatively simple. They come as compact packs, worn like a backpack and secured with a harness. Activating them, though, is a more complex process. The suit deploys from the module similarly to helmets deploying from voidsuits.
				After it covers the whole body, the suit can be started. The startup sequence takes some time. The suit will automatically fit itself to your body, sealing each section individually - boots, gloves, pants, torso, and helmet - then connecting them.<BR><BR>

				Operating a hardsuit is a much more complicated proposal than operating other EVA equipment. While putting them on is relatively simple, and operating basic functions like oxygen and magboots is the same as other suits, the rest is far more complex.
				Consult the operator's manual for invidual pieces of equipment that you plan to use. Use of these for heavy work is only reccomended for people who have specialized training and extensive EVA experience.
				The potential of a suit breach is always there, and the use of powered equipment raises it significantly.<BR><BR>

				<h2><a name="Advice">Miscellaneous Advice</a></h2>
				"} + span_italics("Pro tip: Safety first.") + {"<BR>
				There's a lot of general advice that can be helpful for people who haven't taken a long-form instruction course. Much of this is going to be fairly obvious safety advice, but it's never bad to remind yourself of that.<BR><BR>

				<ul>
					<li>Magboots are important. They can be the difference between keeping your footing and needing a rescue team. A tie-off or a jetpack can substitute if necessary.</li>
					<li>Be aware of breach hazards, especially in softsuits. Loss of suit pressure can be a fatal disaster.</li>
					<li>Keep an eye on your internals. Having to make two trips outside is better than running out of air.</li>
					<li>Similarly, keep an eye on the battery status of cooling units and other equipment.</li>
					<li>In vacuum, sound doesn't carry. Use a radio or sign language for communication.</li><BR><BR>
				</ul>

				<h2><a name="Equipment">Modification Equipment</a></h2>
				"} + span_italics("How to actually make voidsuits fit you.") + {"<BR>
				There's a variety of equipment that can modify hardsuits to fit species that can't fit into them, making life quite a bit easier.<BR><BR>

				The first piece of equipment is a suit cycler. This is a large machine resembling the storage pods that are in place in some places. These are machines that will automatically tailor a suit to certain specifications.
				The largest uses of them are for their cleaning functions and their ability to tailor suits for a species. Do not enter them physically. You will die from any of the functions being activated, and it will hurt the whole time you're dying.
				These machines can both tailor a suit between species, and between types. This means you can convert engineering hardsuits to atmospherics, or the other way. This is useful. Use it if you can.<BR><BR>

				There's also modification kits that let you modify suits yourself. These are extremely difficult to use unless you understand the actual construction of the suit. I do not reccomend using them unless no other option is available.<BR><BR>

				<h2><a name="Final">Final Checks</a></h2>
				<ul>
					<li>Are all seals fastened correctly?</li>
					<li>If you have modified it manually, is absolutely everything sealed perfectly?</li>
					<li>Do you either have shoes on under the suit, or magnetic boots on over it?</li>
					<li>Do you have internals connected and activated?</li>
					<li>Do you have a way to communicate with the station in case something goes wrong?</li>
					<li>Do you have a second person watching if this is a training session?</li><BR>
				</ul>

				If you don't have any further issues, go out and do whatever is necessary.

				</body>
			</html>
			"}

/obj/item/book/manual/virology
	name = "Sneezes and Coughs: A Guide To Virology, 1st Edition"
	icon_state = "bookvirology"
	item_state = "book5"
	author = "James Simpson, Chief " + JOB_ALT_VIROLOGIST
	title = "Sneezes and Coughs: A Guide To Virology, 1st Edition"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				b {font-size: 12px}
				body {font-size: 13px; font-family: Verdana;}
				table {font-family: arial, sans-serif;
						border-collapse: collapse;
						width: 50%;
						font-size: 13px;}
				td, th {border: 1px solid #000000;
						text-align: left;
						padding: 8px;}
				tr:nth-child(even) {background-color: #dddddd;}
				padding {padding-bottom: 50px;}
				</style>
				</head>
				<body>
				<h1>A Guide to Virology, 1st Edition</h1>
				Welcome to virology! <br><br>

				A virologist spends much of their time isolated in the virology department fiddling with deadly and annoying plagues. This guide will get you on the right path to properly<br>
				creating and curing the worst of the worst.<br><br>

				<h2>Anatomy of a Virus</h2>
				Before you jump in to making the next Black Death, you need to understand what's what. When you pop a tray into the disease analyzer you'll get a paper listing quite a few<br>
				things about that virus!<br><br>

				"} + span_bold("Antigens") + {"<br>
				The first thing you might notice on this analysis is the listed antigens of a virus. This, essentially, is what you need for cures. When a patient develops an antibody that<br>
				matches a disease's antigen, they'll be immune to the virus.<br><br>

				"} + span_bold("Transmission") + {"<br>
				This will list one of three methods of transmission: airborne, contact, or blood. Airborne viruses will spread through the air, meaning if a patient is coughing or sneezing<br>
				it will spread quicker. Contactviruses need some sort of, well, contact. Blood on the floor, mucus, and vomit should all be cleaned up. Blood-transmission viruses will only<br>
				spread through actual blood contact, meaning an injection of the virus would be necessary to spread it.<br><br>

				"} + span_bold("Species") + {"<br>
				Not all viruses are compatible with all species! This will list off what can be infected by a particular virus. This can be changed through splicing. In rare cases you will<br>
				get a virus that has infected crewmembers but cannot infect your lab monkeys. In these cases, you will likely have to splice different species data to safely make a cure.<br><br>

				"} + span_bold("Symptoms") + {"<br>
				This lists what all the virus does, along with the strength of the symptoms and their aggressiveness. A full list of symptoms and their stages can be found below.<br><br>

				<h2>Protection</h2>
				First off, any good virologist needs to gear up!<br><br>
				Your virology lab should have the following:
				<ul>
					<li>Two (2) Level-3 Bio Hoods</li>
					<li>Two (2) Level-3 Bio Suits</li>
					<li>Two (2) sets of sealed internals</li>
					<li>One (1) box of sterile masks</li>
					<li>One (1) box of latex gloves</li>
				</ul><br>
				"} + span_bold("Make sure to gear up appropriately and take precautions to not bring the virus out of the lab!") + {"<br><br>
				What needs to be worn varies from race to race, as some species cannot be affected by a virus, but<br>
				precautions should always be taken to prevent accidentally carrying the virus out of containment.<br><br>

				<h2>Machinery</h2>
				These are the types of machines that you will be expected to use in this department. Study them, know them, and make sure you use them correctly!<br><br>

				"} + span_bold("Antibody Scanner") + {"<br>
				A device similar to a health analyzer, when scanned over a patient it will tell you any present antibodies in their bloodstream.<br><br>

				"} + span_bold("Pathogenic Isolator") + {"<br>
				This device can be loaded with blood samples via a syringe. It will tell you if there is a present viral pathogen, and if so it can isolate the pathogen,<br>
				producing a virus dish for further research. This is the primary means of creating virus dishes.<br><br>

				"} + span_bold("Pathogenic Incubator") + {"<br>
				One of the most important machines, you'll be sitting here a lot. Virus trays you produce will start small, and you will need to grow them to get anywhere.<br>
				Load it with virus food (diluted milk, found in a wall mounted dispenser nearby) as well as a virus dish and turn it on. It will slowly grow the virus<br>
				for analysis, splicing, or whatever other use you might find for it. It can also inject the virus into other chemicals (i.e. blood) which will allow you<br>
				to artificially infect a blood sample to infect test subjects.<br><br>

				Additionally, it can irradiate a virus dish to cause mutation. This randomly alters the syndromes, allowing you to collect new data.<br><br>

				"} + span_bold("Disease Analyser") + {"<br>
				Virus dishes may be placed into this machine after it has been incubated sufficiently. It will create a reading of the virus' symptoms, species targeted,<br>
				associated antibodies, and so on. It will also update the disease into the digital database, allowing it to be detected via Medical HUD or health analyzer.<br><br>

				"} + span_bold("Isolation Centrifuge") + {"<br>
				Inserting a vial of blood into this machine will allow it to take a present pathogen or antibody, turning it into a pure virus or pure cure for your use.<br>
				It will automatically detect if either are in the blood sample, so it is useful for determining if a sample is infected. The sample will be reusable if creating<br>
				more of the virus, but will be expended upon creating antibodies.<br><br>

				"} + span_bold("Disease Splicer") + {"<br>
				As it's name implied, this machine is for splicing the disease symptoms and creating new viruses. Insert an analyzed virus sample to take a symptom which can<br>
				then be saved on a GNA disk (created by the machine), or use an existing disk on the machine to load up a symptom and splice it in.<br><br>

				<h2>Syndromes</h2>
				While curing patients is the obvious side to virology, there's more you can do! For a variety of reasons you may wish to engineer your own virus through mutations<br>
				and splicing. Keep in mind that infecting the whole station with a deadly virus is generally frowned upon in most societies, and even in an antagonistic role simply<br>
				infecting everyone with a very deadly virus is not ideal.<br><br>

				"} + span_bold("Obtaining a Sample") + {"<br>
				The first step to making your own virus is to find a virus to start tinkering with. There are two ways of doing this: grabbing the pre-spawned virus dish from the<br>
				freezer create in your laboratory, or taking a blood sample from an infected patient that you haven't cured yet and running it through the Pathogenic Isolator to<br>
				produce a virus dish.<br><br>

				In either case, you'll then need to incubate the virus in the Pathogenic Incubator until it is of sufficient size for you to work with, and ideally also run it<br>
				through the Disease Analyzer to get an idea of what it does. This will also keep the rest of Medical from getting on your case about not giving them the ability to<br>
				detect viral outbreaks without you, and will help prevent public lynchings if someone sneezes.<br><br>

				Once that's all done, you're ready to start the real work.<br><br>

				"} + span_bold("Obtaining a Sample") + {"<br>
				Sometimes you just need to infect somebody. Usually, this is because you're doing some splicing work and want to make sure that you'll have some copies of a virus<br>
				in reserve for future study. Fortunately, the process of deliberately infecting patients, as well as creating backups of your viruses, is actually very simple.<br><br>

				If you have a virus dish and wish to infect a patient, place the dish into the "} + span_bold("Pathogenic Incubator") + {" along with a beaker full of blood. Ideally, this is the<br>
				patient's (or test monkey's) blood, though anyone's will do in a pinch - just be aware of the possibility of blood rejection, and be ready to deal with it accordingly.<br>
				The incubator can inject a sample of the virus into the blood, which you can then inject into the patient to infect them. Alternatively, once a blood sample is infected<br>
				you may place it in either the "} + span_bold("Pathogenic Isolator") + {" or "} + span_bold("Isolation Centrifuge") + {" to make as many samples of that virus you need without destroying the sample.<br>
				No infections necessary!<br><br>

				"} + span_bold("Splicing") + {"<br>
				To understand splicing, you must know that every virus has 4 GNA strands, each of which is tied to one of the syndromes that it can manifest. Each syndrome, and thus each<br>
				strand, is ranked in order of its appearance when symptoms begin to manifest in a patient, and higher-ranked (and thus slower to appear) syndromes are likely to be more<br>
				powerful than lower-ranked ones. (1) is the lowest, first symptom to manifest, and (4) is the highest, final symptom to manifest.<br><br>

				The Disease Splicer will allow you to examine and manipulate a virus' GNA strands to create a virus with any syndromes that you want.<br><br>

				The splicer has main three functions which allow you to modify viruses and define which GNA strands they contain. The first of these functions is the splicing function,<br>
				which copies a GNA strand from an inserted virus tray to the disease splicer buffer. This is done by selecting the desired GNA strand under "Reverse Engineering".<br>
				Doing so will destroy the virus tray in the process, so be sure that you have more samples of the virus on hand if you want to preserve it.<br><br>

				The disease splicer’s second function is to copy whatever strand it has stored in its buffer to a disk the machine creates. These disks can be re-inserted into<br>
				the disease splicer later, making their stored GNA strand immediately available for use. Unlike virus trays, disks can be reused without destroying them.<br><br>

				The final function of the disease splicer is to copy over a GNA strand of its loaded virus dish with the corresponding GNA strand that is currently stored in<br>
				its buffer. This effectively allows you to give a virus any set of symptoms you want, so long as it follows the rules of the ranking. A rank (1) symptom can fill<br>
				any slot, while a (3) can only fill 3 and up, and a (4) can only be in the fourth slot.<br><br>

				"} + span_bold("Mutating") + {"<br>
				Sometimes you just don't have any of the symptoms you want. Fortunately, mutating a virus dish is very simple. Simply place a dish in the "} + span_bold("Pathogenic Incubator") + {"<br>
				to get started and click 'add radiation'. This will fill up the radiation bar with each press. When the machine is on, this bar will slowly tick down as the radiation<br>
				is applied to the sample. For any significant mutation the radiation should be over 500k, meaning at least half the bar. When a mutation occurs -- and multiple<br>
				mutations can occur in a single sample -- there will be a ping from the machine. Once it's done growing and mutating, throw it into the analyzer and see what you got!<br><br>

				With these functions in mind, the process in order for you to develop your own virus is as follows:
				<ol>
					<li>Create lots of virus sample dishes.</li>
					<li>If the virus dishes you have already created don't contain the syndromes that you want in<br>
					your custom virus, irradiate them in the Pathogenic Incubator until they do.</li>
					<li>Create backup dishes of your new viruses.</li>
					<li>Strip the GNA strands that you want from your virus dishes, saving each one onto a disk.</li>
					<li>Load a new virus dish into the Disease Splicer.</li>
					<li>Copy over the virus dish's GNA strands with your disks.</li>
					<li>Once you have your final product, you can use the Pathogenic Incubator to create a beaker<br>
					of blood containing the virus. Congratulations! You are now officially a bioweapon<br>
					manufacturer.</li>
				</ol>

				<h2>Curing</h2>
				Curing a virus is relatively simple, but the below will leave you without a sample to work with. If this is a concern, see 'obtaining a sample' above. Alternatively to<br>
				the below, spacecillin can be used in a pinch to attempt to treat a virus if no virologist is present and someone decided to roll around in mucus. However this is not<br>
				guaranteed to work, and can in fact simply make the virus more resistant to spacecillin.<br><br>

				"} + span_bold("Quarantine") + {"<br>
				If you or a crew member becomes infected by a virus, your first concern should be to isolate them as quickly as possible to prevent the disease from spreading. Ideally,<br>
				this means getting the patient back to Virology and into a holding cell, but failing that, it's important to get them into an isolated room, shut the door, and keep anyone<br>
				else from entering. It is also important to clean up any blood, vomit, or mucus left behind by the patient, as it may spread the virus as well.<br><br>

				"} + span_bold("Antibodies") + {"<br>
				Now that your patient is safely hidden away where they can't infect people without your permission, you want to cure them. The basic idea behind that is to get them to start<br>
				synthesizing antibodies.<br><br>

				Antibodies are produced by living organisms that have started to fight off a virus in their bloodstream. An organism that has produced antibodies is effectively<br>
				immune to any virus that is weak to those antibodies, which are generally denoted by a short string of letters (say, "KM" or similar) to let you know which viruses they<br>
				are effective against. Even better, once an organism has synthesized antibodies for itself, you can take a blood sample and use that to create more antibodies, which you<br>
				can then inject into other people to cure the virus in them, or even to prevent them from catching it in the first place. And you can take blood samples from those people<br>
				to make even more antibodies.<br><br>

				The issue is that, most of the time, a patient's immune system is not powerful enough to create antibodies on its own (space plagues are nasty things), so you have to do that<br>
				for them. You do that by injecting them with Radium.<br><br>

				Since Radium is radioactive, this is obviously not something that you want to do to your actual patients. It'll cause major toxin damage when an antibody is<br>
				made and quickly lead to organ failure. You get around this by using monkeys, which you can get from the box of monkey cubes very handily left on the desk in Virology for<br>
				this very purpose.<br><br>

				So the process of curing diseases is, really, quite simple. Find an infected patient. Make a monkey (ideally, strap this monkey to a bed in an isolation cell to make the<br>
				rest of this process easier). Take a blood sample from the infected patient, then inject it into the monkey to infect the monkey. Inject the monkey with Radium. Use the antibody<br>
				scanner on the monkey every few seconds until it says that the monkey has begun producing antibodies, then take a blood sample (or two or three or four) from the<br>
				monkey. Put the blood sample(s) into a vial, then put the vial into the isolation centrifuge and isolate the antibodies. Voila: a bottle of virus cure. Inject it into as many<br>
				people as you like, then throw the (likely dead) monkey into the disposals chute to eject its disease-ridden body into space and clean the isolation cell. Or, if you're on<br>
				the ball and wish to be conservative with your limited monkey cubes, save the monkey, too.<br><br>

				Congratulations! You have now cured a disease.<br><br>

				The important thing to remember is that anyone injected with antibodies becomes a source of those antibodies for the future. You can take a sample of their blood<br>
				and put it into the isolation centrifuge just like you did with the monkey's to produce more antibodies if you ever run out. For this reason, and because you might have<br>
				gotten infected yourself in the process of synthesizing a cure, most Virologists will inject themselves with any antibodies they produce.<br><br>

				<h2>Syndromes</h2>
				Below are the possible syndromes of a virus and the stages they can appear at. A stage covers that stage and higher, so a stage 1 syndrome can appear at stage 4.<br>
				A stage 4 syndrome, however, cannot appear any earlier than stage 4.<br><br>

				<table>
				<caption> "} + span_bold("Syndromes") + {" </caption>
				<tr>
				<th scope="col"> Stage</th>
				<th scope="col"> Name</th>
				<th scope="col" class="unsortable"> Effects
				</th></tr>
				<tr>
				<td> 1 </td>
				<td> Sneezing </td>
				<td> Makes the patient sneeze. "} + span_bold("Spreads airborne disease!") + {"
				</td></tr>
				<tr>
				<td> 1 </td>
				<td> Mucus Buildup </td>
				<td> Makes the patient's throat fill with mucus.
				</td></tr>
				<tr>
				<td> 1 </td>
				<td> Salivary Gland Stimulation </td>
				<td> Makes the patient drool. "} + span_bold("Spreads the disease!") + {"
				</td></tr>
				<tr>
				<td> 1 </td>
				<td> Involuntary Twitching </td>
				<td> Makes the patient twitch.
				</td></tr>
				<tr>
				<td> 1 </td>
				<td> Headache </td>
				<td> Gives the patient a headache.
				</td></tr>
				<tr>
				<td> 1 </td>
				<td> Mlemington's Syndrome </td>
				<td> Makes the patient 'mlem' uncontrollably.
				</td></tr>
				<tr>
				<td> 1 </td>
				<td> Spyndrome </td>
				<td> Makes the patient spin uncontrollably.
				</td></tr>
				<tr>
				<td> 2 </td>
				<td> Involuntary Vocalization </td>
				<td> Makes the patient scream.
				</td></tr>
				<tr>
				<td> 2 </td>
				<td> Vomiting </td>
				<td> Makes the patient vomit. "} + span_bold("Spreads the disease!") + {"
				</td></tr>
				<tr>
				<td> 2 </td>
				<td> Excessive Sleepiness </td>
				<td> Makes the patient drowsy.
				</td></tr>
				<tr>
				<td> 2 </td>
				<td> Narcolepsy </td>
				<td> Makes the patient pass out at random.
				</td></tr>
				<tr>
				<td> 2 </td>
				<td> Vision Loss </td>
				<td> Causes partial blindness.
				</td></tr>
				<tr>
				<td> 2 </td>
				<td> Severe Cough </td>
				<td> Causes coughing. "} + span_bold("Spreads airborne disease!") + {"
				</td></tr>
				<tr>
				<td> 2 </td>
				<td> Digestive Inefficiency </td>
				<td> Makes the patient always hungry.
				</td></tr>
				<tr>
				<td> 2 </td>
				<td> Reduced Circulation </td>
				<td> Makes the patient shiver.
				</td></tr>
				<tr>
				<td> 2 </td>
				<td> Hair Loss </td>
				<td> Causes the patient's hair to fall out.
				</td></tr>
				<tr>
				<td> 2 </td>
				<td> Overactive Adrenal Gland </td>
				<td> Makes the patient jittery, but also faster.
				</td></tr>
				<tr>
				<td> 2 </td>
				<td> Tinnitus </td>
				<td> Causes ringing in the patient's ears.
				</td></tr>
				<tr>
				<td> 2 </td>
				<td> Lingual Dissocation </td>
				<td> Scrambles the patients language center of their brain.
				</td></tr>
				<tr>
				<td> 3 </td>
				<td> Hyperacidity </td>
				<td> Causes small amounts of toxin damage.
				</td></tr>
				<tr>
				<td> 3 </td>
				<td> Nervous Motor Instability </td>
				<td> Makes the patient shaky.
				</td></tr>
				<tr>
				<td> 3 </td>
				<td> Pineal Gland Decalcification </td>
				<td> Gives the patient telepathy.
				</td></tr>
				<tr>
				<td> 3 </td>
				<td> Neurodegeneration </td>
				<td> Causes brain damage.
				</td></tr>
				<tr>
				<td> 3 </td>
				<td> Hallucination </td>
				<td> Causes hallucinations.
				</td></tr>
				<tr>
				<td> 3 </td>
				<td> Hearing Loss </td>
				<td> A less severe hearing damage.
				</td></tr>
				<tr>
				<td> 3 </td>
				<td> Topographical Cretinism </td>
				<td> Makes the patient incapable of walking straight.
				</td></tr>
				<tr>
				<td> 3 </td>
				<td> Uncontrolled Laughter </td>
				<td> Causes the patient to laugh uncontrollably.
				</td></tr>
				<tr>
				<td> 3 </td>
				<td> DNA Degradation </td>
				<td> Causes genetic damage.
				</td></tr>
				<tr>
				<td> 3 </td>
				<td> Phantom Aches </td>
				<td> Causes groaning.
				</td></tr>
				<tr>
				<td> 3 </td>
				<td> Chemical Synthesis </td>
				<td> Causes the synthesis of a certain chemical in the patient's bloodstream.
				</td></tr>
				<tr>
				<td> 3 </td>
				<td> Genetic Chameleonism </td>
				<td> Prevents the patient from experiencing organ rejection.
				</td></tr>
				<tr>
				<td> 3 </td>
				<td> Mass Revectoring </td>
				<td> Causes the patient to suddenly change size.
				</td></tr>
				<tr>
				<td> 3 </td>
				<td> Flipponov's Disease </td>
				<td> Causes the patient to uncontrollably do a flip.
				</td></tr>
				<tr>
				<td> 4 </td>
				<td> Gibbingtons </td>
				<td> Gibs the patients slowly.
				</td></tr>
				<tr>
				<td> 4 </td>
				<td> Radian's Syndrome </td>
				<td> Irradiates the patient from the inside.
				</td></tr>
				<tr>
				<td> 4 </td>
				<td> Deafness </td>
				<td> Causes complete deafness.
				</td></tr>
				<tr>
				<td> 4 </td>
				<td> Genome Regression </td>
				<td> Turns the patient into the primitive form of their species.
				</td></tr>
				<tr>
				<td> 4 </td>
				<td> Windpipe Contraction </td>
				<td> Causes the patient to involuntarily hold their breath.
				</td></tr>
				<tr>
				<td> 4 </td>
				<td> Autoimmune Response </td>
				<td> Adds toxins to the patient's bloodstream.
				</td></tr>
				<tr>
				<td> 4 </td>
				<td> Catastrophic DNA Degeneration </td>
				<td> Causes genetic damage and scrambles the patient's genes.
				</td></tr>
				<tr>
				<td> 4 </td>
				<td> Limb Paralysis </td>
				<td> Temporary loss of use in the patient's individual arms and legs.
				</td></tr>
				<tr>
				<td> 4 </td>
				<td> Organ Shutdown </td>
				<td> Slowly causes internal organ damage at random.
				</td></tr>
				<tr>
				<td> 4 </td>
				<td> Hyperaccelerated Aging </td>
				<td> Ages the patient, causing external damage.
				</td></tr>
				<tr>
				<td> 4 </td>
				<td> Brittle Bones </td>
				<td> Causes bones to break more easily.
				</td></tr>
				<tr>
				<td> 4 </td>
				<td> Organic Ignition </td>
				<td> Slowly causes the patient to burst into flames.
				</td></tr></table>
				<br>
				</body>
			</html>
				"}


// Chemical Refinery
/obj/item/book/manual/chem_refinery
	name = "Chemical Refinery Basic Operations"
	icon_state ="bookrefinery"
	item_state = "book15"
	author = "Engineering Encyclopedia"
	title = "Chemical Refinery Basic Operations"

	dat = {"<html>
				<head>
					<style>
					h1 {font-size: 18px; margin: 15px 0px 5px;}
					h2 {font-size: 15px; margin: 15px 0px 5px;}
					li {margin: 2px 0px 2px 15px;}
					ul {margin: 5px; padding: 0px;}
					ol {margin: 5px; padding: 0px 15px;}
					body {font-size: 13px; font-family: Verdana;}
					</style>
				</head>
				<body>
					<h1>OPERATING MANUAL FOR MK 1 INDUSTRIAL REAGENT REFINERY EQUIPMENT</h1>
					<br>
					<h2>OPERATING PRINCIPLES</h2>
					<p>The chemical refinery is not a single machine, but instead many machines connected together to perform the complex, multi-step, reactions needed for production of high value industrial reagents for export from the station.</p>
					<p>Unlike a traditional chemistry department where reagents are created at small scales for local use; A chemical refinery is often dedicated to one or two types of reagents, produced at massive quantities. Each cargo train tanker will need to be filled full of a single reagent to be properly sold by cargo.</p>
					<p>To achieve this, the refinery has many unique machines, each with a role to play. Multiple of the same type of machine will often be needed. As reagents often need many steps to filter and react them to their final forms.</p>
					<br>
					<h2>MACHINERY OVERVIEW</h2>
					<p>In order of importance in refinery operations:</p>
					<h3>Pipes:</h3>
					<p>Pipes form the inexpensive backbone of reagent transfer in a refinery, and connect more complex modules of a refinery together. Pipes do not require power to transport reagents, but do so only in one direction. The red pipe marks an input connection from another machine. Arrows are also pressed into the hull of the pipe to indicate flow.</p>

					<h3>Filters:</h3>
					<p>Similar to pipes, a filter allows reagents to flow from one machine to the next. With a red pipe as input. Once reagents are present in a filter, one of them may be chosen. Once chosen the reagent will be filtered to the purple marked outlet on the filter's side. The filter will not move any reagents if no filtered reagent is selected. It can also be configured to filter out nothing, or everything, if the filter is being used as a way divert flow or purge upstream machinery.</p>

					<h3>Hubs:</h3>
					<p>Hubs are an automatic quick connect solution to pumping reagents from the refinery into cargo train tankers. Once a tanker is moved onto a hub's pad, it will begin filling or draining after a small delay. A hub's mode of operation depends entirely on if a machine's output points into it, or not. If a machine's output points into a hub, it will fill cargo tankers on the pad. If the hub connects to a machine's input instead, it will drain cargo tankers into that machine.</p>

					<h3>Grinders:</h3>
					<p>Solid materials such as metal sheets, ores, and plants may be ground down for use in the refinery. Though this method of reagent production is generally slower, and requires manual input. The grinder only has a single output.</p>

					<h3>Vats:</h3>
					<p>Vats are your primary reagent storage tanks. They hold large volumes of reagents. Like any part of the refinery, once reagents are flowing inside them, they can react with other reagents. Separation, filtering, and careful mixing is critical for the construction of a seamlessly operating refinery. Vats only have a single output, all other sides are considered inputs.</p>

					<h3>Reactors:</h3>
					<p>Reactors are the most complex machine in the refinery. It is capable of distilling reagents that require complex atmospheric conditions. A reactor only has a single output, all other sides are considered inputs. Reagents inside a reactor are separated into internal pressurized tanks, and only react during the machine's distillation cycle. The reactor will automatically shift between pumping and distilling once it detects chemical input. The results will often require filtering and reprocessing, as the input reagents are used to flush the reaction chamber each cycle.</p>
					<p>Reactors are compatible with portable atmospherics pads, and may be anchored on top of one to automatically connect it to a gas network. The gas network will provide the specific pressure and temperature required for the reaction within the machine. Many reactions require specific conditions to progress, and some input reagents may have different reactions depending on temperature and gas composition. Consult a trained chemist for insights on enhancing your refinery layout.</p>

					<h3>Sintering Furnaces:</h3>
					<p>Sintering is the process of heating a material under high pressure, causing it to weld together into a cohesive form. Unfortunately, this can only be done with pure materials, as the correctly mixed ratios required for proper alloy production are not possible. Only base materials such as iron, gold, or silver may be formed. Though some reagents may produce other results. It is inadvisable to attempt sintering on flammable or explosive reagents.</p>

					<h3>Pumps:</h3>
					<p>Pumps allow for the high volume exchange of reagents from one machine to another, but they are also useful for their multiple hose connectors. Allowing you to pump reagents from any other hose connector equipped tool. With this feature, they can serve as the input connection for long distance fracking networks.</p>

					<h3>Fluid Pumps:</h3>
					<p>While not directly a refinery machine, they serve a core function outside of the refinery. Fluid pumps will extract eroded ores from bodies of water near mineral rich deposits. Discussion of high value ores with an experienced miner is recommended. Ores must remain intact near a body of water to be collected by the pump.</p>
					<p>Fluid pumps operate on an internal power cell, protected behind a water proof panel. A crowbar is handy for opening it. Hoses can be connected to a fluid pump, allowing it to connect to long distance tube networks.</p>
					<p>Rarely, large cracks can be found underground, these complex networks of micro fractures can be pumped and drained repeatedly to expand them, and extract the dissolved ores deep within the ground. This process is described as fracking.</p>

					<h3>Pump Relay:</h3>
					<p>The location of external fluid pumps are often very far away from the chemical refinery they are destined for. Pump relays allow two input hoses, and one output hose. Active as a passive, no power required pump. Using the pressure of the other pumps at the head of the network. Pump relays may be spaced far apart, unlike refinery piping, saving crews time and expensive parts.</p>

					<h3>Waste Processors:</h3>
					<p>Many reagents have little use in huge quantities, such as water from a pumped river. This waste reagent may be disposed of quickly in a waste processor. Shredding it to an atomic level and dispersing it through nearby bluespace. Similar to what happens to opens dropped out of a shuttles bluespace shielding during flight.</p>

					<br>
					<h2>OPERATIONAL GOALS</h2>
					<p>With the provided knowledge, anything is possible with the right reagents and machines. Reagents produced by the refinery are intended for sale from the station's cargo department. Reagents must be sold pure, and in a full cargo tanker. Each reagent has a different value and purpose on the market. For methods of reagent production, consult a trained chemist, or one of our trusted exonet partners; Such as BINGLE.</p>
				</body>
			</html>
			"}
