//
//  main.m
//  Protocol
//
//  Created by Doug Russell on 1/9/13.
//  Copyright (c) 2013 RSTL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocol+Alloc.h"
#import "ClassCluster.h"

int main(int argc, const char * argv[])
{
	@autoreleasepool {
		id clusterA = [[@protocol(ClassClusterPublicInterface) alloc] initWithTypeA:nil];
		[clusterA doSomething];
		id clusterB = [[@protocol(ClassClusterPublicInterface) alloc] initWithTypeB:nil];
		[clusterB doSomething];
	}
    return 0;
}
