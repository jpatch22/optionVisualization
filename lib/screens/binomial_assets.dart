import 'package:flutter/material.dart';
import 'package:option_visualizer/utils/util.dart';
import '../requests/binomial_asset_requests.dart';
import '../requests/binomial_option_request.dart';
import '../models/tree_node.dart';
import '../widgets/tree_view.dart';

class BinomialPage extends StatefulWidget {
  @override
  _BinomialPageState createState() => _BinomialPageState();
}

class _BinomialPageState extends State<BinomialPage> {
  bool isBase = true;
  List<String> allowedOptions = ["European Call", "European Put"];

  // Asset fields
  final TextEditingController uController = TextEditingController();
  final TextEditingController vController = TextEditingController();
  final TextEditingController volController = TextEditingController();
  final TextEditingController dtController = TextEditingController();
  final TextEditingController numStepsController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  // Option fields
  final TextEditingController rController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController strikeController = TextEditingController();
  String? _selectedOption;

  final Map<String, String> optionTypeMap = {
    "European Call" : "europeanCall",
    "European Put" : "europeanPut",
  };

  TreeNode tree = TreeNode('Asset Tree');
  TreeNode optionTree = TreeNode('Option Tree');

  void updateTree(TreeNode newTree) {
    setState(() {
      tree = newTree;
    });
  }

  void updateOptionTree(TreeNode newTree) {
    setState(() {
      optionTree = newTree;
    });
  }

  Future<void> handleGenerateOptionTree() async {
    Future<List<List<double>>?> optionPricesFuture;
    String optionType = optionTypeMap[_selectedOption] ?? "";
    if (isBase) {
      double u = double.tryParse(uController.text) ?? 0.0;
      double v = double.tryParse(vController.text) ?? 0.0;
      double s = double.tryParse(stockController.text) ?? 0.0;
      int numSteps = int.tryParse(numStepsController.text) ?? 0;
      double r = double.tryParse(rController.text) ?? 0;
      double sigma = double.tryParse(volController.text) ?? 0;
      double K = double.tryParse(strikeController.text) ?? 0;
      double T = double.tryParse(timeController.text) ?? 0;
      optionPricesFuture = BinomialOptionRequest.sendBinomialOptionRequest(
        s, numSteps, u, v, sigma, K, r, T, optionType);
    } else {
      double vol = double.tryParse(volController.text) ?? 0.0;
      double T = double.tryParse(timeController.text) ?? 0.0;
      double s = double.tryParse(stockController.text) ?? 0.0;
      int numSteps = int.tryParse(numStepsController.text) ?? 0;
      double r = double.tryParse(rController.text) ?? 0;
      double sigma = double.tryParse(volController.text) ?? 0;
      double K = double.tryParse(strikeController.text) ?? 0;
      optionPricesFuture = BinomialOptionRequest.sendBinomialOptionsVolRequest(
        s, numSteps, vol, T, sigma, K, r, optionType);
    }

    List<List<double>>? optionPrices = await optionPricesFuture;
    List<List<double>> completed = optionPrices ?? [];

    TreeNode? optionTree = Utils.convertArrayToTree(completed);
    if (optionTree != null) {
      updateOptionTree(optionTree);
    }
  }

  Future<void> handleGenerateAssetTree() async {
    Future<List<List<double>>?> assetPricesFuture;
    if (isBase) {
      double u = double.tryParse(uController.text) ?? 0.0;
      double v = double.tryParse(vController.text) ?? 0.0;
      double s = double.tryParse(stockController.text) ?? 0.0;
      int numSteps = int.tryParse(numStepsController.text) ?? 0;
      assetPricesFuture = BinomialAssetRequest.sendBinomialAssetRequest(s, numSteps, u, v);
    } else {
      double vol = double.tryParse(volController.text) ?? 0.0;
      double dt = double.tryParse(dtController.text) ?? 0.0;
      double s = double.tryParse(stockController.text) ?? 0.0;
      int numSteps = int.tryParse(numStepsController.text) ?? 0;
      assetPricesFuture = BinomialAssetRequest.sendBinomialAssetDriftRequest(s, numSteps, vol, dt);
    }

    List<List<double>>? assetPrices = await assetPricesFuture;
    List<List<double>> completed = assetPrices ?? [];

    TreeNode? root = Utils.convertArrayToTree(completed);
    if (root != null) {
      updateTree(root);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Binomial Assets & Options'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isBase = !isBase;
                });
              },
              child: Text(isBase ? 'Switch to Drift' : 'Switch to Base'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isBase ? buildBaseFields() : buildDriftFields(),
                SizedBox(
                  height: 50,
                  child: VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
                isBase ? buildOptionFieldsBase() : buildOptionFieldsVol(),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: handleGenerateAssetTree,
                  child: Text('Generate Asset Tree'),
                ),
                SizedBox(
                  height: 50,
                  child: VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
                ElevatedButton(
                  onPressed: handleGenerateOptionTree, 
                  child: Text("Generate Option Tree"),
                ),
              ],
            ),
            Text("Binomial Asset Tree"),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 1000,
                    height: 800,
                    child: TreeView(root: tree),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Binomial Option Tree"),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 1000,
                    height: 800,
                    child: TreeView(root: optionTree),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBaseFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text('u'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: uController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Text('v'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: vController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20), // Add spacing between columns
        Column(
          children: [
            Text('Initial Stock Price'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: stockController,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20), // Add spacing between columns
        Column(
          children: [
            Text('Num Steps'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: numStepsController,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDriftFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text('Volatility'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: volController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Text('Time to Exptiry'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: dtController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20), // Add spacing between columns
        Column(
          children: [
            Text('Initial Stock Price'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: stockController,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20), // Add spacing between columns
        Column(
          children: [
            Text('Num Steps'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: numStepsController,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildOptionFieldsBase() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text('Risk Free Interest Rate'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: rController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Text('Time to Expiry'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: timeController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Text('Strike Price'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: strikeController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Text('Volatility'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: volController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20),
        Column(
          children: [
            DropdownButton<String>(
              hint: Text("Option Type"),
              value: _selectedOption,
              items: allowedOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOption = newValue;
                });
              })
          ],
          )
      ],
      );
  }

  Widget buildOptionFieldsVol() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text('Risk Free Interest Rate'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: rController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Text('Strike Price'),
            SizedBox(
              width: 100,
              child: TextField(
                controller: strikeController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 20),
        Column(
          children: [
            DropdownButton<String>(
              hint: Text("Option Type"),
              value: _selectedOption,
              items: allowedOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOption = newValue;
                });
              })
          ],
          )
      ],
      );
  }
}
