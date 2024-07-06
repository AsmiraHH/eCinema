// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/models/reservation.dart';
import 'package:ecinema_mobile/models/seat.dart';
import 'package:ecinema_mobile/providers/reservation_provider.dart';
import 'package:ecinema_mobile/utils/error_dialog.dart';
import 'package:ecinema_mobile/utils/error_snackbar.dart';
import 'package:ecinema_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ReservationsScreen extends StatefulWidget {
  static const String routeName = '/reservations';

  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  late ReservationProvider reservationProvider;
  List<Reservation> reservationsResult = [];
  bool _isLoading = true;
  Reservation? selectedReservation;

  @override
  void initState() {
    super.initState();
    reservationProvider = context.read<ReservationProvider>();
    loadReservations();
  }

  void loadReservations() async {
    try {
      _isLoading = true;
      var data = await reservationProvider.getByUserId(Authorization.userId);
      if (mounted) {
        setState(() {
          reservationsResult = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  Future<void> cancelPaymentIntent() async {
    final response = await http.post(Uri.parse('https://api.stripe.com/v1/refunds'), headers: {
      'Authorization': 'Bearer $stripeSecretKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    }, body: {
      'payment_intent': selectedReservation!.transactionNumber!,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel the payment intent: ${response.body}');
    }
  }

  Future<void> deleteReservation() async {
    try {
      var response = await reservationProvider.delete(selectedReservation!.id!);

      if (response) {
        selectedReservation = null;
        loadReservations();
      }
    } catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  Future<void> cancelReservation() async {
    try {
      await cancelPaymentIntent();
      await deleteReservation();
      showErrorSnackBar(context, 'Reservation successfully cancelled.');
    } catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
              child: Text(
        'My Reservations',
      ))),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: reservationsResult.length,
              itemBuilder: (context, index) {
                return _buildReservation(context, reservationsResult[index]);
              },
            ),
    );
  }

  Widget _buildReservation(BuildContext context, Reservation reservation) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: !reservation.isActive! ? ThemeData().disabledColor : null,
      child: SizedBox(
        height: 180,
        child: Row(
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                child: fromBase64String(reservation.show!.movie!.photo!)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reservation.show!.movie!.title!.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range_outlined,
                          size: 19,
                          color: darkRedColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          DateFormat('dd.MM.yyyy').format(DateTime.parse(reservation.show!.dateTime.toString())),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_clock,
                          size: 19,
                          color: darkRedColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          DateFormat.Hm().format(DateTime.parse(reservation.show!.dateTime.toString())),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.monetization_on_outlined,
                          size: 19,
                          color: darkRedColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${reservation.totalPrice!.round()} BAM',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: reservation.transactionNumber == 'test'
                          ? null
                          : () {
                              selectedReservation = reservation;
                              _buildCancelDialog();
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(25),
                        backgroundColor: darkRedColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showGeneralDialog(
                  barrierColor: const Color(0xBF000000),
                  transitionDuration: const Duration(milliseconds: 400),
                  barrierDismissible: true,
                  barrierLabel: '',
                  context: context,
                  transitionBuilder: (context, a1, a2, dialog) {
                    final curveValue = (1 - Curves.linearToEaseOut.transform(a1.value)) * 200;
                    return Transform(
                      transform: Matrix4.translationValues(curveValue, 0.0, 0.0),
                      child: Opacity(opacity: a1.value, child: dialog),
                    );
                  },
                  pageBuilder: (_, __, ___) => buildSeatsModal(context, reservation),
                );
              },
              child: Container(
                height: double.infinity,
                width: 50,
                decoration: const BoxDecoration(
                  color: darkRedColor,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                child: const Center(
                  child: Icon(Icons.event_seat_outlined, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSeatsModal(BuildContext context, Reservation reservation) {
    return Center(
      child: SizedBox(
        height: 400,
        width: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(child: fromBase64StringR(reservation.show!.movie!.photo!)),
              Expanded(
                child: Material(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text(
                            'Seats',
                            style: TextStyle(
                              color: Color(0xFFf2f2f2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.separated(
                            itemCount: reservation.seats!.length,
                            padding: const EdgeInsets.all(0),
                            separatorBuilder: (ctx, i) => const SizedBox(height: 20),
                            itemBuilder: (ctx, i) => _ReservationSeatsListItem(
                              seat: reservation.seats![i].seat!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _buildCancelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Cancel reservation',
          ),
          content: const Text('Are you sure you want to cancel reservation?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                cancelReservation();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: darkRedColor, side: BorderSide.none, shape: const StadiumBorder()),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ReservationSeatsListItem extends StatelessWidget {
  const _ReservationSeatsListItem({
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
