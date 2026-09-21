import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../l10n/strings.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';
import 'register_screen.dart';

const osmPackageName = 'tz.kkkt.dkmzv.dkmzv_app';

class JumuiyaMapScreen extends StatefulWidget {
  const JumuiyaMapScreen({super.key, this.congregationId, this.jumuiyaId});

  final String? congregationId;
  final String? jumuiyaId;

  @override
  State<JumuiyaMapScreen> createState() => _JumuiyaMapScreenState();
}

class _JumuiyaMapScreenState extends State<JumuiyaMapScreen> {
  late String _congregationId;
  String? _jumuiyaId;
  final _map = MapController();

  @override
  void initState() {
    super.initState();
    final store = context.read<ChurchStore>();
    _congregationId = widget.congregationId ??
        store.selectedCongregation?.id ??
        (store.data.congregations.isEmpty
            ? ''
            : store.data.congregations.first.id);
    _jumuiyaId = widget.jumuiyaId;
    final jumuiyas = store.jumuiyasFor(_congregationId);
    if (_jumuiyaId == null && jumuiyas.isNotEmpty) {
      _jumuiyaId = jumuiyas.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final cong = store.data.congregationById(_congregationId);
    final jumuiyas = store.jumuiyasFor(_congregationId);
    final jumuiya = _jumuiyaId == null
        ? null
        : store.data.jumuiyaById(_jumuiyaId!);
    final pins = _jumuiyaId == null
        ? const <HomePin>[]
        : store.pinsForJumuiya(_jumuiyaId!);
    final center = jumuiya != null
        ? LatLng(jumuiya.latitude, jumuiya.longitude)
        : cong != null
            ? LatLng(cong.latitude, cong.longitude)
            : const LatLng(-3.669681, 33.427495);

    return Scaffold(
      appBar: AppBar(title: Text(s.jumuiyaMap)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.jumuiyaLead,
                    style: const TextStyle(
                        color: DkmzvBrand.muted, fontSize: 13, height: 1.35)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: store.data.congregations
                          .any((c) => c.id == _congregationId)
                      ? _congregationId
                      : null,
                  decoration: InputDecoration(labelText: s.congregations),
                  items: [
                    for (final c in store.data.congregations)
                      DropdownMenuItem(
                          value: c.id, child: Text(c.name(store.sw))),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _congregationId = v;
                      final next = store.jumuiyasFor(v);
                      _jumuiyaId = next.isEmpty ? null : next.first.id;
                    });
                    final nextCong = store.data.congregationById(v);
                    if (nextCong != null) {
                      _map.move(
                          LatLng(nextCong.latitude, nextCong.longitude), 15);
                    }
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue:
                      jumuiyas.any((j) => j.id == _jumuiyaId) ? _jumuiyaId : null,
                  decoration: InputDecoration(labelText: s.jumuiya),
                  items: [
                    for (final j in jumuiyas)
                      DropdownMenuItem(
                          value: j.id, child: Text(j.name(store.sw))),
                  ],
                  onChanged: jumuiyas.isEmpty
                      ? null
                      : (v) {
                          setState(() => _jumuiyaId = v);
                          final j = v == null
                              ? null
                              : store.data.jumuiyaById(v);
                          if (j != null) {
                            _map.move(LatLng(j.latitude, j.longitude), 16);
                          }
                        },
                ),
                const SizedBox(height: 6),
                Text(s.tapMapHint,
                    style: const TextStyle(
                        color: DkmzvBrand.muted, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FlutterMap(
              mapController: _map,
              options: MapOptions(
                initialCenter: center,
                initialZoom: 15.2,
                onTap: (tap, point) => _onMapTap(store, s, point),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: osmPackageName,
                ),
                MarkerLayer(
                  markers: [
                    if (cong != null)
                      _marker(
                        LatLng(cong.latitude, cong.longitude),
                        Icons.church,
                        DkmzvBrand.purple,
                        s.churchPin,
                      ),
                    if (jumuiya != null)
                      _marker(
                        LatLng(jumuiya.latitude, jumuiya.longitude),
                        Icons.groups,
                        DkmzvBrand.gold,
                        jumuiya.name(store.sw),
                      ),
                    for (final pin in pins)
                      _marker(
                        LatLng(pin.latitude, pin.longitude),
                        Icons.home,
                        DkmzvBrand.green,
                        pin.label,
                      ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        child: Text(s.osmAttribution,
                            style: const TextStyle(fontSize: 10)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Marker _marker(LatLng point, IconData icon, Color color, String tooltip) {
    return Marker(
      point: point,
      width: 44,
      height: 44,
      child: Tooltip(
        message: tooltip,
        child: Icon(icon, color: color, size: 32, shadows: const [
          Shadow(color: Colors.white, blurRadius: 6),
        ]),
      ),
    );
  }

  Future<void> _onMapTap(ChurchStore store, S s, LatLng point) async {
    final member = store.currentMember;
    if (member == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.registerToPin),
          action: SnackBarAction(
            label: s.register,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            ),
          ),
        ),
      );
      return;
    }
    final jumuiyaId = _jumuiyaId;
    if (jumuiyaId == null) return;
    await store.pingHome(
      memberId: member.id,
      jumuiyaId: jumuiyaId,
      congregationId: _congregationId,
      label: member.fullName.trim().isEmpty
          ? s.homePins
          : 'Nyumba ya ${member.fullName.trim()}',
      lat: point.latitude,
      lng: point.longitude,
      note: member.householdNote,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.pinDropped)));
  }
}
