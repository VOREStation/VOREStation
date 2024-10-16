// Wiki books that are linked to the configured wiki link.

/// The size of the window that the wiki books open in.
#define BOOK_WINDOW_BROWSE_SIZE "970x710"
/// This macro will resolve to code that will open up the associated wiki page in the window.
#define WIKI_PAGE_IFRAME(wikiurl, link_identifier) {"
	<html>
	<head>
	<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
	<style>
		iframe {
			display: none;
		}
	</style>
	</head>
	<body>
	<script type="text/javascript">
		function pageloaded(myframe) {
			document.getElementById("loading").style.display = "none";
			myframe.style.display = "inline";
	}
	</script>
	<p id='loading'>You start skimming through the manual...</p>
	<iframe width='100%' height='97%' onload="pageloaded(this)" src="[##wikiurl]/[##link_identifier]?printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
	</body>
	</html>
	"}

// A book that links to the wiki
/obj/item/book/manual/wiki
	dat = "Nanotrasen presently does not have any resources on this topic. If you would like to know more, contact your local Central Command representative." // safety
	/// The ending URL of the page that we link to.
	var/page_link = ""

/obj/item/book/manual/wiki/display_content(mob/living/user)
	var/wiki_url = CONFIG_GET(string/wikiurl)
	if(!wiki_url)
		//user.balloon_alert(user, "this book is empty!")
		to_chat(user, "this book is empty!")
		return

	//credit_book_to_reader(user)
	DIRECT_OUTPUT(user, browse(WIKI_PAGE_IFRAME(wiki_url, page_link), "window=manual;size=[BOOK_WINDOW_BROWSE_SIZE]")) // if you change this GUARANTEE that it works.

/obj/item/book/manual/wiki/engineering_construction
	name = "Station Repairs and Construction"
	icon_state ="bookEngineering"
	item_state = "book3"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Station Repairs and Construction"

	page_link = "Guide_to_Construction"

/obj/item/book/manual/wiki/engineering_hacking
	name = "Hacking"
	icon_state ="bookHacking"
	item_state = "book2"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Hacking"

	page_link = "Hacking"

/obj/item/book/manual/wiki/robotics_manual
	name = "Guide to Robotics"
	icon_state ="evabook"
	item_state = "book3"
	author = "Simple Robotics"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Guide to Robotics"

	page_link = "Guide_to_Robotics"

/obj/item/book/manual/wiki/security_space_law
	name = "Corporate Regulations"
	desc = "A set of corporate guidelines for keeping law and order on privately-owned space stations."
	icon_state = "bookSpaceLaw"
	item_state = "book13"
	author = "The Company"
	title = "Corporate Regulations"

	page_link = "Corporate_Regulations"

/obj/item/book/manual/wiki/medical_diagnostics_manual
	name = "Medical Diagnostics Manual"
	desc = "First, do no harm. A detailed medical practitioner's guide."
	icon_state = "bookMedical"
	item_state = "book12"
	author = "Medical Department"
	title = "Medical Diagnostics Manual"

/obj/item/book/manual/wiki/medical_diagnostics_manual/display_content(mob/living/user)
	var/wiki_url = CONFIG_GET(string/wikiurl)
	if(!wiki_url)
		//user.balloon_alert(user, "this book is empty!")
		to_chat(user, "this book is empty!")
		return

	var/dat = {"<html>
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
				<br>
				<h1>The Oath</h1>

				<i>The Medical Oath sworn by recognised medical practitioners in the employ of [using_map.company_name]</i><br>

				<ol>
					<li>Now, as a new doctor, I solemnly promise that I will, to the best of my ability, serve humanity-caring for the sick, promoting good health, and alleviating pain and suffering.</li>
					<li>I recognise that the practice of medicine is a privilege with which comes considerable responsibility and I will not abuse my position.</li>
					<li>I will practise medicine with integrity, humility, honesty, and compassion-working with my fellow doctors and other colleagues to meet the needs of my patients.</li>
					<li>I shall never intentionally do or administer anything to the overall harm of my patients.</li>
					<li>I will not permit considerations of gender, race, religion, political affiliation, sexual orientation, nationality, or social standing to influence my duty of care.</li>
					<li>I will oppose policies in breach of human rights and will not participate in them. I will strive to change laws that are contrary to my profession's ethics and will work towards a fairer distribution of health resources.</li>
					<li>I will assist my patients to make informed decisions that coincide with their own values and beliefs and will uphold patient confidentiality.</li>
					<li>I will recognise the limits of my knowledge and seek to maintain and increase my understanding and skills throughout my professional life. I will acknowledge and try to remedy my own mistakes and honestly assess and respond to those of others.</li>
					<li>I will seek to promote the advancement of medical knowledge through teaching and research.</li>
					<li>I make this declaration solemnly, freely, and upon my honour.</li>
				</ol><br>

				<HR COLOR="steelblue" WIDTH="60%" ALIGN="LEFT">

				<iframe width='100%' height='100%' src="[wiki_url]Guide_to_Medicine&printable=yes&removelinks=1" frameborder="0" id="main_frame"></iframe>
				</body>
			</html>

		"}

	//credit_book_to_reader(user)
	DIRECT_OUTPUT(user, browse(dat, "window=manual;size=[BOOK_WINDOW_BROWSE_SIZE]")) // if you change this GUARANTEE that it works.

/obj/item/book/manual/wiki/engineering_guide
	name = "Engineering Textbook"
	icon_state ="bookEngineering2"
	item_state = "book3"
	author = "Engineering Encyclopedia"
	title = "Engineering Textbook"

	page_link = "Guide_to_Engineering"
