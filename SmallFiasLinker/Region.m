//
//  Region.m
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import "DAO.h"

@implementation Region

+ (Region *) getOrCreateRegion:(NSString *)aName withinOkrug:(Okrug *) aOkrug inMoc:(NSManagedObjectContext *)moc
{
	if (!aName || !aOkrug) return nil;
	NSString *entityName = [[self class] description];
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:entityName];
	req.predicate = [NSPredicate predicateWithFormat:@"name = %@ and okrug = %@",
					 aName, aOkrug];
	NSError *error = nil;
	
	NSArray *result = [moc executeFetchRequest:req error:&error];
	if (!result && error) {
		[[NSNotificationCenter defaultCenter] postNotificationName:VVVCoreDataRequestError object:error];
		return nil;
	}
	if (result.count > 0) {
		return result[0];
	}
	// No record found create the new one
	Region *newObj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:moc];
	if (newObj) {
		newObj.name = aName;
		newObj.okrug = aOkrug;
	}
	return newObj;
}



- (NSString *) description
{
	return [NSString stringWithFormat:@"%@", self.name];
}

@end
