//
//  ModelForJSONModel.h
//  TestTemplateProject
//
//  Created by Ben on 2017/8/27.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#pragma mark -

/**
 *  1.[NSNull null]                                   　✔︎
 *  2.嵌套Model                                  　      ✔︎
 *  3.NSArray中为Model                                  ✔︎
 *  4.字段需要换转处理                                  　 ✔︎
 *  5.字段 JSON 中没有                                   ✔︎
 *  6.未知字段(向后兼容）                                  ✔︎
 */

@protocol JSONModelBook
@end

@interface JSONModelBook : JSONModel
@property (nonatomic, copy, nullable) NSString *name;
@end

@interface JSONModelPhone : JSONModel
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, assign) double price;
@end

@interface JSONModelUser : JSONModel
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL sex;
@property (nonatomic, strong, nullable) NSDate *loginDate;
@property (nonatomic, strong, nullable) JSONModelPhone *phone;
// 注意协议
@property (nonatomic, copy, nullable) NSArray<JSONModelBook> *books;

@end

//@interface JSONValueTransformer (CustomTransformer)
//
////时间戳转NSDate
//- (nullable NSDate *)NSDateFromNSString:(nullable NSString *)string;
////NSDate转时间戳
//- (nullable NSString *)JSONObjectFromNSDate:(nullable NSDate *)date;
//
//@end

#pragma mark -

/**
 *  7.继承情况下多态的支持                                 ✘
 */

@interface JSONModelMessage : JSONModel

@property (nonatomic, assign) NSUInteger msgId;

@end

@interface JSONModelTextMessage: JSONModelMessage

@property (nonatomic, copy, nullable) NSString *body;

@end

@interface JSONModelPictureMessage : JSONModelMessage

@property (nonatomic, strong, nullable) NSURL *imageURL;

@end

#pragma mark -

/**
 *  9.异常情况: NSString <-> NSNumber                     ✔︎
 *  10.异常情况: NSString <-> NSUInteger                  ✘(crash)
 *  11.异常情况: NSArray <-> NSString                     ✘
 */

@interface JSONModelPerson : JSONModel

@property (nonatomic, strong, nullable) NSNumber *age;
@property (nonatomic, assign) NSUInteger sex;
@property (nonatomic, copy, nullable) NSString *name;

@end


