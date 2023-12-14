import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class BaseCheckBox extends StatefulWidget {
  final Object? fieldKey;
  final bool? initialValue;
  final FocusNode? focusNode;

  final bool isEnabled;
  final ValueChanged<bool>? onChanged;
  final Widget? label;
  final bool? error;
  final FormFieldValidator<String>? validator;

  const BaseCheckBox({
    Key? key,
    this.fieldKey,
    this.initialValue,
    this.onChanged,
    this.isEnabled = true,
    this.label,
    this.validator,
    this.focusNode,
    this.error,
  }) : super(key: key);

  @override
  _BaseCheckBoxState createState() => _BaseCheckBoxState();
}

class _BaseCheckBoxState extends State<BaseCheckBox>
    implements BaseFormField<bool> {
  bool _value = true;
  String? _errorText;
  late FocusNode fieldFocusNode;

  var isValidated = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? false;

    final focusNode = widget.focusNode;
    if (focusNode != null) {
      fieldFocusNode = focusNode;
    } else {
      fieldFocusNode = FocusNode();
    }

    _setValue(widget.initialValue ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final fieldKey = widget.fieldKey;
    if (fieldKey != null) {
      BaseForm.of(context)?.register(fieldKey, this);
    }

    final textContent = widget.label;

    final checkBoxContainer = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CheckBox(
              isEnabled: widget.isEnabled,
              value: _value,
              onChanged: onChanged,
            ),
            if (textContent != null) ...[
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                child: textContent,
              ),
            ],
          ],
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 28).w,
            child: Text(
              _errorText!,
              style: AppStyle.txtError,
            ),
          ),
      ],
    );
    return checkBoxContainer;
  }

  void onChanged(bool? value) {
    _setValue(value ?? false);
    widget.onChanged?.call(_value);
    if (widget.fieldKey != null) {
      BaseForm.of(context)?.fieldDidChange();
    }
  }

  String? get validateValue => _value == false ? '' : _value.toString();

  @override
  void clear() {
    _setValue(false);
  }

  void _setValue(bool value) {
    _value = value;
    if (_value) {
      _errorText = null;
    } else {
      validate();
    }
    setState(() {});
  }

  @override
  void focus() {
    fieldFocusNode.requestFocus();
  }

  void _validate() {
    final validator = widget.validator;
    if (validator != null) {
      _errorText = validator(validateValue);
    }
    isValidated = true;
  }

  @override
  bool get isValid {
    final validator = widget.validator;
    return validator == null || validator(validateValue) == null;
  }

  bool get hasError {
    return _errorText != null || errorText != null;
  }

  @override
  bool validate() {
    setState(() {
      _validate();
    });
    return !hasError;
  }

  String? get errorText => _errorText;

  @override
  bool? get value => _value;
}

class _CheckBox extends StatelessWidget {
  final bool isEnabled;
  final bool value;
  final Function(bool) onChanged;

  const _CheckBox({
    Key? key,
    required this.isEnabled,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: BoxConstraints.loose(
        const Size(
          21,
          21,
        ),
      ),
      padding: EdgeInsets.zero,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: isEnabled
          ? () {
              onChanged(!value);
            }
          : null,
      icon: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: AppColor.themePrimaryColor,
            width: 1,
          ),
          color: AppColor.themeWhiteColor,
        ),
        child: value
            ? Center(
                child: Assets.icons.icCheck.svg(
                  color: isEnabled
                      ? AppColor.themePrimaryColor
                      : AppColor.themeWhiteColor,
                ),
              )
            : null,
      ),
    );
  }
}
