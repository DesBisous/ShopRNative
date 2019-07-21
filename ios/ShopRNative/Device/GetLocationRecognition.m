//
//  GetLocationRecognition.m
//  fubaodai_rn
//
//  Created by 管理员 on 2018/10/24.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "GetLocationRecognition.h"
#import <CoreLocation/CLLocationManager.h>

@interface GetLocationRecognition()

@end

@implementation GetLocationRecognition


RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getLocation:(RCTResponseSenderBlock)callback)
{
  //主要这里必须使用主线程发送,不然有可能失效
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
      //定位功能可用回调给React Native
      NSDictionary *dataDict = @{@"getLocation":@1};

      // 利用RCTResponseSenderBlock回调数据给React Native
      callback(@[[NSNull null],dataDict]);
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
      
      //定位不能用回调给React Native
      NSDictionary *dataDict = @{@"getLocation":@0};
      
      // 利用RCTResponseSenderBlock回调数据给React Native
      callback(@[[NSNull null],dataDict]);
    }
  });
}


@end
