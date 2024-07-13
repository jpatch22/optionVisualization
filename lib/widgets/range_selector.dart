import 'package:flutter/material.dart';

class RangeSelector extends StatefulWidget {
  final double min;
  final double max;
  final RangeValues initialRange;
  final ValueChanged<RangeValues> onRangeChanged;

  RangeSelector({
    Key? key,
    required this.min,
    required this.max,
    required this.initialRange,
    required this.onRangeChanged,
  }) : super(key: key);

  @override
  _RangeSelectorState createState() => _RangeSelectorState();
}

class _RangeSelectorState extends State<RangeSelector> {
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = widget.initialRange;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Select Range:',
          style: TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            Text(
              'Start: ${_currentRangeValues.start.round()}',
              style: TextStyle(fontSize: 16),
            ),
            Expanded(
              child: RangeSlider(
                values: _currentRangeValues,
                min: widget.min,
                max: widget.max,
                divisions: 100,
                labels: RangeLabels(
                  _currentRangeValues.start.round().toString(),
                  _currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                  widget.onRangeChanged(values); // Notify parent of changes
                },
              ),
            ),
            Text(
              'End: ${_currentRangeValues.end.round()}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'Selected range: ${_currentRangeValues.start.round()} - ${_currentRangeValues.end.round()}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
