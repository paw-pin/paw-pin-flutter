import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    int currentIndex = () {
      if (location.startsWith('/walks')) return 1;
      if (location.startsWith('/profile')) return 2;
      if (location.startsWith('/community')) return 3;
      if (location.startsWith('/requests')) return 4;
      return 0; // default: map
    }();

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/map');
              break;
            case 1:
              context.go('/walks');
              break;
            case 2:
              context.go('/profile');
              break;
            case 3:
              context.go('/community');
              break;
            case 4:
              context.go('/requests');
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.directions_walk), label: 'Walks'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.group), label: 'Community'),
          NavigationDestination(icon: Icon(Icons.inbox), label: 'Requests'),
        ],
      ),
    );
  }
}
