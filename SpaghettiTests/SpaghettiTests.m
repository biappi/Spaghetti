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
    
    fsm = [[SGMachine alloc] initWithInitialState:@"a"];
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

@end
