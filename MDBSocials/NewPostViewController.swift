//
//  NewPostViewController.swift
//  MDBSocials
//
//  Created by Vineeth Yeevani on 9/26/17.
//  Copyright © 2017 Vineeth Yeevani. All rights reserved.
//

import UIKit
import Firebase

class NewPostViewController: UITabBarController {
    
    //Background Image
    var backgroundImage: UIImageView!
    
    //Return to post button
    var returnButton: UIButton!
    
    //Post Button
    var postButton: UIButton!
    
    //Post Title
    var postTitleTextField: UITextField!
    
    //Post Body
    var postBodyTextField: UITextView!
    
    //Post Date
    var postDateTextField: UITextField!
    
    //Post Image View
    var postImage: UIImageView!
    
    //Select image from library
    var selectFromLibraryButton: UIButton!
    
    //Image picker
    var picker = UIImagePickerController()
    
    //Event Image View
    var eventImageView : UIImageView!
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround() 
        picker.delegate = self
        super.viewDidLoad()
        createBackground()
        createReturnButton()
        createPostButton()
        createPostTitle()
        createPostDate()
        createPostBody()
        createSelectFromLibrary()
        //createPostImage()
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
    
    //Create a post button
    func createPostButton(){
        postButton = UIButton(frame: CGRect(x: view.frame.width * 0.9, y: view.frame.height * 0.05, width: view.frame.width * 0.1, height: view.frame.width * 0.1))
        postButton.setImage(#imageLiteral(resourceName: "addpostunclicked"), for: .normal)
        postButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        postButton.addTarget(self, action: #selector(addPost), for: .touchUpInside)
        view.addSubview(postButton)
    }
    
    //Return to the last feed view
    @objc func returnToView() {
        returnButton.setImage(#imageLiteral(resourceName: "logoutclicked"), for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    //Add the post
    @objc func addPost() {
        postButton.setImage(#imageLiteral(resourceName: "addpostclicked"), for: .normal)
        let ref = Database.database().reference()
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let eventImageData = UIImageJPEGRepresentation(eventImageView.image!, 0.9)
        ref.child("Users" ).child((Auth.auth().currentUser?.uid)!).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
            let name = snapshot.value
            let user = name! as? String
            let newPost = ["name" : self.postTitleTextField.text!, "text": self.postBodyTextField.text!, "date": self.postDateTextField.text!, "poster": user, "interested": [""]] as [AnyHashable : Any]
            let postRef = Database.database().reference().child("Posts")
            let key = postRef.childByAutoId().key
            let update = ["/\(key)/" : newPost]
            let storageRef = Storage.storage().reference().child("Posts").child(key)
            storageRef.putData(eventImageData!, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print(error)
                } else {
                    postRef.updateChildValues(update)
                    self.postButton.setImage(#imageLiteral(resourceName: "addpostunclicked"), for: .normal)
                    self.dismiss(animated: true)
                }
            })
            
        })
    }
    
    //Create the name of the event
    func createPostTitle() {
        postTitleTextField = UITextField(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.3, width: view.frame.width * 0.45, height: view.frame.height * 0.1))
        postTitleTextField.backgroundColor = .white
        postTitleTextField.roundCorners(corners: [.topLeft], radius: 8)
        postTitleTextField.placeholder = "  Name of the event"
        view.addSubview(postTitleTextField)
        
        
    }
    
    //Create date of the event
    func createPostDate() {
        postDateTextField = UITextField(frame: CGRect(x: view.frame.width * 0.5, y: view.frame.height * 0.3, width: view.frame.width * 0.45, height: view.frame.height * 0.1))
        postDateTextField.backgroundColor = .white
        postDateTextField.placeholder = "dd-MM-yyyy"
        postDateTextField.roundCorners(corners: [.topRight], radius: 8)
        self.postDateTextField.delegate = self
        postDateTextField.keyboardType = .numberPad
        view.addSubview(postDateTextField)
    }
    
    //Create the body of the function
    func createPostBody() {
        postBodyTextField = UITextView(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.4, width: view.frame.width * 0.9, height: view.frame.height * 0.3))
        postBodyTextField.placeholder = "Enter description of the event"
        postBodyTextField.backgroundColor = .white
        view.addSubview(postBodyTextField)
    }
    
    //Create the photo library picker
    func createSelectFromLibrary() {
        eventImageView = UIImageView(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.13, width: view.frame.width * 0.9, height: view.frame.height * 0.15))
        eventImageView.layer.cornerRadius = 8
        eventImageView.clipsToBounds = true
        eventImageView.contentMode = .scaleAspectFill
        selectFromLibraryButton = UIButton(frame: CGRect(x: view.frame.width * 0.05, y: view.frame.height * 0.7, width: view.frame.width * 0.9, height: view.frame.height * 0.1))
        selectFromLibraryButton.setTitle("Select Photo of Event From Library", for: .normal)
        selectFromLibraryButton.setTitleColor(UIColor(red: 67.0/255.0, green: 130.0/255.0, blue: 232.0/255.0, alpha: 1.0), for: .normal)
        selectFromLibraryButton.backgroundColor = .white
        selectFromLibraryButton.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
        selectFromLibraryButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        view.addSubview(eventImageView)
        view.addSubview(selectFromLibraryButton)
    }
    
    //Image picker
    @objc func pickImage(sender: UIButton!) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    
    
}


//Extension to limit the charecter to only numeric inputs
extension NewPostViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == postDateTextField {
            
            // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
            if (postDateTextField.text?.characters.count == 2) || (postDateTextField?.text?.characters.count == 5) {
                //Handle backspace being pressed
                if !(string == "") {
                    // append the text
                    postDateTextField.text = (postDateTextField?.text)! + "-"
                }
            }
            // check the condition not exceed 9 chars
            return !(textField.text!.characters.count > 9 && (string.characters.count ) > range.length)
        }
        else {
            return true
        }
    }
}

//Extension to round specific corners of a UIView element

//Adds placeholder to the TextView
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}

//Extension of UIImagePickerController
extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        eventImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
