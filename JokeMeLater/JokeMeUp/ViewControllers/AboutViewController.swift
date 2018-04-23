//
//  AboutViewController.swift
//  JokeMeUp
//
//  Created by Felipe Izepe on 05/04/18.
//  Copyright © 2018 Felipe Izepe. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	
	@IBOutlet weak var backgroundBoxView: UIView!
	
	@IBAction func dismissAbout(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		self.imageView.layer.masksToBounds = false
		self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2
		self.imageView.clipsToBounds = true
		self.imageView.layer.borderWidth = 1.0
		self.imageView.layer.borderColor = ColorConstant.appPurple.cgColor
		
		self.backgroundBoxView.layer.masksToBounds = false
		self.backgroundBoxView.layer.cornerRadius = self.backgroundBoxView.frame.size.width/20
		self.backgroundBoxView.clipsToBounds = true
		self.backgroundBoxView.layer.borderWidth = 1.0

	}
	
}
