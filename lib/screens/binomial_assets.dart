import 'package:flutter/material.dart';
import 'package:option_visualizer/utils/util.dart';
import '../requests/binomial_asset_requests.dart';
import '../models/tree_node.dart';
import '../widgets/tree_view.dart';

class BinomialPage extends StatefulWidget {
  @override
  _BinomialPageState createState() => _BinomialPageState();
}

class _BinomialPageState extends State<BinomialPage> {
  bool isBase = true;

  final TextEditingController uController = TextEditingController();
  final TextEditingController vController = TextEditingController();
  final TextEditingController volController = TextEditingController();
  final TextEditingController dtController = TextEditingController();
  final TextEditingController numStepsController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  TreeNode tree = TreeNode('Root');

  void updateTree(TreeNode newTree) {
    setState(() {
      tree = newTree;
    });
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

    print("Running handleGenerateAssetTree...");
    List<List<double>>? assetPrices = await assetPricesFuture;
    List<List<double>> completed = assetPrices ?? [];
    print("Completed: $completed");

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
            isBase ? buildBaseFields() : buildDriftFields(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleGenerateAssetTree,
              child: Text('Generate Asset Tree'),
            ),
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
            Text('vol'),
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
            Text('dt'),
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
}
