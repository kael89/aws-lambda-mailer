const { createTransport } = require('nodemailer');

const { SMTP_HOST, SMTP_USER, SMTP_PASSWORD } = process.env;

const SMTP_PORT = 587;

const transporter = createTransport({
  host: SMTP_HOST,
  port: SMTP_PORT,
  auth: {
    user: SMTP_USER,
    pass: SMTP_PASSWORD,
  },
  tls: {
    rejectUnauthorized: false,
  },
});

const handler = async event => {
  const { from, to, subject, text, html } = event;
  const args = { from, to, subject, text, html };

  try {
    validateArgs(args);
    const response = await sendMail(args);
    console.info({ args, response });
    return {
      statusCode: 200,
      body: JSON.stringify(response),
    };
  } catch (error) {
    console.error({ error });
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message }),
    };
  }
};

const validateArgs = args => {
  const requiredArgs = ['from', 'to', 'subject', 'text', 'html'];
  requiredArgs.forEach(argName => {
    if (!args[argName]) {
      throw new Error(`'${argName}' is required`);
    }
  });
};

const sendMail = ({ from, to, subject, text, html }) =>
  transporter.sendMail({
    from,
    to,
    subject,
    text,
    html,
  });

exports.handler = handler;
