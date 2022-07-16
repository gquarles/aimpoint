// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(home: AimpointPage(), debugShowCheckedModeBanner: false,));
}

class AimpointPage extends StatefulWidget {
  const AimpointPage({Key? key}) : super(key: key);

  @override
  AimpointPageState createState() => AimpointPageState();
}

class AimpointPageState extends State<AimpointPage> {
  Offset _currentOffset = Offset.zero;
  double yPercentFromCenter = 0;
  double xPercentFromCenter = 0;
  List<Widget> arrowCircles = [];

  loadOffset() async {
    //Get offset from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final offsetx = prefs.getDouble('offsetx');
    final offsety = prefs.getDouble('offsety');
    setState(() {
      yPercentFromCenter = offsety ?? 0;
      xPercentFromCenter = offsetx ?? 0;
    });
  }

  saveOffset(double x, double y) async {
    //Save offset to shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('offsetx', x);
    prefs.setDouble('offsety', y);
  }

  @override
  void initState() {
    loadOffset();
    super.initState();
  }

  Widget drawRing(
      Color color, double size, double seperatorSize, double ringSize,
      {Color seperatorColor = Colors.black, Offset offset = Offset.zero}) {
    return Stack(
      children: [
        Container(
          width: 0,
          height: 0,
          child: CustomPaint(
            painter: CirclePainter(
                color: seperatorColor,
                offset: offset,
                radius: size + seperatorSize,),
          ),
        ),
        Container(
          width: 0,
          height: 0,
          child: CustomPaint(
            painter: CirclePainter(color: color, offset: offset, radius: size,),
          ),
        ),
        Container(
          width: 0,
          height: 0,
          child: CustomPaint(
            painter: CirclePainter(
                color: seperatorColor, offset: offset, radius: size - ringSize,),
          ),
        ),
        Container(
          width: 0,
          height: 0,
          child: CustomPaint(
            painter: CirclePainter(
                color: Colors.white,
                offset: offset,
                radius: size - seperatorSize - ringSize,),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        shadowColor: Colors.yellow[50],
        backgroundColor: Colors.yellow[50],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Aimpoint', style: TextStyle(color: Colors.black)),
        
      ),
      body: Center(
        child: ConstrainedBox(constraints: BoxConstraints.loose(const Size.fromWidth(200)),
        child: LayoutBuilder(
          builder: (context, display) {
            var width = display.constrainWidth(display.maxHeight) * .95;
            var height = display.constrainHeight(display.maxWidth) * .95;
            var r = width / 2;
            //var ry = (display.constrainHeight(display.maxWidth) * .95) / 2;
            var ringSize = r * 0.104;
            var sepSize = r * 0.0125;
            
            var yFromCenter = yPercentFromCenter * height;
            var xFromCenter = xPercentFromCenter * width;
            _currentOffset = Offset(xFromCenter, yFromCenter);

            return GestureDetector(
              onTapUp: (details) {
                var xorigin = display.maxWidth / 2;
                var yorigin = display.maxHeight / 2;

                var directionx = details.localPosition.dx - xorigin;
                var directiony = details.localPosition.dy - yorigin;
                //directiony = -directiony;
                //var magnitude = sqrt(directionx * directionx + directiony * directiony);

                //print('mag: $magnitude');
                //print('x_dir: $directionx');
                //print('y_dir: $directiony');
                //directionx = -directionx;
                //directiony = -directiony;
                //var yPercent = (details.localPosition.dy / height);
                //var xPercent = (details.localPosition.dx / width);
                var yPercent = (directiony / height);
                var xPercent = (directionx / width);
                

                yPercentFromCenter = yPercent; //- 0.50;
                xPercentFromCenter = xPercent; //- 0.50;
                var yFromCenter = yPercentFromCenter * height;
                var xFromCenter = xPercentFromCenter * width;
                
                saveOffset(xPercentFromCenter, yPercentFromCenter);
                setState(() {
                  _currentOffset = Offset(xFromCenter, yFromCenter);
                });
              },
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: Container(
                      color: Colors.yellow[50],
                    ),
                  ),
                  Center(child: drawRing(Colors.white, r, sepSize, ringSize - sepSize)),
                  Center(child: drawRing(Colors.white, r - ringSize, sepSize, ringSize - sepSize)),
                  Center(child: drawRing(Colors.black, r - (ringSize * 2), sepSize, ringSize - sepSize, seperatorColor: Colors.black)),
                  Center(child: drawRing(Colors.black, r - (ringSize * 3), sepSize - 1, ringSize - sepSize, seperatorColor: Colors.white)),
                  Center(child: drawRing(Colors.blue, r - (ringSize * 4), sepSize + 1, ringSize - sepSize)),
                  Center(child: drawRing(Colors.blue, r - (ringSize * 5), sepSize, ringSize - sepSize)),
                  Center(child: drawRing(Colors.red, r - (ringSize * 6), sepSize, ringSize - sepSize)),
                  Center(child: drawRing(Colors.red, r - (ringSize * 7), sepSize, ringSize - sepSize)),
                  Center(child: drawRing(Colors.yellow, r - (ringSize * 8), sepSize, ringSize - sepSize, )),
                  Center(child: drawRing(Colors.yellow, r - (ringSize * 9), sepSize, ringSize - sepSize)),
                  Center(child: drawRing(Colors.yellow, r - (ringSize * 10), sepSize, ringSize - sepSize,)),
                  Center(child: drawRing(Colors.yellow, r - (ringSize * 11), sepSize + 1, ringSize - sepSize, seperatorColor: Colors.yellow)),
                  Center(child: drawRing(Colors.greenAccent, 10, 2, 5, offset: _currentOffset)),
                  ///...arrowCircles,
                  //Center(child: drawRing(Colors.red, 10, 2, 5, offset: Offset(r, ry))),
                  //drawRing(Colors.redAccent, 10, 2, 5, offset: _currentOffset)
                  //ClipOval(
                  //  child: Image.network(
                  //      'https://cdn.shopify.com/s/files/1/1100/1512/products/80cm_Paper_Face_44bd121d-6181-4a9b-9fb8-ea55bb75c6d8_1800x.png'),
                  //),
                ],
              ),
            );
          }
        ),),
      )
    );
  }
}

class CirclePainter extends CustomPainter {
  final double radius;
  final Color color;
  final Offset offset;

  CirclePainter(
      {required this.radius, required this.color, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        offset,
        radius,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
