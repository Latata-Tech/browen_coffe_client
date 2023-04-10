import 'package:flutter/material.dart';

import '../model/category.dart';

List<String> categories = <String>['Semua', 'Coffee', 'Tea'];

class ChipCategory extends StatelessWidget {
  final Future<List<Category>>? categories;
  final Function filterMenu;
  final int selectedChip;
  const ChipCategory({Key? key, required this.categories, required this.filterMenu, required this.selectedChip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 700,
      height: 83,
      decoration: BoxDecoration(
          color: const Color(0XFFD9D9D9),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kategori'),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder(
              future: categories,
              builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
                if(snapshot.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: FilterChip(
                          label: Text(snapshot.data![index].name),
                          backgroundColor: Colors.white,
                          onSelected: (bool value) {
                            filterMenu(snapshot.data![index].id, index);
                          },
                          selected: snapshot.data![index].id == selectedChip,
                          selectedColor: Colors.lightBlue,
                          labelStyle: TextStyle(
                              color: snapshot.data![index].id == selectedChip  ? Colors.white : Colors.black),
                        ),
                      );
                    },
                  );
                } else if(snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),
          )
        ],
      ),
    );;
  }
}
