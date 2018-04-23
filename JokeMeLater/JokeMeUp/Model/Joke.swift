//
//  Joke.swift
//  JokeMeUp
//
//  Created by Felipe Izepe on 22/02/18.
//  Copyright © 2018 Felipe Izepe. All rights reserved.
//

import Foundation


class Joke {
	
	var id: 				String
	var text:				String
	var status:			Int
	var title: 			String
	
	init(id: String, text: String, status: Int, title: String) {
		self.id = id
		self.text = text
		self.status = status
		self.title = title
	}
	
}
