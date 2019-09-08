//
//  SearchJsonModel.swift
//  Hello-iOS
//
//  Created by Herock Hasan on 18/5/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//

import Foundation
struct SearchJsonModel : Codable {
	let status : String?
	let response : Response?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case response = "response"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		response = try values.decodeIfPresent(Response.self, forKey: .response)
	}

}
