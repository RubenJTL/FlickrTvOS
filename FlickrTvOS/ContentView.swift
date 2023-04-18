//
//  ContentView.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		VStack {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundColor(.accentColor)
			Text("Hello, world!")
		}
		.padding()
	}
	enum TEST {
		case unowned
		
		var test: String {
			
			switch self {

			case .unowned:
				return "Hika"
			}
		}
	}


}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
