import 'package:coucou_v2/app_constants/constants.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:coucou_v2/utils/style_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? subLabel;
  final String? hintText;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final Function? onChanged;
  final Function? validator;
  final TextInputType? keyboardType;
  final String? initialValue;
  final Widget? suffixIcon;
  final bool? obscureText;
  final bool? autofocus;
  final Function? onSaved;
  final TextEditingController? textController;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    Key? key,
    this.label,
    this.subLabel,
    required this.hintText,
    this.maxLines,
    this.textInputAction,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.initialValue,
    this.maxLength,
    this.suffixIcon,
    this.obscureText,
    required this.onSaved,
    this.textController,
    this.inputFormatters,
    this.autofocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Row(
            children: [
              Expanded(
                child: Text(
                  label!,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 1.8.t,
                      color: Constants.black.withOpacity(0.8)),
                ),
              ),
            ],
          ),
        if (subLabel != null)
          Padding(
            padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        subLabel!,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 1.2.t,
                            color: Colors.redAccent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: 0.5.h),
        TextFormField(
          autofocus: autofocus ?? false,
          inputFormatters: inputFormatters,
          controller: textController,
          initialValue: initialValue,
          cursorColor: Constants.black,
          maxLines: maxLines,
          obscureText: obscureText ?? false,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          maxLength: maxLength,
          scrollPadding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  (4 * kToolbarHeight)),
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            errorStyle: const TextStyle(height: 0.5, color: Colors.red),
            counterText: '',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.5),
              fontSize: 1.8.t,
            ),
            fillColor: Constants.white,
            filled: true,
            focusedBorder: StyleUtil.defaultTextFieldBorder(),
            enabledBorder: StyleUtil.defaultTextFieldBorder(),
            border: StyleUtil.defaultTextFieldBorder(),
            errorBorder: StyleUtil.defaultTextFieldBorder(),
            disabledBorder: StyleUtil.defaultTextFieldBorder(),
          ),
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
          },
          onSaved: (value) {
            onSaved!(value);
          },
          validator: (value) {
            return validator!(value);
          },
        ),
      ],
    );
  }
}
