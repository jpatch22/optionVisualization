import 'package:flutter/material.dart';
import '../models/row_data.dart';
import '../widgets/row_item.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<RowData> rows = [RowData()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Dynamic Rows'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Long/Short'),
              Text('Put/Call'),
              Text('Contract Price'),
              Spacer(),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: addRow,
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: removeRow,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, index) {
                return RowItem(
                  key: UniqueKey(),
                  rowData: rows[index],
                  onAdd: () => addRowAt(index),
                  onRemove: () => removeRowAt(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void addRow() {
    setState(() {
      rows.add(RowData());
    });
  }

  void removeRow() {
    if (rows.length > 1) {
      setState(() {
        rows.removeLast();
      });
    }
  }

  void addRowAt(int index) {
    setState(() {
      rows.insert(index + 1, RowData());
    });
  }

  void removeRowAt(int index) {
    if (rows.length > 1) {
      setState(() {
        rows.removeAt(index);
      });
    }
  }
}
