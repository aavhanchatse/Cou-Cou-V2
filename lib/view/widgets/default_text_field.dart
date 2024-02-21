import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTextField extends StatelessWidget {
  final Function onChanged;
  final Function? onSaved;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String hintText;
  final bool enabled;
  final String? initialValue;
  final int? maxLines;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? minLines;
  final TextCapitalization? textCapitalization;
  final Function? validator;
  final Function? onTap;
  final TextEditingController? textEditingController;
  final List<TextInputFormatter>? textInputFormatter;
  final bool? autofocus;
  final TextInputAction? textInputAction;
  final Color? cursorColor;

  const DefaultTextField({
    Key? key,
    this.textEditingController,
    required this.onChanged,
    this.onSaved,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    required this.hintText,
    this.enabled = true,
    this.initialValue,
    this.maxLines = 1,
    this.keyboardType,
    this.maxLength,
    this.textCapitalization,
    this.validator,
    this.onTap,
    this.textInputFormatter,
    this.autofocus = false,
    this.textInputAction,
    this.cursorColor,
    this.minLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          minLines: minLines,
          textInputAction: textInputAction,
          autofocus: autofocus ?? false,
          controller: textEditingController,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          inputFormatters: textInputFormatter,
          maxLines: maxLines,
          maxLength: maxLength,
          initialValue: initialValue,
          keyboardAppearance: Brightness.light,
          keyboardType: keyboardType,
          onChanged: (value) {
            onChanged(value);
          },
          onSaved: (value) {
            if (onSaved != null) {
              onSaved!(value);
            }
          },
          validator: validator == null
              ? null
              : (value) {
                  return validator!(value);
                },
          onTap: onTap == null
              ? null
              : () {
                  onTap!();
                },
          cursorColor: cursorColor ?? Constants.black,
          // textInputAction: TextInputAction.,
          obscureText: obscureText,
          enabled: enabled,

          decoration: InputDecoration(
            fillColor: Constants.white,
            filled: true,
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(),
            prefixIcon: prefixIcon,
            counterText: '',
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.0, horizontal: 4.w),
            labelText: hintText,
            labelStyle: TextStyle(color: Constants.primaryGrey),
            // floatingLabelStyle: TextStyle(
            //   color: Constants.primaryColor,
            //   backgroundColor: Colors.white,
            // ),
            errorStyle: TextStyle(
              color: Constants.red1,
            ),
            focusedBorder: StyleUtil.defaultTextFieldBorder(),
            enabledBorder: StyleUtil.defaultTextFieldBorder(),
            border: StyleUtil.defaultTextFieldBorder(),
            errorBorder: StyleUtil.defaultTextFieldBorder(),
            disabledBorder: StyleUtil.defaultTextFieldBorder(),
          ),
        ),
      ],
    );
  }
}
