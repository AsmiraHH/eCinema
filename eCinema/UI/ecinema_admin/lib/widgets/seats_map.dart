import 'package:ecinema_admin/models/seat.dart';
import 'package:flutter/material.dart';

class SeatsMap extends StatefulWidget {
  int? numColumns;
  List<Seat>? seatsResult;
  List<Seat>? selectedSeats = <Seat>[];

  SeatsMap({this.numColumns, this.seatsResult, this.selectedSeats, super.key});

  @override
  State<SeatsMap> createState() => _SeatsMapState();
}

class _SeatsMapState extends State<SeatsMap> {
  @override
  Widget build(BuildContext context) {
    double gridHeight = MediaQuery.of(context).size.height / 3;
    double gridWidth = MediaQuery.of(context).size.width / 3;

    return SizedBox(
        height: gridHeight,
        width: gridWidth,
        child: GridView.count(
          crossAxisCount: widget.numColumns!,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          children: widget.seatsResult!.map((s) {
            return s.isDisabled!
                ? Container()
                : InkWell(
                    hoverColor: Colors.red,
                    onTap: () {
                      if (!widget.selectedSeats!.contains(s)) {
                        widget.selectedSeats!.add(s);
                      }
                      setState(() {
                        s.isSelected = !(s.isSelected ?? false);
                      });
                    },
                    child: (s.isDisabled ?? false) == false
                        ? Container(
                            decoration: BoxDecoration(
                              color: (s.isSelected ?? false) ? Colors.red : null,
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
        ));
  }
}
