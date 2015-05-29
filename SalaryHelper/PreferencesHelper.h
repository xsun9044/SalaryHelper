//
//  UserPreferences.h
//  Phenom
//
//  Created by James Chung on 3/20/13.
//  Copyright (c) 2013 James Chung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPreferences : NSObject


-(void) logInSession:(NSInteger) userID andPicString:(NSString *)profilePicString andUserName:(NSString *)userName andVerifiedState:(BOOL)isVerified;
-(void)logOutSession;
-(NSInteger)getUserID;
- (void) setZeroID;

-(NSInteger) getStateID;
-(NSString *)getStateName;
- (void) setStateID:(NSInteger)stateID withName:(NSString *)stateName;
-(void)clearStateInfo;

-(NSString *)getProfilePicString;
- (void)setProfilePicString:(NSString *)profileString;
- (NSString *)getUserName;

- (void) setVerifiedState:(BOOL)value;
- (BOOL)isVerifiedAccount;

- (void)setMatchNotificationRefreshState:(BOOL)shouldRefreshPage;
- (BOOL)getMatchNotificationRefreshState;

- (void)setNewsfeedRefreshState:(BOOL)shouldRefreshPage;
- (BOOL)getNewsfeedRefreshState;

- (void)setChallengePlayersListRefreshState:(BOOL)shouldRefreshPage;
- (BOOL)getChallengePlayersListRefreshState;

- (void)setProfilePageRefreshState:(BOOL)shouldRefreshPage;
- (BOOL)getProfilePageRefreshState;

- (void)setAlertsPageRefreshState:(BOOL)shouldRefreshPage;
- (BOOL)getAlertsPageRefreshState;

- (void)setVenuesListPageRefreshState:(BOOL)shouldRefreshPage;
- (BOOL)getVenuesListPageRefreshState;

- (void)setVenueDetailPageRefreshState:(BOOL)shouldRefreshPage;
- (BOOL)getVenueDetailPageRefreshState;


- (void)setIndividualMatchPageRefreshState:(BOOL)shouldRefreshPage;
- (BOOL)getIndividualMatchPageRefreshState;

- (void)setSportRatingsSummaryPageRefreshState:(BOOL)shouldRefreshPage;
- (BOOL)getSportRatingsSummaryPageRefreshState;


- (void)setDeviceToken:(NSString *)deviceToken;
- (NSString *)getDeviceToken;

- (void)setHasMatchNotificationsPageBeenLoadedAtLeastOnce:(BOOL)state;
- (BOOL)getHasMatchNotificationsPageBeenLoadedAtLeastOnce;

- (void)setMatchNotificationsForceSegueWithAction:(NSString *)action andMatchID:(NSInteger)matchID;
- (NSString *)getMatchNotificationsForceSegueAction;
- (NSInteger)getMatchNotificationsForeSegueMatchID;

// for teams

- (void)setMatchNotificationsForceSegueWithAction:(NSString *)action andTeamID:(NSInteger)teamID;
- (NSInteger)getMatchNotificationsForeSegueTeamID;


// for venue checkins
- (void)setMatchNotificationsForceSegueWithAction:(NSString *)action andVenueID:(NSInteger)venueID;
- (NSInteger)getMatchNotificationsForeSegueVenueID;

- (void)setUserPhoneNumber:(NSString *)phoneNumber;
- (NSString *)getUserPhoneNumber;

// Add by Xin
- (void)setTipFlag:(BOOL)flag;
- (BOOL)getTipFlag;
- (void)setLastReadTime:(NSString *)timestamp;
- (NSString *)getLastReadTime;
- (void)setFirstTime;
- (BOOL)getFirstTime;

- (void)finishLogoutProcess;
- (BOOL)LogoutProcessStatus;

@end
