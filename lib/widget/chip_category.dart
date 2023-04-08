import 'package:flutter/material.dart';

List<String> categories = <String>['Semua', 'Coffee', 'Tea'];

class ChipCategory extends StatelessWidget {
  const ChipCategory({Key? key}) : super(key: key);

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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(categories[index]),
                    backgroundColor: Colors.white,
                    onSelected: (bool value) {},
                    selected: index == 0,
                    selectedColor: Colors.lightBlue,
                    labelStyle: TextStyle(
                        color: index == 0 ? Colors.white : Colors.black),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );;
  }
}
