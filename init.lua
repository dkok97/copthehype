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

function moveAndType(coords, text)
    hs.mouse.setAbsolutePosition(coords)
    hs.eventtap.leftClick(coords)
    hs.eventtap.keyStrokes(text)
    hs.timer.usleep(20000*string.len(text))
end

function moveAndSelectDown(coords, text)
    hs.mouse.setAbsolutePosition(coords)
    hs.eventtap.leftClick(coords)
    -- hs.eventtap.keyStrokes(text)
    -- hs.timer.usleep(20000*string.len(text))
    hs.eventtap.keyStroke({}, "down")
    hs.eventtap.keyStroke({}, "return")
end

function moveAndClick(coords)
    hs.mouse.setAbsolutePosition(coords)
    hs.eventtap.leftClick(coords)
end

-- hs.osascript.applescriptFromFile('addtocart.applescript')

hs.hotkey.bind({"cmd", "alt"}, "P", function()
    pos = hs.mouse.getAbsolutePosition()
    print(pos.x)
    print(pos.y)
end)

hs.hotkey.bind({"cmd", "alt"}, "O", function()
    moveAndSelect({x=1083.11328125,y=531.8203125}, "123")
end)

hs.hotkey.bind({"cmd", "alt"}, "F", function()
    hs.mouse.setAbsolutePosition({x=1003.6796875,y=615.08984375})
end)

hs.hotkey.bind({"cmd", "alt"}, "G", function()
    hs.eventtap.leftClick({x=1003.6796875,y=615.08984375})
end)

hs.hotkey.bind({"cmd", "alt"}, "H", function()
    hs.mouse.setAbsolutePosition({x=422.203125,y=461.48046875})
end)

hs.hotkey.bind({"cmd", "alt"}, "J", function()
    hs.eventtap.leftClick({x=422.203125,y=461.48046875})
end)

hs.hotkey.bind({"cmd", "alt"}, "K", function()
    -- type in name
    moveAndType({x=578.73828125,y=482.234375}, "Dinkar Khattar")

    --type in email
    moveAndType({x=762.15625,y=529.26171875}, "dinkarkhattar@gmail.com")
    -- hs.timer.doAfter(100, moveAndType({x=569.37109375,y=529.26171875}, "dinkarkhattar@gmail.com"))

    --type in tel
    moveAndType({x=788.0625,y=579.58203125}, "3109185821")

    --type in add1
    moveAndType({x=647.46484375,y=624.7265625}, "437 Gayley Avenue")

    --type in add2
    moveAndType({x=779.48046875,y=628.23828125}, "Unit 204")

    --type in zip
    moveAndType({x=563.61328125,y=673.1640625}, "90024")

    -- --type in city
    -- moveAndType({x=697.54296875,y=672.625}, "Los Angeles")

    --select state
    -- moveAndSelect({x=799.7578125,y=674.17578125}, "CA")

    -- type in number
    moveAndType({x=1044.33984375,y=480.8046875}, "1234123412341234")

    --select in month
    moveAndSelectDown({x=874.0703125,y=529.63671875}, "06")

    --select in year
    moveAndSelectDown({x=933.45703125,y=523.92578125}, "2021")

    --type in cvv
    moveAndType({x=1083.11328125,y=531.8203125}, "123")

    --select agree
    moveAndClick({x=867.22265625,y=721.06640625})

end)