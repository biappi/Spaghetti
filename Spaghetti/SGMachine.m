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
    NSMutableString     * adjacencyGraph;
    NSMutableDictionary * stateTransitions;
}

- (id)init {
    NSAssert(NO, @"Use the designated initializer");
    return nil;
}

- (id)initWithInitialState:(NSString *)state {
    if ((self = [super init]) == nil)
        return nil;
    
    stateTransitions = [NSMutableDictionary new];
    adjacencyGraph   = [NSMutableString new];
    
    _state = state;
    
    return self;
}

- (void)onEvent:(NSString *)event duringState:(NSString *)oldState transitionToState:(NSString *)newState {
    NSString * stateEventKey = StateEventKey(oldState, event);
    stateTransitions[stateEventKey] = newState;
    [adjacencyGraph appendFormat:@"  \"%@\" -> \"%@\" [label=\"%@\"];\n", oldState, newState, event];
}

- (BOOL)sendEvent:(NSString *)event {
    NSString *newState = stateTransitions[StateEventKey(_state, event)];
    
    if (newState)
        _state = newState;
    
    return (newState != nil);
}

- (NSString *)graphvizString {
    return [NSString stringWithFormat:@"digraph {\n%@\n}\n", adjacencyGraph];
}

@end

static NSString * StateEventKey(NSString * state, NSString * event) {
    return [NSString stringWithFormat:@"%@-%@", state, event];
}
