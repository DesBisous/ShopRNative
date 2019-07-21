//
//  LJAddressBookManager.h
//  LJContactManager

#import <UIKit/UIKit.h>

@class LJPerson, LJSectionPerson;

@interface LJContactManager : NSObject

+ (instancetype)sharedInstance;

/**
 请求授权

 @param completion 回调
 */
- (void)requestAddressBookAuthorization:(void (^) (BOOL authorization))completion;

/**
 选择联系人

 @param controller 控制器
 @param completcion 回调
 */
- (void)selectContactAtController:(UIViewController *)controller
                      complection:(void (^)(NSString *name, NSString *phone))completcion;

/**
 获取联系人列表（已分组的通讯录）

 @param completcion 回调
 */
- (void)accessSectionContactsComplection:(void (^)(BOOL succeed, NSArray <LJSectionPerson *> *contacts, NSArray <NSString *> *keys))completcion;

@end
