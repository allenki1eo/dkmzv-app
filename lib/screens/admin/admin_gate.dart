import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/store.dart';
import '../../widgets/common.dart';
import 'admin_home.dart';

class AdminGate extends StatefulWidget {
  const AdminGate({super.key});

  @override
  State<AdminGate> createState() => _AdminGateState();
}

class _AdminGateState extends State<AdminGate> {
  final _pin = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.admin)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(s.adminLead),
          const SizedBox(height: 8),
          Text(s.pinHint, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 16),
          TextField(
            controller: _pin,
            obscureText: true,
            decoration: InputDecoration(labelText: s.pin),
            onSubmitted: (_) => _go(store, s),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Color(0xFF9B1D2E))),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => _go(store, s),
            child: Text(s.unlock),
          ),
        ],
      ),
    );
  }

  void _go(ChurchStore store, dynamic s) {
    if (store.verifyPin(_pin.text)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminHome()),
      );
    } else {
      setState(() => _error = s.wrongPin as String);
    }
  }
}
