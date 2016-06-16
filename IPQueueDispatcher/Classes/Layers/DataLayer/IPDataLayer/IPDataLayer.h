//
//  IPDataLayer.h
//  Pods
//
//  Created by Ilias Pavlidakis on 16/06/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface IPDataLayer : NSObject

/**
 *  Create an instance of the specified entity
 *
 *  @param entityName        The entity type to create
 *  @param properties        If set then those properties will be set on the object after it's creation and before it's save
 *  @param saveStoreOnFinish If yes object will be automatically saved on the store
 *  @param error             The error to fill in case of error
 *
 *  @return The newly created object
 */
- (NSManagedObject * _Nullable)insertEntityName:(NSString *_Nullable)entityName
                                     properties:(NSDictionary *_Nullable)properties
                                        context:(NSManagedObjectContext *_Nullable)context;

/**
 *  Update an instance of the specified entity
 *
 *  @param object        The object to Update
 *  @param properties        If set then those properties will be set on the object after it's creation and before it's save
 *  @param saveStoreOnFinish If yes object will be automatically saved on the store
 *  @param error             The error to fill in case of error
 *
 *  @return The updated object
 */
- (NSManagedObject *_Nullable)updateObject:(NSManagedObject *_Nullable)object
                                properties:(NSDictionary *_Nullable)properties
                                   context:(NSManagedObjectContext *_Nullable)context;

/**
 *  <#Description#>
 *
 *  @param entityName      <#entityName description#>
 *  @param items           <#items description#>
 *  @param predicate       <#predicate description#>
 *  @param sortDescriptors <#sortDescriptors description#>
 *  @param comparator      <#comparator description#>
 *  @param creator         <#creator description#>
 *  @param updater         <#updater description#>
 *  @param entryFinalizer  <#entryFinalizer description#>
 *  @param finalizer       <#finalizer description#>
 *  @param context         <#context description#>
 */
- (void)findOrCreate:(nonnull NSString *)entityName
               items:(nonnull NSArray *)items
           predicate:(nullable NSPredicate *)predicate
     sortDescriptors:(nonnull NSArray<NSSortDescriptor *> *)sortDescriptors
          comparator:(nonnull BOOL (^)(_Nonnull id item,  NSManagedObject * _Nonnull entity))comparator
             creator:(nonnull NSManagedObject * _Nonnull (^)(_Nonnull id item))creator
             updater:(NSManagedObject * _Nonnull (^ _Nonnull)(_Nonnull id item,  NSManagedObject * _Nonnull entity))updater
      entryFinalizer:(void (^ _Nullable)(_Nullable id item,  NSManagedObject * _Nullable entity, BOOL emptyItemsArray))entryFinalizer
           finalizer:(void (^ _Nullable)(_Nullable id item,  NSManagedObject * _Nullable entity, BOOL emptyItemsArray))finalizer
             context:(nonnull NSManagedObjectContext *)context;

/**
 *  <#Description#>
 *
 *  @param childsEntityName     <#childsEntityName description#>
 *  @param childsPredicate      <#childsPredicate description#>
 *  @param parentEntityName     <#parentEntityName description#>
 *  @param parentPredicate      <#parentPredicate description#>
 *  @param assignParentToChild  <#assignParentToChild description#>
 *  @param assignChildsToParent <#assignChildsToParent description#>
 *  @param fetchSingleChild     <#fetchSingleChild description#>
 *  @param context              <#context description#>
 */
- (void)connectChilds:(nonnull NSString *)childsEntityName
      childsPredicate:(nonnull NSPredicate *)childsPredicate
     parentEntityName:(nonnull NSString *)parentEntityName
      parentPredicate:(nonnull NSPredicate *)parentPredicate
  assignParentToChild:(nonnull void (^)(NSManagedObject *_Nonnull child,  NSManagedObject * _Nonnull parent))assignParentToChild
 assignChildsToParent:(nonnull void (^)(NSArray<NSManagedObject *> *_Nonnull childs,  NSManagedObject * _Nonnull parent))assignChildsToParent
     fetchSingleChild:(BOOL)fetchSingleChild
              context:(nonnull NSManagedObjectContext *)context;

