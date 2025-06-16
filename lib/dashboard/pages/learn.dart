import 'package:bitsure/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../gen/assets.gen.dart';

class LearnScreen extends StatelessWidget {
  LearnScreen({super.key});

  final lessons = [
    {
      "img": Assets.images.earn1.path,
      "txt": "Play games & earn",
      "url": "https://www.thndr.games/",
    },
    {
      "img": Assets.images.earn2.path,
      "txt": "Learn & get paid",
      "url": "https://bitcoiners.africa/earn-bitcoin/places-to-earn-sats/",
    },
    {
      "img": Assets.images.earn3.path,
      "txt": "Write & earn",
      "url": "https://stacker.news",
    },
  ];

  final topics = [
    {
      "img": Assets.images.lesson1.path,
      "txt": "Origin of BTC",
      "url": "https://youtu.be/-m22d6tPaj4?si=p7jtodLwOAtR1gt5",
    },
    {
      "img": Assets.images.lesson2.path,
      "txt": "Bitcoin to the rescue",
      "url": "https://youtu.be/oksraL7wN6Q?si=XBGaAP-x0mh_LSNe",
    },
    {
      "img": Assets.images.lesson3.path,
      "txt": "Bitcoin in 3 minutes",
      "url": "https://youtu.be/BL5vUVQvmX4?feature=shared",
    },
    {
      "img": Assets.images.lesson4.path,
      "txt": "Bitcoin for Nerds",
      "url": "https://youtu.be/SXqfFTmYmT0?feature=shared",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.quicksand(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kwhitecolor,
        elevation: 0,
        title: Text(
          "Bitcoin University jsyk",
          style: titleStyle.copyWith(fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Browser input
              _BrowserInput(),
              const SizedBox(height: 20),

              // Quote
              _QuoteCard(),

              const SizedBox(height: 24),

              // Lessons section
              Text("Earn", style: titleStyle),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: lessons.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (_, i) {
                    final item = lessons[i];
                    return _LessonCard(
                      imagePath: item['img']!,
                      title: item['txt']!,
                      url: item['url']!,
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Lessons section
              Text("Lessons", style: titleStyle),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: topics.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (_, i) {
                    final item = topics[i];
                    return _LessonCard(
                      imagePath: item['img']!,
                      title: item['txt']!,
                      url: item['url']!,
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Videos section
              Text("Videos", style: titleStyle),
              const SizedBox(height: 8),
              _VideoCard(
                imagePath: Assets.images.video1.path,
                title: "Origin of BTC",
                url: 'https://youtu.be/-m22d6tPaj4?si=p7jtodLwOAtR1gt5',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrowserInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: const [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "This is a browser, don’t be shy… roam the internet",
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.more_vert),
        ],
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(offset: Offset(4, 4), color: Colors.black87),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(Assets.images.greenFlag.path, width: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Holding bitcoin is like holding your breath underwater, "
              "except you never run out of oxygen and you get rich.",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String url;

  const _LessonCard({
    required this.imagePath,
    required this.title,
    required this.url,
  });

  void _launchURL(BuildContext context) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchURL(context),
      child: Container(
        width: 187.25,
        height: 187.25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black87,
              offset: Offset(4, 4),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                image: DecorationImage(image: AssetImage(imagePath)),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 50,
                width: 187.25,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(color: Colors.white,
                 borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),

                ),
                border:Border(right: BorderSide(color: Colors.black), bottom: BorderSide(color: Colors.black), left: BorderSide(color: Colors.black)),
                ),
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String url;

  const _VideoCard({
    required this.imagePath,
    required this.title,
    required this.url,
  });

  void _launchURL(BuildContext context) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchURL(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(offset: Offset(4, 4), color: Colors.black87),
          ],
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Image.asset(
                    imagePath,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const Icon(
                  Icons.play_circle_fill,
                  color: Colors.blue,
                  size: 48,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              alignment: Alignment.centerLeft,
              child: Text(title, style: GoogleFonts.poppins(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
