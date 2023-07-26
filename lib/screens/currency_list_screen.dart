import 'package:currency_calculator/model/currency_model.dart';
import 'package:flutter/material.dart';
import '../service/currency_exchange_repository.dart';




class CurrencyList extends StatefulWidget {
  const CurrencyList({Key? key}) : super(key: key);

  @override
  State<CurrencyList> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  bool isSearching = false;
  List<Currency> currencies = [];
  List<Currency> filteredCurrencies = [];
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final CurrencyRepository _currencyConverterService = CurrencyRepository();

  @override
  void initState() {
    super.initState();
    fetchCurrencies(); // Fetch currencies list when the screen is initialized
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> fetchCurrencies() async {
    try {
      currencies = await _currencyConverterService.fetchCurrenciesList();
      setState(() {
        filteredCurrencies = currencies;
      });
    } catch (e) {
      print('Error fetching currencies: $e');
    }
  }

  void filterCurrencies() {
    if (searchQuery.isEmpty) {
      setState(() {
        filteredCurrencies = List.from(currencies);
      });
    } else {
      setState(() {
        filteredCurrencies = currencies
            .where(
              (currency) => currency.code.toLowerCase().contains(searchQuery.toLowerCase()) ||
              currency.name.toLowerCase().contains(searchQuery.toLowerCase()),
        ).toList();
      });
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
              filterCurrencies();
            });
          },
          decoration: const InputDecoration(
            hintText: 'Search',
          ),
        ) : const Text('List of currencies'),
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
                  filterCurrencies();
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
        itemCount: filteredCurrencies.length,
        itemBuilder: (context, int index) {
          return CustomItem(
            currency: filteredCurrencies[index],
          );
        },
      ),
    );
  }
}

class CustomItem extends StatelessWidget {
  final Currency currency;

  const CustomItem({
    Key? key,
    required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(
          context,
          currency.code,
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
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currency.code,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  currency.name,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
