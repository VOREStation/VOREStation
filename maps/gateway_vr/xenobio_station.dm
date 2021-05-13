/obj/effect/overmap/visitable/sector/tether_gateway/xenobio_station
	initial_generic_waypoints = list("xenobio_station1", "xenobio_station2")
	scanner_name = "Xenobiology station"
	scanner_desc = @{"[i]Registration[/i]: ZHS Ark
[i]Class[/i]: Installation
[i]Transponder[/i]: Low-power
[b]Notice[/b]: Very high lifesign density"}
	in_space = 0

/area/tether_away/xenobio_station/
	name = "Strange Location"
	icon_state = "away"
	requires_power = 1
	base_turf = /turf/simulated/shuttle/plating
	dynamic_lighting = 1
	ambience = list('sound/ambience/foreboding/foreboding1.ogg',
					'sound/ambience/foreboding/foreboding2.ogg',
					'sound/ambience/foreboding/foreboding3.ogg',
					'sound/ambience/ruins/ruins1.ogg',
					'sound/ambience/ruins/ruins2.ogg')

/area/tether_away/xenobio_station/atmos
	name = "Strange Atmospherics"
	icon_state = "away"
	ambience = list('sound/ambience/atmospherics/atmospherics1.ogg')
/area/tether_away/xenobio_station/atmos/waste
	name = "Strange Atmospherics Waste Tank"
	icon_state = "away"
	requires_power = 0

/area/tether_away/xenobio_station/engine
	name = "Strange Engine"
	icon_state = "away"
	ambience = list('sound/ambience/ambisin1.ogg', 'sound/ambience/ambisin2.ogg', 'sound/ambience/ambisin3.ogg')

/area/tether_away/xenobio_station/engine/smes
	name = "Strange Engine SMES"
	icon_state = "away"
	ambience = list('sound/ambience/substation/substation1.ogg', 'sound/ambience/substation/substation2.ogg')
/area/tether_away/xenobio_station/breakroom
	name = "Strange Breakroom"
	icon_state = "away"

/area/tether_away/xenobio_station/gate
	name = "Strange Gateway"
	icon_state = "away"

/area/tether_away/xenobio_station/hall1
	name = "Strange Hallway"
	icon_state = "away"

/area/tether_away/xenobio_station/hall2
	name = "Strange Strange Hallway 2"
	icon_state = "away"

/area/tether_away/xenobio_station/science
	name = "Strange Science"
	icon_state = "away"

/area/tether_away/xenobio_station/maint
	name = "Strange Maintenance"
	icon_state = "away"

/area/tether_away/xenobio_station/maint/xeno
	name = "Strange Trash Pit"
	icon_state = "away"
	ambience = list('sound/ambience/expoutpost/expoutpost1.ogg','sound/ambience/expoutpost/expoutpost2.ogg')
/area/tether_away/xenobio_station/breakroom2
	name = "Strange Science Breakroom"
	icon_state = "away"

/area/tether_away/xenobio_station/cages
	name = "Strange Cages"
	icon_state = "away"
	ambience = list('sound/ambience/ai/ai2.ogg', 'sound/ambience/ai/ai3.ogg')
/area/tether_away/xenobio_station/cave
	name = "Strange Caves"
	icon_state = "away"
	requires_power = 0
	ambience = list('sound/ambience/ghostly/ghostly2.ogg', 'sound/ambience/lava/lava1.ogg')
	base_turf = /turf/simulated/mineral/floor/cave
/area/tether_away/xenobio_station/cave/vault
	name = "Strange Vault"
	icon_state = "away"
	requires_power = 0
	base_turf = /turf/simulated/shuttle/floor/alienplating

/obj/item/weapon/paper/awaygate/xenobio_station
	name = "engine instructions"
	var/fake_name
	info = {"<large>R-4D EXPERIMENTAL ENGINE<large><hr>\
<b>Step 1<b>: Don radiation protection and enter primary chamber<br>\
<b>Step 2<b>: Press blast door control button and enter secondary chamber<br>\
<b>Step 3<b>: Fill radiation collectors with phoron tanks<br>\
<b>Step 4<b>: Activate radiation collectors<br>\
<b>Step 5<b>: Enter anomaly chamber<br>\
<b>Step 6<b>: NEVER break eye-contact with Subject #41883<br>\
<b>Step 7<b>: Press blinking button on Subject #41883<br>\
<b>Step 8<b>: (OPTIONAL) Interface with Subject #41883 using a multitool, set power level<br>\
<b>Step 9<b>: Exit chamber while maintaining eye-contact with Subject #41883<br>\
<b>Step 10<b>: Press secondary chamber blast door control button<br>\
<b>Step 11<b>: Immediately report to Dr. Kenzer for psych. eval."}

/obj/item/weapon/paper/awaygate/xenobio_station/New()
	..()
	fake_name = random_name(pick(list(MALE, FEMALE)))
	info = {"<large>R-4D EXPERIMENTAL ENGINE<large><hr>\
<b>Step 1<b>: Don radiation protection and enter primary chamber<br>\
<b>Step 2<b>: Press blast door control button and enter secondary chamber<br>\
<b>Step 3<b>: Fill radiation collectors with phoron tanks<br>\
<b>Step 4<b>: Activate radiation collectors<br>\
<b>Step 5<b>: Enter anomaly chamber<br>\
<b>Step 6<b>: NEVER break eye-contact with Subject #41883<br>\
<b>Step 7<b>: Press blinking button on Subject #41883<br>\
<b>Step 8<b>: (OPTIONAL) Interface with Subject #41883 using a multitool, set power level<br>\
<b>Step 9<b>: Exit chamber while maintaining eye-contact with Subject #41883<br>\
<b>Step 10<b>: Press secondary chamber blast door control button<br>\
<b>Step 11<b>: Press primary chamber blast door control button to engage full power output<br>\
<b>Step 12<b>: Immediately report to Dr. [fake_name] for psych. eval."}

/obj/item/weapon/paper/awaygate/xenobio_station/suicide
	name = "last words"
	info = {"goodbye everyone<br>\
i tried telling kenzer that he was crazy but he still went thru with it<br>\
i dont know if im the only one left in the facility because the alarms arent on anymore<br>\
if anyone finds this god forbid send this note to sol so they can put my death on record so my wife gets insurance<br>\
wishful thinking but send my body to sol too so they can see what they did to us<br>\
actually thats kinda gross and i dont want you to be an accessory to a political statement<br>\
its wishful thinking so think anyone would come here since the gateway lost calibration after someone suplexed a kururak thru it<br>\
anyways thank you for reading a dead mans ramblings<br>\
pvt o'connor 23rd regiment 2nd batallion 34th mp company earth corps"}

/obj/item/weapon/paper/awaygate/xenobio_station/suicide/New()
	..()
	info = {"goodbye everyone<br>\
i tried telling the doctor that they <s>was</s> were crazy but they still went thru with it<br>\
i dont know if im the only one left in the facility because the alarms arent on anymore<br>\
if anyone finds this god forbid send this note to sol so they can put my death on record so my wife gets insurance<br>\
wishful thinking but send my body to sol too so they can see what they did to us<br>\
actually thats kinda gross and i dont want you to be an accessory to a political statement<br>\
its wishful thinking so think anyone would come here since the gateway lost <s>cabriation</s> <s>clibration</s> calibration after someone suplexed a kururak thru it<br>\
anyways thank you for reading a dead mans ramblings<br>\
pvt [fake_name] 23rd regiment 2nd batallion 34<s>nd</s>th mp company earth corps"}

/obj/item/weapon/paper/awaygate/xenobio_station/gaslamp/New()
	..()
	info = {"<h1><center>Specimen log</center></h1><br>\
<center><i>Form 1e.36/1</i></center><br>\
<center><small>2298-08-04</small></center><br>\
<hr><br>\
<br>\
<b><large>Investigative parties</large></b><br>\
Dr. [fake_name]<br>\
Dr. [fake_name]<br>\
<br>\
<b><large>Subject(s)</large></b><br>\
One (1) <i>X Alta fumigatorus</i> (Subject #103)<br>\
<br>\
<b><large>Place of origin</large></b><br>\
Unknown rocky body with phoron atmosphere<br>\
<br>\
<b><large>Enviroment</large></b><br>\
82.4kpa<br>\
234K<br>\
16% Nitrogen<br>\
12% CO2<br>\
72% Gaseous phoron<br>\
<br>\
<b><large>Details</large></b><br>\
Subject is a tall squidlike filter-feeder with rubbery skin that stands upright at  17'1" (approx. 5 meters).<br>\
<br>\
Subject possesses eight (8) appendages and ambulates using tripodal locomotion.<br>\
<br>\
Subject observed wrapping feet around potential food items before surrounding the object in it's appendages.<br>\
<br>\
Subject emits an opaque phoron byproduct of unknown composition."}
