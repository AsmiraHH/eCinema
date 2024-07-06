// ignore_for_file: use_build_context_synchronously

import 'package:ecinema_admin/helpers/constants.dart';
import 'package:ecinema_admin/models/country.dart';
import 'package:ecinema_admin/models/paged_result.dart';
import 'package:ecinema_admin/models/production.dart';
import 'package:ecinema_admin/providers/country_provider.dart';
import 'package:ecinema_admin/providers/production_provider.dart';
import 'package:ecinema_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class ProductionsScreen extends StatefulWidget {
  const ProductionsScreen({super.key});

  @override
  State<ProductionsScreen> createState() => _ProductionsScreenState();
}

class _ProductionsScreenState extends State<ProductionsScreen> {
  int _currentPage = 1;
  final _pageSize = 12;
  final _formKey = GlobalKey<FormBuilderState>();
  late ProductionProvider _productionProvider;
  late CountryProvider _countryProvider;
  PagedResult<Production>? productionsResult;
  List<Country>? countriesResult;
  Production? selectedProduction;
  final TextEditingController _searchController = TextEditingController();
  int? selectedCountry;

  @override
  void initState() {
    super.initState();
    _productionProvider = context.read<ProductionProvider>();
    _countryProvider = context.read<CountryProvider>();
    loadProductions({'PageNumber': _currentPage, 'PageSize': _pageSize});
    loadCountries();

    _searchController.addListener(() {
      final searchText = _searchController.text;
      loadProductions({'PageNumber': _currentPage, 'PageSize': _pageSize, 'Name': searchText});
    });
  }

  Future<void> loadProductions(dynamic request) async {
    try {
      var data = await _productionProvider.getPaged(request);
      setState(() {
        productionsResult = data;
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

  Future<void> _saveProduction(bool isEdit) async {
    Map<String, dynamic> newProduction = Map.from(_formKey.currentState!.value);
    if (isEdit) {
      newProduction['id'] = selectedProduction?.id;
    }

    try {
      if (!isEdit) {
        await _productionProvider.insert(newProduction);
      } else {
        await _productionProvider.update(newProduction);
      }

      Navigator.of(context).pop();
      loadProductions({'PageNumber': _currentPage, 'PageSize': _pageSize});
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

  Future<void> _deleteProduction() async {
    try {
      var response = await _productionProvider.delete(selectedProduction!.id!);

      if (response) {
        selectedProduction = null;
        loadProductions({'PageNumber': _currentPage, 'PageSize': _pageSize});
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
      title: "Productions",
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
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Country')),
              ],
              rows: productionsResult?.items.map((Production production) {
                    return DataRow(
                      selected: selectedProduction == production,
                      onSelectChanged: (isSelected) => setState(() {
                        selectedProduction = production;
                      }),
                      cells: [
                        DataCell(Text(production.name.toString())),
                        DataCell(Text(production.country!.name.toString())),
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
        margin: const EdgeInsets.fromLTRB(30, 40, 10, 0),
        height: 35,
        width: MediaQuery.sizeOf(context).width / 4.5,
        child: DropdownButton<int>(
          items: [
            const DropdownMenuItem<int>(
              value: null,
              child: Text('All Countries'),
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
              loadProductions({
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
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: blueColor,
                      title: const Text('Add production'),
                      content: SingleChildScrollView(child: buildAddProductionModal(isEdit: false, productionEdit: null)),
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
                              _saveProduction(false);
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
            onPressed: selectedProduction == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one production."),
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
                              title: const Text('Edit production'),
                              content: buildAddProductionModal(isEdit: true, productionEdit: selectedProduction),
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
                                      _saveProduction(true);
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
            onPressed: selectedProduction == null
                ? () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text("You have to select at least one production."),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
                            ));
                  }
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Delete productiion"),
                              content: const Text("Are you sure you want to delete the selected production?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      _deleteProduction();
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

  Widget buildAddProductionModal({bool isEdit = false, Production? productionEdit}) {
    return SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                              initialValue: productionEdit != null ? productionEdit.name : '',
                              decoration: const InputDecoration(labelText: 'Name'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(errorText: 'Name is required'),
                                FormBuilderValidators.match(r'^[a-zA-Z]+$', errorText: 'Only letters are allowed'),
                              ]),
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
                              initialValue: productionEdit?.country?.id,
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
                    loadProductions({'PageNumber': _currentPage, 'PageSize': _pageSize, 'Name': _searchController.text});
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
            onPressed: productionsResult?.hasNextPage ?? false
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                    loadProductions({'PageNumber': _currentPage, 'PageSize': _pageSize, 'Name': _searchController.text});
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
