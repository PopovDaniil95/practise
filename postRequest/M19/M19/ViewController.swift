//
//  ViewController.swift
//  M19
//
//  Created by Даниил Попов on 14.01.2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    
    var birth = ""
    var occupation = ""
    var name = ""
    var lastName = ""
    var country = ""
    
    
    @IBOutlet weak var birthTF: UITextField!
    @IBOutlet weak var occupationTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    
    @IBAction func tap(_ sender: Any) {
        birthTF.resignFirstResponder()
        occupationTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        lastNameTF.resignFirstResponder()
        countryTF.resignFirstResponder()
    }
    @IBAction func birthTextField(_ sender: UITextField) {
        birth = sender.text ?? " "
    }
    @IBAction func occupationTextField(_ sender: UITextField) {
        occupation = sender.text ?? " "
    }
    @IBAction func nameTextField(_ sender: UITextField) {
        name = sender.text ?? " "
    }
    @IBAction func lastNameTextField(_ sender: UITextField) {
        lastName = sender.text ?? " "
    }
    @IBAction func countryTextField(_ sender: UITextField) {
        country = sender.text ?? " "
    }
    
    @IBAction func onButtonURLSession(_ sender: UIButton) {
        sendRequestWithUrlSession()
    }
    @IBAction func onButtonAlamofire(_ sender: UIButton) {
        sendRequestWithAlamoFire()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func sendRequestWithAlamoFire() {
    let item = Item(birth:birth, occupation: occupation, name: name, lastName: lastName, country: country)
        
           AF.request("https://jsonplaceholder.typicode.com/posts",
                      method: .post,
                      parameters: item,
                      encoder: JSONParameterEncoder.default
           ).response { [weak self] response in
               guard response.error == nil else {
                   self?.creatAlertFailure()
                   return
               }
               self?.creatAlertSucces()
               debugPrint(response)
    }
}

    func sendRequestWithUrlSession() {
        let item = JSON(birth: birth, occupation: occupation, name: name, lastName: lastName, country: country)
        let jsonData = try? JSONSerialization.data(withJSONObject: item.dictionaryRepresentation())
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
            request.httpMethod = "POST"
            request.setValue("aplication/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        self?.creatAlertFailure()
                    }
                    return
                }
                DispatchQueue.main.async {
                    self?.creatAlertSucces()
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }.resume()
        }
    
    func creatAlertSucces() {
        
        let alert = UIAlertController(title: "Succes", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func creatAlertFailure() {
        let alert = UIAlertController(title: "Failure", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
