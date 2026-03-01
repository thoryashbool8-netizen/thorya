import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'favorites_service.dart';

class PlaceDetailsPage extends StatefulWidget {
  final String title;
  final String imagePath;
  final String details;

  // إحداثيات المكان
  final double placeLat;
  final double placeLng;

  const PlaceDetailsPage({
    super.key,
    required this.title,
    required this.imagePath,
    required this.details,
    required this.placeLat,
    required this.placeLng,
  });

  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  String distanceText = "اضغط لحساب المسافة";
  bool loading = false;

  bool isFav = false;
  bool favLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final v = await FavoritesService.isFavorite(widget.title);
    if (!mounted) return;
    setState(() {
      isFav = v;
      favLoading = false;
    });
  }

  Future<void> _toggleFavorite() async {
    setState(() => favLoading = true);
    final nowFav = await FavoritesService.toggle(widget.title);

    if (!mounted) return;
    setState(() {
      isFav = nowFav;
      favLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(nowFav ? "تمت الإضافة للمفضلة ⭐" : "تمت الإزالة من المفضلة"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> calcDistance() async {
    setState(() {
      loading = true;
      distanceText = "جاري حساب المسافة...";
    });

    try {
      // 1) تأكد GPS شغال
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          loading = false;
          distanceText = "شغّل GPS من الجهاز";
        });
        return;
      }

      // 2) صلاحيات
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        setState(() {
          loading = false;
          distanceText = "تم رفض صلاحية الموقع";
        });
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          loading = false;
          distanceText = "الصلاحية مرفوضة نهائيًا. فعّلها من الإعدادات.";
        });
        return;
      }

      // 3) موقع المستخدم
      final userPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4) حساب المسافة (متر)
      final meters = Geolocator.distanceBetween(
        userPos.latitude,
        userPos.longitude,
        widget.placeLat,
        widget.placeLng,
      );

      final km = meters / 1000;

      setState(() {
        loading = false;
        distanceText = "يبعد عنك: ${km.toStringAsFixed(2)} كم";
      });
    } catch (e) {
      setState(() {
        loading = false;
        distanceText = "صار خطأ: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          favLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : IconButton(
                  tooltip: isFav ? "إزالة من المفضلة" : "إضافة للمفضلة",
                  icon: Icon(isFav ? Icons.star : Icons.star_border),
                  onPressed: _toggleFavorite,
                ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              widget.imagePath,
              height: 260,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // كرت المسافة
          Card(
            child: ListTile(
              leading: const Icon(Icons.my_location),
              title: Text(distanceText),
              subtitle: Text(
                "إحداثيات المكان: ${widget.placeLat}, ${widget.placeLng}",
                style: const TextStyle(fontSize: 12),
              ),
              trailing: loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: calcDistance,
                    ),
              onTap: loading ? null : calcDistance,
            ),
          ),

          const SizedBox(height: 12),
          Text(
            widget.details,
            style: const TextStyle(fontSize: 16, height: 1.6),
          ),
        ],
      ),
    );
  }
}