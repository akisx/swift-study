//
//  ViewController.swift
//  ToDoSample
//
//  Created by inoue on 2016/06/18.
//  Copyright © 2016年 inoue. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var todoList = [MyTodo]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let todoListData = userDefaults.objectForKey("todoList") as? NSData {
            if let storedTodoList = NSKeyedUnarchiver.unarchiveObjectWithData(todoListData) as? [MyTodo] {
                todoList.appendContentsOf(storedTodoList)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func tapAddButton(sender: AnyObject) {
        let alertContoller = UIAlertController(title: "ToDo追加", message: "ToDoを追加してください", preferredStyle: UIAlertControllerStyle.Alert)
        alertContoller.addTextFieldWithConfigurationHandler(nil)
        let okAction =  UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
            (action: UIAlertAction) -> Void in
            if let textField = alertContoller.textFields?.first {
                let myTodo: MyTodo = MyTodo()
                myTodo.todoTitle = textField.text!
                self.todoList.insert(myTodo, atIndex: 0)
                
                self.tableView.insertRowsAtIndexPaths(
                    [NSIndexPath(forRow: 0, inSection:0)], withRowAnimation: UITableViewRowAnimation.Right)
                
                let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(self.todoList)
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(data, forKey: "todoList")
                userDefaults.synchronize()
            }
        }
        
        alertContoller.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertContoller.addAction(cancelAction)
        presentViewController(alertContoller, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath)
        let todo = todoList[indexPath.row]
        
        cell.textLabel!.text = todo.todoTitle
        if todo.todoDone {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let todo = todoList[indexPath.row]
        if todo.todoDone {
            todo.todoDone = false
        } else {
            todo.todoDone = true
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
        let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(todoList)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(data, forKey: "todoList")
        userDefaults.synchronize()
    }
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            todoList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(todoList)
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(data, forKey: "todoLIst")
            userDefaults.synchronize()
        }
    }
    
    class MyTodo: NSObject, NSCoding {
        var todoTitle: String?
        var todoDone: Bool = false
        
        override init() {
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            todoTitle = aDecoder.decodeObjectForKey("todoTItle") as? String
            todoDone = aDecoder.decodeBoolForKey("todoDone")
        }
        
        func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(todoTitle, forKey: "todoTitle")
            aCoder.encodeBool(todoDone, forKey: "todoDone")
        }
    }
    

}

