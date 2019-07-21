//
//  LJAddressBookManager.m
//  LJContactManager

#import "AppDelegate.h"

#import "LJContactManager.h"
#import "LJPerson.h"
#import "LJPeoplePickerDelegate.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "LJPickerDetailDelegate.h"


@interface LJContactManager () <CNContactViewControllerDelegate>


@property (nonatomic,strong)UIViewController *showViewController;     // 本类视图控制器
@property (nonatomic, copy) void (^handler) (NSString *, NSString *);
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, copy) NSArray *keys;
@property (nonatomic, strong) LJPeoplePickerDelegate *pickerDelegate;
@property (nonatomic, strong) LJPickerDetailDelegate *pickerDetailDelegate;
@end

@implementation LJContactManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
      
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static id shared_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_instance = [[self alloc] init];
    });
    return shared_instance;
}

- (NSArray *)keys
{
    if (!_keys)
    {
        _keys = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
                  CNContactPhoneNumbersKey,
                  CNContactOrganizationNameKey,
                  CNContactDepartmentNameKey,
                  CNContactJobTitleKey,
                  CNContactNoteKey,
                  CNContactPhoneticGivenNameKey,
                  CNContactPhoneticFamilyNameKey,
                  CNContactPhoneticMiddleNameKey,
                  CNContactImageDataKey,
                  CNContactThumbnailImageDataKey,
                  CNContactEmailAddressesKey,
                  CNContactPostalAddressesKey,
                  CNContactBirthdayKey,
                  CNContactNonGregorianBirthdayKey,
                  CNContactInstantMessageAddressesKey,
                  CNContactSocialProfilesKey,
                  CNContactRelationsKey,
                  CNContactUrlAddressesKey];

    }
    return _keys;
}

- (LJPeoplePickerDelegate *)pickerDelegate
{
    if (!_pickerDelegate)
    {
        _pickerDelegate = [LJPeoplePickerDelegate new];
    }
    return _pickerDelegate;
}

- (LJPickerDetailDelegate *)pickerDetailDelegate
{
    if (!_pickerDetailDelegate)
    {
        _pickerDetailDelegate = [LJPickerDetailDelegate new];
        __weak typeof(self) weakSelf = self;
        _pickerDetailDelegate.handler = ^(NSString *name, NSString *phoneNum) {
            weakSelf.handler(name, phoneNum);
        };
    }
    return _pickerDetailDelegate;
}

#pragma mark - Public

- (void)selectContactAtController:(UIViewController *)controller
                      complection:(void (^)(NSString *, NSString *))completcion
{
    self.isAdd = NO;
    [self _presentFromController:controller];
    
    self.handler = ^(NSString *name, NSString *phone){
        
        if (completcion)
        {
            completcion(name, phone);
        }
    };
}

- (void)createNewContactWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller
{
    CNMutableContact *contact = [[CNMutableContact alloc] init];
        CNLabeledValue *labelValue = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile
                                                                     value:[CNPhoneNumber phoneNumberWithStringValue:phoneNum]];
    contact.phoneNumbers = @[labelValue];
    CNContactViewController *contactController = [CNContactViewController viewControllerForNewContact:contact];
    contactController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:contactController];
    [controller presentViewController:nav animated:YES completion:nil];
}

- (void)accessSectionContactsComplection:(void (^)(BOOL, NSArray<LJSectionPerson *> *, NSArray<NSString *> *))completcion
{
    [self requestAddressBookAuthorization:^(BOOL authorization) {
        
        if (authorization)
        {
            [self _asynAccessContactStoreWithSort:YES completcion:^(NSArray *datas, NSArray *keys) {
                    
                if (completcion)
                {
                    completcion(YES, datas, keys);
                }
            }];
        }
        else
        {
            if (completcion)
            {
                completcion(NO, nil, nil);
            }
        }
    }];
}

#pragma mark - CNContactViewControllerDelegate

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

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

