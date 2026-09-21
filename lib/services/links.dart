import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/strings.dart';

Future<void> openExternal(BuildContext context, String raw, S s) async {
  final uri = Uri.tryParse(raw.trim());
  if (uri == null || raw.trim().isEmpty) return;
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(s.noConnectionHint)));
  }
}

Future<void> copyText(BuildContext context, String value, S s) async {
  await Clipboard.setData(ClipboardData(text: value));
  if (context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(s.copied)));
  }
}

Future<void> dial(BuildContext context, String phone, S s) async {
  final cleaned = phone.replaceAll(' ', '');
  await openExternal(context, 'tel:$cleaned', s);
}

Future<void> shareText(String text, {String? subject}) async {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return;
  await SharePlus.instance.share(ShareParams(text: trimmed, subject: subject));
}
