//
//  LJPeoplePickerDelegate.h
//  LJContactManager

#import <Foundation/Foundation.h>
#import <ContactsUI/ContactsUI.h>

@interface LJPeoplePickerDelegate : NSObject < CNContactPickerDelegate, CNContactViewControllerDelegate>

@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, weak) UIViewController *controller;

@end
