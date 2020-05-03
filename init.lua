function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

hs.hotkey.bind({"cmd", "alt"}, "F", function()
    -- hs.osascript.applescriptFromFile('addtocart.applescript')
    -- pos = hs.mouse.getAbsolutePosition()
    -- print(pos.x)
    -- print(pos.y)
    hs.mouse.setAbsolutePosition({x=1003.6796875,y=615.08984375})
end)