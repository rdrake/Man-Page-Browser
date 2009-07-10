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
#import "Entry.h"
#import "Section.h"


@implementation Database

@synthesize sections;

+ (Database *)db {
	if (db == nil) {
		db = [[Database alloc] init];
		[db load];
	}
	
	return db;
}

- (Section *)sectionFromIdentifier:(NSNumber *)ident {
	for (Section *s in [self sections]) {
		if (s.identifier == ident)
			return s;
	}
	
	//return [[Section alloc] initWithIdentifier:ident];
	
	return nil;
}

- (Entry *)entryFromIdentifier:(NSNumber *)ident {
	for (Section *s in [self sections]) {
		for (Entry *e in s.entries) {
			if (e.identifier == ident)
				return e;
		}
	}
	
	//return [[Entry alloc] initWithIdentifier:ident];
	
	return nil;
}

- (void)load {
	if (!isGhost) return;
	
	// Load ghosts for all of the sections.
	NSString *query = @"SELECT id FROM Sections ORDER BY description";
	
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2([DatabaseHelper getDatabase], [query UTF8String], -1, &statement, NULL) != SQLITE_OK) {
		NSAssert(0, @"Query did not successfully complete.");
	}
	
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(statement) == SQLITE_ROW) {
		NSNumber *num = [NSNumber numberWithInt:(int)sqlite3_column_int(statement, 0)];
		Section *s = [[Section alloc] initWithIdentifier:num];
		//[s retain];
		[arr addObject:s];
	}
	
	sections = arr;
	
	[super load];
}

- (NSDictionary *)entriesWithNameContaining:(NSString *)n {
	NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
	
	for (Section *s in [self sections]) {
		NSArray *foundEntries = [self entriesInSectionWithNameContaining:n withSection:s];
		
		if ([foundEntries count] > 0) {
			[ret setValue:foundEntries forKey:s.name];
		}
	}
	
	return ret;
}

- (NSArray *)entriesInSectionWithNameContaining:(NSString *)n withSection:(Section *)s {
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	
	for (Entry *e in s.entries) {
		if ([[e name] rangeOfString:n options:NSCaseInsensitiveSearch].location != NSNotFound) {
			[arr addObject:e];
		}
	}
	
	return arr;
}

@end
