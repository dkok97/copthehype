local htmlparser = require("htmlparser")
-- https://github.com/msva/lua-htmlparser
-- https://www.lua.org/pil/contents.html

addToCartPos = {x = 1010.7734375, y = 634.25}
checkoutNowPos = {x = 434.70703125, y = 468.78515625}
namePos = {x = 754.16796875, y = 490.46484375}
emailPos = {x = 757.671875, y = 538.8828125}
telPos = {x = 753.93359375, y = 589.02734375}
addrPos = {x = 653.93359375, y = 632.83203125}
aptPos = {x = 794.171875, y = 633.9375}
zipPos = {x = 563.73046875, y = 687.28515625}
cardNumPos = {x = 1075.15234375, y = 490.2265625}
monPos = {x = 866.625, y = 537.6875}
yearPos = {x = 932.73828125, y = 536.73046875}
cvvPos = {x = 1082.59765625, y = 540.359375}
agreeTermsPos = {x = 863.42578125, y = 733.90625}
processPaymentPos = {x = 1100.15625, y = 813.26953125}

-- THE REAL ONE, uncomment when you want to buy
-- processPaymentPos = {x=977.69140625, y=740.4609375}

nameText = "Dinkar Khattar"
emailText = "dinkarkhattar@gmail.com"
telText = "310 918 5821"
addrText = "437 Gayley Avenue"
aptText = "Unit 204"
zipText = "90024"
cardNumText = "1234123412341234"
monText = "06"
yearText = "2021"
cvvText = "123"


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
    hs.timer.usleep(60000)
end

function moveAndSelectDown(coords, text, times)
    hs.mouse.setAbsolutePosition(coords)
    hs.eventtap.leftClick(coords)
    -- hs.eventtap.keyStrokes(text)
    -- hs.timer.usleep(20000*string.len(text))
    for i=1,times do
        hs.eventtap.keyStroke({}, "down")
    end
    
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

            print(name, name:find(keywords))

            -- see if you've found the product
            if name:find(keywords) ~= nil then
                print(name)
                local colors = item("div.product-style > a")

                for _, c in pairs(colors) do
                    local curColor = c:getcontent():lower()

                    print(curColor)
                    -- see if you've found the color
                    if curColor:find(color) ~= nil then

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

function fillCheckout()
    -- type in name
    moveAndType(namePos, nameText)

    --type in email
    moveAndType(emailPos, emailText)
    -- hs.timer.doAfter(100, moveAndType({x=569.37109375,y=529.26171875}, "dinkarkhattar@gmail.com"))

    --type in tel
    moveAndType(telPos, telText)

    print("hi")

    --type in add1
    moveAndType(addrPos, addrText)

    --type in add2
    moveAndType(aptPos, aptText)

    --type in zip
    moveAndType(zipPos, zipText)

    -- --type in city
    -- moveAndType({x=697.54296875,y=672.625}, "Los Angeles")

    --select state
    -- moveAndSelect({x=799.7578125,y=674.17578125}, "CA")

    -- type in number
    moveAndType(cardNumPos, cardNumText)

    --select in month
    moveAndSelectDown(monPos, monText, 1)

    --select in year
    moveAndSelectDown(yearPos, yearText, 4)

    --type in cvv
    moveAndType(cvvPos, cvvText)

    --select agree
    moveAndClick(agreeTermsPos)

    --process payment
    moveAndClick(processPaymentPos)
end

function navigateToProduct()
    -- hs.osascript.applescriptFromFile('navigate.applescript')
    hs.application.launchOrFocus("Google Chrome")

    -- Get HTML from product page
    local category = "t-shirts"
    local categoryURL = "https://www.supremenewyork.com/shop/all/"..category
    _, body, _ = hs.http.doRequest(categoryURL, "GET")

    -- Parse HTML to get product page
    -- TODO: figure out how to input this better
    local href = getProductURL(body, "johnston frog", "Teal")

    -- Check if you found product
    if href == "" then
        print("Didn't find product")
        return
    end
    
    local productURL = "https://www.supremenewyork.com"..href
    print(productURL)
    hs.urlevent.openURL(productURL)
end

--Trial function for debugging
hs.hotkey.bind({"cmd", "alt"}, "O", function()
    moveAndSelectDown({x=1083.11328125,y=531.8203125}, "123")
end)

--Print mouse position
hs.hotkey.bind({"cmd", "alt"}, "P", function()
    pos = hs.mouse.getAbsolutePosition()
    print(pos.x)
    print(pos.y)
end)

-- Navigate to the product
hs.hotkey.bind({"cmd", "alt"}, "T", function()
    navigateToProduct()
end)

--Move to add to cart
hs.hotkey.bind({"cmd", "alt"}, "F", function()
    hs.mouse.setAbsolutePosition(addToCartPos)
end)

--Click on add to cart
hs.hotkey.bind({"cmd", "alt"}, "G", function()
    hs.eventtap.leftClick(addToCartPos)
end)

--Move to checkout now
hs.hotkey.bind({"cmd", "alt"}, "H", function()
    hs.mouse.setAbsolutePosition(checkoutNowPos)
end)

--Click on checkout now
hs.hotkey.bind({"cmd", "alt"}, "J", function()
    hs.eventtap.leftClick(checkoutNowPos)
end)

--Fill checkout form
hs.hotkey.bind({"cmd", "alt"}, "X", function()
    fillCheckout()
end)

--Check out now flow
hs.hotkey.bind({"cmd", "alt"}, "Z", function()
    hs.mouse.setAbsolutePosition(checkoutNowPos)
    hs.eventtap.leftClick(checkoutNowPos)
end)

--Full flow
hs.hotkey.bind({"cmd", "alt"}, "M", function()
    navigateToProduct()
    hs.timer.usleep(500000)
    hs.mouse.setAbsolutePosition(addToCartPos)
    hs.eventtap.leftClick(addToCartPos)
    hs.timer.usleep(600000)
    hs.mouse.setAbsolutePosition(checkoutNowPos)
    hs.eventtap.leftClick(checkoutNowPos)
    hs.timer.usleep(600000)
    fillCheckout()
end)