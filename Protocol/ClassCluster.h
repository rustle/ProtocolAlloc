//
//  ClassCluster.h
//  Protocol
//
//  Created by Doug Russell on 1/9/13.
//  Copyright (c) 2013 RSTL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ClassClusterPublicInterface <NSObject>
@required
- (id)initWithTypeA:(id)a;
- (id)initWithTypeB:(id)b;
- (void)doSomething;
@end
