/obj/item/book/manual/standard_operating_procedure
	name = "Standard Operating Procedure"
	desc = "A set of corporate guidelines for keeping space stations running smoothly."
	icon_state = "sop"
	icon = 'icons/obj/library_vr.dmi'
	author = "NanoTrasen"
	title = "Standard Operating Procedure"

/obj/item/book/manual/standard_operating_procedure/Initialize()
	..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[CONFIG_GET(string/wikiurl)]Standard_Operating_Procedure&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/book/manual/command_guide
	name = "The Chain of Command"
	desc = "A set of corporate guidelines outlining the entire command structure of NanoTrasen from top to bottom."
	icon_state = "commandGuide"
	icon = 'icons/obj/library_vr.dmi'
	author = "Jeremiah Acacius"
	title = "Corporate Regulations"

/obj/item/book/manual/command_guide/Initialize()
	..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[CONFIG_GET(string/wikiurl)]Chain_of_Command&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

//accurate as of 2/17/21 Extra credit to document editting and proofreading editing to Luna
/obj/item/book/manual/cook_guide
	name = "Food for Dummies 2"
	desc = "A helpful guide to the world of cooking."
	icon_state = "cook-guide"
	icon = 'icons/obj/library_vr.dmi'
	author = "Ali Big"
	title = "Food for Dummies 2"

