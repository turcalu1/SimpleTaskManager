//
//  SettingsAddCategoryViewController.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 26/06/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import UIKit
import CoreData

class SettingsAddCategoryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var categoryName: UITextField!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var updateCategoryObj : NSManagedObject!
    var updateCategory = false
    
    func setUpdateState(category: NSManagedObject){
        updateCategoryObj = category
        updateCategory = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var selectedColorIdx = 0
        
        // Set the existing category data
        if (updateCategory){
            title = "Update Category"
            
            categoryName.text = updateCategoryObj.valueForKey("name") as? String
            for c in appDelegate.categories{
                if(c === updateCategoryObj){
                    selectedColorIdx = c.valueForKey("color_id") as! Int
                    pickerView.selectRow(selectedColorIdx, inComponent: 0, animated: false)
                }
            }
        }
        
        //select color & update background
        pickerView.selectRow(selectedColorIdx, inComponent: 0, animated: false)
        pickerView(pickerView, didSelectRow: selectedColorIdx, inComponent: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - pickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return COLORS.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(COLORS.values)[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.view.backgroundColor = Array(COLORS.keys)[row]
    }
    
    // MARK: - Button callbacks
    @IBAction func SaveNewCategory(sender: AnyObject) {
        if (categoryName.text!.isEmpty) {
            let alert = UIAlertView()
            alert.title = "No category name"
            alert.message = "Please enter a category name"
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
        }

        saveCategory(categoryName.text!, colorID: pickerView.selectedRowInComponent(0))
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveCategory(name: String, colorID: Int) {
        let managedContext = appDelegate.managedObjectContext
        
        var category = updateCategoryObj

        if(!updateCategory){
            // create new category
            let entity =  NSEntityDescription.entityForName("Category",
                                                            inManagedObjectContext:managedContext)
            
            category = NSManagedObject(entity: entity!,
                                           insertIntoManagedObjectContext: managedContext)
        }
        
        category.setValue(name, forKey: "name")
        category.setValue(colorID, forKey: "color_id")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
