import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/database.dart';
import '../../services/shared_prefences.dart';
import '../../utils/app_widget.dart';
import '../detail/detail_screen.dart';
import '../search/food_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool icecream = false, pizza = false, salad = false, buger = false;

  Stream? foodItemStream;
  String? name;

  ontheload() async {
    foodItemStream = DatabaseMethods().getFoodItemByCategory("Pizza");
    name = await SharedPreferenceHelper().getUserName();

    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget allItems() {
    return StreamBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(
                            detail: ds["Detail"],
                            image: ds["Image"],
                            price: ds["Price"],
                            name: ds["Name"],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  ds['Image'],
                                  height: 150.0,
                                  width: 150.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(ds['Name'],
                                  style: AppWidget.LightTextFieldStyle()),
                              const SizedBox(height: 5.0),
                              Text("Ẩm thực Quảng Bình",
                                  style: AppWidget.SemiBoldTextFieldStyle()),
                              const SizedBox(height: 5.0),
                              Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                ds['Price'] + "\VNĐ"  ,
                                style: AppWidget.LightTextFieldStyle(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
            : const CircularProgressIndicator();
      },
      stream: foodItemStream,
    );
  }

  Widget allItemsVertical() {
    return StreamBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Details(
                        detail: ds["Detail"],
                        image: ds["Image"],
                        price: ds["Price"],
                        name: ds["Name"],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          ds["Image"],
                          height: 100.0,
                          width: 100.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ds['Name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              ds['Detail'],
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "\VNĐ" + ds['Price'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
            : Center(child: CircularProgressIndicator());
      },
      stream: foodItemStream,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name != null ? 'Hello $name' : 'Hello Guest',
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>const FoodSearchScreen()),
                        );
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    "ẨM THỰC QUẢNG BÌNH",
                    textStyle: AppWidget.HeadlinextFieldStyle(),
                    speed: const Duration(milliseconds: 200),
                  ),
                ],
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    "Chào mừng mọi người đến với ẩm thực đặc sản Quảng Bình ",
                    textStyle: AppWidget.LightTextFieldStyle(),
                    speed: const Duration(milliseconds: 200),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  margin: const EdgeInsets.only(right: 20.0),
                  child: showItem()),
              const SizedBox(
                height: 20.0,
              ),
              Container(height: 270, child: allItems()),
              const SizedBox(
                height: 5.0,
              ),
              allItemsVertical(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            pizza = true;
            icecream = false;
            salad = false;
            buger = false;
            foodItemStream = DatabaseMethods().getFoodItemByCategory("Pizza");
            setState(() {});
          },
          child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: pizza ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/images/pizza.png",
                    height: 40.0,
                    width: 40.0,
                    fit: BoxFit.cover,
                    color: pizza ? Colors.white : Colors.black,
                  ))),
        ),
        GestureDetector(
          onTap: () async {
            pizza = false;
            icecream = true;
            salad = false;
            buger = false;
            foodItemStream =
                DatabaseMethods().getFoodItemByCategory("Ice-cream");

            setState(() {});
          },
          child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: icecream ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/images/ice-cream.png",
                    height: 40.0,
                    width: 40.0,
                    fit: BoxFit.cover,
                    color: icecream ? Colors.white : Colors.black,
                  ))),
        ),
        GestureDetector(
          onTap: () async {
            pizza = false;
            icecream = false;
            salad = true;
            buger = false;
            foodItemStream = DatabaseMethods().getFoodItemByCategory("Salad");

            setState(() {});
          },
          child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: salad ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/images/salad.png",
                    height: 40.0,
                    width: 40.0,
                    fit: BoxFit.cover,
                    color: salad ? Colors.white : Colors.black,
                  ))),
        ),
        GestureDetector(
          onTap: () async {
            pizza = false;
            icecream = false;
            salad = false;
            buger = true;
            foodItemStream = DatabaseMethods().getFoodItemByCategory("Burger");

            setState(() {});
          },
          child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: buger ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/images/burger.png",
                    height: 40.0,
                    width: 40.0,
                    fit: BoxFit.cover,
                    color: buger ? Colors.white : Colors.black,
                  ))),
        )
      ],
    );
  }
}
