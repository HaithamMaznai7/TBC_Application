import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tbc_application/util/constants/colors.dart';

class CustomCurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final int notificationCount;
  final VoidCallback? onBack;
  final VoidCallback? onSearch;
  final VoidCallback? onNotification;

  const CustomCurvedAppBar({
    super.key,
    this.title,
    this.notificationCount = 0,
    this.onBack,
    this.onSearch,
    this.onNotification,
  });
 
  @override
  Size get preferredSize => const Size.fromHeight(130);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: BottomCurveClipper(),
          child: Container(
            height: preferredSize.height,
            color: FColors.primary, // Replace with your FColors.primary
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: _streamUser(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                        case ConnectionState.done:
                          Map<String, dynamic> user = snapshot.data!.data()!;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: FColors.primaryExtraSoft,
                                child: ClipOval(
                                  child: Image.network(
                                    (user["avatar"] == null || user['avatar'] == "") ? "https://ui-avatars.com/api/?name=${user['fullname']}&color=00f" : user['avatar'],
                                    fit: BoxFit.cover,
                                  ),
                                )
                              ),
                              Text(
                                title ?? 'TBC Application',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: onSearch,
                                    icon: const Icon(Icons.search, color: Colors.white),
                                  ),
                                  Stack(
                                    children: [
                                      IconButton(
                                        onPressed: onNotification,
                                        icon: const Icon(Icons.notifications_none, color: Colors.white),
                                      ),
                                      if (notificationCount > 0)
                                        Positioned(
                                          right: 6,
                                          top: 6,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              notificationCount.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          );
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          return Center(child: Text("Error"));
                      }
                    })
                ),
              ),
            ),
          ),
      ],
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _streamUser() async* {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    yield* firestore.collection("employee").doc(uid).snapshots();
  }

}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    final firstCurve = Offset(0, size.height - 20);
    final lastCurve = Offset(30, size.height - 20);

    path.quadraticBezierTo(firstCurve.dx, firstCurve.dy, lastCurve.dx, lastCurve.dy);

    final secondFirstCurve = Offset(0, size.height - 20);
    final secondLastCurve = Offset(size.width - 30, size.height - 20);

    path.quadraticBezierTo(secondFirstCurve.dx, secondFirstCurve.dy, secondLastCurve.dx, secondLastCurve.dy);

    final thirdFirstCurve = Offset(size.width, size.height - 20);
    final thirdLastCurve = Offset(size.width, size.height);

    path.quadraticBezierTo(thirdFirstCurve.dx, thirdFirstCurve.dy, thirdLastCurve.dx, thirdLastCurve.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
