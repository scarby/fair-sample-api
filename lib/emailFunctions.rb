require 'sendgrid-ruby'
require 'aws-sdk-ses'

def validateMailJson(json)
  begin
  schema = File.read("./json-schema/email.schema.json")
  JSON::Validator.validate!(schema, json)
  rescue JSON::Schema::ValidationError => e
    return {"error" => e.message}
  end
  return json
end

def sendEmail(sender,recipient,subject,body,encoding="utf8")
  begin
    sendEmailAWS(sender,recipient,subject,body)
    return true
  rescue
    sendEmailSG(sender,recipient,subject,body)
    return true
  end
end

def sendEmailAWS(sender,recipient,subject,body,encoding="utf8")

  ses = Aws::SES::Client.new(region: ENV.fetch("AWS_DEFAULT_REGION", "us-west-2"))
  begin
    resp = ses.send_email({
      destination: {
        to_addresses: [
          recipient,
        ],
      },
      message: {
        body: {
          text: {
            charset: encoding,
            data: body,
          },
        },
        subject: {
          charset: encoding,
          data: subject,
        },
      },
    source: sender,
    })
    return resp['message_id']
  rescue  => error
    raise "AWS has errored sending with " + error.to_s
  
  end
end

def sendEmailSG (sender,recipient,subject,body)
  from = SendGrid::Email.new(email: sender)
  to = SendGrid::Email.new(email: recipient)
  content = SendGrid::Content.new(type: 'text/plain', value: body)
  mail = SendGrid::Mail.new(from, subject, to, content)
  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  response = sg.client.mail._('send').post(request_body: mail.to_json)

  if response.status_code == "202" then
    return "looks like we sent an email"
  else 
    raise response.parsed_body
  end
end
