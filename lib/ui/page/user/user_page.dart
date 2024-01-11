import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:live_video_commerce/ui/page/login_page.dart';
import 'package:live_video_commerce/ui/page/user/shopping_cart_page.dart';
import 'package:live_video_commerce/ui/page/user/shopping_history_page.dart';

import '../../../entity/commodity.dart';
import '../../../entity/order.dart';
import '../../../entity/user.dart';
import '../../../utils/constant_string_utils.dart';

class UserPage extends StatefulWidget{
  const UserPage({super.key});

  @override
  State<StatefulWidget> createState() => UserPageState();

}

class UserPageState extends State<UserPage> with SingleTickerProviderStateMixin{
  late final TabController _tabController;
  late User _user;
  late Map<String,Widget> _userShoppingSections;
  late List<Order> orders;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _userShoppingSections = {
      ConstantStringUtils.shoppingHistory : ShoppingHistoryPage(orderList: orders,),
      ConstantStringUtils.shoppingCart : const ShoppingCartPage(),
    };
    _tabController = TabController(length: _userShoppingSections.length, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[_myAppBar()];
        },
        body: _buildBody(),
      ),
    );
  }

  SliverAppBar _myAppBar() {
    return SliverAppBar(
      expandedHeight: 160.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          title: Text(
            _user.name, style: const TextStyle(color: Colors.black54),),
          background: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF42a6f3), Color(0xFF6ec0f8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24,),

                ///头像
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: ClipOval(
                          child: SizedBox(
                            width: 64,
                            height: 64,
                            child: Image.network(_user.avatar),
                          ),
                        ),
                        onTap: () {
                          Get.to(() => const LoginPage());
                          //TODO
                        },
                      ),
                      const SizedBox(height: 72,),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        //圆角
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          backgroundColor: MaterialStateProperty.all(Colors.blue),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: const Text("编辑资料"),
                        onPressed: () {
                          //TODO
                        },
                      ),
                      const SizedBox(height: 16,),
                    ],
                  ),
                ),
                const SizedBox(width: 24,),
              ],
            ),
          )
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            //TODO
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: _userShoppingSections.keys.map((e) => Tab(text: e,)).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _userShoppingSections.values.toList()
          ),
        ),
      ]);
  }


  Future<void> _fetchData() async {
    //TODO
    _user = User(
      name: "John Doe",
      email: "johndoe@example.com",
      password: "password123",
      phone: "1234567890",
      address: "123 Main St, City, State",
      avatar: "https://www.zwn2001.space/img/favicon.webp",
      role: "user",
      status: "active",
      createdAt: "2022-01-01 10:00:00",
      updatedAt: "2022-01-01 12:00:00",
    );

    Commodity commodity = Commodity(
      id: "1",
      name: "Test Commodity",
      anchorId: "123",
      anchorName: "Test Anchor",
      price: 99.99,
      freight: 5.0,
      specification: "Sample Specification",
      image: "https://www.zwn2001.space/img/favicon.webp",
    );

    OrderedUser orderedUser = OrderedUser(
      name: "Test User",
      phone: "1234567890",
      address: "123 Main St, City, State",
    );

    Order order = Order(
      orderId: "1",
      commodity: commodity,
      user: orderedUser,
      status: "paid",
      createdAt: "2022-01-01 10:00:00",
      payAt: "2022-01-01 10:00:00",
      shipAt: "2022-01-01 10:00:00",
      completeAt: "2022-01-01 10:00:00",
      totalPrice: 104.99,
      quantity: 1,
    );

    orders = [order,order,order,order,order,order,order,order,order,order,order,order,order];
  }

}