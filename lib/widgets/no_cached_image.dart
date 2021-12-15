import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NonCacheNetworkImage extends StatelessWidget {
  const NonCacheNetworkImage(this.imageUrl, {Key? key}) : super(key: key);
  final String imageUrl;

  Future<Uint8List> getImageBytes() async {
    if (imageUrl.contains('local')) {
      await get(Uri.parse(imageUrl));
    }
    Response response = await get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: getImageBytes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          try {
            Image image = Image.memory(
              snapshot.data!,
              height: 50,
            );
            return image;
          } catch (_) {
            return Image.network(imageUrl);
          }
        }
        return const SizedBox(
          width: 80,
          height: 80,
          child: Text("NO DATA"),
        );
      },
    );
  }
}
