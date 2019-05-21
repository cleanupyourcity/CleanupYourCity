//
//  CameraViewController.swift
//  CleanUpYourCity
//
//  Created by Ariel McCarthy on 4/25/19.
//  Copyright © 2019 Group3. All rights reserved.
//

import UIKit
import AlamofireImage
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseUI

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var ref: DatabaseReference!
    let uid = Auth.auth().currentUser?.uid
    var eventList: [Event] = []
    
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var onSubmitButton: UIButton!
    
    @IBOutlet weak var historyTableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        
        let StorageRef = Storage.storage().reference()
        let StorageRefChild = StorageRef.child("profileImages/\(String(describing: uid)).jpeg")
        //let StorageRefChild = StorageRef.child("profileImages/janeDoe.jpeg")
        
        
        // I think something here is wrong...
        
        
        
        let imageView: UIImageView = self.imageView
        let placeholderImage = UIImage(named: "image_placeholder.jpg")
        imageView.sd_setImage(with: StorageRefChild, placeholderImage: placeholderImage)
        
        // Loading the events from the database
        ref.child("profile").child(uid!).child("history").observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                for events in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let eventObject = events.value as? [String: AnyObject]
                    let poster  = eventObject?["eventAuthorID"]
                    let description  = eventObject?["eventDescription"]
                    let severity  = eventObject?["eventSeverity"]
                    let name = eventObject?["eventName"]
                    let icon = eventObject?["eventIcon"]
                    
                    //creating event object with model and fetched values
                    let event = Event(eventSeverity: severity as! String?,
                                      eventDescription: description as! String?,
                                      eventPoster: poster as! String?,
                                      eventName: name as! String?,
                                      eventIcon: icon as! String?)
                    
                    
                    //appending it to list
                    self.eventList.append(event)
                }
                //reloading the tableview
                //self.historyTableView.reloadData()
            }
        };
        
        // self.historyTableView.delegate = self;
        // self.historyTableView.dataSource = self;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! historyCell;
        let event: Event!
        event = eventList[indexPath.row]
        
        cell.nameLabel.text = event.eventName
        cell.descriptionLabel.text = event.eventDescription
        cell.severityLabel.text = event.eventSeverity
        
        if(event.eventSeverity == "0"){
            cell.backgroundColor = UIColor.green
        }
        else if(event.eventSeverity == "1"){
            cell.backgroundColor = UIColor.cyan
        }
        else if(event.eventSeverity == "2"){
            cell.backgroundColor = UIColor.yellow
        }
        else if(event.eventSeverity == "3"){
            cell.backgroundColor = UIColor.red
        }
        
        return cell;
    }
    
    @IBAction func onCameraSubmitButton(_ sender: Any)
    {
        let picker = UIImagePickerController()
        
        // calls a function that has the photo
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            picker.sourceType = .camera
            // try with both
            //picker.sourceType = .photoLibrary
        }
        else
        {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    @objc func handleSelectProfileImageView()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker
        {
            imageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSubmitButton(_ sender: Any)
    {
        self.uploadImageToFirebaseStorage()
        self.navigationController?.popViewController(animated: true)
    }
    
    func uploadImageToFirebaseStorage()
    {
        if let uploadData = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
        {
            let StorageRef = Storage.storage().reference()
            let StorageRefChild = StorageRef.child("profileImages/\(String(describing: uid)).jpeg")
            StorageRefChild.putData(uploadData, metadata: nil)
            {
                (metadata, err) in
                if let err = err
                {
                    print("unable to upload Image into storage due to \(err)")
                }
                StorageRefChild.downloadURL(completion:
                    {
                        (url, err) in
                        if let err = err
                        {
                            print("Unable to retrieve URL due to error: \(err.localizedDescription)")
                        }
                        let profilePicUrl = url?.absoluteString
                        print("Profile Image successfully uploaded into storage with url: \(profilePicUrl ?? "" )")
                })
            }
        }
    }
    
    @IBAction func onDoneButton(_ sender: Any)
    {
        self.uploadProfileToFirebaseStorage()
        self.navigationController?.popViewController(animated: true)
    }
    
    func uploadProfileToFirebaseStorage()
    {
        // ref.child("profile").child(uid!).setValue(["username":self.usernameTextField.text, "bio":self.bioTextView.text])
        ref.child("profile/\(uid!)/username").setValue(self.usernameTextField.text)
        ref.child("profile/\(uid!)/bio").setValue(self.bioTextView.text)

    }
}
