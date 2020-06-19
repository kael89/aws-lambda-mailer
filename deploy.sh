#!/bin/bash
set -e

# Extracts a variable from .env file
# Usage: read_dotenv {{ variable }}
read_dotenv() {
    grep $1 .env | cut -d '=' -f 2-
}

ZIP_FILE="lambda.zip"
FILES_TO_INCLUDE="node_modules/nodemailer index.js"

region=$(read_dotenv AWS_REGION)
function_name=$(read_dotenv AWS_FUNCTION_NAME)

echo "Installing dependencies..."
npm i
echo "Building zip file..."
zip -r $ZIP_FILE $FILES_TO_INCLUDE
echo "Uploading lambda function..."
aws lambda update-function-code --function-name $function_name --zip-file "fileb://$ZIP_FILE" --region "$region"
rm $ZIP_FILE
echo "Done!"


