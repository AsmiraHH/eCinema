// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_mobile/helpers/constants.dart';
import 'package:ecinema_mobile/models/movie.dart';
import 'package:ecinema_mobile/models/show.dart';
import 'package:ecinema_mobile/providers/show_provider.dart';
import 'package:ecinema_mobile/screens/seats_screen.dart';
import 'package:ecinema_mobile/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ShowsScreen extends StatefulWidget {
  final Movie movie;
  static const String routeName = '/shows';

  const ShowsScreen({super.key, required this.movie});

  @override
  State<ShowsScreen> createState() => _ShowsScreenState();
}

class _ShowsScreenState extends State<ShowsScreen> {
  List<Show> showsResultDistinct = <Show>[];
  List<Show> showsResult = <Show>[];
  late ShowProvider _showProvider;
  bool _isLoading = true;
  Show? selectedDate;
  Show? selectedTime;

  @override
  void initState() {
    super.initState();
    _showProvider = context.read<ShowProvider>();
    _initializeShows();
  }

  Future<void> _initializeShows() async {
    await loadShows(true);
    await loadShows(false);
  }

  Future<void> loadShows(bool isDistinct) async {
    _isLoading = true;
    try {
      var data = await _showProvider.getByMovieId(widget.movie.id, isDistinct);
      if (mounted) {
        setState(() {
          if (isDistinct) {
            showsResultDistinct = data;
            selectedDate = showsResultDistinct.first;
          } else {
            showsResult = data;
          }
          _isLoading = false;
        });
      }
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
          title: Text(widget.movie.title!.toUpperCase()),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text('Select a date', style: TextStyle(color: Colors.grey[400], fontSize: 20)),
              const SizedBox(height: 15),
              Container(
                height: 130,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 47, 46, 46), borderRadius: BorderRadius.all(Radius.circular(20))),
                margin: const EdgeInsets.only(left: 20),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: buildDates(),
              ),
              const Spacer(),
              Text('Select a time', style: TextStyle(color: Colors.grey[400], fontSize: 20)),
              const SizedBox(height: 15),
              Container(
                height: 130,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 47, 46, 46), borderRadius: BorderRadius.all(Radius.circular(20))),
                margin: const EdgeInsets.only(left: 20),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: buildTimes(),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(15),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedTime == null
                      ? null
                      : () {
                          Navigator.pushNamed(
                            context,
                            SeatsScreen.routeName,
                            arguments: selectedTime,
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
              ),
            ],
          ),
        ),
      );
    }
  }

  buildDates() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: showsResultDistinct.map((show) {
          bool isSelected = selectedDate == show;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              showCheckmark: false,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              label: Text(
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  '${DateFormat('EEEE').format(DateTime.parse(show.dateTime.toString()))}\n${DateFormat('dd.MM.').format(DateTime.parse(show.dateTime.toString()))}'),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  selectedDate = show;
                  selectedTime = null;
                });
              },
              selectedColor: darkRedColor,
              labelStyle: const TextStyle(
                color: Colors.white,
              ),
              backgroundColor: const Color.fromARGB(255, 39, 38, 38),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(style: BorderStyle.solid, color: darkRedColor),
              ),
              labelPadding: EdgeInsets.zero,
            ),
          );
        }).toList(),
      ),
    );
  }

  buildTimes() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: showsResult
            .where((s) => s.dateTime!.substring(0, 10) == selectedDate!.dateTime!.substring(0, 10))
            .map((show) {
          bool isSelected = selectedTime == show;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              showCheckmark: false,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              label: Text(
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  DateFormat.jm().format(DateTime.parse(show.dateTime.toString()))),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  selectedTime = show;
                });
              },
              selectedColor: darkRedColor,
              labelStyle: const TextStyle(
                color: Colors.white,
              ),
              backgroundColor: const Color.fromARGB(255, 39, 38, 38),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(style: BorderStyle.solid, color: darkRedColor),
              ),
              labelPadding: EdgeInsets.zero,
            ),
          );
        }).toList(),
      ),
    );
  }
}
