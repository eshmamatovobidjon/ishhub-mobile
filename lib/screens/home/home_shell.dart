import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';

class HomeShell extends StatelessWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  static const _tabs = [
    ('/feed', Icons.explore_outlined, Icons.explore),
    ('/jobs', Icons.work_outline, Icons.work),
    ('/chat', Icons.chat_outlined, Icons.chat),
    ('/profile', Icons.person_outline, Icons.person),
  ];

  String _labelForIndex(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.navFeed;
      case 1:
        return l10n.navJobs;
      case 2:
        return l10n.navChat;
      case 3:
        return l10n.navProfile;
      default:
        return l10n.navFeed;
    }
  }

  int _indexForLocation(String location) {
    final i = _tabs.indexWhere((t) => location.startsWith(t.$1));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final idx = _indexForLocation(loc);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => context.go(_tabs[i].$1),
        destinations: [
          for (var i = 0; i < _tabs.length; i++)
            NavigationDestination(
              label: _labelForIndex(l10n, i),
              icon: Icon(_tabs[i].$2),
              selectedIcon: Icon(_tabs[i].$3),
            ),
        ],
      ),
    );
  }
}
