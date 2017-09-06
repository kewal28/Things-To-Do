//
//  TaskListController.swift
//  Things To Do
//
//  Created by Kewal Kanojia on 29/07/17.
//  Copyright © 2017 Kewal Kanojia. All rights reserved.
//

import UIKit
import AVFoundation

class TaskListController: UITableViewController {
    
    
    var player:AVAudioPlayer = AVAudioPlayer()
    var soundEffectSetting:String = "";
    var taskId:Array = [String]()
    var taskTitle:Array = [String]()
    var taskDescription:Array = [String]()
    var taskStatus:Array = [String]()
    var tasksList:[String: Any] = [:];
    var tasksDelete:[String: Any] = [:];
    var userId:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = self.getUserId();
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Pull To Refresh", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
        
        self.getTaskList(userId:userId);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        soundEffectSetting = self.getSoundEffectSetting()
        if soundEffectSetting == "true" {
            do {
                let audioPath = Bundle.main.path(forResource: "braked", ofType: "mp3")
                try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            } catch let error {
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //count of total record
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if taskTitle.count > 0 {
            return taskTitle.count
        } else {
            let messageLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 100, height: 100)))
            messageLabel.text = "You don't have any task yet."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
            
            self.tableView.backgroundView = messageLabel;
            self.tableView.separatorStyle = .none;
            return 0
        }
    }
    
    //Configer cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCells", for: indexPath) as! TaskListCell

        // Configure the cell...
        if taskStatus[indexPath.row] == "Done" {
            cell.taskStatus.backgroundColor = self.uicolorFromHex(rgbValue: 0x00ccff)
        } else {
            cell.taskStatus.backgroundColor = self.uicolorFromHex(rgbValue: 0xffcc99)
        }
        cell.selectionStyle = .none
        cell.taskTitle.text = String(taskTitle[indexPath.row])
        cell.taskDescription.text = String(taskDescription[indexPath.row])
        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    //Show Delete and edit button while swipe right
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.deleteTask(rowId: indexPath.row)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // share item at indexPath
            self.editTask(rowId: indexPath.row)
        }
        edit.backgroundColor = UIColor.lightGray
        
        var status = UITableViewRowAction();
        if taskStatus[indexPath.row] == "Done" {
            status = UITableViewRowAction(style: .normal, title: "Pending") { (action, indexPath) in
                // share item at indexPath
                self.doneTask(rowId: indexPath.row, status: "Pending")
            }
            status.backgroundColor = self.uicolorFromHex(rgbValue: 0xffcc99)
        } else {
            status = UITableViewRowAction(style: .normal, title: "Done") { (action, indexPath) in
                // share item at indexPath
                self.doneTask(rowId: indexPath.row, status:"Done")
            }
            status.backgroundColor = self.uicolorFromHex(rgbValue: 0x00ccff)
        }
        
        return [delete, edit, status]
    }
    
    //Send to detail page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "viewTask") as! ViewTaskController
        desCV.taskTitleValue = taskTitle[indexPath.row]
        desCV.taskDescriptionValue = taskDescription[indexPath.row]
        self.show(desCV, sender: nil)
    }
    
    func getTaskList(userId: String) {
        taskId = [String]()
        taskTitle = [String]()
        taskDescription = [String]()
        taskStatus = [String]()
        //Get Tasks
        tasksList = doHttpRequest(url: "getTask.php?userId=\(userId)", method: "GET", params: "")!;
        
        if !(tasksList.isEmpty) {
            let status = tasksList["status"] as! String
            if(status == "false") {
                print(tasksList["error"]!);
            } else {
                let _taskList: NSArray = tasksList["tasks"] as! NSArray
                for i in 0 ..< _taskList.count{
                    //getting the data at each index
                    let taskArray = _taskList[i] as! Dictionary<String,AnyObject>
                    self.taskId.append(taskArray["tasksId"]! as! String)
                    self.taskTitle.append(taskArray["taskTitle"]! as! String)
                    self.taskDescription.append(taskArray["taskDescription"]! as! String)
                    self.taskStatus.append(taskArray["status"]! as! String)
                }
            }
        }
    }
    
    //Edit Task Http Call and reload table Data
    func editTask(rowId:Int) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "editTask") as! EditTaskController
        desCV.taskIdValue = self.taskId[rowId]
        desCV.taskTitleValue = self.taskTitle[rowId]
        desCV.taskDescriptionValue = self.taskDescription[rowId]
        self.show(desCV, sender: nil)
    }
    
    //Change Status Http Call and reload table Data
    func doneTask(rowId:Int, status:String) {
        let taskId = self.taskId[rowId]
        let postString = "taskId=\(taskId)&status=\(status)"
        tasksDelete = doHttpRequest(url: "changeStatusTask.php", method: "POST", params: postString)!;
        if !(tasksDelete.isEmpty) {
            let status = tasksDelete["status"] as! String
            if(status == "false") {
                print(tasksDelete["error"]!);
            } else {
                if self.soundEffectSetting == "true" {
                    self.player.play()
                }
                self.getTaskList(userId: userId)
                tableView.reloadData()
            }
        }
    }
    
    //Delete Task Http Call and reload table Data
    func deleteTask(rowId:Int) {
        let taskId = self.taskId[rowId]
        let postString = "taskId=\(taskId)"
        tasksDelete = doHttpRequest(url: "deleteTask.php", method: "POST", params: postString)!;
        if !(tasksDelete.isEmpty) {
            let status = tasksDelete["status"] as! String
            if(status == "false") {
                print(tasksDelete["error"]!);
            } else {
                if self.soundEffectSetting == "true" {
                    self.player.play()
                }
                self.taskId.remove(at: rowId)
                self.taskTitle.remove(at: rowId)
                self.taskDescription.remove(at: rowId)
                tableView.reloadData()
            }
        }
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        // Do your job, when done:
        if self.soundEffectSetting == "true" {
            self.player.play()
        }
        self.getTaskList(userId: userId)
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    

}
