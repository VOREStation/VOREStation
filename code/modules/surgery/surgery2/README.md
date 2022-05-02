# Foreword
This is a Preliminary Design Review. Everything described herein is subject to change, but I (Ater) have expended considerable thought into how I would like the system as a whole to work. Some pieces have been discussed with individuals I feel have useful context on systems involved.
# What is is?
More or less a complete rewrite of the Medical System. Targetting not many user-level changes to the basic procedures, but massive QoL improvements to surgery, and chemistry has a number of changes as fallout.

# Why do we need it?
The code messed with the Honk, and it gets the Bonk.

Our code is really smelly, and a bug with the operating computer prompted me to rewrite surgery. Which, as honestly should be expected of me, snowballed into a huge refactor to support what I want to do. The specific goal is to improve surgery QoL by introducing a radial menu, and expand the organs and chemistry/metabolism systems to allow for more interesting features and gameplay decisions to be implemented in the future.

# How does it work?
## Overview
The basic proposal is that, instead of **organs** tracking all of their wounds internally, wounds are made into distinct objects with the Datum Component System.
Individual wounds can separately process or disable **autohealing**, so one really big, bleeding gash won't get better, but all those scrapes from rolling down the stairs will over time. Different types of wounds can have a variety of qualities, like **broken bones**, **bleeding**, **infection**, etc,.You probably don't want to find them all.
The processing of wounds will be aware of other wounds on the parent organ, but should *not* need to know about wounds on *other organs*. You can do some holder-foo to get there, but that is a bad design practice.

**Open Trade:** I'm considering adding notifications for particular types of wounds to the HUD, so players will get a visual indication that "Hey you're bones are broken" or "you're bleeding". The HUD element itself would only describe the type of injury, but examining it or opening up a tooltip for it might describe the location. This has uses from a QoL perspective, but could make it easier to get healing.

## Surgery
Each **wound** knows of certain **surgical procedures** that can be applied to it (With specific circumstances per-surgery). When you try to do surgery on a human, the organ that you target will start with a few basic surgeries (Like opening an incision), go around to all of its wounds, and collate a list of what surgeries you can actually perform on it, given what you've got in your hand. The organ will also be responsible for handling those basic operations like bandaging 15 wounds at once, and this should have precedence over actually trying to do surgery on Help intent. Because **multi-stage operations**, like mending a broken bone, are a thing, certain wounds may be required to unlock other surgeries to fix the original problem. Certain wounds may also *prevent* operations on other wounds. So if you cut open someone's ribcage to do heart surgery, you can't just forget to put their ribs back in place before closing it up.

Pretty much all of the existing surgery procedures will continue to exist, but the biggest improvement here will be a radial menu to select which operation you want to perform. This will replace the current "priority" system, where certain procedures are always performed over other procedures, and filtering among them is dependent upon very specific circumstances. 

**Open Trade:** The radial menu adds more clicks to actually doing a thing (Though click proximity is kept pretty tight). Should things like bandaging wounds or applying splints be wrapped into the surgical system?

**Open Trade:** New intent? Cleans up this nonsense with help/not-help intents. If you want to do surgery, it is your *intent* to do surgery.

## What about [Other damage type here]?
The changes described above are *entirely* focused on **BRUTE** and **BURN**. They're the two damage types that are most often encountered in surgery, after all, and this whole idea started as a surgery refactor. The four other primary damage types are **TOX** (Toxins), **OXY** (Suffocation), HALLOSS (**Pain**), **CLONELOSS** (`G E N E S`).
### Toxins
**Toxins** represent things being in your body, and especially your blood, that are not supposed to be there. The simplest source is being injected with the extraordinarily *generic* and *descriptive* "toxins" reagent, but the most common instances are *either* **chemical overdoses** OR wounds becoming **infected**.

