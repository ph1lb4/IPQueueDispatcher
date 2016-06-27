//
//  IPDataLayer.m
//  Pods
//
//  Created by Ilias Pavlidakis on 16/06/2016.
//
//

#import "IPDataLayer.h"
#import <MagicalRecord/MagicalRecord.h>
#import <MagicalRecord/NSManagedObject+MagicalFinders.h>

@implementation IPDataLayer

- (NSManagedObject *)insertEntityName:(NSString *)entityName
                           properties:(NSDictionary *)properties
                              context:(NSManagedObjectContext *)context
{
    NSManagedObject *object = [NSClassFromString(entityName) MR_createEntityInContext:context];
    if (object) {
        for (NSString *key in [properties allKeys]){
            @try {
                if ([object respondsToSelector:NSSelectorFromString(key)]){
                    [object setValue:properties[key]
                              forKey:key];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"[W]Exception while insert entity type [%@] with properties [%@], %@",entityName,properties,exception);
            }
        }
    }
    return object;
}

- (NSManagedObject *)updateObject:(NSManagedObject *)object
                       properties:(NSDictionary *)properties
                          context:(NSManagedObjectContext *)context
{
    for (NSString *key in [properties allKeys]){
        @try {
            [object setValue:properties[key] forKey:key];
        } @catch (NSException *exception) {
            NSLog(@"[W] Exception while updateing entity type [%@] with properties [%@], %@",NSStringFromClass([object class]),properties,exception);
        }
    }
    return object;
}

- (void)findOrCreate:(nonnull NSString *)entityName
               items:(nonnull NSArray *)items
           predicate:(nullable NSPredicate *)predicate
     sortDescriptors:(nonnull NSArray<NSSortDescriptor *> *)sortDescriptors
          comparator:(nonnull BOOL (^)(_Nonnull id item,  NSManagedObject * _Nonnull entity))comparator
             creator:(nonnull NSManagedObject * _Nonnull (^)(_Nonnull id item))creator
             updater:(NSManagedObject * _Nonnull (^ _Nonnull)(_Nonnull id item,  NSManagedObject * _Nonnull entity))updater
      entryFinalizer:(void (^ _Nullable)(_Nullable id item,  NSManagedObject * _Nullable entity, BOOL emptyItemsArray))entryFinalizer
           finalizer:(void (^ _Nullable)(_Nullable id item,  NSManagedObject * _Nullable entity, BOOL emptyItemsArray))finalizer
             context:(nonnull NSManagedObjectContext *)context
{
    NSArray *fetchedObjects = nil;
    
    if (predicate) {
        fetchedObjects = [self performFetchRequest:entityName
                                         predicate:predicate
                                           context:context];
    } else {
        fetchedObjects = [self performAllFetchRequest:entityName
                                              context:context];
    }
    
    items = [items sortedArrayUsingDescriptors:sortDescriptors];
    fetchedObjects = [fetchedObjects sortedArrayUsingDescriptors:sortDescriptors];
    
    NSEnumerator *itemsEnumerator = [items objectEnumerator];
    NSEnumerator *fetchedObjectsEnumerator = [fetchedObjects objectEnumerator];
    
    id item = [itemsEnumerator nextObject];
    id fetchedObject = [fetchedObjectsEnumerator nextObject];
    
    if ([items count] == 0) {
        if (finalizer) {
            finalizer(nil,nil,YES);
        }
    } else {
        while (item) {
            BOOL isUpdate = fetchedObject && comparator(item,fetchedObject);
            if (isUpdate){
                fetchedObject = updater(item,fetchedObject);
                if (finalizer) {
                    finalizer(item,fetchedObject,NO);
                }
                
                item = [itemsEnumerator nextObject];
                fetchedObject = [fetchedObjectsEnumerator nextObject];
            } else {
                NSManagedObject *newObject = creator(item);
                if (entryFinalizer) {
                    entryFinalizer(item,newObject,NO);
                }
                
                item = [itemsEnumerator nextObject];
            }
        }
        
        if (finalizer) {
            finalizer(nil,nil,YES);
        }
    }
}

- (void)connectChilds:(nonnull NSString *)childsEntityName
      childsPredicate:(nonnull NSPredicate *)childsPredicate
     parentEntityName:(nonnull NSString *)parentEntityName
      parentPredicate:(nonnull NSPredicate *)parentPredicate
  assignParentToChild:(nonnull void (^)(NSManagedObject *_Nonnull child,  NSManagedObject * _Nonnull parent))assignParentToChild
 assignChildsToParent:(nonnull void (^)(NSArray<NSManagedObject *> *_Nonnull childs,  NSManagedObject * _Nonnull parent))assignChildsToParent
     fetchSingleChild:(BOOL)fetchSingleChild
              context:(nonnull NSManagedObjectContext *)context
{
    NSArray<NSManagedObject *> *childs = nil;
    if (fetchSingleChild) {
        NSManagedObject *child = [self performSingleFetchRequest:childsEntityName
                                                       predicate:childsPredicate
                                                         context:context];
        if (child) {
            childs = @[child];
        }
    } else {
        childs = [self performFetchRequest:childsEntityName
                                 predicate:childsPredicate
                                   context:context];
    }
    
    NSManagedObject *parent = [self performSingleFetchRequest:parentEntityName
                                                    predicate:parentPredicate
                                                      context:context];
    
    if ([childs count] > 0 && parent) {
        for (NSManagedObject *child in childs) {
            assignParentToChild(child,parent);
        }
        assignChildsToParent(childs,parent);
    }
}

