//
//  SGMachine.m
//  Spaghetti
//
//  Created by Antonio "Willy" Malara on 1/7/13.
//  Copyright (c) 2013 Antonio "Willy" Malara. All rights reserved.
//

#import "SGMachine.h"

// Thanks SO! http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown

#define SuppressPerformSelectorLeakWarning(Stuff) \
        do { \
            _Pragma("clang diagnostic push") \
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
            Stuff; \
            _Pragma("clang diagnostic pop") \
        } while (0)

static NSString * StateEventKey                  (NSString * state, NSString * event);
static SEL        DelegateDidChangeStateSelector (NSString * name,  NSString * state);

@implementation SGMachine
{
    NSString            * name;
    NSMutableString     * adjacencyGraph;
    NSMutableDictionary * stateTransitions;
    
    __unsafe_unretained id delegate;
}

- (id)init {
    NSAssert(NO, @"Use the designated initializer");
    return nil;
}

- (id)initWithName:(NSString *)theName
      initialState:(NSString *)state
          delegate:(id)theDelegate;
{
    if ((self = [super init]) == nil)
        return nil;
    
    name             = theName;
    delegate         = theDelegate;
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
    
    if (newState) {
        _state = newState;
        
        SEL didChange = DelegateDidChangeStateSelector(name, newState);
        if ([delegate respondsToSelector:didChange])
            SuppressPerformSelectorLeakWarning([delegate performSelector:didChange withObject:event]);
    }
    
    return (newState != nil);
}

- (NSString *)graphvizString {
    return [NSString stringWithFormat:@"digraph {\n%@\n}\n", adjacencyGraph];
}

@end

static NSString * StateEventKey(NSString * state, NSString * event) {
    return [NSString stringWithFormat:@"%@-%@", state, event];
}

static SEL DelegateDidChangeStateSelector(NSString * name,  NSString * state) {
    return NSSelectorFromString([NSString stringWithFormat:@"stateMachine_%@_didChangeToState_%@:", name, state]);
}
