//
//  GetPermissionsRecognition.m
//  fubaodai_rn
//
//  Created by lightblue on 2018/8/8.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "AppDelegate.h"

// 联系人管理类
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

#import "GetPermissionsRecognition.h"

@interface GetPermissionsRecognition()
 
@end

@implementation GetPermissionsRecognition


RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getPermissions:(RCTResponseSenderBlock)callback)
{
  //主要这里必须使用主线程发送,不然有可能失效
  dispatch_async(dispatch_get_main_queue(), ^{
    [self requestAddressBookAuthorization:^(BOOL authorization) {
      if (authorization)
      {
        // 准备回调给React Native的数据
        NSDictionary *dataDict = @{@"getPermissions":@1};
        
        // 利用RCTResponseSenderBlock回调数据给React Native
        callback(@[[NSNull null],dataDict]);
      }
      else
      {
        // 准备回调给React Native的数据
        NSDictionary *dataDict = @{@"getPermissions":@0};
        
        // 利用RCTResponseSenderBlock回调数据给React Native
        callback(@[[NSNull null],dataDict]);
      }
    }];
  });
}

- (void)requestAddressBookAuthorization:(void (^) (BOOL authorization))completion
{
  __block BOOL authorization;
 
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if (status == CNAuthorizationStatusNotDetermined)
    {
//      [self _authorizationAddressBook:^(BOOL succeed) {
//        authorization = succeed;
//      }];
      authorization = YES;
    }
    else if (status == CNAuthorizationStatusAuthorized)
    {
      authorization = YES;
    }
    else
    {
      authorization = NO;
    }
    if (completion)
    {
      completion(authorization);
    }
}

- (void)_authorizationAddressBook:(void (^) (BOOL succeed))completion
{
    CNContactStore *store = [CNContactStore new];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
      if (completion)
      {
        completion(granted);
      }
    }];
}

@end
