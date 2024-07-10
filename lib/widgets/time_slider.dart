import 'package:flutter/material.dart';

class TimeSliderWidget extends StatefulWidget {
  final List<double> time;
  final Function(int) onTimeIndexChanged;

  TimeSliderWidget({required this.time, required this.onTimeIndexChanged});

  @override
  _TimeSliderWidgetState createState() => _TimeSliderWidgetState();
}

class _TimeSliderWidgetState extends State<TimeSliderWidget> {
  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    if (widget.time.isNotEmpty) {
      _currentSliderValue = widget.time.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.time.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        Slider(
          value: _currentSliderValue,
          min: widget.time.first,
          max: widget.time.last,
          divisions: widget.time.length - 1,
          label: _currentSliderValue.toString(),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
              int timeIndex = widget.time.indexOf(value);
              widget.onTimeIndexChanged(timeIndex);
            });
          },
        ),
        Text('Current Time: $_currentSliderValue'),
      ],
    );
  }
}
