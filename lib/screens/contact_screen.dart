import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../services/links.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final c = store.data.church;

    return Scaffold(
      appBar: AppBar(title: Text(s.contact)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Center(
            child: Image.asset(DkmzvBrand.logoAsset, width: 120, height: 120),
          ),
          const SizedBox(height: 8),
          Text(c.name(store.sw),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge),
          Text(c.diocese(store.sw), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(c.address(store.sw), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => openExternal(context, c.mapUrl, s),
            icon: const Icon(Icons.map_outlined),
            label: Text(s.map),
          ),
          SectionLabel(s.officeHours),
          Text(c.hours(store.sw)),
          SectionLabel(s.about),
          Text(c.about(store.sw)),
          const SizedBox(height: 8),
          Text(c.whatsapp(store.sw),
              style: const TextStyle(color: DkmzvBrand.muted)),
          SectionLabel(s.roleContacts),
          Text(s.notDirectory,
              style: const TextStyle(
                  color: DkmzvBrand.purple, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          for (final role in store.data.contacts)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(role.role(store.sw),
                        style: const TextStyle(
                            color: DkmzvBrand.green,
                            fontWeight: FontWeight.w700)),
                    Text(role.name(store.sw),
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(role.phone),
                    if (role.email.isNotEmpty) Text(role.email),
                    const SizedBox(height: 6),
                    Text(role.note(store.sw),
                        style: const TextStyle(
                            color: DkmzvBrand.muted, fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => dial(context, role.phone, s),
                          icon: const Icon(Icons.call),
                          label: Text(s.call),
                        ),
                        if (role.email.isNotEmpty)
                          TextButton.icon(
                            onPressed: () => openExternal(
                                context, 'mailto:${role.email}', s),
                            icon: const Icon(Icons.email_outlined),
                            label: Text(s.email),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
