import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarBooking extends StatelessWidget {
  final String url;

  const AvatarBooking({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: CircleAvatar(
        radius: 10,
        child: url != ''
            ? CachedNetworkImage(
                imageUrl: url,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black87.withOpacity(0.5), width: 0.5),
                    image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(
                  Icons.account_circle,
                  size: 20,
                  color: Colors.white,
                ),
              )
            : Icon(
                Icons.account_circle,
                size: 20,
                color: Colors.white,
              ),
      ),
    );
  }
}
