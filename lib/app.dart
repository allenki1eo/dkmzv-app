import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'data/store.dart';
import 'l10n/strings.dart';
import 'screens/shell.dart';
import 'theme/brand.dart';

class DkmzvApp extends StatefulWidget {
  const DkmzvApp({super.key, required this.store, this.skipSplash = false});
  final ChurchStore store;
  final bool skipSplash;

  @override
  State<DkmzvApp> createState() => _DkmzvAppState();
}

class _DkmzvAppState extends State<DkmzvApp> {
  late bool _showSplash = !widget.skipSplash;

  @override
  void initState() {
    super.initState();
    if (_showSplash) {
      Future<void>.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => _showSplash = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChurchStore>.value(
      value: widget.store,
      child: Consumer<ChurchStore>(
        builder: (_, store, _) {
          final s = S(store.localeCode);
          final locale = store.sw ? const Locale('sw') : const Locale('en');
          return MaterialApp(
            title: s.appName,
            debugShowCheckedModeBanner: false,
            theme: DkmzvBrand.theme(store.palette),
            locale: locale,
            supportedLocales: const [Locale('sw'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: _showSplash ? const _Splash() : const AppShell(),
          );
        },
      ),
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: DkmzvBrand.purple,
      body: Center(
        child: Image(
          image: AssetImage(DkmzvBrand.splashAsset),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
