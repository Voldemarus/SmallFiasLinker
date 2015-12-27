//
//  Fias+CoreDataProperties.h
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Fias.h"

NS_ASSUME_NONNULL_BEGIN

@class Okrug, Region, Poselenie, Taxophon;

@interface Fias (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *refID;
@property (nullable, nonatomic, retain) NSString *fias;
@property (nullable, nonatomic, retain) NSNumber *refAmount;
@property (nullable, nonatomic, retain) NSString *nasPunkt;
@property (nullable, nonatomic, retain) Okrug *okrug;
@property (nullable, nonatomic, retain) Region *region;
@property (nullable, nonatomic, retain) Poselenie *poselenie;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *taxophones;

@end

NS_ASSUME_NONNULL_END
