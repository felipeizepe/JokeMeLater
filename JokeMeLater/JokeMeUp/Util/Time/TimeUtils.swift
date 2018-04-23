//
//  TimeUtils.swift
//  JokeMeUp
//
//  Created by Felipe Izepe on 02/03/18.
//  Copyright © 2018 Felipe Izepe. All rights reserved.
//

import Foundation

class TimeUtils {
	
	static func getCurrentHour() -> Int{
		let date = Date()
		let calendar = Calendar.current
		
		return calendar.component(.hour, from: date)
	}
	
	
}
