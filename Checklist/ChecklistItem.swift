//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Vyacheslav Nagornyak on 7/31/16.
//  Copyright © 2016 Vyacheslav Nagornyak. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
	var text = ""
	var checked = false
	
	override init() {
		super.init()
	}
	
	init(_ text: String, checked: Bool) {
		self.text = text
		self.checked = checked
	}
	
	required init?(coder aDecoder: NSCoder) {
		text = aDecoder.decodeObject(forKey: "Text") as! String
		checked = aDecoder.decodeBool(forKey: "Checked")
		super.init()
	}
	
	func toogleCheck() {
		checked = !checked
	}
	
	// MARK: - NSCoding
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(text, forKey: "Text")
		aCoder.encode(checked, forKey: "Checked")
	}
}
