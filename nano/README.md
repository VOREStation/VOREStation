# NanoUI Templates

NanoUI uses doT (https://olado.github.io/doT/index.html) as its templating engine.

## Template Markup Tags

Markup tags are used to add dynamic content to the template.
TODO - This documentation is incomplete.

### Credit goes to Neersighted of /tg/station for the styling and large chunks of content of this README.

NanoUI is one of the three primary user interface libraries currently in use
on Polaris (browse(), /datum/browser, NanoUI). It is the most complex of the three,
but offers quite a few advantages, most notably in default features.

NanoUI adds a `ui_interact()` proc to all atoms, which, ideally, should be called
via `interact()`; However, the current standardized layout is `ui_interact()` being
directly called from anywhere in the atom, generally `attack_hand()` or `attack_self()`.
The `ui_interact()` proc should not contain anything but NanoUI data and code.

Here is a simple example from
[poolcontroller.dm @ ParadiseSS13/Paradise](https://github.com/ParadiseSS13/Paradise/blob/master/code/game/machinery/poolcontroller.dm).

```
    /obj/machinery/poolcontroller/attack_hand(mob/user)
        ui_interact(user)

    /obj/machinery/poolcontroller/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
        var/data[0]

        data["currentTemp"] = temperature
        data["emagged"] = emagged
        data["TempColor"] = temperaturecolor

        ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
        if(!ui)
            ui = new(user, src, ui_key, "poolcontroller.tmpl", "Pool Controller Interface", 520, 410)
            ui.set_initial_data(data)
            ui.open()
```



## Components

### `ui_interact()`

The `ui_interact()` proc is used to open a NanoUI (or update it if already open).
As NanoUI will call this proc to update your UI, you should include the data list
within it. On /tg/station, this is handled via `get_ui_data()`, however, as it would
take quite a long time to convert every single one of the 100~ UI's to using such a method,
it is instead just directly created within `ui_interact()`.

The parameters for `try_update_ui` and `/datum/nanoui/New()` are documented in
the code [here](https://github.com/PolarisSS13/Polaris/tree/master/code/modules/nano).

For: 
`/datum/nanoui/New(nuser, nsrc_object, nui_key, ntemplate_filename, ntitle = 0, nwidth = 0, nheight = 0, var/atom/nref = null, var/datum/nanoui/master_ui = null, var/datum/topic_state/state = default_state)`
Most of the parameters are fairly self explanatory.
 - `nuser` is the person who gets to see the UI window
 - `nsrc_obj` is the thing you want to call Topic() on
 - `nui_key` should almost always be `main`
 - `ntemplate_filename` is the filename with `.tmpl` extension in /nano/templates/
 - `ntitle` is what you want to show at the top of the UI window
 - `nwidth` is the width of the new window
 - `nheight` is the height of the new window
 - `nref` is used for onclose()
 - `master_ui` is used for UIs that have multiple children, see code for examples
 - And finally, `state`.

The most interesting parameter here is `state`, which allows the object to choose the
checks that allow the UI to be interacted with.

The default state (`default_state`) checks that the user is alive, conscious,
and within a few tiles. It allows universal access to silicons. Other states
exist, and may be more appropriate for different interfaces. For example,
`physical_state` requires the user to be nearby, even if they are a silicon.
`inventory_state` checks that the user has the object in their first-level
(not container) inventory, this is suitable for devices such as radios;
`admin_state` checks that the user is an admin (good for admin tools).

```
    /obj/item/the/thing/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, force_open = 0)
        var/data[0]

        ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open = force_open)
        if(!ui)
            ui = new(user, src, ui_key, "template_name_here.tmpl", title, width, height)
            ui.set_initial_data(data)
            ui.open()
```

### `Topic()`

`Topic()` handles input from the UI. Typically you will recieve some data from
a button press, or pop up a input dialog to take a numerical value from the
user. Sanity checking is useful here, as `Topic()` is trivial to spoof with
arbitrary data.

The `Topic()` interface is just the same as with more conventional,
stringbuilder-based UIs, and this needs little explanation.

```
    /obj/item/tank/Topic(href, href_list)
        if(..())
            return 1

        if(href_list["dist_p"])
            if(href_list["dist_p"] == "custom")
                var/custom = input(usr, "What rate do you set the regulator to? The dial reads from 0 to [TANK_MAX_RELEASE_PRESSURE].") as null|num
                if(isnum(custom))
                    href_list["dist_p"] = custom
                    .()
            else if(href_list["dist_p"] == "reset")
                distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
            else if(href_list["dist_p"] == "min")
                distribute_pressure = TANK_MIN_RELEASE_PRESSURE
            else if(href_list["dist_p"] == "max")
                distribute_pressure = TANK_MAX_RELEASE_PRESSURE
            else
                distribute_pressure = text2num(href_list["dist_p"])
            distribute_pressure = min(max(round(distribute_pressure), TANK_MIN_RELEASE_PRESSURE), TANK_MAX_RELEASE_PRESSURE)
        if(href_list["stat"])
            if(istype(loc,/mob/living/carbon))
                var/mob/living/carbon/location = loc
                if(location.internal == src)
                    location.internal = null
                    location.internals.icon_state = "internal0"
                    to_chat(usr, "<span class='notice'>You close the tank release valve.</span>")
                    if(location.internals)
                        location.internals.icon_state = "internal0"
                else
                    if(location.wear_mask && (location.wear_mask.flags & MASKINTERNALS))
                        location.internal = src
                        to_chat(usr, "<span class='notice'>You open \the [src] valve.</span>")
                        if(location.internals)
                            location.internals.icon_state = "internal1"
                    else
                        to_chat(usr, "<span class='warning'>You need something to connect to \the [src]!</span>")
```

### Template (doT)

NanoUI templates are written in a customized version of 
[doT](https://olado.github.io/doT/index.html),
a Javascript template engine. Data is accessed from the `data` object,
configuration (not used in pratice) from the `config` object, and template
helpers are accessed from the `helper` object.

It is worth explaining that Polaris's version of doT uses custom syntax
for the templates. The `?` operator is split into `if`, `else if parameter`, and `else`,
instead of `?`, `?? paramater`, `??`, and the `=` operator is replaced with `:`. Refer
to the chart below for a full comparison.

#### Helpers

##### Link

`{{:helpers.link(text, icon, {'parameter': true}, status, class, id)}}`

Used to create a link (button), which will pass its parameters to `Topic()`.

* Text: The text content of the link/button
* Icon: The icon shown to the left of the link (http://fontawesome.io/)
* Parameters: The values to be passed to `Topic()`'s `href_list`.
* Status: `null` for clickable, a class for selected/unclickable.
* Class: Styling to apply to the link.
* ID: Sets the element ID.

Status and Class have almost the same effect. However, changing a link's status
from `null` to something else makes it unclickable, while setting a custom Class
does not.

Ternary operators are often used to avoid writing many `if` statements.
For example, depending on if a value in `data` is true or false we can set a
button to clickable or selected:

`{{:helper.link('Close', 'lock', {'stat': 1}, data.valveOpen ? null : 'selected')}}`

Available classes/statuses are:

* null (normal)
* selected
* disabled
* yellowButton
* redButton
* linkDanger

##### displayBar

`{{:helpers.displayBar(value, min, max, class, text)}}`

Used to create a bar, to display a numerical value visually. Min and Max default
to 0 and 100, but you can change them to avoid doing your own percent calculations.

* Value: Defaults to a percentage but can be a straight number if Min/Max are set
* Min: The minimum value (left hand side) of the bar
* Max: The maximum value (right hand side) of the bar
* Class: The color of the bar (null/normal, good, average, bad)
* Text: The text label for the data contained in the bar (often just number form)

As with buttons, ternary operators are quite useful:

`{{:helper.bar(data.tankPressure, 0, 1013, (data.tankPressure > 200) ? 'good' : ((data.tankPressure > 100) ? 'average' : 'bad'))}}`


#### doT

doT is a simple template language, with control statements mixed in with
regular HTML and interpolation expressions.

However, Polaris uses a custom version with a different syntax. Refer
to the chart below for the differences.

Operator    |  doT       |     equiv         |
|-----------|------------|-------------------|
|Conditional| ?          | if                |
|           | ??         | else              |
|           | ?? (param) | else if(param)   |
|Interpolate| =          | :                 |
|^ + Encode | !          | >                 |
|Evaluation | #          | #                 |
|Defines    | ## #       | ## #              |
|Iteration  | ~ (param)  | for (param)       |

Here is a simple example from tanks, checking if a variable is true:

```
    {{if data.maskConnected}}
        <span>The regulator is connected to a mask.</span>
    {{else if}}
        <span>The regulator is not connected to a mask.</span>
    {{/if}}
```

The doT tutorial is [here](https://olado.github.io/doT/tutorial.html).

__Print Tag__
- The print tag outputs the given expression as text to the UI.

`{{:data.variable}}`

### If Tag
- The if tag displays content conditionally based on the provided expression being true.
- When combined with the else tag the if tag can also show content if the provided expression is false.
- The else tag can optionally have an expression provided (e.g. "`{{else expression2}}`"), giving it "elseif" functionality.

`{{if expression}} <expression true content> {{/if}}`
`{{if expression}} <expression true content> {{else}} <expression false content> {{/if}}`
`{{if expression1}} <expression1 true content> {{else expression2}} <expression2 true content> {{/if}}`

### For Tag
- Loop through entries in an array (an array is a list with a numeric index (it does not use strings as keys).
- Each time the `for` tag iterates though the array it sets a variable (default "value") to the data of the current entry (another variable, default "index", contains the index). An example of this is using the print tag to print the contents (e.g. `{{:value.key1}}` and `{{:value.key2}}`).
- If combined with an `empty` tag the for tag can display content when the array is empty.

`{{for array}} <list entry content> {{/for}}`
`{{for array}} <list entry content> {{empty}} <empty list content> {{/for}}`


### Tansclusion Tag
- Include the contents of another template which has been added to the ui.
`{{#def.atmosphericScan}}`

- You first must have added a template to the ui server side in your DM code:
`ui.add_template("atmosphericScan", "atmospheric_scan.tmpl")`

- Then you can reference it in the main template.  The tag will be replaced by the contents of the named template.  All tags in the named template are evaluated as normal.
