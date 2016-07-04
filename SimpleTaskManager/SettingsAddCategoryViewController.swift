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
    
    var categories : [Category] = []
    var category : Category?
    
    // MARK: Lifecycle
    func setUpdateState(category: Category){
        self.category = category
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        categories = CategoryPersistencyManager.sharedInstance.getCategories()
        var selectedColorIdx = 0
        
        // Set the existing category data
        if let _category = category {
            title = "Update Category"
            
            categoryName.text = _category.name
            for c in categories{
                if(c === _category){
                    selectedColorIdx = c.getColorID()
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
    
    // MARK: pickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Common.COLORS.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(Common.COLORS.values)[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.view.backgroundColor = Array(Common.COLORS.keys)[row]
    }
    
    // MARK: User Interaction
    @IBAction func SaveNewCategory(sender: AnyObject) {
        if (categoryName.text!.isEmpty) {
            let alertController = UIAlertController(title: "No category name", message: "Please enter a category name", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            self.presentViewController(alertController, animated: true, completion:nil)
            return
        }

        if let _category = category {
            CategoryPersistencyManager.sharedInstance.updateCategory(_category, color_id: pickerView.selectedRowInComponent(0), name: categoryName.text!)
        } else {
            CategoryPersistencyManager.sharedInstance.createCategory(pickerView.selectedRowInComponent(0), name: categoryName.text!)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
