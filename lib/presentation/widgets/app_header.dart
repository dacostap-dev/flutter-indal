import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: MyClipperTwo(),
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0x22ff3a5a),
                Color(0x22fe494d),
              ]),
            ),
          ),
        ),
        ClipPath(
          clipper: MyClipperThree(),
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0x22ff3a5a),
                Color(0x22fe494d),
              ]),
            ),
          ),
        ),
        ClipPath(
          clipper: MyClipperOne(),
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xffff3a5a),
                Color(0xfffe494d),
              ]),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(height: 50),
                Icon(
                  Icons.flutter_dash,
                  size: 60,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                Text(
                  'Flutter',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MyClipperOne extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height - 50;

    final path = Path();
    path.lineTo(0, h);

    final firstCurvePoint = Offset(w * .25, h - 60);
    final firstEndPoint = Offset(w * 0.6, h - 29);

    path.quadraticBezierTo(firstCurvePoint.dx, firstCurvePoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondCurvePoint = Offset(w * 0.84, h);
    final secondEndPoint = Offset(w, h - 10);

    path.quadraticBezierTo(secondCurvePoint.dx, secondCurvePoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class MyClipperTwo extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    path.lineTo(0, h - 50);

    final firstCurvePoint = Offset(w * .25, h);
    final firstEndPoint = Offset(w * 0.6, h - 30);

    path.quadraticBezierTo(firstCurvePoint.dx, firstCurvePoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondCurvePoint = Offset(w * 0.84, h - 50);
    final secondEndPoint = Offset(w, h - 40);

    path.quadraticBezierTo(secondCurvePoint.dx, secondCurvePoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class MyClipperThree extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height - 50;

    final path = Path();
    path.lineTo(0, h);

    final firstCurvePoint = Offset(w * .28, h - 50);
    final firstEndPoint = Offset(w * 0.5, h - 25);

    path.quadraticBezierTo(firstCurvePoint.dx, firstCurvePoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondCurvePoint = Offset(w * 0.85, h + 20);
    final secondEndPoint = Offset(w, h + 20);

    path.quadraticBezierTo(secondCurvePoint.dx, secondCurvePoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
