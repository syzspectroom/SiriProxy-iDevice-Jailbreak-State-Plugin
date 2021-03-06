require 'cora'
require 'siri_objects'
require 'json'
require 'httparty'
require 'nokogiri'

class SiriProxy::Plugin::Jailbreak < SiriProxy::Plugin

  def initialize(config)
    #process custom config
  end

	def get_jailbrake(device, version, ios)
		url = "http://www.letsunlockiphone.com/jailbreak.php?device=#{device}&version=#{version}&ios=#{ios}"
		#page = HTTParty.get(uri).body

		#parse and return content here

		#if page is in json format
		#results = JSON.parse(page)

		#some logic here

		#and return
		url
	end

	listen_for /give me jailbreak(?: for)? (iphone|ipad|ipod) ([a-z0-9]*) with ios ([a-z0-9.]*)/i do |device, version, ios|

		results = get_jailbrake(device, version, ios)
		#say something
		say results

		request_completed
	end

	listen_for /give me jailbreak/i do
    		set_state :jail_search_state #set a state...
    	
	    	#say something about
    		say "give me more details about your device"
    
	    	request_completed
  	end

  	listen_for /(iphone|ipad|ipod) ([a-z0-9]*)(?: with)? ios ([a-z0-9.]*)/i, within_state: :jail_search_state do |device, version, ios|
    	
    		set_state nil

	    	results = get_jailbrake(device, version, ios)
	    	
                startRequest = SiriStartRequest.new(results)
                sendCommand = SiriSendCommands.new
                sendCommand.commands << startRequest
                button = SiriButton.new(results)
                button.commands << sendCommand	
                buttons = SiriAddViews.new
                buttons.make_root(last_ref_id)
                utterance = SiriAssistantUtteranceView.new('Here is the link')
                buttons.views << utterance
                buttons.views << button
                send_object buttons
		#say something
		#say results
    	
    		request_completed
  	end
end