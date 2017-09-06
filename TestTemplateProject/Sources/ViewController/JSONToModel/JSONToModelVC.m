//
//  JSONToModelVC.m
//  TestTemplateProject
//
//  Created by Ben on 2017/8/27.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "JSONToModelVC.h"
#import "JSONModelUsageVC.h"
#import "MantleUsageVC.h"
#import "MJExtensionUsageVC.h"
#import "YYModelUsageVC.h"


/**
 *
 *        特点                                  JSONModel          Mantle          MJExtension         YYModel
 *  1.[NSNull null]                              　✔︎                 ✔︎                 ✔︎                 ✔︎
 *  2.嵌套Model                                  　 ✔︎                 ✔︎                 ✔︎                 ✔︎
 *  3.NSArray中为Model                             ✔︎                 ✔︎                 ✔︎                 ✔︎
 *  4.字段需要换转处理                               ✔︎                 ✔︎                 ✔︎                 ✔︎
 *  5.字段 JSON 中没有                              ✔︎                 ✔︎                 ✔︎                 ✔︎
 *  6.未知字段(向后兼容）                             ✔︎                 ✔︎                 ✔︎                 ✔︎
 *  7.继承情况下多态的支持                            ✘(不支持)           ✔︎                 ✘(不支持)          ✔︎
 *  8.NSCoding 协议(持久化)的支持                     ✔︎                 ✔︎                 ✔︎                 ✔︎
 *  9.异常情况: NSString <-> NSNumber               ✔︎                 ✘(error)           ✔︎                 ✔︎
 *  10.异常情况: NSString <-> NSUInteger            ✘(crash)          ✘(error)           ✔︎                 ✔︎
 *  11.异常情况: NSArray <-> NSString               ✘(error)          ✘(error)           ✘(error)          ✘(error)
 *
 */


//Mantle,JSONModel,MJExtension防崩溃比较:
//对于这样一条数据:
//
//{
//    "firstName": "张",
//    "lastName": "三",
//    "age": 23,
//    "height": 172.3,
//    "weight": 51.2,
//    "sex": true
//}
//客户端属性声明为:
//@property (nonatomic, copy) NSString *age;
//
// 直接使用[Model modelWithDictionary:dict error:&error];情况下Mantle的模型赋值:
//
//if (![obj validateValue:&validatedValue forKey:key error:error]) return NO;
//if (forceUpdate || value != validatedValue)
//{
//    [obj setValue:validatedValue forKey:key];
//}
//return YES;
//它是使用了KVC的- (BOOL)validateValue:(inout id __nullable * __nonnull)ioValue
//forKey:(NSString *)inKey error:(out NSError **)outError;方法来验证要赋的值的类型是否和key的类型是否匹配.该方法默认会调用a
//validator method whose name matches the pattern -validate<Key>:error:.因此我们还需要在模型里面写一个这样的方法:
//
//-(BOOL)validateAge:(id *)ioValue error:(NSError * __autoreleasing *)outError
//{
//    if ([*ioValue isKindOfClass:[NSNumber class]])
//    {
//        return YES;
//    }
//    return NO;
//}
//如果没写默认返回YES.Mantle貌似并没有帮我们做这么一步,所以如果你自己没写的话,那么上述验证的方法会返回YES.好的程序不应该总是期望服务器端永远都返回正确的东西,然而我们又无法知道服务器哪些字段会返回和我们不一致的类型.难道每一个属性都要写一个-validate<Key>:error:来判断?个人认为在这一点上Mantle做的很鸡肋.如果你没写-validate<Key>:error:而碰巧服务器端返回一个数字类型,那么你的程序很有可能会崩溃.（注意只是影响[Model modelWithDictionary:dict error:&error]这种使用的转换）

//对于JSONModel的模型赋值:
//
////check for custom transformer
//BOOL foundCustomTransformer = NO;
//if ([valueTransformer respondsToSelector:selector]) {
//    foundCustomTransformer = YES;
//} else {
//    //try for hidden custom transformer
//    selectorName = [NSString stringWithFormat:@"__%@",selectorName];
//    selector = NSSelectorFromString(selectorName);
//    if ([valueTransformer respondsToSelector:selector]) {
//        foundCustomTransformer = YES;
//    }
//}
//
////check if there's a transformer with that name
//if (foundCustomTransformer) {
//
//    //it's OK, believe me...
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//    //transform the value
//    jsonValue = [valueTransformer performSelector:selector withObject:jsonValue];
//#pragma clang diagnostic pop
//
//    if (![jsonValue isEqual:[self valueForKey:property.name]]) {
//        [self setValue:jsonValue forKey: property.name];
//    }
//
//} else {
//
//    // it's not a JSON data type, and there's no transformer for it
//    // if property type is not supported - that's a programmer mistake -> exception
//    @throw [NSException exceptionWithName:@"Type not allowed"
//                                   reason:[NSString stringWithFormat:@"%@ type not supported for %@.%@", property.type, [self class], property.name]
//                                 userInfo:nil];
//    return NO;
//}
//可以看到它有做一个转换,对于一般的服务端数字,客户端NSString,或服务器端字符,客户端NSNumber,这样比较简单的转换,JSONModel已经帮我们实现好了,但是如果服务器端返回一个数组,但是客户端是NSString,那么这需要我们自己按照它的格式去写一个转换的方法,如果没写的话,JSONModel会抛出一个异常.然而通常我们需要服务器端传错了,我们客户端应该不崩溃,而是将对应的字段赋值为nil.

//对于MJExtension的模型赋值:
//由于MJ的考虑的情况比较全面,代码较多,有兴趣的可以自己去看,这里只截取最后一部分:
//
//// value和property类型不匹配
//if (propertyClass && ![value isKindOfClass:propertyClass])
//{
//    value = nil;
//}
//可以看到如果类型不匹配那么对应的属性将被赋值为nil.而这些不需要我们写任何代码,可以的.最为厉害的就是当服务器传字符串,客户端为NSUInteger类型时,Mantle会失败,JSONModel会崩溃,而MJ不会崩溃,且正确转换.
//综上防崩溃最强的当属MJExtension,如果服务器端开发人员很菜的话强烈推荐使用MJExtension.


@interface JSONToModelVC ()

@end

@implementation JSONToModelVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)testJSONModelUsage:(UIButton *)sender {
    JSONModelUsageVC *vc = [[JSONModelUsageVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)testMantleUsage:(id)sender {
    MantleUsageVC *vc = [[MantleUsageVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)testMJExtensionUsage:(id)sender {
    MJExtensionUsageVC *vc = [[MJExtensionUsageVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)testYYModelUsage:(id)sender {
    YYModelUsageVC *vc = [[YYModelUsageVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end


