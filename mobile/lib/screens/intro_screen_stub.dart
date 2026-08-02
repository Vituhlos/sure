import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class IntroScreenPlatform extends StatelessWidget {
  const IntroScreenPlatform({super.key, this.onStartChat});

  final VoidCallback? onStartChat;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  Text(
                    l.introComingSoon,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.introComingSoonBody,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