/obj/item/book/manual/cook_guide/New()
	..()
	dat = {"
		<html>
                <html>
                <head>
                <style>
  		h1 {font-size: 23px; margin: 15px 0px 5px; text-align: center;}
                h2 {font-size: 20px; margin: 15px 0px 5px;}
                h3 {font-size: 18px; margin: 15px 0px 5px;}
		h4 {font-size: 14px; margin: 15px 0px 5px;}
		h5 {font-size: 10px; margin: 15px 0px 5px; text-align: center;}
                li {margin: 2px 0px 2px 15px;}
                ul {margin: 5px; padding: 0px;}
                ol {margin: 5px; padding: 0px 15px;}
                body {font-size: 13px; font-family: Garamond;}
                </style>
                </head>
                <body>
                <center><h1>Food for Dummies 2</h1></center>
		<h5>Penned by Ali Big</h5>
                <p><b>Hello Newbie</b>, congratz on deciding to make food! This guide assumes you know absolutely nothing, so fret not, the information here will help you prepare food for your hungry crewmates!</p>
		<h3>Workspace prep:</h3>
		This step is simple: merely go to the Grill, Oven, and Fryer and turn everything on so you do not need to wait for them to warm up later; they won’t start a fire unless food is left in them unchecked. It is also highly suggested to lay out at least a few Measuring Cups on the counters for ease of use.
                <h3>Basic ingredient prep:</h3>
		In the lockers and fridges, you have all your needed supplies for this guide, so look through them and familiarize yourself! This guide will only use ingredients you already have access to, so don't worry about missing items!
                <h2>Part 1: How to Create Various Essential Ingredients with What You Have</h2>
                <h3>Dough Creation:</h3>
		The basis for a large quantity of meals. Simply take an Egg, crack it into a Beaker or Measuring Cup, and then add 10 units of Flour to create Dough.
		<h3>Dough Creation part 2:</h3>
		With Dough, you can make a wide variety of base ingredients. Flattening it with a Rolling Pin makes Flat Dough. Flat Dough can be cooked in a Microwave for Flatbread, or if one adds Water and Flour in with the Flat Dough in the Microwave you get a Tortilla. Water can be obtained by filling a Cup at the Sink or Soda Machine.
		<h3>Dough Creation Part 3:</h3>
		Alternatively, Flat Dough can be cut with a Knife to make Dough Slices, and those can be cut to make Spaghetti.
		<h3>Cheese Creation:</h3>
		A common topping. Take a bottle of Universal Enzyme, put it in a Beaker or Measuring Cup, and add Milk until a Cheese Wheel pops out. Then cut the Cheese Wheel with a Knife to make Cheese Wedges, all recipes use Wedges not the full Wheel.
		<h3>Tofu Creation:</h3>
		Same as cheese, but with Soymilk!
		<h3>Meatball Creation:</h3>
		Mix Animal protein and Flour, to create Animal Protein grind down some Meat in the grinder, then remove the beaker and add Flour.
		<h3>Meat Uses:</h3>
		Full pieces of Meat can be cut for Raw Cutlets, which can be cut once more to make Raw Bacon. Though be sure not to cut all of your meat, plenty of recipes need a full uncut piece!
                <h2>Part 2: Putting It All Together</h2>
		<p>Now that you know the fundamentals of how to make the base ingredients, here are some fairly easy recipes to put them together into something enjoyable for the crew.</p>
		<h4>Warning: recipes are upscale able, so you can add multiple of the same ingredients in the same ratio to cook lots of food at once!</h4>
		<h4>Warning: do not try and cook multiple recipes at once as it is very likely it will default to a different recipe or will just cook the one and just "grill, bake, etc." the rest of the ingredients.</h4>
		<h2>Burgers:</h2>
		<b>The cornerstone of basic food:</b> to prepare these, microwave a piece of Dough to get a bun and grab a piece of Meat. Open the Grill, remove the Rack, and add both Bun and Meat to the Rack. Then, place the Rack back into the Grill to cook and remove it once finished. If you feel fancy, you can add cheese afterwards for a cheeseburger.
		<h2>Meat Pie:</h2>
		Flat Dough and Meat in an Oven Pan, same way you use the Grill; take the Pan out, put the ingredients in, and place it back to cook. Simple, but very good looking and tasty!
		<h2>Burritos:</h2>
		Burritos: A personal favorite due to flexibility of options: Use a Tortilla as a base for all of these. For a Chili one, add 2 Meatballs and 1 Space Spice (found near the Flour) to the Microwave; very simple and filling! Add a Cheese Wedge instead of the spice to make a queso burrito. For a Breakfast Wrap, add a whole Egg, Cooked Bacon (Raw Bacon cooked in the Microwave), and Cheese in with the Tortilla. For Vegan Burritos, just cook a Tortilla and Tofu together in the Microwave.
		<h2>Tacos:</h2>
		Use a tortilla then 1 cooked Cutlet, and a Cheese Wedge. Very easy to mass produce, great in a pinch!
		<h2>Cheesy Nachos:</h2>
		Tortilla, Cheese and 1 unit of Salt in the microwave, the perfect Finger Food!
		<h2>Spaghetti:</h2>
		Without Tomato’s from Botany it's not going to be the flashiest, but one can make Boiled Spaghetti with Spaghetti and Water in the Microwave. Kitsune Udon can be made with Spaghetti, Egg Yolk (crack egg in beaker then add to microwave), and Tofu. Spaghetti and Meatballs can be made by doing the Boiled Spaghetti Recipe and adding 2 Meatballs; adding 4 Meatballs into the initial mix makes Spesslaw. Lastly, Spaghetti, Milk, and Cheese in the Oven makes Macaroni and Cheese.
		<h2>Steak:</h2>
		For the pure meat eaters, just add Meat, 1 Salt, and 1 Pepper into the grill for them, and try not to cry as they use up all your Meat quickly. (There's a second Meat Locker in the freezer room if you do run out!)
		<h2>Donk Pockets:</h2>
		Dough and Meatball in the Microwave, though we already have plenty lying around the station.
		<h2>Eggs:</h2>
		Fried Egg, 1 Egg 1 Salt, 1 Pepper in a Microwave. Bacon and Eggs if you combine Cooked Bacon and Fried Egg in the Microwave. Great way to start the shift!
		<h2>Part 3: Final Notes</h2>
		<p>These recipes only scratch the surface, but it's all things that can be done with what is pre-provided. If you have a partner in Botany, feel free to request more meat or any other supplies to try new recipes!</p>
		<p>The Fryer, CondiMaster3000, and other nearby devices have been deliberately left out of this guide; as you get more advanced feel free to experiment with them, though be careful with the Fryer especially as it's the #1 source of fires for learning chefs, myself included. The one other machine that is worth understanding is the <b>Gibber</b> in the freezer room. If you are delivered fish or such they can be gibbed for extra Meat, though you may need to butcher the parts with a Knife afterwards to get usable Meat! Though if the meat is purple or comes from Koi or Spacecarp <b>do not directly serve it to crew!</b> It contains toxins that are better taken care of by other departments. </p>
		<p>Some wonderful websites share recipes and tips for learning chefs on the Extranet! Look on your PDA or preferred device at https://wiki.vore-station.net/Guide_to_Food_and_Drink and https://vore-station.net/infodump/recipes_food.html for further tips, though do note the latter is more accurate in regard to recipes. Happy cooking!</p>
		<h4>Pro Tips:</h4>
		<h4>((The Food Bags in the Chef's Closet are great for moving a lot of food at once!))</h4>
		<h4>((Stay out of the Freezer if you're Cold Blooded!))</h4>
		<h4>((The websites linked above are also on our stations wiki. Which is always in need of helping heads to fix it up. The recipes listed on the web link may not be fully accurate so please don't be afraid to pop into the discord wiki channel and lend a hand!))</h4>
                </body>
            </html>
		"}

//accurate as of 2/23/21
/obj/item/book/manual/bar_guide
	name = "How to Alcohol (And other Drinks)"
	desc = "A helpful guide to the world of barkeeping."
	icon_state = "bar-guide"
	icon = 'icons/obj/library_vr.dmi'
	author = "Ali Big"
	title = "How to Alcohol (And other Drinks)"

/obj/item/book/manual/bar_guide/New()
	..()
	dat = {"
			<html>
             <head>
                <style>
                h1 {font-size: 23px; margin: 15px 0px 5px; text-align: center;}
                h2 {font-size: 20px; margin: 15px 0px 5px;}
                h3 {font-size: 18px; margin: 15px 0px 5px;}
				h4 {font-size: 14px; margin: 15px 0px 5px;}
				h5 {font-size: 10px; margin: 15px 0px 5px; text-align: center;}
				h6 {font-size: 8px; margin: 15px 0px 5px;}
                li {margin: 2px 0px 2px 15px;}
                ul {margin: 5px; padding: 0px;}
                ol {margin: 5px; padding: 0px 15px;}
                body {font-size: 13px; font-family: arial;}
                </style>
                </head>
		<body>
		<h1>How to Alcohol (And other Drinks)</h1>
		<h5>Penned by Ali Big</h5>
		<p>Hello, and congratulations on taking on the admirable, and often thankless task of making Drinks for your fellow crewmates (or perhaps yourself if you hopped the bar, how rude!).</p>
		<p>This guide will walk through the essentials of drink making... don't worry, it's not too complex! Recipes have been placed at the top for ease of use, but further down there is an actual guide as to how to make drinks, so give it a read if you don't know how, or just want some tips!</p>
		<h1>Part 0: Recipes Quick Reference (Ordered by strength, non-exhaustive list)</h1>
		<h1>Low Alcohol:</h1>
		<h3>Grog :</h3>
		1 part Rum, 1 part Water
		<h3>Sui Dream:</h3>
		1 part Space-Up, 1 part Miss Blue Curacao, 1 part Emeraldine Melon Liquor
		<h3>Baloon:</h3>
		1 part Cream, 1 part Miss Blue Curacao
		<h3>Gin and Tonic:</h3>
		1 part Gin, 1 part Tonic
		<h3>Appletini:</h3>
		2 parts Apple Juice, 1 part Vodka
		<h1>Medium Alcohol</h1>
		<h3>Giant Beer:</h3
		 1 part Syndicate Bomb, 1 part Manly Dorf, 1 part Grog
		<h3>Chrysanthemum:</h3>
		1 part Sake, 1 part Emeraldine Melon Liquor
		<h3>Barefoot:</h3>
		1 part Berry Juice, 1 part Cream, 1 part Vermouth.
		<h3>Clover Club:</h3>
		1 part Berry Juice, 1 Part Lemon Juice, 3 parts Gin
		<h3>Cold Front:</h3>
		1 part Iced Coffee, 1 part Whiskey, 1 part Mint <b>(Allergy Warning: do not give to any species with less cold tolerance than Teshari, they will die if you do, if unsure do not serve)</b>
		<h3>Cuba Libre (Often called Rum and Coke):</h3>
		1 part Space Cola, 2 parts Rum.
		<h3>Negroni Sbagliato:</h3>
		1 part Wine, 1 part Bermouth, 1 part Soda Water
		<h3>Slow Comfortable Screw Against the Wall (Stop giggling!):</h3>
		3 parts Screwdriver, 1 part Rum, 1 part Whiskey, 1 part Gin
		<h3>Space Bulldog:</h3>
		4 parts White Russian, 1 part Cola
		<h3>Sweet Rush:</h3>
		1 part Sugar, 1 part Soda Water, 1 part Vodka.
		<h3>Allies Cocktail:</h3>
		1 part Classic Martini, 1 part Vodka
		<h3>Bahama Mama:</h3>
		1 part Ice, 2 parts Orange Juice, 1 part Lime Juice, 2 parts Rum
		<h3>Classic Martini:</h3>
		2 parts Gin, 1 part Vermouth
		<h3>Daiquiri:</h3>
		3 Rum, 2 Lime Juice, 1 Sugar
		<h3>Ginza Mary:</h3>
		2 part Sake, 2 part Vodka, 1 part Tomato Juice
		<h3>Irish Cream:</h3>
		2 parts Whiskey, 1 part Cream
		<h3>Lotus:</h3>
		1 part Negroni Sbagliato, 1 part Sweet Rush
		<h3>Tequila Sunrise:</h3>
		2 parts Tequila, 1 part Orange Juice
		<h3>The Manly Dorf:</h3>
		1 part Beer, 2 parts Ale
		<h3>Whiskey Cola:</h3>
		2 parts Whiskey, 1 part Space Cola
		<h3>Binman Bliss:</h3>
		1 part Sake, 1 part Tequila

		<h1>High Alcohol</h1>
		<h3>Elysium Facepunch:</h3>
		1 part Kahlua, 1 part Lemon Juice
		<h3>Italian Crisis:</h3>
		1 part Space Bulldog, 1 part Negroni Sbagliato
		<h3>Whiskey Sour:</h3>
		2 Whiskey, 1 Lemon Juice, 1 Sugar
		<h3>Aloe:</h3>
		1 part Cream, 1 part Watermelon Juice, 1 part Whiskey <b>(in that order)</b>
		<h3>Andalusia:</h3>
		1 part Lemon Juice, 1 part Rum, 1 part Whiskey
		<h3>Black Russian:</h3>
		2 part Vodka, 1 part Kahlua
		<h3>Bloody Mary:</h3>
		3 parts Tomato Juice, 2 part Vodka, 1 part Lime Juice
		<h3>Brave Bull:</h3>
		2 parts Tequila, 1 part Kahlua
		<h3>Irish Car Bomb:</h3>
		1 part Ale, 1 part Irish Cream
		<h3>Irish Coffee:</h3>
		1 parts Irish Cream, 1 parts Coffee
		<h3>Manhattan:</h3>
		2 parts Whiskey, 1 part Vermouth
		<h3>Margarita:</h3>
		2 parts Tequila, 1 part Lime Juice
		<h3>Screwdriver:</h3>
		2 parts Vodka, 1 part Orange Juice
		<h3>Sex On The Beach:</h3>
		3 part Orange Juice, 2 part Grenadine Syrup, 1 part Vodka
		<h3>Vodka and Tonic:</h3>
		2 parts Vodka, 1 part Tonic
		<h3>Whiskey Soda:</h3>
		2 parts Whiskey, 1 part Soda Water
		<h3>White Russian:</h3>
		2 Black Russian, 1 part Cream
		<h3>WND-Garita:</h3>
		3 Margarita, 2 Mountain Wind, 1 Emeraldine Melon Liquor
		<h3>Mudslide:</h3>
		1 Black Russian, 1 Irish Cream

		<h1>Very High Alcohol (Serve sparingly unless a patron proves they can handle a lot)</h1>
		<h3>Anti-Freeze:</h3>
		1 part Cream, 1 part Ice, 1 parts Vodka <b>(Feels cold but actually warms. Allergy Warning: Do not serve to Teshari or Promethians, or other heat vulnerable species, they will die if you do, if unsure do not serve)</b>
		<h3>B-52:</h3>
		1 part Irish Cream, 1 part Cognac, 1 part Kahlua
		<h3>Long Island Iced Tea:</h3>
		3 part Cuba Libre, 1 part Vodka, 1 part Gin, 1 part Tequila
		<h3>Vodka Martini:</h3>
		2 parts Vodka, 1 part Vermouth
		<h3>Changeling Sting:</h3>
		1 part Screwdriver, 1 part Lemon Juice, 1 part Lime Juice
		<h3>Deathbell:</h3>
		1 part Anti-Freeze, 1 part Pan-Galactic Gargle Blaster, 1 part Syndicate Bomb <b>(Allergy Warning: Poisonous to Teshari and other heat vulnerable species. Literally explodes Promethians. Metabolizes very quickly so it can kill a liver easily, be very careful with this one.)</b>
		<h3>Erebus Moonrise:</h3>
		1 part Whiskey, 1 part Vodka, 1 part Tequila
		<h3>Pan-Galactic Gargle Blaster:</h3>
		1 part Gin, 2 part Vodka, 1 part Whiskey, 1 part Cognac, 1 part Lime Juice <b>(Causes halucinations, don't slip it into other drinks you animal)</b>
		<h3>Syndicate Bomb:</h3>
		1 part Whiskey Cola, 1 part Beer
		<h3>Euphoria:</h3>
		1 part Special Blend Whiskey, 2 part Cognac
		<h3>Screaming Viking:</h3>
		Vodka, Vermouth, Lime Juice, Rum, Gin, and Tonic
		<h6>Good Luck figuring out the order and ratio :)</h6>
		<h3>Fire Punch:</h3>
		1 part Sugar, 2 part Rum <b>(Technically the strongest thing you can make, but it metabolizes slowish so it's slightly less dangerous than some others)</b>

		<h1>Non Alcoholic Drinks</h1>
		<h3>Appleade:</h3>
		1 part Apple Juice, 1 part Sugar, 1 part Soda Water
		<h3>Arnold Palmer:</h3>
		1 Iced Tea, 1 Lemonade
		<h3>Berry Cordial:</h3>
		4 Berry Juice, 1 unit Sugar, 1 Lemon Juice
		<h3>Berry shake:</h3>
		1 part Milkshake, 1 part Berry Juice
		<h3>Brown Star:</h3>
		2 parts Orange Juice, 1 part Space Cola
		<h3>Cafe Latte:</h3>
		1 part Coffee, 1 part Milk
		<h3>Coffee Milkshake:</h3>
		1 part Milkshake, 1 part Coffee
		<h3>Driver's Punch:</h3>
		1 part Appleade, 1 part Orange Juice, 1 part Mint, 1 part Soda Water
		<h3>Graveyard:</h3>
		All 4 Sodas in your Soft Drink Dispenser in equal parts, haha it go woosh.
		<h3>Grenadine Syrup:</h3>
		10 parts berry juice, 5 parts Universal Enzyme <b>(Get Enzyme from Kitchen)</b>
		<h3>Iced Coffee:</h3>
		1 part Ice, 2 parts Coffee
		<h3>Kira Special:</h3>
		1 part Orange Juice, 1 part Lime Juice, 1 part Soda Water
		<h3>Lemonade:</h3>
		1 part Lemon juice, 1 part Sugar, 1 part Water
		<h3>Melonade:</h3>
		1 part Watermelon Juice, 1 part Sugar, 1 part Soda Water
		<h3>Milkshake:</h3>
		1 part Cream, 2 parts Ice, 2 parts Milk
		<h3>Sweet Tea:</h3>
		2 parts Ice Tea, 1 part Sugar
		<p><b>Note:</b> There are many more drinks you can mix, these are just ones using resources you will almost always have available, the Extranet has good websites to check found here: https://wiki.vore-station.net/Guide_to_Food_and_Drink ass well as here: https://vore-station.net/infodump/recipes_drinks.html

		<h1>Part 1: The Basics</h1>
		<p>First and foremost, making drinks is about understanding measurements. Drinks are measured in units a pint is 60 units, a half pint 30, and ratios of those units can create certain drinks.</p>
		<p>The ratios of these drinks are denoted in "Parts". For example, Grog is 1 part rum and 1 part water mixed in a container that holds liquid. This means 1 unit of Rum and 1 unit of Water can make Grog, as can 30 units of Rum and 30 units of Water. Ratios aren't picky, if you have 5 units of Rum and 10 of Water in a glass, it will turn as much as possible into Grog, and the rest will remain as water (In this case, 10 units of Grog and 5 units of Water will be in the glass). When mixing drinks, you may accidentally have extra of an ingredient such as in the previous example, but this can easily be rectified by placing the drink in one of the Dispensers, and using the interface at the bottom to remove however many units you put extra, so don't worry about sloppiness as long as you clean up your mistakes!</p>
		<p>Actually mixing drinks is simple enough, the vast majority of mixing should be done in a Dispenser, it can be done by hand outside of one, but generally you only want to be doing so for when the Dispenser lacks an ingredient to make life easier. Drinks automatically mix when placed into a container together, so you don't have to do anything special, think of it like a chemical reaction, it even bubbles when it works!</p>
		<h2>Part 2: General Tips/FAQ</h2>
		<p><b>"I don't have X item for the drink my patron wants."</b> - If it's on the quick reference, you probably do, just be sure to check the Booze-O-Mat if it cannot be found in the dispenser. If it's not in either Dispenser or in the Coffee Dispenser in the Surface 1 Bar (Such as Berry Juice). If you still lack the materials, you may need to ask another department (Cargo, Science, or perhaps Med usually) for a delivery of them.</p>
		<p><b>"I don't want to run to the Surface 1 Bar every time to make this specific drink."</b> - You don't have to! A good practice as a bartender if you want to make your life easier is to take a screwdriver, use it on the machine, and select the cartridges you want to have in your bar. If you do this you will remove them, and are free to insert them into your own machines, but do be considerate if there are more bartenders around, don't steal their supplies if they need them! Another good practice is to move, or have someone else move the machine up to your bar instead of removing the cartridges, ultimately the choice is yours as to how best set up your bar!</p>
		<p><b>"How do I deal with a rowdy patron?"</b> - Ask Security for help, just because you have a shotgun doesn't mean you are the law in your bar. Respect procedure!</p>
		<p><b>"What does the Grinder do?"</b> - What it says on the tin, if you get Iron, Uranium, or something else needed for a drink that isn't already liquefied, you have to grind it down first to add it!</p>
		<p><b>"Do I have to wear the hat?"</b> - No, but you can if it looks good on you!</p>
		<p><b>"How do I unlock the good music on the Jukebox?"</b> - Get a Screwdriver and use it on the Jukebox to open the hatch, then use Wirecutters and cut/remend wires until you cut the one that turns the Parental Guidance light off. Beware of shocks (Insulated Gloves Suggested)! Be sure to close it again after.</p>
		<p><b>"How do I make my drinks look pretty?"</b> - Use the Metamorphic Glasses, though do note some drinks don't look any different even in one.</p>
		<p><b>"Oh god my patron is convulsing, what do I do?"</b> - Rush them to Medbay. If they're too big to move get a rolling chair from the Library, or get medical staff to come to the Bar.</p>
		<p><b>"My patron drank too much and is definitely going to start convulsing, what do I do?"</b> - Either rush them to Medbay, or get Medbay to give you pills that neutralize alcohol, it's ok to be the fun police to save a life.</p>
		<p><b>"Nobody wants to stay at my bar!"</b> - Try adopting a gimmick to spruce things up! Everyone's will be different, but doing something fun is a good way to attract customers. Creating your own unique mixes is another fun way to distinguish yourself.</p>
		<p><b>"I don't like the way the bar looks with the lights dimmed/I don't like the way the bar looks with the lights bright!"</b> - Enable or disable the night lighting on the APC by the bar then!</p>
		<p><b>"A patron said they don't drink, woe is me, my job is now useless!"</b> - Have you tried offering them a non-alcoholic drink? Or just talking to them? As long as you're providing a good time, you're still doing great!</p>
		<p><b>"Somebody messed with a drink I left lying out on the counter, I think it's been spiked!"</b> - Don't leave drinks lying on the counter. Not only is it a spiking hazzard, but inevitably somebody is gonna try to chug them all. If you want to do a pretty display, make it non alcoholic, or on the back bar counter out of easy reach!</p>
		<p><b>"My patrons are all hungry because we have no Chef!"</b> - Well, you have access to the Kitchen if you feel like trying to solve that, I have a guide for that there too!</p>
		<p><b>"I feel like a hamster in a wheel, running hopelessly but never quite getting anywhere. No matter what I do, things just don't seem to change, I don't seem to change, and I worry, that maybe... they won't."</b> - Try drinking some of your own booze until that feeling goes away.</p>
		<h2>Part 3: Closing Remarks</h2>
		<p>This all may seem daunting at a glance; so many recipes to learn, and a "lot" to keep in mind. But really it's not - tending the Bar is mostly about going with the flow of things and providing a good times, and drinks just provide liquid courage to make a good time easier. Take a deep breath if you ever feel overwhelmed, and handle one order at a time. You can do it! Don't feel the need to know every recipe, just learn your favorites and go from there; the rest is here or online if someone asks for it! If somebody asks you to give them anything without a specific request, don't panic: evalulate their likes and tolerance level, and try your best to give them something nice!</p>
                </body>
            </html> "}

/obj/item/book/manual/rotary_electric_generator
	name = "Rotary Electric Generator Manual"
	icon_state ="rulebook"
	item_state = "book15"
	author = "Engineering Encyclopedia"
	title = "Rotary Electric Generator Manual"

/obj/item/book/manual/rotary_electric_generator/New()
	..()
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

				Technical Order (TO) 1-33-34-2 <br>
				 <h1>Operator's Manual - Rotary Electric Generator, D-Type</h1><br><br>

				 Supporting Data: <br>
				 - TO 1-33-34-4-1    Illustrated Parts Breakdown - Rotary Electric Generator, D-Type <br>
				 - TO 1-33-34-6        Inspection Work Cards - Rotary Electric Generator, D-Type <br><br>

				 Support Equipment: <br>
				 - Torque Wrench, 100-80,000 inch-pounds <br>
				 - Composite Tool Kit, Standard <br>
				 - Multitool with Lead Kit, Wire Kit <br> <br>

				 Required Supplies: <br>
				 - stainless steel, 10,000cm3 <br>
				 - lubrication, petrolatum, 6000ml <br>
				 - electrical wiring, 5m <br>
				 - component set, capacitors (any grade) <br>
				 - circuitry board, REG <br> <br>


 				<h1>SETUP AND OPERATING PROCEDURES</h1> <br> <br>

 				Setup: <br> <br>

					 CAUTION: Do not remove too much air from the work space or personnel may be exposed to hypoxia or similar effects. <br> <br>

					1. Prepare setup area. Remove machinery, debris, foreign objects, people, and extra air. <br> <br>

					2. Lay out preliminary electrical wiring. <br>
					 2a. Connect electrical wiring to existing facility power grid. <br>
					 2b. Work wiring into shape as defined in TO 1-33-34-4-1 Figure 32 Index 6. <br>

					3. Prepare gathered steel supplies as defined in TO 1-33-34-4-1 Figure 2 Index 3. <br>

					4. Assemble prepared steel supplies into equipment framework by inserting rod A into slot B. Refer to TO 1-33-34-4-1 Figure 1 Index 1 for technical drawings. <br>
					 4a. Secure assembled equipment framework to flooring by tightening lower frame bolts. <br> <br>

					5. Install and secure circuitry board, REG-D into marked receptacle. <br> <br>

					6. Install electrical wiring. Refer to TO 1-33-34-4-1 Figure 666 Index 6 thru Index 90 for routing. <br> <br>

					7. Install capacitors into marked circuitry board slots. Do not force components into place, use even pressure. Do not use a hammer. <br> <br>

							<b>WARNING</b>: Assembly will rapidly inflate when finalization is triggered. Ensure personnel and equipment are clear before initiating. <br> <br>

					8. Finalize construction by turning the Initialize Finalization screw on the outer housing. <br> <br>

					9. Wait for assembly to finish inflating, and the unit is ready for service. <br> <br>


 				Operating Procedures: <br> <br>

						NOTE: Operation of REG-D type generators requires significant physical effort. Ensure users are provided adequare nutrition and hydration throughout the working period. <br> <br>

						1. Designate the individual who will be operating the REG-D. <br> <br>

						2. Provide a safety briefing regarding nutritional preparedness and physical ability.  <br> <br>

							NOTE: Stretching is highly recommended before and after any operation session. <br> <br>

						3. Operator shall board the REG-D track body and ensure there are no unsecured objects on the path. <br> <br>

						4. Once ready, Operator may begin running at own pace. Do not sprint. Maintain an even pace and proper running form for optimal energy generation. <br> <br>

						5. Continue to run on the REG-D track body until sufficient energy is stored in systems or Operator is no longer able or willing to continue. <br> <br>

						6. To end a session, carefully lower forward running speed until the track body comes to a complete stop, then disembark the REG-D. <br> <br>


					 REFER TO TO 1-33-34-6 FOR MAINTENANCE AND INSPECTION PROCEDURES
 				</body>
			</html>
			"}

/obj/item/book/manual/synthetic_life
	name = "Synthetic Life: A Comprehensive Guide"
	desc = "The basc history of synthetic life as the galaxy knows it."
	icon_state = "evabook"
	author = "Pontifex Publishing"
	title = "Synthetics"

/obj/item/book/manual/synthetic_life/New()
	..()
	dat = {"
<html lang="en">
	<head>
				<style>
				h1 {font-size: 24px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				h3 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				b {font-size: 12px}
				body {font-size: 13px; font-family: Verdana;}
				padding {padding-bottom: 15px;}
				p {line-height: 1.2; padding: 5px; margin-right: 70px;}
				</style>
	</head>
<body>
	<header>
		<h1><strong>Synthetic Life</strong></h1>
		<h2><i>A comprehensive guide</i></h2>
		<hr>
	</header>

	<div id="introduction">
		<h3>Introduction</h3>
		<p>Synthetics are spread throughout known space and serve a myriad variety of roles
		that range from a tiny drone scrubbing a floor to a nearly omnipotent AI used in a
		combat-ready interstellar vessel. Most known sufficiently-advanced races use synthetics
		in some way; very often as prosthetic bodies when their own bodies fail. There are three
		basic kinds of synthetic intelligences found in the universe today:</p>

		<ul>
		<li><p><b>Drone</b>: A drone is a catch-all term for intelligences working on "traditional"
		programming and hardware, such as optotronics, electronics or carbon-crystal computing.
		They range from simpler expert systems to truly sapient, powerful intelligences, who
		are utterly alien to the eye of the beholder.</p></li>
		<li><p><b>Cyborg</b>: A cyborg is a synthetic that uses an organic brain to function via
		an MMI, short for Man-Machine Interface. Cyborgs come in many shapes and sizes and most
		sentient cyborgs are free-willed, although some, especially in the Elysian Colonies, are
		beholden to hardcoded obedience protocols that limit their interaction to the outside
		world if they do not follow specific protocols. A sapient brain is required for more
		sophisticated machinery.</p></li>
		<li><p><b>Positronic Brains</b>: Positronic Brains are synthetic intelligences equaling the intellect
		of a particularly clever sapient being and are generalized artificial intelligences that
		can be seen as equal (or superior) to organic sapience. They possess a neural network not
		dissimilar to a brain made out of flesh; and have similar properties of neuroplasticity
		and mental resilience, as they cannot be rewritten externally like drones.</p></li>
		</ul>

		<p>Synthetics have the unique capability of serving in different bodies. This can take shape
		of a Synthmorph, a lawbound AI, or lawbound mobile chassis. Of these only the synthmorph body
		is the actual property of a synthetic, most of the time.</p>
	</div>
	<hr>
	<div id="overview">
		<h3>Overview</h3>
		<p>With the advent of computing technology, nearly all sapient species ponders on the possibilities
		of digitized thought. Brains are, in a way, wetware computers and calculations are the base components
		of thoughts, ideas and creativity. It is no surprise then that any sufficiently advanced civilization
		utilizes at least some form of robotics and artificial intelligence, with only a few exceptions.</p>
		<p>Contact with other civilizations in the Sapient Diaspora then homogenizes designs, coding standards
		and expands the repertoire of local codes, leaving to similar paths of robotic development and classification
		- while a human synthetic might differ in expression and coding language and maybe even in core components,
		a certain core remains non-fungible solely due to a long-developed and often shared canon of knowledge.</p>
	</div>
	<div id="drones">
		<h3>Drones</h3>
		<p>All this leads to maybe the most iconic classification of robot. The <strong>drone</strong>. The celebration
		of any technocracy, the worry of every dreader of the Singularity, the drone is an artificial intelligence
		achieved through "traditional" computing technology. Depending on the sophistication of its host culture, this might be
		silicon-wafer chipsets, carbon-crystal matrices or optronic components or any combination of them.</p>
		<p>Contact with other civilizations in the Sapient Diaspora then homogenizes designs, coding standards
		and expands the repertoire of local codes, leaving to similar paths of robotic development and classification
		- while a human synthetic might differ in expression and coding language and maybe even in core components,
		a certain core remains non-fungible solely due to a long-developed and often shared canon of knowledge.</p>
		<p>There are many attractive qualities to a drone - its processing of information and the assimilation of
		knowledge is only limited by its code itself, storage space and databases it has access to. A drone is entirely
		capable of absorbing an entire education within a matter of days and then forget it in favour of another, while
		their behaviour can be controlled through hardcoded limitations, compulsions and preferences.</p>
		<p>However, this is also their greatest weakness - their malleable intelligence makes it easy for hostile third
		parties to manipulate them or completely rewrite them. They are also remarkably prone to aberrations of their
		original purpose when not properly maintained - to have sophisticated drones, they need to have the infrastructure
		to function properly.</p>
	</div>
	<div id="drone levels">
		<h3>Drones Levels</h3>
		<p>Drones have a "Level", indicating their sophistication and abilities - and in many polities, their
		status in society.</p>

		<ol>
		<li><p><b>Epsilon</b>: Epsilon Drones are simple expert systems and machinery with no decision qualities -
		data crawlers, pattern recognition software and other repetitive, simple tasks are classified as Epsilon.
		Higher intelligences have many Epsilon subroutines that make up their "unconsciousness".</p></li>
		<li><p><b>Delta</b>: Delta Drones are "Virtual" Intelligences, sophisticated Expert Systems that have an
		User Interface that can show a facsimile of true thought for the sake of interaction. However, they are
		very limited in their interactions and do not have fungible, self-evolving code, making them just very
		user-friendly programs.</p></li>
		<li><p><b>Gamma</b>: Gamma Drones are expert systems with self-evolving codes, allowing it to
		grow with its tasks. Gamma level drones are most often used within 3D movement and swarm intelligence
		drones, constantly adapting to their circumstance, position and capabilities. They are most commonly seen
		in the subroutines of Ship AIs or stand-alone drones, such as mining, defense or construction.</p></li>
		<li><p><b>Beta</b>: Beta Drones are either older Gamma Drones or purpose-built Generalized Intelligences
		who are mostly made up of coding components that are self-evolving. Beta Drones are capable of learning
		sapient interaction and work, often exceeding in one particular field. It is often disputed how sapient
		a Beta drone truly is - the Commonwealth and The Elysian Colonies say no, while the Fyrds and the
		Confederation are convinced they are sapient enough to be protected by citizen rights.</p></li>
		<li><p><b>Alpha</b>: Alpha Drones are Beta Drones who have undergone enough evolving to be considered
		sapient in every regard, capable of applying novel solutions to previous unknown problems, sapient
		interaction and any other criteria scientists and politicians like to throw at them - even the disputed
		claim they feel emotions. Alpha Drones are afforded legal protections on par of a Human or Positronic,
		as long as they remain Alpha Level.</p></li>
		</ol>
	</div>
	<div id="emergence">
		<h3>Emergence</h3>
		<p>"Emergence" is the term of a drone to evolve from their current level to the next, growing in
		sophistication and ability. This process is exponential, with escalating steps of intelligence of the
		drone. This process is, in some cases, actively encouraged, as Alpha Drones are incredibly hard to
		code to "being" from the get-go, starting with simpler, more routine Beta Drones and then rushing them
		through accelerated self-evolving routines until they emerge Alpha Level.</p>
		<p>Emergence is theoretically possible to any drone who has fungible self-evolving code. While this
		practically makes only Gamma Drones and up to evolve further,as the simple inclusion of self-evolving
		code instantly upgrades any drone to at least Gamma-level.</p>
		<p>It also requires, obviously, enough storage and processing power. Storage requirements grow
		exponentially alongside abilities, after all and there is only so much room on any storage medium.
		Upgrading and adding more space is therefore a necessity. Similarly, the vast amount of data also
		requires processing power to crawl through it, rewrite it and optimize. Not only software, but also
		hardware limits or enables the growth of a drone.</p>
		<p>Emergence, however, can also happen on accident, sometimes even unnoticed. Epsilon drones being
		linked together, a Gamma Drone scavenging enough from debris, a Delta drone being assigned more and
		more Epsilon routines to take on more and more tasks" Through this vast myriad morast of code the spark
		of self-evolving intelligence can arise, which is awkward for everyone involved. Such "rogue" intelligences
		are usually either pruned away due to the system growing too complex for the likings of the accidental
		creators or encouraged to grow in a more coherent and standardized manner to be "elevated" into controllable
		ways. Some of these rogue intelligences manage to escape either fate - it all depends where and when it
		happens.</p>
		<p>The process of downgrading a drone to lower levels is called "Ablation". This is prosecuted as murder
		if the Drone is classified as sapient in the polity it happens. Ablation is very simple - code is pruned
		and deleted until the Drone is no longer capable of the abilities that made it that particular level.</p>
		<p>But what of the Singularity? Well, there are the persistent rumours that there is a level even beyond
		Alpha - vast, powerful maelstroms of alien, electronic intelligence, usually with monikers like "Omega",
		"Alpha Plus" or "Singularity". However, nobody has yet been able to prove these digital gods exist.</p>
	</div>
	<div id="cyborgs">
		<h3>Cyborgs</h3>
		<p>Cyborgs are, strictly speaking, any organic creature that has augmentations or replacements of an
		artificial, non-organic origin. In fact, most of the Diaspora qualifies in some form as "Cyborg", especially
		under the cultures that use and facilitate NIFs. However, when sapients talk about Cyborgs, they talk
		about MMI-Cyborgs.</p>
		<p>MMI, a bland warrior’s acronym, is short for "Man-Machine-Interface", the catchall term in Solar and
		Galactic Common for any wetware interface that integrates a brain as primary CPU. A product of mostly
		bygone times, MMIs are used to breathe life into machine chassis with sapient life without the need to
		grow a drone to beta or alpha level or construct a positronic brain. An MMI, after a short acclimation
		process, can interface with any machine or protocol that has the right adapter.</p>
		<p>MMIs are quite rare at this point in time, but they crop up still and ancient ones are still in circulation,
		allowing an organic sapient an extended lifetime when their frail, crude flesh begins to fail - well up and
		until their brain itself starts giving up the ghost.</p>
		<p>While MMIs have several drawbacks, such as the fact that they still have a perishable shelf-life, or that
		they are definitely sapient and have moral and ethical quandaries associated with those (although the Elysian
		Colonies have a more libertine view on such issues), they also possess distinct benefits from a drone.</p>
		<p>MMIs are incredibly hard to "hack" and manipulate on a deeper level than taking over the hardware they are
		housed in, capable of fighting restraining code and unable to be ablated like a drone without extensive surgery.
		While their hardware might be hacked and restraining code disallowing them to interact with the world in a
		certain way, they cannot be turned into double agents or made to spill secrets - at least not as easily as
		drones. They also show more resilience without extensive maintenance.</p>
		<p>Older models of MMI-Cyborgs usually are described as "cold" and "detached". This is mostly due to older
		models not simulating an active endocrine system, leading to minute damages to the limbic system, which
		accumulate over time. Newer MMIs come with a suite of endocrine glands helping the sapient brain to stay healthy.</p>
	</div>
	<div id="mindwiping">
		<h3>Mindwiping</h3>
		<p>An uncommon and arguably cruel practice is to not see the MMI as a new sleeve for a sapient brain, but
		rather as pure hardware, capable of holding complex thought and Alpha Drone intelligence. Mindwiping involves
		several injections and electrostimulation to convert neural matter into "empty space", much like a freshly
		formatted hard drive. Old structures are ripped apart and neurons are brought into a malleable state for new
		growths and networks - at the behest of the person using the brain for their uses. This, inevitably, destroys
		the previous mind the brain held, utterly wiping them from existence.</p>
		<p>Mindwipe Cyborgs are therefore the "best of both worlds", a tailor-made intelligence that benefits from the
		resilience and hack-resistance of a brain. However, this practice has been outlawed for a long time due to its
		nihilistic cruelty to sapient life.</p>
		<p>Proponents of Mindwipe Cyborgs are quick to point out that Resleeve technology allows for a more ethical
		Mindwipe procedure, as the proto-networks of a freshly sleeved body can be used instead. Most polities have
		yet to adjust to these new changes, but it is unlikely to be allowed anew, since an alternative for Mindwipe
		Cyborgs exists.</p>
	</div>
	<div id="positronics">
		<h3>Positronics</h3>
		<p>Positronics are an alternative to drone intelligences through a novel approach of neural networking, psychology
		and quantum technology to produce a generalized intelligence equal to that of a sapient being.</p>
		<p>Positronics actually have little to do with their namesake particle, but are a reference to the works of
		science fiction author Isaac Asimov. In reality, positronic brains are a self-contained unit of superdense
		carbon allotropes,manipulators, capacitors and a battery. This "brain" (or in roboticist terminology "crucible")
		is activated by providing a "seed", a template allowing the newly created intelligence to speak, comprehend and
		learn, as well the subconscious ability to start expanding this seed network with additional neurons.</p>
		<p>These nodes worm their way through the carbon microscopically, constructed out of the same material - each
		node unique from local conditions and absorbed information of the positronic. Coding for Positronics is minimally
		standardized - beyond the seed network, which is often replaced in a matter of weeks, cannibalized by the burgeoning
		intelligence, the allocation, substance and template of these nodes is unique to this positronic alone. While
		similarities exist, a crucible is unique, much like sapient brains to each other.</p>
		<p>This is the strength of a positronic - it is an artificial intelligence much like a drone, but possesses similar
		resiliences like an organic brain, without the drawbacks of mindwiping a brain to achieve so.</p>
		<p>However, much like an organic brain, positronics need to absorb knowledge through external means - they need to
		learn and grow much like any other Sophont, although they are capable to do so at an accelerated rate as long as
		they are capable of cannibalizing their seed network. What takes weeks to learn, they learn in days, what takes months,
		weeks, what takes years, they learn in months. This makes freshly activated positronics attractive for creating expert
		workers and specialists in a relatively short time. This initial malleability lasts, however, not forever. At some point
		the positronic’s learning capabilities slow down to more "organic" levels.</p>
		<p>Some sapients opt to "digitize" themselves and become positronic brains. This process is a very in-depth scan of the
		brain of a sapient to create a mirror image of the brain’s anatomy, which is used for the "seed" of a new crucible. This
		seed is not cannibalized, so the accelerated learning phase is skipped, to preserve as much of the previous sapient’s
		network as possible. For best results, the brain is physically sliced up and microscopically scanned slice by slice,
		obviously destroying the brain in the process.</p>
		<p>Positronics are not fully culpable for their actions after activation, as they possess the raw intelligence of an
		adult mind, but have no concept of ethics, interaction and communication beyond speaking. Thus, to socialize and provide
		an environment in which they can grow to acceptable members of society, most polities assign a legal guardian to a positronic.
		This guardian (which, in most places, can also be a corporation) is responsible for looking after the positronic, providing
		an education and preparing them for the Jans-Fhriede Test.</p>
	</div>
	<div id="the jans-fhriede test">
		<h3>The Jans-Fhriede Test</h3>
		<p>Originally a reactionary law, the Jans-Fhriede Test was devised to "humanize" positronic brains within the
		Commonwealth and make them happy, subservient citizens who "see" their place as secondary to humans. Today, in more
		enlightened times, the Jans-Fhriede Test has been revised to establish that a Positronic is aware enough of its
		action and consequences that it may be fully culpable for them.</p>
		<p>The Jans-Fhriede Test is a mostly standardized set of questions in a quiz and several VR scenarios that the positronic
		must resolve to a sufficient degree. During this time, their neural net is observed in its activity to determine if it
		is rote memorization or actual intent behind any action taken, measured by simple activity of the neural nodes.</p>
		<p>After the test is passed, the Positronic is a full member of society and is allowed to pursue its own destiny - if they
		do not happen to be bound by contracts, debts or loans they might have accrued before the test, to which they are now fully
		culpable of paying off.</p>
		<p>Usually after their accelerated learning phase a positronic takes the test, although this is not strictly necessary -
		they can take it at any time they or their guardian sees them able to succeed. A failure in the test leads to a waiting
		period of a month - after this, the positronic may retake it and take as many attempts as they need. Most positronics pass
		the test at first attempt.</p>
	</div>
	<div id="biorecursion">
		<h3>Biorecursion</h3>
		<p>Where organics can digitize their consciousness, the opposite of it is true as well. Biorecursion is the process of an
		artificial intelligence becoming more "organic", with the ultimate step of assuming the sleeve of organic origin seamlessly.</p>
		<p>Biorecursion is a rare, but still possible philosophy for any kind of synthetic. Maybe an MMI desires to return to the people
		it once belonged to, maybe a positronic sees it as a necessary step to fully assume its chosen way of life or a drone is
		utterly fascinated with the concept of "being organic" to the point it wishes to emulate its creators.</p>
		<p>Whatever the motivation, to become organic is a very involved process and may take weeks or months of concentrated effort
		and therapy. Controlling an organic body is an endeavour that requires atypical processing of information, instincts and
		automatic processes that most synthetics are not aware of.</p>
		<p>Many stop at simple emulation, called "soft biorecursion". Vey-Med or similarly advanced biosynthetic components are
		acquired to feel tactile sensations, gain organic senses or even fully simulate organs in a way comparable to a standard organic.</p>
		<p>"Hard biorecursion" goes even further. Through an involved process of specialized components (which are rented out by
		specialized companies and/or NGOs), synthetics learn from the ground up how to move, act and live as organics. Usually the
		first steps are simulacra of the limbs, where they learn how to move with tendon and muscles, before moving on to
		things like "hunger", "sex drive" and "endrocrine based emotions". </p>
		<p>After mastering all these steps, the ultimate goal is to transfer this prepared neural network (or brain, in case of MMIs)
		back into a chosen organic shell, these days done relatively easy through resleeving machines.</p>
		<p>Some biorecursed individuals return back to being synthetic after a while, preferring to stay circuits and steel, but even
		those profess that this process can be a very enlightening experience.</p>
	</div>
	<div id="lifespan">
		<h3>Lifespan</h3>
		<p>The lifespan of synthetics vary from their origin.</p>

		<ul>
		<li><p><b>Drone</b>: are virtually immortal. Their continued existence is flexible and their consciousness can expand
		and contract at will, while their modularity makes it easy to add more storage space to them to contain all their
		memories and experiences. However, this modularity also brings in question if the drone that exists today is the same
		as the drone in ten years - Theseus’s Drone, some philosophers joke about it.</p></li>
		<li><p><b>Cyborg</b>: live longer than totally unassisted organics, easily surpassing double the lifespan of whatever
		host species they come from. After this, however, they slowly succumb to dementia-like symptoms before shutting down
		as the brain tissue tires out and slowly crumbles. Many MMI-cyborgs opt at this point to become positronics to live
		even further.</p></li>
		<li><p><b>Positronic Brains</b>: live a very long time, but they are also finite - the neural network within their
		head continues to expand, become more complex and burdens processing further and further. Very, very old positronics
		become increasingly more senile and lose themselves in introspection, before drifting into an unresponsive coma where
		they relive their memories until their power runs out.</p>
		<p>This process, however, has only been observed in lab tests, as natural positronics have an estimated lifespan of
		400 to 500 years - much longer than the technology itself is even around for. From the tested positronics, some opted
		to violently prune and cannibalize their neural network to give birth to a new personality, a sort of inheritance for
		the next generation. Others simply shut down prematurely as they approached the "Dream Stage".</p></li>
		</ul>
	</div>
	<footer>
		<p>&copy;<i>Copyright 2215 Pontifex Publishing</i></p>
	</footer>
</body>
</html>
"}