#pragma mark - Delete Request Handlers

/**
 *  Batch delete implementation
 *
 *  @param entityName The entity type to delete
 *  @param predicate  Any predicate we would like to add on our delete
 *
 *  @return Yes if successful
 */
- (BOOL)performDeleteRequest:(NSString *_Nullable)entityName
                   predicate:(NSPredicate *_Nullable)predicate
                     context:(NSManagedObjectContext *_Nullable)context;

/**
 *  <#Description#>
 *
 *  @param entityObject <#entityObject description#>
 *  @param context      <#context description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)performDeleteRequestForEnityObject:(NSManagedObject *_Nullable)entityObject
                                   context:(NSManagedObjectContext *_Nullable)context;

/**
 *  <#Description#>
 *
 *  @param entityObjects <#entityObjects description#>
 *  @param context       <#context description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)performDeleteRequestForEnityObjects:(NSArray<NSManagedObject *> *_Nullable)entityObjects
                                    context:(NSManagedObjectContext *_Nullable)context;

#pragma mark -
#pragma mark - Fetch Request Handlers

/**
 *  <#Description#>
 *
 *  @param entityName <#entityName description#>
 *  @param context    <#context description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *_Nullable)performAllFetchRequest:(NSString *_Nullable)entityName
                                     context:(NSManagedObjectContext *_Nullable)context;

/**
 *  <#Description#>
 *
 *  @param entityName <#entityName description#>
 *  @param predicate  <#predicate description#>
 *  @param context    <#context description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *_Nullable)performFetchRequest:(NSString *_Nullable)entityName
                                predicate:(NSPredicate *_Nullable)predicate
                                  context:(NSManagedObjectContext *_Nullable)context;

/**
 *  <#Description#>
 *
 *  @param entityName <#entityName description#>
 *  @param predicate  <#predicate description#>
 *  @param context    <#context description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *_Nullable)performDistinctFetchRequest:(NSString *_Nullable)entityName
                                        predicate:(NSPredicate *_Nullable)predicate
                                          context:(NSManagedObjectContext *_Nullable)context;

/**
 *  <#Description#>
 *
 *  @param entityName <#entityName description#>
 *  @param predicate  <#predicate description#>
 *  @param context    <#context description#>
 *
 *  @return <#return value description#>
 */
- (NSManagedObject *_Nullable)performSingleFetchRequest:(NSString *_Nullable)entityName
                                              predicate:(NSPredicate *_Nullable)predicate
                                                context:(NSManagedObjectContext *_Nullable)context;

/**
 *  <#Description#>
 *
 *  @param objectID <#objectID description#>
 *  @param context  <#context description#>
 *
 *  @return <#return value description#>
 */
- (NSManagedObject *_Nullable)objectWithID:(NSManagedObjectID *_Nullable)objectID
                                   context:(NSManagedObjectContext *_Nullable)context;

- (NSInteger)countEntities:(NSString *_Nonnull)entityName
                filteredBy:(NSPredicate *_Nullable)predicate;

#pragma mark - UUID Handlers

+ (NSString * __nonnull)UUIDGenerator;

#pragma mark - Execute Blocks

/**
 *  <#Description#>
 *
 *  @param block      <#block description#>
 *  @param save       <#save description#>
 *  @param completion <#completion description#>
 */
- (void)executeBlock:(nullable void (^)(NSManagedObjectContext * _Nullable context))block
                save:(BOOL)save
          completion:(nullable void (^)(BOOL contextDidSave,  NSError * _Nullable error))completion;

/**
 *  <#Description#>
 *
 *  @param block <#block description#>
 *  @param save  <#save description#>
 */
- (void)executeBlock:(nullable void (^)(NSManagedObjectContext * _Nullable context))block
                save:(BOOL)save;

#pragma mark - Helpers

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (NSManagedObjectContext * _Nullable)defaultContext;

@end