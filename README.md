# Open HQ

Open source project management app.

## Deploy to Heroku

To make using Open HQ as easy as possible we have optimised it for usage on Heroku with the 1 click deploy button, however for now we still require you to have a mailgun and amazon s3 account.

### Prerequisites

1. **File upload storage** - Sign up for [Amazon S3](https://aws.amazon.com) and have your S3 AWS access key ID, secret access key and S3 bucket name ready. (Please provision your bucket in the default zone)
2. Setup CORS policy on your AWS S3 bucket (change the URL to match where you want to host it, or add '*' if unsure just yet)

    <CORSConfiguration>
        <CORSRule>
            <AllowedOrigin>https://openhq.herokuapp.com</AllowedOrigin>
            <AllowedMethod>GET</AllowedMethod>
            <AllowedMethod>POST</AllowedMethod>
            <AllowedMethod>PUT</AllowedMethod>
            <MaxAgeSeconds>3000</MaxAgeSeconds>
            <AllowedHeader>*</AllowedHeader>
        </CORSRule>
    </CORSConfiguration>

3. **Sending Email** - Sign up for [Mailgun](https://mailgun.com) and have your API key, mailgun domain and from address ready.

Once you have these setup click the magic deploy button, enter your details and get started with Open HQ!

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/phawkinsltd/openhq)

## Deploy to your own servers

Coming soon.

## License

GPLv3


## Contributing

### Testing

```sh
# Run the tests (uses spring)
$ bin/rspec

# Generate code coverage
$ COVERAGE=true rspec
```
