#!/usr/bin/env ruby

require "curb"
require "nokogiri"
require "ostruct"

class ListApps

	APIKEY = File.read("apikey.txt")
	ACCOUNT_ID = File.read("accountid.txt")
	VERBOSE = false

	def retrieve()

		apps = []
		url="https://api.newrelic.com/api/v1/accounts.xml"
		r = Curl::Easy.perform("https://api.newrelic.com/api/v1/accounts/#{ACCOUNT_ID}/applications.xml") do |curl|
		    curl.headers["x-api-key"] = "#{APIKEY}"
		  	curl.verbose = true	if VERBOSE
		end
		
		doc = Nokogiri::XML(r.body_str)
		doc.search('//applications/application').each do |app|
		    
			id = app.at_xpath("id").text
		    name = app.at_xpath("name").text
		    
		    apps << OpenStruct.new(:id => id, :name => name)
		end
		return apps
	end
end

ListApps.new().retrieve().each do |app|
	puts app.id + " - " + app.name 
end
