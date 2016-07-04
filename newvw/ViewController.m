//
//  ViewController.m
//  newvw
//
//  Created by oricheng on 15/9/17.
//  Copyright © 2015年 navinfo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
}
@property(nonatomic,strong)CNContactStore *contactStore;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)newContactClicked:(id)sender {
    [self saveNewContact];
}
- (IBAction)currentContactClicked:(id)sender {
    [self saveExistContact];
}

- (void)saveNewContact{
    //1.创建Contact对象，必须是可变的
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    //2.为contact赋值，这块比较恶心，很混乱，setValue4Contact中会给出常用值的对应关系
    [self setValue4Contact:contact existContect:NO];
    //3.创建新建好友页面
    CNContactViewController *controller = [CNContactViewController viewControllerForNewContact:contact];
    //代理内容根据自己需要实现
    controller.delegate = self;
    //4.跳转
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
    
}

//保存现有联系人实现
- (void)saveExistContact{
    //1.跳转到联系人选择页面，注意这里没有使用UINavigationController
    CNContactPickerViewController *controller = [[CNContactPickerViewController alloc] init];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

#pragma mark - CNContactViewControllerDelegate
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact{
    [viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - CNContactPickerDelegate
//2.实现点选的代理，其他代理方法根据自己需求实现
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    [picker dismissViewControllerAnimated:YES completion:^{
        //3.copy一份可写的Contact对象，不要尝试alloc一类，mutableCopy独此一家
        CNMutableContact *c = [contact mutableCopy];
        //4.为contact赋值
        [self setValue4Contact:c existContect:YES];
        //5.跳转到新建联系人页面
        CNContactViewController *controller = [CNContactViewController viewControllerForNewContact:c];
        controller.delegate = self;
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navigation animated:YES completion:^{
        }];
    }];
}

//设置要保存的contact对象
- (void)setValue4Contact:(CNMutableContact *)contact existContect:(BOOL)exist{
    if (!exist) {
        //名字和头像
        contact.nickname = @"oriccheng";
        //        UIImage *logo = [UIImage imageNamed:@"..."];
        //        NSData *dataRef = UIImagePNGRepresentation(logo);
        //        contact.imageData = dataRef;
    }
    //电话,每一个CNLabeledValue都是有讲究的，如何批评，可以在头文件里面查找，这里给出几个常用的，别的我也不愿意去研究
    CNLabeledValue *phoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:@"18888888888"]];
    if (!exist) {
        contact.phoneNumbers = @[phoneNumber];
    }
    //现有联系人情况
    else{
        if ([contact.phoneNumbers count] >0) {
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] initWithArray:contact.phoneNumbers];
            [phoneNumbers addObject:phoneNumber];
            contact.phoneNumbers = phoneNumbers;
        }else{
            contact.phoneNumbers = @[phoneNumber];
        }
    }
    
    //网址:CNLabeledValue *url = [CNLabeledValue labeledValueWithLabel:@"" value:@""];
    //邮箱:CNLabeledValue *mail = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:self.poiData4Save.mail];
    
    //特别说一个地址，PostalAddress对应的才是地址
    CNMutablePostalAddress *address = [[CNMutablePostalAddress alloc] init];
    address.state = @"辽宁省";
    address.city = @"沈阳市";
    address.postalCode = @"111111";
    //外国人好像都不强调区的概念，所以和具体地址拼到一起
    address.street = @"沈河区惠工街10号";
    //生成的上面地址的CNLabeledValue，其中可以设置类型CNLabelWork等等
    CNLabeledValue *addressLabel = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:address];
    if (!exist) {
        contact.postalAddresses = @[addressLabel];
    }else{
        if ([contact.postalAddresses count] >0) {
            NSMutableArray *addresses = [[NSMutableArray alloc] initWithArray:contact.postalAddresses];
            [addresses addObject:addressLabel];
            contact.postalAddresses = addresses;
        }else{
            contact.postalAddresses = @[addressLabel];
        }
    }
}



@end
