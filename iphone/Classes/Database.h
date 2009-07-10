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
#import "BDO.h"
#import "ActiveRecord.h"
#import "Section.h"
#import "Entry.h"


@interface Database : BDO <ActiveRecord> {
	/**
	 * All sections in the database.
	 */
	NSArray *sections;
}

@property (nonatomic, retain) NSArray *sections;

static Database *db;

/**
 * An implementation of the singleton pattern.  This variable should only ever
 * be set once after the very first request for the singleton object.
 */
+ (Database *)db;

/**
 * Finds a section from a numeric identifier.  The sections variable does not
 * need to be called first, as it will be loaded if necessary.
 */
- (Section *)sectionFromIdentifier:(NSNumber *)ident;

/**
 * Finds an entry from a numeric identifier.
 */
- (Entry *)entryFromIdentifier:(NSNumber *)ident;

/**
 * Finds all the Entry objects containing the specified name in them.  Intended
 * to only be used when searching for entries by name.  The sections variable
 * must be accessed beforehand or this method will return an empty array on any
 * input.
 */
- (NSDictionary *)entriesWithNameContaining:(NSString *)name;

- (NSArray *)entriesInSectionWithNameContaining:(NSString *)name withSection:(Section *)s;

@end
