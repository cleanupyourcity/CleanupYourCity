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

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref: DatabaseReference!
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var onSubmitButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        
        let StorageRef = Storage.storage().reference()
        let StorageRefChild = StorageRef.child("profileImages/\(String(describing: uid)).jpeg")
        //let StorageRefChild = StorageRef.child("profileImages/janeDoe.jpeg")
        
        
        // I think something here is wrong...
        
        
        
        let imageView: UIImageView = self.imageView
        let placeholderImage = UIImage(named: "placeholder.jpg")
        imageView.sd_setImage(with: StorageRefChild, placeholderImage: placeholderImage)
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
    ref.child("profile").child(uid!).setValue(["username":self.usernameTextField.text, "bio":self.bioTextView.text])

    }
}
