//
//  TableViewInterceptor.m
//  lunchSearch
//
//  Created by 小林堂太 on 2014/08/16.
//  Copyright (c) 2014年 dota.kobayashi. All rights reserved.
//

#import "TableViewInterceptor.h"

@implementation TableViewInterceptor

@synthesize receiver = _receiver;
@synthesize middleMan = _middleMan;

- (id) forwardingTargetForSelector:(SEL)aSelector {
    
	if ([_middleMan respondsToSelector:aSelector])
		return _middleMan;
	
	if ([_receiver respondsToSelector:aSelector])
		return _receiver;
    
	return	[super forwardingTargetForSelector:aSelector];
	
}

- (BOOL) respondsToSelector:(SEL)aSelector {
    
	if ([_middleMan respondsToSelector:aSelector])
		return YES;
	
	if ([_receiver respondsToSelector:aSelector])
		return YES;
	
	return [super respondsToSelector:aSelector];
	
}

@end
