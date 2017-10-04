//
//  ViewController.swift
//  editable-cells
//
//  Created by Amos  on 10/3/17.
//  Copyright © 2017 Amos . All rights reserved.
//

//introduce a section which cant be editable

import UIKit

class ViewController: UITableViewController {
    
    var foods = ["Apple", "Bread", "Milk", "Pizza"]
    var colors = ["Blue", "Green", "Red"]
    var animals = ["Cat", "Dog", "Bird", "Mouse", "Elephant"]

    var sectionPressed: Int = 0   // for restricting reordering to the section
    var reordering: Bool = true 

    var longPress = UILongPressGestureRecognizer()
    var tap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongPress))
        longPress.minimumPressDuration = 1.50;
        tableView.addGestureRecognizer(longPress)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        tableView.addGestureRecognizer(tap)

    }
    
    
    /*
     * Disable indentention when in editing mode
     */
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    /*
     * Detect tap to disable reordering
     */
    @objc func handleTap(sender: UITapGestureRecognizer){
        if (tableView.isEditing == true) {
            tableView.setEditing(false, animated: true)
        }
    }
    
    
    /*
     * Detect long-press to toggle reordering
     */
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        let touchPoint = longPress.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            sectionPressed = indexPath.section
            tableView.setEditing(true, animated: true)
            reordering = true
        }
    }
    
    
    /*
     * Set the edit control button on left side (+/- button on left)
     */
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        if (tableView.isEditing == false) {
            reordering = false
        } else {
            reordering = true
        }
        
        if (reordering) {
            return .none // set all cells to not have that any control button
        } else {
            return .delete // set all cells to have delete control button
        }
    }
    
    
    /*
     * Restricts the reordering control icon to the section where the longpressed cell lives in
     */
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == sectionPressed)
    }
    
    
    /*
     * Necessary delegate for reordercontrol icon to appear
     * Updates your datasource
     */
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var movedObject: String
        
        if sourceIndexPath.section == 0 {
            movedObject = self.foods[sourceIndexPath.row]
        } else if sourceIndexPath.section == 1 {
            movedObject = self.colors[sourceIndexPath.row]
        } else {
            movedObject = self.animals[sourceIndexPath.row]
        }
        
        if (destinationIndexPath.section == 0) {
            foods.remove(at: sourceIndexPath.row)
            foods.insert(movedObject, at: destinationIndexPath.row)
        } else if (destinationIndexPath.section == 1) {
            colors.remove(at: sourceIndexPath.row)
            colors.insert(movedObject, at: destinationIndexPath.row)
        } else {
            animals.remove(at: sourceIndexPath.row)
            animals.insert(movedObject, at: destinationIndexPath.row)
        }
    }
    
    
    /*
     * Displays the reordering movement in the tableview
     * Restricts reordering animation to cells in the same section
    */
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if (sourceIndexPath.section != proposedDestinationIndexPath.section ) {
            var row = 0
            if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    
    /*
     * Perform the action that results from pressing the editing style controler buttom
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        // performs the delete on your data source and reloads the table to reflec changes
        if editingStyle == UITableViewCellEditingStyle.delete {
            if (indexPath.section == 0) {
                foods.remove(at: indexPath.row)
            }
            else if (indexPath.section == 1) {
                colors.remove(at: indexPath.row)
            }
            else {
                animals.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
    }
    
    
    /*
     * Regular tableview delegate stuff below here
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return foods.count
        } else if (section == 1) {
            return colors.count
        } else {
            return animals.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if (indexPath.section == 0) {
            cell.textLabel?.text = foods[indexPath.row]
        } else if (indexPath.section == 1){
            cell.textLabel?.text = colors[indexPath.row]
        } else {
            cell.textLabel?.text = animals[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Food"
        } else if (section == 1) {
            return "Colors"
        }
        else {
            return "Animals"
        }
    }
    
}

