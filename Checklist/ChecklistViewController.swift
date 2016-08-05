//
//  ViewController.swift
//  Checklist
//
//  Created by Vyacheslav Nagornyak on 7/31/16.
//  Copyright © 2016 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
	
	// MARK: - Variables
	
	var checklist: Checklist!
	
	// MARK: - View
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		title = checklist.title
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Table View
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return checklist.items.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
		configureCell(cell, withChecklistItem: checklist.items[indexPath.row])
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) {
			
			let item = checklist.items[indexPath.row]
			item.checked = !item.checked
			
			configureCell(cell, withChecklistItem: item)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			checklist.items.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	func configureCell(_ cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
		let textLabel = cell.viewWithTag(1000) as! UILabel
		textLabel.text = item.text
		
		let checkmarkLabel = cell.viewWithTag(1001) as! UILabel
		checkmarkLabel.text = item.checked ? "√" : ""
	}
	
	// MARK: - ItemDetailViewControllerDelegate
	
	func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
		dismiss(animated: true, completion: nil)
	}
	
	func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
		let newIndex = checklist.items.count
		checklist.items.append(item)
		let indexPath = IndexPath(row: newIndex, section: 0)
		tableView.insertRows(at: [indexPath], with: .left)
		dismiss(animated: true, completion: nil)
	}
	
	func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
		if let index = checklist.items.index(of: item) {
			let indexPath = IndexPath(row: index, section: 0)
			if let cell = tableView.cellForRow(at: indexPath) {
				configureCell(cell, withChecklistItem: item)
			}
		}
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Segues
	
	override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "AddItem" {
			let navigationController = segue.destination as! UINavigationController
			let addItemController = navigationController.topViewController as! ItemDetailViewController
			addItemController.delegate = self
		} else if segue.identifier == "EditItem" {
			let navigationController = segue.destination as! UINavigationController
			let addItemController = navigationController.topViewController as! ItemDetailViewController
			addItemController.delegate = self
			if let IndexPath = tableView.indexPath(for: sender as! UITableViewCell) {
				addItemController.itemToEdit = checklist.items[IndexPath.row]
			}
		}
	}
}

