import 'package:coucou_v2/utils/place_service%20copy.dart';
import 'package:coucou_v2/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AddressSearch extends SearchDelegate<Suggestion> {
  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  final sessionToken;
  PlaceApiProvider? apiClient;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'clear'.tr,
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'back'.tr,
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        // Get.back();
        context.pop();
        // Get.back(result: area != null?area:null);
        // Get.to(()=>const CreateHomeText());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var nulla;
    return nulla;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == ""
          ? null
          : apiClient!.fetchSuggestions(
              query, Localizations.localeOf(context).languageCode),
      builder: (context, AsyncSnapshot<List<Suggestion>> snapshot) => query ==
              ''
          ? Container(
              padding: const EdgeInsets.all(16.0),
              child: Text('enter_your_addr'.tr),
            )
          : snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text((snapshot.data![index]).description),
                    onTap: () {
                      var area = snapshot.data![index].description;
                      close(context, snapshot.data![index]);
                    },
                  ),
                  itemCount: snapshot.data!.length,
                )
              : Center(
                  child: Container(
                      child: Text(
                  '${"loading".tr}...',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 1.8.t),
                ))),
    );
  }
}
