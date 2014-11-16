#!/usr/bin/env ruby

require "curb"
require "nokogiri"
require "ostruct"

require_relative "listapps"

class ApplicationMetrics

	APIKEY = File.read("apikey.txt")
	ACCOUNT_ID = File.read("accountid.txt")

	def get_metrics_for_app(app_id, app_name)

		r = Curl::Easy.perform("https://api.newrelic.com/api/v1/accounts/#{ACCOUNT_ID}/applications/#{app_id}/threshold_values.xml") do |curl|
		    curl.headers["x-api-key"] = "#{APIKEY}"
		end

		lines = []
		doc = Nokogiri::XML(r.body_str)
		doc.search('//threshold-values/threshold_value').each do |tv|
		    
		    if !tv.nil?
			    line = ""
				tv.attributes.each do |a|
					key = a[0]
					value = a[1]
					line += "#{key} - #{value}, "
				end
				
				lines << line.chomp(", ")
				
			end
		end

		puts "#{app_name}"
		lines.each do |l|
			puts "\t#{l}"
		end
	end

	def retrieve(appname)

		apps = ListApps.new().retrieve()

		apps.each do |app|

			if app.name.include? appname
				get_metrics_for_app(app.id, app.name)			
			end
		end

	end
end

ApplicationMetrics.new().retrieve("gateway")