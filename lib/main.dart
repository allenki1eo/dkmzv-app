import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'data/store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('sw');
  await initializeDateFormatting('en');
  final store = await ChurchStore.load();
  runApp(DkmzvApp(store: store));
}
