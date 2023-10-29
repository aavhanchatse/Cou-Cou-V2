import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtil {
  static void launchMail(String email) {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );
    launchUrl(params);
  }
}
