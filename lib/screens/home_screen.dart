import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../services/links.dart';
import '../theme/brand.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/member_ui.dart';
import '../widgets/parish.dart';
import '../widgets/tab_bar.dart';
import '../widgets/video.dart';
import 'announcements_screen.dart';
import 'events_screen.dart';
import 'giving_screen.dart';
import 'jumuiya_map_screen.dart';
import 'profile_screen.dart';
import 'register_screen.dart';

/// The mwumini's own page: who they are, what they owe the offering box, what
/// their jumuiya is doing, and what the usharika is doing next.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenIbada,
    required this.onOpenSermons,
  });

  final VoidCallback onOpenIbada;
  final VoidCallback onOpenSermons;

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final member = store.currentMember;
    final congregation = store.selectedCongregation;
    final jumuiya = member == null
        ? null
        : store.data.jumuiyaById(member.jumuiyaId);
    final ibada = store.featuredService;
    final watch = store.watchNow;
    final announcements = store.data.sortedAnnouncements;
    final today = DateTime.now();

    final events = [...store.data.events]
      ..sort((a, b) => a.start.compareTo(b.start));
    final upcoming = events
        .where(
          (e) => (DateTime.tryParse(e.start) ?? today).isAfter(
            today.subtract(const Duration(hours: 6)),
          ),
        )
        .take(3)
        .toList();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Insets.gutter,
            Insets.md,
            Insets.gutter,
            GlassTabBar.scrollInset,
          ),
          children: [
            _Greeting(member: member, congregation: congregation),
            const SizedBox(height: Insets.xl),

            // The one figure a mwumini needs to hand: their bahasha.
            BahashaPanel(
              member: member,
              onGive: () => _push(context, const GivingScreen()),
              onRegister: () => _push(context, const RegisterScreen()),
            ),

            if (watch != null) ...[
              const SizedBox(height: Insets.lg),
              WatchCard(sermon: watch),
            ],

            SectionLabel(s.quickActions),
            _ActionGrid(
              onOpenIbada: onOpenIbada,
              onOpenSermons: onOpenSermons,
              onOpenGiving: () => _push(context, const GivingScreen()),
              onOpenMap: () => _push(context, const JumuiyaMapScreen()),
            ),

            if (jumuiya != null) ...[
              SectionLabel(s.myJumuiya),
              _JumuiyaCard(jumuiya: jumuiya),
            ],

            SectionLabel(
              upcoming.isEmpty ? s.todaySchedule : s.weekAhead,
              action: s.seeAll,
              onAction: () => _push(context, const EventsScreen()),
            ),
            if (upcoming.isEmpty)
              EmptyState(s.nothingToday, icon: Icons.event_available_outlined)
            else
              for (var i = 0; i < upcoming.length; i++)
                TimelineRow(
                  time: _clock(upcoming[i].start),
                  title: upcoming[i].title(store.sw),
                  subtitle:
                      '${formatDate(upcoming[i].start, store.localeCode)} · ${upcoming[i].place(store.sw)}',
                  highlight: i == 0,
                  onTap: () => showEventSheet(context, upcoming[i]),
                ),

            if (ibada != null) ...[
              SectionLabel(s.tabIbada),
              SoftTile(
                tone: SoftTone.dark,
                icon: Icons.menu_book_rounded,
                title: ibada.theme(store.sw),
                subtitle: formatDate(ibada.date, store.localeCode),
                onTap: () {
                  store.openIbada(ibada.id);
                  onOpenIbada();
                },
              ),
            ],

            SectionLabel(
              s.announcements,
              action: announcements.length > 2 ? s.seeAll : null,
              onAction: announcements.length > 2
                  ? () => _push(context, const AnnouncementsScreen())
                  : null,
            ),
            if (announcements.isEmpty)
              EmptyState(s.announcements, icon: Icons.campaign_outlined)
            else
              for (final a in announcements.take(2))
                AnnouncementCard(announcement: a),

            const SizedBox(height: Insets.lg),
            FootNote(s.offlineNote, icon: Icons.offline_pin_outlined),
          ],
        ),
      ),
    );
  }

  static String _clock(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    return '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}

/// "Habari za asubuhi, Asha" over the usharika the phone is following.
class _Greeting extends StatelessWidget {
  const _Greeting({required this.member, required this.congregation});

  final MemberRecord? member;
  final Congregation? congregation;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final name = member?.fullName.split(' ').first;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.greetingFor(DateTime.now().hour),
                style: TextStyle(
                  color: surfaces.muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              if (name == null)
                DisplayHeading(lead: s.welcomeLeadA, accent: s.welcomeLeadB)
              else
                DisplayHeading(lead: s.welcomeLeadA, accent: name),
              const SizedBox(height: Insets.xs + 2),
              Row(
                children: [
                  Icon(Icons.church_outlined, size: 13, color: surfaces.muted),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      congregation?.name(store.sw) ??
                          store.data.church.name(store.sw),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: surfaces.muted, fontSize: 12.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: Insets.sm),
        // The usharika switch and the language switch stay reachable from the
        // first screen — a mwumini may follow a congregation they do not
        // worship in every Sunday.
        const ParishButton(),
        const LocaleToggle(),
        const SizedBox(width: Insets.sm),
        const _ProfileAvatar(),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final surfaces = Surfaces.of(context);
    final member = store.currentMember;

    return Pressable(
      onTap: () =>
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
      scale: 0.92,
      child: Container(
        width: 46,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: member == null ? surfaces.card : surfaces.panel,
          shape: BoxShape.circle,
          border: Border.all(color: surfaces.hairline),
        ),
        child: member == null
            ? Icon(Icons.person_outline, size: 21, color: surfaces.muted)
            : Text(
                initialsOf(member.fullName),
                style: TextStyle(
                  color: surfaces.onPanel,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

/// The envelope card. When nobody has registered on this phone it turns into
/// the invitation to do so, because that is the only useful next step.
class BahashaPanel extends StatelessWidget {
  const BahashaPanel({
    super.key,
    required this.member,
    required this.onGive,
    required this.onRegister,
  });

  final MemberRecord? member;
  final VoidCallback onGive;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);

    if (member == null) {
      return HeroPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.notRegistered,
              style: TextStyle(
                color: surfaces.onPanel,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: Insets.sm),
            Text(
              s.registerForBahasha,
              style: TextStyle(
                color: surfaces.onPanel.withValues(alpha: 0.78),
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: Insets.lg),
            AmberButton(
              label: s.register,
              icon: Icons.person_add_alt_rounded,
              onPressed: onRegister,
            ),
          ],
        ),
      );
    }

    final year = DateTime.now().year;
    final mine = store.data.givingNotes.where((n) {
      final at = DateTime.tryParse(n.at);
      return at != null && at.year == year;
    }).toList();
    final total = mine.fold<int>(0, (sum, n) => sum + n.amount);
    final goal = _goalFor(total);
    final bahasha = member!.bahashaNo;

    return HeroPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.myBahasha.toUpperCase(),
                      style: TextStyle(
                        color: surfaces.onPanel.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: Insets.sm),
                    if (bahasha.isEmpty)
                      Text(
                        s.bahashaNotSet,
                        style: TextStyle(
                          color: surfaces.onPanel.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      )
                    else
                      Row(
                        children: [
                          Text(
                            bahasha,
                            style: TextStyle(
                              color: surfaces.onPanel,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(width: Insets.sm),
                          Pressable(
                            onTap: () => copyText(context, bahasha, s),
                            scale: 0.88,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.copy_rounded,
                                size: 16,
                                color: surfaces.onPanel.withValues(alpha: 0.75),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: Insets.xs),
                    Text(
                      bahasha.isEmpty ? '' : s.bahashaHint,
                      style: TextStyle(
                        color: surfaces.onPanel.withValues(alpha: 0.62),
                        fontSize: 11.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Insets.md),
              ProgressRing(
                value: goal == 0 ? 0 : total / goal,
                label: total == 0 ? '—' : _short(total),
              ),
            ],
          ),
          const SizedBox(height: Insets.lg),
          Row(
            children: [
              Expanded(
                child: StatStrip(
                  stats: [
                    Stat(value: '${mine.length}', label: s.givingTimes),
                    Stat(
                      value: total == 0 ? '—' : _short(total),
                      label: s.givenThisYear,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.lg),
          AmberButton(
            label: s.giveNow,
            icon: Icons.volunteer_activism_rounded,
            onPressed: onGive,
          ),
        ],
      ),
    );
  }

  /// A soft target so the ring has something to fill against. It is a
  /// presentation device only — the app makes no claim about what anyone owes.
  static int _goalFor(int total) {
    if (total <= 0) return 0;
    var step = 50000;
    while (step < total * 1.25) {
      step *= 2;
    }
    return step;
  }

  static String _short(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) return '${(amount / 1000).round()}K';
    return '$amount';
  }
}

/// Four soft tiles, two up.
class _ActionGrid extends StatelessWidget {
  const _ActionGrid({
    required this.onOpenIbada,
    required this.onOpenSermons,
    required this.onOpenGiving,
    required this.onOpenMap,
  });

  final VoidCallback onOpenIbada;
  final VoidCallback onOpenSermons;
  final VoidCallback onOpenGiving;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    final s = sOf(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SoftTile(
                tone: SoftTone.warm,
                icon: Icons.menu_book_rounded,
                title: s.tabIbada,
                height: 96,
                onTap: onOpenIbada,
              ),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: SoftTile(
                icon: Icons.play_circle_outline_rounded,
                title: s.sermons,
                height: 96,
                onTap: onOpenSermons,
              ),
            ),
          ],
        ),
        const SizedBox(height: Insets.md),
        Row(
          children: [
            Expanded(
              child: SoftTile(
                icon: Icons.volunteer_activism_outlined,
                title: s.giving,
                height: 96,
                onTap: onOpenGiving,
              ),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: SoftTile(
                tone: SoftTone.warm,
                icon: Icons.map_outlined,
                title: s.jumuiyaMap,
                height: 96,
                onTap: onOpenMap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _JumuiyaCard extends StatelessWidget {
  const _JumuiyaCard({required this.jumuiya});
  final Jumuiya jumuiya;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final surfaces = Surfaces.of(context);
    final neighbours = store.data.members
        .where((m) => m.jumuiyaId == jumuiya.id)
        .map((m) => initialsOf(m.fullName))
        .toList();

    return AppCard(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const JumuiyaMapScreen())),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: surfaces.amber.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Icon(Icons.groups_rounded, size: 21, color: surfaces.amber),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jumuiya.name(store.sw),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: surfaces.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (jumuiya.meetingNote(store.sw).isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    jumuiya.meetingNote(store.sw),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: surfaces.muted, fontSize: 12.5),
                  ),
                ],
              ],
            ),
          ),
          if (neighbours.isNotEmpty) ...[
            const SizedBox(width: Insets.sm),
            AvatarStack(initials: neighbours),
          ],
        ],
      ),
    );
  }
}
