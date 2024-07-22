import 'package:crypto_app/controllers/assets_controller.dart';
import 'package:crypto_app/services/http_service.dart';
import 'package:get/get.dart';

Future<void> registerServices() async {
  Get.put(HTTPService());
}

Future<void> registerControllers() async {
  Get.put(AssetsController());
}

String getCryptoImageURL(String name) {
  return "https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/${name.toLowerCase()}.png";
}
