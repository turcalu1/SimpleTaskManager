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
    func setUpdateState(_ category: Category){
        self.category = category
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Common.COLORS.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(Common.COLORS.values)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.view.backgroundColor = Array(Common.COLORS.keys)[row]
    }
    
    // MARK: User Interaction
    @IBAction func SaveNewCategory(_ sender: AnyObject) {
        if (categoryName.text!.isEmpty) {
            let alertController = UIAlertController(title: "No category name", message: "Please enter a category name", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion:nil)
            return
        }

        if let _category = category {
            CategoryPersistencyManager.sharedInstance.updateCategory(_category, color_id: pickerView.selectedRow(inComponent: 0), name: categoryName.text!)
        } else {
            _ = CategoryPersistencyManager.sharedInstance.createCategory(pickerView.selectedRow(inComponent: 0), name: categoryName.text!)
        }
        
        _ = self.navigationController?.popViewController(animated: true)
    }
}
