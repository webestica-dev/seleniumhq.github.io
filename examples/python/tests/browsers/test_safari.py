import sys

import pytest
from selenium import webdriver


@pytest.mark.skipif(sys.platform != "darwin", reason="requires Mac")
def test_basic_options():
    options = webdriver.safari.options.Options()
    options.use_technology_preview = True
    service = webdriver.safari.service.Service(executable_path = '/Applications/Safari Technology Preview.app/Contents/MacOS/safaridriver')
    driver = webdriver.Safari(options=options, service=service)

    driver.quit()
