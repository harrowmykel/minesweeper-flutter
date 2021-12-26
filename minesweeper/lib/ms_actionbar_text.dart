import 'package:flutter/material.dart';

class MSActionBarText extends StatelessWidget {
  final String _text;
  final IconData _iconData;

  const MSActionBarText(
    this._text,
    this._iconData, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade400,
      padding: const EdgeInsets.symmetric(
        horizontal: 3,
        vertical: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _iconData,
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(width: 2),
          Text(
            _text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