#pragma mark - Delete Request Handlers

- (BOOL)performDeleteRequest:(NSString *)entityName
                   predicate:(NSPredicate *)predicate
                     context:(NSManagedObjectContext *)context
{
    __block BOOL result = NO;
    [context MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        if (predicate) {
            result = [NSClassFromString(entityName) MR_deleteAllMatchingPredicate:predicate
                                                                        inContext:context];
        } else {
            result = [NSClassFromString(entityName) MR_truncateAllInContext:context];
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        NSLog(@"[I]Entities deletion completed");
    }];
    return result;
}

- (BOOL)performDeleteRequestForEnityObject:(NSManagedObject *)entityObject
                                   context:(NSManagedObjectContext *)context
{
    BOOL result = NO;
    result = [entityObject MR_deleteEntityInContext:context];
    return result;
}

- (BOOL)performDeleteRequestForEnityObjects:(NSArray<NSManagedObject *> *)entityObjects
                                    context:(NSManagedObjectContext *)context
{
    BOOL result = NO;
    if (entityObjects)
    {
        for (NSManagedObject *entityObject in entityObjects)
        {
            result = [self performDeleteRequestForEnityObject:entityObject
                                                      context:context];
            if (!result) break;
        }
    } else {
        result = YES;
    }
    return result;
}

#pragma mark - Fetch Request Handlers

- (NSArray *)performAllFetchRequest:(NSString *)entityName
                            context:(NSManagedObjectContext *)context
{
    return [NSClassFromString(entityName) MR_findAllInContext:context];
}

- (NSArray *)performFetchRequest:(NSString *)entityName
                       predicate:(NSPredicate *)predicate
                         context:(NSManagedObjectContext *)context
{
    return [NSClassFromString(entityName) MR_findAllWithPredicate:predicate
                                                        inContext:context?:[self defaultContext]];
}

- (NSArray *)performDistinctFetchRequest:(NSString *)entityName
                               predicate:(NSPredicate *)predicate
                                 context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSClassFromString(entityName) MR_createFetchRequestInContext:context];
    [request setPredicate:predicate];
    [request setReturnsDistinctResults:YES];
    
    return [NSClassFromString(entityName) MR_executeFetchRequest:request
                                                       inContext:context];
}

- (NSManagedObject *)performSingleFetchRequest:(NSString *)entityName
                                     predicate:(NSPredicate *)predicate
                                       context:(NSManagedObjectContext *)context
{
    return [NSClassFromString(entityName) MR_findFirstWithPredicate:predicate inContext:context];
}

- (NSManagedObject *)objectWithID:(NSManagedObjectID *)objectID
                          context:(NSManagedObjectContext *)context
{
    return [context?:[self defaultContext] objectWithID:objectID];
}

- (NSInteger)countEntities:(NSString *_Nonnull)entityName
                filteredBy:(NSPredicate *_Nullable)predicate
                   context:(NSManagedObjectContext *)context
{
    NSNumber *result = nil;
    if (predicate){
        result = [NSClassFromString(entityName) MR_numberOfEntitiesWithPredicate:predicate
                                                                       inContext:context];
    } else {
        result = [NSClassFromString(entityName) MR_numberOfEntitiesWithContext:context];
    }
    return [result integerValue];
}

- (NSFetchedResultsController *)controllerForEntiyName:(NSString *_Nonnull)entityName
                                             predicate:(NSPredicate *)predicate
                                               groupBy:(NSString *_Nullable)groupBy
                                                sortBy:(NSString *_Nullable)sortBy
                                             ascending:(BOOL)ascending
                                               context:(NSManagedObjectContext *_Nullable)context
{
    Class class = NSClassFromString(entityName);
    if ([class instancesRespondToSelector:@selector(MR_fetchAllGroupedBy:withPredicate:sortedBy:ascending:inContext:)]){
        return [class MR_fetchAllGroupedBy:groupBy
                             withPredicate:predicate
                                  sortedBy:sortBy
                                 ascending:ascending
                                 inContext:context?:[self defaultContext]];
    } else {
        return nil;
    }
}

#pragma mark - UUID Handlers;

+ (NSString *)UUIDGenerator
{
    return [[[NSUUID alloc] init] UUIDString];
}

#pragma mark - Execute Blocks

- (void)executeBlock:(nullable void (^)(NSManagedObjectContext *context))block
                save:(BOOL)save
          completion:(nullable void (^)(BOOL contextDidSave,  NSError * _Nullable error))completion
{
    if (block) {
        if (save) {
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                block(localContext);
            } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                if (completion) {
                    completion(contextDidSave,error);
                }
            }];
        } else {
            __block NSManagedObjectContext *localContext = [NSManagedObjectContext MR_context];
            [localContext performBlock:^{
                block(localContext);
                if (completion) {
                    completion(NO,nil);
                }
            }];
        }
    } else {
        NSLog(@"[W]Non executable block found!");
    }
}

- (void)executeBlock:(nullable void (^)(NSManagedObjectContext *context))block
                save:(BOOL)save
{
    [self executeBlock:block
                  save:save
            completion:nil];
}

#pragma mark - Helpers

- (NSManagedObjectContext *)defaultContext
{
    return [NSManagedObjectContext MR_defaultContext];
}

@end