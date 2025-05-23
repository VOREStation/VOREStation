# VChat
(Please add to this file as you learn how this thing works. Thank you!)
## Development

To implement changes to VChat, one must modify either vchat.js or vchat_client,
 where vchat.js corresponds to what actually appears to the user.
 Not all of the logic is isolated within vchat_client, vchat.js handles a significant amount of processing as well.

### vchat.js

vchat.js is a development file - it is not actually included in the actual game code. Instead, what the game expects is
the minified version "vchat.min.js"

Therefore, to have your changes in "vchat.js" apply to the game for either PR or testing - you must first minify your script.
If you are unfamiliar how to, simply you copy the file contants in vchat.js, paste them into https://codebeautify.org/minify-js
or any similar tool and paste its output into vchat.min.js .

As of 2023/08/05, no tool is provided by the codebase to handle minification for the developer.

### ss13styles.css

Handles chat colours, background colours, filtering.

Please keep this file synchronized with code\stylesheet.dm where possible (filters, lightmode colours).