In the case of "chemicals in your blood", the current system for tracking toxloss makes sense. Damage isn't really targeted to specific organs, so unless we start introducing a lot of things that specifically target [*this organ*], it doesn't make sense to expand upon that.
However, in the case of infected wounds (/sepsis/necrosis), it actually makes more sense to create and track the toxloss on each organ (But having it be tracked by the *organ*, not wounds!). When a wound becomes infected, it creates an "infection" wound. The infection wound has different stages, and causes toxloss only on the infected organ until the last stage, at which point it starts causing massive toxloss to the rest of the body (*Don't let infections reach 100%*).

Because this system is wound-centric, we should pursue an implementation where *organs* track toxloss. The existing sources of system-wide toxins that affect the whole body will have damage distributed across all present organs (and scaled down accordingly). For more information, see the **Bloodstream Metabolism** section.
### Suffocation
**Suffocation** is staying on the body. If your body isn't getting enough oxygen, the damage is system-wide.
Having too much oxyloss could *create wounds* on other parts of the body (Mostly the brain, maybe other internal organs).
### Pain
**Pain** will be tracked by each organ. There isn't really a semantic difference in the pain caused by a single stun-baton whack or ten bruises, but the more you hurt, the longer it takes to stop hurting (Each wound tracking pain separately would make multiple wounds hurt for less time than a single big wound).
Tracking pain on each organ also opens the floor to things like local anesthesia. Such things are out of scope to the work being described by this proposal, but it becomes a possibility.
### Cloneloss
**Cloneloss** is... a weird damage type. It's inflicted by:
* Slimes (They suck out all your delicious DNA... why not the rest of you?)
* Cloning (Generic instability or something?)
* Radiation (If you have enough of it)

And it's not really clear *what* the damage actually *is*. "Body not working right" is already covered by toxloss. Body is physically deteriorating is covered by brute/burn.

It is dumb and it should be removed.

Slimes should inflict wounds that generate burns and toxloss.
Being cloned should inflict that spooky "You got cloned" modifier, but still be treated by cryo. Speaking of cryo...

## Chemistry
Much as the proposal needs special consideration for other damage types that don't as easily fit into this round hole I'm shaping, the entire premise by which **Chemistry** treats injuries needs to be reexamined. The human (mob) body contains a few **reservoirs** for reagents (Bloodstream, stomach), and each Life() tick, those reservoirs metabolize certain amounts of each reagent contained within them. Different reagents are metabolized at different rates, and have different effects when metabolized from the **bloodstream**, from the **stomach**, as well as when contacted via the **skin** or the **lungs**.
### Skin-Contact Metabolism
The most common way of "ingesting" reagents via skin-contact are through specifically prepared **"patches"** (You've probably heard of nicotine patches IRL). You might also **spill** your sulphuric acid beaker all over your pants when you drop it. The common trend here is that **skin-contact** is typically *isolated* to individual external organs. When ingested by this mechanism, reagents may have some effect upon the individual organ doing the ingestion, and a *small* amount will be transmitted to the bloodstream.
### Inhalation Metabolism
There's a very small handful of things that you expect to be inhaling. Oxygen (g), nitrogen (g), and carbon dioxide (g) are mostly **handled by breathing mechanics** (~~Did you remember to say "*exhale"?~~), so we're going to ignore them here (If you actually inject oxygen (g) into your blood, Very Bad Things start happening).
Of more interest are things **airborne chemical agents**, like phoron (g), and **inhaled medicines** (Asthma inhalers IRL). Yes, this will probably have to have some interaction with breathing, but I'm trying to limit the complexity.
Inhaling this stuff may have some effect upon the lungs. Most of the time you just start coughing, and it usually smells terrible. *Most* of the amount will be transmitted into the bloodstream. (Phoron causes burns to the lungs, Dex and Dex+ do most their oxyloss thing *here*, but will still have some effect in the blood)
### Stomach Metabolism
Whenever you swallow a **pill**, it goes here without passing "Go" or collecting $200. Doctors like pills, because they don't have to stab people with needles, but the chemicals in the pills take a bit longer to get into your bloodstream. You can also just **drink reagents** directly!
This may seem like a weird use of the wounds system, but swallowing pills or eating food will actually create a stomach "wound" containing the eaten thing, that *slowly releases the reagents* contained within to your stomach. Drinking things directly sends *all the reagents to your stomach at once*, but your mouth may hate you for it.  (Chemical burns)
When the stomach metabolizes its reagents, they may have some effect upon it (Heart burn, anyone?), and a *moderate* amount of the reagents will be transmitted to the bloodstream.
### Bloodstream Metabolism
This is the part where things get complicated. Some of our reagents **act universally** on the whole body, like bicaridine, to heal injuries everywhere. Others only work on **specific organs**.

Generally speaking, a *little bit* of each reagent get ingested into *every organ*, where they may or may not do a thing to that organ. A *lot* of each reagent gets filtered by your **kidneys** as waste to be expelled from your system (Including blood!). Mechanically, each life tick, each of your organs (Internal and external) *asks* for a certain amount of blood from the body's **bloodstream** (And all the chemicals inside that blood), and *returns* a certain amount of reagents (E.g., blood from bone marrow, or chemicals from the stomach). Different organs may request or return different amounts. If organs receive too much of a particular reagent, it will **Overdose**, triggering effects per-organ, and usually triggering **Toxloss**.
Because your kidneys are responsible for removing most of the reagents from your system, having a lower-than-normal number of kidneys means that both good and bad reagents will affect you for longer. Because your kidneys are independent to the number of bone-containing organs producing blood, **missing limbs** may mean you are destroying more blood than you are creating.  Your body has a limited capacity for *adjusting its blood production/destruction* to account for this, based on the amount of blood each organ receives during its metabolism.
#### Wait what's that about waste?
No, you don't have to use the bathroom every 20 minutes. Reagents filtered by the kidneys will just be deleted.
### Cryo
Thematically, I like **Cryo**. Mechanically, I like the sleeper's concept of **stasis**. Having the two be separate is icky to me.

Cryo engages the stasis system to **reduce the frequency of life ticks** (including wounds and metabolism). Instead, every time the cryo pod processes, it applies its own reagent slurry to the body uniformly. Cryo gets internal coolers, to save power and remove the awkward interface with atmospherics. Cryo chems will probably get a buff.
Sleepers are lesser versions of cryo pods, with more limited stasis options. Their ability to dispense dexalin and dylovene are exported to separate machinery.

Medical will lose their sleepers (Cryo does it but better), and the scattered first aid stations will become "Hey, here's some basic things to treat people, and something to keep them alive longer if you're waiting for medical to get there."

## Cloning & Genetics
I touched on what changes will be here in the Cloneloss section, but to summarize:
* No changes to genetics. That system is incredibly convoluted and touches a wide variety of other systems, and a replacement would be a pretty large project in its own right.
* Cloning will inflict some wounds all over the body, and the "Recently Cloned" modifier. Leaving a clone in the pod for longer will make it healthy faster than stuffing it into a cryo pod. But the cryo pod *can* heal all of the damage inflicted by the cloning process, so it's possible to crank out bodies and get people back into the round faster.
#### The Recently Cloned Modifier
As it exists, it's a fun tax. The intent of it is clear: Prevent medical from cloning people and sending them instantly back into a firefight.
The current effects include health maluses and slowdown. Health maluses mean you die faster if you get back into a fight. Honestly, that should be a pretty good deterrent already. Having slowdown really boils down to you can't move as quickly, so you're easier to click on // hit. Except it affects everyone that gets cloned, and is a huge pain in the ass. I'm proposing we instead add accuracy maluses to the modifier and remove the slowdown, because the goal is to get people back into the round.
As I have noted in a few places, **spending time in a cryo pod will completely remove this modifier** (With appropriate cryo chems). The reason is that spending more time in medical, especially with a black screen, is *also* a form of fun tax. Spending an extra minute or two in cryo is enough of a tax in my opinion. Sleepers, as lesser forms of cryo, will not be able to reach the temperatures required for these chems to work.

## Beep Boop, I Am A Robot
**FBPs** and **synthetic organs** will remain mostly unchanged, beyond the QoL changes to surgery. By giving up their warm flesh for cold, unrelenting steel, prosthetic organs generally have *higher durability*, but a *lower threshold* between *"It's kinda broken"* and *"It's scrap."*
**Brute** and **burn** damage are the most common damage types for synthetics, and since those are the being focused upon by this proposal, the relevant changes are largely inclusive. Synths take **toxin** damage from things like **radiation**, which actually lends itself well to having unpredictable but hard-to-diagnose effects, and requiring time in the recharger pods to properly resolve the errors. Splitting toxloss onto each individual organ means that your irradiated arm may suffer a **rad hit** and start malfunctioning, without necessarily being detrimental to the rest of your body.

The changes to metabolism can't really be fully expanded to prosthetic organs, because those organs may be attached to an FBP, which could *replace blood with oil* in its **bloodstream** reservoir, but they may also be attached to an organic body, and instead get a bunch of **sticky blood**. Probably not the best lubricant.
Instead, synthetic organs will have their own **internal reservoirs** of **oil** that they use for lubrication. If your arm leaks all of its oil, it's not going to work as well.
Having a limb that is *low on oil* will cause damage over time from abnormal wear and tear, and it may occasionally **malfunction** (Similar to a broken bone).

## What about Antags?
These ideas are much more formative. All of them are for the traitor uplink. Technomancers have spells that will be updated for these new mechanics. Changeling's regenerative abilities will be updated for these new mechanics. None of them are finalized, but I do want to expand the tools available to antags, to allow them to better survive fights. Chemical metabolism tends to be slower-acting, but more easily administered. Surgery should be much quicker, but must be separately applied to each limb or injury, and may require some flavor of anesthesia. Cryo is very effective, but requires specialized and power-hungry equipment.
#### Skin Grafts & Armor Plating
The basic premise is a material that can be applied to an external organ to give it a bonus to its armor rating. The bonus may scale with cost. Only one graft/plate should be applicable at a time. Synthetics can probably remove their plating, but organics cannot remove grafts without surgery (If at all).
#### Organ augments
Very broad category for augments to or upgrades for internal organs that make them more efficient/powerful/better. There's... a lot of room for options here, because there's a lot of organs. This does technically include replacements for synthetic organs as well.
#### Autosurgery
A tool that can perform surgical operations on yourself, with much lower risk than just doing it yourself. This will be fairly expensive, but not exorbitantly so. The autosurgeon will take a decent amount of time to operate, and you do not want to be disturbed during that time.
#### *Druuuuuuuugs*
Generic category for making chemicals available to traitors. The tradeoffs are discussed above: Longer time to fully act, but you (Probably) aren't completely incapacitated while they do so.