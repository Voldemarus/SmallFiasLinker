//
//  Fias.h
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Fias : NSManagedObject

+ (Fias *) getFiasForID:(NSString *)aFiasId inMoc:(NSManagedObjectContext *)moc;


+ (Fias *) createFiasRecordWithData:(NSArray *)aData errorifNotUnique:(BOOL)aUnique inMoc:(NSManagedObjectContext *)aMoc;

@end

NS_ASSUME_NONNULL_END

#import "Fias+CoreDataProperties.h"
