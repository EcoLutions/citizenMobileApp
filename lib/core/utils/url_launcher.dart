import 'package:url_launcher/url_launcher.dart' as launcher;

Future<void> launchUrlExternal(String url) async {
final Uri uri = Uri.parse(url);
  if (!await launcher.launchUrl(
    uri,
    mode: launcher.LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}