// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/models/reservation.dart';
import 'package:ecinema_mobile/providers/reservation_provider.dart';
import 'package:ecinema_mobile/utils/error_dialog.dart';
import 'package:ecinema_mobile/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  var _seatsColor = darkRedColor;

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
      setState(() {
        reservationsResult = data;
        _isLoading = false;
      });
    } catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
            title: const Center(
                child: Text(
          'My Reservations',
          // style: TextStyle(fontSize: 22),
        ))),
        body: ListView.builder(
          itemCount: reservationsResult.length,
          itemBuilder: (context, index) {
            return _buildReservation(context, reservationsResult[index]);
          },
        ),
      );
    }
  }
}

Widget _buildReservation(BuildContext context, Reservation reservation) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: SizedBox(
      height: 150,
      child: Row(
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              child: fromBase64String(reservation.show!.movie!.photo!)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reservation.show!.movie!.title!.toUpperCase(),
                    // overflow: TextOverflow.ellipsis,
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
                        Icons.hd_outlined,
                        size: 19,
                        color: darkRedColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        reservation.show!.format!,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
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
                pageBuilder: (_, __, ___) => buildTicketsModal(context, reservation),
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

buildTicketsModal(BuildContext context, Reservation reservation) {
  return Center(
    child: SizedBox(
      height: 400,
      width: 250,
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10.0), child: fromBase64StringR(reservation.show!.movie!.photo!)),
          const Expanded(
            child: Material(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 12, 15, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Seat',
                            style: TextStyle(
                              color: Color(0xFFf2f2f2),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Price',
                            style: TextStyle(
                              color: Color(0xFFf2f2f2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // //Column data
                    // Expanded(
                    //   child: ListView.separated(
                    //     itemCount: reservation..length,
                    //     padding: const EdgeInsets.all(0),
                    //     separatorBuilder: (ctx, i) => const SizedBox(height: 20),
                    //     itemBuilder: (ctx, i) => _BookingSeatsListItem(
                    //       booking: bookings[i],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
