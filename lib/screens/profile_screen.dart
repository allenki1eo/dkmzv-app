import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../services/links.dart';
import '../theme/brand.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/member_ui.dart';
import 'giving_screen.dart';
import 'jumuiya_map_screen.dart';
import 'pastoral_screen.dart';
import 'register_screen.dart';

/// Who this phone belongs to, and everything that follows from it: the
/// bahasha number, the jumuiya, the giving already recorded.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final member = store.currentMember;
    final congregation = store.selectedCongregation;
    final jumuiya = member == null
        ? null
        : store.data.jumuiyaById(member.jumuiyaId);

    final year = DateTime.now().year;
    final mine = store.data.givingNotes.where((n) {
      final at = DateTime.tryParse(n.at);
      return at != null && at.year == year;
    }).toList();
    final total = mine.fold<int>(0, (sum, n) => sum + n.amount);

    return Scaffold(
      appBar: AppBar(title: Text(s.myProfile)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Insets.gutter,
          Insets.sm,
          Insets.gutter,
          Insets.xxl,
        ),
        children: [
          if (member == null)
            HeroPanel(
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
                  FlatButton(
                    label: s.register,
                    icon: Icons.person_add_alt_rounded,
                    onPressed: () => _push(context, const RegisterScreen()),
                  ),
                ],
              ),
            )
          else
            HeroPanel(
              padding: const EdgeInsets.fromLTRB(
                Insets.lg,
                Insets.xl,
                Insets.lg,
                Insets.lg,
              ),
              child: Column(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: surfaces.action,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      initialsOf(member.fullName),
                      style: TextStyle(
                        color: surfaces.onAction,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: Insets.md),
                  Text(
                    member.fullName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: surfaces.onPanel,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [congregation?.name(store.sw), jumuiya?.name(store.sw)]
                        .whereType<String>()
                        .where((e) => e.isNotEmpty)
                        .join(' · '),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: surfaces.onPanel.withValues(alpha: 0.72),
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: Insets.lg + 2),
                  StatStrip(
                    stats: [
                      Stat(
                        value: member.bahashaNo.isEmpty
                            ? '—'
                            : member.bahashaNo,
                        label: s.bahashaNumber,
                      ),
                      Stat(value: '${mine.length}', label: s.givingTimes),
                      Stat(
                        value: total == 0 ? '—' : _short(total),
                        label: s.givenThisYear,
                      ),
                    ],
                  ),
                ],
              ),
            ),

          if (member != null && member.bahashaNo.isNotEmpty) ...[
            const SizedBox(height: Insets.md),
            AppCard(
              onTap: () => copyText(context, member.bahashaNo, s),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: surfaces.subtle,
                      borderRadius: BorderRadius.circular(Radii.sm),
                    ),
                    child: Icon(
                      Icons.mail_outline_rounded,
                      size: 20,
                      color: surfaces.ink,
                    ),
                  ),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.bahashaNumber,
                          style: TextStyle(color: surfaces.muted, fontSize: 12),
                        ),
                        Text(
                          member.bahashaNo,
                          style: TextStyle(
                            color: surfaces.ink,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.copy_rounded, size: 18, color: surfaces.muted),
                ],
              ),
            ),
          ],

          SectionLabel(s.myChurchFollowUp),
          TileRow(
            icon: Icons.volunteer_activism_outlined,
            title: s.giving,
            subtitle: mine.isEmpty ? s.noGiftsYet : s.givenThisYear,
            onTap: () => _push(context, const GivingScreen()),
          ),
          const SizedBox(height: Insets.sm),
          TileRow(
            icon: Icons.groups_outlined,
            title: s.myJumuiya,
            subtitle: jumuiya?.name(store.sw) ?? s.noJumuiya,
            onTap: () => _push(context, const JumuiyaMapScreen()),
          ),
          const SizedBox(height: Insets.sm),
          TileRow(
            icon: Icons.favorite_outline_rounded,
            title: s.pastoral,
            subtitle: s.pastoralRowHint,
            onTap: () => _push(context, const PastoralScreen()),
          ),

          if (member != null) ...[
            const SizedBox(height: Insets.sm),
            TileRow(
              icon: Icons.badge_outlined,
              title: s.register,
              subtitle:
                  '${s.memberSince} '
                  '${formatDate(member.registeredAt, store.localeCode)}',
              onTap: () => _push(context, const RegisterScreen()),
            ),
          ],

          const SizedBox(height: Insets.lg),
          FootNote(s.pastoralRowHint, icon: Icons.lock_outline_rounded),
        ],
      ),
    );
  }

  static String _short(int amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '${(amount / 1000).round()}K';
    return '$amount';
  }
}
