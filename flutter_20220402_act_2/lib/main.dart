import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ACT8',
      home: ProductPage(),
    );
  }
}

enum ProductSortType {
  name,
  price,
}

//This is the default sort type when the app is run
final productSortTypeProvider =
    StateProvider<ProductSortType>((ref) => ProductSortType.name);

class Product {
  Product({required this.name, required this.price});

  final String name;
  final double price;
}

final _products = [
  Product(name: "Spagetti", price: 10),
  Product(name: "Indomie", price: 6),
  Product(name: "Fried Yam", price: 9),
  Product(name: "Beans", price: 10),
  Product(name: "Red Chicken feet", price: 2),
];

class ProductPage extends ConsumerWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final productsProvider = ref.watch(futureProductsProvider);

    AppBar(
      title: const Text("ACT8"),
      actions: [
        DropdownButton<ProductSortType>(
            dropdownColor: const Color.fromARGB(255, 255, 131, 86),
            value: ref.watch(productSortTypeProvider),
            items: const [
              DropdownMenuItem(
                value: ProductSortType.name,
                child: Icon(Icons.sort_by_alpha),
              ),
              DropdownMenuItem(
                value: ProductSortType.price,
                child: Icon(Icons.sort),
              ),
            ],
            onChanged: (value) =>
                ref.watch(productSortTypeProvider.notifier).state = value!),
      ],
    );

    productsProvider.when(
      data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Card(
                color: const Color.fromARGB(255, 106, 255, 136),
                elevation: 3,
                child: ListTile(
                  title: Text(products[index].name,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 122, 122),
                          fontSize: 15)),
                  subtitle: Text("${products[index].price}",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 44, 216),
                          fontSize: 15)),
                ),
              ),
            );
          }),
      error: (err, stack) => Text("Error: $err",
          style: const TextStyle(
              color: Color.fromARGB(255, 26, 255, 72), fontSize: 15)),
      loading: () => const Center(
          child: CircularProgressIndicator(
        color: Colors.white,
      )),
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text("Lista de productos sencilla"),
          actions: [
            DropdownButton<ProductSortType>(
                dropdownColor: const Color.fromARGB(255, 255, 170, 232),
                value: ref.watch(productSortTypeProvider),
                items: const [
                  DropdownMenuItem(
                    value: ProductSortType.name,
                    child: Icon(Icons.sort_by_alpha),
                  ),
                  DropdownMenuItem(
                    value: ProductSortType.price,
                    child: Icon(Icons.sort),
                  ),
                ],
                onChanged: (value) =>
                    ref.watch(productSortTypeProvider.notifier).state = value!),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 3, 244, 184),
        body: Container(
          child: productsProvider.when(
            data: (products) => ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Card(
                      color: const Color.fromARGB(255, 0, 60, 239),
                      elevation: 3,
                      child: ListTile(
                        title: Text(products[index].name,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 15)),
                        subtitle: Text("${products[index].price}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20)),
                      ),
                    ),
                  );
                }),
            error: (err, stack) => Text("Error: $err",
                style: const TextStyle(
                    color: Color.fromARGB(255, 235, 52, 52), fontSize: 20)),
            loading: () => const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )),
          ),
        ));
  }
}

final futureProductsProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(seconds: 3));
  final sortType = ref.watch(productSortTypeProvider);
  switch (sortType) {
    case ProductSortType.name:
      _products.sort((a, b) => a.name.compareTo(b.name));
      break;
    case ProductSortType.price:
      _products.sort((a, b) => a.price.compareTo(b.price));
  }
  return _products;
});
