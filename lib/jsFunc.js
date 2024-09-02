const functions = require('firebase-functions');
const nodemailer = require('nodemailer');

// Configure your email transporter
let transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'your-email@gmail.com',
        pass: 'your-email-password',
    },
});

exports.sendEmailNotification = functions.https.onCall((data, context) => {
    const email = data.email;
    const doctorName = data.doctorName;
    const date = data.date;
    const time = data.time;
    const note = data.note;

    const mailOptions = {
        from: 'your-email@gmail.com',
        to: email,
        subject: 'Appointment Confirmation',
        text: `Your appointment with Dr. ${doctorName} is confirmed for ${date} at ${time}. Note: ${note}`,
    };

    return transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
            return { success: false, error: error.toString() };
        }
        return { success: true };
    });
});