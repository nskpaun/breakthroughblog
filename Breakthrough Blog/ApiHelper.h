//
//  ApiHelper.h
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/20/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiHelper : NSObject {
    NSMutableData* _receivedData;
    NSURLConnection *conn;
    void (^callbackBlock)(NSArray*);
}

-(void)updateDatabase;
-(void)getPage:(int)page forCategory:(NSString*)category withCallback:(void (^)(NSArray*))callback;

@end
