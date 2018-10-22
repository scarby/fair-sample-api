require "test_helper"

class EmailValidateTest < Minitest::Test
  def test_validator_rejects_invalid_to_address
    json = '{"from":"test@example.com","to":"testample.com","subject":"testing123","body":"hey, this is a test of the automated broadcast system"}'
    assert_equal false, (validateMailJson(json)['error'].nil?)
  end
  def test_validator_rejects_invalid_from_address
    json = '{"from":"tesxample.com","to":"test@example.com","subject":"testing123","body":"hey, this is a test of the automated broadcast system"}'
    assert_equal false, (validateMailJson(json)['error'].nil?)
  end
  def test_validator_accepts_valid_json
    json = '{"from":"test@example.com","to":"test@example.com","subject":"testing123","body":"hey, this is a test of the automated broadcast system"}'
    assert_equal json, (validateMailJson(json))
  end
  def test_validator_rejects_invalid_json
    json = '{"from":"tesxample.com":"test@example.com","subject":"testing123","body":"this is a test of the emergency broadcast system"}'
    assert_equal false, (validateMailJson(json)['error'].nil?)
  end
end

class EmailSendTest < Minitest::Test
  def test_can_send_mail_aws_up
    sender = "test@example.com"
    subject = "testing123"
    body = "this is a test of the emergency broadcast system"
    Aws.config[:ses] = {
      stub_responses: {
        send_email: {:message_id => "12345"}
      }
    }
    assert_instance_of String, sendEmailAWS(sender,sender,subject,body)
  end
  def test_when_aws_fails_try_sendgrid
    Aws.config[:ses] = {
      stub_responses: {
        send_email: Timeout::Error
      }
    }
    #eventually i should mock out sendgrind and assert that it is called here...
    assert sendEmail(@@from,@@to,@@subject,@@body)
  end
  def test_can_send_mail_sendgrid
    assert_instance_of String, sendEmailSG(@@from,@@to,@@subject,@@body)
  end
end
