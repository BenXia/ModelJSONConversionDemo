//
//  MJExtensionUsageVC.m
//  TestTemplateProject
//
//  Created by Ben on 2017/9/5.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "MJExtensionUsageVC.h"
#import "ModelForMJExtension.h"

/**
 *
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
 *  10.异常情况: NSString <-> NSUInteger                 ✔︎
 *  11.异常情况: NSArray <-> NSString                    ✘(error)
 *
 */

// MJExtension 一些异常处理
// 这个的使用方式就不介绍了，GitHub上写的非常详细。这里主要说说我在用的项目中时遇到问题及解决方式。情况大致是这样的: 最开始项目中的模型统统继承自BaseModel类，解析方式都是自己挨个手动解析。还自定义了一些譬如时间戳转自定义日期类型的方法。在换到MJExtension时，没法对我们的自定义解析方式进行兼容，全部重写肯定是不现实的，只能做兼容。最后通过阅读MJExtension的源码，找到了一个突破口。在BaseModel里面对MJExtension里面的一个方法使用Method Swizzling进行替换。大致代码如下:

//// json->模型，转换完成之后调用, 以便进行自定义配置。
//- (void)mc_keyValuesDidFinishConvertingToObjectWithData:(id)data;
//
////这样在使用MJExtension将模型解析完成之后再调用mc_keyValuesDidFinishConvertingToObjectWithData: 将原始数据传递过去进行自定义配置。就可以很好的与老工程兼容了。
//@implementation ModelForMJExtension
//
///* 替换方法: - (instancetype)setKeyValues:(id)keyValues context:(NSManagedObjectContext *)context error:(NSError **)error; */
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//
//        SEL originalSelector = @selector(setKeyValues:context:error:);
//        SEL swizzledSelector = @selector(mc_setKeyValues:context:error:);
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//
//        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//        if (success) {
//            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    });
//}
//
////- (instancetype)mc_setKeyValues:(id)keyValues context:(NSManagedObjectContext *)context error:(NSError **)error {
////    MCDataModel *model = [self mc_setKeyValues:keyValues context:context error:error];
////    if ([self respondsToSelector:@selector(mc_keyValuesDidFinishConvertingToObjectWithData:)]) {
////        [self mc_keyValuesDidFinishConvertingToObjectWithData:keyValues];
////    }
////    return model;
////}
//
//@end

@interface MJExtensionUsageVC ()

@end

@implementation MJExtensionUsageVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"MJExtension 用法测试";
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
    id JSONDict = [JSONUtils getJSONObjectWithJSONFileName:@"MJExtensionTest"];

    //  JSON -> Model
    [MJExtensionUser mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"loginDate" : @"login_date"};
    }];
    
    [MJExtensionUser mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"books" : @"MJExtensionBook"};
    }];
    
    MJExtensionUser *userOne = [MJExtensionUser mj_objectWithKeyValues:JSONDict];
    NSLog (@"userOne: %@", userOne);
    
    // JSONString -> Model
    NSString *jsonString = [JSONUtils getJSONStringWithJSONFileName:@"MJExtensionTest"];
    MJExtensionUser *userTwo = [MJExtensionUser mj_objectWithKeyValues:jsonString];
    NSLog (@"userTwo: %@", userTwo);
    
    // JSON array -> model array
    id JSONArray = [JSONUtils getJSONObjectWithJSONFileName:@"MJExtensionModelArrayTest"];
    NSArray *bookArray = [MJExtensionBook mj_objectArrayWithKeyValuesArray:JSONArray];
    NSLog (@"bookArray: %@", bookArray);
    
    // Model -> JSON
    NSDictionary *jsonDict = userOne.mj_keyValues;
    NSLog (@"jsonDict:\n%@", jsonDict);
    
    // Model array -> JSON array
    NSArray *JSONArrayResult = [MJExtensionBook mj_keyValuesArrayWithObjectArray:bookArray];
    NSLog (@"JSONArrayResult: %@", JSONArrayResult);
}

- (IBAction)didClickSecondButton:(id)sender {
    // *  7.继承情况下多态的支持                                 ✘
//    [MJExtensionTextMessage mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{@"msgId" : @"id"};
//    }];
//    
//    [MJExtensionPictureMessage mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{@"msgId" : @"id",
//                 @"imageURL" : @"image_url"};
//    }];
    
    [MJExtensionMessage mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"msgId" : @"id"};
    }];
    
    [MJExtensionPictureMessage mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"imageURL" : @"image_url"};
    }];
    
    id JSONDictOne = [JSONUtils getJSONObjectWithJSONFileName:@"MJExtensionSubClassOneTest"];
    MJExtensionTextMessage *textMsg = [MJExtensionTextMessage mj_objectWithKeyValues:JSONDictOne];
    NSLog (@"textMsg: %@", textMsg);
    
    id JSONDictTwo = [JSONUtils getJSONObjectWithJSONFileName:@"MJExtensionSubClassTwoTest"];
    MJExtensionPictureMessage *pictureMsg = [MJExtensionPictureMessage mj_objectWithKeyValues:JSONDictTwo];
    NSLog (@"pictureMsg: %@", pictureMsg);
}

- (IBAction)didClickThirdButton:(id)sender {
    // *  8.NSCoding 协议(持久化)的支持                         ✔︎
    id JSONDict = [JSONUtils getJSONObjectWithJSONFileName:@"MJExtensionTest"];
    
    [MJExtensionUser mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"loginDate" : @"login_date"};
    }];
    
    [MJExtensionUser mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"books" : @"MJExtensionBook"};
    }];
    
    MJExtensionUser *mjUser = [MJExtensionUser mj_objectWithKeyValues:JSONDict];
//    [MJExtensionUser mj_setupIgnoredCodingPropertyNames:^NSArray *{
//        return @[@"books"];
//    }];
    // 上面的方法与 MJExtensionUser中重载 + (NSArray *)mj_ignoredCodingPropertyNames 方法等效
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:mjUser];
    MJExtensionUser *unarchivedUser = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    NSLog (@"unarchivedUser: %@", unarchivedUser);
}

- (IBAction)didClickForthButton:(id)sender {
    //    *  9.异常情况: NSString <-> NSNumber                    ✔︎
    //    *  10.异常情况: NSString <-> NSUInteger                 ✔︎
    //    *  11.异常情况: NSArray <-> NSString                    ✘
    
    id JSONDictOne = [JSONUtils getJSONObjectWithJSONFileName:@"MJExtensionExceptionOneTest"];
    MJExtensionPerson *personOne = [MJExtensionPerson mj_objectWithKeyValues:JSONDictOne];
    NSLog (@"personOne: %@", personOne);
    
    id JSONDictTwo = [JSONUtils getJSONObjectWithJSONFileName:@"MJExtensionExceptionTwoTest"];
    MJExtensionPerson *personTwo = [MJExtensionPerson mj_objectWithKeyValues:JSONDictTwo];
    NSLog (@"personTwo: %@", personTwo);
    
    id JSONDictThree = [JSONUtils getJSONObjectWithJSONFileName:@"MJExtensionExceptionThreeTest"];
    MJExtensionPerson *personThree = [MJExtensionPerson mj_objectWithKeyValues:JSONDictThree];
    NSLog (@"personThree: %@", personThree);
}

@end
