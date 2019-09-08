//
//  Multimedia.swift
//  Hello-iOS
//
//  Created by Herock Hasan on 18/5/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//

import Foundation
struct Multimedia : Codable {

	let type : String?
	let url : String?
	

	enum CodingKeys: String, CodingKey {

		
		case type = "type"
		case url = "url"

		
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		type = try values.decodeIfPresent(String.self, forKey: .type)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		
	}

}
