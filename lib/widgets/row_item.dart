import 'package:flutter/material.dart';
import '../models/row_data.dart';

class RowItem extends StatefulWidget {
  final RowData rowData;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  RowItem({
    Key? key,
    required this.rowData,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  _RowItemState createState() => _RowItemState();
}

class _RowItemState extends State<RowItem> {
  late String longShort;
  late String putCall;
  late TextEditingController contractPriceController;

  @override
  void initState() {
    super.initState();
    longShort = widget.rowData.longShort;
    putCall = widget.rowData.putCall;
    contractPriceController = TextEditingController(text: widget.rowData.contractPrice);
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
              widget.rowData.putCall = putCall;
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
