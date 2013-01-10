//
//  SpaghettiTests.m
//  SpaghettiTests
//
//  Created by Antonio "Willy" Malara on 1/7/13.
//  Copyright (c) 2013 Antonio "Willy" Malara. All rights reserved.
//

#import "SpaghettiTests.h"
#import "SGMachine.h"

@implementation SpaghettiTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreation {
    SGMachine * fsm;
    
    fsm = [[SGMachine alloc] initWithName:@"test" initialState:@"a" delegate:nil];
    
    STAssertEqualObjects(@"a", fsm.state, @"State is not the initial state");
    STAssertEqualObjects(@"digraph {\n\n}\n", [fsm graphvizString], @"Graph should be empty");
    
    [fsm onEvent:@"goto_b" duringState:@"a" transitionToState:@"b"];
    STAssertEqualObjects(@"digraph {\n  \"a\" -> \"b\" [label=\"goto_b\"];\n\n}\n",
                         [fsm graphvizString],
                         @"Graph serialization do not match");

    [fsm onEvent:@"goto_a" duringState:@"b" transitionToState:@"a"];
    STAssertEqualObjects(@"digraph {\n"
                         "  \"a\" -> \"b\" [label=\"goto_b\"];\n"
                         "  \"b\" -> \"a\" [label=\"goto_a\"];\n"
                         "\n}\n",
                         [fsm graphvizString],
                         @"Graph serialization do not match");
}

- (void)testStateChanges {
    SGMachine * fsm;
    BOOL        res;
    
    fsm = [[SGMachine alloc] initWithName:@"test" initialState:@"a" delegate:nil];
    
    [fsm onEvent:@"goto_b" duringState:@"a" transitionToState:@"b"];
    [fsm onEvent:@"goto_a" duringState:@"b" transitionToState:@"a"];

    res = [fsm sendEvent:@"bla"];
    STAssertFalse(res, @"Should not react to event'bla'");
    
    res = [fsm sendEvent:@"goto_b"];
    STAssertTrue(res, @"Should switch to state for event 'goto_b'");
    STAssertEqualObjects(@"b", fsm.state, @"State should now be b");
    
    res = [fsm sendEvent:@"goto_b"];
    STAssertFalse(res, @"Should not react to event 'goto_b'");
    STAssertEqualObjects(@"b", fsm.state, @"State should be stil b");

    res = [fsm sendEvent:@"goto_a"];
    STAssertTrue(res, @"Should switch to state for event 'goto_a'");
    STAssertEqualObjects(@"a", fsm.state, @"State should now be a");
}

@end
