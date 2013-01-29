#!/usr/bin/env ruby
require 'rubygems' if RUBY_VERSION < '1.9.0'
require "net/https"
require 'json'
require 'sensu-plugin/check/cli'
 
class CheckSplunk < Sensu::Plugin::Check::CLI
  
  option :warn,
    :short => '-w WARN',
    :default => 1

  option :crit,
    :short => '-c CRIT',
    :default => 2

  option :host,
    :short => '-h HOST',
    :default => 'localhost'

  option :port,
    :short => '-p PORT',
    :default => '8089'

  option :username,
    :short => '-u USER',
    :default => 'hello'

  option :password,
    :short => '-P PASS',
    :default => 'securepassword'

  option :ssl,
    :short => '-s SSL',
    :default => true

  def api_request(opts={})
    o = {}.merge(opts)
  
    http = Net::HTTP.new(o[:host], o[:port])
    if o[:ssl]
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    req =  Net::HTTP::Get.new(o[:path])
    if o[:auth] then req.basic_auth(o[:auth][:user], o[:auth][:pass]) end
    http.request(req)
  end
  
  def check_splunk
    opts = {
      :ssl => config[:ssl],
      :host => config[:host],
      :port => config[:port],
      :path => "/services/alerts/fired_alerts?output_mode=json",
      :auth => { :user => config[:username], :pass => config[:password] }
    }
    res = JSON.parse(api_request(opts).body)
  end
  def run
    splunk = check_splunk
    count = splunk["entry"][0]["content"]["triggered_alert_count"]
    msg = "There are #{count} Splunk Alerts"
    if count.to_i >= config[:crit].to_i
      critical msg
    elsif count.to_i >= config[:warn].to_i
      warning msg
    else
      ok msg
    end
  end
end