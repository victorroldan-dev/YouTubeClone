//
//  LoginViewController.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 20/02/22.
//

import GoogleAPIClientForREST
import GoogleSignIn
import UIKit

class LoginViewController: UIViewController {
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeYouTubeReadonly]
    private let service = GTLRYouTubeService()
    let signInButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configSignInButton()
    }

    
    func configSignInButton(){
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        // Add the sign-in button.
        view.addSubview(signInButton)
        signInButton.center = view.center
        
    }
}

extension LoginViewController : GIDSignInDelegate, GIDSignInUIDelegate{

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            if let error = error {
                self.service.authorizer = nil
                
            } else {
                print("success")
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController{
                    present(vc, animated: true)
                    
                }
            }
        }
    
    
}

