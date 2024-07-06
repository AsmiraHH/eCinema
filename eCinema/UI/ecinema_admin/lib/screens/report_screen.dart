// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:ecinema_admin/helpers/constants.dart';
import 'package:ecinema_admin/models/cinema.dart';
import 'package:ecinema_admin/models/genre.dart';
import 'package:ecinema_admin/models/report.dart';
import 'package:ecinema_admin/models/reservation.dart';
import 'package:ecinema_admin/models/user.dart';
import 'package:ecinema_admin/providers/cinema_provider.dart';
import 'package:ecinema_admin/providers/genre_provider.dart';
import 'package:ecinema_admin/providers/reservation_provider.dart';
import 'package:ecinema_admin/providers/user_provider.dart';
import 'package:ecinema_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Month {
  final int number;
  final String name;

  Month(this.number, this.name);
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<Month> months = [
    Month(1, 'January'),
    Month(2, 'February'),
    Month(3, 'March'),
    Month(4, 'April'),
    Month(5, 'May'),
    Month(6, 'June'),
    Month(7, 'July'),
    Month(8, 'August'),
    Month(9, 'September'),
    Month(10, 'October'),
    Month(11, 'November'),
    Month(12, 'December'),
  ];

  late GenreProvider _genreProvider;
  late ReservationProvider _reservationProvider;
  late CinemaProvider _cinemaProvider;
  late UserProvider _userProvider;
  List<Genre>? genresResult;
  List<Cinema>? cinemasResult;
  List<User>? usersResult;
  Report? _reportResult;
  int? selectedMonth;
  int? selectedGenre;
  int? selectedCinema;
  int? selectedUser;

  @override
  void initState() {
    super.initState();
    _genreProvider = context.read<GenreProvider>();
    _reservationProvider = context.read<ReservationProvider>();
    _cinemaProvider = context.read<CinemaProvider>();
    _userProvider = context.read<UserProvider>();
    loadGenres();
    loadCinemas();
    loadUsers();
  }

  Future<void> loadReservations(dynamic request) async {
    try {
      var data = await _reservationProvider.getForReport(request);
      setState(() {
        _reportResult = data;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
              ));
    }
  }

  void loadGenres() async {
    try {
      var data = await _genreProvider.getAll();
      setState(() {
        genresResult = data;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
              ));
    }
  }

  void loadUsers() async {
    try {
      var data = await _userProvider.getAll();
      setState(() {
        usersResult = data;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
              ));
    }
  }

  void loadCinemas() async {
    try {
      var data = await _cinemaProvider.getAll();
      setState(() {
        cinemasResult = data;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
              ));
    }
  }

  void generatePdf() async {
    try {
      var pdf = pw.Document();
      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(children: [
          pw.Text('eCinema - Report',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, letterSpacing: 0.5, fontSize: 13, color: PdfColors.black)),
          pw.SizedBox(height: 15),
          pw.TableHelper.fromTextArray(
              border: null,
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
                3: pw.Alignment.center,
                4: pw.Alignment.centerRight
              },
              cellHeight: 20,
              headers: ['Movie', 'User', 'Date', 'Format', 'Price'],
              data: _reportResult?.listOfReservations
                      .map((e) => [
                            e.show!.movie!.title,
                            '${e.user!.firstName} ${e.user!.lastName}',
                            DateFormat('dd.MM.yyyy').format(DateTime.parse(e.show!.dateTime.toString())),
                            e.show!.format,
                            '${e.show!.price.toString()} BAM'
                          ])
                      .toList() ??
                  []),
          pw.SizedBox(height: 10),
          pw.Divider(thickness: 0.5),
          pw.SizedBox(height: 15),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
            pw.Text("Total: (${_reportResult!.totalCount})", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
            pw.SizedBox(width: 125),
            pw.Text("${_reportResult!.totalUsers}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
            pw.SizedBox(width: 250),
            pw.Text(" ${_reportResult?.totalPrice ?? "0"} BAM", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12))
          ])
        ]),
      ));

      final dir = await getApplicationDocumentsDirectory();
      final time = DateTime.now().millisecondsSinceEpoch;
      String path = '${dir.path}/report_$time.pdf';
      File file = File(path);
      file.writeAsBytes(await pdf.save());
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Success"),
                content: Text('Saved at $path'),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
              ));
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Reports",
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [buildFilterDropDowns(context), buildDataContainer(context)]),
    );
  }

  Row buildFilterDropDowns(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            decoration:
                BoxDecoration(color: blueColor, border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.fromLTRB(80, 40, 10, 0),
            height: 35,
            width: MediaQuery.sizeOf(context).width / 5.3,
            child: DropdownButton<int>(
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text('All Months'),
                ),
                ...months.map((e) => DropdownMenuItem(
                      value: e.number,
                      child: Text(
                        e.name,
                      ),
                    )),
              ],
              value: selectedMonth,
              onChanged: (int? newValue) {
                setState(() {
                  selectedMonth = newValue;
                  loadReservations({
                    'Genre': selectedGenre,
                    'Cinema': selectedCinema,
                    'Month': selectedMonth,
                    'User': selectedUser,
                  });
                });
              },
              isExpanded: true,
              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              underline: Container(),
              style: const TextStyle(color: Colors.white),
            )),
        Container(
            decoration:
                BoxDecoration(color: blueColor, border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.fromLTRB(30, 40, 10, 0),
            height: 35,
            width: MediaQuery.sizeOf(context).width / 5.3,
            child: DropdownButton<int>(
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text('All Cinemas'),
                ),
                ...cinemasResult
                        ?.map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                e.name!,
                              ),
                            ))
                        .toList() ??
                    [],
              ],
              value: selectedCinema,
              onChanged: (int? newValue) {
                setState(() {
                  selectedCinema = newValue;
                  loadReservations({
                    'Genre': selectedGenre,
                    'Cinema': selectedCinema,
                    'Month': selectedMonth,
                    'User': selectedUser,
                  });
                });
              },
              isExpanded: true,
              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              underline: Container(),
              style: const TextStyle(color: Colors.white),
            )),
        Container(
            decoration:
                BoxDecoration(color: blueColor, border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.fromLTRB(30, 40, 10, 0),
            height: 35,
            width: MediaQuery.sizeOf(context).width / 5.3,
            child: DropdownButton<int>(
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text('All Genres'),
                ),
                ...genresResult
                        ?.map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                e.name!,
                              ),
                            ))
                        .toList() ??
                    [],
              ],
              value: selectedGenre,
              onChanged: (int? newValue) {
                setState(() {
                  selectedGenre = newValue;
                  loadReservations({
                    'Genre': selectedGenre,
                    'Cinema': selectedCinema,
                    'Month': selectedMonth,
                    'User': selectedUser,
                  });
                });
              },
              isExpanded: true,
              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              underline: Container(),
              style: const TextStyle(color: Colors.white),
            )),
        Container(
            decoration:
                BoxDecoration(color: blueColor, border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.fromLTRB(30, 40, 10, 0),
            height: 35,
            width: MediaQuery.sizeOf(context).width / 5.3,
            child: DropdownButton<int>(
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text('All Users'),
                ),
                ...usersResult
                        ?.map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                '${e.firstName} ${e.lastName}',
                              ),
                            ))
                        .toList() ??
                    [],
              ],
              value: selectedUser,
              onChanged: (int? newValue) {
                setState(() {
                  selectedUser = newValue;
                  loadReservations({
                    'Genre': selectedGenre,
                    'Cinema': selectedCinema,
                    'Month': selectedMonth,
                    'User': selectedUser,
                  });
                });
              },
              isExpanded: true,
              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              underline: Container(),
              style: const TextStyle(color: Colors.white),
            )),
        Container(
          margin: const EdgeInsets.fromLTRB(30, 40, 20, 0),
          child: Row(children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  generatePdf();
                },
                child: const Icon(Icons.download)),
          ]),
        )
      ],
    );
  }

  Expanded buildDataContainer(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width),
          child: Container(
            margin: const EdgeInsets.only(left: 80, right: 80, bottom: 70, top: 20),
            padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
            decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(10)),
            child: DataTable(
              showCheckboxColumn: false,
              columns: const [
                DataColumn(label: Text('Movie')),
                DataColumn(label: Text('User')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Format')),
                DataColumn(label: Text('Price')),
              ],
              rows: [
                ...(_reportResult?.listOfReservations.map((Reservation reservation) {
                      return DataRow(
                        cells: [
                          DataCell(Text(reservation.show!.movie!.title.toString())),
                          DataCell(Text('${reservation.user!.firstName} ${reservation.user!.lastName}')),
                          DataCell(Text(DateFormat('dd.MM.yyyy').format(DateTime.parse(reservation.show!.dateTime.toString())))),
                          DataCell(Text(reservation.show!.format.toString())),
                          DataCell(Text('${reservation.show!.price.toString()} BAM')),
                        ],
                      );
                    }).toList() ??
                    []),
                DataRow(
                  cells: [
                    DataCell(
                        Text('Total (${_reportResult?.totalCount ?? ''})', style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text('${_reportResult?.totalUsers ?? ''} ', style: const TextStyle(fontWeight: FontWeight.bold))),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                    DataCell(Text('${_reportResult?.totalPrice ?? ''} BAM', style: const TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
