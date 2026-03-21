//
//  NoteEditor.swift
//  Notes
//
//  Created by Nagy, Bence Damján on 2026. 03. 09..
//

import SwiftUI
import SwiftData

struct NoteEditor : View {
	@State var title: String = ""
	@State var text: String = ""
	@State var tags: Set<Tag> = []

	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss
	let note: Note

	var body: some View {
		VStack {
			TextField("Title", text: $title)
			TextEditor(text: $text)
				.background(Color(.systemBackground))
			Button("Save") {
				note.tags.removeAll()

				for word in text.split(separator: " ") {
					guard !word.isEmpty else {
						continue
					}
					guard word.first == "#" else {
						continue
					}
					
					let text = String(word.dropFirst(1))
					let tag = Tag(text: text)
					guard !note.tags.contains(tag) else {
						continue
					}
					
					self.tags.insert(tag)
				}
				note.tags = self.tags.compactMap({ $0 })
				note.title = title
				note.text = text
				do {
					try modelContext.save()
				}
				catch {
					print(error.localizedDescription)
				}
				dismiss.callAsFunction()
			}.onAppear {
				title = note.title
				text = note.text
			}
		}
		.padding(EdgeInsets.init(top: 20, leading: 20, bottom: 20, trailing: 20))
	}
}

class TagPosition {
	var start: Int
	var end: Int
	var tag: Tag
	
	init(start: Int, end: Int, tag: Tag) {
		self.start = start
		self.end = end
		self.tag = tag
	}
}

// first steps to a text editor which handles the addition of tags
//	I've decided to not go forward with it for now due to its complexity,
//	but I'll keep it here for (my) educational purposes
struct TagsWatchingTextEditor : UIViewRepresentable {
	@Binding var text: String
	@Binding var tagPositions: [TagPosition]
	
	func updateUIView(_ uiView: UITextView, context: Context) {	}
	
	func makeUIView(context: Context) -> UITextView {
		var textView = UITextView()
		textView.textStorage.delegate = context.coordinator
		textView.delegate = context.coordinator
		textView.text = text

		// TODO: parse text initially for labels

		return textView
	}
	
	func makeCoordinator() -> Coordinator {
		.init(text: $text, tagPositions: $tagPositions)
	}

	class Coordinator : NSObject, NSTextStorageDelegate, UITextViewDelegate {
		@Binding var text: String
		@Binding var tagPositions: [TagPosition]
		
		init(text: Binding<String>, tagPositions: Binding<[TagPosition]>) {
			self._text = text
			self._tagPositions = tagPositions
		}
		
		func textStorage(
			_ textStorage: NSTextStorage,
			willProcessEditing editedMask: NSTextStorage.EditActions,
			range editedRange: NSRange,
			changeInLength delta: Int
		) {
			//check which tags are in the current change in length, partial selection is not possible
			//if caret is at the border of a tag and a deletion arrives to delete the tag, the entire
			//	tag should be deleted, not only its first/last character
			//remove those from the tagPositions
			//update tagpositions
		}
		
		/*func textStorage(
			_ textStorage: NSTextStorage,
			didProcessEditing editedMask: NSTextStorage.EditActions,
			range editedRange: NSRange,
			changeInLength delta: Int
		) {
			guard editedMask.contains(NSTextStorage.EditActions.editedCharacters) else {
				return
			}
			
			
		}*/
		
		func textViewDidChangeSelection(_ textView: UITextView) {
			guard var selectionRange = textView.selectedTextRange else {
				return
			}
			var newStartPosition = selectionRange.start
			var newEndPosition = selectionRange.end

			var cursorAffinity = textView.selectionAffinity
			
			var selectionStartAdjusted = false
			var selectionEndAdjusted = false

			for tagPosition in tagPositions {
				let tagLength = tagPosition.end - tagPosition.start
				var tagStart = textView.position(from: textView.beginningOfDocument, offset: tagPosition.start)!
				var tagEnd = textView.position(from: textView.beginningOfDocument, offset: tagPosition.end)!
				
				adjustSelectionStart: if !selectionStartAdjusted {
					let selectionStartIsAfterTagStart = textView.compare(selectionRange.start, to: tagStart) == .orderedDescending
					let selectionStartIsBeforeTagEnd = textView.compare(selectionRange.end, to: tagStart) == .orderedAscending

					if selectionStartIsAfterTagStart && selectionStartIsBeforeTagEnd {
						let offsetFromStart = textView.offset(from: tagStart, to: selectionRange.start)
						let offsetFromEnd = textView.offset(from: selectionRange.start, to: tagEnd)
						let closerPosition = offsetFromStart < offsetFromEnd ? selectionRange.start : selectionRange.end
						newStartPosition = closerPosition
						selectionStartAdjusted = true
					}
				}

				adjustSelectionEnd: if !selectionEndAdjusted {
					let selectionEndIsAfterTagStart = textView.compare(selectionRange.start, to: tagEnd) == .orderedDescending
					let selectionEndIsBeforeTagEnd = textView.compare(selectionRange.end, to: tagEnd) == .orderedAscending

					if selectionEndIsAfterTagStart && selectionEndIsBeforeTagEnd {
						let offsetFromStart = textView.offset(from: tagEnd, to: selectionRange.start)
						let offsetFromEnd = textView.offset(from: selectionRange.start, to: tagEnd)
						let closerPosition = offsetFromStart < offsetFromEnd ? selectionRange.start : selectionRange.end
						newEndPosition = closerPosition
						selectionEndAdjusted = true
					}
				}
				if selectionStartAdjusted && selectionEndAdjusted {
					break
				}
			}
			
			textView.selectedTextRange = textView.textRange(from: newStartPosition, to: newEndPosition)
		}
	}
}

#Preview {
	//@State @Previewable var tags: Set<Tag> = [Tag(text:"swift"), Tag(text:"ui"), Tag(text:"preview")]
	NoteEditor(note: Note(title: "abcab", text: "textual"))
}

