//
//  TagSelector.swift
//  Notes
//
//  Created by Nagy Bence Damján on 2026. 03. 23..
//

import SwiftUI
import SwiftData

struct TagSelector: View {
	@Environment(\.editMode) var editMode
	@Query private var tags: [Tag] = []
	@Binding var selectedTags: Set<Tag>

	var body: some View {
		List (selection: $selectedTags) {
			ForEach (tags, id:\.id) { tag in
				Text("#" + tag.text)
					.tag(tag)
			}
			.onMove{ a, b in
				
			}
		}
		.onAppear {
			editMode?.wrappedValue = .active
		}
		.onDisappear {
			editMode?.wrappedValue = .inactive
		}
    }
}

#Preview {
	@State @Previewable var selectedTags: Set<Tag> = []
    TagSelector(selectedTags: $selectedTags)
}
