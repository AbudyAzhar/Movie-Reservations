import 'package:flutter/material.dart';
import 'reserve_seats.dart';

class TimeSlotSelection extends StatelessWidget {
  final String movieId;
  final List timeSlots;

  TimeSlotSelection({required this.movieId, required this.timeSlots});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Time Slot'),
      ),
      body: ListView.builder(
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          int remainingSeats = timeSlots[index]['capacity'] - timeSlots[index]['bookedCount'];  
          return ListTile(
            title: Text('Time: ${timeSlots[index]['time']}, Remaining Seats: $remainingSeats'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReserveSeats(
                    movieId: movieId,
                    timeSlot: timeSlots[index]['time'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
