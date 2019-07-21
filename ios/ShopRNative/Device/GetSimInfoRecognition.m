//
//  GetSimInfoRecognition.m
//  fubaodai_rn
//
//  Created by 管理员 on 2018/10/24.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "GetSimInfoRecognition.h"
#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
@interface GetSimInfoRecognition()

@end

@implementation GetSimInfoRecognition


RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getSimInfo:(RCTResponseSenderBlock)callback)
{
  //主要这里必须使用主线程发送,不然有可能失效
  dispatch_async(dispatch_get_main_queue(), ^{
  
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSLog(@"info = %@", info);
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSLog(@"carrier = %@", carrier);
//    NSString *name;
//    NSString *code = [carrier mobileNetworkCode];
//    if (carrier == nil) {
//      name = @"不能识别";
//    }
    NSString *carrierName = [carrier carrierName];
    NSString *mobileCountryCode = [carrier mobileCountryCode];
    NSString *mobileNetworkCode = [carrier mobileNetworkCode];
    NSString *isoCountryCode = [carrier isoCountryCode];
    
    if (carrierName == nil) {
      carrierName = @"";
    }
    if (mobileCountryCode == nil) {
      mobileCountryCode = @"";
    }
    if (mobileNetworkCode == nil) {
      mobileNetworkCode = @"";
    }
    if (isoCountryCode == nil) {
      isoCountryCode = @"";
    }
    
    NSDictionary *dataDict = @{@"carrierName": carrierName,
                               @"mcc": mobileCountryCode,
                               @"isoCountryCode": isoCountryCode,
                               @"mnc": mobileNetworkCode};
    
    callback(@[[NSNull null],dataDict]);
    
    
  });
}
@end
