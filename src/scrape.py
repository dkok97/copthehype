import sel
import time
import re

driver = ""

regex = r"(.*)/(.*)$"

def screenshot(url, num, cat):
    """
        take 2 screenshots on the product page (url)
        1 with the cart button, 1 with the checkout button
        save in format item{num}_cart.png
    """
    global driver

    path = "./images/" + cat + str(num)

    driver.execute_script(("window.open('{}', 'new_window')").format(url))
    driver.switch_to.window(driver.window_handles[1])

    driver.implicitly_wait(0)

    # check if sold out
    sold = driver.find_elements_by_xpath("""//*[@id="add-remove-buttons"]/b""")
    if len(sold) != 0:
        driver.close()
        driver.switch_to.window(driver.window_handles[0])
        driver.implicitly_wait(10)
        return False

    driver.save_screenshot(path + "_cart.png") 

    driver.implicitly_wait(10)

    add = driver.find_element_by_xpath("""//*[@id="add-remove-buttons"]/input""")
    add.click()

    driver.save_screenshot(path + "_checkout.png")

    # TODO: doesn't work, cart keeps growing lol
    remove = driver.find_element_by_xpath("""//*[@id="add-remove-buttons"]/input""")
    driver.execute_script("arguments[0].click();", remove)
    remove.click()

    driver.close()
    driver.switch_to.window(driver.window_handles[0])

    return True


def scrape():
    """
        take pictures of non-sold out items from each category
    """
    # TODO - use html coordinates to label the two buttons
    global driver

    url = "https://www.supremenewyork.com"
    categories = ["jackets", "t-shirts", "pants"]

    itemNum = 0

    for cat in categories:
        cUrl = url + "/shop/all/" + cat
        sel.navigate(cUrl)
        items = driver.find_elements_by_class_name('name-link')

        lastItem = ""

        # get url for each item
        for item in items:

            attrs = driver.execute_script('var items = {}; for (index = 0; index < arguments[0].attributes.length; ++index) { items[arguments[0].attributes[index].name] = arguments[0].attributes[index].value }; return items;', item)
            itemUrl = attrs["href"]

            # only look at 1 of an item type
            m = re.match(regex, itemUrl)
            curItem = m.group(1)

            if curItem == lastItem:
                # print(itemUrl, "true")
                continue
            else:
                # print(itemUrl, "false")
                lastItem = curItem

            navUrl = url + itemUrl
            result = screenshot(navUrl, itemNum, cat)
            if result:
                itemNum += 1

def main():
    global driver 

    driver = sel.setup_driver(False)
    scrape()
    sel.closeDriver()

if __name__ == '__main__':
    main()