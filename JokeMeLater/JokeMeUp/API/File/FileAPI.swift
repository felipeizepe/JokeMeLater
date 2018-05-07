//
//  FileAPI.swift
//  JokeMeUp
//
//  Created by Felipe Izepe on 23/02/18.
//  Copyright © 2018 Felipe Izepe. All rights reserved.
//

import Foundation
import PromiseKit

class SharedFileAPI {
	
	//Shared singleton instance
	static let shared: FileAPI = FetchFileAPI()
	
}

protocol FileAPI {
	func getJoke(completion: @escaping (_ success: Bool, _ message: String?, _ joke: Joke?) -> Void)
	func getJokePT(completion: @escaping (_ success: Bool, _ message: String?, _ joke: Joke?) -> Void)
	
	func getJokePromise() -> Promise<Joke>
	func getPTJokePromise() -> Promise<[Joke]>
	
}
