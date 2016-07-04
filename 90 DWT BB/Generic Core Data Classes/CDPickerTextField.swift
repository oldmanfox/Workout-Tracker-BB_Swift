//
//  CDPickerTextField.swift
//
//  Created by Tim Roadley on 5/10/2015.
//  Copyright © 2015 Tim Roadley. All rights reserved.
//

import UIKit
import CoreData

protocol CDPickerTextFieldDelegate {
    func selectedObject(object:NSManagedObject, changedForPickerTF pickerTF:CDPickerTextField)
}

class CDPickerTextField: UITextField, NSFetchedResultsControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Override
    var entity = "MyEntity"
    var sort = [NSSortDescriptor(key: "myAttribute", ascending: true)]
    
    // Optionally Override
    var context = CDHelper.shared.context
    var filter:NSPredicate? = nil
    var cacheName:String? = nil
    var sectionNameKeyPath:String? = nil
    var fetchBatchSize = 0 // 0 = No Limit
    var fetchLimit = 0
    var fetchOffset = 0
    var resultType:NSFetchRequestResultType = NSFetchRequestResultType.ManagedObjectResultType
    var propertiesToGroupBy:[AnyObject]? = nil
    var havingPredicate:NSPredicate? = nil
    var includesPropertyValues = true
    var relationshipKeyPathsForPrefetching:[AnyObject]? = nil

    // Supporting Variables
    var toolbar:UIToolbar?
    var picker:UIPickerView?
    var pickerDelegate:CDPickerTextFieldDelegate?
    var selectedTitle:String?
    var selectedIndex:NSIndexPath?

    // MARK: - FETCHED RESULTS CONTROLLER
    lazy var frc: NSFetchedResultsController = {
    
        let request = NSFetchRequest(entityName:self.entity)
        request.sortDescriptors = self.sort
        request.fetchBatchSize  = self.fetchBatchSize
        if let _filter = self.filter {request.predicate = _filter}
        
        request.fetchLimit = self.fetchLimit
        request.fetchOffset = self.fetchOffset
        request.resultType = self.resultType
        request.includesPropertyValues = self.includesPropertyValues
        if let _propertiesToGroupBy = self.propertiesToGroupBy {request.propertiesToGroupBy = _propertiesToGroupBy}
        if let _havingPredicate = self.havingPredicate {request.havingPredicate = _havingPredicate}
        if let _relationshipKeyPathsForPrefetching = self.relationshipKeyPathsForPrefetching as? [String] {
            request.relationshipKeyPathsForPrefetching = _relationshipKeyPathsForPrefetching}
        
        let newFRC = NSFetchedResultsController(
                            fetchRequest: request,
                    managedObjectContext: self.context,
                      sectionNameKeyPath: self.sectionNameKeyPath,
                               cacheName: self.cacheName)
        newFRC.delegate = self
        return newFRC
    }()

    // MARK: - DELEGATE & DATASOURCE: UIPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return self.frc.sections?.count ?? 0
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.frc.sections?[component].numberOfObjects ?? 0
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Override titleForRow:forComponent"
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // Pass the selected object back to the picker delegate
        if let _pickerDelegate = self.pickerDelegate {
            let indexPath = NSIndexPath(forRow: row, inSection: component)
            if let object = self.frc.objectAtIndexPath(indexPath) as? NSManagedObject {
                _pickerDelegate.selectedObject(object, changedForPickerTF: self)
            }    
        }
    }
    
    // MARK: - FETCHING
    func performFetch () {
        self.frc.managedObjectContext.performBlock ({

            do {
                try self.frc.performFetch()
            } catch {
                print("\(#function) FAILED : \(error)")
            }
            if let _picker = self.picker {_picker.reloadAllComponents()}
        })
    }

    // MARK: - DELEGATE: NSFetchedResultsController
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if let _picker = self.picker {_picker.reloadAllComponents()}
    }
    
    // MARK: - INTERACTION
    func done () {
        self.resignFirstResponder()
    }
    func createInputView () -> UIView? {
        let newPicker = UIPickerView(frame: CGRectZero)
        newPicker.showsSelectionIndicator = true
        newPicker.dataSource = self
        newPicker.delegate = self
        self.picker = newPicker
        return self.picker
    }
    func createInputAccessoryView () -> UIView? {
        
        let newToolbar = UIToolbar(frame: CGRectZero)
        var frame = newToolbar.frame
        frame.size.height = 44
        newToolbar.frame = frame
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(CDPickerTextField.done))
        newToolbar.setItems([space,doneButton], animated: false)
        self.toolbar = newToolbar
        return self.toolbar
    }
    
}
