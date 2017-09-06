//
//  MantleUsageVC.m
//  TestTemplateProject
//
//  Created by Ben on 2017/9/5.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "MantleUsageVC.h"
#import "ModelForMantle.h"

/**
 *        特点                                       支持情况
 *  1.[NSNull null]                                   　✔︎
 *  2.嵌套Model                                  　      ✔︎
 *  3.NSArray中为Model                                  ✔︎
 *  4.字段需要换转处理                                  　 ✔︎
 *  5.字段 JSON 中没有                                    ✔︎
 *  6.未知字段(向后兼容）                                  ✔︎
 *  7.继承情况下多态的支持                                 ✔︎
 *  8.NSCoding 协议(持久化)的支持                         ✔︎
 *  9.异常情况: NSString <-> NSNumber                    ✘
 *  10.异常情况: NSString <-> NSUInteger                 ✘
 *  11.异常情况: NSArray <-> NSString                    ✘
 *
 */

@interface MantleUsageVC ()

@end

@implementation MantleUsageVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Mantle 用法测试";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)didClickFirstButton:(id)sender {
//    *  1.[NSNull null]                                   　✔︎
//    *  2.嵌套Model                                  　      ✔︎
//    *  3.NSArray中为Model                                  ✔︎
//    *  4.字段需要换转处理                                  　 ✔︎
//    *  5.字段 JSON 中没有                                    ✔︎
//    *  6.未知字段(向后兼容）                                  ✔︎
    id JSONDict = [JSONUtils getJSONObjectWithJSONFileName:@"MantleTest"];
    
    //  JSON -> Model
    // 该方法会调用key-key map方法。
    MantleUser *mantleUser = [MTLJSONAdapter modelOfClass:[MantleUser class] fromJSONDictionary:JSONDict error:nil];
    // 这种方式只是简单的使用KVC进行赋值。不会调用key-key map方法, 要求属性和JSON字典中的key名称相同，否则就crash
    // self.MantleUser = [MantleUser modelWithDictionary:self.JSONDict error:&error];
    
    // Model -> JSON
    // 一旦有属性为nil, Mantle会转换成NSNull对象放到JSON字典中
    NSDictionary *jsonDict = [MTLJSONAdapter JSONDictionaryFromModel:mantleUser error:nil];
    // 这里有一个坑，使用NSUserDefault存储这样的JSON字典时，程序crash，原因是不可以包含NSNull对象。
    //[[NSUserDefaults standardUserDefaults] setObject:jsonDict forKey:@"JustForMantleUsageTest"];
    
    NSLog (@"jsonDict:\n%@", jsonDict);
}

- (IBAction)didClickSecondButton:(id)sender {
// *  7.继承情况下多态的支持                                 ✔︎
    id JSONDictOne = [JSONUtils getJSONObjectWithJSONFileName:@"MantleSubClassOneTest"];
    MantleTextMessage *textMsg = [MTLJSONAdapter modelOfClass:[MantleMessage class] fromJSONDictionary:JSONDictOne error:nil];
    NSLog (@"textMsg: %@", textMsg);
    
    id JSONDictTwo = [JSONUtils getJSONObjectWithJSONFileName:@"MantleSubClassTwoTest"];
    MantlePictureMessage *pictureMsg = [MTLJSONAdapter modelOfClass:[MantleMessage class] fromJSONDictionary:JSONDictTwo error:nil];
    NSLog (@"pictureMsg: %@", pictureMsg);
}

- (IBAction)didClickThirdButton:(id)sender {
// *  8.NSCoding 协议(持久化)的支持                         ✔︎
    id JSONDict = [JSONUtils getJSONObjectWithJSONFileName:@"MantleTest"];
    MantleUser *mantleUser = [MTLJSONAdapter modelOfClass:[MantleUser class] fromJSONDictionary:JSONDict error:nil];
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:mantleUser];
    
    MantleUser *unarchivedUser = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    
    NSLog (@"unarchivedUser: %@", unarchivedUser);
}

- (IBAction)didClickForthButton:(id)sender {
//    *  9.异常情况: NSString <-> NSNumber                    ✘
//    *  10.异常情况: NSString <-> NSUInteger                 ✘
//    *  11.异常情况: NSArray <-> NSString                    ✘
    
    id JSONDictOne = [JSONUtils getJSONObjectWithJSONFileName:@"MantleExceptionOneTest"];
    NSError *error;
    MantlePerson *personOne = [MTLJSONAdapter modelOfClass:[MantlePerson class] fromJSONDictionary:JSONDictOne error:&error];
    NSLog (@"error: %@", error);
    NSLog (@"personOne: %@", personOne);
    
    id JSONDictTwo = [JSONUtils getJSONObjectWithJSONFileName:@"MantleExceptionTwoTest"];
    error = nil;
    MantlePerson *personTwo = [MTLJSONAdapter modelOfClass:[MantlePerson class] fromJSONDictionary:JSONDictTwo error:&error];
    NSLog (@"error: %@", error);
    NSLog (@"personTwo: %@", personTwo);
    
    id JSONDictThree = [JSONUtils getJSONObjectWithJSONFileName:@"MantleExceptionThreeTest"];
    error = nil;
    MantlePerson *personThree = [MTLJSONAdapter modelOfClass:[MantlePerson class] fromJSONDictionary:JSONDictThree error:&error];
    NSLog (@"error: %@", error);
    NSLog (@"personThree: %@", personThree);
}

@end


