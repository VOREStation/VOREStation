/obj/item/weapon/book/manual/standard_operating_procedure
	name = "Standard Operating Procedure"
	desc = "A set of corporate guidelines for keeping space stations running smoothly."
	icon_state = "sop"
	icon = 'icons/obj/library_vr.dmi'
	author = "NanoTrasen"
	title = "Standard Operating Procedure"

/obj/item/weapon/book/manual/standard_operating_procedure/New()
	..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[config.wikiurl]Standard_Operating_Procedure&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/weapon/book/manual/command_guide
	name = "The Chain of Command"
	desc = "A set of corporate guidelines outlining the entire command structure of NanoTrasen from top to bottom."
	icon_state = "commandGuide"
	icon = 'icons/obj/library_vr.dmi'
	author = "Jeremiah Acacius"
	title = "Corporate Regulations"

/obj/item/weapon/book/manual/command_guide/New()
	..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[config.wikiurl]Chain_of_Command&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}