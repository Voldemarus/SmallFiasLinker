//
//  Poselenie.m
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import "DAO.h"

@implementation Poselenie

+ (Poselenie *) getOrCreatePoselenie:(NSString *)aName forOkrug:(Okrug *)aOkrug
							  region:(Region *)aRegion inMoc:(NSManagedObjectContext *)moc
{
	if (!aName || !aOkrug || !aRegion) return nil;
	NSString *entityName = [[self class] description];
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:entityName];
	req.predicate = [NSPredicate predicateWithFormat:@"name = %@ and okrug = %@ and region = %@",aName, aOkrug, aRegion];
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
	Poselenie *newObj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:moc];
	if (newObj) {
		newObj.name = aName;
		newObj.okrug = aOkrug;
		newObj.region = aRegion;
	}
	return newObj;
}

- (NSString *) description
{
	return [NSString stringWithFormat:@"%@", self.name];
}


@end
