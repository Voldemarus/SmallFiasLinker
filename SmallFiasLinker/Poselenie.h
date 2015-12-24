//
//  Poselenie.h
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Fias, Okrug, Region;

NS_ASSUME_NONNULL_BEGIN

@interface Poselenie : NSManagedObject

+ (Poselenie *) getOrCreatePoselenie:(NSString *)aName forOkrug:(Okrug *)aOkrug
							  region:(Region *)aRegion inMoc:(NSManagedObjectContext *)moc;

@end

NS_ASSUME_NONNULL_END

#import "Poselenie+CoreDataProperties.h"
