//
//  Protocol+Alloc.h
//  Protocol
//
//  Created by Doug Russell on 1/9/13.
//  Copyright (c) 2013 RSTL. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <objc/Protocol.h>

//An implementation of an idea I borrowed from Rob Rix https://github.com/robrix

@interface Protocol (Alloc)

- (void)registerClass:(Class)class forInitializer:(SEL)initializer;
- (id)alloc;

@end
