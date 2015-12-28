//
//  AppDelegate.m
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import "AppDelegate.h"
#import "DAO.h"


NSString * const VVVInternalAddresLoad		=	@"Pip1";

@interface AppDelegate () {
	NSArray *allLinedStrings;
	NSInteger lineIndex;
	
	NSMutableArray *fiasArray;
	NSMutableArray *taxoArray;
}

@property (weak) IBOutlet NSWindow *window;

- (IBAction)saveAction:(id)sender;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Init DAO and database connection
	[DAO sharedInstance].managedObjectContext = self.managedObjectContext;
	
	fiasArray = [[NSMutableArray alloc] initWithArray:[[DAO sharedInstance] fiasListWithPredicate:nil]];
	self.fiasRecordCount.stringValue = [NSString stringWithFormat:@"Всего записей: %lu",fiasArray.count];

	for (NSTableColumn *tableColumn in self.fiasTableView.tableColumns ) {
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:tableColumn.identifier ascending:YES selector:@selector(compare:)];
		[tableColumn setSortDescriptorPrototype:sortDescriptor];
	}
	[self.fiasTableView reloadData];
	
	taxoArray = [[NSMutableArray alloc] initWithArray:[[DAO sharedInstance] taxophoneListWithPredicate:nil]];
	
	self.taxophoneRecordsAmount.stringValue = [NSString stringWithFormat:@"Всего записей: %lu",taxoArray.count];

	float badPercent = [DAO sharedInstance].badPercent;
	self.unlinkedCount.stringValue = [NSString stringWithFormat:@"Привязано: %.0f объектов",badPercent];

	for (NSTableColumn *tableColumn in self.taxoTableView.tableColumns ) {
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:tableColumn.identifier ascending:YES selector:@selector(compare:)];
		[tableColumn setSortDescriptorPrototype:sortDescriptor];
	}
	[self.taxoTableView reloadData];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(processAddressLoading:)
			   name:VVVInternalAddresLoad object:nil];
	
	
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

