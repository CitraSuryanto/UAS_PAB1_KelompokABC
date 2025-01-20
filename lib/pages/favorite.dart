import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reviewhotelpab/pages/homedetail.dart';
import 'package:reviewhotelpab/pages/homelistitem.dart';

class FavoritesPage extends StatefulWidget {
  final String userId;

  const FavoritesPage({super.key, required this.userId});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Set<String> favoriteHotelIds = {};

  @override
  void initState() {
    super.initState();
    fetchFavoriteHotelIds();
  }

  Future<void> fetchFavoriteHotelIds() async {
    try {
      // Ambil semua dokumen di koleksi `favorites` dengan userId terkait
      QuerySnapshot favoriteSnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: widget.userId)
          .get();

      // Simpan hotelId ke dalam set
      setState(() {
        favoriteHotelIds = favoriteSnapshot.docs
            .map((doc) => doc['hotelId'] as String)
            .toSet();
      });
    } catch (e) {
      print("Error fetching favorite hotel IDs: $e");
    }
  }

  Future<void> toggleFavoriteStatus(DocumentSnapshot hotel) async {
    try {
      String hotelId = hotel.id;

      if (favoriteHotelIds.contains(hotelId)) {
        // Hapus dari favorit
        await FirebaseFirestore.instance
            .collection('favorites')
            .where('userId', isEqualTo: widget.userId)
            .where('hotelId', isEqualTo: hotelId)
            .get()
            .then((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.delete();
          }
        });

        setState(() {
          favoriteHotelIds.remove(hotelId);
        });
      } else {
        // Tambahkan ke favorit
        await FirebaseFirestore.instance.collection('favorites').add({
          'userId': widget.userId,
          'hotelId': hotelId,
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          favoriteHotelIds.add(hotelId);
        });
      }
    } catch (e) {
      print("Error toggling favorite status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Hotels',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: favoriteHotelIds.isEmpty
          ? const Center(child: Text('No favorite hotels found.'))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hotels found.'));
          } else {
            // Filter hotel favorit
            var hotels = snapshot.data!.docs.where((hotel) {
              return favoriteHotelIds.contains(hotel.id);
            }).toList();

            return ListView.builder(
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                DocumentSnapshot hotel = hotels[index];
                return HotelListItem(
                  hotel: hotel,
                  isFavorite: favoriteHotelIds.contains(hotel.id),
                  onFavoriteToggle: () => toggleFavoriteStatus(hotel),
                  onTap: () async {
                    bool? shouldRefresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HotelDetailPage(hotel: hotel),
                      ),
                    );
                    if (shouldRefresh == true) {
                      fetchFavoriteHotelIds();
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