- (void)requestAddressBookAuthorization:(void (^) (BOOL authorization))completion
{
    __block BOOL authorization;
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];

    if (status == CNAuthorizationStatusNotDetermined)
    {
        [self _authorizationAddressBook:^(BOOL succeed) {
            authorization = succeed;
        }];
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

- (void)_presentFromController:(UIViewController *)controller
{
    CNContactPickerViewController *pc = [[CNContactPickerViewController alloc] init];
    if (self.isAdd)
    {
        pc.delegate = self.pickerDelegate;
    }
    else
    {
        pc.delegate = self.pickerDetailDelegate;
    }
  
    pc.displayedPropertyKeys = @[CNContactPhoneNumbersKey];

    [self requestAddressBookAuthorization:^(BOOL authorization) {
        if (authorization)
        {
          
            [controller presentViewController:pc animated:YES completion:nil];
          
        }
        else
        {
//            [self _showAlert];
        }
    }];
}

- (void)_showAlert
{
  UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"请前往设置->富宝袋->允许访问通讯录" message:nil preferredStyle:UIAlertControllerStyleAlert];
  [[self getShowViewController] presentViewController:alertC animated:YES completion:nil];
  UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    [[self getShowViewController] dismissViewControllerAnimated:YES completion:nil];
  }];
  [alertC addAction:action];
}

- (void)_asynAccessContactStoreWithSort:(BOOL)isSort completcion:(void (^)(NSArray *, NSArray *))completcion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *datas = [NSMutableArray array];
        CNContactStore *contactStore = [CNContactStore new];
    
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:self.keys];
        
        [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            
            LJPerson *person = [[LJPerson alloc] initWithCNContact:contact];
            [datas addObject:person];
            
        }];
        
        if (!isSort)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(datas, nil);
                }
                
            });
            
            return ;
        }
        
        [self _sortNameWithDatas:datas completcion:^(NSArray *persons, NSArray *keys) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(persons, keys);
                }
                
            });
            
        }];
        
    });
}

- (void)_sortNameWithDatas:(NSArray *)datas completcion:(void (^)(NSArray *, NSArray *))completcion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (LJPerson *person in datas)
    {
        NSString *firstLetter = [self _firstCharacterWithString:person.fullName];
        
        if (dict[firstLetter])
        {
            [dict[firstLetter] addObject:person];
        }
        else
        {
            NSMutableArray *arr = [NSMutableArray arrayWithObjects:person, nil];
            [dict setValue:arr forKey:firstLetter];
        }
    }
    
    NSMutableArray *keys = [[[dict allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
    if ([keys.firstObject isEqualToString:@"#"])
    {
        [keys addObject:keys.firstObject];
        [keys removeObjectAtIndex:0];
    }
    
    NSMutableArray *persons = [NSMutableArray array];
    
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        
        LJSectionPerson *person = [LJSectionPerson new];
        person.key = key;
        person.persons = dict[key];
        
        [persons addObject:person];
    }];
    
    if (completcion)
    {
        completcion(persons, keys);
    }
}

- (NSString *)_firstCharacterWithString:(NSString *)string
{
    if (string.length == 0)
    {
        return @"#";
    }
    
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    
    NSMutableString *pinyinString = [[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]] mutableCopy];
    NSString *str = [string substringToIndex:1];
    
    // 多音字处理http://blog.csdn.net/qq_29307685/article/details/51532147
    if ([str compare:@"长"] == NSOrderedSame)
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    if ([str compare:@"沈"] == NSOrderedSame)
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    if ([str compare:@"厦"] == NSOrderedSame)
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"xia"];
    }
    if ([str compare:@"地"] == NSOrderedSame)
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 2) withString:@"di"];
    }
    if ([str compare:@"重"] == NSOrderedSame)
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    
    NSString *upperStr = [[pinyinString substringToIndex:1] uppercaseString];
    
    NSString *regex = @"^[A-Z]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    NSString *firstCharacter = [predicate evaluateWithObject:upperStr] ? upperStr : @"#";
    
    return firstCharacter;
}
- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
}

#pragma mark - 获取本类控制器
- (UIViewController *)getShowViewController
{
  AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  
  UIWindow * window = delegate.window;
  
  if ([window.rootViewController isKindOfClass:[UINavigationController class]])
  {
    _showViewController = ((UINavigationController *)window.rootViewController).visibleViewController;
  }
  else if ([window.rootViewController isKindOfClass:[UITabBarController class]])
  {
    _showViewController = ((UITabBarController *)window.rootViewController).selectedViewController;
  }
  else
  {
    _showViewController = window.rootViewController;
  }
  return _showViewController;
}

@end
