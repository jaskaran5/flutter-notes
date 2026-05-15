import 'package:flutter/material.dart';



class TimePicker extends StatefulWidget {
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  List<int> hours = List.generate(12, (index) => index+1);
  List<int> minutes = List.generate(60, (index) => index);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildPicker(hours, 'Hour')),
          Expanded(child: _buildPicker(minutes, 'Minute')),
        ],
      ),
    );
  }

  Widget _buildPicker(List<int> items, String label) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 200.0,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Divider(), // Divider before each item
                      ListTile(
                        title: Center(
                          child: Text(
                            '${items[index]}',
                            style: TextStyle(fontSize: 24.0),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Divider(), // Divider after the last item
          ],
        ),
      ),
    );
  }
}
