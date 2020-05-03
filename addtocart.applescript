tell application "Safari"
	set a to do JavaScript "document.getElementsByName('commit')[0].click();" in document 1
end tell