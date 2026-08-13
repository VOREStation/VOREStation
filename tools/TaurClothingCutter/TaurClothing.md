This small Byond program takes all the icons in SpritesToSnip.dmi,
cuts them using all the icons in Taur_Cutter.dmi, and produces a file save
dialog for you to download the resulting DMI.

Useful for cutting up species sprites from full body ones. Or whatever else.

--Arokha/Aronai

-- Hijacked by Poojawa to facilitate easier sprite porting -> tauric sprites.

# Introduction

Taur suits have been divided into three different categories: Coats, Dresses, and fullsuits. These are found in suitstocovert folders. Please adhere to the general sorting that's been done already when adding new clothing.

Standard body types: Wolf, Fox, Feline, Lizard, RedPanda, Sergal, Skunk, Deer, Horse, Cow, "sotie" (Otie North facing), And Husky.
"Long" body types: Noodle, Rat, Zorgoia, Drake, Otie (South/East/West facings), Bunny, Scoli, and Sloog.

We have to have two different sprite sheets due to how drastic those body shapes are, but these all also follow the overall pattern.

If you're doing Otie specific, you'll want to copy/paste the north facing version from your short body sprites onto the long body one. Otie's north facing isn't as tall as rat or noodle's are, so that'll be a thing. This applies to any other body types that are just long but low.

All taur bodies unlisted above are considered "Unsuitable" because of the nature of said body (Slug, tree roots, giant spiders) just aren't compatible or sensible to cover in suit plating. They will default to the "old" behavior of clipmask snipping the human half out and a colorable sock will be added automatically.

Speaking of clip masking; There's taur templates of each type too found in the Taur Templates folder, Most of them have a large purple mask applied for special exceptions of suits that 'spill over' the human sprite (Imperium Monk robe, Wedding gown, etc), Everything inside of this mask and the sprite itself will be used to 'snip out' the needed pixels, so keep that in mind!

Also included in this folder are two png templates for your preferred sprite editing software. Save time by seeing exactly where the stray pixels are in each body! Aseprite users, https://github.com/spacestation13/aseprite-dmi/releases 2.0+ preserves dmi info now, it's so good.

# Actually Setting Things Up

In Dreammaker -> Build -> Compile and Run -> Cut <Type>

Cut Standard and Long Cut perform batch actions of the ENTIRE sprite sheets located in suitstoconvert/long or standard. You simply just need to accept the prompts to save the outputs. Dress and Coats save seperately. Remember to close the client when you're done!

Once all three are done, please ensure to combine them all into the specific taursuit_[species].dmi, Preferrably Suits + Coats + Dress + Bedsheet for consistency in sorting.

Suit_flares.dmi contains a quick copy-and-paste addition to add longer capes for certain types of coats/dresses. If you add a new type of cloak that seems to get trimmed off, just add it here so it can be copy/pasted to each.

Bedsheet.dmi contains the copy/paste costume that will totally absolutely hide your taur butt. yup!!

Cut Single will trim a specific single outfit located in, well, singleoutfit.dmi.

# Additional Notes

You can use the Single outfit cutter to masscut any sprites, not just the tauric ones. doing things like hole-punching with hands or trimming legs for digitigrade, etc. You're welcome <3

Taur bodies do not need their tails sprited onto suits anymore. You do not have to sprite tails onto human mobs either! The tail sock system will do the heavy lifting for these aspects on their own. It's absolutely wonderful like that.

Each Taur body is a about 440 seperate suit icons, with 4 states each at the time of this tool's implimentation. That's 1760 sprites per page!

Or well it would if you didn't have to take a few of those and multiply the total amount by however many animation frames in the icon as well. The nasa suit is 16 total, Techpriest and Cosmic coats are 42 (24x2 with hoods), etc . ~ 1900 sprites Each! Of course, a fourth of those are just flipped East/West facing, so you're _only_ having do deal with 1425 for the most part. Honk

If You're adding a new taur entirely:
Be sure to add pixel padding, the assembled human sprites have some. The purple outline is the padding. This accounts for stuff like armor vests or heavier coats/suits. You'll want enough clothing pixels to work with to follow up and edit! Suits should be reasonably skin tight. Coats should be looser, and dresses trailing to the floor.
