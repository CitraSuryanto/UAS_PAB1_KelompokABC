import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditHotelPage extends StatefulWidget {
  final DocumentSnapshot hotel; // The hotel document to edit

  const EditHotelPage({super.key, required this.hotel});

  @override
  _EditHotelPageState createState() => _EditHotelPageState();
}

class _EditHotelPageState extends State<EditHotelPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imagelinkController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mapsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the current hotel data
    _nameController.text = widget.hotel['name'];
    _descriptionController.text = widget.hotel['description'];
    _imagelinkController.text = widget.hotel['image'];
    _addressController.text = widget.hotel['address'];
    _mapsController.text = widget.hotel['maps'];
  }

  Future<void> _updateHotel(BuildContext context) async {
    // Update hotel in Firestore
    await FirebaseFirestore.instance.collection('hotels').doc(widget.hotel.id).update({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'image': _imagelinkController.text,
      'address': _addressController.text,
      'maps': _mapsController.text,
    });
    // Navigate back to home page
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Hotel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Hotel Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _mapsController,
              decoration: const InputDecoration(labelText: 'Maps link'),
            ),
            TextField(
              controller: _imagelinkController,
              decoration: const InputDecoration(labelText: 'Image link'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address link'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _updateHotel(context), // Pass context here
              child: const Text('Update Hotel', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}