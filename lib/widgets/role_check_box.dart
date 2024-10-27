import 'package:flutter/material.dart';

class RoleCheckbox extends StatefulWidget {
  final String roleName;
  final bool initialValue;
  final Function(bool) onChanged;

  const RoleCheckbox({
    super.key,
    required this.roleName,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<RoleCheckbox> createState() => _RoleCheckboxState();
}

class _RoleCheckboxState extends State<RoleCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        widget.roleName,
        style: const TextStyle(fontSize: 14),
      ),
      value: _isChecked,
      onChanged: (value) {
        setState(() {
          _isChecked = value ?? false;
        });
        widget.onChanged(_isChecked);
      },
      tristate: true,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}

