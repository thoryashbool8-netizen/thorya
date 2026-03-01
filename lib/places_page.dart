import 'package:flutter/material.dart';
import 'place_details_page.dart';

class PlacesPage extends StatelessWidget {
  const PlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tourist Places")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        // حذفنا const من ListView لأننا نستخدم context داخل Navigator
        children: [
          PlaceCard(
            title: "Petra",
            description: "Ancient city carved into red rock.",
            imagePath: "assets/images/petra1.jpg",
            onTap: () {
              // عند الضغط يتم فتح صفحة التفاصيل الخاصة بالبتراء
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PlaceDetailsPage(
                    title: "Petra",
                    imagePath: "assets/images/petra1.jpg",
                    details:
                        "Petra is one of Jordan’s most famous attractions. It is an ancient city carved into rose-red rock and is considered one of the New Seven Wonders of the World.",
                  ),
                ),
              );
            },
          ),
          PlaceCard(
            title: "Wadi Rum",
            description: "Desert valley with stunning landscapes.",
            imagePath: "assets/images/wadirum1.jpg",
            onTap: () {
              // الانتقال إلى صفحة تفاصيل وادي رم
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PlaceDetailsPage(
                    title: "Wadi Rum",
                    imagePath: "assets/images/wadirum1.jpg",
                    details:
                        "Wadi Rum is a beautiful desert in southern Jordan, famous for red sand, mountains, and adventure trips like jeep tours and camping.",
                  ),
                ),
              );
            },
          ),
          PlaceCard(
            title: "Jerash",
            description: "Roman ruins and historic architecture.",
            imagePath: "assets/images/jerash1.jpg",
            onTap: () {
              // فتح صفحة تفاصيل جرش عند الضغط على البطاقة
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PlaceDetailsPage(
                    title: "Jerash",
                    imagePath: "assets/images/jerash1.jpg",
                    details:
                        "Jerash is one of the best-preserved Roman cities in the world. It includes columns, theaters, temples, and amazing ancient streets.",
                  ),
                ),
              );
            },
          ),
          PlaceCard(
            title: "Dead Sea",
            description: "Lowest point on Earth and very salty water.",
            imagePath: "assets/images/deadsea1.jpg",
            onTap: () {
              // الانتقال إلى صفحة البحر الميت
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PlaceDetailsPage(
                    title: "Dead Sea",
                    imagePath: "assets/images/deadsea1.jpg",
                    details:
                        "The Dead Sea is the lowest point on Earth. Its water is extremely salty, allowing people to float easily, and it is known for natural minerals.",
                  ),
                ),
              );
            },
          ),
          PlaceCard(
            title: "Aqaba",
            description: "Coastal city with beautiful beaches.",
            imagePath: "assets/images/aqapa1.jpg", // اسم الصورة عندك مكتوب aqapa
            onTap: () {
              // فتح صفحة تفاصيل العقبة
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PlaceDetailsPage(
                    title: "Aqaba",
                    imagePath: "assets/images/aqapa1.jpg",
                    details:
                        "Aqaba is Jordan’s coastal city on the Red Sea. It is famous for beaches, snorkeling, diving, and relaxing sea activities.",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback onTap;

  const PlaceCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 180,
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(description),
                  const SizedBox(height: 6),
                  const Text(
                    "Tap to view details", // تنبيه بسيط للمستخدم أنه يمكن الضغط لرؤية التفاصيل
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}