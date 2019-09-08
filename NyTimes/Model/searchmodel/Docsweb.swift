//
//  Docsweb.swift
//  Hello-iOS
//
//  Created by Herock Hasan on 18/5/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//

import Foundation
struct Docsweb : Codable {
    
	let web_url : String?
	let snippet : String?
	let multimedia : [Multimedia]?
	let headline : Headline?
	let pub_date : String?
	let document_type : String?
	let uri : String?

	enum CodingKeys: String, CodingKey {

		case web_url = "web_url"
		case snippet = "snippet"
		case multimedia = "multimedia"
		case headline = "headline"
		case pub_date = "pub_date"
		case document_type = "document_type"
		case uri = "uri"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		web_url = try values.decodeIfPresent(String.self, forKey: .web_url)
		snippet = try values.decodeIfPresent(String.self, forKey: .snippet)
		multimedia = try values.decodeIfPresent([Multimedia].self, forKey: .multimedia)
		headline = try values.decodeIfPresent(Headline.self, forKey: .headline)
		pub_date = try values.decodeIfPresent(String.self, forKey: .pub_date)
		document_type = try values.decodeIfPresent(String.self, forKey: .document_type)
		uri = try values.decodeIfPresent(String.self, forKey: .uri)
	}

}
