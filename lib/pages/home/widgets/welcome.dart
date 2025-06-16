import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/pages/home/widgets/wave_clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  var message = '';
  var timeNow = int.parse(DateFormat('kk').format(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(children: [
      ClipPath(
        clipper: WaveClipper(),
        child: Container(
          padding: getPadding(all: defaultPadding),
          color: colorScheme.primary,
          height: height * 0.2,
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(), // Use snapshots() to listen for real-time updates
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(
                      child: Text('User data not found.'),
                    );
                  }

                  // Extract data
                  String displayName = snapshot.data!['name'];
                  String? photoUrl = snapshot.data!['photoURL'];

                  // Get the current time
                  int timeNow = DateTime.now().hour;

                  return Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(photoUrl ?? ''),
                        //backgroundColor: colorScheme.onSecondary,
                        radius: 50.0,
                      ),
                      const SizedBox(width: defaultPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              timeNow <= 12
                                  ? 'Good Morning'
                                  : ((timeNow > 12) && (timeNow <= 16))
                                      ? 'Good Afternoon'
                                      : 'Good Evening',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.white70),
                            ),
                            Text(
                              displayName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
