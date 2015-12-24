//
//  Fias.m
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import "DAO.h"

@implementation Fias

+ (Fias *) getFiasForID:(NSString *)aFiasId inMoc:(nonnull NSManagedObjectContext *)moc
{
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[[self class] description]];
	req.predicate = [NSPredicate predicateWithFormat:@"fias = %@",aFiasId];
	NSError *error = nil;
	NSArray *result = [moc executeFetchRequest:req error:&error];
	if (!result && error) {
		[[NSNotificationCenter defaultCenter] postNotificationName:VVVCoreDataRequestError object:error];
		return nil;
	}
	if (result.count > 0) {
		return result[0];
	}
	return nil;
}

+ (Fias *) createFiasRecordWithData:(NSArray *)aData errorifNotUnique:(BOOL)aUnique inMoc:(NSManagedObjectContext *)aMoc
{
	if (!aData || aData.count != 7) {
		[[NSNotificationCenter defaultCenter] postNotificationName:VVVParserWrongFieldsNum object:aData];
		return nil;
	}
	NSInteger refId = [aData[0] integerValue];
	if (refId == 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:VVVParserWrongFieldsNum object:aData];
		return nil;
	}
	NSString *okrugName = aData[1];
	Okrug *fiasOkrug = [Okrug getOrCreateOkrugForName:okrugName inMoc:aMoc];
	if (!fiasOkrug) {
		return nil;
	}
	NSString *fiasRegionName = aData[2];
	Region *fiasRegion = [Region getOrCreateRegion:fiasRegionName
									   withinOkrug:fiasOkrug inMoc:aMoc];
	if (!fiasRegion) {
		return nil;
	}
	NSString *poselenieName = aData[3];
	Poselenie *fiasPoselok = [Poselenie getOrCreatePoselenie:poselenieName
													forOkrug:fiasOkrug
													  region:fiasRegion
													   inMoc:aMoc];
	if (!fiasPoselok) {
		return nil;
	}
	// Now check for FIAS record
	NSString *nasPunkt = aData[4];
	NSInteger taxAmount = [aData[5] integerValue];
	NSString *fiasId = aData[6];
	Fias *justPresent = [Fias getFiasForID:fiasId inMoc:aMoc];
	if (justPresent) {
		if (aUnique) {
			// check for fields
			if ([justPresent.nasPunkt isEqualToString:nasPunkt] == NO ||
				[justPresent.okrug isEqualTo:fiasOkrug] == NO ||
				[justPresent.region isEqualTo:fiasRegion] == NO ||
				[justPresent.poselenie isEqualTo:fiasPoselok] == NO) {
				NSDictionary *dict = @{
									   @"FIAS"		: justPresent,
									   @"Record"	: aData,
									   };
				
				[[NSNotificationCenter defaultCenter] postNotificationName:
				 VVVParserDuplicatedFiasID object:dict];
				return nil;
			}
		}
			// update fields
			justPresent.nasPunkt = nasPunkt;
			justPresent.refAmount = @(taxAmount);
			return justPresent;
	}
	// no record found, create the new one
	Fias *newObj = [NSEntityDescription insertNewObjectForEntityForName:[[self class] description] inManagedObjectContext:aMoc];
	if (newObj) {
		newObj.refID = @(refId);
		newObj.okrug = fiasOkrug;
		newObj.region = fiasRegion;
		newObj.poselenie = fiasPoselok;
		newObj.nasPunkt = nasPunkt;
		newObj.refAmount = @(taxAmount);
		newObj.fias = fiasId;
	}
	
	return newObj;
}


@end