#pragma mark - Core Data stack

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "geomatix.cz.SmallFiasLinker" in the user's Application Support directory.
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"geomatix.cz.SmallFiasLinker"];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SmallFiasLinker" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    BOOL shouldFail = NO;
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    // Make sure the application files directory is there
    NSDictionary *properties = [applicationDocumentsDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    if (properties) {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            failureReason = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationDocumentsDirectory path]];
            shouldFail = YES;
        }
    } else if ([error code] == NSFileReadNoSuchFileError) {
        error = nil;
        [fileManager createDirectoryAtPath:[applicationDocumentsDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (!shouldFail && !error) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *url = [applicationDocumentsDirectory URLByAppendingPathComponent:@"OSXCoreDataObjC.storedata"];
        if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
            coordinator = nil;
        }
        _persistentStoreCoordinator = coordinator;
    }
    
    if (shouldFail || error) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        if (error) {
            dict[NSUnderlyingErrorKey] = error;
        }
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

#pragma mark - Core Data Saving and Undo support

- (IBAction)saveAction:(id)sender {
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    NSError *error = nil;
    if ([[self managedObjectContext] hasChanges] && ![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    return [[self managedObjectContext] undoManager];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertFirstButtonReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}


#pragma mark -


- (IBAction)fiasUploadPressed:(id)sender
{
	// Запрашиваем файл, внешний по отношению к проекту, в котором хранятся данные ФИАС в CSVформате
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	openPanel.canChooseDirectories = NO;
	openPanel.canChooseFiles = YES;
	
	[openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
		if (result == NSFileHandlingPanelOKButton) {
			if (openPanel.URL) {
				// файл выбран!
				// 1) Удаляем все данные из ФИАС
				NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Fias"];
				NSError *error = nil;
				NSArray *res = [self.managedObjectContext executeFetchRequest:req error:&error];
				if (!error) {
					for (Fias *f in res) {
						[self.managedObjectContext deleteObject:f];
					}
				} else {
					NSAlert *alert = [NSAlert alertWithError:error];
					[alert runModal];
				}
				// 2. Начинаем обработку входного массива из файла в csv формате
				
				
				NSString* fileContents =
				[NSString stringWithContentsOfURL:openPanel.URL encoding:NSUTF8StringEncoding error:&error];
				if (error) {
					NSLog(@"Ошибка при чтении файла - %@",[error localizedDescription]);
					exit(1);
				}
				
				// first, separate by new line
				@autoreleasepool {
					allLinedStrings =
					[fileContents componentsSeparatedByCharactersInSet:
					 [NSCharacterSet characterSetWithCharactersInString:@",\n"]];
					lineIndex = 0;
					NSInteger totalRecords = 0;
					for (NSString *line in allLinedStrings) {
						
						NSArray *decomposed = [line componentsSeparatedByString:@";"];
						if (decomposed.count == 7) {
							NSInteger check = [decomposed[0] integerValue];
							if (check > 0) {
								Fias *newFias = [Fias createFiasRecordWithData:decomposed errorifNotUnique:YES inMoc:self.managedObjectContext];
								if (newFias) {
									lineIndex++;
									if (lineIndex >= 500) {
										[self.managedObjectContext save:&error];
										totalRecords += lineIndex;
										lineIndex = 0;
										NSLog(@"Загружено - %lu записей", totalRecords);
								
									}
								}
							}
						}
					}
					allLinedStrings = nil;
					[self.managedObjectContext save:&error];
				}
				[fiasArray removeAllObjects];
				[fiasArray addObjectsFromArray:[[DAO sharedInstance] fiasListWithPredicate:nil]];
				self.filterIsOn.state = NSOffState;
				self.fiasRecordCount.stringValue = [NSString stringWithFormat:@"Всего записей: %lu",fiasArray.count];
				[self.fiasTableView reloadData];
		}
	}
	 }];

}

- (IBAction)filerSetupPressed:(id)sender
{
	
}

- (IBAction)filterIsOnChanged:(id)sender
{
	
}

#pragma mark - Table delegate -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	if (tableView == self.fiasTableView) {
		return fiasArray.count;
	} else if (tableView == self.taxoTableView) {
		return taxoArray.count;
	}
	return 0;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	// The return value is typed as (id) because it will return a string in most cases.
	id returnValue=nil;
 
	// The column identifier string is the easiest way to identify a table column.
	NSString *columnIdentifer = [aTableColumn identifier];
 
	if (aTableView == self.fiasTableView) {
		Fias *rec = fiasArray[rowIndex];
		if ([columnIdentifer isEqualToString:@"refID"]) {
			returnValue = [NSString stringWithFormat:@"%@", rec.refID];
		} else if ([columnIdentifer isEqualToString:@"fias"]) {
			returnValue = rec.fias;
		} else if ([columnIdentifer isEqualToString:@"okrug.name"]) {
			returnValue = rec.okrug.name;
		} else if ([columnIdentifer isEqualToString:@"region.name"]) {
			returnValue = rec.region.name;
		} else if ([columnIdentifer isEqualToString:@"poselenie.name"]) {
			returnValue = rec.poselenie.name;
		} else if ([columnIdentifer isEqualToString:@"nasPunkt"]) {
			returnValue = rec.nasPunkt;
		} else if ([columnIdentifer isEqualToString:@"refAmount"]) {
			returnValue = [NSString stringWithFormat:@"%@", rec.refAmount];
		}
	} else if (aTableView == self.taxoTableView) {
		Taxophon *tax = taxoArray[rowIndex];
		if ([columnIdentifer isEqualToString:@"fias.fias"]) {
			returnValue = tax.fias.fias;
		} else if ([columnIdentifer isEqualToString:@"formattedAddess"]) {
			returnValue = tax.formattedAddress;
		} else if ([columnIdentifer isEqualToString:@"latitude"]) {
			double lat = [tax.latitude doubleValue];
			if (lat < 0.001) {
				returnValue = @"Нет данных";
			} else
				returnValue = [NSString stringWithFormat:@"%.3f",lat];
		} else if ([columnIdentifer isEqualToString:@"longitude"]) {
			double lon = [tax.latitude doubleValue];
			if (lon < 0.001) {
				returnValue = @"Нет данных";
			} else
				returnValue = [NSString stringWithFormat:@"%.3f",lon];
		} else if ([columnIdentifer isEqualToString:@"phoneNumber"]) {
			returnValue = tax.phoneNumber;
		} else if ([columnIdentifer isEqualToString:@"subjLine"]) {
			returnValue = tax.subjLine;
		} else if ([columnIdentifer isEqualToString:@"addressLine"]) {
			returnValue = tax.addressLine;
		}
		
		if (!returnValue) {
			returnValue = @"Нет данных";
		}
	}
	
	return returnValue;
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
	if (tableView == self.fiasTableView) {
		[fiasArray sortUsingDescriptors: [tableView sortDescriptors]];
	} else if (tableView == self.taxoTableView) {
		[taxoArray sortUsingDescriptors:[tableView sortDescriptors]];
	}
	[tableView reloadData];
}

