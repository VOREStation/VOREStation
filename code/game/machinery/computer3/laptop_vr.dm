/obj/machinery/computer3/laptop/survival
	name = "Survival Laptop"
	desc = "A clamshell portable computer. It is open. This one is a more durable survival model, with longer battery life."
	default_prog = /datum/file/program/welcome

/obj/machinery/computer3/laptop/survival/New(var/L, var/built = 0)
	if(!built && !battery)
		battery = new /obj/item/weapon/cell/apc(src)
	..(L,built)
