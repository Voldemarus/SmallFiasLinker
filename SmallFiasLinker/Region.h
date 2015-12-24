//
//  Region.h
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Okrug.h"

@class Fias, Okrug, Poselenie;

NS_ASSUME_NONNULL_BEGIN

@interface Region : NSManagedObject

+ (Region *) getOrCreateRegion:(NSString *)aName withinOkrug:(Okrug *)aOkrug inMoc:(NSManagedObjectContext *)moc;


@end

NS_ASSUME_NONNULL_END

#import "Region+CoreDataProperties.h"
