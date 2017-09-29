//
//  FeedViewController.swift
//  MDBSocials
//
//  Created by Vineeth Yeevani on 9/25/17.
//  Copyright © 2017 Vineeth Yeevani. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {
    
    //Collection of posts
    var postCollectionView : UICollectionView!
    
    //Background Image
    var backgroundImage : UIImageView!
    
    //MBD Logo view
    var logoImageView : UIImageView!
    
    //Logout Button
    var logoutButton : UIButton!
    //Add Post Button
    var addPostButton : UIButton!
    
    //Create a list of the posts
    var posts : [Post] = []
    
    //Create post to pass to detail view
    var postToPass : Post!

    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround() 
        super.viewDidLoad()
        createBackground()
        createLogoutButton()
        createMDBLogo()
        setupPosts()
        fetchPosts()
        changePosts()
        createAddPostButton()
        // Do any additional setup after loading the view.
    }
    
    
    func fetchPosts() {
        let ref = Database.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            self.posts.insert(post, at: 0)
            post.getProfilePic(withBlock: {
                self.postCollectionView.reloadData()
            })
        })
    }
    
    func changePosts() {
        let ref = Database.database().reference()
        ref.child("Posts").observe(.childChanged, with: { (snapshot) in
            self.postCollectionView.reloadData()
        })
    }
    
    //Create the blue background
    func createBackground() {
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundImage.backgroundColor = UIColor(red: 67.0/255.0, green: 130.0/255.0, blue: 232.0/255.0, alpha: 1.0)
        view.addSubview(backgroundImage)
    }
    
    //Create the MDB logo on the top bar
    func createMDBLogo() {
        logoImageView = UIImageView(frame: CGRect(x: view.frame.width * 0.45, y: view.frame.height * 0.02, width: view.frame.width * 0.1, height: view.frame.height * 0.1))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = #imageLiteral(resourceName: "mdb_logo")
        view.addSubview(logoImageView)
    }
    
    //Create the add post button
    func createAddPostButton() {
        addPostButton = UIButton(frame: CGRect(x: view.frame.width * 0.9, y: view.frame.height * 0.05, width: view.frame.width * 0.1, height: view.frame.width * 0.1))
        addPostButton.setImage(#imageLiteral(resourceName: "addpostunclicked"), for: .normal)
        addPostButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        addPostButton.addTarget(self, action: #selector(createPost), for: .touchUpInside)
        view.addSubview(addPostButton)
    }
    
    //Create the logout button
    func createLogoutButton(){
        logoutButton = UIButton(frame: CGRect(x: 0, y: view.frame.height * 0.05, width: view.frame.width * 0.1, height: view.frame.width * 0.1))
        logoutButton.setImage(#imageLiteral(resourceName: "logoutunclicked"), for: .normal)
        logoutButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        view.addSubview(logoutButton)
    }
    
    //Create the add new post button
    @objc func createPost(){
        addPostButton.setImage(#imageLiteral(resourceName: "addpostclicked"), for: .normal)
        self.performSegue(withIdentifier: "toNewPost", sender: self)
        addPostButton.setImage(#imageLiteral(resourceName: "addpostunclicked"), for: .normal)
    }
    
    @objc func logout(){
        logoutButton.setImage(#imageLiteral(resourceName: "logoutclicked"), for: .normal)
        do{
            try Auth.auth().signOut()
            print("Sign out success!")
        } catch let signOutError as Error {
            print("Sign out error \(signOutError)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func setupPosts() {
        let cvLayout = UICollectionViewFlowLayout()
        postCollectionView = UICollectionView(frame: CGRect(x: 0, y: view.frame.height * 0.12, width: view.frame.width, height: view.frame.height * 0.88), collectionViewLayout: cvLayout)
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "post")
        postCollectionView.backgroundColor = UIColor(red: 67.0/255.0, green: 130.0/255.0, blue: 232.0/255.0, alpha: 1.0)
        view.addSubview(postCollectionView)
    }
    
    //Prepare for segue to the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetail" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.post = postToPass
        }
    }
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! PostCollectionViewCell
        let postInQuestion = posts[indexPath.row]
        cell.title = postInQuestion.name
        cell.image = postInQuestion.image
        cell.content = postInQuestion.text
        cell.date = postInQuestion.date
        cell.name = postInQuestion.poster
        print(postInQuestion.interested)
        cell.interested = "Interested: \(postInQuestion.interested!.count-1)"
        cell.layer.cornerRadius = 8
        cell.awakeFromNib()
        return cell
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: postCollectionView.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: UIScreen.main.bounds.width - 20, height: 200)
        return CGSize(width: view.frame.width * 0.9, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        postToPass = posts[indexPath.row]
        if postToPass.image != nil{
            performSegue(withIdentifier: "segueToDetail", sender: self)
        }
    }
}

