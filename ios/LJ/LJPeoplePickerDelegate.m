//
//  LJPeoplePickerDelegate.m
//  LJContactManager 

#import "LJPeoplePickerDelegate.h"

@implementation LJPeoplePickerDelegate

#pragma mark - CNContactPickerDelegate

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact;
{
    [picker dismissViewControllerAnimated:YES completion:^{ 
    }];
}

#pragma mark - CNContactViewControllerDelegate

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(CNContact *)contact
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

@end
