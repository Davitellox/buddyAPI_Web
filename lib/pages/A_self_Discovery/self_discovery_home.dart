import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SelfDiscoveryHome extends StatelessWidget {
  final Map<String, dynamic> payload;

  const SelfDiscoveryHome({super.key, required this.payload});
  String safeString(dynamic value, [String fallback = '']) {
    if (value == null) return fallback;
    if (value is String) return value;
    return value.toString();
  }

  Widget safeNetworkImage(String? url,
      {double width = 60, double height = 60, BoxFit fit = BoxFit.cover}) {
    if (url == null || url.isEmpty) {
      return const Icon(Icons.image_not_supported,
          size: 60, color: Colors.grey);
    }
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: width,
          height: height,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: width,
          height: height,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
  }

  Widget animatedCard({required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, scale, _) =>
          Transform.scale(scale: scale, child: child),
    );
  }

  // Fixed desktop width with responsive fallback
  double cardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Desktop fixed width increased to 1400
    const desktopWidth = 1400.0;
    // Use fixed width for desktop, responsive for mobile
    return width >= 1400 ? desktopWidth : width * 0.95;
  }

  // Adjusted cards per row for desktop layout
  int cardsPerRow(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1400) return 4; // Desktop: always 4 cards
    if (width >= 800) return 3;
    if (width >= 400) return 2;
    return 1;
  }

  Widget squareCard({
    required Widget image,
    required String title,
    String? subtitle,
    double size = 220, // Increased card size
    VoidCallback? onTap,
  }) {
    Widget cardContent = SizedBox(
      width: size,
      height: size,
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size * 0.7, // Increased image container size
                height: size * 0.6,
                child: image,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                )
              ]
            ],
          ),
        ),
      ),
    );
    if (onTap != null) {
      return InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: cardContent,
      );
    }
    return cardContent;
  }

  // Rest of the methods remain the same but update size parameter in squareCard calls to 220
  Widget _buildCareerSection(BuildContext context, dynamic data) {
    if (data is! List) {
      return _buildErrorCard('Career data invalid');
    }
    return _buildSectionGrid(
      context,
      title: 'Top Career Choices recommended for you',
      items: data,
      itemBuilder: (item) {
        if (item is! Map<String, dynamic>) {
          return _buildErrorListTile(item.toString());
        }
        final title = safeString(item['title'], 'No Title');
        final description = safeString(item['description'], 'No Description');
        final imageUrl = safeString(item['imageUrl']);
        return animatedCard(
          child: squareCard(
            image: safeNetworkImage(imageUrl, width: 120, height: 120),
            title: title,
            subtitle: description,
            size: 220,
          ),
        );
      },
    );
  }

  // Previous section building methods updated with new size
  Widget _buildFashionStyleSection(BuildContext context, dynamic data) {
    if (data is! List) return _buildErrorCard('Fashion Style data invalid');
    return _buildSectionGrid(
      context,
      title: 'Fashion Styles For You',
      items: data,
      itemBuilder: (item) {
        if (item is! Map<String, dynamic>) {
          return _buildErrorListTile(item.toString());
        }
        final title = safeString(item['title'], 'No Title');
        final description = safeString(item['description'], 'No Description');
        final imageUrl = safeString(item['imageUrl']);
        return animatedCard(
          child: squareCard(
            image: safeNetworkImage(imageUrl, width: 120, height: 120),
            title: title,
            subtitle: description,
            size: 220,
          ),
        );
      },
    );
  }

  Widget _buildPersonalitySection(BuildContext context, dynamic data) {
    if (data is! List) return _buildErrorCard('Personality data invalid');
    return _buildSectionGrid(
      context,
      title: 'Your Personality Info',
      items: data,
      itemBuilder: (item) {
        if (item is! Map<String, dynamic>) {
          return _buildErrorListTile(item.toString());
        }
        final text = safeString(item['text'], 'No description');
        final imageUrl = safeString(item['imageUrl']);
        return animatedCard(
          child: squareCard(
            image: safeNetworkImage(imageUrl, width: 120, height: 120),
            title: text,
            size: 220,
          ),
        );
      },
    );
  }

  Widget _buildResumeSection(BuildContext context, dynamic data) {
    if (data is! List) return _buildErrorCard('Resume data invalid');
    return _buildSectionGrid(
      context,
      title: 'Career Goals',
      items: data,
      itemBuilder: (item) {
        if (item is! Map<String, dynamic>) {
          return _buildErrorListTile(item.toString());
        }
        final text = safeString(item['text'], 'No details');
        final imageUrl = safeString(item['imageUrl']);
        return animatedCard(
          child: squareCard(
            image: safeNetworkImage(imageUrl, width: 120, height: 120),
            title: text,
            size: 220,
          ),
        );
      },
    );
  }

