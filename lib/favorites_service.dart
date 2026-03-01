import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _key = 'favorite_place_titles';

  static Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? []).toSet();
  }

  static Future<bool> isFavorite(String placeTitle) async {
    final favs = await getFavorites();
    return favs.contains(placeTitle);
  }

  static Future<bool> toggle(String placeTitle) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = (prefs.getStringList(_key) ?? []).toSet();

    final nowFav = !favs.contains(placeTitle);

    if (nowFav) {
      favs.add(placeTitle);
    } else {
      favs.remove(placeTitle);
    }

    await prefs.setStringList(_key, favs.toList());
    return nowFav;
  }
}