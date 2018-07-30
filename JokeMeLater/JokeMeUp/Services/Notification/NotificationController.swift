//
//  NotificationController.swift
//  JokeMeUp
//
//  Created by Felipe Izepe on 23/02/18.
//  Copyright © 2018 Felipe Izepe. All rights reserved.
//

import Foundation
import UserNotifications

protocol JokesReceivedDelegate: class {
	func retrivalDone()
	
	func retrivalPercentUpdate(value: Float)
}

class NotificationController: NSObject {
	//MARK: Properties
	
	//Singleton instance
	static let shared = NotificationController()
	
	var isEnabled = false
	var isEnglishEnabled = false
	var isPortEnabled = false

	private(set) var isGettingJokes = false

	//Joke controll
	
	var frequency : Int = 3
	weak var waitDelegate: JokesReceivedDelegate?
	var ptJokes: [Joke]?
	var engJokes: [Joke]?
	//
	
	//MARK: Life Cycle
	override init() {
		super.init()
		setupNotifications()
	}
	
	
	//MARK: Methods
	func setupNotifications(){
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
			// Enable or disable features based on authorization
			self.isEnabled = granted
		}
		self.isEnglishEnabled = UserDefaults.standard.bool(forKey: SaveConstants.english)
		self.isPortEnabled = UserDefaults.standard.bool(forKey: SaveConstants.portuguese)
		self.frequency = UserDefaults.standard.integer(forKey: SaveConstants.frequencie)

	}
	
	func sendWeekJokes(){
		
		if !isEnabled || (!isEnglishEnabled && !isPortEnabled ){
			return
		}
		self.isGettingJokes = true
		self.cancelNotifications()
		
		var hourInterval = frequency
		let totalHours = DateConstants.hoursInWeek
		
		DispatchQueue.global().async {
		
			while hourInterval <= totalHours {
				let date = Date(timeIntervalSinceNow: TimeInterval(hourInterval * DateConstants.secondsInHour))
				
				let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
				self.setJoke(date: triggerDate)
				
				DispatchQueue.main.sync {
					if let delegate = self.waitDelegate {
						let percent:Float = Float(hourInterval)/Float(totalHours)
						delegate.retrivalPercentUpdate(value: percent)
					}
				}
				
				hourInterval += self.frequency
				
			}
			self.isGettingJokes = false
			DispatchQueue.main.sync {
				if let delegate = self.waitDelegate {
					delegate.retrivalDone()
				}
			}
		}	
	}
	
	func setJoke(date: DateComponents){
		self.isEnglishEnabled = UserDefaults.standard.bool(forKey: SaveConstants.english)
		self.isPortEnabled = UserDefaults.standard.bool(forKey: SaveConstants.portuguese)
		
		if isEnglishEnabled && isPortEnabled {
			
			if Int(arc4random()) % 2 == 0 {
				 setENGJoke(date: date)
			}else {
				setPTJoke(date: date)
			}
			
		}else if isPortEnabled {
			setPTJoke(date: date)
		}else {
			setENGJoke(date: date)
		}
	}
	
	func setENGJoke(date: DateComponents){
		do {
			
			if self.engJokes == nil {
				self.engJokes = try SharedFileAPI.shared.getENGJokesPromise().wait()
			}
			
			let index = Int(arc4random_uniform(UInt32(engJokes!.count)))
			let joke = engJokes![index]
			
			
			self.setNotification(joke: joke, date: date)
		} catch {
			print(error)
		}
	}
	
	func setPTJoke(date: DateComponents){
		do {

		if self.ptJokes == nil {
			 self.ptJokes = try SharedFileAPI.shared.getPTJokesPromise().wait()
		}
		
		let index = Int(arc4random_uniform(UInt32(ptJokes!.count)))
		let joke = ptJokes![index]
		
		
			self.setNotification(joke: joke, date: date)
		} catch {
			print(error)
		}
	}
	
	func setNotification(joke: Joke, date: DateComponents){
		
		let content = UNMutableNotificationContent()
		content.title = NSString.localizedUserNotificationString(forKey:
			joke.title, arguments: nil)
		content.body = NSString.localizedUserNotificationString(forKey:
			joke.text, arguments: nil)
		
		// Deliver the notification in five seconds.
		content.sound = UNNotificationSound.default()
		let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
		
		// Schedule the notification.
		let request = UNNotificationRequest(identifier: "jokeNotification \(date)", content: content, trigger: trigger)
		let center = UNUserNotificationCenter.current()
		center.add(request, withCompletionHandler: nil)
		
	}
	
	//MARK: debug methods
	
	func printSetup(){
		
		print("IS ENABLED: \(isEnabled)")
		print("ENG: \(isEnglishEnabled)")
		print("PT: \(isPortEnabled)")
		print("FREQ: \(frequency)")
		
	}
	
	func cancelNotifications(){
			let center = UNUserNotificationCenter.current()
			center.removeAllPendingNotificationRequests()
	}
	
}

