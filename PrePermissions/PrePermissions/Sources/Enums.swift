//
//  Enums.swift
//  PrePermissions
//
//  Created by Jesse Onolememen on 28/07/2017.
//  Copyright © 2017 Jesse Onolememen. All rights reserved.
//

import Foundation

enum TitleType : Int {
    case request
    case deny
}

enum DialogResult : Int {
    /// User was not given the chance to take action.
    /// This can happen if the permission was
    /// already granted, denied, or restricted.
    case noActionTaken
    /// User declined access in the user dialog or system dialog.
    case denied
    /// User granted access in the user dialog or system dialog.
    case granted
    /// The iOS parental permissions prevented access.
    /// This outcome would only happen on the system dialog.
    case parentallyRestricted
}

/**
 * A general descriptor for the possible outcomes of Authorization Status.
 */
enum AuthorizationStatus : Int {
    /// Permission status undetermined.
    case unDetermined
    /// Permission denied.
    case denied
    /// Permission authorized.
    case authorized
    /// The iOS parental permissions prevented access.
    case restricted
}

/**
 * Authorization methods for the usage of location services.
 */
enum LocationAuthorizationType : Int {
    /// the “when-in-use” authorization grants the app to start most
    /// (but not all) location services while it is in the foreground.
    case whenInUse
    /// the “always” authorization grants the app to start all
    /// location services
    case always
}

/**
 * Authorization methods for the usage of event services.
 */

enum EventAuthorizationType : Int {
    /// Authorization for events only
    case event
    /// Authorization for reminders only
    case reminder
}

/**
 * Authorization methods for the usage of Contacts services(Handling existing of AddressBook or Contacts framework).
 */
enum ContactsAuthorizationType : Int {
    case notDetermined = 0
    /*! The application is not authorized to access contact data.
     *  The user cannot change this application’s status, possibly due to active restrictions such as parental controls being in place. */
    case restricted
    /*! The user explicitly denied access to contact data for the application. */
    case denied
    /*! The application is authorized to access contact data. */
    case authorized
}

/**
 * Authorization methods for the usage of AV services.
 */
enum AVAuthorizationType : Int {
    /// Authorization for Camera only
    case camera
    /// Authorization for Microphone only
    case microphone
}

struct PushNotificationType : OptionSet {
    let rawValue: Int
    
    static let none = PushNotificationType(rawValue: 0)
    // the application may not present any UI upon a notification being received
    static let badge = PushNotificationType(rawValue: 1 << 0)
    // the application may badge its icon upon a notification being received
    static let sound = PushNotificationType(rawValue: 1 << 1)
    // the application may play a sound upon a notification being received
    static let alert = PushNotificationType(rawValue: 1 << 2)
}
