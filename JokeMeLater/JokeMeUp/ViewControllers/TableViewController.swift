//
//  TableViewController.swift
//  JokeMeUp
//
//  Created by Felipe Izepe on 05/04/18.
//  Copyright © 2018 Felipe Izepe. All rights reserved.
//

import UIKit
import UserNotifications

class TableViewController: UITableViewController {
	
	//MARK: Outlets
	@IBOutlet weak var frequencyPicker: UIPickerView!
	//MARK: Properties
	
	@IBOutlet weak var engSwitch: UISwitch!
	
	@IBOutlet weak var ptSwitch: UISwitch!
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	@IBOutlet weak var progressBar: UIProgressView!
	
	@IBOutlet weak var cancelButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//Setup picker
		frequencyPicker.dataSource = self
		frequencyPicker.delegate = self
		
		//Load switch values
		self.engSwitch.setOn(UserDefaults.standard.bool(forKey: SaveConstants.english), animated: true)
		self.ptSwitch.setOn(UserDefaults.standard.bool(forKey: SaveConstants.portuguese), animated: true)
		var index = UserDefaults.standard.integer(forKey: SaveConstants.frequencie) - 3
		if index < 0 {
			index = 0
		}
		UserDefaults.standard.set(index + 3, forKey: SaveConstants.frequencie)
		self.frequencyPicker.selectRow(index, inComponent: 0, animated: true)
		
		let center = UNUserNotificationCenter.current()
		center.delegate = self
		
		if NotificationController.shared.isGettingJokes {
			activityIndicator.isHidden = false
			activityIndicator.startAnimating()
			cancelButton.isEnabled = false
		}
	}
	
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let header = view as! UITableViewHeaderFooterView
		header.textLabel?.textColor = UIColor.white
	}
	
	func showErrorMessage(message: String){
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
				
		alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
			
			NotificationController.shared.sendWeekJokes()
			alert.dismiss(animated: true, completion: nil)
			
		}))
		
		self.present(alert, animated: true)
	}
	
	@IBAction func setupWeekJokes(_ sender: Any) {
		
		if !NotificationController.shared.isPortEnabled && !NotificationController.shared.isEnglishEnabled {
			showErrorMessage(message: "No language selected")
			return
		}
		
		if NotificationController.shared.isGettingJokes {
			showErrorMessage(message: "Alredy currently getting Jokes")
			return
		}
		
		if !Reachability.isConnectedToNetwork() {
			let noInternetAlert = UIAlertController(title: "No Connection Found", message: "Please connect to the internet so that the jokes can be retrieved", preferredStyle: .alert)
			
			noInternetAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
				
				noInternetAlert.dismiss(animated: true, completion: nil)
				
			}))
			self.present(noInternetAlert, animated: true)
			return
		}
		
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		cancelButton.isEnabled = false
		
		NotificationController.shared.waitDelegate = self
		
		var message = "We will send you jokes every \(NotificationController.shared.frequency)h for a week! You will receive "
		
		if NotificationController.shared.isPortEnabled && NotificationController.shared.isEnglishEnabled {
			message.append("English and Portuguese Jokes")
		}else if NotificationController.shared.isPortEnabled{
			message.append("Portuguese Jokes")
		}else {
			message.append("English Jokes")
		}
		
		
		let alert = UIAlertController(title: "Setup the jokes?", message: message, preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
			
			NotificationController.shared.sendWeekJokes()
			alert.dismiss(animated: true, completion: nil)
			
		}))
		alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
			
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
			self.cancelButton.isEnabled = true

			alert.dismiss(animated: true, completion: nil)
			
		}))
		
		self.present(alert, animated: true)
		
	}
	@IBAction func enableEnglish(_ sender: Any) {
		let swtch = sender as! UISwitch
		UserDefaults.standard.set(swtch.isOn, forKey: SaveConstants.english)
		NotificationController.shared.setupNotifications()
	}
	
	@IBAction func enablePort(_ sender: Any) {
		let swtch = sender as! UISwitch
		UserDefaults.standard.set(swtch.isOn, forKey: SaveConstants.portuguese)
		NotificationController.shared.setupNotifications()
	}
	
	@IBAction func cancelJokes(_ sender: Any) {
		
		let alert = UIAlertController(title: "Jokes will be cancelled =(", message: "Are you certain you don't want any more jokes?.", preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
			
			NotificationController.shared.cancelNotifications()
			alert.dismiss(animated: true, completion: nil)
			
		}))
		alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
			alert.dismiss(animated: true, completion: nil)
			
		}))
		
		self.present(alert, animated: true)
	}
	
}


//MARK: Extensios UIPickerView Delegate
extension TableViewController : UIPickerViewDelegate {
}

//MARK: Extensios UIPickerView Data Source
extension TableViewController : UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 22
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return ("\(row+3)h")
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		UserDefaults.standard.set(row+3, forKey: SaveConstants.frequencie)
		NotificationController.shared.setupNotifications()
	}
	
}

extension TableViewController: UNUserNotificationCenterDelegate{
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "ShareView") as! ShareViewController
		
		controller.receivedJokeText = response.notification.request.content.body
		
		self.present(controller, animated: true, completion: nil)
		
		completionHandler()
		
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		
		// Delivers a notification to an app running in the foreground.
	}
	
}

extension TableViewController: JokesReceivedDelegate {
	func retrivalPercentUpdate(value: Float) {
		progressBar.setProgress(value, animated: true)
	}
	
	func retrivalDone() {
		activityIndicator.stopAnimating()
		activityIndicator.isHidden = true
		cancelButton.isEnabled = true
	}
}
