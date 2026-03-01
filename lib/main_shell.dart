import 'package:flutter/material.dart';

import 'home_page.dart';
import 'places_page.dart';
import 'favorites_page.dart';
import 'quiz_page.dart';
import 'video_page.dart';

enum AppTab { home, places, favorites, quiz, video }

class TabItem {
  final AppTab tab;
  final String label;
  final IconData icon;
  final Widget page;

  const TabItem({
    required this.tab,
    required this.label,
    required this.icon,
    required this.page,
  });
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  AppTab _current = AppTab.home;

  // مصدر واحد للحقيقة: نفس البيانات للـ Drawer والـ BottomNav
  static const List<TabItem> _items = [
    TabItem(tab: AppTab.home, label: 'الرئيسية', icon: Icons.home, page: HomePage()),
    TabItem(tab: AppTab.places, label: 'المعالم', icon: Icons.place, page: PlacesPage()),
    TabItem(tab: AppTab.favorites, label: 'المفضلة', icon: Icons.star, page: FavoritesPage()),
    TabItem(tab: AppTab.quiz, label: 'Quiz', icon: Icons.quiz, page: QuizPage()),
    TabItem(tab: AppTab.video, label: 'فيديو', icon: Icons.play_circle, page: VideoPage()),
  ];

  int get _currentIndex => _items.indexWhere((e) => e.tab == _current);

  void _setTab(AppTab tab, {bool closeDrawer = false}) {
    setState(() => _current = tab);
    if (closeDrawer) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality( // تحسين للعربي
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_items[_currentIndex].label),
          centerTitle: true,
        ),

        drawer: _AppDrawer(
          items: _items,
          current: _current,
          onSelect: (tab) => _setTab(tab, closeDrawer: true),
        ),

        body: IndexedStack(
          index: _currentIndex,
          children: _items.map((e) => e.page).toList(growable: false),
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (i) => _setTab(_items[i].tab),
          items: _items
              .map((e) => BottomNavigationBarItem(
                    icon: Icon(e.icon),
                    label: e.label,
                  ))
              .toList(growable: false),
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  final List<TabItem> items;
  final AppTab current;
  final ValueChanged<AppTab> onSelect;

  const _AppDrawer({
    required this.items,
    required this.current,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const _DrawerHeader(),
            const Divider(height: 1),

            Expanded(
              child: ListView(
                children: items.map((e) {
                  final selected = e.tab == current;
                  return ListTile(
                    leading: Icon(e.icon),
                    title: Text(e.label),
                    selected: selected,
                    onTap: () => onSelect(e.tab),
                  );
                }).toList(growable: false),
              ),
            ),

            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('إغلاق'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 26, child: Icon(Icons.travel_explore)),
          SizedBox(height: 12),
          Text('Tourism App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('استكشف أجمل الأماكن السياحية', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}