// Launches YouTube video using the video ID
  void _launchYoutubeVideo(String videoId) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

// Fetches YouTube videos from YouTube Data API
  Future<List<Map<String, dynamic>>> fetchYoutubeVideos(String query) async {
    final apiKey = 'AIzaSyCoNb3p615gTDOuVF6-4Gg2R0netDlmR2M';
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=6&q=${Uri.encodeQueryComponent(query)}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'] ?? [];

      return items
          .where((item) =>
              item['id'] != null &&
              item['id']['videoId'] != null &&
              item['snippet'] != null)
          .map<Map<String, dynamic>>((item) {
        final snippet = item['snippet'];
        final videoId = item['id']['videoId'];
        return {
          'videoId': videoId,
          'title': snippet['title'] ?? 'Untitled',
          'thumbnail': snippet['thumbnails']?['high']?['url'] ?? '',
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch YouTube videos');
    }
  }

// Fetches all videos for multiple search queries
  Future<List<Map<String, dynamic>>> _fetchAllYoutubeVideos(
      List<String> queries) async {
    List<Map<String, dynamic>> allVideos = [];

    for (final query in queries) {
      try {
        final videos = await fetchYoutubeVideos(query);
        allVideos.addAll(videos);
      } catch (e) {
        debugPrint('Failed to fetch for query "$query": $e');
      }
    }

    return allVideos;
  }

// Builds YouTube Videos UI section
  Widget _buildYoutubeVideosSection(
      BuildContext context, List<String> queries) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchAllYoutubeVideos(queries),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _buildErrorCard('Error: ${snapshot.error}');
        }

        final videos = snapshot.data ?? [];
        if (videos.isEmpty) {
          return _buildErrorCard('No YouTube videos found.');
        }

        return _buildSectionGrid(
          context,
          title: 'Recommended YouTube Videos',
          items: videos,
          itemBuilder: (item) {
            final videoId = item['videoId'] ?? '';
            final title = item['title'] ?? 'No title';
            final thumbnailUrl = item['thumbnail'] ?? '';

            return animatedCard(
              child: squareCard(
                image: safeNetworkImage(thumbnailUrl,
                    width: 140, height: 105, fit: BoxFit.cover),
                title: title,
                size: 220,
                onTap: () {
                  if (videoId.isNotEmpty) {
                    _launchYoutubeVideo(videoId);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionGrid(BuildContext context,
      {required String title,
      required List<dynamic> items,
      required Widget Function(dynamic) itemBuilder}) {
    final crossAxisCount = cardsPerRow(context);
    final width = cardWidth(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        )),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return itemBuilder(items[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.red.shade100,
      child: ListTile(
        leading: const Icon(Icons.error_outline, color: Colors.red),
        title: Text(message, style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget _buildErrorListTile(String message) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.error, color: Colors.redAccent),
        title: Text(message),
        subtitle: const Text('Invalid data format'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buddy = safeString(payload['buddy'], 'Friend');

    return Scaffold(
      // backgroundColor: Colors.grey[100],
      body: Theme(
        data: Theme.of(context).copyWith(
          scaffoldBackgroundColor:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.grey[100],
          cardColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[850]
              : Colors.white,
          shadowColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black54
              : Colors.black12,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxContentWidth = cardWidth(context);
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Container(
                    width: maxContentWidth,
                    constraints: const BoxConstraints(maxWidth: 1400),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[850]
                          : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Buddy:  $buddy',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurpleAccent,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Made with Trae AI 🤖",
                          style: TextStyle(fontSize: 20, color: Colors.white60),
                        ),
                        const SizedBox(height: 40),
                        if (payload['career'] != null)
                          _buildCareerSection(context, payload['career']),
                        if (payload['fashion_style'] != null)
                          _buildFashionStyleSection(
                              context, payload['fashion_style']),
                        if (payload['personality'] != null)
                          _buildPersonalitySection(
                              context, payload['personality']),
                        if (payload['resume'] != null)
                          _buildResumeSection(context, payload['resume']),
                        if (payload['youtube_videos'] != null)
                          _buildYoutubeVideosSection(
                              context, payload['youtube_videos']),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
