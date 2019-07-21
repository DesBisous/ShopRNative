//
//  GetSectionContactsRecognition.m
//  fubaodai_rn
//
//  Created by 管理员 on 2018/8/10.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "GetSectionContactsRecognition.h"

// 联系人管理类iOS9及以后使用Contacts

#import "LJContactManager.h"
#import "LJPerson.h"

@interface GetSectionContactsRecognition ()


@property (nonatomic, copy) NSMutableArray *contactsArr;//联系人所有信息数组
@end
@implementation GetSectionContactsRecognition

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getSectionContacts:(RCTResponseSenderBlock)callback)
{
  //主要这里必须使用主线程发送,不然有可能失效
  _contactsArr = [[NSMutableArray alloc]init];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [[LJContactManager sharedInstance] accessSectionContactsComplection:^(BOOL succeed, NSArray<LJSectionPerson *> *contacts, NSArray<NSString *> *keys) {
 
      for (LJSectionPerson *sectionModel in contacts)
      {
        for (LJPerson *person in sectionModel.persons)
        {
          NSMutableDictionary *_contactsDict = [[NSMutableDictionary alloc]init];
          
          NSString *phoneNumstring;
          NSString *phoneTypestring;
          
          NSMutableArray *phoneNumArr = [[NSMutableArray alloc]init];
          
          NSMutableArray *phoneTypeArr = [[NSMutableArray alloc]init];
          
          
          for (LJPhone *model in person.phones)
          {
            [phoneNumArr addObject:model.phone];
            NSString *typeStr;
            if (person.fullName != nil) {
              if ([model.label isEqualToString:@"家庭"] ) {
                typeStr = @"1";
              }else if ([model.label isEqualToString:@"手机"]){
                typeStr = @"2";
              }else if ([model.label isEqualToString:@"工作"]){
                typeStr = @"3";
              }else if ([model.label isEqualToString:@"工作传真"]){
                typeStr = @"4";
              }else if ([model.label isEqualToString:@"家庭传真"]){
                typeStr = @"5";
              }else if ([model.label isEqualToString:@"传呼机"]){
                typeStr = @"6";
              }else{
                typeStr = @"7";
              }
            }
            
            [phoneTypeArr addObject:typeStr];
          }
          //          号码
          if (phoneNumArr.count != 0 && ![phoneNumArr isKindOfClass:[NSNull class]] && phoneNumArr != nil) {
            
            
            phoneNumstring = [phoneNumArr componentsJoinedByString:@"|"];
            [_contactsDict setObject:[NSString stringWithFormat:@"%@",phoneNumstring] forKey:@"phoneNumber"];
          }
          //          号码类型
          if (phoneTypeArr.count != 0 && ![phoneTypeArr isKindOfClass:[NSNull class]] && phoneTypeArr != nil) {
            
            phoneTypestring = [phoneTypeArr componentsJoinedByString:@"|"];
            [_contactsDict setObject:[NSString stringWithFormat:@"%@",phoneTypestring] forKey:@"phoneType"];
          }
          
          //          名字列表
          [_contactsDict setObject:[NSString stringWithFormat:@"%@",person.fullName] forKey:@"phoneName"];
          if( person.fullName == nil)
          {
            [_contactsDict setObject: @"" forKey:@"phoneName"];
          }
          
          [self.contactsArr addObject:_contactsDict];
        }
        
        
      }
      NSMutableDictionary *dic = [NSMutableDictionary dictionary];
      dic[@"contacts"] =  self.contactsArr ;
      NSString *str =[self convertToJsonData:  dic];
     
      //最终给RN的字典
      NSDictionary *dataDict = @{@"contacts":str};
      
      callback(@[[NSNull null],dataDict]);
    }];
  });
  
}

-(NSString *)convertToJsonData:(NSDictionary *)dict
{
  NSError *error;
  
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
  
  NSString *jsonString;
  
  if (!jsonData) {
    
  }else{
    
    jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
  }
  
  NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
  
  NSRange range = {0,jsonString.length};
  
  //去掉字符串中的空格
  
  [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
  
  NSRange range2 = {0,mutStr.length};
  
  //去掉字符串中的换行符
  
  [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
  
  return mutStr;
  
}
@end
