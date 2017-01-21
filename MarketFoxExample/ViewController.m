//
//  ViewController.m
//  MarketFoxExample
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "ViewController.h"
#import "MarketFox.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)subscribeToMarketFox:(id)sender {
    
    [[MarketFox instance] postEvent:@"clicked_subscribe" value:@"1"];
    
}
- (IBAction)unsubscribeToMarketFox:(id)sender {
    
    [[MarketFox instance] postEvent:@"clicked_unsubscribe" value:@"1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
