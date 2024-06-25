import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:review_hub_admin/constants/color.dart';
import 'package:review_hub_admin/customWidgets/customText.dart';
import 'package:review_hub_admin/drawer.dart';
import 'package:review_hub_admin/item_view.dart';

class Makeup extends StatefulWidget {
  const Makeup({super.key});

  @override
  State<Makeup> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Makeup> {
  
  late final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final String _clothCollection = 'items'; // Replace with actual collection name

  late Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _futureMakeup;

  @override
  void initState() {
    super.initState();
    _futureMakeup = _fetchMakeup();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _fetchMakeup() async {
    try {
      final querySnapshot = await _firestore.collection(_clothCollection).where('category',isEqualTo: 'MakeUp').get();
      return querySnapshot.docs.toList();
    } catch (error) {
      print('Error fetching Makeup: $error');
      rethrow; // Rethrow for error handling in FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: const Text("Makeup Review"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(text: 'Makeup', weight: FontWeight.bold, size: 18, textcolor: customBalck),
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
              future: _futureMakeup,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  final Makeup = snapshot.data!;
                  return ResponsiveGridList(
                    desiredItemWidth:300,
                    minSpacing: 10,
                    children: Makeup.map((Makeup) => _buildMakeUpCard(Makeup)).toList(),
                  );
                } else {
                  return const Text('No Makeup found');
                }
              },
            ),
          ),
        ],
      ),
      drawer: customDrawer(context)
      
    );
  }
  Widget _buildMakeUpCard(QueryDocumentSnapshot<Map<String, dynamic>> MakeUp) {
  final MakeUpData = MakeUp.data();
  if (MakeUpData == null) return const SizedBox(); // Handle potential null data

  final imageUrl = MakeUpData['image_url'] as String;
  final name = MakeUpData['name'] as String;

  return InkWell(
    onTap: () {
      Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemView(
                    name: name, image: imageUrl, about: MakeUpData['about'])));
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