//
//  SGMachine.h
//  Spaghetti
//
//  Created by Antonio "Willy" Malara on 1/7/13.
//  Copyright (c) 2013 Antonio "Willy" Malara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGMachine : NSObject

@property (nonatomic, readonly) NSString * state;

- (id)initWithInitialState:(NSString *)state;

- (void)onEvent:(NSString *)event duringState:(NSString *)oldState transitionToState:(NSString *)newState;
- (BOOL)sendEvent:(NSString *)event;

- (NSString *)graphvizString;

@end
