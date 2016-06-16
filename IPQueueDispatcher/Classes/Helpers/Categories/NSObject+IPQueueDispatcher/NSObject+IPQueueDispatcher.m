//
//  NSObject+IPQueueDispatcher.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "NSObject+IPQueueDispatcher.h"
#import <objc/runtime.h>

@implementation NSObject (IPQueueDispatcher)

- (void)setPropertiesFromDictionary:(NSDictionary *)properties
{
    for (NSString *key in [properties allKeys]){
        @try {
            if ([self respondsToSelector:NSSelectorFromString(key)]){
                id value = properties[key];
                [self setValue:value forKey:key];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"[W]Exception while filling object with properties [%@], %@",properties,exception);
        }
    }
}

- (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    for (NSString *key in [[[self class] JSONKeyPathsByPropertyKey] allKeys])
    {
        [self addSafeKey:key
                   value:[self valueForKey:key]
              collection:result];
    }
    return [NSDictionary dictionaryWithDictionary:result];
}

- (void)addSafeKey:(NSString *)key
             value:(id)value
        collection:(NSMutableDictionary *)collection
{
    if (value && key && value && ![value isKindOfClass:[NSArray class]])
    {
        collection[key] = value;
    }
}

- (NSDictionary *)differencesfrom:(id)obj2
{
    
    NSMutableDictionary *result = [NSMutableDictionary new];
    unsigned int varCount1, varCount2;
    
    @try {
        if (!self || !obj2) {
            NSLog(@"Both objects should not be nil!");
            return nil;
        }
        if ([self class] != [obj2 class]) {
            NSLog(@"Objects has different classes!");
            return nil;
        }
        Ivar *vars1 = class_copyIvarList([self class], &varCount1);
        Ivar *vars2 = class_copyIvarList([obj2 class], &varCount2);
        BOOL match = YES;
        
        for (int i = 0; i < varCount1; i++) {
            Ivar var1 = vars1[i];
            for (int j = 0; i < varCount2; j++) {
                Ivar var2 = vars2[j];
                if (strcmp(ivar_getName(var1), ivar_getName(var2)) == 0) {
                    if (object_getIvar(self, var1) != object_getIvar(obj2, var2)) {
                        match = NO;
                        break;
                    }
                }
            }
            if (!match) break;
        }
        free(vars1);
        free(vars2);
    } @catch (NSException *exception) {
        NSLog(@"[E]An exception raised : %@",exception);
    } @finally {
        return [NSDictionary dictionaryWithDictionary:result];
    }
}

@end
