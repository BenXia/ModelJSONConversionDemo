//
//  YYModelUsageVC.m
//  TestTemplateProject
//
//  Created by Ben on 2017/9/5.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "YYModelUsageVC.h"
#import "ModelForYYModel.h"

/**
 *
 *        特点                                       支持情况
 *  1.[NSNull null]                                   　✔︎
 *  2.嵌套Model                                  　      ✔︎
 *  3.NSArray中为Model                                  ✔︎
 *  4.字段需要换转处理                                  　 ✔︎
 *  5.字段 JSON 中没有                                   ✔︎
 *  6.未知字段(向后兼容）                                  ✔︎
 *  7.继承情况下多态的支持                                 ✔︎
 *  8.NSCoding 协议(持久化)的支持                         ✔︎
 *  9.异常情况: NSString <-> NSNumber                    ✔︎
 *  10.异常情况: NSString <-> NSUInteger                 ✔︎
 *  11.异常情况: NSArray <-> NSString                    ✘
 *
 */

@interface YYModelUsageVC ()

@end

@implementation YYModelUsageVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"YYModel 用法测试";
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
    id JSONDict = [JSONUtils getJSONObjectWithJSONFileName:@"YYModelTest"];
    
    //  JSON -> Model
    YYModelUser *userOne = [YYModelUser yy_modelWithJSON:JSONDict];
    NSLog (@"userOne: %@", userOne);
    
    // JSONString -> Model
    NSString *jsonString = [JSONUtils getJSONStringWithJSONFileName:@"YYModelTest"];
    YYModelUser *userTwo = [YYModelUser yy_modelWithJSON:jsonString];
    NSLog (@"userTwo: %@", userTwo);
    
    // JSON array -> model array
    id JSONArray = [JSONUtils getJSONObjectWithJSONFileName:@"YYModelModelArrayTest"];
    NSArray *bookArray = [NSArray yy_modelArrayWithClass:[YYModelBook class] json:JSONArray];
    NSLog (@"bookArray: %@", bookArray);
    
    // Model -> JSON
    NSDictionary *jsonDict = [userOne yy_modelToJSONObject];
    NSLog (@"jsonDict:\n%@", jsonDict);
}

- (IBAction)didClickSecondButton:(id)sender {
    // *  7.继承情况下多态的支持                                 ✔︎
    id JSONDictOne = [JSONUtils getJSONObjectWithJSONFileName:@"YYModelSubClassOneTest"];
    YYModelTextMessage *textMsg = (YYModelTextMessage *)[YYModelMessage yy_modelWithJSON:JSONDictOne];
    NSLog (@"textMsg: %@", textMsg);
    
    id JSONDictTwo = [JSONUtils getJSONObjectWithJSONFileName:@"YYModelSubClassTwoTest"];
    YYModelPictureMessage *pictureMsg = (YYModelPictureMessage *)[YYModelMessage yy_modelWithJSON:JSONDictTwo];
    NSLog (@"pictureMsg: %@", pictureMsg);
}

- (IBAction)didClickThirdButton:(id)sender {
    // *  8.NSCoding 协议(持久化)的支持                         ✔︎
    id JSONDict = [JSONUtils getJSONObjectWithJSONFileName:@"YYModelTest"];
    YYModelUser *yyUser = [YYModelUser yy_modelWithJSON:JSONDict];
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:yyUser];
    YYModelUser *unarchivedUser = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    NSLog (@"unarchivedUser: %@", unarchivedUser);
}

- (IBAction)didClickForthButton:(id)sender {
    //    *  9.异常情况: NSString <-> NSNumber                    ✔︎
    //    *  10.异常情况: NSString <-> NSUInteger                 ✔︎
    //    *  11.异常情况: NSArray <-> NSString                    ✘
    
// 支持的自动转换
//JSON/Dictionary	                  Model
//
//NSString	                 NSNumber,NSURL,SEL,Class
//
//NSNumber	                        NSString
//
//NSString/NSNumber	       基础类型 (BOOL,int,float,NSUInteger,UInt64,...)
//                             NaN 和 Inf 会被忽略
//
//NSString	                   NSDate 以下列格式解析:
//                                yyyy-MM-dd
//                                yyyy-MM-dd HH:mm:ss
//                                yyyy-MM-dd'T'HH:mm:ss
//                                yyyy-MM-dd'T'HH:mm:ssZ
//                                EEE MMM dd HH:mm:ss Z yyyy
//
//NSDate	                   NSString 格式化为 ISO8601:
//                              "YYYY-MM-dd'T'HH:mm:ssZ"
//
//NSValue	                   struct (CGRect,CGSize,...)
//
//NSNull	                          nil,0
//
//"no","false",...	                 @(NO),0
//
//"yes","true",...	                 @(YES),1
    
    id JSONDictOne = [JSONUtils getJSONObjectWithJSONFileName:@"YYModelExceptionOneTest"];
    YYModelPerson *personOne = [YYModelPerson mj_objectWithKeyValues:JSONDictOne];
    NSLog (@"personOne: %@", personOne);
    
    id JSONDictTwo = [JSONUtils getJSONObjectWithJSONFileName:@"YYModelExceptionTwoTest"];
    YYModelPerson *personTwo = [YYModelPerson mj_objectWithKeyValues:JSONDictTwo];
    NSLog (@"personTwo: %@", personTwo);
    
    id JSONDictThree = [JSONUtils getJSONObjectWithJSONFileName:@"YYModelExceptionThreeTest"];
    YYModelPerson *personThree = [YYModelPerson mj_objectWithKeyValues:JSONDictThree];
    NSLog (@"personThree: %@", personThree);
}

@end
