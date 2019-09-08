//
//  FeedModel.swift
//  Hello-iOS
//
//  Created by Herock Hasan on 18/5/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//

import Foundation
struct FeedModel : Codable {
	let status : String?
	let results : [NyResults]?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case results = "results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		results = try values.decodeIfPresent([NyResults].self, forKey: .results)
	}

}
