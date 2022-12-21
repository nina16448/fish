import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({Key? key, required this.onTap}) : super(key: key);
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Color(0xFF0F0BDB),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          width: 60,
          height: 60,
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 30,
          )),
    );
  }
}
