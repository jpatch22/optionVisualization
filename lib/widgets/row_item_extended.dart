import 'package:flutter/material.dart';
import 'package:option_visualizer/models/row_data_extend.dart';

class RowItemExtended extends StatefulWidget {
  final RowDataExtended rowData;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  RowItemExtended({
    Key? key,
    required this.rowData,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  _RowItemExtendedState createState() => _RowItemExtendedState();
}

class _RowItemExtendedState extends State<RowItemExtended> {
  late String longShort;
  late String putCall;
  late TextEditingController contractPriceController;
  late TextEditingController timeController;

  @override
  void initState() {
    super.initState();
    longShort = widget.rowData.longShort;
    putCall = widget.rowData.type;
    contractPriceController = TextEditingController(text: widget.rowData.contractPrice);
    timeController = TextEditingController(text: widget.rowData.timeToExpiry);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DropdownButton<String>(
          value: longShort,
          onChanged: (String? newValue) {
            setState(() {
              longShort = newValue!;
              widget.rowData.longShort = longShort;
            });
          },
          items: <String>['Long', 'Short']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        DropdownButton<String>(
          value: putCall,
          onChanged: (String? newValue) {
            setState(() {
              putCall = newValue!;
              widget.rowData.type = putCall;
            });
          },
          items: <String>['Put', 'Call']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Text("Contract Price:"),
        Container(
          width: 100,
          child: TextField(
            controller: contractPriceController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              widget.rowData.contractPrice = value;
            },
          ),
        ),
        Text("Time To Expiry:"),
        Container(
          width: 100,
          child: TextField(
            controller: timeController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              widget.rowData.timeToExpiry = value;
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: widget.onAdd,
        ),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: widget.onRemove,
        ),
      ],
    );
  }

  @override
  void dispose() {
    contractPriceController.dispose();
    super.dispose();
  }
}
