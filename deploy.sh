#!/bin/bash
set -e

. .env
ZIP_FILE="lambda.zip"
FILES_TO_INCLUDE="node_modules/nodemailer index.js"

echo "Installing dependencies..."
npm i
echo "Building zip file..."
zip -r $ZIP_FILE $FILES_TO_INCLUDE
echo "Uploading lambda function..."
aws lambda update-function-code \
    --function-name $AWS_FUNCTION_NAME \
    --zip-file "fileb://$ZIP_FILE" \
    --region "$AWS_REGION"
rm $ZIP_FILE
echo "Done!"


