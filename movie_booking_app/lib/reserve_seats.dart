import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReserveSeats extends StatefulWidget {
  final String movieId;
  final String timeSlot;

  ReserveSeats({required this.movieId, required this.timeSlot});

  @override
  _ReserveSeatsState createState() => _ReserveSeatsState();
}

class _ReserveSeatsState extends State<ReserveSeats> {
  final TextEditingController _seatsController = TextEditingController();
  int remainingSeats = 0;

  @override
  void initState() {
    super.initState();
    checkAvailability();
  }

  Future<void> checkAvailability() async {
    final response = await http.get(
      Uri.parse('http://localhost:5001/api/movies/${widget.movieId}/timeSlot/${widget.timeSlot}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print(data);
      setState(() {
        
        remainingSeats = data['availableSeats'];  
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking availability')),
      );
    }
  }

  Future<void> reserveSeats() async {
    final response = await http.post(
      Uri.parse('http://localhost:5001/api/movies/${widget.movieId}/timeSlot/${widget.timeSlot}/reserve'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'numSeats': int.parse(_seatsController.text)}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reservation successful!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reserve seats.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve Seats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Remaining seats: $remainingSeats'),
            TextField(
              controller: _seatsController,
              decoration: InputDecoration(
                labelText: 'Number of seats',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: remainingSeats > 0 ? reserveSeats : null,
              child: Text('Reserve Seats'),
            ),
          ],
        ),
      ),
    );
  }
}
