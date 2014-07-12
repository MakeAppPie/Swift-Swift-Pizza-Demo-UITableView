//
//  PizzaTypeTableVC.swift
//  PizzaDemo
//
//  Created by Steven Lipton on 7/11/14.
//  Copyright (c) 2014 Steven Lipton. All rights reserved.
//

import UIKit

protocol PizzaTypeTableDelegate{
    func pizzaTypeTableDidFinish(controller:PizzaTypeTableVC, pizza:Pizza)
}

class PizzaTypeTableVC: UITableViewController, PizzaTypePriceDelegate{

    var pizza = Pizza()
    var delegate:PizzaTypeTableDelegate? = nil
    @IBAction func savePrices(sender: UIBarButtonItem) {
        delegate?.pizzaTypeTableDidFinish(self, pizza: pizza)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func pizzaTypeDidFinish(controller: PizzaTypePriceVC, type: String, price: Double) {
        pizza.pizzaType = type
        pizza.pizzaPricePerInSq[pizza.pizzaType] = price
        controller.navigationController.popViewControllerAnimated(true)
        tableView.reloadData()
    }
 
    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return pizza.pizzaPricePerInSq.count
    }

    
    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        //note I did not check for nil values. Something has to be really broken for these to be nil.
        let row = indexPath!.row   //get the array index from the index path
        let cell = tableView!.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell  //make the cell
        let myRowKey = pizza.typeList[row]  //the dictionary key
        cell.textLabel.text = myRowKey
        let myRowData = pizza.pizzaPricePerInSq[myRowKey]  //the dictionary value
        cell.detailTextLabel.text = String(format: "%6.3f",myRowData!)
        return cell
    }

    override func tableView(tableView: UITableView!, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 44.0
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let index = tableView.indexPathForSelectedRow()
        pizza.pizzaType = pizza.typeList[index.row]
        if segue.identifier == "toEdit" {
            let vc = segue.destinationViewController as PizzaTypePriceVC
            vc.pizzaType = pizza.pizzaType
            vc.pizzaPrice = pizza.unitPrice()
            vc.delegate = self
        }
    }
  
}
