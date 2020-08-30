# Selenium Related Functions

from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import WebDriverException
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.proxy import Proxy, ProxyType
from selenium.common.exceptions import TimeoutException

import selenium.webdriver.chrome.service as service

from openpyxl import Workbook
from bs4 import BeautifulSoup
from sys import platform
import requests

# Store the driver as a global variable
driver = ""

# start the driver and return it
def setup_driver(testing):
    global driver 
    
    chrome_options = webdriver.ChromeOptions()

    if not testing:
        chrome_options.add_argument("--headless")
    chrome_options.add_argument("--start-maximized")
    prefs = {"profile.default_content_setting_values.notifications" : 2}
    chrome_options.add_experimental_option("prefs",prefs)

    print("Starting driver")

    if platform == "linux" or platform == "linux2":
        print("Don't have linux chrome driver")
        return
    
    # './chromedrivers/chromedriver'
    if platform == "darwin":  # OS X
        driver = webdriver.Chrome(executable_path = '/Users/Saquib/Desktop/Metis2/Scrape/chromedrivers/chromedriver', chrome_options=chrome_options)
    elif platform == "win32":   # Windows...
        driver = webdriver.Chrome(executable_path = './chromedrivers/chromedriver.exe', chrome_options=chrome_options)

    # poll DOM for 10 seconds when looking for an element
    driver.implicitly_wait(10)

    return driver

# simple wrappers ****************************************************
# go to specified url
def navigate(url):
    global driver 

    driver.get(url)

# make element visible in viewport
def scroll(el):
    global driver
    driver.execute_script("arguments[0].scrollIntoView();", el)

# return elements at an xpath
def getElements(xpath):
    global driver

    return driver.find_elements_by_xpath(xpath)

# javascript click an element
def click(el):
    global driver

    driver.execute_script("arguments[0].click();", el)

# todo: refactor code to not need this
def getDriver():
    global driver

    return driver

def getDriverSrc():
    global driver

    return driver.page_source

def closeDriver():
    global driver

    driver.close()

# ********************************************************************

# fill out simple input fields
def fillInput(driver, xpath, value):
    name = check_exists_by_xpath(xpath, driver)
    name.click()
    sendKeys(value, name, driver)

# check for existence of input element in dom
def check_exists_by_xpath(xpath):
    global driver 
    try:
        myElem = WebDriverWait(driver, 1).until(EC.presence_of_element_located((By.XPATH, xpath)))
        return driver.find_element_by_xpath(xpath)
    except NoSuchElementException:
        myElem = WebDriverWait(driver, 1).until(EC.presence_of_element_located((By.XPATH, xpath)))
        return driver.find_element_by_xpath(xpath)

# fill out the input field with value
def sendKeys(value, field, driver):
    if len(value) < 1:
        return None
    try:
        driver.execute_script("arguments[0].value = '" + value + "';", field)
    except WebDriverException:
        print(field.get_attribute('Name'))

# return soup for HTML from a parent tag
def getHTML(element, attributes):
    global driver

    # Get the current page's HTML
    page_response = requests.get(driver.current_url, timeout=5)

    # Get Lower Div Courses
    soup = BeautifulSoup(page_response.content, "html.parser")
    data = soup.find(element, attributes)

    return data
