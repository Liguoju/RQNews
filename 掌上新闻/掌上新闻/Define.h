//
//  Define.h
//  掌上新闻
//
//  Created by qianfeng on 15/9/22.
//  Copyright © 2015年 XieRenQiang. All rights reserved.
//

#ifndef Define_h
#define Define_h
//首页
#define kFirstPage_url @"http://api.m.jiemian.com/cate/main.json?page=%ld&version=2.2.0&"
//视频
#define kVideo_url @"http://api.m.jiemian.com/video/timeline.json?page=%ld&version=2.2.0&"

//普通
#define kcommon_url @"http://api.m.jiemian.com/article/cate/%@.json?page=%ld&version=2.2.0&"

#define kvideo  @"http://api.m.jiemian.com/video/%@.json?version=2.2.0&"
//详情
#define kdetailUrl  @"http://api.m.jiemian.com/article/%@.json?version=2.2.0&"
//传入id
#define kshangye  @"117"//商业    117
#define ktianxia  @"118"//天下    118
#define kzhongguo @"260"//中国    260
#define kyule     @"203"//娱乐    203
#define ktiyu     @"202"//体育    202
#define kshishang @"183"//时尚    183
#define kwailou   @"119"//歪楼    119
#define kkeji     @"123"//科技    123
#define kqiche    @"138"//汽车    138
#define kdichan   @"121"//地产    121
#define ktouzi    @"142"//投资    142
#define kzhengwu  @"120"//正午    120
#define kreping   @"124"//热评    124
#define kjirong   @"137"//金融    137
#define kxiaofei  @"139"//消费    139
#define kkuaixun  @"141"//快讯    141
#define kquanbu   @"152"//全部    152
#define ktupian   @"158"//图片    158
#define kredu     @"181"//热读    181
#define kyinxiao  @"182"//营销    182
#define kzhichang @"201"//职场    201
#define knengyuan @"259"//能源    259
#define kjunshi   @"293"//军事    293
#define kyouxi    @"294"//游戏    294
#define klvxing   @"313"//旅行    313
#define kshizhi   @"322"//市值    322
#define kjmedia   @"122"//JMedia 122
#define klead     @"140"//LEAD   140

//城市代码
#define kareaNum @"http://api.k780.com:88/?app=weather.city&format=xml "
//城市查询

//http://apistore.baidu.com/microservice/cityinfo
//天气接口
#define kWeather @"http://apistore.baidu.com/microservice/weather?cityname=%@"

//http://apistore.baidu.com/microservice/cityinfo
#endif /* Define_h */
