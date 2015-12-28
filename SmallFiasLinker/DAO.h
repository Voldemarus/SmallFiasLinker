//
//  DAO.h
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Okrug.h"
#import "Region.h"
#import "Poselenie.h"
#import "Fias.h"
#import "Taxophon.h"

extern NSString * const VVVCoreDataRequestError;
extern NSString * const VVVParserWrongFieldsNum;
extern NSString * const VVVParserDuplicatedFiasID;

@interface DAO : NSObject

// main MOC for read/write operations in foreground thread
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;



+ (DAO *) sharedInstance;


// Importer' wrappers

- (Okrug *) getOrCreateOkrug:(NSString *)aOkrug;
- (Region *) getOrCreateRegion:(NSString *)aRegion forOkrug:(Okrug *)aOkrug;
- (Poselenie *) getOrCreatePoselenie:(NSString *) aName
							forOkrug:(Okrug *)aOkrug andRegion:(Region *) aRegion;

// Data source helpers for various table representations
- (NSArray *) okrugList;
- (NSArray *)regionListForOkrug:(Okrug *)aOkrug;
- (NSArray *)poselenieListForOkrug:(Okrug *)aOkrug andRegion:(Region *)aRegion;
- (NSArray *)fiasListWithPredicate:(NSPredicate *)predicate;

- (CGFloat) badPercent;
- (NSArray *)taxophoneListWithPredicate:(NSPredicate *)predicate;
- (NSArray *)sortedTaxophoneListWithPredicate:(NSPredicate *)predicate;


@end
