import 'package:buddy/pages/B_skillfull-web/logic/ads/ads_carousel.dart';
import 'package:buddy/pages/B_skillfull-web/logic/ads/ads_carousel_basetwo.dart';
import 'package:buddy/pages/B_skillfull-web/logic/ads/freelancers_boost_profileAd.dart';
import 'package:buddy/pages/B_skillfull-web/logic/jobs/all_jobs_screen.dart';
import 'package:buddy/pages/B_skillfull-web/logic/jobs/job_model.dart';
import 'package:buddy/pages/B_skillfull-web/logic/jobs/jobs_within_freelancersskill.dart';
import 'package:buddy/pages/_logik/components/theme_color_mainpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

class FreelancerHomeScreen extends StatefulWidget {
  const FreelancerHomeScreen({super.key});

  @override
  State<FreelancerHomeScreen> createState() => _FreelancerHomeScreenState();
}

class _FreelancerHomeScreenState extends State<FreelancerHomeScreen> {
  List<Job> jobs = [];

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  // Fetch jobs from Firestore
  Future<void> loadJobs() async {
    var jobQuerySnapshot =
        await FirebaseFirestore.instance.collection('jobs').get();
    var jobList =
        jobQuerySnapshot.docs.map((doc) => Job.fromDocument(doc)).toList();

    setState(() {
      jobs = jobList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors =
        getThemeColorsMainPages('freelancer', brightness: brightness);

    final nearbyJobs = jobs.where((job) {
      // Show only jobs with distance available and <= 10 km
      final distanceStr = job.distance?.replaceAll(RegExp(r'[^\d.]'), '');
      final distance = double.tryParse(distanceStr ?? '');
      return distance != null && distance <= 150;
    }).toList();

    final topJobThreshold = getTopJobThreshold(jobs);
    final topJobs = jobs
        .where((job) =>
            job.priceValue >= topJobThreshold || job.isPremiumClient == true)
        .toList()
      ..sort((a, b) {
        // Premium jobs come first
        if (a.isPremiumClient && !b.isPremiumClient) return -1;
        if (!a.isPremiumClient && b.isPremiumClient) return 1;

        // If both same premium status, sort by price (high to low)
        return b.priceValue.compareTo(a.priceValue);
      });

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors.backgroundGradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Bar
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.fieldFillColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: colors.borderColor, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 20),
                        child: Row(
                          children: [
                            // Avatar + greeting
                            const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/animation/user.png'),
                              radius: 24,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Welcome back!',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colors.textColor,
                                    fontSize: 18,
                                  ),
                            ),
                            const Spacer(),

                            // Lottie + notifications
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Lottie.asset(
                                  'assets/animation/present2.json'),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: Icon(Icons.notifications_outlined,
                                  size: 30, color: colors.iconColor),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Welcome Section with Boost
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: FutureBuilder<String>(
                        future: getUsernameFromFirebase(),
                        builder: (context, snapshot) {
                          final username = snapshot.data ?? 'Freelancer';

                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 18),
                            decoration: BoxDecoration(
                              color: colors.fieldFillColor.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: colors.borderColor, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left side
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome back,',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: colors.iconColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        username,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: colors.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Right: Boost CTA
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: colors.buttonColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Lottie.asset(
                                        'assets/animation/rocket_boost.json',
                                        height: 36,
                                        width: 36,
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Boost your profile',
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w600,
                                              color: colors.textColor,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Earn more gigs',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: colors.iconColor
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          SizedBox(
                                            height: 26,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // Boost logic
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    colors.buttonColor,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: Text(
                                                'Boost',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: colors.textColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Search Bar
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search for Jobs...",
                          hintStyle: TextStyle(
                              color: colors.iconColor.withOpacity(0.8)),
                          prefixIcon:
                              Icon(Icons.search, color: colors.iconColor),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send, color: colors.iconColor),
                            onPressed: () {},
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: colors.borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: colors.borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: colors.focusedBorderColor,
                              width: 1.6,
                            ),
                          ),
                          filled: true,
                          fillColor: colors.fieldFillColor,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        style: TextStyle(color: colors.textColor),
                      ),
                    ),
                  ),
                ],
              ),
              /////////////////////////
              SizedBox(
                height: 12,
              ),
              //optional conatiner sliders ads?

              Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: const AdsCarousel()),
              ),

              const SizedBox(height: 24),

              // Top Job Offers
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    children: [
                      Text("Top Job Offers",
                          style: TextStyle(
                              color: colors
                                  .textColor, // Adjust to your color theme
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      topJobs.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'No top job offers available right now.',
                                style: TextStyle(
                                  color: colors.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: topJobs.map((job) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                      width: 225,
                                      margin: const EdgeInsets.only(right: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: colors.fieldFillColor,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                            color: colors.borderColor,
                                            width: 1),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 8,
                                            offset: Offset(4, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Top job tag
                                          if (job.isPremiumClient) ...[
                                            Row(
                                              children: [
                                                Icon(Icons.verified,
                                                    size: 16,
                                                    color: Colors.green),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Premium',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                          Row(
                                            children: [
                                              Icon(Icons.star,
                                                  size: 16,
                                                  color: colors.iconColor),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Top Job',
                                                style: TextStyle(
                                                  color: colors.iconColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),

                                          Text(
                                            job.title,
                                            style: TextStyle(
                                              color: colors.textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),

                                          Row(
                                            children: [
                                              Icon(Icons.person,
                                                  size: 15,
                                                  color: colors.auxIconColor),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  job.clientName,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: colors.iconColor,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),

                                          if ((job.description ?? '')
                                              .isNotEmpty) ...[
                                            const SizedBox(height: 12),
                                            Text(
                                              job.description!,
                                              style: TextStyle(
                                                  color: colors.textColor),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],

                                          const SizedBox(height: 12),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: colors.buttonColor
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Text(
                                                  job.price,
                                                  style: TextStyle(
                                                    color: colors.buttonColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Icon(Icons.arrow_forward_ios,
                                                  size: 14,
                                                  color: colors.iconColor),
                                            ],
                                          ),

                                          const SizedBox(height: 12),

                                          Row(
                                            children: [
                                              Icon(Icons.location_on,
                                                  size: 16,
                                                  color: colors.auxIconColor),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  job.location,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: colors.iconColor,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),

                                          if ((job.distance ?? '')
                                              .isNotEmpty) ...[
                                            const SizedBox(height: 12),
                                            Text(
                                              job.distance!,
                                              style: TextStyle(
                                                  color: colors.textColor),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],

                                          const SizedBox(height: 12),

                                          Row(
                                            children: [
                                              Icon(Icons.calendar_today,
                                                  size: 16,
                                                  color: colors.auxIconColor),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Builder(
                                                  builder: (_) {
                                                    if (job.deadline == null) {
                                                      return Text(
                                                        'No deadline',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              colors.iconColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      );
                                                    }

                                                    final now = DateTime.now();
                                                    final difference = job
                                                        .deadline!
                                                        .difference(now)
                                                        .inDays;

                                                    if (difference < 0) {
                                                      return Text(
                                                        'Expired',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      );
                                                    } else if (difference ==
                                                        0) {
                                                      return Text(
                                                        'Deadline today',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.orange,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      );
                                                    }

                                                    return Text(
                                                      '$difference day${difference == 1 ? '' : 's'} left',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ), ///////
              const SizedBox(height: 24),

              if (nearbyJobs.isNotEmpty) ...[
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Text(
                      "Job Openings Near You",
                      style: TextStyle(
                        color: colors.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Column(
                      children: nearbyJobs.map((job) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.fieldFillColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: colors.borderColor),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor:
                                    colors.buttonColor.withOpacity(0.15),
                                child: Icon(Icons.home_repair_service,
                                    color: colors.buttonColor, size: 22),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      job.title,
                                      style: TextStyle(
                                        color: colors.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${job.distance ?? 'Unknown'} • ${job.price}",
                                      style: TextStyle(
                                        color: colors.iconColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  size: 14, color: colors.iconColor),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
              //Profile Boost Ads,
              Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: FreelancerBoostAdWidget()),
              ),
              // PROMOTE YOURSELF QUICK AD WIDGET

              FutureBuilder<Map<String, String>>(
                future:
                    getFreelancerProfileData(), // Should return 'title', 'skill', 'imageUrl'
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();

                  final profile = snapshot.data!;
                  final title = profile['title'] ?? 'Freelancer';
                  final skill = profile['skill'] ?? 'Your services';
                  final imageUrl =
                      profile['imageUrl']; // Add this key in your data

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.fieldFillColor.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colors.borderColor.withOpacity(0.5),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigate to profile edit screen or trigger image change
                                Navigator.pushNamed(
                                    context, '/editProfile'); // Example route
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundImage: imageUrl != null
                                        ? NetworkImage(imageUrl)
                                        : const AssetImage(
                                                'assets/images/default_avatar.png')
                                            as ImageProvider,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Promote Yourself Instantly',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: colors.textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Tap your image to update it',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: colors.iconColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Create and share a quick ad about your services.',
                              style: TextStyle(
                                  fontSize: 13, color: colors.iconColor),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '"Hi, I’m $title. I offer $skill services. Let’s work together!"',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: colors.textColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final message =
                                        '📢 $title for hire!\n\nI specialize in $skill.\n\nLet’s work together. Contact me via the app!';
                                    await Share.share(message);
                                  },
                                  icon: const Icon(Icons.share, size: 16),
                                  label: const Text('Share'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colors.buttonColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    // Ads Carousel
                    child: AdsCarouselBaseTwo()),
              ), /////under adsss
              const SizedBox(height: 24),
              Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    // More Jobs Within Expertise
                    child: MoreJobsWithinExpertiseWidget()),
              ),
              // const SizedBox(height: 5),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, right: 16, left: 16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        //transparent tube kind Container,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: colors.fieldFillColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colors.borderColor,
                            width: 1,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllJobsScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'See More Jobs →',
                            style: TextStyle(
                              color: colors.buttonColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> getUsernameFromFirebase() async {
  final user = FirebaseAuth.instance.currentUser;
  return user?.displayName ?? user?.email?.split('@').first ?? 'Freelancer';
}

double getTopJobThreshold(List<Job> jobs) {
  final prices = jobs.map((j) => j.priceValue).toList();
  prices.sort();

  if (prices.isEmpty) return 0.0;

  int index = (prices.length * 0.75).floor(); // 75th percentile
  return prices[index];
}

Future<Map<String, String>> getFreelancerProfileData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return {};

  final doc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  if (!doc.exists) return {};

  final data = doc.data()!;
  return {
    'title': data['name'] ?? 'A Freelancer',
    'skill': data['skill'] ?? 'Several',
    'imageUrl': data['imageUrl'] ?? '', // Optional: default if not uploaded
  };
}
