//
//  ArticleFormatter.m
//  Breakthrough Blog
//
//  Created by Nathan Spaun on 6/13/13.
//  Copyright (c) 2013 BACC. All rights reserved.
//

#import "ArticleFormatter.h"
#import "Note.h"

@implementation ArticleFormatter

+(NSString*)formatPostToHtml:(Post*)post
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    
	NSString *html = [NSString stringWithFormat:@"<html lang=\"en\">" \
                      "<head>" \
                      "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">" \
                      "<script type=\"text/javascript\" src=\"jquery-1.8.1.min.js\"> </script>" \
                      "<script type=\"text/javascript\" src=\"jquery.autogrowtextarea.min.js\"> </script>" \
                      "<link rel=\"stylesheet\" type=\"text/css\" href=\"blog.css\">"
                      "<meta name = \"viewport\" content = \"width = 300, initial-scale = 1.0, user-scalable = yes\">" \
                      "</head>" \
                      "<html>" \
                      "<body>" \
                      "<div> " \
                      "<h1>%@</h1>" \
                      "<subheading>BY %@</subheading>&nbsp&nbsp&nbsp&nbsp" \
                      "<subheading>%@</subheading>" \
                      "  </li><mydivider>___________________________________</mydivider> <np>%@" \
                      " <strong>Notes:</strong> </br> <ul> [raw_html_snippet id=\"baccnote\"] </ul></np> " \
                      "</br></br></br></br></br></br></br></br></br></br></br> </div>" \
                      "</body>" \
                      "</html>"
                      ,
                      post.title, [post.author uppercaseString], [formatter stringFromDate:post.postDate], post.htmlContent
                      ];
    
    html = [ArticleFormatter insertTextAreas:html withPost:post];
    
    NSLog(@"%@", html);
    
    return html;
}

+(NSString*)insertTextAreas:(NSString*)htmlIn withPost:(Post*)post
{
    
    NSUInteger count = 0, length = [htmlIn length];
    NSRange range = NSMakeRange(0, length);
    NSString *replaceMe = @"[raw_html_snippet id=\"baccnote\"]";
    NSString *mutableHtml = @"";
    NSString *jqueryString = @" <script> $(document).ready(function() { ";
    NSUInteger lastLocation = 0;
    while(range.location != NSNotFound)
    {
        range = [htmlIn rangeOfString: @"[raw_html_snippet id=\"baccnote\"]" options:0 range:range];
        if(range.location != NSNotFound)
        {
            jqueryString = [NSString stringWithFormat:@"%@ $(\"#target%d\").autoGrow(); ", jqueryString, count/2];
            NSString *lastLocationString = [[htmlIn substringFromIndex:lastLocation ] substringToIndex:(range.location - lastLocation)];
            mutableHtml = [NSString stringWithFormat:@"%@%@", mutableHtml,lastLocationString];
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            NSString *textAreaHtml;
            Note *note = [Note getNoteForPostId:post.pid andQuestion:[NSNumber numberWithInteger:count/2]];
            
            NSRange liRange = [[[htmlIn substringFromIndex:range.location] substringToIndex:replaceMe.length+7] rangeOfString:@"</li>"];
            NSRange ulRange = [[[htmlIn substringFromIndex:range.location] substringToIndex:replaceMe.length+7] rangeOfString:@"</ul>"];
            if (liRange.location == NSNotFound && ulRange.location == NSNotFound) {
                if (note) {
                    textAreaHtml = [NSString stringWithFormat:@"<ul><div5><textarea class=\"cta\" id=\"target%d\"  placeholder=\"Add your notes...\" rows=\"1\">%@</textarea></div5></ul>",count/2, note.text];
                    
                } else {
                    textAreaHtml = [NSString stringWithFormat:@"<ul><div5><textarea class=\"cta\" id=\"target%d\" placeholder=\"Add your notes...\" rows=\"1\"></textarea></div5></ul>",count/2];
                }
            } else {
            
                if (note) {
                     textAreaHtml = [NSString stringWithFormat:@"<div5><textarea class=\"cta\" id=\"target%d\"  placeholder=\"Add your notes...\" rows=\"1\">%@</textarea></div5>",count/2, note.text];
                    
                } else {
                   textAreaHtml = [NSString stringWithFormat:@"<div5><textarea class=\"cta\" id=\"target%d\" placeholder=\"Add your notes...\" rows=\"1\"></textarea></div5>",count/2];
                }
            }
            count++;

            mutableHtml = [NSString stringWithFormat:@"%@%@", mutableHtml,textAreaHtml ];
            count++;
            lastLocation = range.location;
        }
        
        

    }
    NSString *lastLocationString = [htmlIn substringFromIndex:lastLocation];
    mutableHtml = [NSString stringWithFormat:@"%@%@%@});	</script>", mutableHtml,lastLocationString,jqueryString];
    
    return mutableHtml;
}



@end
