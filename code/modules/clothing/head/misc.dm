/obj/item/clothing/head/centhat
	name = "\improper CentCom. hat"
	icon_state = "centcom"
	desc = "It's good to be emperor."
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/centhat/customs
	name = "Customs Hat"
	desc = "A formal hat for SolGov Customs Officers."
	icon_state = "customshat"

/obj/item/clothing/head/halo
	name = "halo"
	desc = "a small metal ring, floating above it's wearer."
	icon_state = "halo"
	
/obj/item/clothing/head/pin
	icon_state = "pin"
	addblends = "pin_a"
	name = "hair pin"
	desc = "A nice hair pin."
	slot_flags = SLOT_HEAD | SLOT_EARS
	body_parts_covered = 0
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/clothing/head/pin/pink
	icon_state = "pinkpin"
	addblends = null
	name = "pink hair hat"

/obj/item/clothing/head/pin/clover
	icon_state = "cloverpin"
	name = "clover pin"
	addblends = null
	desc = "A hair pin in the shape of a clover leaf."

/obj/item/clothing/head/pin/butterfly
	icon_state = "butterflypin"
	name = "butterfly pin"
	addblends = null
	desc = "A hair pin in the shape of a bright blue butterfly."

/obj/item/clothing/head/pin/magnetic
	icon_state = "magnetpin"
	name = "magnetic 'pin'"
	addblends = null
	desc = "Finally, a hair pin even a Morpheus chassis can use."
	matter = list(MAT_STEEL = 10)

/obj/item/clothing/head/pin/flower
	name = "red flower pin"
	icon_state = "hairflower"
	addblends = null
	desc = "Smells nice."

/obj/item/clothing/head/pin/flower/blue
	icon_state = "hairflower_blue"
	name = "blue flower pin"

/obj/item/clothing/head/pin/flower/pink
	icon_state = "hairflower_pink"
	name = "pink flower pin"

/obj/item/clothing/head/pin/flower/yellow
	icon_state = "hairflower_yellow"
	name = "yellow flower pin"

/obj/item/clothing/head/pin/flower/violet
	icon_state = "hairflower_violet"
	name = "violet flower pin"

/obj/item/clothing/head/pin/flower/orange
	icon_state = "hairflower_orange"
	name = "orange flower pin"

/obj/item/clothing/head/pin/flower/white
	icon_state = "hairflower_white"
	addblends = "hairflower_white_a"
	name = "flower pin"

/obj/item/clothing/head/pin/bow
	icon_state = "bow"
	addblends = "bow_a"
	name = "hair bow"
	desc = "A ribbon tied into a bow with a clip on the back to attach to hair."
	item_state_slots = list(slot_r_hand_str = "pill", slot_l_hand_str = "pill")

/obj/item/clothing/head/pin/bow/big
	icon_state = "whiteribbon"
	name = "ribbon"

/obj/item/clothing/head/pin/bow/big/red
	icon_state = "redribbon"
	name = "red ribbon"
	addblends = null

/obj/item/clothing/head/powdered_wig
	name = "powdered wig"
	desc = "A powdered wig."
	icon_state = "pwig"

/obj/item/clothing/head/redcoat
	name = "redcoat's hat"
	icon_state = "redcoat"
	item_state_slots = list(slot_r_hand_str = "pirate", slot_l_hand_str = "pirate")
	desc = "<i>'I guess it's a redhead.'</i>"
	body_parts_covered = 0

/obj/item/clothing/head/mailman
	name = "station cap"
	icon_state = "mailman"
	item_state_slots = list(slot_r_hand_str = "hopcap", slot_l_hand_str = "hopcap")
	desc = "<i>Choo-choo</i>!"
	body_parts_covered = 0

