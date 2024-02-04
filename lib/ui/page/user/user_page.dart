import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:live_video_commerce/state/user_status.dart';
import 'package:live_video_commerce/ui/page/functions_page/login_page.dart';
import 'package:live_video_commerce/ui/page/user/my_receiving_info_page.dart';
import 'package:live_video_commerce/ui/page/user/shopping_cart_page.dart';
import 'package:live_video_commerce/ui/page/user/shopping_history_page.dart';

import '../../../api/api.dart';
import '../../../entity/order/order.dart';
import '../../../entity/user.dart';

class UserPage extends StatefulWidget{
  const UserPage({super.key});

  @override
  State<StatefulWidget> createState() => UserPageState();

}

class UserPageState extends State<UserPage> with SingleTickerProviderStateMixin,UserStateMixin{
  late User? _user;
  late List<Order> orders;

  @override
  void initState() {
    super.initState();
    _fetchData();
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
      flexibleSpace: UserStatus.isLogin ? _buildLoginFlexibleSpaceBar() : _buildUnLoginFlexibleSpaceBar(),
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

  FlexibleSpaceBar _buildLoginFlexibleSpaceBar(){
    return FlexibleSpaceBar(
      title: Text(
        _user!.nickname, style: const TextStyle(color: Colors.black54),),
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
                    ClipOval(
                      child: SizedBox(
                        width: 64,
                        height: 64,
                        child: _user?.avatar == null ? Image.network(_user!.avatar):_unLoginAvatar(),
                      ),
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
                      onPressed: () async {
                        User? u = UserAPI.user!;
                        print(u.toString());
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
    );
  }

  FlexibleSpaceBar _buildUnLoginFlexibleSpaceBar(){
    return FlexibleSpaceBar(
        title: const Text(
          '您尚未登录', style: TextStyle(color: Colors.black54),),
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
                          child: _unLoginAvatar(),
                        ),
                      ),
                      onTap: () {
                        Get.to(() => const LoginPage());
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
                      child: const Text("登录"),
                      onPressed: () async {
                        Get.to(() => const LoginPage());
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
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.grey[200],
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(
          primary: false,
          shrinkWrap: true,
          children: [
            _myOrdersCard(),
            const SizedBox(height: 8,),
            _mySettingsCard(),
            const SizedBox(height: 32,),

            if(_user?.uid != null)
              Center(
                child: Text('uid: ${_user?.uid}',
                  style: const TextStyle(color: Colors.grey),),
              ),
            if(_user?.uid != null)
              Padding(padding: const EdgeInsets.only(left: 48,right: 48),child: ElevatedButton(onPressed: (){
                //todo
              }, child: const Text('退出登录'),),)


          ],
        ),
      ),

    );
  }

  Widget _myOrdersCard(){
    return Card(
      child: Column(
        children: [
          const SizedBox(height: 8,),
          Row(
            children: [
              const SizedBox(width: 16,),
              const Text('我的订单',style: TextStyle(fontSize: 16),),
              Expanded(
                child: Container(),
              ),
              TextButton(
                child: const Text('查看全部 >'),
                onPressed: () {
                  Get.to(()=>const ShoppingHistoryPage());
                  //TODO
                },
              ),
              const SizedBox(width: 6,),
            ],
          ),
          Row(
            children: [
              Expanded(child: TextButton(
                child: const Column(
                  children: [
                    Icon(Icons.payment),
                    Text('待付款'),
                  ],
                ),
                onPressed: () {
                  //TODO
                },
              ),),
              Expanded(child: TextButton(
                child: const Column(
                  children: [
                    Icon(Icons.access_time_outlined),
                    Text('待发货'),
                  ],
                ),
                onPressed: () {
                  //TODO
                },
              ),),
              Expanded(child: TextButton(
                child: const Column(
                  children: [
                    Icon(Icons.local_shipping),
                    Text('待收货'),
                  ],
                ),
                onPressed: () {
                  //TODO
                },
              ),),
              Expanded(child: TextButton(
                child: const Column(
                  children: [
                    Icon(Icons.history),
                    Text('浏览历史'),
                  ],
                ),
                onPressed: () {
                  //TODO
                },
              ),),
            ],
          ),
          const SizedBox(height: 8,)
        ],
      ),
    );
  }

  Widget _mySettingsCard(){
    return Card(
      child: Column(
        children: [
          _settingsRow(Icons.shopping_cart_outlined, '我的购物车', () {
            Get.to(() => const ShoppingCartPage());
          }),
          const Divider(height: 0,),
          _settingsRow(Icons.star_border, '我关注的直播间', () {

          }),
          const Divider(height: 0,),
          _settingsRow(Icons.location_on_outlined, '我的收货地址', () {
            Get.to(()=>const MyReceivingInfoPage());
          }),
        ],
      ),
    );
  }

  Widget _settingsRow(IconData icon,String title, VoidCallback onTap){
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            const SizedBox(width: 16,),
            Icon(icon,color: Colors.blue,),
            const SizedBox(width: 16,),
            Expanded(child: Text(title,style: const TextStyle(fontSize: 16),)),
            const SizedBox(width: 16,),
            const Icon(Icons.arrow_forward_ios,size: 18,color: Colors.grey,),
            const SizedBox(width: 16,),
          ],
        ),
      ),

    );
  }

  Widget _unLoginAvatar(){
    return Container(
      color: Colors.white,
      child: const Icon(Icons.person, size: 56, color: Colors.blue,),
    );
  }



  Future<void> _fetchData() async {
    _user = UserAPI.user;
  }

  @override
  void onUserStateChanged(User? user) {
    if (user != null && mounted) {
      setState(() {
        _user = user;
      });
    }
  }

}