import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class CarouselC extends GetxController {
  RxList imgList = [].obs;
  RxList title = [].obs;
  RxList slug = [].obs;
  RxList link = [].obs;

  @override
  void onInit() {
    getSlide();
    super.onInit();
  }

  // Get data slider homepage
  void getSlide() async {
    var url = "https://api.wrt.my.id/api/slider";
    await http.get(Uri.parse(url)).then((response) {
      imgList.clear();
      var data = json.decode(response.body);
      for (var i = 0; i < data.length; i++) {
        imgList.add(data['data'][i]['image']);
        title.add(data['data'][i]['title']);
        slug.add(data['data'][i]['slug']);
        link.add(data['data'][i]['link']);
      }
    });
  }
}
