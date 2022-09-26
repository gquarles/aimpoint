// ignore_for_file: sized_box_for_whitespace

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AimpointLocation {
  final double theta;
  final double magnitude;
  final bool negativeY;

  AimpointLocation(
      {required this.theta, required this.magnitude, required this.negativeY});

  Offset offset(double radius) {
    var scalar = magnitude * radius;
    var directionx = scalar * -sin(theta);
    var directiony = scalar * -cos(theta);
    if (negativeY) directiony = -directiony;
    if (negativeY) directionx = -directionx;

    return Offset(directionx, directiony);
  }

  static AimpointLocation fromCartesian(
      BoxConstraints constraints, double dx, double dy, double radius) {
    //Get x,y for center of target
    var xorigin = constraints.maxWidth / 2;
    var yorigin = constraints.maxHeight / 2;

    //Direction of vector from center of target
    var directionx = dx - xorigin;
    var directiony = dy - yorigin;

    //Magnitude of vector
    var magnitude = sqrt(directionx * directionx + directiony * directiony);

    //Get what % of the radius is the magnitude
    var magnitudeAdjusted = magnitude / radius;
    //Grab angle in radians
    var theta = atan(directionx / directiony);

    //If bottom half we flip sign of x and y
    var negativeY = (directiony < 0) ? false : true;

    return AimpointLocation(
        theta: theta, magnitude: magnitudeAdjusted, negativeY: negativeY);
  }
}

class Target {
  late double radius;
  late double ringSize;
  late double seperatorSize;
  final BoxConstraints constraints;

  Target({required this.constraints}) {
    radius = (constraints.constrainWidth(constraints.maxHeight) * .95) / 2;
    ringSize = radius * 0.104;
    seperatorSize = radius * 0.0125;
  }

  int findSelectedRing(AimpointLocation aimpoint) {
    if (aimpoint.magnitude * radius < radius) {
      for (int ring = 0; ring < 13; ring++) {
        if (!(aimpoint.magnitude * radius < radius - (ringSize * ring))) {
          return ring;
        }
      }  
    }

    return 0;
  }

  static Widget drawRing(
      Color color, double size, double seperatorSize, double ringSize,
      {Color seperatorColor = Colors.black,
      Offset offset = Offset.zero,
      bool drawName = false, bool selected = false}) {
    
    if (selected) {
      if (color == Colors.blue) color = Colors.blue[800]!;
      if (color == Colors.red) color = Colors.red[800]!;
      if (color == Colors.black) color = Colors.grey[800]!;
      if (color == Colors.white) color = Colors.white70;
      if (color == Colors.yellow) color = Colors.amber[700]!;
      //size = size + 1;
      //seperatorSize = seperatorSize * 2;
    }
    return Stack(
      children: [
        Container(
          width: 0,
          height: 0,
          child: CustomPaint(
            painter: CirclePainter(
              color: seperatorColor,
              offset: offset,
              radius: size + seperatorSize,
            ),
          ),
        ),
        Container(
          width: 0,
          height: 0,
          child: CustomPaint(
            painter: CirclePainter(
              color: color,
              offset: offset,
              radius: size,
            ),
          ),
        ),
        Container(
          width: 0,
          height: 0,
          child: CustomPaint(
            painter: CirclePainter(
              color: seperatorColor,
              offset: offset,
              radius: size - ringSize,
            ),
          ),
        ),
        Container(
          width: 0,
          height: 0,
          child: CustomPaint(
            painter: CirclePainter(
              color: Colors.white,
              offset: offset,
              radius: size - seperatorSize - ringSize,
              drawName: drawName,
            ),
          ),
        ),
      ],
    );
  }

