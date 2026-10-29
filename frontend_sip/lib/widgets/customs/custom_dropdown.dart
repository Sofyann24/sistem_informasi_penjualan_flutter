import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    this.hintText = 'Pilih...',
    this.searchHintText = 'Cari Barang...',
    required this.itemAsString,
    this.compareFn,
    required this.onSelected,
    this.validator,
    this.labelText,
    this.enabled = true,
    this.titleDropdown,
  });

  final String? titleDropdown;
  final List<T> items;
  final T? selectedItem;
  final String hintText;
  final String searchHintText;
  final String Function(T) itemAsString;
  final bool Function(T, T)? compareFn;
  final void Function(T?) onSelected;
  final String? Function(T?)? validator;
  final String? labelText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownSearch<T>(
          items: (filter, loadProps) {
            final query = filter.toLowerCase();
            return items
                .where(
                  (items) => itemAsString(items).toLowerCase().contains(query),
                )
                .toList();
          },
          itemAsString: itemAsString,
          selectedItem: selectedItem,
          compareFn: compareFn,
          onSelected: enabled ? onSelected : null,
          validator: validator,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
              border: OutlineInputBorder(),
            ),
          ),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
