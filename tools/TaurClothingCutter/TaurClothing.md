This small Byond program takes all the icons in SpritesToSnip.dmi, 
cuts them using all the icons in Taur_Cutter.dmi, and produces a file save
dialog for you to download the resulting DMI.

Useful for cutting up species sprites from full body ones. Or whatever else.

--Arokha/Aronai


-- Hijacked by Poojawa to facilitate easier sprite porting -> tauric sprites. 

Taur suits have been divided into three different categories: Coats, Dresses, and fullsuits. These are found in suitstocovert folders. Please adhere to the general sorting that's been done already when adding new clothing.

Standard folder contains the sprites compatible with Wolf, Fox, Horse, Cow, Deer, Lizard, Skunk, Red Panda (Wah), Sergal, and Feline bodies. For Otie, 'Goia, Noodle, Drake, and Rat bodies, these body types require the 'Long' sprite variants that look absolutely fucking awful if further stretched in the base sprites. If you're doing Otie specific, you'll want to copy/paste the north facing version from your short body sprites onto the long body one. Otie's north facing isn't as tall as rat or noodle's are, so that'll be a thing. 

Currently the only body types the sprites are really designed for are ones based off of the Canine, Feline, and to some extent lizard bodies. The fat versions of sprites have a special sock overlay and don't need to be custom edited unless the legs themselves are changed. All other sprites theoretically can be used, but will take significant work to bueautify them. See more with the unsuitable note below

There's taur templates of each type too found in the Taur Templates folder, Most of them have a large purple mask applied for special exceptions of suits that 'spill over' the human sprite (Imperium Monk robe, Wedding gown, etc), Everything inside of this mask and the sprite itself will be used to 'snip out' the needed pixels, so keep that in mind! Copy and paste each species template sprites into their respective <type>Cutter.dmi. Only one at a time! Each of CoatCutter, DressCutter, SuitCutter should have the one species inside of it, so Wolf, Wolf, Wolf. Etc.

Also included in this folder are two png templates for your preferred sprite editing software. Save time by seeing exactly where the stray pixels are in each body! This saves SO MUCH TIME.

In Dreammaker -> Build -> Compile and Run -> Cut <Type>. The default for Cut Suits is taursuit_.dmi so you can save your species in as taursuit_[species] and go. Cut Dresses and Cut Coats will save into their own files. Long Cut is the same, it just uses the long subfolder instead of the standard one. 

Once all three are done, please ensure to combine them all into your species specific dmi, Preferrably Suits + Coats + Dresses for consistency in sorting. Remember to close the client when you're done! You won't be able to recompile the cutter in dream maker otherwise. That's the solution to 'x.dmi cannot be found' errors. Bedsheet.dmi is seperate because it's so goofy oversized that it works as a one-size fits all, so just copy that in after you paste the dresses in. 

If the species is in taursuits_unsuitable.dmi then they won't get the benefits of these suit cutters. That'll take changing in their sprite_accessories_taur.dm listing. It's an all-or-nothing type overhaul, so you'll need every listed suit in that species' suit file. Yes I'm aware of how daunting it is. Fortunately the "sock" template for them can be used to get a reasonable head start, but you'll still be suffering from a lot of work to fix each non standard body. Each Taur body is a little over 400 seperate suit icons, with 4 states each totalling around 1,600 suit icons each, multiplied by however many animation frames in the icon as well (The nasa suit is 16 total, the comic coat is 48 !!). Of course, a fourth of those are just flipped East/West facing, so you're *only* having do deal with ~1,200 of 'em!

In addition to this, tails are given socks as well, so you don't need to model them, just make sure the tail's added! It will overlay over the suit icon if applicable, for space suits and the like. 

Cut Taurs is if you're just doing a limited run of one suit type icon, you can throw all the relevant species into the relevant cutter, the resulting file will contain all tauric versions of your clothing item after cutout. Avoid doing this with the major ones. You will never be able to sort them out with any sanity! 

If You're porting a new taur entirely:
Be sure to add pixel padding, the assembled human sprite has some. The purple outline is the padding. This accounts for stuff like armor vests or heavier coats/suits. You'll want enough clothing pixels to work with to follow up and edit!

It would be helpful if you 'build' a four directional template sprite for use as an overlay for alignment as well, just export a template as a png! Some taur bodies have weird spine positions, or legs that stick out a bit too much, etc. It is what it is. 