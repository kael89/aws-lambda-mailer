# aws-lambda-mailer

An [AWS Lambda](https://aws.amazon.com/lambda/) function using [nodemailer](https://nodemailer.com/) for serverless email sending.

Check [Serverless Emails with AWS](https://codinglicks.com/blog/serverless-emails-with-aws/) for a step-by-step guide on setting up a cloud-based email sending service.

## Deployment

You can either manually upload a `.zip` file in your Lambda function, or use the `deploy.sh` script for automatic deployment:

```
./deploy.sh
```

In order to use the script you will need a .`env` file under the project's root. An example:

```bash
AWS_REGION=ap-southeast-2
AWS_FUNCTION_NAME=arn:aws:lambda:ap-southeast-2:999:function:sendEmail
```

⚠ If you follow the manual approach, you have to include both `index.js` and `node_modules/nodemailer/*` in the `.zip` file.

## Usage

To invoke this function from a `Node.js` application, we must first add [aws-sdk](https://www.npmjs.com/package/aws-sdk) as a dependency:

```bash
npm install aws-sdk
```

An example implementation:

```js
const Lambda = require('aws-sdk/clients/lambda');

const SEND_EMAIL_LAMBDA = 'myLambdaFunctionName'; // Your Lambda function name here

const lambda = new Lambda({
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  region: process.env.AWS_REGION,
});

const sendEmail = (data, callback) => {
  const { from, to, subject, text, html } = data;
  const payload = { from, to, subject, text, html };

  return lambda.invoke(
    {
      FunctionName: SEND_EMAIL_LAMBDA,
      InvocationType: 'Event',
      Payload: JSON.stringify(payload),
    },
    /**
     * @function
     * @param {?Error} error
     * @param {?{ StatusCode, Payload }} results
     */
    (error, results) => callback(error, results),
  );
};

module.exports = sendEmail;
```

We also need to provide `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_REGION` in the execution environment.

---

✍ [Kostas Karvounis](https://github.com/kael89), 2019-2020
