//
//  PrePermissions.swift
//  PrePermissions
//
//  Created by Jesse Onolememen on 28/07/2017.
//  Copyright © 2017 Jesse Onolememen. All rights reserved.
//

import Foundation
import AddressBook
import AssetsLibrary
import EventKit
import CoreLocation
import AVFoundation
import Contacts
import Photos
import UserNotifications

/**
 * General callback for permissions.
 * @param hasPermission Returns YES if system permission was granted
 *                      or is already available, NO otherwise.
 * @param userDialogResult Describes whether the user granted/denied access,
 *                         or if the user didn't have an opportunity to take action.
 *                         ClusterDialogResultParentallyRestricted is never returned.
 * @param systemDialogResult Describes whether the user granted/denied access,
 *                           or was parentally restricted, or if the user didn't
 *                           have an opportunity to take action.
 * @see ClusterDialogResult
 */

typealias PrePermissionsCompletionHandler = (_ hasPermission: Bool, _ userDialogResult: DialogResult, _ systemDialogResult: DialogResult) -> Void

class PrePermissions: NSObject {
    static let shared = PrePermissions()
    
    var preAVPermissionAlertController: UIAlertController!
    var avPermissionCompletionHandler: PrePermissionsCompletionHandler!
    
    var prePhotoPermissionAlertController: UIAlertController!
    var photoPermissionCompletionHandler: PrePermissionsCompletionHandler!
    
    var preContactPermissionAlertController: UIAlertController!
    var contactPermissionCompletionHandler: PrePermissionsCompletionHandler!
    
    var preEventPermissionAlertController: UIAlertController!
    var eventPermissionCompletionHandler: PrePermissionsCompletionHandler!
    
    var preLocationPermissionAlertController: UIAlertController!
    var locationPermissionCompletionHandler: PrePermissionsCompletionHandler!
    var locationManager: CLLocationManager!
    
    var locationAuthorizationType: LocationAuthorizationType!
    var requestedPushNotificationTypes: PushNotificationType!
    
    var prePushNotificationPermissionAlertController: UIAlertController!
    var pushNotificationPermissionCompletionHandler: PrePermissionsCompletionHandler?
    
    func applicationDidBecomeActive() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        firePushNotificationPermissionCompletionHandler()
    }
}

// MARK: - Helpers
extension PrePermissions {
    fileprivate var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    fileprivate func present(_ viewController: UIViewController) {
        guard let rootVC = self.rootViewController else {
            return
        }
        
        rootVC.present(viewController, animated: true, completion: nil)
    }
    
    fileprivate func alert(title: String, message: String, denyTitle: String, grantTitle: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let grantAction = UIAlertAction(title: grantTitle, style: .default) { (_) in
            self.granted(on: alert)
        }
        
        let denyAction = UIAlertAction(title: denyTitle, style: .destructive) { (_) in
            self.denied(on: alert)
        }
        
        alert.addAction(grantAction)
        alert.addAction(denyAction)
        
        return alert
    }
    
    fileprivate func title(for type: TitleType, from title: String) -> String {
        var title = title
        
        switch type {
        case .deny:
            title = title.characters.count == 0 ? "Not Now" : title
        case .request:
            title = title.characters.count == 0 ? "Give Access" : title
        }
        
        return title
    }
    
    fileprivate func granted(on: UIAlertController) {
        
    }
    
    fileprivate func denied(on: UIAlertController) {
        
    }
}

// MARK:- Statuses
extension PrePermissions {
    
