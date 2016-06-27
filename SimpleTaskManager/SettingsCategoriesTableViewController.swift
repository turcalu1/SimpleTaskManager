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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.loadCategories()
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
        return appDelegate.categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let cat = appDelegate.categories[indexPath.row]

        cell.textLabel!.text =
            cat.valueForKey("name") as? String
        
        cell.backgroundColor = Array(COLORS.keys)[(cat.valueForKey("color_id") as! Int)]
        
        if cell.backgroundColor === UIColor.blackColor() {
            cell.textLabel?.textColor = UIColor.whiteColor()
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let settingsAddCategoryViewControllerObj = self.storyboard?.instantiateViewControllerWithIdentifier("AddCategory") as! SettingsAddCategoryViewController
        settingsAddCategoryViewControllerObj.setUpdateState(appDelegate.categories[indexPath.row])
        self.navigationController?.pushViewController(settingsAddCategoryViewControllerObj, animated: true)
    }

}
