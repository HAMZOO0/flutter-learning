import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping Cart',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProductListScreen(),
      getPages: [
        GetPage(name: '/products', page: () => ProductListScreen()),
        GetPage(name: '/cart', page: () => CartScreen()),
      ],
    );
  }
}

// Model
class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

// Controller
class CartController extends GetxController {
  var cartItems = <Product>[].obs;
  var total = 0.0.obs;

  void addToCart(Product product) {
    cartItems.add(product);
    calculateTotal();
    Get.snackbar(
      'Added to Cart',
      '${product.name} added to your cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
    calculateTotal();
    Get.snackbar(
      'Removed from Cart',
      '${product.name} removed from your cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void calculateTotal() {
    total.value = cartItems.fold(0, (sum, item) => sum + item.price);
  }
}

// Product List Screen
class ProductListScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  final List<Product> products = [
    Product(
      id: 1,
      name: 'Smartphone',
      price: 599.99,
      imageUrl: 'https://via.placeholder.com/150?text=Smartphone',
    ),
    Product(
      id: 2,
      name: 'Laptop',
      price: 999.99,
      imageUrl: 'https://via.placeholder.com/150?text=Laptop',
    ),
    Product(
      id: 3,
      name: 'Headphones',
      price: 149.99,
      imageUrl: 'https://via.placeholder.com/150?text=Headphones',
    ),
    Product(
      id: 4,
      name: 'Smartwatch',
      price: 249.99,
      imageUrl: 'https://via.placeholder.com/150?text=Smartwatch',
    ),
    Product(
      id: 5,
      name: 'Tablet',
      price: 349.99,
      imageUrl: 'https://via.placeholder.com/150?text=Tablet',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Get.toNamed('/cart'),
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 8.0),
              child: Text(
                cartController.cartItems.length.toString(),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(product.imageUrl),
              title: Text(product.name),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () => cartController.addToCart(product),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Cart Screen
class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartController.cartItems[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.network(product.imageUrl),
                      title: Text(product.name),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => cartController.removeFromCart(product),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => Text(
                'Total: \$${cartController.total.value.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (cartController.cartItems.isNotEmpty) {
                  Get.defaultDialog(
                    title: 'Checkout',
                    middleText: 'Proceed with payment?',
                    textConfirm: 'Yes',
                    textCancel: 'No',
                    onConfirm: () {
                      cartController.cartItems.clear();
                      cartController.calculateTotal();
                      Get.back();
                      Get.back();
                      Get.snackbar(
                        'Success',
                        'Your order has been placed',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  );
                } else {
                  Get.snackbar(
                    'Empty Cart',
                    'Add some products first',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                child: Text('Checkout', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
