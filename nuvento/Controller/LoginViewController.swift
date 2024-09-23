//
//  LoginViewController.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func loginWithGoogleBtn(_ sender: UIButton) {
        GoogleSignInManager.shared.googleSingin(viewController: self) { loginDetails, error in
            if(error == nil && loginDetails != nil){
                self.navigationToHomeScreen()
            }
            else{
                print(error?.localizedDescription ?? "")
            }
        }
    }
    func navigationToHomeScreen(){
        if let HomeVc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewControllerID") as? HomeViewController {
            self.navigationController?.pushViewController(HomeVc, animated: false)
        }
    }
    func logout(){
        GIDSignIn.sharedInstance.signOut()
    }
}
