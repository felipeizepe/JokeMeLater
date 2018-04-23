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
	internal let webURLPT = "https://us-central1-kivson.cloudfunctions.net/charada-aleatoria"
	internal let headers: HTTPHeaders = [
		"Accept": "application/json"
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
	
	func getJokePromise() -> Promise<Joke> {
		return Promise<Joke>{ fulfiller in
			Alamofire.request(webURL, headers: headers).responseJSON { response in
				if let dict = response.value as? [String:Any] {
					let joke = JSONParser.fromDict(jokeDict: dict)
					fulfiller.fulfill(joke)
				}else {
					fulfiller.fulfill(Joke(id: "01", text: "YOU SPENT A DAY IN A WELL?, well, that's a day well spent!", status: 200, title: "Joke Time!"))
				}
			}
		}
	}
	
	func getPTJokePromise() -> Promise<Joke> {
		return Promise<Joke>{ fulfiller in
			Alamofire.request(webURLPT, headers: headers).responseJSON { response in
				if let dict = response.value as? [String:Any] {
					let joke = JSONParser.fromDict(jokeDictPT: dict)
					fulfiller.fulfill(joke)
				}else {
					fulfiller.fulfill(Joke(id: "01", text: "YOU SPENT A DAY IN A WELL?, well, that's a day well spent!", status: 200, title: "Hora da Piada!"))
				}
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
	
	
}
