import 'package:flutter/material.dart';

final List<String> currencies = [
  'COP',
  'USD',
  'AUD',
  'CAD',
  'EUR',
  'ARG',
  'CLP',
  'DKK',
  'JPY',
  'GBP',
];
bool isSearching = false;

class CurrencyList extends StatefulWidget {
  const CurrencyList({super.key});

  @override
  State<CurrencyList> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  List<String> filteredItems = [];
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(currencies);
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void filterItems() {
    if (searchQuery.isEmpty) {
      filteredItems = List.from(currencies);
    } else {
      filteredItems = currencies
          .where(
              (item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        title: isSearching
            ? TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    filterItems();
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search',
                ),
              )
            : const Text('List of currencies'),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.cancel : Icons.search,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (isSearching) {
                  searchFocusNode.requestFocus();
                } else {
                  searchFocusNode.unfocus();
                  searchController.clear();
                  filterItems();
                }
              });
            },
          ),
        ],
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, int index) {
          return CustomItem(
            filteredItems: filteredItems,
            index: index,
          );
        },
      ),
    );
  }
}

class CustomItem extends StatelessWidget {
  const CustomItem(
      {super.key, required this.filteredItems, required this.index});

  final List<String> filteredItems;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(
          context,
          filteredItems[index],
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.flag_circle_sharp,
              size: 40,
            ),
            Text(
              filteredItems[index],
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