    // MARK:- Functions
    private static func AVPermissionAuthorizationStatus(for type: String) -> AuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: type)
        switch status {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        default:
            return .unDetermined
        }
    }
    
    // MARK:- Variables
    public var cameraPermissionAuthorizationStatus: AuthorizationStatus {
        return PrePermissions.AVPermissionAuthorizationStatus(for: AVMediaTypeVideo)
    }
    
    public var microphonePermissionAuthorizationStatus: AuthorizationStatus {
        return PrePermissions.AVPermissionAuthorizationStatus(for: AVMediaTypeAudio)
    }
    
    public var photoPermissionAuthorizationStatus: AuthorizationStatus {
        if #available(iOS 9.0, *) {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                return .authorized
            case .denied:
                return .denied
            case .restricted:
                return .restricted
            default:
                return .unDetermined
            }
        } else {
            let status = ALAssetsLibrary.authorizationStatus()
            switch status {
            case .authorized:
                return .authorized
            case .denied:
                return .denied
            case .restricted:
                return .restricted
            default:
                return .unDetermined
            }
        }
    }
    
    public var contactsPermissionAuthorizationStatus: AuthorizationStatus {
        if #available(iOS 9.0, *) {
            let status = CNContactStore.authorizationStatus(for: .contacts)
            switch status {
            case .authorized:
                return .authorized
            case .denied:
                return .denied
            case .restricted:
                return .restricted
            default:
                return .unDetermined
            }
        } else {
            let status = ABAddressBookGetAuthorizationStatus()
            switch status {
            case .authorized:
                return .authorized
            case .denied:
                return .denied
            case .restricted:
                return .restricted
            default:
                return .unDetermined
            }
        }
    }
    
    public var locationPermissionAuthorizationStatus: AuthorizationStatus {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        default:
            return .unDetermined
        }
    }
    
    public var pushNotificationPermissionAuthorizationStatus: AuthorizationStatus {
        let didAskForPermission = UserDefaults.standard.bool(forKey: PrePermissionsDidAskForPushNotifications)
        
        if didAskForPermission {
            return UIApplication.shared.isRegisteredForRemoteNotifications ? .authorized : .denied
        } else {
            return .denied
        }
    }
}

// MARK:- Push Notificaiton Permissions Helper
extension PrePermissions {
    func showPushNotificationPermissions(with type: PushNotificationType, title _title: String, message: String, denyTitle: String, grantTitle: String, _ completion: @escaping PrePermissionsCompletionHandler) {
        var _title = _title
        
        let denyTitle = title(for: .deny, from: denyTitle)
        let grantTitle = title(for: .request, from: grantTitle)
        
        if _title.isEmpty {
            _title = "Enable Push Notifications?"
        }
        
        if pushNotificationPermissionAuthorizationStatus == .unDetermined {
            pushNotificationPermissionCompletionHandler = completion
            requestedPushNotificationTypes = type
            prePushNotificationPermissionAlertController = alert(title: _title, message: message, denyTitle: denyTitle, grantTitle: grantTitle)
            present(prePushNotificationPermissionAlertController)
        } else {
            completion(pushNotificationPermissionAuthorizationStatus == .unDetermined, .noActionTaken, .noActionTaken)
        }
    }
    
    func showActualPushNotificationPermissionAlert() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                UserDefaults.standard.set(true, forKey: PrePermissionsDidAskForPushNotifications)
                UserDefaults.standard.synchronize()
                self.firePushNotificationPermissionCompletionHandler()
            })
        } else {
            let settings = UIUserNotificationSettings(types: UIUserNotificationType(rawValue: UInt(requestedPushNotificationTypes.rawValue)), categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
            UserDefaults.standard.set(true, forKey: PrePermissionsDidAskForPushNotifications)
            UserDefaults.standard.synchronize()
        }
    }
    
    func firePushNotificationPermissionCompletionHandler() {
        let status = pushNotificationPermissionAuthorizationStatus
        
        if let handler = pushNotificationPermissionCompletionHandler {
            var userResult: DialogResult = .granted
            var dialogResult: DialogResult = .granted
            
            switch status {
            case .authorized:
                userResult = .granted
                dialogResult = .granted
            case .denied:
                userResult = .granted
                dialogResult = .denied
            case .unDetermined:
                userResult = .denied
                dialogResult = .noActionTaken
            default:
                userResult = .denied
                dialogResult = .noActionTaken
            }
            
            handler(status == .authorized, userResult, dialogResult)
            pushNotificationPermissionCompletionHandler = nil
        }
    }
}
