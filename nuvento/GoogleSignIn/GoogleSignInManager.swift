//
//  GoogleSignInManager.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import Foundation
import GoogleSignIn



class GoogleSignInManager {
    static let shared = GoogleSignInManager()
    
    func logout(){
        GIDSignIn.sharedInstance.signOut()
    }
    func isUserLogin(completion: @escaping(Bool) -> ()){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil {
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    func googleSingin(viewController: UIViewController, completionHandler: @escaping (GIDGoogleUser?,Error?) -> ()){
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { user, error in
            guard error == nil else{
                completionHandler(nil, error)
                return
            }
            
            guard let users = user?.user else{
                return
            }
            
            completionHandler(users, nil)
        
        }
    }
}
