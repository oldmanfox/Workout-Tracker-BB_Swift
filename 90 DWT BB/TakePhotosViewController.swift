//
//  TakePhotosViewController.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 9/16/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit
import CoreData
import Social

class TakePhotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MPMediaPickerControllerDelegate, UIPopoverPresentationControllerDelegate, UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let arrayOfImages = NSMutableArray()
    
    var session = ""
    var monthString = ""
    
    let actionButtonType = ""
    var whereToGetPhoto = ""
    var selectedPhotoTitle = ""
    
    var selectedImageRect = CGRect()
    var selectedCell = UICollectionViewCell()
    var selectedPhotoIndex = NSInteger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getPhotosFromDatabase()
        
        let lightGrey = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        self.collectionView.backgroundColor = lightGrey
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Force fetch when notified of significant data changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.doNothing), name: "SomethingChanged", object: nil)
        
        self.collectionView.reloadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "doNothing", object: nil)
    }
    
    func doNothing() {
        
        // Do nothing
    }

    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Share", message: "", preferredStyle: .ActionSheet)
        
        let emailAction = UIAlertAction(title: "Email", style: .Default, handler: {
            action in
            
            self.emailPhotos()
        })
        
        let facebookAction = UIAlertAction(title: "Facebook", style: .Default, handler: {
            action in
            
            if(SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)) {
                let socialController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                //            socialController.setInitialText("Hello World!")
                //            socialController.addImage(someUIImageInstance)
                //            socialController.addURL(someNSURLInstance)
                
                self.presentViewController(socialController, animated: true, completion: nil)
            }
            else {
                
                let alertControllerError = UIAlertController(title: "Error", message: "Please ensure you are connected to the internet AND signed into the Facebook app on your device before posting to Facebook.", preferredStyle: .Alert)
                
                let cancelActionError = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                
                alertControllerError.addAction(cancelActionError)
                
                if let popoverError = alertControllerError.popoverPresentationController {
                    
                    popoverError.barButtonItem = sender
                    popoverError.sourceView = self.view
                    popoverError.delegate = self
                    popoverError.permittedArrowDirections = .Any
                }
                
                self.presentViewController(alertControllerError, animated: true, completion: nil)
            }
        })
        
        let twitterAction = UIAlertAction(title: "Twitter", style: .Default, handler: {
            action in
            
            if(SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)) {
                let socialController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                //            socialController.setInitialText("Hello World!")
                //            socialController.addImage(someUIImageInstance)
                //            socialController.addURL(someNSURLInstance)
                
                self.presentViewController(socialController, animated: true, completion: nil)
            }
            else {
                
                let alertControllerError = UIAlertController(title: "Error", message: "Please ensure you are connected to the internet AND signed into the Twitter app on your device before posting to Twitter.", preferredStyle: .Alert)
                
                let cancelActionError = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                
                alertControllerError.addAction(cancelActionError)
                
                if let popoverError = alertControllerError.popoverPresentationController {
                    
                    popoverError.barButtonItem = sender
                    popoverError.sourceView = self.view
                    popoverError.delegate = self
                    popoverError.permittedArrowDirections = .Any
                }
                
                self.presentViewController(alertControllerError, animated: true, completion: nil)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(emailAction)
        alertController.addAction(facebookAction)
        alertController.addAction(twitterAction)
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController {
            
            popover.barButtonItem = sender
            popover.sourceView = self.view
            popover.delegate = self
            popover.permittedArrowDirections = .Any
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func emailPhotos() {
        
        // Create MailComposerViewController object.
        let mailcomposer = MFMailComposeViewController()
        mailcomposer.mailComposeDelegate = self
        mailcomposer.navigationBar.tintColor = UIColor.whiteColor()
        
        // Check to see if the device has at least 1 email account configured
        if MFMailComposeViewController.canSendMail() {
            
            var emailAddress = [""]
            
            // Fetch defaultEmail data.
            let request = NSFetchRequest( entityName: "Email")
            let sortDate = NSSortDescriptor( key: "date", ascending: true)
            request.sortDescriptors = [sortDate]
            
            do {
                if let emailObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Email] {
                    
                    print("emailObjects.count = \(emailObjects.count)")
                    
                    if emailObjects.count != 0 {
                        
                        // There is a default email address.
                        emailAddress = [(emailObjects.last?.defaultEmail)!]
                    }
                    else {
                        
                        // There is NOT a default email address.  Put an empty email address in the arrary.
                        emailAddress = [""]
                    }
                }
                
            } catch { print(" ERROR executing a fetch request: \( error)") }

            mailcomposer.setToRecipients(emailAddress)
            
            let monthArray = ["Start Month 1", "Start Month 2", "Start Month 3", "Final"]
            let picAngle = ["Front", "Side", "Back"]
            
            for i in 0..<monthArray.count {
                
                if self.navigationItem.title == monthArray[i] {
                    
                    // Prepare string for the Subject of the email
                    var subjectTitle = ""
                    subjectTitle = subjectTitle.stringByAppendingFormat("90 DWT BB %@ Photos - Session %@", monthArray[i], self.session)
                    
                    mailcomposer.setSubject(subjectTitle)
                    
                    for b in 0..<picAngle.count {
                        
                        // Don't attach photos that just use the placeholder image.
                        if self.arrayOfImages[b] as? UIImage != UIImage(named: "PhotoPlaceHolder") {
                            
                            let imageData = UIImageJPEGRepresentation(self.arrayOfImages[b] as! UIImage, 1.0)
                            
                            var photoAttachmentFileName = ""
                            photoAttachmentFileName = photoAttachmentFileName.stringByAppendingFormat("%@ %@ - Session %@.jpg", monthArray[i], picAngle[b], self.session)
                            
                            mailcomposer.addAttachmentData(imageData!, mimeType: "image/jpg", fileName: photoAttachmentFileName)
                        }
                    }
                }
            }
            
            presentViewController(mailcomposer, animated: true, completion: {
                UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
            })
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getPhotosFromDatabase() {
        
        // Get photo data with the current session
        let photoAngle = ["Front",
                          "Side",
                          "Back"]
        
        for i in 0..<photoAngle.count {
            
            // Fetch Photos
            let request = NSFetchRequest( entityName: "Photo")
            let sortDate = NSSortDescriptor( key: "date", ascending: true)
            request.sortDescriptors = [sortDate]
            
            let filter = NSPredicate(format: "session == %@ AND month == %@ AND angle == %@",
                                     self.session,
                                     self.monthString,
                                     photoAngle[i])
            
            request.predicate = filter
            
            do {
                if let photoObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Photo] {
                    
                    print("photosObjects.count = \(photoObjects.count)")
                    
                    if photoObjects.count != 0 {
                        
                        // Get the image from the last object
                        let matches = photoObjects.last
                        let image = UIImage(data: (matches?.image)!)
                        
                        // Add image to array.
                        self.arrayOfImages.addObject(image!)
                    }
                    else {
                        
                        // Load a placeholder image.
                        self.arrayOfImages.addObject(UIImage(named: "PhotoPlaceHolder")!)
                    }
                }
            } catch { print(" ERROR executing a fetch request: \( error)") }
        }
    }
    
    func cameraOrPhotoLibrary() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if self.whereToGetPhoto == "Camera" {
            
            // Use Camera
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            }
        }
        
        else if self.whereToGetPhoto == "Photo Library" {
            
            // Use Photo Library
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        else {
            
            // User Canceled the alert controller.
            return
        }
        
        // Check to see what device you are using iPad or iPhone.
        
        // If your device is iPad then show the imagePicker in a popover.
        // If not iPad then show the imagePicker modally.

        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad) {
         
            imagePicker.modalPresentationStyle = .Popover
        }
        
        if let popover = imagePicker.popoverPresentationController {
            
            popover.sourceView = self.selectedCell
            popover.delegate = self
            popover.sourceRect = (self.selectedCell.bounds)
            popover.permittedArrowDirections = .Any
        }
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage]
        
        self.arrayOfImages.replaceObjectAtIndex(self.selectedPhotoIndex, withObject: image!)
        
        var selectedAngle = ""
        
        switch selectedPhotoIndex {
        case 0:
            selectedAngle = "Front"
        case 1:
            selectedAngle = "Side"
        default:
            // selectedPhotoIndex = 2
            selectedAngle = "Back"
        }
        
        let imageData = UIImageJPEGRepresentation(image as! UIImage, 1.0)
        
        // Save the image data with the current session
        // Fetch Photos
        let request = NSFetchRequest( entityName: "Photo")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        // Weight with index and round
        let filter = NSPredicate(format: "session == %@ AND month == %@ AND angle == %@",
                                 self.session,
                                 self.monthString,
                                 selectedAngle)
        
        request.predicate = filter
        
        do {
            if let photoObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Photo] {
                
                print("photosObjects.count = \(photoObjects.count)")
                
                switch photoObjects.count {
                case 0:
                    // No matches for this object.
                    // Insert a new record
                    print("No Matches")
                    let insertPhotoInfo = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: CDHelper.shared.context) as! Photo
                    
                    insertPhotoInfo.session = session
                    insertPhotoInfo.month = monthString
                    insertPhotoInfo.angle = selectedAngle
                    insertPhotoInfo.date = NSDate()
                    insertPhotoInfo.image = imageData
                    
                    CDHelper.saveSharedContext()
                    
                case 1:
                    // Update existing record
                    
                    let updatePhotoInfo = photoObjects[0]
                    
                    updatePhotoInfo.date = NSDate()
                    updatePhotoInfo.image = imageData
                    
                    CDHelper.saveSharedContext()
                    
                default:
                    // More than one match
                    // Sort by most recent date and delete all but the newest
                    print("More than one match for object")
                    for index in 0..<photoObjects.count {
                        
                        if (index == photoObjects.count - 1) {
                            // Get data from the newest existing record.  Usually the last record sorted by date.
                            let updatePhotoInfo = photoObjects[index]
                            
                            updatePhotoInfo.date = NSDate()
                            updatePhotoInfo.image = imageData
                        }
                        else {
                            // Delete duplicate records.
                            CDHelper.shared.context.deleteObject(photoObjects[index])
                        }
                    }
                    
                    CDHelper.saveSharedContext()
                }
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            self.collectionView.reloadData()
            
        } catch { print(" ERROR executing a fetch request: \( error)") }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UICollectionView Datasource
    
    // 1
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arrayOfImages.count
    }
    
    // 2
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    // 3
    func collectionView(cv: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let blueColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
        let cell = cv .dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        cell.backgroundColor = UIColor.blackColor()
        cell.myImage.image = self.arrayOfImages.objectAtIndex(indexPath.item) as? UIImage
        
        let photoAngle = ["Front",
                          "Side",
                          "Back"]
        
        cell.myLabel.text = photoAngle[indexPath.item]
        cell.myLabel.backgroundColor = UIColor.blackColor()
        cell.myLabel.textColor = blueColor
        cell.myLabel.textAlignment = NSTextAlignment.Center
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(cv: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var alertController = UIAlertController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            alertController = UIAlertController(title: "Set Photo", message: "Select Photo Source", preferredStyle: .ActionSheet)
        }
        else {
            
            alertController = UIAlertController(title: "Set Photo", message: "No Camera Found.  Must Use Photo Library", preferredStyle: .ActionSheet)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .Default, handler: {
            action in
            
            self.whereToGetPhoto = "Camera"
            self.cameraOrPhotoLibrary()
        })
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .Default, handler: {
            action in
            
            self.whereToGetPhoto = "Photo Library"
            self.cameraOrPhotoLibrary()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
         
            alertController.addAction(cameraAction)
        }
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        
        let photoAngle = [" Front",
                          " Side",
                          " Back"]
        
        self.selectedPhotoTitle = (self.navigationItem.title?.stringByAppendingString(photoAngle[indexPath.item]))!
        self.selectedPhotoIndex = indexPath.item
        
        if let popover = alertController.popoverPresentationController {
            
            // Get the position of the image so the popover arrow can point to it.
            let cell = cv.cellForItemAtIndexPath(indexPath) as! PhotoCollectionViewCell
            self.selectedImageRect = cv .convertRect(cell.frame, toView: self.view)
            self.selectedCell = cell
            
            popover.sourceView = cell
            popover.delegate = self
            popover.sourceRect = (cell.bounds)
            popover.permittedArrowDirections = .Any
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        // Size cell for iPhone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone) {
            
            return CGSizeMake(152, 204);
        }
            
            // Size cell for iPad
        else {
            
            return CGSizeMake(304, 408);
        }
    }
}
