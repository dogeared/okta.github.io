#!/bin/bash
set -ex

source "${0%/*}/helpers.sh"

if [ $TRAVIS_EVENT_TYPE != 'push' ]; then
  export CHROME_HEADLESS=true
fi

# 2. Run the npm install to pull in test dependencies
npm install

# 3. Run tests
npm test

# 4. Run lint
export GENERATED_SITE_LOCATION="dist"
if ! url_consistency_check || ! duplicate_slug_in_url; then
  echo "FAILED LINT CHECK!"
  exit 1;
fi

# 5. Run htmlproofer to validate links, scripts, and images
bundle exec htmlproofer ./dist --assume-extension --disable-external --allow-hash-href --empty-alt-ignore --log-level verbose --file-ignore "/3rd_party_notices/","/java_api_sdk/","/python_api_sdk/","/javadoc/","/csharp_api_sdk/"
