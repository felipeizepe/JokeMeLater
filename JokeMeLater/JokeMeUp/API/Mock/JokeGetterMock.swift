//
//  JokeGetterMock.swift
//  JokeMeUp
//
//  Created by Felipe Izepe on 23/02/18.
//  Copyright © 2018 Felipe Izepe. All rights reserved.
//

import Foundation
import PromiseKit

class JokeGetterMock : FileAPI {
	
	func getENGJokesPromise() -> Promise<[Joke]> {
		return Promise<[Joke]>{ fulfiller in
			fulfiller.fulfill([Joke(id: "01", text: "YOU SPENT A DAY IN A WELL?, well, that's a day well spent!", status: 200, title: "Joke Time!")])
		}
	}
	
	func getPTJokesPromise() -> Promise<[Joke]> {
		return Promise<[Joke]>{ fulfiller in
			fulfiller.fulfill([Joke(id: "01", text: "YOU SPENT A DAY IN A WELL?, well, that's a day well spent!", status: 200, title: "Joke Time!")])
		}
	}
	
	func getJokePT(completion: @escaping (Bool, String?, Joke?) -> Void) {
		completion(true, nil, Joke(id: "01", text: "YOU SPENT A DAY IN A WELL?, well, that's a day well spent!", status: 200, title: "Hora da Piada!"))
	}
	
	func getJoke(completion: @escaping (Bool, String?, Joke?) -> Void) {
		completion(true, nil, Joke(id: "01", text: "YOU SPENT A DAY IN A WELL?, well, that's a day well spent!", status: 200, title: "Joke Time!"))
	}
	
	
	
	
}

