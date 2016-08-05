//
//  AllListsViewController.swift
//  Checklist
//
//  Created by Vyacheslav Nagornyak on 8/1/16.
//  Copyright © 2016 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
	
	// MARK: - Variables
	
	var dataModel: DataModel!
	
	// MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		navigationController?.delegate = self
		let index = dataModel.indexOfSelectedChecklist
		if index >= 0, index < dataModel.lists.count {
			let checklist = dataModel.lists[index]
			performSegue(withIdentifier: "ShowChecklist", sender: checklist)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

    // MARK: - Table view

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = getCell(for: tableView)
		
		let checklist = dataModel.lists[indexPath.row]
		cell.textLabel!.text = checklist.title
		cell.accessoryType = .detailDisclosureButton
		let count = checklist.countUncheckedItems()
		var label = ""
		if checklist.items.count == 0 {
			label = "(No Items)"
		} else if count == 0 {
			label = "All done!"
		} else {
			label = "\(checklist.countUncheckedItems()) Remaining"
		}
		cell.detailTextLabel!.text = label
		
		return cell
    }
	
	func getCell(for tableView: UITableView) -> UITableViewCell {
		let cellIdentifier = "Cell"
		if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
			return cell
		} else {
			return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		dataModel.indexOfSelectedChecklist = indexPath.row
		
		let checklist = dataModel.lists[indexPath.row]
		performSegue(withIdentifier: "ShowChecklist", sender: checklist)
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			dataModel.lists.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		let navigation = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
		let controller = navigation.topViewController as! ListDetailViewController
		controller.delegate = self
		let checklist = dataModel.lists[indexPath.row]
		controller.checklistToEdit = checklist
		
		present(navigation, animated: true, completion: nil)
	}
	
	// MARK: - ListDetailViewControllerDelegate
	
	func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
		dismiss(animated: true, completion: nil)
	}
	
	func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {
		let index = dataModel.lists.count
		dataModel.lists.append(checklist)
		
		let indexPath = IndexPath(row: index, section: 0)
		tableView.insertRows(at: [indexPath], with: .left)
		
		dismiss(animated: true, completion: nil)
	}
	
	func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist) {
		if let index = dataModel.lists.index(of: checklist) {
			let indexPath = IndexPath(row: index, section: 0)
			if let cell = tableView.cellForRow(at: indexPath) {
				cell.textLabel!.text = checklist.title
			}
		}
		
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Segues
	
	override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "ShowChecklist" {
			let controller = segue.destination as! ChecklistViewController
			controller.checklist = sender as! Checklist
		} else if segue.identifier == "AddChecklist" {
			let navigation = segue.destination as! UINavigationController
			let controller = navigation.topViewController as! ListDetailViewController
			controller.delegate = self
			controller.checklistToEdit = nil
		}
	}
	
	// MARK: - Navigation controller delegate
	
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		if viewController === self {
			dataModel.indexOfSelectedChecklist = -1
		}
	}
}
