import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddHotelPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imagelinkController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mapsController = TextEditingController();

  AddHotelPage({super.key});

  Future<void> _addHotel(BuildContext context) async {
    // Add hotel to Firestore
    await FirebaseFirestore.instance.collection('hotels').add({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'image': _imagelinkController.text,
      'address': _addressController.text,
      'maps' : _mapsController.text
    });
    // Navigate back to home page
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Hotel')),
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
              onPressed: () => _addHotel(context), // Pass context here
              child: const Text('Tambah Hotel', style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}