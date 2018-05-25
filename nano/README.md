# NanoUI Templates

NanoUI uses doT (https://olado.github.io/doT/index.html) as its templating engine.

## Template Markup Tags

Markup tags are used to add dynamic content to the template.
TODO - This documentation is incomplete.

### Print Tag
- The print tag outputs variable as text to the UI.
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
