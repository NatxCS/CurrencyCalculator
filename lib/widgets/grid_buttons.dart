import 'package:flutter/material.dart';

class GridButtons extends StatelessWidget {
  const GridButtons({
    super.key,
    required this.buttons,
  });

  final List<String> buttons;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(1.5),
      color: Colors.grey[400],
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          childAspectRatio: 2.0,
          crossAxisSpacing: 2.5,
          mainAxisSpacing: 2.5,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: buttons.length,
        itemBuilder: (BuildContext context, int index) {
          if (buttons[index] == 'back') {
            return ElevatedButton(
              onPressed: () {

              },
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.green.withOpacity(0.2);
                  }
                  return Colors.transparent;
                }),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 35,
              ),
            );
          } else {
            return ElevatedButton(
              onPressed: () {

              },
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.green.withOpacity(0.2);
                  }
                  return Colors.transparent;
                }),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: Text(
                buttons[index],
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}