
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:review_hub_admin/constants/color.dart';
import 'package:review_hub_admin/customWidgets/customText.dart';
import 'package:review_hub_admin/dashboard.dart';
import 'package:review_hub_admin/channels.dart';
import 'package:review_hub_admin/drawer.dart';
import 'package:review_hub_admin/item_view.dart';
import 'package:review_hub_admin/services.dart';
import 'package:review_hub_admin/babyproducts.dart';
import 'package:review_hub_admin/add.dart';

class Restaurants extends StatefulWidget {
  const Restaurants({Key? key}) : super(key: key);

  @override
  _RestaurantsState createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  late final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final String _RestaurantsCollection = 'items'; // Replace with actual collection name

  late Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _futureRestaurants;

  @override
  void initState() {
    super.initState();
    _futureRestaurants = _fetchRestaurants();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _fetchRestaurants() async {
    try {
      final querySnapshot = await _firestore.collection(_RestaurantsCollection).where('category',isEqualTo: 'Hotel').get();
      return querySnapshot.docs.toList();
    } catch (error) {
      print('Error fetching Restaurants: $error');
      rethrow; // Rethrow for error handling in FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: const Text("Restaurants Review"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(text: 'Restaurants', weight: FontWeight.bold, size: 18, textcolor: customBalck),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20,
                  unratedColor: Colors.grey,
                  itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    // Implement your functionality with the rating value
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
              future: _futureRestaurants,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  final Restaurants = snapshot.data!;
                  return ResponsiveGridList(
                    desiredItemWidth:300,
                    minSpacing: 10,
                    children: Restaurants.map((hotel) => _buildMovieCard(hotel)).toList(),
                  );
                } else {
                  return const Text('No Restaurants found');
                }
              },
            ),
          ),
        ],
      ),
      drawer: customDrawer(context),
      
    );
  }
  Widget _buildMovieCard(QueryDocumentSnapshot<Map<String, dynamic>> movie) {
  final movieData = movie.data();
  if (movieData == null) return const SizedBox(); // Handle potential null data

  final imageUrl = movieData['image_url'] as String;
  final name = movieData['name'] as String;

  return InkWell(
    onTap: () {
      Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemView(
                    name: name, image: imageUrl, about: movieData['about'])));
    },
    child: Card(
      child: Container(
        height: 300,
        width: 150,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 240,
              width: 350,
              child: Image.network(
                imageUrl,
                // height: 150,
                fit: BoxFit.cover,
                // errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
            SizedBox(height: 10),
            Text(name ?? 'No name', style: TextStyle(color: customBalck, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}

}
