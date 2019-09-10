//
//  AppDelegate.swift
//  SandRecruits
//
//  Created by PC on 27/04/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NVActivityIndicatorView
import MFSideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var activityLoader : NVActivityIndicatorView!
    var container : MFSideMenuContainerViewController = MFSideMenuContainerViewController()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /**
         * IQKeyboardManager
         *
         * used to manage keyboard show hide event.
         *
         * @enable : Used to enble IQKeyboardManager in App.
         * @shouldShowToolbarPlaceholder : Display textfield placeholder string in UIToolbar.
         */
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        
        if let StatusbarView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            StatusbarView.backgroundColor = LightGrayColor
        }
        
        if isUserLogin(), let dict : [String : Any] = getLoginUserData()
        {
            AppModel.shared.currentUser = UserModel.init(dict: dict)
            navigateToDashBoard()
        }
        
        return true
    }

    
    /**
     * UIStoryboard
     *
     * Used to access main storyboard instance
     *
     * @param
     */
    func storyboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    /**
     * AppDelegate Sharing
     *
     * Used to share AppDelegate method to access globally
     *
     * @param
     */
    func sharedDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    /**
     * Show loader till sending/getting data to/from server
     *
     * Set color and size here
     *
     * @param
     */
    func showLoader()
    {
        removeLoader()
        window?.isUserInteractionEnabled = false
        activityLoader = NVActivityIndicatorView(frame: CGRect(x: ((window?.frame.size.width)!-50)/2, y: ((window?.frame.size.height)!-50)/2, width: 50, height: 50))
        activityLoader.type = .ballSpinFadeLoader
        activityLoader.color = DarkGrayColor
        window?.addSubview(activityLoader)
        activityLoader.startAnimating()
    }
    
    /**
     * Hide loader after getting response from server
     *
     * @param
     */
    func removeLoader()
    {
        window?.isUserInteractionEnabled = true
        if activityLoader == nil
        {
            return
        }
        activityLoader.stopAnimating()
        activityLoader.removeFromSuperview()
        activityLoader = nil
    }
    
    func logout() {
        AppModel.shared.currentUser = nil
        removeUserDefaultValues()
        AppModel.shared.resetAllModel()
        navigateToLogin()
    }
    
    func navigateToLogin(){
        let navigationVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ViewControllerNavigation") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = navigationVC
    }
    
    
    func navigateToDashBoard()
    {
        let rootVC: MFSideMenuContainerViewController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
        container = rootVC
        var navController: UINavigationController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "DashboardVCNav") as! UINavigationController
        if #available(iOS 9.0, *) {
            let vc : HomeVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true

            let leftSideMenuVC: UIViewController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SideMenuContentVC")
            container.menuWidth = UIDevice.current.userInterfaceIdiom == .pad ? 400 : 290
            //container.menuWidth = 290
            container.panMode = MFSideMenuPanModeSideMenu
            container.menuSlideAnimationEnabled = false
            container.rightMenuViewController = leftSideMenuVC
            container.centerViewController = navController

            container.view.layer.masksToBounds = false
            container.view.layer.shadowOffset = CGSize(width: 10, height: 10)
            container.view.layer.shadowOpacity = 0.5
            container.view.layer.shadowRadius = 5
            container.view.layer.shadowColor = UIColor.clear.cgColor

            let rootNavigatioVC : UINavigationController = self.window?.rootViewController
                as! UINavigationController
            rootNavigatioVC.pushViewController(container, animated: false)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
