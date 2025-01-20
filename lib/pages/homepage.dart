import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reviewhotelpab/pages/favorite.dart';
import 'package:reviewhotelpab/pages/profile.dart';
import 'package:reviewhotelpab/pages/homedetail.dart';
import 'package:reviewhotelpab/pages/addhotel.dart'; // Ensure this import exists

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({super.key, required this.userId, required String userRole, required String userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DocumentSnapshot> hotels = [];
  String? bannerUrl;
  String? userName;
  String? userRole; // To store the user role
  final double cardHeight = 200;

  int _selectedIndex = 0; // Index for BottomNavigationBar

  @override
  void initState() {
    super.initState();
    fetchHotels();
    fetchBanner();
    fetchUserData();
  }

  Future<void> fetchHotels() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('hotels').get();
    setState(() {
      hotels = snapshot.docs;
    });
  }

  Future<void> fetchBanner() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('banners').get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        bannerUrl = snapshot.docs.first['url'];
      });
    }
  }

  Future<void> fetchUserData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('profile')
        .doc(widget.userId)
        .get();
    if (snapshot.exists) {
      setState(() {
        userName = snapshot['name'];
        userRole = snapshot['role'];
      });
    }
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pages for BottomNavigationBar
    final List<Widget> _pages = [
      buildHomeContent(),
      FavoritesPage(userId: widget.userId),
      ProfilePage(userId: widget.userId),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vitel - Aplikasi Review Hotel',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        actions: [
          if (userRole == 'admin') // Show Add Icon if the user is an admin
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddHotelPage(),
                  ),
                );
              },
            ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }

  // Widget for Home Content
  Widget buildHomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Selamat datang, ${userName ?? 'Pengguna'}!',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (bannerUrl != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                bannerUrl!,
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ),
          ),
        const SizedBox(height: 16),
        Expanded(
          child: hotels.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              var hotel = hotels[index].data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HotelDetailPage(hotel: hotels[index]),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          bottomLeft: Radius.circular(12.0),
                        ),
                        child: Image.network(
                          hotel['image'], // URL of hotel image
                          height: cardHeight,
                          width: cardHeight,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hotel['name'] ?? 'Nama Hotel',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                hotel['description'] ??
                                    'Deskripsi tidak tersedia',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  FutureBuilder<double>(
                                    future: calculateAverageRating(hotels[index].id.toString()),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Text('Loading...');
                                      } else if (snapshot.hasError) {
                                        return const Text('Error');
                                      } else {
                                        return Text(
                                          '${snapshot.data?.toStringAsFixed(1) ?? 'N/A'}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  Future<double> calculateAverageRating(String hotelId) async {
    QuerySnapshot commentsSnapshot = await FirebaseFirestore.instance
        .collection('hotels')
        .doc(hotelId)
        .collection('comments')
        .get();

    if (commentsSnapshot.docs.isEmpty) {
      return 0.0; // No comments, return 0
    }

    double totalRating = 0.0;
    for (var doc in commentsSnapshot.docs) {
      totalRating += doc['rating'] ?? 0.0; // Assuming 'rating' field exists
    }

    return totalRating / commentsSnapshot.docs.length; // Calculate average
  }
}