  static List<Widget> buildTarget(Target target, {int selectedRing = -1, bool isHovering = false}) {
    if (isHovering == false) selectedRing = -1;
    return [
      Center(
        child: drawRing(
          Colors.white,
          target.radius,
          target.seperatorSize,
          target.ringSize - target.seperatorSize,
          selected: selectedRing == 1
        ),
      ),
      Center(
        child: drawRing(
          Colors.white,
          target.radius - target.ringSize,
          target.seperatorSize,
          target.ringSize - target.seperatorSize,
          selected: selectedRing == 2
        ),
      ),
      Center(
        child: drawRing(
          Colors.black,
          target.radius - (target.ringSize * 2),
          target.seperatorSize,
          target.ringSize - target.seperatorSize,
          seperatorColor: Colors.black,
          selected: selectedRing == 3
        ),
      ),
      Center(
        child: drawRing(
          Colors.black,
          target.radius - (target.ringSize * 3),
          target.seperatorSize - 1,
          target.ringSize - target.seperatorSize,
          seperatorColor: Colors.white,
          selected: selectedRing == 4
          
        ),
      ),
      Center(
        child: drawRing(
          Colors.blue,
          target.radius - (target.ringSize * 4),
          target.seperatorSize + 1,
          target.ringSize - target.seperatorSize,
          selected: selectedRing == 5
        ),
      ),
      Center(
        child: drawRing(
          Colors.blue,
          target.radius - (target.ringSize * 5),
          target.seperatorSize,
          target.ringSize - target.seperatorSize,
          selected: selectedRing == 6
        ),
      ),
      Center(
        child: drawRing(
          Colors.red,
          target.radius - (target.ringSize * 6),
          target.seperatorSize,
          target.ringSize - target.seperatorSize,
          selected: selectedRing == 7
        ),
      ),
      Center(
        child: drawRing(
          Colors.red,
          target.radius - (target.ringSize * 7),
          target.seperatorSize,
          target.ringSize - target.seperatorSize,
          selected: selectedRing == 8
        ),
      ),
      Center(
        child: drawRing(
          Colors.yellow,
          target.radius - (target.ringSize * 8),
          target.seperatorSize,
          target.ringSize - target.seperatorSize,
          selected: selectedRing == 9
        ),
      ),
      Center(
        child: drawRing(
          Colors.yellow,
          target.radius - (target.ringSize * 9),
          target.seperatorSize,
          target.ringSize - target.seperatorSize,
          selected: selectedRing == 10
        ),
      ),
      Center(
        child: drawRing(
          Colors.yellow,
          target.radius - (target.ringSize * 10),
          target.seperatorSize,
          target.ringSize - target.seperatorSize,
          selected: selectedRing == 11
        ),
      ),
      Center(
        child: drawRing(
          Colors.yellow,
          target.radius - (target.ringSize * 11),
          target.seperatorSize + 1,
          target.ringSize - target.seperatorSize,
          seperatorColor: Colors.yellow,
          selected: selectedRing == 12
        ),
      ),
    ];
  }
}

class TargetWidgetSmall {
  static ConstrainedBox buildTarget(String name, {double width = 50, bool smallAimpoint = true}) {
    return ConstrainedBox(constraints: BoxConstraints.loose(Size.fromWidth(width)), child: TargetWidget(addingArrows: false, allowEdit: false, name: name, targetController: TargetController(), smallAimpoint: smallAimpoint, selectedRingChanged: (int _) {},));
  }
}

class TargetController {
  late void Function() clearArrows;
  late void Function() shareTarget;
  late void Function() fitAimpoint;
}

class TargetWidget extends StatefulWidget {
  final TargetController targetController;
  final String name;
  final bool allowEdit;
  final bool addingArrows;
  final Color backgroundColor;
  final bool smallAimpoint;
  final Function(int) selectedRingChanged;

  const TargetWidget(
      {Key? key, required this.name,
      required this.allowEdit,
      required this.addingArrows,
      required this.targetController, this.backgroundColor=Colors.transparent, this.smallAimpoint = false, required this.selectedRingChanged}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  TargetWidgetState createState() => TargetWidgetState(targetController);
}

class TargetWidgetState extends State<TargetWidget> {
  var aimpoint = AimpointLocation(magnitude: 0, negativeY: false, theta: 0);
  List<AimpointLocation> arrows = [];
  final GlobalKey _globalKey = GlobalKey();
  int selectedRing = -1;
  bool isHovering = false;

  TargetWidgetState(TargetController targetController) {
    targetController.clearArrows = clearArrows;
    targetController.fitAimpoint = fitAimpoint;
    selectedRing = selectedRing;
  }

  void clearArrows() {
    setState(() {
      arrows.clear();
    });

  }

  void fitAimpoint() {}

