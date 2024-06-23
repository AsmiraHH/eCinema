import 'package:ecinema_mobile/models/seat.dart';
import 'package:flutter/material.dart';

class ReservationSeatsListItem extends StatelessWidget {
  const ReservationSeatsListItem({
    super.key,
    required this.seat,
  });

  final Seat seat;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '${seat.row}-${seat.column}',
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
        ),
      ),
    );
  }
}
