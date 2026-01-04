import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  // MailDev SMTP configuration
  static const String _smtpHost = 'localhost';
  static const int _smtpPort = 1025;
  static const String _senderEmail = 'noreply@autopaleis.com';
  static const String _senderName = 'AutoPaleis';

  static Future<bool> sendEmail({
    required String recipientEmail,
    required String subject,
    required String body,
    bool isHtml = true,
  }) async {
    try {
      final smtpServer = SmtpServer(
        _smtpHost,
        port: _smtpPort,
        allowInsecure: true,
      );

      final message = Message()
        ..from = Address(_senderEmail, _senderName)
        ..recipients.add(recipientEmail)
        ..subject = subject;

      if (isHtml) {
        message.html = body;
      } else {
        message.text = body;
      }

      await send(message, smtpServer);
      print('Email sent successfully to $recipientEmail');
      return true;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }

  /// Send password reset email
  static Future<bool> sendPasswordResetEmail(
    String userEmail,
  ) {
    final resetLink = '';
    final htmlBody = '''
      <h2>Password Reset Request</h2>
      <p>We received a request to reset your password.</p>
      <p><a href="$resetLink">Click here to reset your password</a></p>
      <p>If you didn't request this, please ignore this email.</p>
      <p>This link expires in 24 hours.</p>
      <hr>
      <p>Best regards,<br>The AutoPaleis Team</p>
    ''';

    return sendEmail(
      recipientEmail: userEmail,
      subject: 'Password Reset - AutoPaleis',
      body: htmlBody,
      isHtml: true,
    );
  }
}
