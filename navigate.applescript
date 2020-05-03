set baseURL to "https://www.supremenewyork.com/shop/all/"
set section to "pants"
set productURL to (baseURL & section)
-- display dialog baseURL & section

tell application "Google Chrome"
	
	-- open the section
	if not (exists window 1) then reopen
    set URL of active tab of window 1 to productURL

    -- search for product

end tell