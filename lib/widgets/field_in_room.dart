import 'package:deskable/models/models.dart';
import 'package:deskable/screens/home/widgets/printer_x.dart';
import 'package:flutter/material.dart';

class FieldInRoom extends StatelessWidget {
  final Furniture? furniture;
  final GestureTapCallback? onTap;
  final bool edit;

  const FieldInRoom({Key? key, required this.furniture, required this.onTap, this.edit = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (furniture == null) return const Card(margin: EdgeInsets.zero);

    if (furniture!.type == EFurnitureType.empty && !edit) return Container();

    if (furniture!.type == EFurnitureType.empty && edit) return InkWell(splashColor: Colors.grey, onTap: onTap, child: Container());

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
          splashColor: Colors.grey,
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.all(2),
            child: Stack(
              children: [
                RotationTransition(
                  turns: AlwaysStoppedAnimation(furniture!.rotation / 360),
                  child: Image.asset(
                    furniture!.path(),
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.high,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                    colorBlendMode: BlendMode.modulate,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: furniture!.name.isNotEmpty
                      ? Card(
                          color: Theme.of(context).cardColor.withOpacity(0.8),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              furniture!.name,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        )
                      : Container(),
                ),
                if (false) ...[
                  CustomPaint(
                    size: Size(50, 50),
                    painter: PainterX(),
                  )
                ],
              ],
            ),
          )),
    );
  }
}
