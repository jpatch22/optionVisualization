import 'package:flutter/material.dart';

class RangeSelector extends StatefulWidget {
  final ValueNotifier<double> minNotifier;
  final ValueNotifier<double> maxNotifier;
  final ValueNotifier<RangeValues> rangeNotifier;
  final ValueChanged<RangeValues> onRangeChanged;

  RangeSelector({
    Key? key,
    required this.minNotifier,
    required this.maxNotifier,
    required this.rangeNotifier,
    required this.onRangeChanged,
  }) : super(key: key);

  @override
  _RangeSelectorState createState() => _RangeSelectorState();
}

class _RangeSelectorState extends State<RangeSelector> {
  @override
  void initState() {
    super.initState();
    widget.rangeNotifier.addListener(_updateRange);
    widget.minNotifier.addListener(_updateRange);
    widget.maxNotifier.addListener(_updateRange);
  }

  @override
  void dispose() {
    widget.rangeNotifier.removeListener(_updateRange);
    widget.minNotifier.removeListener(_updateRange);
    widget.maxNotifier.removeListener(_updateRange);
    super.dispose();
  }

  void _updateRange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final rangeValues = widget.rangeNotifier.value;
    final min = widget.minNotifier.value;
    final max = widget.maxNotifier.value;
    final sideSpacing = 20.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            SizedBox(width: sideSpacing),
            Text(
              'Min: ${rangeValues.start.round()}',
              style: TextStyle(fontSize: 16),
            ),
            Expanded(
              child: RangeSlider(
                values: rangeValues,
                min: min,
                max: max,
                divisions: 100,
                labels: RangeLabels(
                  rangeValues.start.round().toString(),
                  rangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  widget.rangeNotifier.value = values;
                  widget.onRangeChanged(values); // Notify parent of changes
                },
              ),
            ),
            Text(
              'Max: ${rangeValues.end.round()}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(width: sideSpacing)
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