/obj/item/clothing/head/plaguedoctorhat
	name = "plague doctor's hat"
	desc = "These were once used by Plague doctors, allegedly. They're pretty much useless."
	icon_state = "plaguedoctor"
	item_state_slots = list(slot_r_hand_str = "tophat", slot_l_hand_str = "tophat")
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/plaguedoctorhat/gold
	name = "golden plague doctor's hat"
	desc = "These were once used by plague doctors, allegedly. This one has gold accents."
	icon_state = "plaguedoctor2"

/obj/item/clothing/head/hasturhood
	name = "hastur's hood"
	desc = "It's unspeakably stylish"
	icon_state = "hasturhood"
	item_state_slots = list(slot_r_hand_str = "enginering_beret", slot_l_hand_str = "enginering_beret")
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/nursehat
	name = "nurse's hat"
	desc = "It allows quick identification of trained medical personnel."
	icon_state = "nursehat"
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/syndicatefake
	name = "red space-helmet replica"
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black-red", slot_l_hand_str = "syndicate-helm-black-red")
	icon_state = "syndicate"
	desc = "A plastic replica of a bloodthirsty mercenary's space helmet, you'll look just like a real murderous criminal operative in this! This is a toy, it is not made for use in space!"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	siemens_coefficient = 2.0
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/cueball
	name = "cueball helmet"
	desc = "A large, featureless white orb mean to be worn on your head. How do you even see out of this thing?"
	icon_state = "cueball"
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/greenbandana
	name = "green bandana"
	desc = "It's a green bandana with some fine nanotech lining."
	icon_state = "greenbandana"
	flags_inv = 0
	body_parts_covered = 0

/obj/item/clothing/head/cardborg
	name = "cardborg helmet"
	desc = "A helmet made out of a box."
	icon_state = "cardborg_h"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = HEAD|FACE|EYES
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/clothing/head/justice
	name = "justice hat"
	desc = "fight for what's righteous!"
	icon_state = "justicered" //Does this even exist?
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/justice/blue
	icon_state = "justiceblue"

/obj/item/clothing/head/justice/yellow
	icon_state = "justiceyellow"

/obj/item/clothing/head/justice/green
	icon_state = "justicegreen"

/obj/item/clothing/head/justice/pink
	icon_state = "justicepink"

/obj/item/clothing/head/rabbitears
	name = "rabbit ears"
	desc = "Wearing these makes you looks useless, and only good for your sex appeal."
	icon_state = "bunny"
	body_parts_covered = 0

/obj/item/clothing/head/flatcap
	name = "flat cap"
	desc = "A working man's cap."
	icon_state = "flat_cap"
	item_state_slots = list(slot_r_hand_str = "detective", slot_l_hand_str = "detective")
	siemens_coefficient = 0.9 //...what?

/obj/item/clothing/head/flatcap/grey
	icon_state = "flat_capw"
	addblends = "flat_capw_a"
	item_state_slots = list(slot_r_hand_str = "greysoft", slot_l_hand_str = "greysoft")

/obj/item/clothing/head/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"
	body_parts_covered = 0

/obj/item/clothing/head/hgpiratecap
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "hgpiratecap"
	item_state_slots = list(slot_r_hand_str = "hoscap", slot_l_hand_str = "hoscap")
	body_parts_covered = 0

/obj/item/clothing/head/bandana
	name = "pirate bandana"
	desc = "Yarr."
	icon_state = "bandana"
	item_state_slots = list(slot_r_hand_str = "redbandana", slot_l_hand_str = "redbandana")

/obj/item/clothing/head/witchwig
	name = "witch costume wig"
	desc = "Eeeee~heheheheheheh!"
	icon_state = "witch"
	flags_inv = BLOCKHAIR
	siemens_coefficient = 2.0

/obj/item/clothing/head/chicken
	name = "chicken suit head"
	desc = "Bkaw!"
	icon_state = "chickenhead"
	flags_inv = BLOCKHAIR
	siemens_coefficient = 0.7
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/bearpelt
	name = "bear pelt hat"
	desc = "Fuzzy."
	icon_state = "bearpelt"
	item_state_slots = list(slot_r_hand_str = "beret_black", slot_l_hand_str = "beret_black")
	flags_inv = BLOCKHAIR
	siemens_coefficient = 0.7

