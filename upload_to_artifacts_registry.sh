#!/bin/bash

# Exit script on any error
set -e

# Check if 'twine' is installed, if not, install it
if ! python -c "import twine" 2> /dev/null; then
    echo "Info: 'twine' is not installed. Installing now..."
    pip install twine
fi

# Get the repository URL as input
read -p "Please enter the repository-url: " REPO_URL

# Generate an access token for authentication
export TWINE_USERNAME=oauth2accesstoken
export TWINE_PASSWORD=$(gcloud auth print-access-token)

# Upload the Wheel file
twine upload --repository-url "$REPO_URL" dist/*.whl

# Cleanup environment variables
unset TWINE_USERNAME TWINE_PASSWORD

echo "Successfully uploaded the package to Google Artifact Registry."