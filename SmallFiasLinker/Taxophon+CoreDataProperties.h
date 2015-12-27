//
//  Taxophon+CoreDataProperties.h
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Taxophon.h"

NS_ASSUME_NONNULL_BEGIN

@interface Taxophon (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *addressLine;
@property (nullable, nonatomic, retain) NSString *subjLine;
@property (nullable, nonatomic, retain) NSString *phoneNumber;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *formattedAddress;
@property (nullable, nonatomic, retain) Fias *fias;

@end

NS_ASSUME_NONNULL_END
