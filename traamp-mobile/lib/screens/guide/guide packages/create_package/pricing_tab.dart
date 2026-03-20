import 'package:flutter/material.dart';
import '../../../../models/guide_package_data.dart';

class PricingTab extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final GuidePackageData data;

  PricingTab(this._formKey, this.data, {super.key});

  @override
  State<PricingTab> createState() => _PricingTabState();
}

class _PricingTabState extends State<PricingTab> {
  final WidgetStateProperty<Color?> trackColor =
      WidgetStateProperty<Color?>.fromMap(<WidgetStatesConstraint, Color>{
        WidgetState.selected: Colors.green,
      });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget._formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // first form element
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Price Per Person (LKR) *",
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 15, 84, 20),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Text("LKR", style: TextStyle(fontSize: 16)),
                      border: InputBorder.none, // removes the bottom line
                      enabledBorder:
                          InputBorder.none, // also removes when not focused
                      focusedBorder: InputBorder.none,
                      hintText: "0.00",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Price cannot be empty";
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() {
                        if (!text.isNotEmpty) {
                          double price = double.parse(text.trim());
                          widget.data.price = price;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            // second element
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // minimum guests
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Min Guests *",
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 15, 84, 20),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 130,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        maxLength: 2,
                        decoration: InputDecoration(
                          border: InputBorder.none, // removes the bottom line
                          enabledBorder:
                              InputBorder.none, // also removes when not focused
                          focusedBorder: InputBorder.none,
                          hintText: "1",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Min Guests cannot be empty";
                          }
                          return null;
                        },
                        onChanged: (text) {
                          setState(() {
                            if (!text.isEmpty) {
                              double guest = double.parse(text.trim());
                              widget.data.minGuests = guest.floor();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),

                // maximum guests
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Max Guests *",
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 15, 84, 20),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 130,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        maxLength: 3,
                        decoration: InputDecoration(
                          border: InputBorder.none, // removes the bottom line
                          enabledBorder:
                              InputBorder.none, // also removes when not focused
                          focusedBorder: InputBorder.none,
                          hintText: "10",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Max Guests cannot be empty";
                          }
                          return null;
                        },
                        onChanged: (text) {
                          setState(() {
                            if (!text.isEmpty) {
                              double guest = double.parse(text.trim());
                              widget.data.maxGuests = guest.floor();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 10),

            ListTile(
              title: Text(
                "Private Tour Option",
                style: TextStyle(
                  fontSize: 18,
                  color: const Color.fromARGB(255, 15, 84, 20),
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                "Allow booking entire tour privately",
                style: TextStyle(fontSize: 15),
              ),
              trailing: Switch(
                value: widget.data.havePrivateTourOption,
                trackColor: trackColor,
                thumbColor: const WidgetStatePropertyAll<Color>(Colors.black),
                onChanged: (bool value) {
                  setState(() {
                    print(value);
                    widget.data.havePrivateTourOption = value;
                  });
                },
              ),
            ),

            SizedBox(height: 10),

            ListTile(
              title: Text(
                "Group Discount",
                style: TextStyle(
                  fontSize: 18,
                  color: const Color.fromARGB(255, 15, 84, 20),
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                "Offer discounts for larger groups",
                style: TextStyle(fontSize: 15),
              ),
              trailing: Switch(
                value: widget.data.haveGroupDiscounts,
                trackColor: trackColor,
                thumbColor: const WidgetStatePropertyAll<Color>(Colors.black),
                onChanged: (bool value) {
                  setState(() {
                    print(value);
                    widget.data.haveGroupDiscounts = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
