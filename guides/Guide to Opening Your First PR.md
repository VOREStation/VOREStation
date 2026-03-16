Guide to Opening Your First PR
This guide is intended for newbie developers who have never touched BYOND .dm code, Github, or other things. If you already know github, you can safely skip a good portion of the below information.

Beginning:
In order to go anywhere, we’re going to need our own Repository (the thing you get the code from) to make changes to. Luckily, this is a one-button-job. Go to https://github.com/VOREStation/VOREStation and click Fork, as shown here:
https://i.imgur.com/tIbXmGN.png

In the top left, you will see:
https://i.imgur.com/sieji75.png

(Replace Rykka-Stormheart with your own username, ofc.) If you see this, and the “this repository is forked from VOREStation), you are part of the way there!

Git Clients
Everyone has their own preferred Github clients - I use Gitkraken because it’s exceedingly easy to use for newbies, and it’s a very visually-focused client. There are others, of course, links here:
**Gitkraken:** https://www.gitkraken.com/
**SourceTree:** https://www.sourcetreeapp.com/
**Github Desktop:** https://desktop.github.com/

I recommend Gitkraken as it’s very good at handling things for you, and it comes with built-in darkmode. It DOES have paid features, but you don’t need them.

Cloning your Repo: AKA “Progress bar time”
I’ll give these instructions in relevance to Gitkraken as that’s what I use, but they should be relatively applicable to other platforms.

You’re going to open Gitkraken and be met with this:
https://i.imgur.com/oXYqeZy.png

Choose “Clone a Repo”, and then choose Github.com. You can then choose where you want your repo installed (I usually do a master folder, Devwork, and then each repo is cloned inside: Devwork/VOREStation, Devwork/Polaris)
https://i.imgur.com/y15Qir2.png
https://i.imgur.com/bsw8p18.png

Opening your Repo for the first time:
Once your repo is cloned, you’ll be greeted with a screen SIMILAR to this (Note that mine has a lot of branches and repos):
https://i.imgur.com/Ei6QZOh.png

On the top left is your **local/remote**, those are the two important things we want to focus on.
Local is stuff that’s locally on YOUR PC, and remote is the fork that you made (and the other things we add).

Before we go further, we’ll want to add VOREStation as a remote so we can keep you up to date. Don’t worry, it’s easy.
Follow the picture instructions:
https://i.imgur.com/0aBRaoq.png
https://i.imgur.com/OaNNWjK.png
https://i.imgur.com/U7Maetj.png

And you should see:
https://i.imgur.com/Vlwn8R9.png

If you see the VOREStation_Master ahead of your master, **don’t panic.** Right click on ‘master’ and choose “fast-forward”. You’ll see the local computer icon jump to meet Master, and then you go to the top and hit “Push” - Push sends your changes up to your repo/remote.

Creating Your Branch:
Now that that’s done, we’re going to create our branch.
Go to master, right click, and choose “create branch here”.
https://i.imgur.com/Qqld0WI.png

You’ll see this popup in the bottom left (It goes away quickly, so don’t worry if you miss it)
https://i.imgur.com/uFR2qjP.png

Next, hit “push”. You’ll see a thing pop up at the top asking where to push/pull from. Just leave it at origin, and your branch name.
https://i.imgur.com/f3Gnw1Z.png

You’ll see this afterwards:
https://i.imgur.com/E36fYga.png

Making Changes + PR’ing:
Now, we’ve got our branch made, and it’s on both our repo and local PC. We’re all set to make changes. Now, do whatever changes you like to the files, and then you’ll come back to Gitkraken and see:
https://i.imgur.com/kMB7bKs.png

What this is is your changes, unstaged. You’ll need to stage them, and then type a message in to commit. The first part of the commit is the “Header”, the name that appears in the main branch/tree, and the text underneath is a description.
An example of commit title is here: https://i.imgur.com/dCiXsZX.png
Once that’s done, hit “Commit changes to x files”, and you’ll see the above image!

Now, hit “push”, to send the changes up to your repo’s branch.

Then, right click on your branch under “Local”, and choose “Start a pull request to x from x”:
https://i.imgur.com/lroAj8X.png

You’ll see this pop out:
https://i.imgur.com/21D6qt9.png

If the TO repo doesn’t autofill, don’t panic. Just choose VOREStation/VOREStation, branch master.

Then type the NAME of your PR, and a description underneath, then hit “Create Pull Request”!

And that’s it!

**You’ve now successfully made your first PR!**

Any further issues or changes, maintainers will assist you with! If you have any questions or run into any snags during this tutorial, feel free to @ a maintainer (The blue names on the sidebar) in #dev-general or just ask for help and someone should be with you momentarily!

**Good luck, and thank you for contributing to VORE. Your efforts are what keeps us all going! <3**
