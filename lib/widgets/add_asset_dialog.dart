import 'package:crypto_app/controllers/assets_controller.dart';
import 'package:crypto_app/models/api_response.dart';
import 'package:crypto_app/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAssetDialogController extends GetxController {
  RxBool loading = false.obs;
  RxList<String> assets = <String>[].obs;
  RxString selectedAsset = "".obs;
  RxDouble assetValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HTTPService httpService = Get.find<HTTPService>();
    var responseData = await httpService.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
    currenciesListAPIResponse.data?.forEach((coin) {
      assets.add(coin.name!);
    });
    selectedAsset.value = assets.first;
    loading.value = false;
  }
}

class AddAssetDialog extends StatelessWidget {
  AddAssetDialog({super.key});
  final controller = Get.put(AddAssetDialogController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Center(
            child: Material(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).size.width * 0.80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: _buildUI(context),
          ),
        )));
  }

  Widget _buildUI(BuildContext context) {
    if (controller.loading.isTrue) {
      return const Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButton(
                    value: controller.selectedAsset.value,
                    items: controller.assets.map((asset) {
                      return DropdownMenuItem(value: asset, child: Text(asset));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedAsset.value = value;
                      }
                    }),
                TextField(
                  onChanged: (Value) {
                    controller.assetValue.value = double.tryParse(Value) ?? 0.0;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    AssetsController assetsController = Get.find();
                    assetsController.addTrackedAsset(
                      controller.selectedAsset.value,
                      controller.assetValue.value,
                    );
                    Get.back(closeOverlays: true);
                  },
                  color: Theme.of(context).colorScheme.primary,
                  child: const Text(
                    "Add Asset",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ]));
    }
  }
}
