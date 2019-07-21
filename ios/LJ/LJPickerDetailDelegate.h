//
//  LJPickerDetailDelegate.h 

#import <Foundation/Foundation.h>
#import <ContactsUI/ContactsUI.h>

@interface LJPickerDetailDelegate : NSObject <CNContactPickerDelegate>

@property (nonatomic, copy) void (^handler) (NSString *name, NSString *phoneNum);

@end
