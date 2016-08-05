//
//  ListDetailViewController.swift
//  Checklist
//
//  Created by Vyacheslav Nagornyak on 8/1/16.
//  Copyright © 2016 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
	func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
	func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist)
	func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
	
	// MARK: - Variables
	
	weak var delegate: ListDetailViewControllerDelegate?
	var checklistToEdit: Checklist?
	
	// MARK: - Outlets
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var doneBarButton: UIBarButtonItem!
	
	// MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
		
		if let checklist = checklistToEdit {
			title = "Edit Checklist"
			textField.text = checklist.title
			doneBarButton.isEnabled = true
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		textField.becomeFirstResponder()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
	}
	
	// MARK: - Table View
	
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return nil
	}
	
	// MARK: - Text Field
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let oldText: NSString = textField.text!
		let newString: NSString = oldText.replacingCharacters(in: range, with: string)
		
		doneBarButton.isEnabled = newString.length > 0
		return true
	}
	
	// MARK: - Actions
	
	@IBAction func cancel() {
		delegate?.listDetailViewControllerDidCancel(self)
	}
	
	@IBAction func done() {
		if let checklist = checklistToEdit {
			checklist.title = textField.text!
			delegate?.listDetailViewController(self, didFinishEditingChecklist: checklist)
		} else {
			delegate?.listDetailViewController(self, didFinishAddingChecklist: Checklist(textField.text!))
		}
	}
}
