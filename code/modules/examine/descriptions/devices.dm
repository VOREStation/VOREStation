/obj/item/device/communicator
	description_info = "This device allows someone to speak to another player sourced from the observer pool, as well as other communicators linked to it.  \
	To use the device, use it in your hand, and it will open an interface with various buttons.  Near the bottom will be a list of devices currently available \
	for you to call, both from communications on the station, and communicators very far away (observers).  To call someone, send a communications request to \
	someone and hope they respond, or receive one yourself and respond to them.  Hanging up is also simple, and is handled in the 'Manage Connections' tab."

	description_fluff = "As a concept, a device that allows long-distance communication has existed for over five hundred years.  A device that can accomplish \
	that while in space, across star systems, and that the consumer can afford and use without training, is much more recent, and is thanks to the backbone \
	that is the Exonet.<br>\
	<br>\
	The Exonet is the predominant interstellar telecomm system, servicing trillions of devices across a large portion of human-controlled space.  \
	It is distributed by a massive network of telecommunication satellites, some privately owned and others owned by the systems’ local governments, \
	that utilize FTL technologies to bounce data between satellites at speeds that would not be possible at sub-light technology.  This communicator \
	uses a protocol called Exonet Protocol Version 2, generally shortened to EPv2.<br>\
	<br>\
	EPv2 is the most common communications protocol in the Exonet, and was specifically designed for it.  It was designed to facilitate communication \
	between any device in a star system, and have the ability to forward interstellar requests at the root node of that system’s Exonet.  \
	It is also built to cope with the reality that the numerous nodes in a system will likely have frequent outages.  The protocol allows for \
	up to 18,446,744,073,709,551,616 unique addresses, one of which is assigned to this device."

	description_antag = "Electromagnetic pulses will cause the device to disconnect all linked communicators.  Turning off the Exonet node at the Telecomms \
	satellite will also accomplish this, but for all communicators on and near the station.  This may be needed to allow for a quiet kill or capture."

/obj/item/device/electronic_assembly/device
	description_info = "This is the guts of a 'device' type electronic assembly, and can either be used in this form or can be used inside of the assembly to \
	allow it to interact with other assembly type devices (igniter, signaler, proximity sensor, etc). This device has unique inputs that allow it to either send \
	or receive pulsed signals from an attached items when inside an electronic assembly device frame (looks not unlike a signaler). Ensure the assembly is closed \
	before placing it inside the frame."

/obj/item/device/assembly/electronic_assembly
	description_info = "This is the casing for the 'device' type of electronic assembly. It behaves like any other 'assembly' type device such as an igniter or signaler \
	and can be attached to others in the same way. Use the 'toggle-open' verb (right click) or a crowbar to pop the electronic device open to add components and close when finished."

/obj/item/device/personal_shield_generator
	description_info = "This is a personal shield generator. Depending on the type, it can either be worn on your backpack slot, your belt slot, or in a rigsuit \
	storage slot. It runs on an internal battery, which is usually self-charging. Some versions come with a gun. To active the shield, click the button in the upper \
	right of the screen, use the 'Toggle Shield' command under your objects tab, or click the device itself while it is on you. Some units come with an active weapon \
	which can be taken out at any time by Alt-clicking the device. If the device requires a cell, a screwdriver can be used. The shield slowly drains charge while \
	active and becomes weaker with each individual strike taken."

	description_fluff = "A relatively new invention, made in a collaboration between Hephaestus Industries and a startup known as Kuznetsova Enterprise in the year \
	2322. Numerous variants of the device have been made for specific tasks, ranging from riot control, mining, biohazard containment, and search and rescue, among \
	others. Most of the devices share the flaw that electrical attacks can easily overload the device and cause a shield failure, encouraging combatants to swap to \
	the use of stun-based electric weaponry when shield generators are in use. Most shield devices are self-charging, running off a micro-nuclear reactor built into \
	the chassis itself, although some variants exist without this capability and can have normal cells inserted into them. Larger units boast the capability of \
	storing a weapon, although without upgraded batteries the usage of said weapon is ill-advised."