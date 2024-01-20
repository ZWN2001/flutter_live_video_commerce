import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ConstantStringUtils{
  static const String appTitle = '带货直播机';
  static const ClassicHeader classicHeader = ClassicHeader(
    idleText: '下拉刷新',
    refreshingText: '正在刷新',
    failedText: '刷新失败',
    releaseText: '松开刷新',
    completeText: '刷新成功',
  );

  static const  ClassicFooter classicFooter = ClassicFooter(
    loadingText: '正在加载',
    noDataText: '没有更多数据了',
    failedText: '加载失败',
    idleText: '上拉加载更多',
    canLoadingText: '释放加载下一页',
  );

  static const String shoppingCart = '购物车';
  static const String shoppingHistory = '购物历史';

  static const Map<int,String> orderStatus = {
    0: '确认订单',
    1 : '订单待付款',
    2 : '订单待发货',
    3 : '订单待收货',
    4 : '订单已完成',
    5 : '订单已取消',
  };
}