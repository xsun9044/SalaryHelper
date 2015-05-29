//
//  UserPreferences.m
//  Phenom
//
//  Created by James Chung on 3/20/13.
//  Copyright (c) 2013 James Chung. All rights reserved.
//

#import "UserPreferences.h"
//#import <FacebookSDK/FacebookSDK.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface UserPreferences()

@property NSInteger userID;

@end

@implementation UserPreferences

#define USER_ID @"userID"
#define STATE_ID @"stateID"
#define STATE_NAME @"stateName"
#define USER_PIC_STRING @"profilePicString"
#define USER_NAME @"userName"
#define IS_VERIFIED @"isVerified"
#define SHOULD_REFRESH_MATCH_NOTIFICATION_PAGE @"shouldRefreshMatchNotificationPage"
#define SHOULD_REFRESH_NEWSFEED_PAGE @"shouldRefreshNewsfeedPage"
#define SHOULD_REFRESH_CHALLENGE_PLAYERS_LIST_PAGE @"shouldRefreshChallengePlayersListPage"
#define SHOULD_REFERESH_PROFILE_PAGE @"shouldRefreshProfilePage"
#define SHOULD_REFRESH_VENUES_LIST_PAGE @"shouldRefreshVenuesListPage"
#define SHOULD_REFRESH_VENUE_DETAIL_PAGE @"shouldRefreshVenueDetailaPage"
#define SHOULD_REFRESH_INDIVIDUAL_MATCH_DETAIL_PAGE @"shouldRefreshIndividualMatchDetailPage"
#define SHOULD_REFRESH_SPORT_RATINGS_SUMMARY_PAGE @"shouldRefreshSportRatingsSummaryPage"
#define SHOULD_REFRESH_ALERTS_PAGE @"shouldRefreshAlertsPage"
#define DEVICE_TOKEN @"deviceToken"
#define MATCH_NOTIFICATIONS_PAGE_STATE @"matchNotificationsPageState"
#define MATCH_NOTIFICATIONS_FORCE_SEGUE_ACTION_TYPE @"matchNotificationsForceSegueActionType"
#define MATCH_NOTIFICATIONS_FORCE_SEGUE_MATCH_ID @"matchNotificationsForceSegueMatchID"
#define MATCH_NOTIFICATIONS_FORCE_SEGUE_TEAM_ID @"matchNotificationsForceSegueTeamID"
#define MATCH_NOTIFICATIONS_FORCE_SEGUE_VENUE_ID @"matchNotificationsForceSegueVenueID"
#define USER_PHONE_NUMBER @"userPhoneNumber"
#define DID_REGISTER_MATCH_NOTIFICATIONS @"didRegisterMatchNotifications"

#define TIP_FLAG @"tipFlag"
#define LAST_READ_TIME @"lastReadTime"
#define FIRST_TIME @"first_time_in"

- (void) setZeroID // this should probably be in a convenience init
{
    [self synchronizeSession:0 withKey:USER_ID];
}

-(void) logInSession:(NSInteger) userID andPicString:(NSString *)profilePicString andUserName:(NSString *)userName andVerifiedState:(BOOL)isVerified
{
    [self synchronizeSession:userID withKey:USER_ID];
    [self synchronizeSessionPic:profilePicString withKey:USER_PIC_STRING];
    
    if (![userName isKindOfClass:[NSNull class]]) {
        [self synchronizeSessionWithStringValue:userName withKey:USER_NAME];
    }
    
    [self setVerifiedState:isVerified];
    
}

- (void) logOutSession
{
    [self synchronizeSession:0 withKey:USER_ID]; // 0 value means no ID
    [self synchronizeSessionPic:@"" withKey:USER_PIC_STRING];
    [self synchronizeSessionWithStringValue:@"" withKey:USER_NAME];
    [self setVerifiedState:NO];
    [self inLogoutProcess];
    //[FBSession.activeSession closeAndClearTokenInformation];

}

- (void)inLogoutProcess
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"logoutProcess"];
    [defaults synchronize];
}

- (void)finishLogoutProcess
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"logoutProcess"];
    [defaults synchronize];
}

- (BOOL)LogoutProcessStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"logoutProcess"];
}

-(void) synchronizeSession:(NSInteger)value
            withKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}

