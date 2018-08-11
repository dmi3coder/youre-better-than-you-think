//
//  ViewController.swift
//  You're better than you think
//
//  Created by User on 8/7/18.
//  Copyright © 2018 Dmitry Chaban. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    
    fileprivate enum CellIdentifiers {
        static let CheerCell = "cheerTextCell"
    }
    
    @IBOutlet weak var cheerField: NSTextField!
    
    var statemenst: [Statement]? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest = NSFetchRequest<Statement>()
        let appDelegate = NSApp.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Statement", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        
        do {
            statemenst = try context.fetch(fetchRequest as! NSFetchRequest<Statement>)
            tableView.reloadData()
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        

        // Do any additional setup after loading the view.
    }
    
    private func reloadData() {
        let fetchRequest = NSFetchRequest<Statement>()
        let appDelegate = NSApp.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Statement", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        
        do {
            statemenst = try context.fetch(fetchRequest as! NSFetchRequest<Statement>)
            tableView.reloadData()
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
    
    @IBAction func cheerButton(_ sender: NSButton) {
        if(cheerField.stringValue.isEmpty){
            return
        }
        let appDelegate = NSApp.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Statement", in: context)
        
        let newStatement = NSManagedObject(entity: entity!, insertInto: context)
        newStatement.setValue(cheerField.stringValue, forKey: "text")
        newStatement.setValue("default", forKey: "batch")
        newStatement.setValue(true, forKey: "enabled")
        do {
            try context.save()
            reloadData()
            cheerField.stringValue = ""
        } catch _ {
            
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return statemenst?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
        
        // 1
        guard let item = statemenst?[row] else {
            return nil
        }
        
        // 2
//        if tableColumn == tableView.tableColumns[0] {
            text = item.text!
            cellIdentifier = CellIdentifiers.CheerCell
//        }
        
        // 3
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
    
    @IBAction func cellSelected(_ sender: NSTableView) {
        
    }
    
    @IBAction func removeElement(_ sender: Any) {
        deleteProfile(text: statemenst![tableView.clickedRow])
    }
    
    
    func deleteProfile(text: Statement) {
        
        let appDelegate = NSApp.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.delete(text)
        reloadData()
    }


}

