//
//  SettingsTableViewController.swift
//  Alquran
//
//  Created by Asset Sarsengaliyev on 10/4/16.
//  Copyright © 2016 Alquran. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var arab: UISwitch!
  @IBOutlet weak var trans: UISwitch!
  @IBOutlet weak var kaz: UISwitch!
  @IBOutlet weak var rus: UISwitch!
  @IBOutlet weak var eng: UISwitch!
  @IBOutlet weak var taf: UISwitch!
  
    @IBOutlet weak var latin: UITableViewCell!
    @IBOutlet weak var qazaq: UITableViewCell!
  
  @IBOutlet weak var qazWord: UITableViewCell!
  @IBOutlet weak var rusWord: UITableViewCell!
  @IBOutlet weak var engWord: UITableViewCell!
  
    @IBAction func arabtoggle(_ sender: UISwitch) {
      UserDefaults.standard.set(sender.isOn, forKey: "arab")
      UserDefaults.standard.synchronize()
    }
  @IBAction func transtoggle(_ sender: UISwitch) {
    UserDefaults.standard.set(sender.isOn, forKey: "trans")
    UserDefaults.standard.synchronize()
  }
  @IBAction func rustoggle(_ sender: UISwitch) {
    UserDefaults.standard.set(sender.isOn, forKey: "rus")
    UserDefaults.standard.synchronize()
  }
  @IBAction func kaztoggle(_ sender: UISwitch) {
    UserDefaults.standard.set(sender.isOn, forKey: "kaz")
    UserDefaults.standard.synchronize()
  }
  @IBAction func engtoggle(_ sender: UISwitch) {
    UserDefaults.standard.set(sender.isOn, forKey: "eng")
    UserDefaults.standard.synchronize()
  }
  @IBAction func taftoggle(_ sender: UISwitch) {
    UserDefaults.standard.set(sender.isOn, forKey: "taf")
    UserDefaults.standard.synchronize()
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      let arabValue: Bool? = UserDefaults.standard.object(forKey: "arab") as? Bool
      let kazValue: Bool! = UserDefaults.standard.object(forKey: "kaz") as? Bool
      let transValue: Bool! = UserDefaults.standard.object(forKey: "trans") as? Bool
      let rusValue: Bool! = UserDefaults.standard.object(forKey: "rus") as? Bool
      let tafValue: Bool? = UserDefaults.standard.object(forKey: "taf") as? Bool
      let engValue: Bool! = UserDefaults.standard.object(forKey: "eng") as? Bool


        arab.isOn = arabValue!
      trans.isOn = transValue!
      kaz.isOn = kazValue!
      rus.isOn = rusValue!
      eng.isOn = engValue!
      taf.isOn = tafValue!

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      if section == 0{
        return 6}
      if section == 1{
        return 2}
      if section == 2{
        return 3}
      if section == 3{
        return 3}
        return 0
    }
  
//  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCellWithIdentifier("trans", forIndexPath: indexPath)
//    if (indexPath.row == 1){
//    cell.accessoryType = .Checkmark
//    tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Bottom)
//    } else {
//      cell.accessoryType = .None
//    }
//  
//    return cell
//  }
  
  override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    if (indexPath.row == 1 && indexPath.section == 1){
      print ("salem")
      UserDefaults.standard.set(false, forKey: "qazTrans")
      UserDefaults.standard.synchronize()
      //tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Bottom)
    }else if (indexPath.row == 0 && indexPath.section == 1){
      print ("irbik")
      UserDefaults.standard.set(true, forKey: "qazTrans")
      UserDefaults.standard.synchronize()
      //tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Bottom)
    }
    let qazTrans: Bool! = UserDefaults.standard.object(forKey: "qazTrans") as? Bool
    if qazTrans!{
      qazaq.accessoryType = .checkmark
      latin.accessoryType = .none
    }else{
      latin.accessoryType = .checkmark
      qazaq.accessoryType = .none
    }
    
    if (indexPath.section == 2){
      UserDefaults.standard.set(indexPath.row+1, forKey: "qazWord")
      UserDefaults.standard.synchronize()
    }

    setTickForWordByWord()

    
  }
  
  func setTickForWordByWord(){
    let qw: Int! = UserDefaults.standard.object(forKey: "qazWord") as? Int
    if (qw == 1){
      qazWord.accessoryType = .checkmark
      rusWord.accessoryType = .none
      engWord.accessoryType = .none
    }else if (qw == 2){
      qazWord.accessoryType = .none
      rusWord.accessoryType = .checkmark
      engWord.accessoryType = .none    }
    else{
      qazWord.accessoryType = .none
      rusWord.accessoryType = .none
      engWord.accessoryType = .checkmark
    }
    
  }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      setTickForWordByWord()


        // Configure the cell...
      if (indexPath.section == 1){
        let qazTrans: Bool! = UserDefaults.standard.object(forKey: "qazTrans") as? Bool
        if qazTrans!{
          qazaq.accessoryType = .checkmark
          latin.accessoryType = .none
        }else{
          latin.accessoryType = .checkmark
          qazaq.accessoryType = .none
        }
        
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
      }
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        return cell


    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
