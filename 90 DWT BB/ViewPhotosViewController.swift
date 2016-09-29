//
//  ViewPhotosViewController.swift
//  90 DWT BB
//
//  Created by Grant, Jared on 9/19/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit
import CoreData
import Social

class ViewPhotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MPMediaPickerControllerDelegate, UIPopoverPresentationControllerDelegate, UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var shareActionButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrayOfImages = [[], []]
    
    var session = ""
    var monthString = ""
    
    var photoAngle = [[], []]
    var photoMonth = [[], []]
    var photoTitles = [[], []]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.getPhotosFromDatabase()
        
        let lightGrey = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        self.collectionView.backgroundColor = lightGrey
    }
    
    func getPhotosFromDatabase() {
        
        // Fetch Photos
        let request = NSFetchRequest( entityName: "Photo")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        for arraySection in 0..<photoAngle.count {
            
            let tempArray = NSMutableArray()
            
            if arraySection == 0 {
                
                arrayOfImages.removeAll()
            }
            
            for arrayRow in 0..<photoAngle[arraySection].count {
                
                print("Section = \(arraySection) Row = \(arrayRow)")
                
                let filter = NSPredicate(format: "session == %@ AND month == %@ AND angle == %@",
                                         self.session,
                                         self.photoMonth[arraySection][arrayRow] as! String,
                                         self.photoAngle[arraySection][arrayRow] as! String)
                
                request.predicate = filter
                
                do {
                    if let photoObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Photo] {
                        
                        print("photosObjects.count = \(photoObjects.count)")
                        
                        if photoObjects.count != 0 {
                            
                            // Get the image from the last object
                            let matches = photoObjects.last
                            let image = UIImage(data: (matches?.image)!)
                            
                            // Add image to array.
                            tempArray.addObject(image!)
                        }
                        else {
                            
                            // Load a placeholder image.
                            tempArray.addObject(UIImage(named: "PhotoPlaceHolder")!)
                        }
                    }
                } catch { print(" ERROR executing a fetch request: \( error)") }
            }
            
            self.arrayOfImages.insert(tempArray, atIndex: arraySection)
        }
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
            
            // Array to store the default email address.
            let emailAddress = self.getEmailAddresses()
            
            mailcomposer.setToRecipients(emailAddress)
            
            switch self.navigationItem.title! as String {
            case "All":
                
                // ALL PHOTOS
                let emailTitle = String.localizedStringWithFormat("90 DWT BB All Photos - Session %@", self.session)
                mailcomposer.setSubject(emailTitle)
                
                for arraySection in 0..<self.arrayOfImages.count {
                    
                    for arrayRow in 0..<self.arrayOfImages[arraySection].count {
                        
                        // Don't attach photos that just use the placeholder image.
                        if self.arrayOfImages[arraySection][arrayRow] as? UIImage != UIImage(named: "PhotoPlaceHolder") {
                            
                            let photoAttachmentFileName = String.localizedStringWithFormat("%@ - Session %@.jpg", self.photoTitles[arraySection][arrayRow] as! String, self.session)
                            
                            let imageData = UIImageJPEGRepresentation(self.arrayOfImages[arraySection][arrayRow] as! UIImage, 1.0)
                            
                            mailcomposer.addAttachmentData(imageData!, mimeType: "image/jpg", fileName: photoAttachmentFileName)
                        }
                    }
                }
                
            case "Front":
                
                // FRONT PHOTOS
                let emailTitle = String.localizedStringWithFormat("90 DWT BB Front Photos - Session %@", self.session)
                mailcomposer.setSubject(emailTitle)
                
                for arraySection in 0..<self.arrayOfImages.count {
                    
                    for arrayRow in 0..<self.arrayOfImages[arraySection].count {
                        
                        // Don't attach photos that just use the placeholder image.
                        if self.arrayOfImages[arraySection][arrayRow] as? UIImage != UIImage(named: "PhotoPlaceHolder") {
                            
                            let photoAttachmentFileName = String.localizedStringWithFormat("%@ - Session %@.jpg", self.photoTitles[arraySection][arrayRow] as! String, self.session)
                            
                            let imageData = UIImageJPEGRepresentation(self.arrayOfImages[arraySection][arrayRow] as! UIImage, 1.0)
                            
                            mailcomposer.addAttachmentData(imageData!, mimeType: "image/jpg", fileName: photoAttachmentFileName)

                        }
                    }
                }

            case "Side":
                
                // SIDE PHOTOS
                let emailTitle = String.localizedStringWithFormat("90 DWT BB Side Photos - Session %@", self.session)
                mailcomposer.setSubject(emailTitle)
                
                for arraySection in 0..<self.arrayOfImages.count {
                    
                    for arrayRow in 0..<self.arrayOfImages[arraySection].count {
                        
                        // Don't attach photos that just use the placeholder image.
                        if self.arrayOfImages[arraySection][arrayRow] as? UIImage != UIImage(named: "PhotoPlaceHolder") {
                            
                            let photoAttachmentFileName = String.localizedStringWithFormat("%@ - Session %@.jpg", self.photoTitles[arraySection][arrayRow] as! String, self.session)
                            
                            let imageData = UIImageJPEGRepresentation(self.arrayOfImages[arraySection][arrayRow] as! UIImage, 1.0)
                            
                            mailcomposer.addAttachmentData(imageData!, mimeType: "image/jpg", fileName: photoAttachmentFileName)
                        }
                    }
                }
                
            default:
                
                // BACK PHOTOS
                let emailTitle = String.localizedStringWithFormat("90 DWT BB Back Photos - Session %@", self.session)
                mailcomposer.setSubject(emailTitle)
                
                for arraySection in 0..<self.arrayOfImages.count {
                    
                    for arrayRow in 0..<self.arrayOfImages[arraySection].count {
                        
                        // Don't attach photos that just use the placeholder image.
                        if self.arrayOfImages[arraySection][arrayRow] as? UIImage != UIImage(named: "PhotoPlaceHolder") {
                            
                            let photoAttachmentFileName = String.localizedStringWithFormat("%@ - Session %@.jpg", self.photoTitles[arraySection][arrayRow] as! String, self.session)
                            
                            let imageData = UIImageJPEGRepresentation(self.arrayOfImages[arraySection][arrayRow] as! UIImage, 1.0)
                            
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
    
    func getEmailAddresses() -> [String] {
        
        // Fetch defaultEmail data.
        let request = NSFetchRequest( entityName: "Email")
        let sortDate = NSSortDescriptor( key: "date", ascending: true)
        request.sortDescriptors = [sortDate]
        
        var emailAddressArray = [String]()
        
        do {
            if let emailObjects = try CDHelper.shared.context.executeFetchRequest(request) as? [Email] {
                
                print("emailObjects.count = \(emailObjects.count)")
                
                if emailObjects.count != 0 {
                    
                    // There is a default email address.
                    emailAddressArray = [(emailObjects.last?.defaultEmail)!]
                }
                else {
                    
                    // There is NOT a default email address.  Put an empty email address in the arrary.
                    emailAddressArray = [""]
                }
            }
            
        } catch { print(" ERROR executing a fetch request: \( error)") }
        
        return emailAddressArray
    }
    
    // MARK: UICollectionView Datasource
    
    // 1
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arrayOfImages[0].count
    }
    
    // 2
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        if self.photoTitles.count == 4 {
            
            return 4
        }
        else {
            
            return 1
        }
    }
    
    // 3
    func collectionView(cv: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let blueColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
        let cell = cv .dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        cell.backgroundColor = UIColor.blackColor()
        
        let section = indexPath.section
        let row = indexPath.row
        
        print("Section = \(section) Row = \(row)")
        
        cell.myImage.image = self.arrayOfImages[indexPath.section][indexPath.row] as? UIImage
        
        cell.myLabel.text = self.photoTitles[indexPath.section][indexPath.row] as? String
        cell.myLabel.backgroundColor = UIColor.blackColor()
        cell.myLabel.textColor = blueColor
        cell.myLabel.textAlignment = NSTextAlignment.Center
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
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
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeader", forIndexPath: indexPath) as! PhotoCollectionHeaderView
        
        if photoAngle.count == 4 {
            
            switch indexPath.section {
            case 0:
                
                header.headerLabel.text = "Start Month 1"
                
            case 1:
                
                header.headerLabel.text = "Start Month 2"
                
            case 2:
                
                header.headerLabel.text = "Start Month 3"
                
            default:
                
                header.headerLabel.text = "Final"
            }
        }
        else {
            
            header.headerLabel.text = ""
        }
        
        return header
    }
}
