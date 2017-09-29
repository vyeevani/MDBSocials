//
//  ViewController.swift
//  MDBSocials
//
//  Created by Vineeth Yeevani on 9/25/17.
//  Copyright © 2017 Vineeth Yeevani. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    //Segmented Control
    var segmentedControl : UISegmentedControl!
    
    
    //Backround Image
    var backgroundImage : UIImageView!
    
    //Logo Image
    var logoImage : UIImageView!
    
    //View for the Texfields to get rounded corners
    var textEnterView : UIView!
    
    //TextFields for the existing user sign-up
    var usernameTextField : UITextField!
    var passwordTextField : UITextField!
    var nameTextField : UITextField!
    
    //****Buttons****//
    //Button for sign-in
    var signInButton : UIButton!
    var signUpButton : UIButton!

    //Label for sign-in errors
    var signInError : UILabel!
    var signInErrorText : String?
    
    
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround() 
        setupSegmentedControl()
        createSignIn()
    }
    
    
    //****Start segmented view creation, switch view method, createSignIn(), createSignUp()****//
    func setupSegmentedControl() {
        //Initialize SegmentedControl
        segmentedControl = UISegmentedControl(frame: CGRect(x: view.frame.height * 0.03, y: view.frame.height * 0.48, width: view.frame.width * 0.9, height: view.frame.height * 0.05))
        segmentedControl.insertSegment(withTitle: "Sign-In", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Sign-Up", at: 1, animated: true)
        segmentedControl.layer.cornerRadius = 8
        //segmentedControl.backgroundColor = .white
        segmentedControl.addTarget(self, action: #selector(switchView), for: .valueChanged)
        view.addSubview(segmentedControl)
    }
    
    //Create the whole sign-in view from the functions
    func createSignIn(){
        createBackground()
        createLogo()
        createUsernameField()
        createPasswordField()
        createsignInButton()
    }
    
    //Create the whole sign-up view from functions
    func createSignUp(){
        createBackground()
        createLogo()
        createUsernameField()
        createPasswordField()
        createNameField()
        createsignUpButton()
    }
    
    //Switch between the sign-in and sign-up views
    @objc func switchView(sender: UISegmentedControl) {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        view.addSubview(segmentedControl)
        if (sender.selectedSegmentIndex == 0) {
            createSignIn()
        } else if (sender.selectedSegmentIndex == 1){
            createSignUp()
        }
    }
    //****End creation segmentedView****//
    
    
    
    
    //Start Background Creation
    func createBackground(){
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundImage.image = #imageLiteral(resourceName: "background")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.layer.opacity = 0.7
        view.addSubview(backgroundImage)
    }
    //End Background Creation
    
    //Start Logo Creation
    func createLogo(){
        logoImage = UIImageView(frame: CGRect(x: view.frame.width*0.15, y: view.frame.height*0.06, width: view.frame.width*0.65, height: view.frame.height*0.20))
        logoImage.image = #imageLiteral(resourceName: "mdb_logo")
        view.addSubview(logoImage)
    }
    //End Logo Creation
    
    //****Start View Element Creation for Sign In****//
    
    //Create Username text field
    func createUsernameField() {
        usernameTextField = UITextField(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.55, width: view.frame.width * 0.9, height: view.frame.height * 0.1))
        usernameTextField.backgroundColor = .white
        usernameTextField.roundCorners(corners: [.topLeft, .topRight], radius: 8)
        usernameTextField.placeholder = "       Username"
        view.addSubview(usernameTextField)
    }
    
    //Create Password field
    func createPasswordField() {
        passwordTextField = UITextField(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.65, width: view.frame.width * 0.9, height: view.frame.height * 0.1))
        passwordTextField.backgroundColor = .white
        passwordTextField.placeholder = "       Password"
        view.addSubview(passwordTextField)
    }
    
    //Create Name field
    func createNameField() {
        nameTextField = UITextField(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.75, width: view.frame.width * 0.9, height: view.frame.height * 0.1))
        nameTextField.backgroundColor = .white
        nameTextField.placeholder = "       Your Name"
        view.addSubview(nameTextField)
    }
    
    //Create Sign-In button
    func createsignInButton() {
        signInButton = UIButton(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.85, width: view.frame.width * 0.9, height: view.frame.height * 0.1))
        signInButton.backgroundColor = UIColor(red: 67.0/255.0, green: 130.0/255.0, blue: 232.0/255.0, alpha: 1.0)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.layer.cornerRadius = 8
        signInButton.addTarget(self, action: #selector(signInUser), for: .touchUpInside)
        signInButton.setTitle("Sign-In", for: .normal)
        view.addSubview(signInButton)
    }
    
    //Create Sign-up button
    func createsignUpButton(){
        signUpButton = UIButton(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.85, width: view.frame.width * 0.9, height: view.frame.height * 0.1))
        signUpButton.backgroundColor = UIColor(red: 67.0/255.0, green: 130.0/255.0, blue: 232.0/255.0, alpha: 1.0)
        signInButton.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
        signUpButton.addTarget(self, action: #selector(signUpUser), for: .touchUpInside)
        signUpButton.setTitle("Sign-Up", for: .normal)
        view.addSubview(signUpButton)
    }
    //****End View Element Created for Sign In****//
    
    
    
    //****Start Sign In Process****//
    @objc func signInUser() {
        var email = usernameTextField.text!
        email = email + "@gmail.com"
        let password = passwordTextField.text!
        print(email)
        print(password)
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user: User?, error) in
            if error == nil{
                print("Login Success")
                self.toFeed(signUp: false)
            } else {
                print(error.debugDescription)
                self.signInErrorText = "Username/Password incorrect"
                self.signInFailed()
            }
        })
    }
    //****End sign in process****//
    
    //****Start User Creation process****//
    @objc func signUpUser(){
        let username = usernameTextField.text!
        let email = username + "@gmail.com"
        let name = nameTextField.text!
        let password = passwordTextField.text!
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user: User?, error) in
            if error == nil{
                print("Create User Start")
                let ref = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!)
                ref.setValue(["name": name, "email": email, "username": username])
                print("Creation success")
                self.toFeed(signUp: true)
            } else {
                print(error.debugDescription)
            }
        })
    }
    //****End User Creation process****//
    
    
    //Start error handling for sign-in failure
    func signInFailed(){
        signInError = UILabel(frame: CGRect(x: view.frame.width * 0.2, y: view.frame.height * 0.1, width: view.frame.width * 0.6, height: view.frame.height * 0.1))
        signInError.text = signInErrorText
        view.addSubview(signInError)
    }
    //End error handling for sign-in failure
    
    //Finished Everything and continue to the feed
    func toFeed(signUp : Bool){
        usernameTextField.text = ""
        passwordTextField.text = ""
        if signUp {
            nameTextField.text = ""
        }
        self.performSegue(withIdentifier: "toFeed", sender: self)
    }
    
}

//Extension to round specific corners of a UIView element
extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

