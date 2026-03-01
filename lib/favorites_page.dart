import 'package:flutter/material.dart';
import 'favorites_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool loading = true;
  List<String> favTitles = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final favs = await FavoritesService.getFavorites();
    if (!mounted) return;
    setState(() {
      favTitles = favs.toList()..sort();
      loading = false;
    });
  }

  Future<void> _remove(String title) async {
    await FavoritesService.toggle(title); // toggle رح يشيلها لأنها موجودة
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تمت الإزالة من المفضلة")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الأماكن المفضلة ⭐")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : favTitles.isEmpty
              ? const Center(child: Text("ما في أماكن مضافة للمفضلة بعد"))
              : ListView.separated(
                  itemCount: favTitles.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final title = favTitles[i];
                    return ListTile(
                      leading: const Icon(Icons.star),
                      title: Text(title),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _remove(title),
                      ),
                    );
                  },
                ),
    );
  }
}