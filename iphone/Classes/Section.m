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

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"
#import "Database.h"
#import "DatabaseHelper.h"
#import "Section.h"
#import "Entry.h"


@implementation Section

@synthesize key, entries;

- (id)initWithIdentifier:(NSNumber *)ident {
	if (self = (Section *)[super initWithIdentifier:ident]) {
		[self load];
	}
	
	return self;
}

- (void)load {
	if (!isGhost) return;
	
	// Grab all of the data for this particular section.
	NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM Sections WHERE id=%@", identifier];
	
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2([DatabaseHelper getDatabase], [query UTF8String], -1, &statement, NULL) != SQLITE_OK) {
		NSAssert(0, @"Query did not successfully complete.");
	}
	
	if (sqlite3_step(statement) == SQLITE_ROW) {
		self.key = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
		self.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
	}
	
	// Figure out which entries belong to this section.
	sqlite3_reset(statement);
	int os_id = [[NSUserDefaults standardUserDefaults] integerForKey:@"os_id_value"];
	query = [[NSString alloc] initWithFormat:@"SELECT id FROM Entries WHERE section_id=%@ AND os_id=%d ORDER BY name", identifier, os_id];
	
	if (sqlite3_prepare_v2([DatabaseHelper getDatabase], [query UTF8String], -1, &statement, NULL) != SQLITE_OK) {
		NSAssert(0, @"Query did not successfully complete.");
	}
	
	NSMutableArray *newEntries = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(statement) == SQLITE_ROW) {
		// Something's trying to release this NSNumber object.  Retain it so it doesn't disappear.
		NSNumber *num = [[NSNumber numberWithInt:(int)sqlite3_column_int(statement, 0)] retain];
		Entry *e = [[Entry alloc] initWithIdentifier:num];
		[newEntries addObject:e];
	}
	
	self.entries = newEntries;
	
	[super load];
}

@end