/obj/item/clothing/head/xenos
	name = "xenos helmet"
	icon_state = "xenos"
	item_state_slots = list(slot_r_hand_str = "xenos_helm", slot_l_hand_str = "xenos_helm")
	desc = "A helmet made out of chitinous alien hide."
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	siemens_coefficient = 2.0
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/philosopher_wig
	name = "natural philosopher's wig"
	desc = "A stylish monstrosity unearthed from Earth's Renaissance period. With this most distinguish'd wig, you'll be ready for your next soiree!"
	icon_state = "philosopher_wig"
	item_state_slots = list(slot_r_hand_str = "pwig", slot_l_hand_str = "pwig")
	flags_inv = BLOCKHAIR
	siemens_coefficient = 2.0 //why is it so conductive?!
	body_parts_covered = 0

/obj/item/clothing/head/orangebandana //themij: Taryn Kifer
	name = "orange bandana"
	desc = "An orange piece of cloth, worn on the head."
	icon_state = "orange_bandana"
	body_parts_covered = 0

/obj/item/clothing/head/hijab
	name = "hijab"
	desc = "A veil that is wrapped to cover the head and chest"
	icon_state = "hijab"
	addblends = "hijab_a"
	item_state_slots = list(slot_r_hand_str = "beret_white", slot_l_hand_str = "beret_white")
	body_parts_covered = 0
	flags_inv = BLOCKHAIR

/obj/item/clothing/head/kippa
	name = "kippa"
	desc = "A small, brimless cap."
	icon_state = "kippa"
	addblends = "kippa_a"
	body_parts_covered = 0

/obj/item/clothing/head/turban
	name = "turban"
	desc = "A cloth used to wind around the head"
	icon_state = "turban"
	addblends = "turban_a"
	item_state_slots = list(slot_r_hand_str = "beret_white", slot_l_hand_str = "beret_white")
	body_parts_covered = 0
	flags_inv = BLOCKHEADHAIR

/obj/item/clothing/head/taqiyah
	name = "taqiyah"
	desc = "A short, rounded skullcap usually worn for religious purposes."
	icon_state = "taqiyah"
	addblends = "taqiyah_a"
	item_state_slots = list(slot_r_hand_str = "taq", slot_l_hand_str = "taq")

/obj/item/clothing/head/beanie
	name = "beanie"
	desc = "A head-hugging brimless winter cap. This one is tight."
	icon_state = "beanie"
	addblends = "beanie_a"
	body_parts_covered = 0

/obj/item/clothing/head/beanie_loose
	name = "loose beanie"
	desc = "A head-hugging brimless winter cap. This one is loose."
	icon_state = "beanie_hang"
	addblends = "beanie_hang_a"
	body_parts_covered = 0

/obj/item/clothing/head/beretg
	name = "beret"
	desc = "A beret, an artists favorite headwear."
	icon_state = "beret_g"
	addblends = "beret_g_a"
	body_parts_covered = 0

/obj/item/clothing/head/sombrero
	name = "sombrero"
	desc = "A wide-brimmed hat popularly worn in Mexico."
	icon_state = "sombrero"
	body_parts_covered = 0

/obj/item/clothing/head/headband/maid
	name = "maid headband"
	desc = "Keeps hair out of the way for important... jobs."
	icon_state = "maid"
	body_parts_covered = 0

/obj/item/clothing/head/maangtikka
	name = "maang tikka"
	desc = "A jeweled headpiece originating in India."
	icon_state = "maangtikka"
	body_parts_covered = 0
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/clothing/head/jingasa
	name = "jingasa"
	desc = "A wide, flat rain hat originally from Japan."
	icon_state = "jingasa"
	body_parts_covered = 0
	item_state_slots = list(slot_r_hand_str = "taq", slot_l_hand_str = "taq")

