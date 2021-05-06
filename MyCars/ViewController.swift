//
//  ViewController.swift
//  MyCars
//
//  Created by Ivan Akulov on 08/02/20.
//  Copyright © 2020 Ivan Akulov. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var lastTimeStartedLabel: UILabel!
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var myChoiceImageView: UIImageView!
    
    @IBAction func segmentedCtrlPressed(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func startEnginePressed(_ sender: UIButton) {
        
    }
    
    @IBAction func rateItPressed(_ sender: UIButton) {
        
    }
    
    private func getDataFromFile() {
        //остановим выполенение метода если в БД уже созданы объекты типа Car
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mark != nil")
        var records = 0
        do {
            records = try context.count(for: fetchRequest)
            print("Is Data there already?")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        guard records == 0 else { return }
        
        
        
        //получим путь до нашего файла
        guard let pathToFile = Bundle.main.path(forResource: "data", ofType: "plist"),
              //извлекаем массив из файла
              let dataArray = NSArray(contentsOfFile: pathToFile)
              else { return }
        //проводим итерацию по массиву, берем данные и помещаем их в CoreData
        for dictionary in dataArray{
            let entity = NSEntityDescription.entity(forEntityName: "Car", in: context)
            let car = NSManagedObject(entity: entity!, insertInto: context) as! Car
            
            let carDictionary = dictionary as! [String : AnyObject]
            car.mark = carDictionary["mark"] as? String
            car.model = carDictionary["model"] as? String
            car.rating = carDictionary["rating"] as! Double
            car.lastStarted = carDictionary["lastStarted"] as? Date
            car.timesDriven = carDictionary["timesDriven"] as! Int16
            car.myChoice = carDictionary["myChoice"] as! Bool
            
            let imageName = carDictionary["imageName"] as? String
            let image = UIImage(named: imageName!)
            let imageData = image!.pngData()
            car.imageData = imageData
            
            if let colorDictionary = carDictionary["tintColor"] as? [String : Float] {
                car.titntColor = getColor(colorDictionary: colorDictionary)
            }
        }
    }
    
    private func getColor(colorDictionary: [String : Float]) -> UIColor {
        guard let red = colorDictionary["red"],
              let green = colorDictionary["green"],
              let blue = colorDictionary["blue"]
              else { return UIColor() }
        
        return UIColor(red: CGFloat(red / 255),
                       green: CGFloat(green / 255),
                       blue: CGFloat(blue / 255),
                       alpha: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
}

