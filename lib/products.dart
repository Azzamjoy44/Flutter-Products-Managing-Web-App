import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'manage_products.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Page'),
        centerTitle: false,  // Ensure the title is always aligned to the left
        actions: [
          // TextButton in the AppBar for navigating to the manage products page
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageProductsPage()),
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Colors.purple.withOpacity(0.85),  // Default color when not interacting
              ),
              overlayColor: WidgetStateProperty.all(
                Colors.purple.withOpacity(1.0),  // Hover or press effect (slightly darker)
              ),  // Optional: background color
            ),
            child: Text(
              'Manage Products',
              style: TextStyle(
                color: Colors.white, // White text color
                fontSize: 18,         // Increase font size
                fontWeight: FontWeight.bold,  // Make text bold
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(

            // Using StreamBuilder to fetch live data from Firestore
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Products').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var products = snapshot.data!.docs; // Get the list of products from Firestore

                // // Calculate the number of columns for the grid based on screen width
                double screenWidth = MediaQuery.of(context).size.width;
                int crossAxisCount = screenWidth < 600 ? 2 : 4; // 2 columns for smaller screens, 4 for larger screens

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount, // Number of columns in grid
                    mainAxisSpacing: 20,            // Space between rows
                    crossAxisSpacing: 20,           // Space between columns
                    childAspectRatio: 0.8,          // Aspect ratio for each item in the grid (controls item height/width ratio)
                  ),

                  itemCount: products.length, // Number of items in the grid is equal to the number of products
                  itemBuilder: (context, index) {
                    var product = products[index];  // Get a product from the list
                    var name = product['Name'];     // Get the product name
                    var price = product['Price'];   // Get the product price
                    var imageUrl = product['ImageUrl']; // Get the image URL for the product

                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            // Wrap Image in Expanded to avoid overflow
                            Expanded(
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover, // Ensure the image covers the container's space
                              ),
                            ),
                            SizedBox(height: 8),
                            // Wrap Text in Expanded to handle overflow (for long product names)
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis, // Handle overflow in text
                              ),
                            ),
                            // Display product price below the product name
                            Text(
                              '$price lei',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