/obj/item/clothing/head/cowl
	name = "black cowl"
	desc = "A gold-lined black cowl. It gives off uncomfortable cult vibes, but fancy."
	icon_state = "cowl"
	body_parts_covered = 0

/obj/item/clothing/head/cowl
	name = "white cowl"
	desc = "A gold-lined white cowl. It gives off uncomfortable cult vibes, but fancy."
	icon_state = "whitecowl"
	body_parts_covered = 0

/obj/item/clothing/head/blackngoldheaddress
	name = "black and gold headdress"
	desc = "An odd looking headdress that covers the eyes."
	icon_state = "blackngoldheaddress"
	flags_inv = HIDEEYES
	body_parts_covered = HEAD|EYES

//Corporate Berets

/obj/item/clothing/head/beret/corp/saare
	name = "\improper SAARE beret"
	desc = "A red beret denoting service with Stealth Assault Enterprises. For mercenaries that are more inclined towards style than safety."
	icon_state = "beret_red"

/obj/item/clothing/head/beret/corp/saare/officer
	name = "\improper SAARE officer beret"
	desc = "A red beret with a gold insignia, denoting senior service with Stealth Assault Enterprises. For mercenaries who are more inclined towards style than safety."
	icon_state = "beret_redgold"

/obj/item/clothing/head/beret/corp/pcrc
	name = "\improper PCRC beret"
	desc = "A black beret with a PCRC logo insignia, denoting service with Proxima Centauri Risk Control. For private security personnel that are more inclined towards style than safety."
	icon_state = "beret_black_observatory"


/obj/item/clothing/head/beret/corp/hedberg
	name = "\improper Hedberg-Hammarstrom beret"
	desc = "A tan beret denoting service with Hedberg-Hammarstrom private security. For mercenaries who are more inclined towards style than safety."
	icon_state = "beret_tan"

/obj/item/clothing/head/beret/corp/xion
	name = "\improper Xion beret"
	desc = "An orange beret denoting employment with Xion Manufacturing. For personnel that are more inclined towards style than safety."
	icon_state = "beret_orange"

//Stylish Hats

/obj/item/clothing/head/bowler
	name = "bowler hat"
	desc = "Gentleman, elite aboard!"
	icon_state = "bowler"
	item_state_slots = list(slot_r_hand_str = "tophat", slot_l_hand_str = "tophat")
	body_parts_covered = 0

/obj/item/clothing/head/that
	name = "top-hat"
	desc = "It's an amish looking hat."
	icon_state = "tophat"
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/beaverhat
	name = "beaver hat"
	desc = "Soft felt makes this hat both comfortable and elegant."
	icon_state = "beaver_hat"
	item_state_slots = list(slot_r_hand_str = "tophat", slot_l_hand_str = "tophat")
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/boaterhat
	name = "boater hat"
	desc = "The ultimate in summer fashion."
	icon_state = "boater_hat"
	item_state_slots = list(slot_r_hand_str = "tophat", slot_l_hand_str = "tophat")
	body_parts_covered = 0

/obj/item/clothing/head/fedora
	name = "fedora"
	icon_state = "fedora_grey"
	desc = "A sharp, stylish hat that's grey in color."
	item_state_slots = list(slot_r_hand_str = "detective", slot_l_hand_str = "detective")
	body_parts_covered = 0

/obj/item/clothing/head/fedora/brown
	desc = "A brown fedora. Perfect for detectives or those trying to pilfer artifacts."
	icon_state = "fedora_brown"
	allowed = list(/obj/item/weapon/reagent_containers/food/snacks/candy_corn, /obj/item/weapon/pen)

/obj/item/clothing/head/fedora/white
	desc = "A white fedora, really cool hat if you're a mobster. A really lame hat if you're not."
	icon_state = "fedora_white"

