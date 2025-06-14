import 'package:buddy/pages/B_skillfull-web/skillfull_home_page.dart';
import 'package:buddy/pages/B_skillfull-web/logic/jobs/job_model.dart';
import 'package:buddy/pages/_logik/components/theme_color_mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class AllJobsScreen extends StatelessWidget {
  const AllJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors =
        getThemeColorsMainPages('freelancer', brightness: brightness);

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SkillfullHomePage(userType: 'freelancer'),
            ),
          );
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SkillfullHomePage(userType: 'freelancer'),
                ),
              );
            },
          ),
          title: const Text('All Job Listings'),
          backgroundColor: colors.fieldFillColor,
          foregroundColor: colors.textColor,
        ),
        backgroundColor: colors.fieldFillColor,
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseAuth.instance.currentUser == null
              ? Future.value(null) // User not logged in
              : FirebaseFirestore.instance.collection('jobs').get(),
          builder: (context, snapshot) {
            if (FirebaseAuth.instance.currentUser == null) {
              return noJobsFallback();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return noJobsFallback();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return noJobsFallback();
            }

            final jobs = snapshot.data!.docs
                .map((doc) => Job.fromDocument(doc))
                .toList();

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                final deadlineText = _formatDeadline(job.deadline);
                final isUrgent = deadlineText.startsWith('#');
                final isExpired = deadlineText == 'Expired';
                final noDeadline = deadlineText == 'No deadline';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: colors.backgroundGradient.first.withOpacity(0.85),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colors.textColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          job.clientName,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textColor.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          (job.description != null &&
                                  job.description!.trim().isNotEmpty)
                              ? job.description!
                              : 'Apply now to get more information on this job',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textColor.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              job.price,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: colors.buttonColor,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 14, color: Colors.orangeAccent),
                                const SizedBox(width: 4),
                                Text(
                                  deadlineText.replaceFirst('#', '').trim(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontStyle:
                                          isExpired ? FontStyle.italic : null,
                                      color: isExpired
                                          ? colors.auxIconColor
                                          : isUrgent
                                              ? Colors.red
                                              : noDeadline
                                                  ? Colors.green
                                                  : Colors.green,
                                      fontWeight: isExpired
                                          ? FontWeight.w800
                                          : isUrgent
                                              ? FontWeight.w800
                                              : noDeadline
                                                  ? FontWeight.w500
                                                  : FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              job.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.textColor.withOpacity(0.7),
                              ),
                            ),
                            if (job.distance != null) ...[
                              const SizedBox(width: 16),
                              const Icon(Icons.directions_walk,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                job.distance!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.textColor.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// Format deadline with urgency styling
String _formatDeadline(dynamic deadline) {
  if (deadline == null) return 'No deadline';

  try {
    DateTime date;

    if (deadline is Timestamp) {
      date = deadline.toDate();
    } else if (deadline is DateTime) {
      date = deadline;
    } else if (deadline is String) {
      date = DateTime.parse(deadline);
    } else {
      return 'Invalid date';
    }

    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) return 'Expired';
    if (difference == 0) return '# Today';
    if (difference <= 3) {
      return '# $difference day${difference > 1 ? 's' : ''} left';
    }

    return '$difference days left';
  } catch (e) {
    return 'Invalid date';
  }
}

Widget noJobsFallback() {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No Jobs Available at the moment',
                style: TextStyle(
                  fontSize: isMobile ? 20 : 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: isMobile ? 200 : 300,
                child: Lottie.asset('assets/animation/no_jobs.json'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
