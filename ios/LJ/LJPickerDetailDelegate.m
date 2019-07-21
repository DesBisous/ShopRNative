//
//  LJPickerDetailDelegate.m

#import "LJPickerDetailDelegate.h"

@implementation LJPickerDetailDelegate 
#pragma mark - CNContactPickerDelegate

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    CNContact *contact = contactProperty.contact;
    NSString *name = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
    NSString *phoneNumber;
    if (![contactProperty.key isEqualToString:@"emailAddresses"]) {
      CNPhoneNumber *phoneValue= contactProperty.value;
      if (phoneValue.stringValue.length>0) {
        
        phoneNumber = [NSString stringWithFormat:@"%@",phoneValue.stringValue];
        
      }
    }
  
    if (name.length>0 &&phoneNumber.length>0) {
      if (self.handler)
      {
        self.handler(name, phoneNumber);
      }
    }

}

@end
