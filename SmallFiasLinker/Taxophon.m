//
//  Taxophon.m
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import "DAO.h"

@implementation Taxophon

+ (Taxophon *) getOrCreateRecordForData:(NSArray *)data inMoc:(NSManagedObjectContext *)moc
{
	if (data.count != 3) return nil;
	NSString *okrugName = [(NSString *)data[0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
	NSString *addrString = [(NSString *)data[1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
	NSString *phoneString = [(NSString *)data[2] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
	
	NSString *className = [[self class] description];
	
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:className];
	req.predicate = [NSPredicate predicateWithFormat:@"subjLine = %@ and addressLine = %@ and phoneNumber = %@",
					 okrugName, addrString, phoneString];
	NSError *error = nil;
	NSArray *result = [moc executeFetchRequest:req error:&error];
	if (!result && error) {
		[[NSNotificationCenter defaultCenter] postNotificationName:VVVCoreDataRequestError object:error];
		return nil;
	}
	if (result.count == 1) {
		Taxophon *t = result[0];
		// Это не ошибка - этот адрес уже привязан! Стараемся избежать накопления глупостей
		if (t.fias) return nil;
	}
	Taxophon *t = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:moc];
	if (t) {
		t.subjLine = okrugName;
		t.addressLine = addrString;
		t.phoneNumber = phoneString;
	}
	return t;
}


- (NSString *) description
{
	return [NSString stringWithFormat:@"%@ -> %@ :: %@, :: %@",
			self.phoneNumber, self.formattedAddress, self.subjLine, self.addressLine ];
}

@end