/obj/item/clothing/head/fedora/beige
	desc = "A beige fedora. Either the cornerstone of a reporter's style or a poor attempt at looking cool. Depends on the person wearing it."
	icon_state = "fedora_beige"

/obj/item/clothing/head/fedora/panama
	desc = "A fancy, cream colored fedora. Columbian pure."
	icon_state = "fedora_panama"

/obj/item/clothing/head/trilby
	name = "trilby"
	icon_state = "trilby"
	item_state_slots = list(slot_r_hand_str = "detective", slot_l_hand_str = "detective")
	desc = "M'lady"

/obj/item/clothing/head/trilby/feather
	name = "feather trilby"
	icon_state = "feather_trilby"
	item_state_slots = list(slot_r_hand_str = "detective", slot_l_hand_str = "detective")
	desc = "A sharp, stylish hat with a feather."

/obj/item/clothing/head/fez
	name = "fez"
	icon_state = "fez"
	desc = "You should wear a fez. Fezzes are cool."

//Cowboy Hats

/obj/item/clothing/head/cowboy
	name = "cowboy hat"
	desc = "For those that have spurs that go jingle jangle jingle."
	icon_state = "cowboy_1"
	body_parts_covered = 0

/obj/item/clothing/head/cowboy/rattan
	name = "rattan cowboy hat"
	desc = "Made from the same straw harvested from the fields."
	icon_state = "cowboy_2"

/obj/item/clothing/head/cowboy/dark
	name = "dark cowboy hat"
	desc = "Protect yer head in this new frontier."
	icon_state = "cowboy_3"

/obj/item/clothing/head/cowboy/ranger
	name = "ranger cowboy hat"
	desc = "Feel the western vibe from this good ol' classic."
	icon_state = "cowboy_4"

/obj/item/clothing/head/cowboy/rustler
	name = "rustler cowboy hat"
	desc = "Rustle up some of that there cattle bucko."
	icon_state = "cowboy_5"

/obj/item/clothing/head/cowboy/black
	name = "black cowboy hat"
	desc = "Perfect for the budding tram robber."
	icon_state = "cowboy_7"

/obj/item/clothing/head/cowboy/fancy
	name = "fancy cowboy hat"
	desc = "Premium black leather had with a rattlesnake hatband to top the ensemble."
	icon_state = "cowboy_8"

/obj/item/clothing/head/cowboy/wide
	name = "wide-brimmed cowboy hat"
	desc = "Because justice isn't going to dispense itself."
	icon_state = "cowboy_6"

/obj/item/clothing/head/cowboy/bandit
	name = "bandit cowboy hat"
	desc = "You can almost hear the old western music."
	icon_state = "cowboy_9"

/obj/item/clothing/head/cowboy/small
	name = "small cowboy hat"
	desc = "For the tiniest of cowboys."
	icon_state = "cowboy_small"

/obj/item/clothing/head/wheat
	name = "straw hat"
	desc = "It's a hat made from synthetic straw. Brought to you by \"Country Girls LLC.\" the choice brand for the galaxy's working class."
	icon_state = "wheat"

//Ruin Marine (Doom Marine)
/obj/item/clothing/head/marine
	name = "marine helmet"
	desc = "A marine helmet prop from the popular game 'Ruin'."
	icon_state = "marine"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES

//Laser Tag Helmets
/obj/item/clothing/head/bluetag
	name = "blue laser tag helmet"
	desc = "Blue Pride, Station Wide."
	icon_state = "bluetag"
	flags_inv = HIDEEARS|BLOCKHEADHAIR
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/redtag
	name = "red laser tag helmet"
	desc = "Reputed to go faster."
	icon_state = "redtag"
	flags_inv = HIDEEARS|BLOCKHEADHAIR
	body_parts_covered = HEAD|EYES
