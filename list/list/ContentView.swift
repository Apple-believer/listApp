


import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to:nil,from:nil,for:nil
        )
    }
}

struct ContentView: View {
    @State var theText: String = ""
    var body: some View {
        NavigationView {
            TextEditor(text: $theText)
                .lineSpacing(10)
                .border(Color.gray)
                .padding([.leading,.bottom,.trailing])
                .navigationTitle("復元できるメモ")
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            if let data  = loadText("sample.txt") {
                                theText = data
                            }
                        } label: {
                            Text("読み込み")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            UIApplication.shared.endEditing()
                            saveText(theText, "sample.txt")
                        } label: {
                            Text("保存")
                        }
                    }
                    
                }
        }
    }
    
    func saveText(_ textData:String, _ fileName:String){
        
        guard let url = docURL(fileName) else {
            return
        }
        
        do {
            let path = url.path
            try textData.write(toFile: path, atomically: true, encoding:  .utf8)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func docURL(_ fileName:String) -> URL? {
        let fileManager = FileManager.default
        do {
            
            let docsUrl = try fileManager.url(
                
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false)
            let url = docsUrl.appendingPathComponent(fileName)
            return url
        }catch {
            return nil
        }
    }
    
    func loadText(_ fileName:String) -> String? {
        guard let url = docURL(fileName) else {
            return nil
        }
        
        do {
            let textData = try String(contentsOf: url, encoding: .utf8)
            return textData
        } catch {
            return nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

