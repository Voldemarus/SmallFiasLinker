//
//  AppDelegate.h
//  SmallFiasLinker
//
//  Created by Водолазкий В.В. on 24.12.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (weak) IBOutlet NSTableView *taxoTableView;
- (IBAction)taxophoneLoadPressed:(id)sender;
@property (weak) IBOutlet NSTextField *taxophoneRecordsAmount;
- (IBAction)linkFIASPressed:(id)sender;


@property (weak) IBOutlet NSTableView *fiasTableView;
- (IBAction)fiasUploadPressed:(id)sender;
- (IBAction)filerSetupPressed:(id)sender;

@property (weak) IBOutlet NSButton *filterIsOn;
- (IBAction)filterIsOnChanged:(id)sender;
@property (weak) IBOutlet NSTextField *fiasRecordCount;

@property (weak) IBOutlet NSTextField *unlinkedCount;


@end

