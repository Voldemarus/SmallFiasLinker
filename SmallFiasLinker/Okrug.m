//
//  Okrug.m
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import "Okrug.h"
#import "Fias.h"

#import "DAO.h"

@implementation Okrug


+ (Okrug *) getOrCreateOkrugForName:(NSString *)aName inMoc:(NSManagedObjectContext *)moc
{
	if (!aName) return nil;
	NSString *entityName = [[self class] description];
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:entityName];
	req.predicate = [NSPredicate predicateWithFormat:@"name = %@",aName];
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
	Okrug *newObj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:moc];
	if (newObj) {
		newObj.name = aName;
	}
	return newObj;
}



- (NSString *) description
{
	return [NSString stringWithFormat:@"%@", self.name];
}

@end
