//
//  Protocol+Alloc.m
//  Protocol
//
//  Created by Doug Russell on 1/9/13.
//  Copyright (c) 2013 RSTL. All rights reserved.
//

#import "Protocol+Alloc.h"
#include <objc/runtime.h>

static NSMutableDictionary *_classRegistry;
static dispatch_queue_t _registry_queue;
static void _initializeRegistryIfNeeded()
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_classRegistry = [NSMutableDictionary new];
		_registry_queue = dispatch_queue_create("com.rstl.reqistry-queue", DISPATCH_QUEUE_CONCURRENT);
	});
}

static Class _lookupClassForProtocolAndInitializer(Protocol *protocol, SEL initializer)
{
	assert(protocol);
	assert(initializer);
	_initializeRegistryIfNeeded();
	const char * protocol_name = protocol_getName(protocol);
	NSString *protocolName = [[NSString alloc] initWithBytes:protocol_name length:strlen(protocol_name) encoding:NSUTF8StringEncoding];
	NSString *initializerName = NSStringFromSelector(initializer);
	NSString *classKey = [[NSString alloc] initWithFormat:@"%@%@", protocolName, initializerName];
	__block Class class;
	dispatch_sync(_registry_queue, ^{
		NSString *className = _classRegistry[classKey];
		class = NSClassFromString(className);
	});
	return class;
}

static void _registerClassAndInitializerForProtocol(Protocol *protocol, Class class, SEL initializer)
{
	assert(protocol);
	assert(class);
	assert(initializer);
	_initializeRegistryIfNeeded();
	const char * protocol_name = protocol_getName(protocol);
	NSString *protocolName = [[NSString alloc] initWithBytes:protocol_name length:strlen(protocol_name) encoding:NSUTF8StringEncoding];
	NSString *initializerName = NSStringFromSelector(initializer);
	NSString *className = NSStringFromClass(class);
	NSString *classKey = [[NSString alloc] initWithFormat:@"%@%@", protocolName, initializerName];
	dispatch_barrier_sync(_registry_queue, ^{
		// Disallow replacing a class for now, this needs more work.
		if (_classRegistry[classKey])
		{
			@throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
		}
		_classRegistry[classKey] = className;
	});
}

@implementation Protocol (Alloc)

- (id)alloc
{
	return self;
}

- (void)registerClass:(Class)class forInitializer:(SEL)initializer
{
	if (!class)
	{
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Nil class" userInfo:nil];
	}
	if (!initializer)
	{
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"NULL initializer" userInfo:nil];
	}
	_registerClassAndInitializerForProtocol(self, class, initializer);
}

// Putting forwardingTargetForSelector isn't ideal, but it works and it seems unlikely that the actual implementation is using forwarding.
// Could use a trampoline object instead to make it safer, but that has it's own drawbacks.
- (id)forwardingTargetForSelector:(SEL)aSelector
{
	Class class = _lookupClassForProtocolAndInitializer(self, aSelector);
	if (class)
	{
		id instance = [class alloc];
		// ARC autoreleases instance, so we'll retain it to make sure it gets to init +1
		CFBridgingRetain(instance);
		return instance;
	}
	return nil;
}

@end
