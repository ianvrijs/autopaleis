import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      print('E-mail succesvol verzonden naar $recipientEmail');
      return true;
    } catch (e) {
      print('Fout bij het verzenden van e-mail: $e');
      return false;
    }
  }

  /// Send password reset email
  static Future<bool> sendPasswordResetEmail(
    String userEmail,
  ) {
    final resetLink = '';
    final htmlBody = '''
      <h2>Aanvraag Wachtwoord Opnieuw Instellen</h2>
      <p>We hebben een aanvraag ontvangen om uw wachtwoord opnieuw in te stellen.</p>
      <p><a href="$resetLink">Klik hier om uw wachtwoord opnieuw in te stellen</a></p>
      <p>Als u dit niet hebt aangevraagd, kunt u deze e-mail negeren.</p>
      <p>Deze link verloopt in 24 uur.</p>
      <hr>
      <p>Met vriendelijke groeten,<br>Het AutoPaleis Team</p>
    ''';

    return sendEmail(
      recipientEmail: userEmail,
      subject: 'Wachtwoord Opnieuw Instellen - AutoPaleis',
      body: htmlBody,
      isHtml: true,
    );
  }

  /// Send activation email
  static Future<bool> sendActivationEmail(
    String userEmail,
  ) {
    final activationLink = '${dotenv.env['API_BASE_URL']}/account/activate?email=$userEmail';
    final htmlBody = '''
      <h2>Welkom bij Danny's Autopaleis</h2>
      <p>Uw account staat voor u klaar.. Alleen nog even op het linkje klikken.</p>
      <p><a href="$activationLink">Activeer.</a></p>
      <p>Gewoon klikken.</p>
      <hr>
      <p>Groetjes,<br>Danny & co</p>
    ''';

    return sendEmail(
      recipientEmail: userEmail,
      subject: "Welkom bij Danny's Autopaleis - Activeer uw account",
      body: htmlBody,
      isHtml: true,
    );
  }
}