- (IBAction)taxophoneLoadPressed:(id)sender
{
	// Запрашиваем файл, внешний по отношению к проекту, в котором хранятся данные ФИАС в CSVформате
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	openPanel.canChooseDirectories = NO;
	openPanel.canChooseFiles = YES;
	
	[openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
		if (result == NSFileHandlingPanelOKButton) {
			if (openPanel.URL) {
				[[NSNotificationCenter defaultCenter] postNotificationName:VVVInternalAddresLoad object:openPanel.URL];
			}
		}
	}];
	

}

- (void) processAddressLoading:(NSNotification *) note
{
	NSURL *urlToLoad = [note object];
	
	// файл выбран!
	// 1) Удаляем все данные из ФИАС
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Taxophon"];
	NSError *error = nil;
	NSArray *res = [self.managedObjectContext executeFetchRequest:req error:&error];
	if (!error) {
		for (Taxophon *f in res) {
			[self.managedObjectContext deleteObject:f];
		}
	} else {
		NSAlert *alert = [NSAlert alertWithError:error];
		[alert runModal];
	}
	// 2. Начинаем обработку входного массива из файла в csv формате
	
	
	NSString* fileContents =
	[NSString stringWithContentsOfURL:urlToLoad encoding:NSUTF8StringEncoding error:&error];
	if (error) {
		NSLog(@"Ошибка при чтении файла - %@",[error localizedDescription]);
		exit(1);
	}
	
	// first, separate by new line
	@autoreleasepool {
		allLinedStrings =
		[fileContents componentsSeparatedByCharactersInSet:
		 [NSCharacterSet characterSetWithCharactersInString:@"\n"]];
		lineIndex = 0;
		NSInteger totalRecords = 0;
		for (NSString *line in allLinedStrings) {
			
			NSArray *decomposed = [line componentsSeparatedByString:@","];
			if (decomposed.count == 3) {
				BOOL check = ! [decomposed[0] isEqualToString:@"\"subj_name\""];
				if (check ) {
					Taxophon *newTax = [Taxophon getOrCreateRecordForData:decomposed inMoc:self.managedObjectContext];
					if (newTax) {
						lineIndex++;
						if (lineIndex >= 500) {
							[self.managedObjectContext save:&error];
							totalRecords += lineIndex;
							lineIndex = 0;
							NSLog(@"Загружено - %lu записей", totalRecords);
							
						}
					}
				}
			}
		}
		allLinedStrings = nil;
		[self.managedObjectContext save:&error];
	}
	[taxoArray removeAllObjects];
	[taxoArray addObjectsFromArray:[[DAO sharedInstance] fiasListWithPredicate:nil]];
	self.taxophoneRecordsAmount.stringValue = [NSString stringWithFormat:@"Всего записей: %lu",taxoArray.count];
	[self.taxoTableView reloadData];
}



