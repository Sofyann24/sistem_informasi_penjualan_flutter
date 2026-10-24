import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sistem_informasi_penjualan/utils/extension.dart';

class DeleteConfirmDialog {
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message, style: context.textTheme.bodyLarge),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}

// FORM FIELD CONFIG
class FormFieldConfig {
  FormFieldConfig({
    required this.key,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.isRequired = false,
    this.validator,
    this.maxLines = 1,
    this.obscureText = false,
    this.initialValue,
  });

  final String key;
  final String label;
  final String? hint;
  final TextInputType keyboardType;
  final bool isRequired;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool obscureText;
  final String? initialValue;
}

class DynamicFormDialog extends StatefulWidget {
  const DynamicFormDialog({
    super.key,
    required this.title,
    this.message,
    this.cancelLabel = 'Batal',
    this.fields,
    this.initialValues,
    this.submitLabel = 'Simpan',
    this.onSubmit,
    this.onConfirm,
  });

  final String title;
  final String? message;
  final String cancelLabel;
  final List<FormFieldConfig>? fields;
  final Map<String, dynamic>? initialValues;
  final String submitLabel;
  final Future<bool> Function(Map<String, dynamic> values)? onSubmit;
  final VoidCallback? onConfirm;

  @override
  State<DynamicFormDialog> createState() => _DynamicFormDialogState();
}

class _DynamicFormDialogState extends State<DynamicFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = false;
  bool get isFormMode => widget.fields != null && widget.fields!.isNotEmpty;
  bool get isConfirmMode => !isFormMode;

  @override
  void initState() {
    super.initState();
    for (final field in widget.fields!) {
      _controllers[field.key] = TextEditingController(
        text: widget.initialValues?[field.key]?.toString() ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (isFormMode && !_formKey.currentState!.validate()) return;
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });
    try {
      if (isFormMode && widget.onSubmit != null) {
        final values = <String, dynamic>{};
        for (final field in widget.fields!) {
          values[field.key] = _controllers[field.key]!.text.trim();
        }

        final success = await widget.onSubmit!(values);

        if (!mounted) return;
        setState(() => _isLoading = false);

        if (success) {
          Navigator.pop(context, values);
        }
      } else if (isConfirmMode) {
        widget.onConfirm?.call();
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: isFormMode
          ? Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final field in widget.fields!) ...[
                      TextFormField(
                        autofocus: true,
                        controller: _controllers[field.key],
                        keyboardType: field.keyboardType,
                        obscureText: field.obscureText,
                        maxLines: field.maxLines,
                        textCapitalization: TextCapitalization.sentences,
                        inputFormatters:
                            field.keyboardType ==
                                const TextInputType.numberWithOptions(
                                  decimal: true,
                                )
                            ? [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$'),
                                ),
                              ]
                            : null,
                        decoration: InputDecoration(
                          labelText: field.label,
                          hintText: field.hint,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (field.isRequired &&
                              (value == null || value.isEmpty)) {
                            return '${field.label} wajib diisi';
                          }

                          if (field.validator != null) {
                            return field.validator!(value);
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.message ?? 'Apakah Anda yakin?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(widget.cancelLabel),
        ),
        TextButton(
          onPressed: _isLoading ? null : _onSubmit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.submitLabel, style: context.textTheme.bodyMedium),
        ),
      ],
    );
  }
}
