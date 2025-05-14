import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberCarField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLetter;
  final int index;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  const NumberCarField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isLetter,
    required this.index,
    required this.controllers,
    required this.focusNodes,
  });

  @override
  Widget build(BuildContext context) {
    final double height = isLetter ? 60.0 : 80.0;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 48,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Focus(
        onKey: (FocusNode node, RawKeyEvent event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              controller.text.isEmpty &&
              index > 0) {
            controllers[index - 1].clear();
            FocusScope.of(context).requestFocus(focusNodes[index - 1]);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          maxLength: 1,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.allow(RegExp(isLetter ? r'[А-Яа-я]' : r'[0-9]')),
          ],
          onChanged: (text) {
            if (isLetter && text.isNotEmpty) {
              final upper = text.toUpperCase();
              controller.value = TextEditingValue(
                text: upper,
                selection: TextSelection.collapsed(offset: upper.length),
              );
            }

            if (text.isNotEmpty && index < focusNodes.length - 1) {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            }
          },
          decoration: const InputDecoration(counterText: '', border: InputBorder.none),
          style: const TextStyle(fontSize: 44),
        ),
      ),
    );
  }
}
