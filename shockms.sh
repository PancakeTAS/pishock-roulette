#!/bin/bash

#
# This code is mostly written by GitHub Copilot,
# so don't blame me if it doesn't work as expected.
#

# Check if user, api key and code environment variables are set
if [ -z "$PISHOCK_USER" ]; then
    echo "PISHOCK_USER environment variable is not set."
    exit 1
fi

if [ -z "$PISHOCK_API_KEY" ]; then
    echo "PISHOCK_API_KEY environment variable is not set."
    exit 1
fi

if [ -z "$PISHOCK_CODE" ]; then
    echo "PISHOCK_CODE environment variable is not set."
    exit 1
fi

# Set the intensity and duration with parameters
INTENSITY=$1
DURATION=$2

# Check if intensity and duration parameters are provided
if [ -z "$INTENSITY" ] || [ -z "$DURATION" ]; then
    echo "Usage: shockms <intensity: 1-100> <duration: 0.1, 0.3, 1-10>"
    exit 1
fi

# Check if intensity is between 0 and 100
if ! [[ "$INTENSITY" =~ ^([0-9]|[1-9][0-9]|100)$ ]]; then
    echo "Invalid intensity. Intensity can only be an integer between 0 and 100."
    exit 1
fi

# Check if duration is one of the allowed values
if [[ "$DURATION" =~ ^(0\.1|0\.3)$ ]]; then
    DURATION=$(echo "$DURATION * 1000" | bc)
    DURATION=${DURATION%.*} # Convert to integer
elif ! [[ "$DURATION" =~ ^([1-9]|10)$ ]]; then
    echo "Invalid duration. Duration can only be 0.1, 0.3 or any integer between 1 and 10."
    exit 1
fi

# Create JSON payload with jq
JSON_PAYLOAD=$(jq -n \
                  --arg un "$PISHOCK_USER" \
                  --arg sys "shockms by $USER@$HOSTNAME" \
                  --arg ak "$PISHOCK_API_KEY" \
                  --arg cd "$PISHOCK_CODE" \
                  --arg it "$INTENSITY" \
                  --arg dr "$DURATION" \
                  '{Username: $un, Name: $sys, Code: $cd, Intensity: $it, Duration: $dr, Apikey: $ak, Op: "0"}')

# Make the API request
curl -d "$JSON_PAYLOAD" -H 'Content-Type: application/json' https://do.pishock.com/api/apioperate
echo
