// PICK QUANTITY (INPUT MANUAL / WITH BUTTONS)
import 'package:flutter/material.dart';

class PickQty extends StatefulWidget {
  const PickQty({
    super.key,
    this.initValue = 0,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    this.width,
  });

  final int initValue;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;
  final double? width;

  @override
  State<PickQty> createState() => _PickQtyState();
}

class _PickQtyState extends State<PickQty> {
  late final TextEditingController _inputValueController;

  @override
  void initState() {
    super.initState();
    _inputValueController = TextEditingController(
      text: widget.initValue.toString(),
    );
  }

  @override
  void didUpdateWidget(covariant PickQty oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initValue != widget.initValue &&
        _inputValueController.text != widget.initValue.toString()) {
      _inputValueController.text = widget.initValue.toString();
    }
  }

  @override
  void dispose() {
    _inputValueController.dispose();
    super.dispose();
  }

  void _updateValue(int newValue) {
    if (newValue < widget.minValue) {
      newValue = widget.minValue;
    }
    if (newValue > widget.maxValue) {
      newValue = widget.maxValue;
    }

    widget.onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Tombol Minus
          GestureDetector(
            onTap: () {
              if (widget.initValue > widget.minValue) {
                _updateValue(widget.initValue - 1);
              }
            },
            child: Container(
              width: 30,
              height: 40,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Icon(Icons.remove, size: 22),
            ),
          ),

          // INPUT FIELD
          SizedBox(
            width: 60,
            height: 40,
            child: TextFormField(
              controller: _inputValueController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) return;
                final newValue = int.tryParse(value);
                if (newValue != null) {
                  _updateValue(newValue);
                }
              },
            ),
          ),

          // Tombol Plus
          GestureDetector(
            onTap: () {
              if (widget.initValue < widget.maxValue) {
                _updateValue(widget.initValue + 1);
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: 30,
              height: 40,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Icon(Icons.add, size: 22),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.initValue > widget.minValue) {
                _updateValue(0);
              }
            },
            child: const Icon(
              Icons.close,
              size: 18,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
