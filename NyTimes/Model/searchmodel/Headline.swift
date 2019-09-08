//
// Headline.swift
//  Hello-iOS
//
//  Created by Herock Hasan on 18/5/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//

import Foundation
struct Headline : Codable {
	let main : String?

	enum CodingKeys: String, CodingKey {

		case main = "main"
		
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		main = try values.decodeIfPresent(String.self, forKey: .main)
		}

}
