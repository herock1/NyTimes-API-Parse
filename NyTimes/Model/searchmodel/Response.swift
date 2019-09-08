//
//  Response.swift
//  Hello-iOS
//
//  Created by Herock Hasan on 18/5/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//

import Foundation
struct Response : Codable {
	let docs : [Docsweb]?

	enum CodingKeys: String, CodingKey {

		case docs = "docs"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		docs = try values.decodeIfPresent([Docsweb].self, forKey: .docs)
	}

}
