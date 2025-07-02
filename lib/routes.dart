import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'nav/ScaffoldWithNavBar.dart';
import 'screens/map_screen.dart';
import 'screens/walks_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/community_screen.dart';
import 'screens/requests_screen.dart';
import 'screens/landing_page.dart';

// TEMPORARY GLOBAL FLAG
bool isOwner = false;

final router = GoRouter(
  initialLocation: '/',
  routes: [
    // Landing Page Route
    GoRoute(
      path: '/',
      name: 'landing',
      builder: (context, state) => LandingPage(
        onSelect: (owner) {
          isOwner = owner;
          context.go('/map');
        },
      ),
    ),

    // Shell route with bottom nav
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/map',
          name: 'map',
          builder: (context, state) => MapScreen(isOwner: isOwner),
        ),
        GoRoute(
          path: '/walks',
          name: 'walks',
          builder: (context, state) => WalksScreen(isOwner: isOwner),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => CombinedProfileScreen(isOwner: isOwner),
        ),
        GoRoute(
          path: '/community',
          name: 'community',
          builder: (context, state) => CommunityScreen(isOwner: isOwner),
        ),
        GoRoute(
          path: '/requests',
          name: 'requests',
          builder: (context, state) => RequestsScreen(isOwner: isOwner),
        ),
      ],
    ),
  ],
);
