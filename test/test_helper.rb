$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "minitest/autorun"
require "./app.rb"

@@from    = ENV.fetch("EMAIL_FROM", "scarby@scarby.co.uk")
@@to      = ENV.fetch("EMAIL_TO", "scarby2@gmail.com")
@@subject = ENV.fetch("EMAIL_SUBJECT", "This is a Test of the Emergency Broadcast System")
@@body = ENV.fetch("EMAIL_BODY", "This is a test of the Emergency Broadcast System. The broadcasters of your area in voluntary cooperation with the FCC and federal, state and local authorities have developed this system to keep you informed in the event of an emergency.")