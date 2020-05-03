## How to run
- Install [Hammerspoon](https://github.com/Hammerspoon/hammerspoon/releases/tag/0.9.78)
- Copy `init.lua` and all `.applescript` files to `~.hammerspoon/`
- Start Hammerspoon and Hit `Reload Config` from the Hammerspoon menu accessible from the toolbar on top

## A bit about the code
- The first part in `init.lua` allows you to never have to `Reload Config` (which is basically means loading `init.lua` file in Hammerspoon). It automatically reloads when you make any changes to the file and save.
- When changes are made to the files in `~.hammerspoon/`, copy these files back into your repo directory to commit to the remote repo
- When saving any Applescript files, you will need to use the export to `text` option for it to work with Hammerspoon. This saves the file with the extension `.applescript`. The defualt extension, `.scpt` does not work with Hammerspoon.