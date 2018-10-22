require 'sinatra'
require './lib/emailFunctions.rb'
require 'json-schema'

set :bind, '0.0.0.0'

get '/emails' do
  'Welcome to the email api - more to follow'
end

post '/emails' do
    request.body.rewind
    data = validateMailJson(request.body.read)
    if !data['error'] then
       data = JSON.parse(data)
      "#{sendEmail(data['from'],data['to'],data['subject'],data['body']).to_s}"
    else
      halt 400, "#{data['error']}"
    end

end
