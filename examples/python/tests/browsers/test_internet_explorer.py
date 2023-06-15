import subprocess
import sys

import pytest
from selenium import webdriver


@pytest.mark.skipif(sys.platform != "win32", reason="requires Windows")
def test_basic_options():
    options = webdriver.IeOptions()
    driver = webdriver.Ie(options=options)

    driver.quit()


def test_log_to_file(log_path):
    service = webdriver.ie.service.Service(log_path=log_path)

    driver = webdriver.Ie(service=service)

    with open(log_path, 'r') as fp:
        assert "Starting ChromeDriver" in fp.readline()

    driver.quit()


@pytest.mark.skip(reason="this is not supported, yet")
def test_log_to_stdout(capfd):
    service = webdriver.ie.service.Service(log_output=subprocess.STDOUT)

    driver = webdriver.Ie(service=service)

    out, err = capfd.readouterr()
    assert "Starting ChromeDriver" in out

    driver.quit()


def test_log_level(log_path):
    service = webdriver.ie.service.Service(service_args=['--log-level=DEBUG'], log_path=log_path)

    driver = webdriver.Ie(service=service)

    with open(log_path, 'r') as f:
        assert '[DEBUG]' in f.read()

    driver.quit()
