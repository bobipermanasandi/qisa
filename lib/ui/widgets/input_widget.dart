import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qisa/common/enum/input_type.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final InputType type;
  final String? hintText;
  final bool isPassword;
  final bool showPassword;
  final int? maxLines;
  final String? Function(String?)? validator;
  final Function()? onPressedPassword;
  const InputWidget({
    super.key,
    required this.labelText,
    required this.controller,
    this.type = InputType.text,
    this.hintText,
    this.maxLines = 1,
    this.isPassword = false,
    this.showPassword = true,
    this.validator,
    this.onPressedPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: labelText,
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.zero,
            child: TextFormField(
              controller: controller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType:
                  (type == InputType.email)
                      ? TextInputType.emailAddress
                      : (type == InputType.phone)
                      ? TextInputType.number
                      : TextInputType.text,
              obscureText: !showPassword,
              validator: validator,
              inputFormatters:
                  (type == InputType.phone)
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : null,
              style: TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: maxLines,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.black38),
                suffixIcon:
                    (isPassword)
                        ? IconButton(
                          onPressed: onPressedPassword,
                          icon: Icon(
                            (!showPassword)
                                ? Icons.visibility
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                        )
                        : null,
                counterText: "",
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                errorMaxLines: 2,
                errorStyle: TextStyle(fontSize: 11, color: Colors.redAccent),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff9f050d)),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