- (IBAction)linkFIASPressed:(id)sender
{
	NSArray *stopWords = @[ @"р-н", @"п.", @"с.", @"СТС", @"ул.", @"LIN", @"ст.",
							@"городской", @"округ", @"г."];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"fias = NULL"];
	NSArray *notConnectedd = [[DAO sharedInstance] sortedTaxophoneListWithPredicate:pred];
	NSLog(@"Найдено записей для обработки - %lu",notConnectedd.count);
	NSInteger foundCount = 0;
	NSInteger stepCount = 0;
	NSString *previousOkrugName = @"";
	NSArray *okrugList = @[];
	NSInteger notConnectedCount = notConnectedd.count;
	BOOL cityMode = NO;
	for (NSInteger currentIndex = 0; currentIndex < notConnectedCount; currentIndex++) {
		// для гарантии правильной последовательности перебора, упорядоченной по
		// округам
		Taxophon *taxo = notConnectedd[currentIndex];
		stepCount++;
//		NSLog(@"Taxo = %@", taxo.addressLine);
		if (!taxo.fias) {
			// ковыряемся только с непривязанными адресами
			// 1) Выбираем записи для которых есть полное совпадение по названию края/округа
			//    Разумеется без учета регистра
			
			if ([taxo.subjLine isEqualToString:previousOkrugName] == NO) {
				for (Fias *f in okrugList) {
					[self.managedObjectContext refreshObject:f mergeChanges:NO];
				}
				okrugList = nil;
				NSPredicate *pred = [NSPredicate predicateWithFormat:@"okrug.name like [cd] %@", taxo.subjLine];
				//
				// С городами все непросто
				//
				cityMode = NO;
				NSString *addrLineUp = [taxo.addressLine uppercaseString];
				if ([addrLineUp containsString:@"БАРНАУЛ"]) {
					NSLog(@"###");
				}
				
				if ([addrLineUp containsString:@"ГОРОДСКОЙ ОКРУГ"]) {
					pred = [NSPredicate predicateWithFormat:@"okrug.name like [cd] %@ AND region.name like [cd] %@", taxo.subjLine, @"* ГОРОД"];
					cityMode = YES;
				}
				
				
				okrugList = [[DAO sharedInstance] fiasListWithPredicate:pred];
				previousOkrugName = taxo.subjLine;
			}
//			NSLog(@"subjLine = %@ -> okrugList = %@", taxo.subjLine, okrugList);
			if (okrugList.count > 0) {
				// Ищем в данном округе
				NSArray *components = [taxo.addressLine componentsSeparatedByString:@" "];
				NSMutableArray *measure = [[NSMutableArray alloc] initWithCapacity:components.count];
				// Отстреливаем стоп-слова и ненужные компоненты
				for (NSString *word in components) {
					if ([word integerValue] == 0) {
						BOOL fundStop = NO;
						for ( NSString *stopWord in stopWords) {
							if ([word isEqualToString:stopWord]) {
								fundStop = YES;
								break;
							}
						}
						if (!fundStop) {
							[measure addObject:[word uppercaseString]];
						}
					}
				}
				// 2)	Используем полученный набор как список слов, которые должны встречаться
				//		в названиях классификатора
				for (Fias *fiasRecord in okrugList) {
					NSString *fiasRegion = [fiasRecord.region.name uppercaseString];
					if (cityMode) {
						// с пробелом, чтобы не прибить СТАРГОРОД
						fiasRegion = [fiasRegion stringByReplacingOccurrencesOfString:@" ГОРОД" withString:@""];
						fiasRegion = [fiasRegion stringByReplacingOccurrencesOfString:@"ГОРОД " withString:@""];
					} else {
						fiasRegion = [fiasRegion stringByReplacingOccurrencesOfString:@" РАЙОН" withString:@""];
					}
					fiasRegion = [fiasRegion stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

					BOOL regionFound = NO;
//					BOOL poselokFound = NO;
					BOOL seloFound = NO;
					if (fiasRegion && fiasRegion.length > 3) {
						// ищем название района в списке признаков
						for (NSString *mw in measure) {
							if ([mw isEqualToString:fiasRegion]) {
								regionFound = YES;
								if (cityMode) {
									NSLog(@"Найден город - %@", fiasRegion);
								}
								break;
							}
						}
					} else {
						regionFound = YES;		// регион не задан, считаем что совпало
					}
					if (regionFound) {
//						NSString *fiasPoselok = [fiasRecord.poselenie.name uppercaseString];
//						fiasPoselok = [fiasPoselok stringByReplacingOccurrencesOfString:@"СЕЛЬСКОЕ ПОСЕЛЕНИЕ "withString:@""];
//						fiasPoselok = [fiasPoselok stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//						if (fiasPoselok && fiasPoselok.length > 3) {
//							// теперь ищем название поселения
//							for (NSString *mw in measure) {
//								if ([mw isEqualToString:fiasPoselok]) {
//									poselokFound = YES;
//									NSLog(@"найден поселок - %@",fiasPoselok);
//									break;
//								}
//							}
//						} else {
//							poselokFound = YES;
//						}
//					}
//					if (poselokFound) {
						NSString *fiasSelo = [fiasRecord.nasPunkt uppercaseString];
						if (cityMode) {
							fiasSelo = [fiasSelo stringByReplacingOccurrencesOfString:@" ГОРОД" withString:@""];
						} else {
							fiasSelo = [fiasSelo stringByReplacingOccurrencesOfString:@" СЕЛО" withString:@""];
							fiasSelo = [fiasSelo stringByReplacingOccurrencesOfString:@"СЕЛО " withString:@""];
							fiasSelo = [fiasSelo stringByReplacingOccurrencesOfString:@"ДЕРЕВНЯ " withString:@""];
							fiasSelo = [fiasSelo stringByReplacingOccurrencesOfString:@" ДЕРЕВНЯ" withString:@""];
							fiasSelo = [fiasSelo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
						}
						if (fiasSelo && fiasSelo.length > 1) {
							// теперь ищем название деревни, может быть из двух букв - Ая
							for (NSString *mw in measure) {
								NSString *mwt = [mw stringByReplacingOccurrencesOfString:@"Д." withString:@""];
								if ([mwt isEqualToString:fiasSelo]) {
									seloFound = YES;
									NSLog(@"Найдено село - %@", fiasSelo);
									
									break;
								}
							}
						} else {
							seloFound = YES;
						}
					}
					//
					// Принимаем решение - если все три параметра совпали (или те, что
					// доступны для сравнения, устанавливаем привязку
					//
//					NSLog(@"address line - %@",taxo.addressLine);
					BOOL fiasFound = regionFound  && seloFound;
					// и собственно привязка
					if (fiasFound) {
						taxo.fias = fiasRecord;
						[self.managedObjectContext save:nil];
						foundCount++;
						NSLog(@"Привязан! - %lu/%lu ==> %.3f%%", foundCount, stepCount, 100.0*foundCount/stepCount);
						NSLog(@"fias - %@ %@ %@ %@", fiasRecord.okrug.name, fiasRecord.region.name, fiasRecord.poselenie.name, fiasRecord.nasPunkt);
						break;
					}
				}
			}
			
		}
		[self.managedObjectContext refreshObject:taxo mergeChanges:NO];
	}
	[self.taxoTableView reloadData];
	NSLog(@"Проход закончен!");
}

- (IBAction)removeFIASpressed:(id)sender
{
	for (Taxophon *t in taxoArray) {
		t.fias = nil;
	}
	[self.managedObjectContext save:nil];
	[self.taxoTableView reloadData];
}
@end
