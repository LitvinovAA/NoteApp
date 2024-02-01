//
//  SceneDelegate.swift
//  NoteApp
//
//  Created by Alexey on 30.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var storageManager = StorageMagager.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: NoteListViewController())
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        storageManager.saveContext()
    }
}

