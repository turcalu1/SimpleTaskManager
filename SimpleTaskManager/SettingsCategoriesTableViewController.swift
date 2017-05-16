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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categories = CategoryPersistencyManager.sharedInstance.getCategories()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let cat = categories[indexPath.row]

        cell.textLabel!.text = cat.name
        
        cell.backgroundColor = Array(Common.COLORS.keys)[(cat.getColorID())]
        
        if cell.backgroundColor === UIColor.black {
            cell.textLabel?.textColor = UIColor.white
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingsAddCategoryViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "AddCategory") as! SettingsAddCategoryViewController
        settingsAddCategoryViewControllerObj.setUpdateState(categories[indexPath.row])
        self.navigationController?.pushViewController(settingsAddCategoryViewControllerObj, animated: true)
    }

}
