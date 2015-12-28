//
//  DAO.m
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import "DAO.h"

NSString * const VVVCoreDataRequestError	=	@"VVVCoreDataRequestError";
NSString * const VVVParserWrongFieldsNum	=	@"VVVParserWrongFieldsNum";
NSString * const VVVParserDuplicatedFiasID	=	@"VVVParserDuplicatedFiasID";

@implementation DAO


+ (DAO *) sharedInstance
{
	static DAO *__dao = nil;
	if (!__dao) {
		__dao = [[DAO alloc] init];
	}
	return __dao;
}


#pragma mark -

- (Okrug *) getOrCreateOkrug:(NSString *)aOkrug
{
	return [Okrug getOrCreateOkrugForName:aOkrug
									inMoc:self.managedObjectContext];
}

- (Region *) getOrCreateRegion:(NSString *)aRegion forOkrug:(Okrug *)aOkrug
{
	return [Region getOrCreateRegion:aRegion
						 withinOkrug:aOkrug
							   inMoc:self.managedObjectContext];
}

- (Poselenie *) getOrCreatePoselenie:(NSString *) aName
							forOkrug:(Okrug *)aOkrug andRegion:(Region *) aRegion
{
	return [Poselenie getOrCreatePoselenie:aName
								  forOkrug:aOkrug
									region:aRegion
									 inMoc:self.managedObjectContext];
}


#pragma mark -

- (NSArray *) okrugList
{
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[[Okrug class] description]];
	NSError *error = nil;
	NSArray *result = [self.managedObjectContext executeFetchRequest:req error:&error];
	if (!result && error) {
		[[NSNotificationCenter defaultCenter] postNotificationName:VVVCoreDataRequestError object:error];
		return @[];
	}
	return result;
}

- (NSArray *)regionListForOkrug:(Okrug *)aOkrug
{
	if (!aOkrug) return @[];
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[[Region class] description]];
	req.predicate = [NSPredicate predicateWithFormat:@"okrug = %@",aOkrug];
	NSError *error = nil;
	NSArray *result = [self.managedObjectContext executeFetchRequest:req error:&error];
	if (!result && error) {
		[[NSNotificationCenter defaultCenter] postNotificationName:VVVCoreDataRequestError object:error];
		return @[];
	}
	return result;
}

- (NSArray *)poselenieListForOkrug:(Okrug *)aOkrug andRegion:(Region *)aRegion
{
	if (!aOkrug || !aRegion) return @[];
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[[Poselenie class] description]];
	req.predicate = [NSPredicate predicateWithFormat:@"okrug = %@ and region = %@",
					 aOkrug, aRegion];
	NSError *error = nil;
	NSArray *result = [self.managedObjectContext executeFetchRequest:req error:&error];
	if (!result && error) {
		[[NSNotificationCenter defaultCenter] postNotificationName:VVVCoreDataRequestError object:error];
		return @[];
	}
	return result;
	
}

- (NSArray *)fiasListWithPredicate:(NSPredicate *)predicate
{
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[[Fias class] description]];
	req.predicate = predicate;
	NSError *error = nil;
	NSArray *result = [self.managedObjectContext executeFetchRequest:req error:&error];
	if (!result && error) {
		[[NSNotificationCenter defaultCenter] postNotificationName:VVVCoreDataRequestError object:error];
		return @[];
	}
	return result;
}

#pragma mark -

- (CGFloat) badPercent
{
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[[Taxophon class] description]];
	req.predicate = nil;
	NSInteger total = [self.managedObjectContext countForFetchRequest:req error:nil];
	if (total > 0) {
		req.predicate = [NSPredicate predicateWithFormat:@"fias != NULL"];
		NSError *error = nil;
		NSInteger empty = [self.managedObjectContext countForFetchRequest:req error:&error];
		if (error) {
			[[NSNotificationCenter defaultCenter] postNotificationName:VVVCoreDataRequestError object:error];
			NSLog(@"req = %@ error = %@", req, [error localizedDescription]);
			return 100.0;
		}
		CGFloat result = empty ;
		return result;
		
	}
	return 100.0;
}

- (NSArray *)taxophoneListWithPredicate:(NSPredicate *)predicate
{
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[[Taxophon class] description]];
	req.predicate = predicate;
	NSError *error = nil;
	NSArray *result = [self.managedObjectContext executeFetchRequest:req error:&error];
	if (!result && error) {
		[[NSNotificationCenter defaultCenter] postNotificationName:VVVCoreDataRequestError object:error];
		return @[];
	}
	return result;
	
}

- (NSArray *)sortedTaxophoneListWithPredicate:(NSPredicate *)predicate
{
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[[Taxophon class] description]];
	req.predicate = predicate;
	req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"subjLine" ascending:YES]];
	NSError *error = nil;
	NSArray *result = [self.managedObjectContext executeFetchRequest:req error:&error];
	if (!result && error) {
		[[NSNotificationCenter defaultCenter] postNotificationName:VVVCoreDataRequestError object:error];
		return @[];
	}
	return result;
	

}

@end
