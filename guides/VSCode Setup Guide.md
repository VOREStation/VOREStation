This guide will simply list VSCode + the extensions needed, plus very basic instructions, as VSCode has a NUMBER of tutorials on it, and there's little need to reinvent the wheel.
It is assumed that you can follow the VSCode walkthrough. Navigate to the Extensions tab on the left, type @recommended, and then install each extension under the "Recommended" Tab.
Screenshot here, but don't rely on this as the workspace recommendations may change over time. https://i.imgur.com/CF0P6TI.png
If you require assistance, don't feel stupid! Just ask a maintainer or ask in Discord for help. Be prepared to take screenshots if you need.

**VSCode + All mission-critical extensions for DM Coding.**
<https://code.visualstudio.com/> VSCode, the root tool.
<https://marketplace.visualstudio.com/items?itemName=gbasood.byond-dm-language-support> DM language support, allow autoupdates
<https://marketplace.visualstudio.com/items?itemName=platymuus.dm-langclient> DM Language client, also allows compiling. When setting it up you need to go to extension settings, then "choose folder", pick the BYOND folder that has "uninstall.exe" and "bin" folders (the root/base folder). Then, once that's done, you can literally hit ctrl+shift+b and choose the .dme, and compile inside VSCode. It's FAR faster than compiling in Dream Maker.
Screenshot of settings: <https://i.gyazo.com/378b93de1a68886a0dc3b919a2a7a401.png>
<https://marketplace.visualstudio.com/items?itemName=stylemistake.auto-comment-blocks> Auto Comment Blocks (Allows multi-line comments easily in DM)
<https://marketplace.visualstudio.com/items?itemName=oderwat.indent-rainbow> Indent Rainbow - makes your indents colorcoded by how deep they are.
<https://marketplace.visualstudio.com/items?itemName=Donkie.vscode-tgstation-test-adapter> Not adapted for our code yet, but this allows one to run compile tests the same as online does.

{
"editor.bracketPairColorization.enabled": true,
"editor.guides.bracketPairs":"active"
}

Add this to settings.json
If you run into issues, ask in Discord for help.

**Optional.**
<https://marketplace.visualstudio.com/items?itemName=icrawl.discord-vscode> Discord rich presence, not needed, but looks pretty
<https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens> This one is also optional, works for allowing you to gitblame and stuff. Requires setup, but will walk you through it, and ALSO links with Gitkraken. Extremely handy.

**Quick Tips for VSCode**
Highlighting a proc and right clicking, then going to "Definition" or "Implementation" will allow you to easily see/lookup wherever it's used. This is massively helpful over having to manually search it.
CTRL+F will bring up a search, that also allows a replace line-by-line.
CTRL+Clicking will also (usually) take you to the definition of a proc/verb/etc.