  void onTargetTap(
      Offset offset, BoxConstraints display, Target target, bool save) {
    if (widget.addingArrows && save == false) return;

    var newAimpoint = AimpointLocation.fromCartesian(display, offset.dx,offset.dy, target.radius);
    
    if (widget.addingArrows) {
      setState(() {
        arrows.add(newAimpoint);
      });
    } else {

      setState(() {
        aimpoint = newAimpoint;
        var currentRing = target.findSelectedRing(newAimpoint);
      if (currentRing != selectedRing) {
        selectedRing = currentRing;
        widget.selectedRingChanged(selectedRing);
        HapticFeedback.selectionClick();
      }
        
        
        if (save) {
          setState(() {
            isHovering = true;
          });
        } else {
          setState(() {
            isHovering = true;
          });
        }
      });
    }
  }

  Widget wrapGesture(
      {required Widget child,
      required BoxConstraints display,
      required Target target}) {
    
    if (widget.allowEdit == false) return child;

    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          isHovering = true;
        });
        onTargetTap(Offset(details.localPosition.dx, details.localPosition.dy), display, target, false);
      },
      onPanDown: (details) {
        setState(() {
          isHovering = true;
        });
        onTargetTap(Offset(details.localPosition.dx, details.localPosition.dy), display, target, false);
      },
      onPanEnd: (details) {
        setState(() {
          isHovering = false;
        });
      },
      onPanUpdate: (details) {
        onTargetTap(Offset(details.localPosition.dx, details.localPosition.dy), display, target, false);
      },
      onTapUp: (details) {
        onTargetTap(Offset(details.localPosition.dx, details.localPosition.dy), display, target, true);
        setState(() {
          isHovering = false;
        });
      },
      onHorizontalDragUpdate: (details) {
        onTargetTap(Offset(details.localPosition.dx, details.localPosition.dy), display, target, false);
      },
      onHorizontalDragStart: (details) {
        setState(() {
          isHovering = true;
        });
        onTargetTap(Offset(details.localPosition.dx, details.localPosition.dy), display, target, false);
      },
      onHorizontalDragCancel: () {
        setState(() {
          isHovering = false;
        });
      },

      onHorizontalDragEnd: (details) {
        setState(() {
          isHovering = false;
        });
      },

      child: child,
    );
  }

  Widget buildAimpoint(
      {required Target target,
      required Color color,
      required AimpointLocation aimpoint}) {
    var size = 10.0;
    var sepSize = 2.0;
    var ringSize = 5.0;

    if (widget.smallAimpoint) {
      size = 7;
      sepSize = 1;
      ringSize = 4;
    }
    return Center(
      child: Target.drawRing(
        color,
        size,
        sepSize,
        ringSize,
        offset: aimpoint.offset(target.radius),
      ),
    );
  }

  List<Widget> buildArrows(Target target) {
    List<Widget> arrowWidgets = [];

    for (var arrow in arrows) {
      arrowWidgets.add(
          buildAimpoint(target: target, color: Colors.red, aimpoint: arrow));
    }

    return arrowWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, display) {
        var target = Target(constraints: display);
        return wrapGesture(
          display: display,
          target: target,
          child: RepaintBoundary(
            key: _globalKey,
            child: Stack(
              children: [
                // Background color
                SizedBox.expand(
                  child: Container(
                    color: widget.backgroundColor,
                  ),
                ),

                // Target rings
                ...Target.buildTarget(target, selectedRing: selectedRing, isHovering: isHovering),

                // Arrows
                ...buildArrows(target),

                // Aimpoint
                buildAimpoint(
                  target: target,
                  color: Colors.greenAccent,
                  aimpoint: aimpoint,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CirclePainter extends CustomPainter {
  final double radius;
  final Color color;
  final Offset offset;
  final bool drawName;

  CirclePainter(
      {required this.radius,
      required this.color,
      required this.offset,
      this.drawName = false});

  @override
  void paint(Canvas canvas, Size size) {
    if (drawName) {
      TextSpan span = const TextSpan(
          style: TextStyle(color: Colors.black), text: 'Fitted Aimpoint');
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();

      canvas.drawRRect(
          RRect.fromRectAndRadius(
            Offset(offset.dx - 48, offset.dy + 13) & const Size(100, 20),
            const Radius.circular(5),
          ),
          Paint()..color = color);
      tp.paint(
        canvas,
        Offset(offset.dx - 46, offset.dy + 13),
      );

      const p1 = Offset(0, 0);

      canvas.drawLine(
        offset,
        p1,
        Paint()
          ..color = Colors.black
          ..strokeWidth = 4,
      );
    }

    canvas.drawCircle(
      offset,
      radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
