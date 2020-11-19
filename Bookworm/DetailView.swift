//
//  DetailView.swift
//  Bookworm
//
//  Created by Eman Elrefai on 11/17/20.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingDeleteAlert = false
    
    let book: Book
    
    var body: some View {
        GeometryReader { geomtry in
            VStack {
                VStack {
                    Image(self.book.genre ?? "fantasy").resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -0.5, y: -0.5)
                }
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(self.book.review ?? "No review")
                    .padding()
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                
                Spacer()
            }
        }.background(Color.blue)
        .navigationTitle(Text(book.title ?? "Unknown title" ))
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete Book"), message: Text("Are you sure?"),primaryButton: .destructive(Text("Delete")) {
                self.deleteBook()
            }, secondaryButton: .cancel())
        }
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
    }
    func deleteBook() {
        moc.delete(book)
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test Book"
        book.author = "Test author"
        book.genre = "Fantsy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it"
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
