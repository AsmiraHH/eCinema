// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_admin/helpers/constants.dart';
import 'package:ecinema_admin/models/cinema.dart';
import 'package:ecinema_admin/models/paged_result.dart';
import 'package:ecinema_admin/models/reservation.dart';
import 'package:ecinema_admin/models/show.dart';
import 'package:ecinema_admin/models/user.dart';
import 'package:ecinema_admin/providers/cinema_provider.dart';
import 'package:ecinema_admin/providers/reservation_provider.dart';
import 'package:ecinema_admin/providers/user_provider.dart';
import 'package:ecinema_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final _currentPage = 1;
  final _pageSize = 10;
  late ReservationProvider _reservationProvider;
  late CinemaProvider _cinemaProvider;
  late UserProvider _userProvider;

  PagedResult<Reservation>? reservationsResult;
  List<Show>? showsResult;
  List<Cinema>? cinemasResult;
  List<User>? usersResult;
  Reservation? selectedReservation;

  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  int? selectedShow;
  int? selectedCinema;
  int? selectedUser;

  @override
  void initState() {
    super.initState();
    _reservationProvider = context.read<ReservationProvider>();
    _userProvider = context.read<UserProvider>();
    _cinemaProvider = context.read<CinemaProvider>();
    loadReservations({'PageNumber': _currentPage, 'PageSize': _pageSize});
    loadCinemas();
    loadUsers();

    _searchController.addListener(() {
      final searchText = _searchController.text;
      loadReservations({
        'PageNumber': _currentPage,
        'PageSize': _pageSize,
        'Movie': searchText,
        'Cinema': selectedCinema,
        'User': selectedUser,
      });
    });
  }

  Future<void> loadReservations(dynamic request) async {
    try {
      var data = await _reservationProvider.getPaged(request);
      setState(() {
        reservationsResult = data;
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

  Future<void> loadCinemas() async {
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

  Future<void> loadUsers() async {
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

  Future<void> _saveReservation() async {
    Map<String, dynamic> newReservation = Map.from(_formKey.currentState!.value);
    newReservation['id'] = selectedReservation?.id;
    newReservation['ShowId'] = selectedReservation?.show!.id;
    newReservation['SeatId'] = selectedReservation?.seat!.id;
    newReservation['UserId'] = selectedReservation?.user!.id;

    try {
      await _reservationProvider.update(newReservation);

      Navigator.of(context).pop();
      loadReservations({'PageNumber': _currentPage, 'PageSize': _pageSize});
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

  Future<void> _deleteReservation() async {
    try {
      var response = await _reservationProvider.delete(selectedReservation!.id!);

      if (response) {
        selectedReservation = null;
        loadReservations({'PageNumber': _currentPage, 'PageSize': _pageSize});
      }
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
      title: "Reservations",
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [buildSearchField(context), buildDataContainer(context)]),
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
                DataColumn(label: Text('Cinema')),
                DataColumn(label: Text('Movie')),
                DataColumn(label: Text('Seat')),
                DataColumn(label: Text('User')),
                DataColumn(label: Text('Active')),
              ],
              rows: reservationsResult?.items.map((Reservation reservation) {
                    return DataRow(
                      selected: selectedReservation == reservation,
                      onSelectChanged: (isSelected) => setState(() {
                        selectedReservation = reservation;
                      }),
                      cells: [
                        DataCell(Text(reservation.show!.hall!.cinema!.name.toString())),
                        DataCell(Text(reservation.show!.movie!.title.toString())),
                        DataCell(Text('${reservation.seat!.column.toString()}${reservation.seat!.row}')),
                        DataCell(Text('${reservation.user!.firstName} ${reservation.user!.lastName}')),
                        DataCell(Container(
                            margin: const EdgeInsets.only(left: 9),
                            child: reservation.user!.isActive == true
                                ? const Icon(
                                    Icons.check_box_outlined,
                                    color: Colors.green,
                                    size: 25,
                                  )
                                : const Icon(
                                    Icons.close_outlined,
                                    color: Colors.red,
                                    size: 25,
                                  ))),
                      ],
                    );
                  }).toList() ??
                  [],
            ),
          ),
        ),
      ),
    );
  }

  Row buildFilterDropDowns(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            decoration:
                BoxDecoration(color: blueColor, border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.fromLTRB(30, 40, 20, 0),
            height: 35,
            width: 400,
            child: DropdownButton<int>(
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text('All'),
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
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Movie': _searchController.text,
                    'Cinema': selectedCinema,
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
            width: 400,
            child: DropdownButton<int>(
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text('All'),
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
                    'PageNumber': _currentPage,
                    'PageSize': _pageSize,
                    'Movie': _searchController.text,
                    'Cinema': selectedCinema,
                    'User': selectedUser,
                  });
                });
              },
              isExpanded: true,
              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              underline: Container(),
              style: const TextStyle(color: Colors.white),
            )),
      ],
    );
  }

  Row buildSearchField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(80, 40, 10, 0),
          height: 35,
          width: 400,
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
                filled: true,
                fillColor: blueColor,
                contentPadding: EdgeInsets.only(top: 10.0, left: 10.0),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: 'Search ...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(width: 3, color: Colors.white)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: Colors.white))),
          ),
        ),
        buildFilterDropDowns(context),
        buildButtons(context)
      ],
    );
  }

  Container buildButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 40, 20, 0),
      child: Row(children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                shape:
                    RoundedRectangleBorder(side: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: selectedReservation == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one reservation."),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
                            ));
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              backgroundColor: blueColor,
                              title: const Text('Edit reservation'),
                              content: buildEditReservationModal(reservationEdit: selectedReservation),
                              actions: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  child: const Text('Close'),
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.saveAndValidate()) {
                                      _saveReservation();
                                    }
                                  },
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  child: const Text('Save'),
                                )
                              ],
                            );
                          });
                        });
                  },
            child: const Icon(Icons.edit)),
        const SizedBox(width: 5),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                shape:
                    RoundedRectangleBorder(side: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: selectedReservation == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one reservation."),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
                            ));
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Delete reservation"),
                              content: const Text("Are you sure you want to delete the selected reservation?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      _deleteReservation();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Delete"))
                              ],
                            ));
                  },
            child: const Icon(Icons.delete_forever_rounded))
      ]),
    );
  }

  Widget buildEditReservationModal({Reservation? reservationEdit}) {
    return SizedBox(
        height: 350,
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  Wrap(
                    runAlignment: WrapAlignment.spaceEvenly,
                    spacing: 40,
                    runSpacing: 10,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: 340,
                            child: FormBuilderTextField(
                              enabled: false,
                              cursorColor: Colors.grey,
                              name: 'CinemaId',
                              initialValue: reservationEdit?.show?.hall?.cinema?.name ?? '',
                              decoration: const InputDecoration(labelText: 'Cinema'),
                            ),
                          ),
                          SizedBox(
                            width: 340,
                            child: FormBuilderTextField(
                              enabled: false,
                              cursorColor: Colors.grey,
                              name: 'ShowId',
                              initialValue: reservationEdit?.show?.movie?.title ?? '',
                              decoration: const InputDecoration(labelText: 'Show'),
                            ),
                          ),
                          SizedBox(
                            width: 340,
                            child: FormBuilderTextField(
                              enabled: false,
                              cursorColor: Colors.grey,
                              name: 'SeatId',
                              initialValue: (reservationEdit?.seat?.column?.toString() ?? '') +
                                  (reservationEdit?.seat?.row ?? '').toString(),
                              decoration: const InputDecoration(labelText: 'Seat'),
                            ),
                          ),
                          SizedBox(
                            width: 340,
                            child: FormBuilderTextField(
                              enabled: false,
                              cursorColor: Colors.grey,
                              name: 'UserId',
                              initialValue: ('${reservationEdit?.user?.firstName ?? ''} ${reservationEdit?.user?.lastName ?? ''}')
                                  .toString(),
                              decoration: const InputDecoration(labelText: 'User'),
                            ),
                          ),
                          SizedBox(
                            width: 340,
                            child: FormBuilderCheckbox(
                              title: const Text('Active'),
                              name: 'IsActive',
                              initialValue: reservationEdit!.isActive,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )),
        ));
  }
}
