import 'package:flutter/material.dart';

import '../../source.dart';

class WidgetTextFormField extends StatefulWidget {
  final String hintText;

  final double height;
  final double circular;

  final bool obscureText;
  final bool readOnly;

  final Widget suffixIcon;
  final Widget prefixIcon;

  final TextEditingController controller;
  final TextStyle hintStyle;
  final Function onTap;

  final Color colorBorder;
  final Color colorFill;

  final FormFieldValidator<String> validator;
  final ValueChanged<String> onSubmitted;

  WidgetTextFormField({
    @required this.hintText,
    this.height = 15,
    this.circular = 99,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    @required this.controller,
    this.hintStyle,
    this.onTap,
    this.colorBorder,
    this.colorFill = Colors.white,
    this.validator,
    this.onSubmitted,
  });

  @override
  _WidgetTextFormFieldState createState() => _WidgetTextFormFieldState();
}

class _WidgetTextFormFieldState extends State<WidgetTextFormField> {
  @override
  Widget build(BuildContext context) {
    var _borderTextField = _buildBorderTextField(
      color: widget.colorBorder ?? AppColors.primary,
      circular: widget.circular,
    );

    return TextFormField(
      onTap: widget.onTap ?? () {},
      controller: widget.controller,
      readOnly: widget.readOnly ?? false,
      obscureText: widget.obscureText,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.validator,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
        focusedBorder: _borderTextField,
        enabledBorder: _borderTextField,
        errorBorder: _borderTextField,
        focusedErrorBorder: _borderTextField,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: widget.height,
        ),
        filled: true,
        fillColor: widget.colorFill,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle ??
            AppStyles.DEFAULT_REGULAR.copyWith(
              color: AppColors.primary,
            ),
      ),
    );
  }

  OutlineInputBorder _buildBorderTextField({
    @required Color color,
    @required double circular,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(circular),
      borderSide: BorderSide(
        color: color,
        width: 0.85,
      ),
    );
  }
}
