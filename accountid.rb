#!/usr/bin/env ruby

require "curb"
require 'nokogiri'

class AccountId
	
	APIKEY = File.read("apikey.txt")
	VERBOSE = false

	def retrieve()

		accountid_filename = "accountid.txt"
		url="https://api.newrelic.com/api/v1/accounts.xml"
		r = Curl::Easy.perform(url) do |curl| 
			curl.headers["x-api-key"] = "#{APIKEY}"
		  	curl.verbose = true if VERBOSE
		end
		body = r.body_str
		doc = Nokogiri::XML(body)
		doc.search('//account/id').each do |account|
			File.open(accountid_filename, 'w') {|f| f.write(account.text) }
		end

		puts "Stored account id in: #{accountid_filename}"
	end
end

AccountId.new().retrieve()