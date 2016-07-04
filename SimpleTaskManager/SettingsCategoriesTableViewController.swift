//
//  SettingsCategoriesTableViewController.swift
//  SimpleTaskManager
//
//  Created by Lukas Turcan on 26/06/16.
//  Copyright © 2016 Lukas Turcan. All rights reserved.
//

import UIKit
import CoreData

class SettingsCategoriesTableViewController: UITableViewController {
    var categories : [Category] = []
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        categories = CategoryPersistencyManager.sharedInstance.getCategories()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let cat = categories[indexPath.row]

        cell.textLabel!.text = cat.name
        
        cell.backgroundColor = Array(Common.COLORS.keys)[(cat.getColorID())]
        
        if cell.backgroundColor === UIColor.blackColor() {
            cell.textLabel?.textColor = UIColor.whiteColor()
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let settingsAddCategoryViewControllerObj = self.storyboard?.instantiateViewControllerWithIdentifier("AddCategory") as! SettingsAddCategoryViewController
        settingsAddCategoryViewControllerObj.setUpdateState(categories[indexPath.row])
        self.navigationController?.pushViewController(settingsAddCategoryViewControllerObj, animated: true)
    }

}
