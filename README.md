# bot

A build bot

[![Circle CI](https://circleci.com/gh/dkubb/bot.svg?style=shield)](https://circleci.com/gh/dkubb/bot)
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Getting Started

1. Click on Deploy to Heroku button.
2. Remember the application name.
3. Make sure you have AWS read/write credentials for S3.
4. Create an S3 bucket for halcyon assets.
5. Run the following commands:

```bash
# Clone the repository
git clone https://github.com/dkubb/bot.git
cd bot

# Setup the local environment
./sbin/setup.sh

# Build the system locally
./sbin/build-local.sh

# Build the system on heroku
./sbin/build-heroku.sh
```
