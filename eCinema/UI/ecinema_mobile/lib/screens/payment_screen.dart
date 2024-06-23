// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/models/seat.dart';
import 'package:ecinema_mobile/models/show.dart';
import 'package:ecinema_mobile/providers/reservation_provider.dart';
import 'package:ecinema_mobile/screens/reservation_success_screen.dart';
import 'package:ecinema_mobile/utils/error_dialog.dart';
import 'package:ecinema_mobile/utils/error_snackbar.dart';
import 'package:ecinema_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  final Show show;
  static const String routeName = '/payment';

  const PaymentScreen({super.key, required this.show});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late ReservationProvider _reservationProvider;
  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    super.initState();
    _reservationProvider = context.read<ReservationProvider>();
  }

  Future<Map<String, dynamic>> makePaymentIntent() async {
    final body = {
      'amount': (_reservationProvider.totalPrice * 100).round().toString(),
      'currency': 'BAM',
      'payment_method_types[]': 'card',
    };

    final headers = {
      'Authorization': 'Bearer $stripeSecretKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final response = await http.post(
      Uri.parse("https://api.stripe.com/v1/payment_intents"),
      headers: headers,
      body: body,
    );

    return jsonDecode(response.body);
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await _insertReservation();
    } catch (e) {
      showErrorSnackBar(context, 'Transaction cancelled.');
    }
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await makePaymentIntent();
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'eCinema',
          paymentIntentClientSecret: paymentIntent!["client_secret"],
          style: ThemeMode.dark,
        ),
      );
      await displayPaymentSheet();
    } on StripeException catch (e) {
      throw Exception('StripeException: ${e.error.localizedMessage}');
    } catch (e) {
      showErrorSnackBar(context, 'Transaction cancelled.');
    }
  }

  Future _insertReservation() async {
    try {
      Map<String, dynamic> reservation = {};

      List<int> seatIds = _reservationProvider.selectedSeats.map((seat) => seat.id!).toList();
      reservation['isActive'] = true;
      reservation['UserId'] = Authorization.userId;
      reservation['ShowId'] = _reservationProvider.selectedShow!.id;
      reservation['SeatIDs'] = seatIds;
      reservation['TransactionNumber'] = paymentIntent!['id'];

      await _reservationProvider.insert(reservation);

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, ReservationSuccessScreen.routeName, (route) => false);
      } else {
        throw Exception("Error while creating a reservation.");
      }
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Payment'), centerTitle: true),
        body: Container(
          color: Colors.black26,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    child: fromBase64StringCoverWithoutOpacity(widget.show.movie!.photo!)),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Date",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          Text(DateFormat('EEEE, dd.MM.').format(DateTime.parse(widget.show.dateTime.toString())))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Time",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          Text(DateFormat('jm').format(DateTime.parse(widget.show.dateTime.toString())))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hall",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          Text(widget.show.hall!.name!)
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: _reservationProvider.selectedSeats.length,
                    padding: const EdgeInsets.all(0),
                    separatorBuilder: (ctx, i) => const SizedBox(height: 20),
                    itemBuilder: (ctx, i) => _ReservationSeatsListItem(
                      seat: _reservationProvider.selectedSeats[i],
                      price: widget.show.price ?? 0,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text(
                      "Total price",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    Text(NumberFormat.currency(locale: 'bs').format(_reservationProvider.totalPrice))
                  ]),
                ),
                ElevatedButton(
                  onPressed: () async => await makePayment(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    backgroundColor: darkRedColor,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    ),
                  ),
                  child: const Text("Confirm"),
                ),
              ],
            ),
          ),
        ));
  }
}

class _ReservationSeatsListItem extends StatelessWidget {
  const _ReservationSeatsListItem({
    required this.seat,
    required this.price,
  });

  final Seat seat;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.event_seat, color: darkRedColor, size: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Seat",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              Text('${seat.row}-${seat.column}')
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Price",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              Text(NumberFormat.currency(locale: 'bs').format(price))
            ],
          )
        ],
      ),
    );
  }
}
