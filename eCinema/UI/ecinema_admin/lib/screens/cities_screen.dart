// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_admin/helpers/constants.dart';
import 'package:ecinema_admin/models/city.dart';
import 'package:ecinema_admin/models/country.dart';
import 'package:ecinema_admin/models/paged_result.dart';
import 'package:ecinema_admin/providers/city_provider.dart';
import 'package:ecinema_admin/providers/country_provider.dart';
import 'package:ecinema_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({super.key});

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  final _currentPage = 1;
  final _pageSize = 10;
  final _formKey = GlobalKey<FormBuilderState>();
  late CityProvider _cityProvider;
  late CountryProvider _countryProvider;
  List<Country>? countriesResult;
  PagedResult<City>? citiesResult;
  final TextEditingController _searchController = TextEditingController();
  City? selectedCity;
  int? selectedCountry;
  @override
  void initState() {
    super.initState();
    _cityProvider = context.read<CityProvider>();
    _countryProvider = context.read<CountryProvider>();
    loadCities({'PageNumber': _currentPage, 'PageSize': _pageSize});
    loadCountries();

    _searchController.addListener(() {
      final searchText = _searchController.text;
      loadCities({'PageNumber': _currentPage, 'PageSize': _pageSize, 'Name': searchText, 'Country': selectedCountry});
    });
  }

  Future<void> loadCities(dynamic request) async {
    try {
      var data = await _cityProvider.getPaged(request);
      setState(() {
        citiesResult = data;
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

  Future<void> loadCountries() async {
    try {
      var data = await _countryProvider.getAll();
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

  Future<void> _saveCity(bool isEdit) async {
    Map<String, dynamic> newCity = Map.from(_formKey.currentState!.value);
    if (isEdit) {
      newCity['id'] = selectedCity?.id;
    }

    try {
      if (!isEdit) {
        await _cityProvider.insert(newCity);
      } else {
        await _cityProvider.update(newCity);
      }

      Navigator.of(context).pop();
      loadCities({'PageNumber': _currentPage, 'PageSize': _pageSize});
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

  Future<void> _deleteCity() async {
    try {
      var response = await _cityProvider.delete(selectedCity!.id!);

      if (response) {
        selectedCity = null;
        loadCities({'PageNumber': _currentPage, 'PageSize': _pageSize});
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
      title: "Cities",
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
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Zip code')),
                DataColumn(label: Text('Country')),
              ],
              rows: citiesResult?.items.map((City city) {
                    return DataRow(
                      selected: selectedCity == city,
                      onSelectChanged: (isSelected) => setState(() {
                        selectedCity = city;
                      }),
                      cells: [
                        DataCell(Text(city.name.toString())),
                        DataCell(Text(city.zipCode.toString())),
                        DataCell(Text(city.country!.name.toString())),
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

  Container buildFilterDropDowns(BuildContext context) {
    return Container(
        decoration:
            BoxDecoration(color: blueColor, border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.fromLTRB(40, 40, 10, 0),
        height: 35,
        width: 400,
        child: DropdownButton<int>(
          items: [
            const DropdownMenuItem<int>(
              value: null,
              child: Text('All'),
            ),
            ...countriesResult
                    ?.map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(
                            e.name!,
                          ),
                        ))
                    .toList() ??
                [],
          ],
          value: selectedCountry,
          onChanged: (int? newValue) {
            setState(() {
              selectedCountry = newValue;
              loadCities({
                'PageNumber': _currentPage,
                'PageSize': _pageSize,
                'Name': _searchController.text,
                'Country': selectedCountry,
              });
            });
          },
          isExpanded: true,
          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
          underline: Container(),
          style: const TextStyle(color: Colors.white),
        ));
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
        buildButtons(context),
        buildFilterDropDowns(context)
      ],
    );
  }

  Container buildButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(40, 40, 20, 0),
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
                      title: const Text('Add city'),
                      content: SingleChildScrollView(child: buildAddCityModal(isEdit: false, cityEdit: null)),
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
                              _saveCity(false);
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
            onPressed: selectedCity == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one city."),
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
                              title: const Text('Edit city'),
                              content: buildAddCityModal(isEdit: true, cityEdit: selectedCity),
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
                                      _saveCity(true);
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
            onPressed: selectedCity == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one city."),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
                            ));
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Delete city"),
                              content: const Text("Are you sure you want to delete the selected city?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      _deleteCity();
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

  Widget buildAddCityModal({bool isEdit = false, City? cityEdit}) {
    return SizedBox(
        height: 250,
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
                            width: 300,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'Name',
                              initialValue: cityEdit != null ? cityEdit.name : '',
                              decoration: const InputDecoration(labelText: 'Name'),
                              validator:
                                  FormBuilderValidators.compose([FormBuilderValidators.required(errorText: 'Name is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: FormBuilderTextField(
                              cursorColor: Colors.grey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'ZipCode',
                              initialValue: cityEdit != null ? cityEdit.zipCode : '',
                              decoration: const InputDecoration(labelText: 'ZipCode'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'ZipCode is required')]),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: FormBuilderDropdown<int>(
                              items: countriesResult
                                      ?.map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              e.name!,
                                            ),
                                          ))
                                      .toList() ??
                                  [],
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              name: 'CountryId',
                              initialValue: cityEdit?.country?.id,
                              decoration: const InputDecoration(labelText: 'Country'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(errorText: 'Country is required')]),
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
