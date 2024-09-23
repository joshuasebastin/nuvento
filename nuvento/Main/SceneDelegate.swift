//
//  SceneDelegate.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        handleTheNavigation(windowScene: windowScene)
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    func handleTheNavigation(windowScene:UIWindowScene){
        let isConnected = NetworkManager.shared.isNetworkAvailable()
        
        if isConnected {
            GoogleSignInManager.shared.isUserLogin { status in
                self.checkTheUserIsAlreadyLogin(status: status, windowScene: windowScene)
            }
        } else {
            GoogleSignInManager.shared.logout()
        }
    }
    func checkTheUserIsAlreadyLogin(status:Bool,windowScene:UIWindowScene){
        
        let viewController: UINavigationController
        window = UIWindow(windowScene: windowScene)
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if(status){
            let vc = mainStoryBoard.instantiateViewController(identifier: "HomeViewControllerID") as! HomeViewController
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            viewController = navController
        }
        else{
            let vc = mainStoryBoard.instantiateViewController(identifier: "LoginViewControllerID") as! LoginViewController
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            viewController = navController
        }
        viewController.navigationBar.isHidden = true
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        UIView.transition(with: self.window!, duration: 0.5, options: [], animations: {
        }, completion: nil)
        
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

