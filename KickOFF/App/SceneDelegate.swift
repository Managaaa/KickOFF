//
//  SceneDelegate.swift
//  KickOFF
//
//  Created by Luka Managadze on 1/1/26.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        let coordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator = coordinator
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        coordinator.start()
    }
    
    func scene(_scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        GIDSignIn.sharedInstance.handle(url)
    }
    
}
