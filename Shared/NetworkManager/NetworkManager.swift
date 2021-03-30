import Foundation
class NetworkManager:ObservableObject {
    // step to work with HTTP request
    //1. create urlString
    //2. create session
    //3 working with your task
    
   
    let urlString = "https://peopleinfoapi.herokuapp.com/api/people"
    @Published var people = PeopleModel()
    @Published var isDeleted = false
    @Published var isCreated = false
    @Published var isUpdated = false
    var temp: [String:[People]] = [ : ]
    func performRequest()  {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            //let task =
            session.dataTask(with: url) {(data,respose,error) in
                if (error != nil)
                {
                    print(error!)
                }
                if let safeData = data {
                    //let dataString = String(data:safeData,encoding: .utf8)
                    self.parseJSON(peopleModel: safeData)
                    //                    print(dataString!)
                }
            }.resume() // start task
        }
    }
    
    func parseJSON(peopleModel: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode(PeopleModel.self, from: peopleModel)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.people = decodeData
                self.temp["\(decodeData.meta!.current_page)"] = decodeData.data
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    
    func getByPage(currentScrool:String) {
        let decoder = JSONDecoder()
        var page:Int = 0
        page = people.meta?.current_page ?? 0
        if currentScrool == "up"
        {
        
            page = page + 1
            if page <= people.meta!.last_page && people.meta!.current_page != people.meta!.last_page{
                
                   if let url = URL(string: "\(urlString)?page=\(page)"){
                       print(url)
                       let session = URLSession(configuration: .default)
                       //let task =
                       session.dataTask(with: url) {(data,respose,error) in
                           if (error != nil)
                           {
                               print(error!)
                           }
                           if let safeData = data {
                              
                               do {
                                   let decodeData =  try decoder.decode(PeopleModel.self, from: safeData)
                                   
                                   DispatchQueue.main.async {
                                     self.people.data = []
                                       self.people.data.append(contentsOf: decodeData.data)
                                       self.people.links = decodeData.links
                                       self.people.meta = decodeData.meta
                                       self.temp["\(page)"] = self.people.data
                                   
                                   }
                                   
                               }
                               catch{
                                   print("error parse JSON \(error)")
                               }
                             
           //                    self.parseJSON(peopleModel: safeData)
                               print(self.temp["1"])
                               print(self.temp["2"])
                               print(self.temp["3"])
                           }
                       }.resume() // start task
                   }
            }
            
           
            
           
        }
        else{
            if page > 1 {
            
             
                DispatchQueue.main.async {
                    page = page - 1
                    print(page)
                    print(self.temp["\(page)"])
                    self.people.data = []
                    self.people.data = self.temp["\(page)"]!
                    self.people.meta!.current_page =  (self.people.meta!.current_page) - 1
                  
                }
            
            }
        }
       

    }
    
    
    func deletePeople(id: Int)  {
        let personId =  people.data[id].id
        print(personId)
        
        var request = URLRequest(url:URL(string: "\(urlString)/\(personId)")!)
        
        request.httpMethod  = "DELETE"
        let session = URLSession(configuration: .default)
        session.dataTask(with: request){(data,res,err)in
          
            if err != nil {
                print(err!.localizedDescription)
                
            }
            if err == nil,let data = data, let response = res as? HTTPURLResponse {
                print(response.statusCode)
                print(data)
              
                DispatchQueue.main.async {
                    self.people.data.removeAll{
                        (person)-> Bool in
                        return person.id == id
                    }
                    self.isDeleted = true
                    self.performRequest()
                }
                
            }
            
        }.resume()
    }
    
    func createNew(person:People)  {
        
        var request = URLRequest(url:URL(string: urlString)!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "first_name": person.first_name,
            "last_name": person.last_name,
            "age": person.age,
            "active_date": person.active_date,
            
        ]
        // covert diectionary to json
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        request.httpBody =  jsonData
        
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request){(data,res,err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            guard let _ = data else {return}
            if err == nil,let response = res as? HTTPURLResponse {
                if response.statusCode == 201
                {
                    DispatchQueue.main.async {
                        self.isCreated = true
                    }
                }
            }
         
        }.resume()
        
    }
    func updatePerson(id:Int, person:People) {
        
        var request = URLRequest(url:URL(string: "\(urlString)/\(id)")!)
        print("url request to update \(request)")
        request.httpMethod  = "PUT"
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "first_name": person.first_name,
            "last_name": person.last_name,
            "age": person.age,
            "active_date": person.active_date,
            
        ]
        // covert diectionary to json
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        request.httpBody =  jsonData
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request){(data,res,err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            if err == nil,let response = res as? HTTPURLResponse {
                if response.statusCode == 200
                {
                    DispatchQueue.main.async {
                        self.isUpdated = true
                    }
                }
            }
            guard let response = data else {return}
            let status = String(data:response,encoding: .utf8) ?? ""
            
            print(status)
            
        }.resume()
    }
}
