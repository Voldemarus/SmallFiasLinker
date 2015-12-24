//
//  Okrug+CoreDataProperties.h
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Okrug.h"

NS_ASSUME_NONNULL_BEGIN

@interface Okrug (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Fias *> *fiasRecords;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *regions;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *poselenies;

@end

@interface Okrug (CoreDataGeneratedAccessors)

- (void)addFiasRecordsObject:(Fias *)value;
- (void)removeFiasRecordsObject:(Fias *)value;
- (void)addFiasRecords:(NSSet<Fias *> *)values;
- (void)removeFiasRecords:(NSSet<Fias *> *)values;

- (void)addRegionsObject:(NSManagedObject *)value;
- (void)removeRegionsObject:(NSManagedObject *)value;
- (void)addRegions:(NSSet<NSManagedObject *> *)values;
- (void)removeRegions:(NSSet<NSManagedObject *> *)values;

- (void)addPoseleniesObject:(NSManagedObject *)value;
- (void)removePoseleniesObject:(NSManagedObject *)value;
- (void)addPoselenies:(NSSet<NSManagedObject *> *)values;
- (void)removePoselenies:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
