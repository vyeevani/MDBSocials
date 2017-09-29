//
//  DetailViewController.swift
//  MDBSocials
//
//  Created by Vineeth Yeevani on 9/28/17.
//  Copyright © 2017 Vineeth Yeevani. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    //Background Image
    var backgroundImage: UIImageView!
    
    //Return to post button
    var returnButton: UIButton!
    
    //Post Given
    var post: Post!
    
    //Post Title
    var postTitleTextField: UILabel!
    
    //Post Body
    var postBodyTextField: UILabel!
    
    //Post Date
    var postDateTextField: UILabel!
    
    //Event Image View
    var eventImageView : UIImageView!
    
    //Interested Button
    var interestedButton : UIButton!
    
    

    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround() 
        super.viewDidLoad()
        createBackground()
        createReturnButton()
        createEventImageView()
        createPostTitle()
        createPostBody()
        createPostDate()
        createInterestedButton()
    }

    //Create background
    func createBackground() {
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundImage.backgroundColor = UIColor(red: 67.0/255.0, green: 130.0/255.0, blue: 232.0/255.0, alpha: 1.0)
        view.addSubview(backgroundImage)
    }
    
    //Create Return Button
    func createReturnButton(){
        returnButton = UIButton(frame: CGRect(x: 0, y: view.frame.height * 0.05, width: view.frame.width * 0.1, height: view.frame.width * 0.1))
        returnButton.setImage(#imageLiteral(resourceName: "logoutunclicked"), for: .normal)
        returnButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        returnButton.addTarget(self, action: #selector(returnToView), for: .touchUpInside)
        view.addSubview(returnButton)
    }
    
    //Function to dismiss view
    @objc func returnToView() {
        dismiss(animated: true, completion: nil)
    }
    
    //Create the EventImageView
    func createEventImageView() {
        eventImageView = UIImageView(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.13, width: view.frame.width * 0.9, height: view.frame.height * 0.15))
        eventImageView.layer.cornerRadius = 8
        eventImageView.clipsToBounds = true
        eventImageView.backgroundColor = .white
        eventImageView.contentMode = .scaleAspectFill
        eventImageView.image = post.image!
        view.addSubview(eventImageView)
    }
    
    func createPostTitle() {
        postTitleTextField = UILabel(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.3, width: view.frame.width * 0.45, height: view.frame.height * 0.1))
        postTitleTextField.backgroundColor = .white
        postTitleTextField.roundCorners(corners: [.topLeft], radius: 8)
        postTitleTextField.text = " \(post.name!) by:  \(post.poster!)"
        view.addSubview(postTitleTextField)
        
        
    }
    
    //Create date of the event
    func createPostDate() {
        postDateTextField = UILabel(frame: CGRect(x: view.frame.width * 0.5, y: view.frame.height * 0.3, width: view.frame.width * 0.45, height: view.frame.height * 0.1))
        postDateTextField.backgroundColor = .white
        postDateTextField.text = "\(post.date!)"
        postDateTextField.textAlignment = .center
        postDateTextField.roundCorners(corners: [.topRight], radius: 8)
        view.addSubview(postDateTextField)
    }
    
    //Create the body of the function
    func createPostBody() {
        postBodyTextField = UILabel(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.4, width: view.frame.width * 0.9, height: view.frame.height * 0.15))
        postBodyTextField.text = post.text!
        postBodyTextField.numberOfLines = 5
        postBodyTextField.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
        postBodyTextField.backgroundColor = .white
        view.addSubview(postBodyTextField)
    }
    
    //Create a button to increase the interested number
    func createInterestedButton() {
        interestedButton = UIButton(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.7, width: view.frame.width * 0.9, height: view.frame.height * 0.1))
        interestedButton.layer.cornerRadius = 8
        interestedButton.backgroundColor = UIColor.lightGray
        interestedButton.backgroundColor = .white
        interestedButton.setTitle("Interested?", for: .normal)
        interestedButton.setTitleColor(UIColor(red: 67.0/255.0, green: 130.0/255.0, blue: 232.0/255.0, alpha: 1.0), for: .normal)
        if(post.interested!.contains((Auth.auth().currentUser?.uid)!)){
            interestedButton.isEnabled = false
            interestedButton.setTitle("You are already interested", for: .normal)
        } else {
            interestedButton.addTarget(self, action: #selector(increaseInterested), for: .touchUpInside)
        }
        view.addSubview(interestedButton)
    }
    
    //Function to increase the number of those interested
    @objc func increaseInterested() {
        interestedButton.isEnabled = false
        interestedButton.setTitle("You are already interested", for: .normal)
        post.interested!.append((Auth.auth().currentUser?.uid)!)
        let postRef = Database.database().reference().child("Posts").child(post.id!)
        let update = ["interested" : post.interested!]
        postRef.updateChildValues(update)
    }
}
