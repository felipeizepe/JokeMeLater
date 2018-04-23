//
//  FirebaseParser.swift
//  JokeMeUp
//
//  Created by Felipe Izepe on 01/03/18.
//  Copyright © 2018 Felipe Izepe. All rights reserved.
//

import Foundation

class JSONParser {
	
	static func fromDict(jokeDict dict: [String:Any]) -> Joke {
		
		let id = dict[JSONConstants.Joke.id] as! String
		let text = dict[JSONConstants.Joke.joke] as! String
		let status = dict[JSONConstants.Joke.status] as! Int
		
		return Joke(id: id, text: text, status: status, title: "Joke Time!")
		
	}
	
	static func fromDict(jokeDictPT dict: [String:Any]) -> Joke {
		
		let id = dict[JSONConstants.JokePT.id] as! Int
		var text = dict[JSONConstants.JokePT.question] as! String
		text.append("\n\(dict[JSONConstants.JokePT.awnser] as! String)")
		
		return Joke(id: "\(id)", text: text, status: 200, title: "Hora da piada!")
		
	}
	
}
