//
//  JSONModelUsageVC.m
//  TestTemplateProject
//
//  Created by Ben on 2017/9/5.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "JSONModelUsageVC.h"
#import "ModelForJSONModel.h"

/**
 *        特点                                       支持情况
 *  1.[NSNull null]                                   　✔︎
 *  2.嵌套Model                                  　      ✔︎
 *  3.NSArray中为Model                                  ✔︎
 *  4.字段需要换转处理                                  　 ✔︎
 *  5.字段 JSON 中没有                                   ✔︎
 *  6.未知字段(向后兼容）                                  ✔︎
 *  7.继承情况下多态的支持                                 ✘
 *  8.NSCoding 协议(持久化)的支持                         ✔︎
 *  9.异常情况: NSString <-> NSNumber                    ✔︎
 *  10.异常情况: NSString <-> NSUInteger                 ✘(crash)
 *  11.异常情况: NSArray <-> NSString                    ✘
 *
 */

@interface JSONModelUsageVC ()

@end

@implementation JSONModelUsageVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"JSONModel 用法测试";
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
    
    id JSONDict = [JSONUtils getJSONObjectWithJSONFileName:@"JSONModelTest"];
    
    // JSON -> Model
    NSError *error;
    JSONModelUser *user = [[JSONModelUser alloc] initWithDictionary:JSONDict error:&error];
    NSLog (@"error: %@", error);
    
    // Model -> JSON
    NSDictionary *dict = [user toDictionary];
    
    NSLog (@"dict:\n%@", dict);
}

- (IBAction)didClickSecondButton:(id)sender {
    // *  7.继承情况下多态的支持                                 ✘
    id JSONDictOne = [JSONUtils getJSONObjectWithJSONFileName:@"JSONModelSubClassOneTest"];

    NSError *error;
    JSONModelTextMessage *textMsg = [[JSONModelTextMessage alloc] initWithDictionary:JSONDictOne error:&error];
    NSLog (@"error: %@", error);
    NSLog (@"textMsg: %@", textMsg);
    
    id JSONDictTwo = [JSONUtils getJSONObjectWithJSONFileName:@"JSONModelSubClassTwoTest"];
    error = nil;
    JSONModelPictureMessage *pictureMsg = [[JSONModelPictureMessage alloc] initWithDictionary:JSONDictTwo error:&error];
    NSLog (@"error: %@", error);
    NSLog (@"pictureMsg: %@", pictureMsg);
}

- (IBAction)didClickThirdButton:(id)sender {
    // *  8.NSCoding 协议(持久化)的支持                         ✔︎
    
    // JSONModel 归档的方式, 不是将对象归档，而是转换成 JSON字符串 再归档
    
    id JSONDict = [JSONUtils getJSONObjectWithJSONFileName:@"JSONModelTest"];
    NSError *error;
    JSONModelUser *user = [[JSONModelUser alloc] initWithDictionary:JSONDict error:&error];
    NSLog (@"error: %@", error);
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:user];
    
    JSONModelUser *unarchivedUser = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    
    NSLog (@"unarchivedUser: %@", unarchivedUser);
}

- (IBAction)didClickForthButton:(id)sender {
    //    *  9.异常情况: NSString <-> NSNumber                    ✔︎
    //    *  10.异常情况: NSString <-> NSUInteger                 ✘(crash)
    //    *  11.异常情况: NSArray <-> NSString                    ✘
    
    id JSONDictOne = [JSONUtils getJSONObjectWithJSONFileName:@"JSONModelExceptionOneTest"];
    NSError *error;
    JSONModelPerson *personOne = [[JSONModelPerson alloc] initWithDictionary:JSONDictOne error:&error];
    NSLog (@"error: %@", error);
    NSLog (@"personOne: %@", personOne);
    
    id JSONDictTwo = [JSONUtils getJSONObjectWithJSONFileName:@"JSONModelExceptionTwoTest"];
    error = nil;
    JSONModelPerson *personTwo = [[JSONModelPerson alloc] initWithDictionary:JSONDictTwo error:&error];
    NSLog (@"error: %@", error);
    NSLog (@"personTwo: %@", personTwo);
    
    id JSONDictThree = [JSONUtils getJSONObjectWithJSONFileName:@"JSONModelExceptionThreeTest"];
    error = nil;
    JSONModelPerson *personThree = [[JSONModelPerson alloc] initWithDictionary:JSONDictThree error:&error];
    NSLog (@"error: %@", error);
    NSLog (@"personThree: %@", personThree);
}

@end


