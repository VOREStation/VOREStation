
/datum/event/trivial_news
	endWhen = 10

/datum/event/trivial_news/announce()
	var/author = "Editor Mike Hammers"
	var/channel = "The Gibson Gazette"

	var/datum/trade_destination/affected_dest = pick(weighted_mundaneevent_locations)
	var/body = pick(
	"Tree stuck in tajaran; firefighters baffled.",\
	"Armadillos want aardvarks removed from dictionary claims 'here first'.",\
	"Angel found dancing on pinhead ordered to stop; cited for public nuisance.",\
	"Letters claim they are better than number; 'Always have been'.",\
	"Pens proclaim pencils obsolete, 'lead is dead'.",\
	"Rock and paper sues scissors for discrimination.",\
	"Steak tell-all book reveals he never liked sitting by potato.",\
	"Woodchuck stops counting how many times he's chucked 'Never again'.",\
	"[affected_dest.name] clerk first person able to pronounce '@*$%!'.",\
	"[affected_dest.name] delis serving boiled paperback dictionaries, 'Adjectives chewy' customers declare.",\
	"[affected_dest.name] weather deemed 'boring'; meteors and rad storms to be imported.",\
	"Most [affected_dest.name] security officers prefer cream over sugar.",\
	"Palindrome speakers conference in [affected_dest.name]; 'Wow!' says Otto.",\
	"Question mark worshipped as deity by ancient [affected_dest.name] dwellers.",\
	"Spilled milk causes whole [affected_dest.name] populace to cry.",\
	"World largest carp patty at display on [affected_dest.name].",\
	"'Here kitty kitty' no longer preferred tajaran retrieval technique.",\
	"Man travels 7000 light years to retrieve lost hankie, 'It was my favourite'.",\
	"New bowling lane that shoots mini-meteors at bowlers very popular.",\
	"[pick("Unathi","Spacer")] gets tattoo of "+using_map.starsys_name+" on chest '[pick("[using_map.boss_short]","star","starship","asteroid")] tickles most'.",\
	"Skrell marries computer; wedding attended by 100 modems.",\
	"Chef reports successfully using harmonica as cheese grater.",\
	"[using_map.company_name] invents handkerchief that says 'Bless you' after sneeze.",\
	"Clone accused of posing for other clones's school photo.",\
	"Clone accused of stealing other clones's employee of the month award.",\
	"Woman robs station with hair dryer; crewmen love new style.",\
	"This space for rent.",\
	"[affected_dest.name] Baker Wins Pickled Crumpet Toss Three Years Running",\
	"Skrell Scientist Discovers Abacus Can Be Used To Dry Towels",\
	"Survey: 'Cheese Louise' Voted Best Pizza Restaurant In [using_map.starsys_name]",\
	"I Was Framed, jokes [affected_dest.name] artist",\
	"Mysterious Loud Rumbling Noises In [affected_dest.name] Found To Be Mysterious Loud Rumblings",\
	"Alien ambassador becomes lost on [affected_dest.name], refuses to ask for directions",\
	"Swamp Gas Verified To Be Exhalations Of Stars--Movie Stars--Long Passed",\
	"Tainted Broccoli Weapon Of Choice For Efficient Assassins",\
	"Chefs Find Broccoli Effective Tool For Cutting Cheese",\
	"Broccoli Found To Cause Grumpiness In Monkeys",\
	"Survey: 80% Of People on [affected_dest.name] Love Clog-Dancing",\
	"Giant Hairball Has Perfect Grammar But Rolls rr's Too Much, Linguists Say",\
	"[affected_dest.name] Phonebooks Print All Wrong Numbers; Results In 15 New Marriages",\
	"Tajaran Burglar Spotted on [affected_dest.name], Mistaken For Dalmatian",\
	"Gibson Gazette Updates Frequently Absurd, Poll Indicates",\
	"Esoteric Verbosity Culminates In Communicative Ennui, [affected_dest.name] Academics Note",\
	"Taj Demand Longer Breaks, Cleaner Litter, Slower Mice",\
	"Survey: 3 Out Of 5 Skrell Loathe Modern Art",\
	"Skrell Scientist Discovers Gravity While Falling Down Stairs",\
	"Boy Saves Tajaran From Tree on [affected_dest.name], Thousands Cheer",\
	"Shipment Of Apples Overturns, [affected_dest.name] Diner Offers Applesauce Special",\
	"Spotted Owl Spotted on [affected_dest.name]",\
	"Humans Everywhere Agree: Purring Tajarans Are Happy Tajarans",\
	"From The Desk Of Wise Guy Sammy: One Word In This Gazette Is Sdrawkcab",\
	"From The Desk Of Wise Guy Sammy: It's Hard To Have Too Much Shelf Space",\
	"From The Desk Of Wise Guy Sammy: Wine And Friendships Get Better With Age",\
	"From The Desk Of Wise Guy Sammy: The Insides Of Golf Balls Are Mostly Rubber Bands",\
	"From The Desk Of Wise Guy Sammy: You Don't Have To Fool All The People, Just The Right Ones",\
	"From The Desk Of Wise Guy Sammy: If You Made The Mess, You Clean It Up",\
	"From The Desk Of Wise Guy Sammy: It Is Easier To Get Forgiveness Than Permission",\
	"From The Desk Of Wise Guy Sammy: Check Your Facts Before Making A Fool Of Yourself",\
	"From The Desk Of Wise Guy Sammy: You Can't Outwait A Bureaucracy",\
	"From The Desk Of Wise Guy Sammy: It's Better To Yield Right Of Way Than To Demand It",\
	"From The Desk Of Wise Guy Sammy: A Person Who Likes Cats Can't Be All Bad",\
	"From The Desk Of Wise Guy Sammy: Help Is The Sunny Side Of Control",\
	"From The Desk Of Wise Guy Sammy: Two Points Determine A Straight Line",\
	"From The Desk Of Wise Guy Sammy: Reading Improves The Mind And Lifts The Spirit",\
	"From The Desk Of Wise Guy Sammy: Better To Aim High And Miss Then To Aim Low And Hit",\
	"From The Desk Of Wise Guy Sammy: Meteors Often Strike The Same Place More Than Once",\
	"Tommy B. Saif Sez: Look Both Ways Before Boarding The Shuttle",\
	"Tommy B. Saif Sez: Hold On; Sudden Stops Sometimes Necessary",\
	"Tommy B. Saif Sez: Keep Fingers Away From Moving Panels",\
	"Tommy B. Saif Sez: No Left Turn, Except Shuttles",\
	"Tommy B. Saif Sez: Return Seats And Trays To Their Proper Upright Position",\
	"Tommy B. Saif Sez: Eating And Drinking In Docking Bays Is Prohibited",\
	"Tommy B. Saif Sez: Accept No Substitutes, And Don't Be Fooled By Imitations",\
	"Tommy B. Saif Sez: Do Not Remove This Tag Under Penalty Of Law",\
	"Tommy B. Saif Sez: Always Mix Thoroughly When So Instructed",\
	"Tommy B. Saif Sez: Try To Keep Six Month's Expenses In Reserve",\
	"Tommy B. Saif Sez: Change Not Given Without Purchase",\
	"Tommy B. Saif Sez: If You Break It, You Buy It",\
	"Tommy B. Saif Sez: Reservations Must Be Cancelled 48 Hours Prior To Event To Obtain Refund",\
	"Doughnuts: Is There Anything They Can't Do",\
	"If Tin Whistles Are Made Of Tin, What Do They Make Foghorns Out Of?",\
	"Broccoli discovered to be colonies of tiny aliens with murder on their minds"\
	)

	news_network.SubmitArticle(body, author, channel, null, 1)
