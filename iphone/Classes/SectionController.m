/*
 * Copyright (c) 2009, Richard Drake
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *   1. Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 *   2. Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *   3. Neither the name of the Mobile Education Project, the University of
 *      Ontario Institute of Technology (UOIT), nor the names of its
 *      contributors may be used to endorse or promote products derived from
 *      this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
 
#import "SectionController.h"
#import "EntriesController.h"
#import "EntryController.h"
#import "Database.h"
#import "Section.h"
#import "SearchController.h"


@implementation SectionController

@synthesize data;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Sections";
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Support everything.
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (searching) {
		return [self.data.allKeys count];
	}
	
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (searching) {
		NSString *key = [self.data.allKeys objectAtIndex:section];
		return [[self.data valueForKey:key] count];
	}
	
	return [[[Database db] sections] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	if (searching) {
		NSString *key = [self.data.allKeys objectAtIndex:[indexPath section]];
		Entry *e = [[self.data valueForKey:key] objectAtIndex:[indexPath row]];
		[cell.textLabel setText:e.name];
	} else {
		Section *s = [[Database db].sections objectAtIndex:[indexPath row]];
		[cell.textLabel setText:s.name];
	}
	
    return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIViewController *cont = nil;
	
	if (searching) {
		NSString *key = [self.data.allKeys objectAtIndex:[indexPath section]];
		Entry *e = [[self.data valueForKey:key] objectAtIndex:[indexPath row]];
		cont = [[EntryController alloc] initWithEntry:e];
	} else {
		Section *s = [[Database db].sections objectAtIndex:[indexPath row]];
		cont = [[EntriesController alloc] initWithSection:s];
	}
	
	[self.navigationController pushViewController:cont animated:YES];
	[cont release];
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
	if (searching) {
		return [self.data.allKeys objectAtIndex:section];
	}
	
	return nil;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark Search bar methods

- (void)searchBar:(UISearchBar *)sb textDidChange:(NSString *)searchText {
	if ([searchText isEqualToString:@""]) {
		self.data = nil;
	} else {
		self.data = [[Database db] entriesWithNameContaining:searchText];
	}
	
	[self.tableView reloadData];
}

@end

