//
//  SGMachine.m
//  Spaghetti
//
//  Created by Antonio "Willy" Malara on 1/7/13.
//  Copyright (c) 2013 Antonio "Willy" Malara. All rights reserved.
//

#import "SGMachine.h"

static NSString * StateEventKey(NSString * state, NSString * event);

@implementation SGMachine
{
    NSMutableDictionary * stateTransitions;
}

- (id)init {
    NSAssert(NO, @"Use the designated initializer");
    return nil;
}

- (id)initWithInitialState:(NSString *)state {
    if ((self = [super init]) == nil)
        return nil;
    
    _state = state;
    stateTransitions = [NSMutableDictionary new];
    
    return self;
}

- (void)onEvent:(NSString *)event duringState:(NSString *)oldState transitionToState:(NSString *)newState {
    NSString * stateEventKey = StateEventKey(oldState, event);
    stateTransitions[stateEventKey] = newState;
}

- (BOOL)sendEvent:(NSString *)event {
    NSString *newState = stateTransitions[StateEventKey(_state, event)];
    
    if (newState)
        _state = newState;
    
    return (newState != nil);
}

@end

static NSString * StateEventKey(NSString * state, NSString * event) {
    return [NSString stringWithFormat:@"%@-%@", state, event];
}
