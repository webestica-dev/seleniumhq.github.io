# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Firefox' do
  let(:driver) { start_firefox }

  describe 'Options' do
    it 'basic options' do
      options = Selenium::WebDriver::Options.firefox
      @driver = Selenium::WebDriver.for :firefox, options: options
    end

    it 'installs addon' do
      extension_file_path = File.expand_path('../extensions/webextensions-selenium-example.xpi', __dir__)
      driver.install_addon(extension_file_path)

      driver.get 'https://www.selenium.dev/selenium/web/blank.html'
      injected = driver.find_element(id: 'webextensions-selenium-example')
      expect(injected.text).to eq 'Content injected by webextensions-selenium-example'
    end

    it 'uninstalls addon' do
      extension_file_path = File.expand_path('../extensions/webextensions-selenium-example.xpi', __dir__)
      extension_id = driver.install_addon(extension_file_path)
      driver.uninstall_addon(extension_id)

      driver.get 'https://www.selenium.dev/selenium/web/blank.html'
      expect(driver.find_elements(id: 'webextensions-selenium-example')).to be_empty
    end

    it 'installs unsigned addon' do
      extension_dir_path = File.expand_path('../extensions/webextensions-selenium-example/', __dir__)
      driver.install_addon(extension_dir_path, true)

      driver.navigate.to 'https://www.selenium.dev/selenium/web/blank.html'
      injected = driver.find_element(id: 'webextensions-selenium-example')
      expect(injected.text).to eq 'Content injected by webextensions-selenium-example'
    end

    it 'add arguments' do
      options = Selenium::WebDriver::Options.firefox(args: ['-headless'])

      @driver = Selenium::WebDriver.for :firefox, options: options
    end
  end

  describe 'Service' do
    let(:file_name) { File.expand_path('geckodriver.log') }
    let(:root_directory) { File.expand_path('./profile') }

    before { FileUtils.mkdir_p(root_directory) }

    after do
      FileUtils.rm_f(file_name)
      FileUtils.rm_rf(root_directory)
    end

    it 'basic service' do
      service = Selenium::WebDriver::Service.firefox
      @driver = Selenium::WebDriver.for :firefox, service: service
    end

    it 'logs to file' do
      service = Selenium::WebDriver::Service.firefox
      service.log = file_name

      @driver = Selenium::WebDriver.for :firefox, service: service

      expect(File.readlines(file_name).first).to include("geckodriver	INFO	Listening on")
    end

    it 'logs to stdout' do
      service = Selenium::WebDriver::Service.firefox
      service.log = $stdout

      expect {
        @driver = Selenium::WebDriver.for :firefox, service: service
      }.to output(/geckodriver	INFO	Listening on/).to_stdout_from_any_process
    end

    it 'logs to stderr' do
      service = Selenium::WebDriver::Service.firefox
      service.log = $stderr

      expect {
        @driver = Selenium::WebDriver.for :firefox, service: service
      }.to output(/geckodriver	INFO	Listening on/).to_stderr_from_any_process
    end

    it 'sets log level' do
      service = Selenium::WebDriver::Service.firefox
      service.log = file_name
      service.args += %w[--log debug]

      @driver = Selenium::WebDriver.for :firefox, service: service

      expect(File.readlines(file_name).grep(/Marionette	DEBUG/).any?).to eq true
    end

    it 'stops truncating log lines' do
      service = Selenium::WebDriver::Service.firefox(log: file_name, args: %w[--log debug])

      service.args << '--log-no-truncate'

      @driver = Selenium::WebDriver.for :firefox, service: service

      expect(File.readlines(file_name).grep(/ \.\.\. /).any?).to eq false
    end

    it 'sets default profile location' do
      service = Selenium::WebDriver::Service.firefox
      service.args += ['--profile-root', root_directory]

      @driver = Selenium::WebDriver.for :firefox, service: service

      profile_location = File.new(@driver.capabilities['moz:profile'])
      expect(profile_location.path).to include(root_directory)
    end
  end
end
