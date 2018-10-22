# Fair interview challange

This is a simple API for sending e-mails written in fairly short order for:
https://github.com/wearefair/interview/blob/master/platform/platform.md

As such it's intended to be as simple as possible and not intended for production use anywhere without significant extenstions to things like error handling, authentication, et. al. (there's obviously a limit to the amount of time i have to spend on this). That being said it does have a test suite - and does function - so could form the basis of something someday (maybe).

## Usage

This can be run locally using docker:
`docker build -t email .`
``` 
docker run -it --rm -P 3000:3000 \
   -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
   -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
   -e SENDGRID_API_KEY=$SENDGRID_API_KEY \
   email
```

You will need a sendgrid API key and a correctly configured SES account you are sending from, along with the access key.

Guidance on how to do that can be found here:

https://docs.aws.amazon.com/ses/latest/DeveloperGuide/setting-up-email.html
https://sendgrid.com/docs/for-developers/sending-email/api-getting-started/

After running the container you may post it a JSON document looking something like:

```
POST http://localhost:3000/emails HTTP/1.1

{"from":"CONFIGURED ADDRESS","to":"RECIPIENT EMAIL","subject":"testing123","body":"hey, this is a test of the automated broadcast system"}
```

This is the minimum i could really take in and still prove that it is possible to send an e-mail.

## Testing

This project has two levels of testing at a top level BDD using cucumber, mainly concerning itself with the project doing what it says it does from a users perspective and unit(ish) testing - that as of yet does not contain a mocked sendgrid Client (TODO).

### As a Ruby project

Assuming you have a modern version or ruby (2.5.x) this should work for you, check out the project, build and run using docker - or use bundle install and bundle exec app.rb . 

In order for your tests to have a chance at passing you will need to set the following environment variables:
```
FROM_EMAIL=<email> //set this to a valid e-mail for SES.
TO_EMAIL=<email> //set this to somewhere you can recieve mail.
SUBJECT=<string> //anything you want really, or we will assume a default if its blank.
BODY=<string> //anything you want really, or we will assume a default if its blank.
```

you must also edit feature/validate.feature file to contain valid e-mail addresses as i cant think of a good way of the top of my head to pull in data there. (in reality i'd impliment my own step here in order to consume the environment varaibles - however i have not implimented this for expedience)

## Architectural Decisions

The stack consists of Ruby running Sinatra as a framework implimenting the API - mainly as that's what i'm most familiar with and i prefer the simplicity of Sinatra vs Rails especially for something so simple. I was half tempted to write this in go - however i figured based upon my personal time constraints i'd stick with what i was most comfortable with (there's only so many new things you have the time for at once right?).

There is a JSON schema in here which discribes the format which the json should be and submitted JSON is validated against this on every request (i like JSON schema).

Testing is performend at 2 levels - Unit (or currently unitish) testing using minitest and on top of that a level of BDD testing using cucumber (again because i really like cucumber, for describing the bahaviour of a user and acting as living documentation is IMHO second to none). these test suites are minimal - but then this is currently a tiny project.

We are also usng cucumber-rest-bdd for step definitons here.

## TODO
Or more speficically what i would do if this was going anywhere near production.

* Use passenger as an application server. Its just better but right now not necessarrily worth the overhead.
* Put in some form of authentication - really this kind of endpoint can't be publically acessible and segregating. it using the network is probably not enough (nobody wants an angry empoloyee anoymously sending e-mails).
* Impliment some kind of CI building the docker container and pushing it to a registry.
* Kubernates config.
* Actually handle errors - at the moment i assume any error with AWS means i should try sendGrid.
* Add configurable provider ordering.
* Add logging preferably to STDOUT but it would probably good to spefically log any failure (i may goof and do this one)
* Make Cucumber tests pass using the environment variables some how. at present you must edit the feature file

### TODO: Nice to have

* Some kind of ongoing security testing (OpenVASd anyone)
* Talk over HTTPS - i assume this would be an internal service and not internet facing.
* This should probably have a method for getting the state of e-mails submitted. At the moment it has no useful get method. If the calling application recives a 200 it must assume that the mail was actually sent (not for some reason accepted by a provider then reject for some reason)