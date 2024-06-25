import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:review_hub_admin/add.dart';
import 'package:review_hub_admin/babyproducts.dart';
import 'package:review_hub_admin/channels.dart';
import 'package:review_hub_admin/constants/color.dart';
import 'package:review_hub_admin/customWidgets/customText.dart';
import 'package:review_hub_admin/dashboard.dart';
import 'package:review_hub_admin/drawer.dart';
import 'package:review_hub_admin/item_view.dart';
import 'package:review_hub_admin/login.dart';
import 'package:review_hub_admin/movies.dart';
import 'package:review_hub_admin/restaurents.dart';
import 'package:review_hub_admin/services.dart';

class Clothes extends StatefulWidget {
  const Clothes({super.key});

  @override
  State<Clothes> createState() => _ClothesState();
}

class _ClothesState extends State<Clothes> {
  
  late final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final String _clothCollection = 'items'; // Replace with actual collection name

  late Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _futureClothes;

  @override
  void initState() {
    super.initState();
    _futureClothes = _fetchClothes();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _fetchClothes() async {
    try {
      final querySnapshot = await _firestore.collection(_clothCollection).where('category',isEqualTo: 'Clothes').get();
      return querySnapshot.docs.toList();
    } catch (error) {
      print('Error fetching Clothes: $error');
      rethrow; // Rethrow for error handling in FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: const Text("Clothes Review"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(text: 'Clothes', weight: FontWeight.bold, size: 18, textcolor: customBalck),
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
              future: _futureClothes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  final clothes = snapshot.data!;
                  return ResponsiveGridList(
                    desiredItemWidth:300,
                    minSpacing: 10,
                    children: clothes.map((clothes) => _buildMovieCard(clothes)).toList(),
                  );
                } else {
                  return const Text('No Clothes found');
                }
              },
            ),
          ),
        ],
      ),
      drawer: customDrawer(context)
      
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