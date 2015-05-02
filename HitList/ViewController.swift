//
//  ViewController.swift
//  HitList
//
//  Created by babykang on 15/4/21.
//  Copyright (c) 2015年 Fiona. All rights reserved.
//

import UIKit

import CoreData

class ViewController: UIViewController, UITableViewDataSource , UITableViewDelegate{
        
    var people = [NSManagedObject]()
    var names = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    func saveName(name:String){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        //
        let entity =  NSEntityDescription.entityForName("Person",
            inManagedObjectContext:
            managedContext)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        //3
        person.setValue(name, forKey: "name")
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }  
        //5
        people.append(person)
    }
    @IBAction func addName(sender: UIBarButtonItem) {
        var alert = UIAlertController(title:"New Item", message:"add a new item", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) -> Void in
                
        let textField = alert.textFields![0] as UITextField
        self.saveName (textField.text)
        //self.names.append(textField.text)
        self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel",style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
        

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        title = "\"The List\""
        tableView.registerClass(UITableViewCell.self , forCellReuseIdentifier: "cell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return people.count
    }
    
   
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        //cell.textLabel.text = names[indexPath.row]
        let person = people[indexPath.row]
        cell.textLabel!.text = person.valueForKey("name") as? String
        cell.selectionStyle = .None
        return cell
    }
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = people.count
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 2.0, green: val, blue: 1.0, alpha: 1.0)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            cell.backgroundColor = colorForIndex(indexPath.row)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Person")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            people = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    //删除cell的内容 并有平滑的效果。
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            people.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
}

