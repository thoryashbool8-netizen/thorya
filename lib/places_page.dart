import 'package:flutter/material.dart';
import 'place_details_page.dart';

class PlacesPage extends StatelessWidget {
  const PlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // ✅ اتجاه عربي
      child: Scaffold(
        appBar: AppBar(
          title: const Text("المعالم السياحية"),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            PlaceCard(
              title: "البتراء",
              description: "مدينة أثرية منحوتة في الصخور الوردية.",
              imagePath: "assets/images/petra1.jpg",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PlaceDetailsPage(
                      title: "البتراء",
                      imagePath: "assets/images/petra1.jpg",
                      details:
                          "تُعد البتراء من أشهر المعالم السياحية في الأردن. هي مدينة تاريخية منحوتة في الصخور الوردية وتُعتبر واحدة من عجائب الدنيا السبع الجديدة.",
                      placeLat: 30.3285,
                      placeLng: 35.4444,
                    ),
                  ),
                );
              },
            ),
            PlaceCard(
              title: "وادي رم",
              description: "صحراء ساحرة بمناظر طبيعية رائعة.",
              imagePath: "assets/images/wadirum1.jpg",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PlaceDetailsPage(
                      title: "وادي رم",
                      imagePath: "assets/images/wadirum1.jpg",
                      details:
                          "وادي رم من أجمل صحارى الأردن، مشهور بالرمال الحمراء والجبال ورحلات المغامرة مثل الجولات بالجيب والتخييم.",
                      placeLat: 29.5764,
                      placeLng: 35.4195,
                    ),
                  ),
                );
              },
            ),
            PlaceCard(
              title: "جرش",
              description: "آثار رومانية ومعمار تاريخي مميز.",
              imagePath: "assets/images/jerash1.jpg",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PlaceDetailsPage(
                      title: "جرش",
                      imagePath: "assets/images/jerash1.jpg",
                      details:
                          "تُعتبر جرش من أفضل المدن الرومانية المحفوظة في العالم، وتضم أعمدة ومدرجات ومعابد وشوارع أثرية مدهشة.",
                      placeLat: 32.2769,
                      placeLng: 35.8906,
                    ),
                  ),
                );
              },
            ),
            PlaceCard(
              title: "البحر الميت",
              description: "أخفض نقطة على سطح الأرض ومياهه شديدة الملوحة.",
              imagePath: "assets/images/deadsea1.jpg",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PlaceDetailsPage(
                      title: "البحر الميت",
                      imagePath: "assets/images/deadsea1.jpg",
                      details:
                          "البحر الميت هو أخفض نقطة على سطح الأرض. مياهه شديدة الملوحة مما يساعد على الطفو بسهولة، ويشتهر بالمعادن الطبيعية المفيدة.",
                      placeLat: 31.5590,
                      placeLng: 35.4732,
                    ),
                  ),
                );
              },
            ),
            PlaceCard(
              title: "العقبة",
              description: "مدينة ساحلية بشواطئ جميلة على البحر الأحمر.",
              imagePath: "assets/images/aqapa1.jpg",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PlaceDetailsPage(
                      title: "العقبة",
                      imagePath: "assets/images/aqapa1.jpg",
                      details:
                          "العقبة هي مدينة الأردن الساحلية على البحر الأحمر. تشتهر بالشواطئ والغطس والسنوركلينغ والأنشطة البحرية الممتعة.",
                      placeLat: 29.5321,
                      placeLng: 35.0063,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "اضغط لعرض التفاصيل",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
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