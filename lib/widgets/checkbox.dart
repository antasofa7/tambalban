import 'package:flutter/material.dart';
import 'package:tambal_ban/theme.dart';

class LabeledCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final bool selected;
  final ValueChanged<bool> onChanged;
  const LabeledCheckbox(
      {Key? key,
      required this.label,
      required this.value,
      required this.onChanged,
      this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(
          label,
          style: blackTextStyle.copyWith(fontSize: 14.0),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: value,
        selected: selected,
        activeColor: greenColor,
        onChanged: (bool? newValue) {
          onChanged(newValue!);
        });
  }
}
