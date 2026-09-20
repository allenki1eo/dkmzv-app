import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../widgets/common.dart';

class PastoralScreen extends StatefulWidget {
  const PastoralScreen({super.key});

  @override
  State<PastoralScreen> createState() => _PastoralScreenState();
}

class _PastoralScreenState extends State<PastoralScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _message = TextEditingController();
  String _type = 'prayer';
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(s.pastoral)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Text(s.pastoralLead),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: s.yourName),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: s.phoneOptional),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _type,
            items: [
              DropdownMenuItem(value: 'prayer', child: Text(s.prayer)),
              DropdownMenuItem(value: 'visit', child: Text(s.visit)),
            ],
            onChanged: (v) => setState(() => _type = v ?? 'prayer'),
            decoration: InputDecoration(labelText: s.requestType),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _message,
            maxLines: 5,
            decoration: InputDecoration(labelText: s.message),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Color(0xFF9B1D2E))),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              if (_name.text.trim().isEmpty || _message.text.trim().isEmpty) {
                setState(() => _error = s.required);
                return;
              }
              await store.addPastoralRequest(
                name: _name.text,
                phone: _phone.text,
                type: _type,
                message: _message.text,
              );
              if (!context.mounted) return;
              _name.clear();
              _phone.clear();
              _message.clear();
              setState(() => _error = null);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(s.submitted)));
            },
            child: Text(s.submit),
          ),
        ],
      ),
    );
  }
}
