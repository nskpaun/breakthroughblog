//
//  ApiHelper.m
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/20/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//


#import "ApiHelper.h"
#import "Post.h"

@implementation ApiHelper

NSString const *HTTP_PRE  =                         @"https://";
NSString const *HOST_API  =                         @"www.bacc.cc/api/app.php?";


- (ApiHelper*) init {
    return self;
}

-(void) updateDatabase {
    NSString *params = @"action=top";
    NSString *urlstring = [NSString stringWithFormat:@"%@%@%@",HTTP_PRE,HOST_API,params];
    NSMutableURLRequest* request = [NSMutableURLRequest
                                    requestWithURL: [NSURL URLWithString: urlstring]];
    [request setHTTPMethod:@"GET"];
    conn = [[NSURLConnection alloc] initWithRequest: request delegate:self];
    
}

#pragma NSUrlConnectionDelegate Methods

-(void)connection:(NSConnection*)conn didReceiveResponse:
(NSURLResponse *)response
{
    if (_receivedData == NULL) {
        _receivedData = [[NSMutableData alloc] init];
    }
    [_receivedData setLength:0];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
    else
    {
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:
(NSData *)data
{
    // Append the new data to receivedData.
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:
(NSError *)error
{
    //Naive error handling - log it!
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:
           NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&error];
    [Post loadPostsIntoDatabase:array];
    
}


@end

