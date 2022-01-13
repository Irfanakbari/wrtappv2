import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:wrtappv2/Screen/detailpage.dart';

class NewerKomik extends StatefulWidget {
  final List title;
  final List genre;
  final List image;
  final List year;
  final List url;
  const NewerKomik(
      {Key? key,
      required this.title,
      required this.genre,
      required this.image,
      required this.year,
      required this.url})
      : super(key: key);

  @override
  _NewerKomikState createState() => _NewerKomikState();
}

class _NewerKomikState extends State<NewerKomik> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: Get.width,
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Terbaru",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            const Divider(
              height: 5,
            ),
            const SizedBox(height: 10),
            // gridview
            SizedBox(
                width: Get.width,
                child: Column(
                  children: [
                    for (var i = 0; i < widget.title.length; i++)
                      InkWell(
                        onTap: () {
                          Get.to(() => DetailPage(
                                url: widget.url[i],
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Image.network(
                                widget.image[i],
                                fit: BoxFit.cover,
                                height: 85,
                                width: 65,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.title[i],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    Text(widget.genre[i],
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey)),
                                    const SizedBox(height: 5),
                                    Text(widget.year[i],
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ))
          ]),
        ),
      ),
    );
  }
}
