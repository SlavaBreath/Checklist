//
//  DataModel.swift
//  Checklist
//
//  Created by Vyacheslav Nagornyak on 8/2/16.
//  Copyright © 2016 Vyacheslav Nagornyak. All rights reserved.
//

import Foundation

class DataModel {
	var lists = [Checklist]()
	var indexOfSelectedChecklist: Int {
		get {
			return UserDefaults.standard.integer(forKey: "ChecklistIndex")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
		}
	}
	
	init() {
		loadChecklists()
		registerDefaults()
		handleFirstTime()
	}
	
	// MARK: - Load/Save
	
	func documentDirectory() -> String {
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		return paths[0]
	}
	
	func dataFilePath() -> String {
		return "\(documentDirectory())/Checklists.plist"
	}
	
	func saveCheckLists() {
		let data = NSMutableData()
		let archiver = NSKeyedArchiver(forWritingWith: data)
		archiver.encode(lists, forKey: "Checklists")
		archiver.finishEncoding()
		data.write(to: URL(fileURLWithPath: dataFilePath()), atomically: true)
	}
	
	func loadChecklists() {
		let path = dataFilePath()
		if FileManager.default.fileExists(atPath: path) {
			let data = try! Data(contentsOf: URL(fileURLWithPath: path))
			let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
			lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
			unarchiver.finishDecoding()
		}
	}
	
	func registerDefaults() {
		let dict = ["ChecklistIndex": -1,
		            "FirstTime": true]
		UserDefaults.standard.register(defaults: dict)
	}
	
	func handleFirstTime() {
		let userDefaults = UserDefaults.standard
		let firstTime = userDefaults.bool(forKey: "FirstTime")
		if firstTime {
			let checklist = Checklist("List")
			lists.append(checklist)
			indexOfSelectedChecklist = 0
			userDefaults.set(false, forKey: "FirstTime")
			userDefaults.synchronize()
		}
	}
}
