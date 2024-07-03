// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_admin/helpers/constants.dart';
import 'package:ecinema_admin/models/country.dart';
import 'package:ecinema_admin/models/paged_result.dart';
import 'package:ecinema_admin/providers/country_provider.dart';
import 'package:ecinema_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  int _currentPage = 1;
  final _pageSize = 12;
  final _formKey = GlobalKey<FormBuilderState>();
  late CountryProvider _countryProvider;
  final TextEditingController _searchController = TextEditingController();
  Country? selectedCountry;
  PagedResult<Country>? countriesResult;

  @override
  void initState() {
    super.initState();
    _countryProvider = context.read<CountryProvider>();
    loadCountries({'PageNumber': _currentPage, 'PageSize': _pageSize});

    _searchController.addListener(() {
      final searchText = _searchController.text;
      loadCountries({'PageNumber': _currentPage, 'PageSize': _pageSize, 'Name': searchText});
    });
  }

  Future<void> loadCountries(dynamic request) async {
    try {
      var data = await _countryProvider.getPaged(request);
      setState(() {
        countriesResult = data;
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

  Future<void> _saveCountry(bool isEdit) async {
    Map<String, dynamic> newCountry = Map.from(_formKey.currentState!.value);
    if (isEdit) {
      newCountry['id'] = selectedCountry?.id;
    }

    try {
      if (!isEdit) {
        await _countryProvider.insert(newCountry);
      } else {
        await _countryProvider.update(newCountry);
      }

      Navigator.of(context).pop();
      loadCountries({'PageNumber': _currentPage, 'PageSize': _pageSize});
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

  Future<void> _deleteCountry() async {
    try {
      var response = await _countryProvider.delete(selectedCountry!.id!);

      if (response) {
        selectedCountry = null;
        loadCountries({'PageNumber': _currentPage, 'PageSize': _pageSize});
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
      title: "Countries",
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [buildSearchField(context), buildDataContainer(context), buildPagination()]),
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
                DataColumn(
                  label: Flexible(
                    child: Center(
                      child: Text(
                        'Name',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
              rows: countriesResult?.items.map((Country country) {
                    return DataRow(
                      selected: selectedCountry == country,
                      onSelectChanged: (isSelected) => setState(() {
                        selectedCountry = country;
                      }),
                      cells: [
                        DataCell(Container(
                          alignment: Alignment.center,
                          child: Text(
                            country.name.toString(),
                            textAlign: TextAlign.center,
                          ),
                        )),
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

  Row buildSearchField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(80, 40, 10, 0),
          height: 35,
          width: MediaQuery.sizeOf(context).width / 4.5,
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
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: blueColor,
                      title: const Text('Add country'),
                      content: SingleChildScrollView(child: buildAddCountryModal(isEdit: false, countryEdit: null)),
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
                              _saveCountry(false);
                            }
                          },
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: const Text('Save'),
                        )
                      ],
                    );
                  });
            },
            child: const Icon(Icons.add)),
        const SizedBox(width: 5),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                shape:
                    RoundedRectangleBorder(side: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: selectedCountry == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one country."),
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
                              title: const Text('Edit country'),
                              content: buildAddCountryModal(isEdit: true, countryEdit: selectedCountry),
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
                                      _saveCountry(true);
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
            onPressed: selectedCountry == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one country."),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
                            ));
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Delete country"),
                              content: const Text("Are you sure you want to delete the selected country?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      _deleteCountry();
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

  Widget buildAddCountryModal({bool isEdit = false, Country? countryEdit}) {
    return SizedBox(
        width: 350,
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 350,
                        child: FormBuilderTextField(
                          cursorColor: Colors.grey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          name: 'Name',
                          initialValue: countryEdit != null ? countryEdit.name : '',
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator:
                              FormBuilderValidators.compose([FormBuilderValidators.required(errorText: 'Name is required')]),
                        ),
                      )
                    ],
                  ),
                ],
              )),
        ));
  }

  Widget buildPagination() {
    return Container(
      margin: const EdgeInsets.only(right: 80, bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                shape:
                    RoundedRectangleBorder(side: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                    loadCountries({'PageNumber': _currentPage, 'PageSize': _pageSize, 'Name': _searchController.text});
                  }
                : null,
            child: const Icon(
              Icons.arrow_left_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                shape:
                    RoundedRectangleBorder(side: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(15))),
            onPressed: countriesResult?.hasNextPage ?? false
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                    loadCountries({'PageNumber': _currentPage, 'PageSize': _pageSize, 'Name': _searchController.text});
                  }
                : null,
            child: const Icon(
              Icons.arrow_right_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
