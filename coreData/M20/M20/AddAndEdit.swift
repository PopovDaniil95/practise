//
//  ViewController.swift
//  M20
//
//  Created by Даниил Попов on 22.01.2023.
//

import UIKit

class AddAndEdit: UIViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var labelSurname: UILabel!
    @IBOutlet weak var fieldSurname: UITextField!
    @IBOutlet weak var labelBirthday: UILabel!
    @IBOutlet weak var fieldBirthday: UITextField!
    @IBOutlet weak var labelCountry: UILabel!
    @IBOutlet weak var fieldCountry: UITextField!
    
    var artist: Artist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let artist = artist {
            fieldName.text = artist.name
            fieldSurname.text = artist.surname
            fieldBirthday.text = artist.birthday
            fieldCountry.text = artist.country
        }
    }

    @IBAction func saveData() {
        artist?.name = fieldName.text
        artist?.surname = fieldSurname.text
        artist?.birthday = fieldBirthday.text
        artist?.country = fieldCountry.text
        
        try? artist?.managedObjectContext?.save()
        navigationController?.popViewController(animated: true)
    }
}

