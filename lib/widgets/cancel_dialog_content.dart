import 'package:flutter/material.dart';

import '../config/const_design.dart';

/// The content of the cancel order dialog.
class CancelOrderDialogContent extends StatelessWidget {
  const CancelOrderDialogContent({
    Key? key,
    required this.cancelType,
    required this.selectedCancelType,
    required this.textEditingController,
    required this.onSelectedCancelTypeChanged,
    required this.onTextChanged,
  }) : super(key: key);

  final List<int> cancelType;
  final int selectedCancelType;
  final TextEditingController textEditingController;
  final ValueChanged<int> onSelectedCancelTypeChanged;
  final ValueChanged<String> onTextChanged;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "ເລືອກການຍົກເລີກ",
              style: TextStyle(
                fontFamily: "noto san lao",
                color: Colors.white,
              ),
            ),
            DropdownButtonFormField<int>(
              value: selectedCancelType,
              style: const TextStyle(
                fontFamily: "noto san lao",
                color: Colors.white,
              ),
              dropdownColor: kPrimaryColor,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0),
                  ),
                ),
              ),
              items: cancelType
                  .map(
                    (item) => DropdownMenuItem<int>(
                      value: item,
                      child: Text(
                        '${item == 1 ? 'Effected' : item == 2 ? 'Cancel' : 'Return'} ',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                onSelectedCancelTypeChanged(1);
              },
              validator: (value) =>
                  value == null ? "ກລນ ເລືອກປະເພດການຍົກເລີກ" : null,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.4),
              ),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                enableSuggestions: false,
                autocorrect: false,
                controller: textEditingController,
                cursorColor: Colors.white,
                style: const TextStyle(
                  fontFamily: "noto san lao",
                  color: Colors.white,
                ),
                onChanged: onTextChanged,
                onTap: () => textEditingController.selection =
                    const TextSelection.collapsed(offset: -1),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(
                    fontFamily: "noto san lao",
                    color: Colors.white,
                  ),
                  hintText: 'ເຫດຜົນ ການຍົກເລີກ',
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
