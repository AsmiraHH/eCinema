import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:flutter/material.dart';

class ReservationSuccessScreen extends StatefulWidget {
  static const String routeName = '/reservationSuccess';

  const ReservationSuccessScreen({super.key});

  @override
  State<ReservationSuccessScreen> createState() => _ReservationSuccessScreenState();
}

class _ReservationSuccessScreenState extends State<ReservationSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: darkRedColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                const Column(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white, size: 64),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Your tickets have been booked!',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false, arguments: 2),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.white,
                      foregroundColor: darkRedColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    child: const Text(
                      "SEE YOUR BOOKINGS",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 0.7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