- (void)synchronizeSessionWithStringValue:(NSString *)value withKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

-(void) synchronizeSessionPic:(NSString *)value
                      withKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

-(NSInteger) getUserID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:USER_ID];
}

-(NSString *)getProfilePicString
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *returnString = [defaults valueForKey:USER_PIC_STRING];
    
    return returnString;
}

- (void)setProfilePicString:(NSString *)profileString
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:profileString forKey:USER_PIC_STRING];
    [defaults synchronize];
}


- (NSString *)getUserName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *returnString = [defaults valueForKey:USER_NAME];
    
    return returnString;
}

// For account verification purposes

- (void) setVerifiedState:(BOOL)value
{
    NSString *valueString;
    
    if (value)
        valueString = @"1";
    else
        valueString = @"0";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:valueString forKey:IS_VERIFIED];
    [defaults synchronize];
}


- (BOOL)isVerifiedAccount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *returnString = [defaults valueForKey:IS_VERIFIED];
    
    return [returnString boolValue];
}

// End for account verification purposes

- (void) setStateID:(NSInteger)stateID withName:(NSString *)stateName
{
    [self synchronizeSession:stateID withKey:STATE_ID]; // should rename to synchronizeIntegerwithKey
                                                        
    [self synchronizeString:stateName withKey:STATE_NAME];
}

-(void) synchronizeString:(NSString *)value
                   withKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:STATE_NAME];
    [defaults synchronize];
}

-(NSInteger) getStateID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:STATE_ID];
}

-(NSString *)getStateName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:STATE_NAME];
}

-(void)clearStateInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:STATE_ID];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:STATE_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Refresh states
// These help indicate whether certain pages should be refreshed


- (void)setMatchNotificationRefreshState:(BOOL)shouldRefreshPage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:shouldRefreshPage forKey:SHOULD_REFRESH_MATCH_NOTIFICATION_PAGE];
    [defaults synchronize];
}

- (BOOL)getMatchNotificationRefreshState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:SHOULD_REFRESH_MATCH_NOTIFICATION_PAGE];
}


- (void)setNewsfeedRefreshState:(BOOL)shouldRefreshPage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:shouldRefreshPage forKey:SHOULD_REFRESH_NEWSFEED_PAGE];
    [defaults synchronize];
}

- (BOOL)getNewsfeedRefreshState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults integerForKey:SHOULD_REFRESH_NEWSFEED_PAGE];
}

- (void)setChallengePlayersListRefreshState:(BOOL)shouldRefreshPage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:shouldRefreshPage forKey:SHOULD_REFRESH_CHALLENGE_PLAYERS_LIST_PAGE];
    [defaults synchronize];
}

- (BOOL)getChallengePlayersListRefreshState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:SHOULD_REFRESH_CHALLENGE_PLAYERS_LIST_PAGE];
}

- (void)setProfilePageRefreshState:(BOOL)shouldRefreshPage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:shouldRefreshPage forKey:SHOULD_REFERESH_PROFILE_PAGE];
    [defaults synchronize];
}

- (BOOL)getProfilePageRefreshState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:SHOULD_REFERESH_PROFILE_PAGE];
}

- (void)setAlertsPageRefreshState:(BOOL)shouldRefreshPage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:shouldRefreshPage forKey:SHOULD_REFRESH_ALERTS_PAGE];
    [defaults synchronize];
}

- (BOOL)getAlertsPageRefreshState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:SHOULD_REFRESH_ALERTS_PAGE];
}
// Venues List Page

- (void)setVenuesListPageRefreshState:(BOOL)shouldRefreshPage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:shouldRefreshPage forKey:SHOULD_REFRESH_VENUES_LIST_PAGE];
    [defaults synchronize];
}

- (BOOL)getVenuesListPageRefreshState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:SHOULD_REFRESH_VENUES_LIST_PAGE];
}

// Venue Detail Page

- (void)setVenueDetailPageRefreshState:(BOOL)shouldRefreshPage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:shouldRefreshPage forKey:SHOULD_REFRESH_VENUE_DETAIL_PAGE];
    [defaults synchronize];
}

- (BOOL)getVenueDetailPageRefreshState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:SHOULD_REFRESH_VENUE_DETAIL_PAGE];
}


