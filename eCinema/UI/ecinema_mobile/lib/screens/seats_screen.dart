// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/models/seat.dart';
import 'package:ecinema_mobile/models/show.dart';
import 'package:ecinema_mobile/providers/reservation_provider.dart';
import 'package:ecinema_mobile/providers/reservation_seat_provider.dart';
import 'package:ecinema_mobile/providers/seat_provider.dart';
import 'package:ecinema_mobile/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecinema_mobile/utils/error_dialog.dart';

class SeatsScreen extends StatefulWidget {
  final Show show;
  static const String routeName = '/seats';

  const SeatsScreen({super.key, required this.show});

  @override
  State<SeatsScreen> createState() => _SeatsScreenState();
}

class _SeatsScreenState extends State<SeatsScreen> {
  late SeatProvider _seatProvider;
  late ReservationSeatProvider _reservationSeatProvider;
  late ReservationProvider _reservationProvider;
  List<Seat>? seatsResult = <Seat>[];
  List<Seat>? takenSeatsResult = <Seat>[];
  List<Seat> selectedSeats = <Seat>[];
  bool _isLoading = true;
  Color takenColor = const Color.fromARGB(255, 47, 46, 46);
  Color availableColor = const Color.fromARGB(255, 20, 85, 22);

  @override
  void initState() {
    super.initState();
    _seatProvider = context.read<SeatProvider>();
    _reservationSeatProvider = context.read<ReservationSeatProvider>();
    _reservationProvider = context.read<ReservationProvider>();
    loadSeats();
    loadTakenSeats();
  }

  Future<void> loadSeats() async {
    // _isLoading = true;
    try {
      var data = await _seatProvider.getByHallId(widget.show.hall!.id);
      if (mounted) {
        setState(() {
          seatsResult = data;
          // _isLoading = false;
        });
      }
    } catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  Future<void> loadTakenSeats() async {
    _isLoading = true;
    try {
      var data = await _reservationSeatProvider.getByShowId(widget.show.id);
      if (mounted) {
        setState(() {
          takenSeatsResult = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Seats'), centerTitle: true),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width) * 1.2,
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: widget.show.hall!.maxNumberOfSeatsPerRow!,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 20,
                            children: seatsResult!.map((s) {
                              return s.isDisabled!
                                  ? Container()
                                  : InkWell(
                                      hoverColor: darkRedColor,
                                      onTap: () {
                                        if (!takenSeatsResult!.contains(s) && !selectedSeats.contains(s)) {
                                          selectedSeats.add(s);
                                        } else {
                                          selectedSeats.remove(s);
                                        }
                                        setState(() {
                                          s.isSelected = !(s.isSelected ?? false);
                                        });
                                      },
                                      child: (s.isDisabled ?? false) == false
                                          ? Container(
                                              decoration: BoxDecoration(
                                                color: takenSeatsResult != null && takenSeatsResult!.contains(s)
                                                    ? takenColor
                                                    : (s.isSelected ?? false)
                                                        ? darkRedColor
                                                        : Colors.black,
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  s.row.toString() + s.column.toString(),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )
                                          : null,
                                    );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    buildColorInfo(),
                    ElevatedButton(
                      onPressed: selectedSeats.isEmpty
                          ? null
                          : () {
                              _reservationProvider.setSelectedShow(widget.show);
                              _reservationProvider.setSelectedSeats(selectedSeats);
                              Navigator.pushNamed(
                                context,
                                PaymentScreen.routeName,
                                arguments: widget.show,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        backgroundColor: darkRedColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text("Continue"),
                    ),
                  ],
                ),
              ));
  }
}

buildColorInfo() {
  return Container(
    margin: const EdgeInsets.fromLTRB(20, 20, 20, 30),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          SizedBox(
            height: 9,
            width: 9,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            "Available",
            style: TextStyle(color: Colors.white),
          ),
        ]),
        Row(children: [
          SizedBox(
            height: 9,
            width: 9,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 47, 46, 46),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            "Taken",
            style: TextStyle(color: Colors.white),
          ),
        ]),
        Row(children: [
          SizedBox(
            height: 9,
            width: 9,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: darkRedColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            "Selected",
            style: TextStyle(color: Colors.white),
          ),
        ]),
      ],
    ),
  );
}
