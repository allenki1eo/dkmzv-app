import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../l10n/strings.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';
import '../widgets/parish.dart';
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
  bool _showAll = true;
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
    if (widget.jumuiyaId != null) _showAll = false;
  }

  Color _jumuiyaColor(Jumuiya j, int index) {
    final fromData = parseHexColor(j.colorHex);
    if (fromData != null) return fromData;
    const fallback = [
      DkmzvBrand.clothGreen,
      DkmzvBrand.gold,
      DkmzvBrand.clothRed,
      DkmzvBrand.sage,
    ];
    return fallback[index % fallback.length];
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final cong = store.data.congregationById(_congregationId);
    final jumuiyas = store.jumuiyasFor(_congregationId);
    final selected =
        _jumuiyaId == null ? null : store.data.jumuiyaById(_jumuiyaId!);
    final visible = _showAll ? jumuiyas : [?selected];
    final colors = <String, Color>{
      for (var i = 0; i < jumuiyas.length; i++)
        jumuiyas[i].id: _jumuiyaColor(jumuiyas[i], i),
    };
    final pins = _showAll
        ? store.pinsForCongregation(_congregationId)
        : (_jumuiyaId == null
            ? const <HomePin>[]
            : store.pinsForJumuiya(_jumuiyaId!));
    final inside = selected == null ? 0 : store.pinsInsideGeofence(selected).length;
    final outside = selected == null
        ? 0
        : store.pinsForJumuiya(selected.id).length - inside;
    final center = selected != null
        ? LatLng(selected.latitude, selected.longitude)
        : cong != null
            ? LatLng(cong.latitude, cong.longitude)
            : const LatLng(-3.669681, 33.427495);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.jumuiyaMap),
        actions: const [ParishButton()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cong?.name(store.sw) ?? s.congregations,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(s.geofenceHint,
                    style: TextStyle(
                        color: surfaces.muted, fontSize: 12.5, height: 1.35)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(s.showAllJumuiya),
                          selected: _showAll,
                          onSelected: (_) => setState(() => _showAll = true),
                        ),
                      ),
                      for (final j in jumuiyas)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            avatar: CircleAvatar(
                                radius: 6,
                                backgroundColor: colors[j.id] ?? DkmzvBrand.sage),
                            label: Text(j.name(store.sw)),
                            selected: !_showAll && _jumuiyaId == j.id,
                            onSelected: (_) {
                              setState(() {
                                _showAll = false;
                                _jumuiyaId = j.id;
                              });
                              _map.move(LatLng(j.latitude, j.longitude), 15.6);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _map,
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: 14.6,
                    onTap: (tap, point) => _onMapTap(store, s, point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: osmPackageName,
                    ),
                    CircleLayer(
                      circles: [
                        for (final j in visible)
                          CircleMarker(
                            point: LatLng(j.latitude, j.longitude),
                            radius: j.radiusMeters,
                            useRadiusInMeter: true,
                            color: (colors[j.id] ?? DkmzvBrand.sage)
                                .withValues(alpha: 0.12),
                            borderColor: (colors[j.id] ?? DkmzvBrand.sage)
                                .withValues(alpha: 0.75),
                            borderStrokeWidth: 1.6,
                          ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        if (cong != null)
                          _marker(
                            LatLng(cong.latitude, cong.longitude),
                            Icons.church,
                            parseHexColor(cong.accentHex) ?? DkmzvBrand.ink,
                            s.churchPin,
                          ),
                        for (final j in visible)
                          _marker(
                            LatLng(j.latitude, j.longitude),
                            Icons.groups,
                            colors[j.id] ?? DkmzvBrand.gold,
                            j.name(store.sw),
                          ),
                        for (final pin in pins)
                          _marker(
                            LatLng(pin.latitude, pin.longitude),
                            Icons.home,
                            colors[pin.jumuiyaId] ?? DkmzvBrand.clothGreen,
                            pin.label,
                            small: true,
                          ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.88),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            child: Text(s.osmAttribution,
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.black87)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (selected != null && !_showAll)
                  Positioned(
                    left: 12,
                    right: 12,
                    top: 12,
                    child: _GeofenceCard(
                      jumuiya: selected,
                      inside: inside,
                      outside: outside,
                      color: colors[selected.id] ?? DkmzvBrand.ink,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            color: surfaces.card,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(s.tapMapHint,
                      style:
                          TextStyle(color: surfaces.muted, fontSize: 12.5)),
                ),
                const SizedBox(width: 10),
                FilledButton.tonalIcon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  icon: const Icon(Icons.badge_outlined, size: 18),
                  label: Text(s.register),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Marker _marker(LatLng point, IconData icon, Color color, String tooltip,
      {bool small = false}) {
    return Marker(
      point: point,
      width: small ? 34 : 44,
      height: small ? 34 : 44,
      child: Tooltip(
        message: tooltip,
        child: Icon(icon,
            color: color,
            size: small ? 22 : 30,
            shadows: const [Shadow(color: Colors.white, blurRadius: 6)]),
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
    // A tap inside another jumuiya's fence files the home under that jumuiya.
    final fenced = store.jumuiyaAt(point.latitude, point.longitude,
        congregationId: _congregationId);
    final jumuiyaId = fenced?.id ?? _jumuiyaId ?? member.jumuiyaId;
    if (jumuiyaId.isEmpty) return;
    await store.pingHome(
      memberId: member.id,
      jumuiyaId: jumuiyaId,
      congregationId: _congregationId,
      label: member.kaya.trim().isNotEmpty
          ? member.kaya.trim()
          : member.fullName.trim().isEmpty
              ? s.homePins
              : 'Nyumba ya ${member.fullName.trim()}',
      lat: point.latitude,
      lng: point.longitude,
      note: member.householdNote,
    );
    if (!mounted) return;
    final placed = store.data.jumuiyaById(jumuiyaId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(placed == null
            ? s.pinDropped
            : '${s.pinDropped} · ${placed.name(store.sw)}'),
      ),
    );
  }
}

class _GeofenceCard extends StatelessWidget {
  const _GeofenceCard({
    required this.jumuiya,
    required this.inside,
    required this.outside,
    required this.color,
  });

  final Jumuiya jumuiya;
  final int inside;
  final int outside;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    return Container(
      decoration: BoxDecoration(
        color: surfaces.card.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: surfaces.hairline),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(jumuiya.name(store.sw),
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              Pill('${jumuiya.radiusMeters.round()} m', color: color),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Pill('${s.homesInside}: $inside',
                  color: DkmzvBrand.clothGreen, icon: Icons.home_outlined),
              const SizedBox(width: 8),
              if (outside > 0)
                Pill('${s.homesOutside}: $outside',
                    color: DkmzvBrand.clothRed, icon: Icons.near_me_disabled),
            ],
          ),
          if (jumuiya.meetingNote(store.sw).isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(jumuiya.meetingNote(store.sw),
                style: TextStyle(color: surfaces.muted, fontSize: 12.5)),
          ],
        ],
      ),
    );
  }
}
