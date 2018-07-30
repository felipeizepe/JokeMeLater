//
//  FetchFileAPI.swift
//  JokeMeUp
//
//  Created by Felipe Izepe on 01/03/18.
//  Copyright © 2018 Felipe Izepe. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class FetchFileAPI: FileAPI {
	
	internal let webURL = "https://icanhazdadjoke.com/"
	//Link to git: https://github.com/kivson/charadas
	internal let webURLPT = "https://us-central1-kivson.cloudfunctions.net/charada-aleatoria"
	internal let filePathENG = "jokesENG"
	internal let filePathPT = "jokesPT"
	internal let headers: HTTPHeaders = [
		"Accept": "application/json",
		"User-Agent":" My Project Git (https://github.com/felipeizepe/JokeMeLater.git) https://www.facebook.com/jkLater/"
	]
	
	func getJoke(completion: @escaping (Bool, String?, Joke?) -> Void) {
		
		Alamofire.request(webURL, headers: headers).responseJSON { response in
			
			if let dict = response.value as? [String:Any] {
				let joke = JSONParser.fromDict(jokeDict: dict)
				completion(true, nil, joke)
			}else {
				completion(false, "Could not retrive joke", nil)
			}
		}
		
	}
	
	func getJokePT(completion: @escaping (_ success: Bool, _ message: String?, _ joke: Joke?) -> Void){
		Alamofire.request(webURLPT, headers: headers).responseJSON { response in
			
			if let dict = response.value as? [String:Any] {
				let joke = JSONParser.fromDict(jokeDictPT: dict)
				completion(true, nil, joke)
			}else {
				completion(false, "Could not retrive joke", nil)
			}
		}
	}
	
	func getENGJokesPromise() -> Promise<[Joke]> {
		return Promise<[Joke]>{ fulfiller in
			var jokes = [Joke]()
			let path = Bundle.main.url(forResource: filePathENG, withExtension: "JSON")
			do {
				let jsonData = try Data(contentsOf: path!)
				guard let parsedJson = try JSONSerialization.jsonObject(with: jsonData) as? [String:Any] else {return}
				guard let array = parsedJson["jokes"] as? [[String:Any]] else {
					fulfiller.fulfill([Joke(id: "01", text: "YOU SPENT A DAY IN A WELL?, well, that's a day well spent!", status: 200, title: "Hora da Piada!")])
					
					return
				}
				var index = 0
				for dict in array {
					let joke = JSONParser.fromDict(jokeDict: dict)
					joke.id = String(index)
					jokes.append(joke)
					index += 1
				}
				
				fulfiller.fulfill(jokes)
			} catch {
				fulfiller.fulfill(jokes)
			}
		}
	}
	
	func getPTJokesPromise() -> Promise<[Joke]> {
		return Promise<[Joke]>{ fulfiller in
			var jokes = [Joke]()
			let path = Bundle.main.url(forResource: filePathPT, withExtension: "JSON")
			do {
				let jsonData = try Data(contentsOf: path!)
				guard let parsedJson = try JSONSerialization.jsonObject(with: jsonData) as? [String:Any] else {return}
				guard let array = parsedJson["charadas"] as? [[String:Any]] else {
					fulfiller.fulfill([Joke(id: "01", text: "YOU SPENT A DAY IN A WELL?, well, that's a day well spent!", status: 200, title: "Hora da Piada!")])
					
					return
				}
				var index = 0
				for dict in array {
					let joke = JSONParser.fromDict(jokeDictPT: dict)
					joke.id = String(index)
					jokes.append(joke)
					index += 1
				}
				
				fulfiller.fulfill(jokes)
			} catch {
				fulfiller.fulfill(jokes)
			}
		}
	}
	
	
}