// Individual Match Detail Page
- (void)setIndividualMatchPageRefreshState:(BOOL)shouldRefreshPage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:shouldRefreshPage forKey:SHOULD_REFRESH_INDIVIDUAL_MATCH_DETAIL_PAGE];
    [defaults synchronize];
}

- (BOOL)getIndividualMatchPageRefreshState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:SHOULD_REFRESH_INDIVIDUAL_MATCH_DETAIL_PAGE];

}

// For Sport Ratings Summary Page
- (void)setSportRatingsSummaryPageRefreshState:(BOOL)shouldRefreshPage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:shouldRefreshPage forKey:SHOULD_REFRESH_SPORT_RATINGS_SUMMARY_PAGE];
    [defaults synchronize];
}

- (BOOL)getSportRatingsSummaryPageRefreshState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:SHOULD_REFRESH_SPORT_RATINGS_SUMMARY_PAGE];
}

// For Push Notifications

- (void)setDeviceToken:(NSString *)deviceToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceToken forKey:DEVICE_TOKEN];
    [defaults synchronize];
}

- (NSString *)getDeviceToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:DEVICE_TOKEN];
}

// Match Notifications Page
- (void)setHasMatchNotificationsPageBeenLoadedAtLeastOnce:(BOOL)state
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:state forKey:MATCH_NOTIFICATIONS_PAGE_STATE];
    [defaults synchronize];
}



- (BOOL)getHasMatchNotificationsPageBeenLoadedAtLeastOnce
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:MATCH_NOTIFICATIONS_PAGE_STATE];
}

- (void)setMatchNotificationsForceSegueWithAction:(NSString *)action andMatchID:(NSInteger)matchID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:action forKey:MATCH_NOTIFICATIONS_FORCE_SEGUE_ACTION_TYPE];
    [defaults setInteger:matchID forKey:MATCH_NOTIFICATIONS_FORCE_SEGUE_MATCH_ID];
}

- (NSString *)getMatchNotificationsForceSegueAction
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:MATCH_NOTIFICATIONS_FORCE_SEGUE_ACTION_TYPE];
}

- (NSInteger)getMatchNotificationsForeSegueMatchID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:MATCH_NOTIFICATIONS_FORCE_SEGUE_MATCH_ID];
}

// for teams

- (void)setMatchNotificationsForceSegueWithAction:(NSString *)action andTeamID:(NSInteger)teamID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:action forKey:MATCH_NOTIFICATIONS_FORCE_SEGUE_ACTION_TYPE];
    [defaults setInteger:teamID forKey:MATCH_NOTIFICATIONS_FORCE_SEGUE_TEAM_ID];
}

- (NSInteger)getMatchNotificationsForeSegueTeamID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:MATCH_NOTIFICATIONS_FORCE_SEGUE_TEAM_ID];
}

// end for teams

// for venue checkins

- (void)setMatchNotificationsForceSegueWithAction:(NSString *)action andVenueID:(NSInteger)venueID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:action forKey:MATCH_NOTIFICATIONS_FORCE_SEGUE_ACTION_TYPE];
    [defaults setInteger:venueID forKey:MATCH_NOTIFICATIONS_FORCE_SEGUE_VENUE_ID];
}

- (NSInteger)getMatchNotificationsForeSegueVenueID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:MATCH_NOTIFICATIONS_FORCE_SEGUE_VENUE_ID];
}

- (void)setUserPhoneNumber:(NSString *)phoneNumber
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:phoneNumber forKey:USER_PHONE_NUMBER];
    [defaults synchronize];
}

- (NSString *)getUserPhoneNumber
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_PHONE_NUMBER];
}

// Add by XIN
- (void)setTipFlag:(BOOL)flag
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:flag] forKey:TIP_FLAG];
    [defaults synchronize];
}

- (BOOL)getTipFlag
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:TIP_FLAG] boolValue];
}

- (void)setLastReadTime:(NSString *)timestamp
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:timestamp forKey:LAST_READ_TIME];
    [defaults synchronize];
}

- (NSString *)getLastReadTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:LAST_READ_TIME];
}

- (void)setFirstTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:FIRST_TIME];
    [defaults synchronize];
}

- (BOOL)getFirstTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:FIRST_TIME] boolValue];
}


@end
