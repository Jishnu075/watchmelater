import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_bloc.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_event.dart';
import 'package:watchmelater/presentation/pages/watch_screen.dart';
import 'package:watchmelater/presentation/pages/watched_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    WatchScreen(),
    WatchedScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("WatchMeLater"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
              child: const Text('logout'),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_3x3_outlined),
            selectedIcon: Icon(Icons.grid_3x3),
            label: 'to watch',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'watched',
          ),
        ],
      ),
    );
  }
}
