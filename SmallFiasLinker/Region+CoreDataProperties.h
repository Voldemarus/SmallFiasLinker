//
//  Region+CoreDataProperties.h
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Region.h"

NS_ASSUME_NONNULL_BEGIN

@interface Region (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Fias *> *fiasRecords;
@property (nullable, nonatomic, retain) Okrug *okrug;
@property (nullable, nonatomic, retain) NSSet<Poselenie *> *poselenies;

@end

@interface Region (CoreDataGeneratedAccessors)

- (void)addFiasRecordsObject:(Fias *)value;
- (void)removeFiasRecordsObject:(Fias *)value;
- (void)addFiasRecords:(NSSet<Fias *> *)values;
- (void)removeFiasRecords:(NSSet<Fias *> *)values;

- (void)addPoseleniesObject:(Poselenie *)value;
- (void)removePoseleniesObject:(Poselenie *)value;
- (void)addPoselenies:(NSSet<Poselenie *> *)values;
- (void)removePoselenies:(NSSet<Poselenie *> *)values;

@end

NS_ASSUME_NONNULL_END
