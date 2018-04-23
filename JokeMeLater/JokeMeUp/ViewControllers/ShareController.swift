//
//  ShareController.swift
//  JokeMeUp
//
//  Created by Felipe Izepe on 22/02/18.
//  Copyright © 2018 Felipe Izepe. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import GoogleMobileAds

class ShareViewController: UIViewController {
	
	//MARK: Outlets
	@IBOutlet weak var jokeTextLabel: UILabel!
	
	@IBOutlet weak var shareButton: UIButton!
	
	@IBOutlet weak var bannerView: GADBannerView!

	@IBOutlet weak var infoButton: UIButton!
	//Received argument
	var receivedJokeText: String?
	
	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		if let text = receivedJokeText{
			self.jokeTextLabel.text = text
		}
		
		bannerView.adUnitID = "ca-app-pub-8673913558227099/8552696807"
		bannerView.rootViewController = self
		bannerView.load(GADRequest())
		
	}
	
	@IBAction func shareCliecked(_ sender: Any) {
		if let text = receivedJokeText {
			let linkToStore = NSURL(string: LinkConstants.linkToStore)
			
			let activityViewController = UIActivityViewController(activityItems: [linkToStore as Any, text], applicationActivities: nil)
			
			// This lines is for the popover you need to show in iPad
			activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
			
			// This line remove the arrow of the popover to show in iPad
			activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
			activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
			
			// Anything you want to exclude
			activityViewController.excludedActivityTypes = [
				UIActivityType.postToWeibo,
				UIActivityType.print,
				UIActivityType.assignToContact,
				UIActivityType.saveToCameraRoll,
				UIActivityType.addToReadingList,
				UIActivityType.postToFlickr,
				UIActivityType.postToVimeo,
				UIActivityType.postToTencentWeibo
			]
			
			self.present(activityViewController, animated: true, completion: nil)

		}
		
		
	}
}
