//
//  ClassCluster.m
//  Protocol
//
//  Created by Doug Russell on 1/9/13.
//  Copyright (c) 2013 RSTL. All rights reserved.
//

#import "ClassCluster.h"
#import "Protocol+Alloc.h"

@interface ClassCluster : NSObject <ClassClusterPublicInterface>

- (id)initWithTypeA:(id)a;
- (id)initWithTypeB:(id)b;

@end

@interface ConcreteSubclassA : ClassCluster

@end

@interface ConcreteSubclassB : ClassCluster

@end

@implementation ClassCluster

+ (void)load
{
	if (self == [ClassCluster class])
	{
		[@protocol(ClassClusterPublicInterface) registerClass:[ConcreteSubclassA class] forInitializer:@selector(initWithTypeA:)];
		[@protocol(ClassClusterPublicInterface) registerClass:[ConcreteSubclassB class] forInitializer:@selector(initWithTypeB:)];
	}
}

- (id)initWithTypeA:(id)a
{
	NSString *className = NSStringFromClass([self class]);
	NSString *selectorName = NSStringFromSelector(_cmd);
	@throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"*** -[ClassCluster %@]: method only defined for abstract class.  Define -[%@ %@]!]", selectorName, className, selectorName] userInfo:nil];
	return nil;
}

- (id)initWithTypeB:(id)b
{
	NSString *className = NSStringFromClass([self class]);
	NSString *selectorName = NSStringFromSelector(_cmd);
	@throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"*** -[ClassCluster %@]: method only defined for abstract class.  Define -[%@ %@]!]", selectorName, className, selectorName] userInfo:nil];
	return nil;
}

- (void)doSomething
{
	NSLog(@"Do Nothing");
}

@end

@implementation ConcreteSubclassA

- (id)initWithTypeA:(id)a
{
	self = [super init];
	if (self)
	{
		NSLog(@"A");
	}
	return self;
}

- (void)doSomething
{
	NSLog(@"Do A");
}

@end

@implementation ConcreteSubclassB

- (id)initWithTypeB:(id)b
{
	self = [super init];
	if (self)
	{
		NSLog(@"B");
	}
	return self;
}

- (void)doSomething
{
	NSLog(@"Do B");
}

@end
