//
//  PizzaDemo.swift
//  pizzaDemo version 7/12/14
//  adds a table view to the application
//
//  Created by Steven Lipton on 6/8/14.
//  Copyright (c) 2014 Steven Lipton. All rights reserved.
//
//

import UIKit

class PizzaDemoVC: UIViewController, PizzaTypeTableDelegate {
    
    var pizza=Pizza()
    
    let clearString = "I Like Pizza!"
    
    @IBOutlet var priceLabel : UILabel!   //added 07/01/14
    @IBOutlet var resultsDisplayLabel : UILabel!
    
    @IBOutlet var pizzaType: UISegmentedControl!
    @IBAction func pizzaType(sender : UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        pizza.pizzaType = sender.titleForSegmentAtIndex(index)!
        displayPizza()
    }
    
    func pizzaTypeTableDidFinish(controller: PizzaTypeTableVC, pizza: Pizza) {
        self.pizza = pizza
        controller.navigationController?.popViewControllerAnimated(true)
        displayPizza()
        //update the segment index to match new pizza type
        for index in 0..<pizzaType.numberOfSegments{
            if pizza.pizzaType == pizzaType.titleForSegmentAtIndex(index){
                pizzaType.selectedSegmentIndex = index
            }
        }
        
    }
    func displayPizza(){
        let displayString = NSString(format:"%6.1fin %@",pizza.pizzaDiameter, pizza.pizzaType)
        let priceString = NSString(format:"%6.2f sq in at $%6.2f is $%6.2f",pizza.pizzaArea(),pizza.unitPrice(),pizza.pizzaPrice()) //added 6/29/14
        resultsDisplayLabel.text = displayString
        priceLabel.text = priceString //added 6/29/14
    }
    
    @IBAction func sizeButton(sender : UIButton) {
        pizza.pizzaDiameter = pizza.diameterFromString(sender.titleLabel!.text!)
        displayPizza()
    }
    
    
    @IBAction func clearDisplayButton(sender : UIButton) {
        resultsDisplayLabel.text = clearString
        pizza.pizzaDiameter = 0
        displayPizza()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsDisplayLabel.text = clearString
        pizza.pizzaDiameter = 8
        pizza.pizzaType = "Cheese"
        pizza.pizzaPricePerInSq["Pepperoni"] = 9.99 //test data -- remove when done
        displayPizza()
        view.backgroundColor = UIColor(red:0.99,green:0.9,blue:0.9,alpha:1.0)
    }

    func pizzaTypeDidFinish(controller: PizzaTypePriceVC, type: String, price: Double) {
        pizza.pizzaType = type
        pizza.pizzaPricePerInSq[pizza.pizzaType] = price
        controller.navigationController?.popViewControllerAnimated(true)
        displayPizza()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        /* -------------------------------------------
        /*replaced 7/6/14 for new segue to tableview  */
        if segue.identifier == "typeprice" {
        let vc = segue.destinationViewController as PizzaTypePriceVC
        vc.pizzaType = pizza.pizzaType
        vc.pizzaPrice = pizza.unitPrice()
        vc.delegate = self
        }
        ------------------------------------------*/
        if segue.identifier == "toTable" {
            let vc = segue.destinationViewController as PizzaTypeTableVC
            vc.pizza = pizza
            vc.delegate = self
        }
    }

}

