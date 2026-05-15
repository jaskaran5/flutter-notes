import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_boilerplate_flutter/config/helper.dart';
import 'package:riverpod_boilerplate_flutter/feature/common_widgets/app_text.dart';
import 'package:riverpod_boilerplate_flutter/feature/home/data/models/preferance_model.dart';

import '../provider/home_provider.dart';

class HomePageView extends ConsumerWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final getPreference = ref.watch(getPreferenceProvider);

    return  Scaffold(
      appBar: AppBar(title: const AppText(text: "Preferences"),centerTitle: true,),
      body: SafeArea(
          child: getPreference.when(
              data:(data)=> PreferenceList(list: data,),
              error:(e,s)=> Center(
                child: AppText(text: e.toString()),
              ),
              loading:()=> const Center(
                child: CircularProgressIndicator(
                  color: AppColor.primary,
                ),
              ))),

    );
  }
}
class PreferenceList extends ConsumerWidget {
  final List<PreferencesModel> list;
  const PreferenceList({super.key,required this.list});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    if(list.isEmpty){
      return const Center(
        child: AppText(text: "No Data Found"),
      );
    }else{
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          var data = list[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 10),
          child: ListTile(
            tileColor: Colors.cyan.withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

            title: AppText(text: data.title??"",textSize: 18,),
             subtitle: AppText(text: data.createdAt??""),
          ),
        );
      },);
    }
  }
}

