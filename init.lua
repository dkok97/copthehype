local htmlparser = require("htmlparser")
-- https://github.com/msva/lua-htmlparser
-- https://www.lua.org/pil/contents.html

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

-- return href for a product from html body
function getProductURL(html, keywords, color)

    -- make lowercase
    keywords = keywords:lower()
    color    = color:lower()

    local root = htmlparser.parse(body)
    local elements = root("div.inner-article")

    local items = root("div.inner-article")
    for _, item in pairs(items) do

        -- product names
        names = item("div.product-name > a")
        for _, n in pairs(names) do
            local name = n:getcontent():lower()

            -- see if you've found the product
            if name:find(keywords) == 1 then
                local colors = item("div.product-style > a")

                for _, c in pairs(colors) do
                    local curColor = c:getcontent():lower()

                    -- see if you've found the color
                    if curColor:find(color) == 1 then

                        -- get href attribute from tag 
                        for k, v in pairs(c.attributes) do
                            if k == "href" then
                                return v
                            end
                        end
                    end
                    
                end

            end
        end
    end

    -- didn't find product
    return ""
end

-- Navigate to the product
hs.hotkey.bind({"cmd", "alt"}, "T", function()
    -- hs.osascript.applescriptFromFile('navigate.applescript')
    hs.application.launchOrFocus("Google Chrome")

    -- Get HTML from product page
    _, body, _ = hs.http.doRequest("https://www.supremenewyork.com/shop/all/pants", "GET")

    -- Parse HTML to get product page
    -- TODO: figure out how to input this better
    local href = getProductURL(body, "Metallic Rib", "Black")

    -- Check if you found product
    if href == "" then
        print("Didn't find product")
        return
    end
    
    local productURL = "https://www.supremenewyork.com"..href
    print(productURL)
    hs.urlevent.openURL(productURL)
end)

hs.hotkey.bind({"cmd", "alt"}, "P", function()
    pos = hs.mouse.getAbsolutePosition()
    print(pos.x)
    print(pos.y)
end)

hs.hotkey.bind({"cmd", "alt"}, "O", function()
    moveAndSelectDown({x=1083.11328125,y=531.8203125}, "123")
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