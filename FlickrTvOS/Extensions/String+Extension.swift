//
//  String+Extension.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 18/04/23.
//

import Foundation

extension String {
    func trimmed() -> String { self.trimmingCharacters(in: .whitespacesAndNewlines) }
}
