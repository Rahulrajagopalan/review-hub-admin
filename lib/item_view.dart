import 'dart:js_interop_unsafe';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:review_hub_admin/constants/color.dart';
import 'package:review_hub_admin/customWidgets/customText.dart';

class ItemView extends StatefulWidget {
  const ItemView(
      {super.key,
      required this.name,
      required this.image,
      required this.about});
  final String name;
  final String image;
  final String about;

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  Future<Stream<QuerySnapshot>> getReview() async {
    return await FirebaseFirestore.instance
        .collection("reviews")
        .where("item", isEqualTo: widget.name)
        .snapshots();
  }

  Stream? reviewStream;

  getOnTheLoad() async {
    reviewStream = await getReview();
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Future<double> calculateAverageRating(String itemName) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('item', isEqualTo: itemName)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return 0.0; // No reviews, thus no average rating
      }

      double totalRating = 0;
      querySnapshot.docs.forEach((doc) {
        totalRating += doc.data()['rating'];
      });
      print(5 / querySnapshot.docs.length);
      return 5 / querySnapshot.docs.length;
    } catch (e) {
      print("Error fetching reviews: $e");
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              child: Image.network(
                widget.image,
                fit: BoxFit.fill,
              ),
              width: double.infinity,
            ),
            SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    AppText(
                        text: widget.name,
                        weight: FontWeight.bold,
                        size: 20,
                        textcolor: customBalck),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                                width: 400,
                                child: Expanded(
                                    child: Text(
                                  widget.about,
                                  style: GoogleFonts.poppins(),
                                ))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    AppText(
                        text: 'Rating and Reviews',
                        weight: FontWeight.bold,
                        size: 20,
                        textcolor: customBalck),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                                width: 400,
                                child: Expanded(
                                    child: Text(
                                  'Rating and Reviews are verified and are from people who use the same type of device that you use',
                                  style: GoogleFonts.poppins(),
                                ))),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder(
                              future: calculateAverageRating(widget.name),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                double rating = snapshot.data ?? 0.0;

                                return Column(
                                  children: [
                                    AppText(
                                        text: rating.toString(),
                                        weight: FontWeight.w400,
                                        size: 35,
                                        textcolor: customBalck),
                                    RatingBar.builder(
                                      initialRating: rating.toDouble(),
                                      minRating: 1,
                                      ignoreGestures: true,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 18,
                                      unratedColor: Colors.yellow[100],
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 1),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        (rating);
                                      },
                                    ),
                                  ],
                                );
                              }),
                          Image.asset('assets/images/rating.png')
                        ],
                      ),
                    ),
                    Container(
                      height: 70,
                      color: grey,
                      child: StreamBuilder(
                          stream: reviewStream,
                          builder: (context, snap) {
                            if (snap.hasError) {
                              return Text('Error: ${snap.error}');
                            }
                            if (!snap.hasData) {
                              return const SizedBox(
                                  width: double.infinity,
                                  child:
                                      Center(child: Text("No reviews yet.")));
                            }
                            return ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: snap.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot ds = snap.data.docs[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/images/profile.png'),
                                    ),
                                    title: AppText(
                                        text: ds['user'],
                                        weight: FontWeight.w600,
                                        size: 18,
                                        textcolor: white),
                                    subtitle: AppText(
                                        text: ds['review'],
                                        weight: FontWeight.w400,
                                        size: 15,
                                        textcolor: white),
                                    trailing: IconButton(
                                        onPressed: () async {
                                          try {
                                            // Query the reviews collection where the "user" field matches the current user ID
                                            QuerySnapshot querySnapshot =
                                                await FirebaseFirestore.instance
                                                    .collection("reviews")
                                                    .where("user",
                                                        isEqualTo: ds['user'])
                                                    .get();

                                            // Iterate through the documents and delete them
                                            for (QueryDocumentSnapshot doc
                                                in querySnapshot.docs) {
                                              await doc.reference.delete();
                                            }

                                            print(
                                                'Successfully deleted user reviews.');
                                          } catch (e) {
                                            print(
                                                'Error deleting user reviews: $e');
                                          }
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        )),
                                  );
                                });
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
