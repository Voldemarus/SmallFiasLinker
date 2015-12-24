//
//  Poselenie+CoreDataProperties.h
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Poselenie.h"

NS_ASSUME_NONNULL_BEGIN

@interface Poselenie (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Fias *fiasRecords;
@property (nullable, nonatomic, retain) Okrug *okrug;
@property (nullable, nonatomic, retain) Region *region;

@end

NS_ASSUME_NONNULL_END
