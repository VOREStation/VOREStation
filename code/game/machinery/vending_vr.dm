/obj/machinery/vending/hydroseeds
	products = list(/obj/item/seeds/bananaseed = 3,/obj/item/seeds/berryseed = 3,/obj/item/seeds/carrotseed = 3,/obj/item/seeds/chantermycelium = 3,/obj/item/seeds/chiliseed = 3,
					/obj/item/seeds/cornseed = 3, /obj/item/seeds/eggplantseed = 3, /obj/item/seeds/potatoseed = 3, /obj/item/seeds/replicapod = 3,/obj/item/seeds/soyaseed = 3,
					/obj/item/seeds/sunflowerseed = 3,/obj/item/seeds/tomatoseed = 3,/obj/item/seeds/towermycelium = 3,/obj/item/seeds/wheatseed = 3,/obj/item/seeds/appleseed = 3,
					/obj/item/seeds/poppyseed = 3,/obj/item/seeds/sugarcaneseed = 3,/obj/item/seeds/ambrosiavulgarisseed = 3,/obj/item/seeds/peanutseed = 3,/obj/item/seeds/whitebeetseed = 3,/obj/item/seeds/watermelonseed = 3,/obj/item/seeds/lavenderseed = 3,/obj/item/seeds/limeseed = 3,
					/obj/item/seeds/lemonseed = 3,/obj/item/seeds/orangeseed = 3,/obj/item/seeds/grassseed = 3,/obj/item/seeds/cocoapodseed = 3,/obj/item/seeds/plumpmycelium = 2,
					/obj/item/seeds/cabbageseed = 3,/obj/item/seeds/grapeseed = 3,/obj/item/seeds/pumpkinseed = 3,/obj/item/seeds/cherryseed = 3,/obj/item/seeds/plastiseed = 3,/obj/item/seeds/riceseed = 3,/obj/item/seeds/shrinkshroom = 3,/obj/item/seeds/megashroom = 3)

/obj/machinery/vending/security
	req_access = list(access_security)
	products = list(/obj/item/weapon/handcuffs = 8,/obj/item/weapon/grenade/flashbang = 4,/obj/item/device/flash = 5,
					/obj/item/weapon/reagent_containers/food/snacks/donut/normal = 12,/obj/item/weapon/storage/box/evidence = 6,
					/obj/item/weapon/gun/energy/taser = 8,/obj/item/weapon/gun/energy/stunrevolver = 4,
					/obj/item/weapon/reagent_containers/spray/pepper = 6,/obj/item/taperoll/police = 6)

/obj/machinery/vending/tool
	products = list(/obj/item/stack/cable_coil/random = 10,/obj/item/weapon/crowbar = 5,/obj/item/weapon/weldingtool = 3,/obj/item/weapon/wirecutters = 5,
					/obj/item/weapon/wrench = 5,/obj/item/device/analyzer = 5,/obj/item/device/t_scanner = 5,/obj/item/weapon/screwdriver = 5,
					/obj/item/device/flashlight/glowstick = 3, /obj/item/device/flashlight/glowstick/red = 3, /obj/item/device/flashlight/glowstick/blue = 3,
					/obj/item/device/flashlight/glowstick/orange =3, /obj/item/device/flashlight/glowstick/yellow = 3, /obj/item/weapon/reagent_containers/spray/windowsealant = 5)

/*
	var/list/log = list()
	var/req_log_access = access_armory

/obj/machinery/vending/security/vend(datum/stored_item/vending_product/R, mob/user)
	if (..())
		if(user.GetIdCard())
			var/obj/item/weapon/card/id/tempid = user.GetIdCard()
			var/list/list_item = list()
			list_item += tempid.registered_name
			list_item += stationtime2text()
			list_item += R.item_name
			log[++log.len] = list_item

/obj/machinery/vending/security/proc/show_log(mob/user as mob)
	if(user.GetIdCard())
		var/obj/item/weapon/card/id/tempid = user.GetIdCard()
		if(req_log_access in tempid.GetAccess())
			var/datum/browser/popup = new(user, "vending_log", "Vending Log", 700, 500)
			var/dat = ""
			dat += "<center><span style='font-size:24pt'><b>SecTech Vending Log</b></span></center>"
			dat += "<center><span style='font-size:16pt'>Welcome [user.name]!</span></center><br>"
			dat += "<span style='font-size:8pt'>Below are the recent vending logs for your vending machine.</span><br>"
			for(var/i in log)
				dat += json_encode(i)
				dat += ";<br>"
			popup.set_content(dat)
			popup.open()
	else
		to_chat(user,"<span class='warning'>You do not have the required access to view the vending logs for this machine.</span>")

/obj/machinery/vending/security/verb/check_logs()
	set name = "Check Vending Logs"
	set category = "Object"
	set src in oview(1)

	show_log(usr)
*/ //Polaris ported all of this.