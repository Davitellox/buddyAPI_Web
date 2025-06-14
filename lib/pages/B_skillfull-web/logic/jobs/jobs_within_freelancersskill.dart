import 'dart:async';
import 'package:buddy/pages/B_skillfull-web/logic/jobs/job_model.dart';
import 'package:buddy/pages/_logik/components/theme_color_mainpage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoreJobsWithinExpertiseWidget extends StatefulWidget {
  const MoreJobsWithinExpertiseWidget({super.key});

  @override
  State<MoreJobsWithinExpertiseWidget> createState() =>
      _MoreJobsWithinExpertiseWidgetState();
}

class _MoreJobsWithinExpertiseWidgetState
    extends State<MoreJobsWithinExpertiseWidget> with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  List<Job> matchedJobs = [];
  bool isLoading = true;
  Timer? _autoScrollTimer;

  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    fetchJobsByUserSkill();

    _gradientController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients && matchedJobs.length > 1) {
        final nextPage =
            (_pageController.page!.round() + 1) % matchedJobs.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchJobsByUserSkill() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final userData = userDoc.data();
    if (userData == null || !userData.containsKey('skill')) {
      setState(() => isLoading = false);
      return;
    }

    final userSkill = userData['skill'];
    final query = await FirebaseFirestore.instance
        .collection('jobs')
        .where('category', arrayContains: userSkill)
        .get();

    setState(() {
      matchedJobs = query.docs.map((doc) => Job.fromDocument(doc)).toList();
      isLoading = false;
    });
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final diff = deadline.difference(now);
    if (diff.inDays > 0) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} left';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} left';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} min left';
    } else {
      return 'Deadline passed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors =
        getThemeColorsMainPages('freelancer', brightness: brightness);

    if (isLoading) {
      return const SizedBox(
          height: 180, child: Center(child: CircularProgressIndicator()));
    }
    if (matchedJobs.isEmpty) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, child) {
        final gradient = LinearGradient(
          colors: brightness == Brightness.dark
              ? [
                  const Color(0xFF0F0400),
                  const Color(0xFF1A0A00),
                  const Color(0xFF2A0F00),
                ]
              : [
                  const Color(0xFFFFF3E0),
                  const Color(0xFFFFE0B2),
                  const Color(0xFFFFF8E1),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [
            0.0,
            _gradientController.value,
            1.0,
          ],
        );

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'More Jobs Within Your Expertise',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: colors.textColor,
                  ),
                ),
              ),
              SizedBox(
                height: 280,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: matchedJobs.length,
                  itemBuilder: (context, index) {
                    final job = matchedJobs[index];
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          value = (_pageController.page! - index)
                              .abs()
                              .clamp(0.0, 1.0);
                        }
                        return Transform.scale(
                          scale: 1 - (value * 0.05),
                          child: child,
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/jobDetails',
                              arguments: job);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.fieldFillColor.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (job.isPremiumClient)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: colors.buttonColor.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '🌟 Premium Client',
                                    style: TextStyle(
                                        fontSize: 11, color: colors.textColor),
                                  ),
                                ),
                              const SizedBox(height: 6),
                              Text(
                                job.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              if (job.deadline != null)
                                Text(
                                  'Deadline: ${_formatDeadline(job.deadline!)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Text(
                                (job.description != null &&
                                        job.description!.trim().isNotEmpty)
                                    ? job.description!
                                    : 'Apply now to get more information on this job',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: colors.textColor.withOpacity(0.7),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    job.price,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: colors.buttonColor,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        job.location,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              colors.textColor.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
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
              ),
            ],
          ),
        );
      },
    );
  }
}
