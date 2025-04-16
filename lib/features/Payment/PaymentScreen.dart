import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'Credit Card'; // Default payment method
  final Color selectedColor = Color(0xFF8C4931);
  final Color unselectedColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F0EC),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Payment'),
        backgroundColor: Color(0xFFF8F0EC),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Product Details',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Product Name: Premium'),
              subtitle: Text('Price: \$99.99'),
            ),
            Divider(),
            SizedBox(height: 20.0),
            Text(
              'Payment Method',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: Row(
                children: <Widget>[
                  Image.network(
                    "https://i.pinimg.com/474x/48/40/de/4840deeea4afad677728525d165405d0.jpg",
                    width: 50.0,
                    height: 50.0,
                  ),
                  SizedBox(width: 8.0),
                  Text('Credit Card'),
                ],
              ),
              value: 'Credit Card',
              groupValue: _selectedPaymentMethod,
              onChanged: (String? value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              activeColor: selectedColor,
              tileColor: _selectedPaymentMethod == 'Credit Card'
                  ? null
                  : unselectedColor
                  .withOpacity(0.1), // Optional: change tile color
            ),
            if (_selectedPaymentMethod == 'Credit Card')
              _buildCreditCardFields(),
            RadioListTile<String>(
              title: Row(
                children: <Widget>[
                  Image.network(
                    'https://i.pinimg.com/474x/67/54/b8/6754b8049f56d673d01abd9e46175a29.jpg',
                    width: 50.0,
                    height: 50.0,
                  ),
                  SizedBox(width: 8.0),
                  Text('Cash on Delivery'),
                ],
              ),
              value: 'Cash on Delivery',
              groupValue: _selectedPaymentMethod,
              onChanged: (String? value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              activeColor: selectedColor,
              tileColor: _selectedPaymentMethod == 'Cash on Delivery'
                  ? null
                  : unselectedColor
                  .withOpacity(0.02), // Optional: change tile color
            ),
            SizedBox(height: 30.0),
            Text(
              'Order Summary',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total:'),
                Text('\$99.99'),
              ],
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8C4931),
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  textStyle: TextStyle(fontSize: 18.0),
                ),
                child: Text(
                  'Confirm Payment',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardFields() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Expiry Date (MM/YY)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}