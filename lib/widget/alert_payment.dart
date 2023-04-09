import 'package:browenz_coffee/helpers/converter.dart';
import 'package:browenz_coffee/service/order.dart';
import 'package:browenz_coffee/widget/Form.dart';
import 'package:browenz_coffee/widget/alert.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/order_menu.dart';

const TextStyle defaultStyle = TextStyle(
  fontSize: 13,
);

class _ListOrderItem extends StatelessWidget {
  const _ListOrderItem(
      {Key? key,
      required this.name,
      required this.quantity,
      required this.price})
      : super(key: key);

  final String name;
  final int quantity, price;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: defaultStyle),
              Text(
                "Qty:$quantity",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          Text(Converter.currencyIndonesia(price * quantity),
              style: const TextStyle(
                fontSize: 13,
              )),
        ],
      ),
    );
  }
}

class AlertPayment extends StatefulWidget {
  final List<OrderMenu> menu;
  final int total;
  final OrderService service;
  final Function removeMenu;
  const AlertPayment({Key? key, required this.menu, required this.total, required this.service, required this.removeMenu})
      : super(key: key);

  @override
  State<AlertPayment> createState() => _AlertPaymentState();
}

class _AlertPaymentState extends State<AlertPayment> {
  TextEditingController change = TextEditingController(text: '0');
  TextEditingController pay = TextEditingController();
  bool isButtonPressed = false;

  void changeTextFieldValue() {
    int valuePay = 0;
    if (pay.value.text.contains('.')) {
      valuePay = int.parse(pay.value.text.split('.').join());
      change.text = '0';
    } else {
      valuePay = int.parse(pay.value.text);
      change.text = '0';
    }
    if (valuePay >= widget.total) {
      change.text = Converter.cIWithoutSymbol(valuePay - widget.total);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    change.dispose();
    pay.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => AlertDialog(
        title: const Text('Pesanan'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: widget.menu
                      .map((value) => _ListOrderItem(
                          name: value.name,
                          quantity: value.quantity,
                          price: value.price))
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: defaultStyle,
                  ),
                  Text(
                    Converter.currencyIndonesia(widget.total),
                    style: defaultStyle,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Diskon',
                    style: defaultStyle,
                  ),
                  Text(
                    '0',
                    style: defaultStyle,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bayar',
                    style: defaultStyle,
                  ),
                  SizedBox(
                    width: 100,
                    height: 18,
                    child: TextField(
                      controller: pay,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (String? value) {
                        changeTextFieldValue();
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  const BorderSide(color: Colors.black))),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyTextInputFormatter(
                          locale: 'id',
                          decimalDigits: 0,
                          symbol: '',
                        )
                      ],
                      style: const TextStyle(fontSize: 13),
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kembali',
                    style: defaultStyle,
                  ),
                  SizedBox(
                    width: 100,
                    height: 18,
                    child: TextField(
                      readOnly: true,
                      controller: change,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  const BorderSide(color: Colors.black)),
                          fillColor: Colors.black12,
                          filled: true),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: const TextStyle(fontSize: 13),
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tipe Pembayaran',
                    style: defaultStyle,
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: DropdownButtonFormField(
                        value: "tunai",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder()
                        ),
                        menuMaxHeight: 50,
                        itemHeight: 50,
                        items: ["tunai"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (String? value) {}),
                  )
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            onPressed: isButtonPressed ? null : () {
              int valuePay = 0;
              if(pay.value.text.contains('.')) {
                valuePay = int.parse(pay.value.text.split('.').join());
              }
              if(valuePay < widget.total) {
                final snackBar = alert("Bayar tidak boleh lebih kecil dari total", Colors.redAccent);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
                return;
              }
              widget.service.createOrder(widget.menu, 0, widget.total, 'cash').then((value) {
                final snackBar = alert(value[1], value[0] == 'success' ? Colors.greenAccent : Colors.redAccent);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                widget.removeMenu();
                Navigator.of(context).pop();
              });
              setState(() {
                isButtonPressed = true;
              });
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
