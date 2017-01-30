//
//  ServiceManager.swift
//  Tender
//
//  Created by Michael Liu on 1/28/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ServiceManager: NSObject {
    
    var ref:FIRDatabaseReference = FIRDatabase.database().reference()
    
    func getMostRecentServices()->[Service]{
        let path = ref.child("services")
        var services:[Service] = []
        path.queryOrdered(byChild: "date").observe(.value, with: { (snapshot) in
            for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let service = self.parseServiceData(child: child)
                print(service)
                services.append(service)
            }
        })
        return services
    }
    
    func getServicesByCategory(name:String)->[Service]{
        let path = ref.child("services")
        var services:[Service]?
        path.queryOrdered(byChild: "category").queryEqual(toValue: name).observe(.childAdded, with: { (snapshot) in
            for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let service = self.parseServiceData(child: child)
                services?.append(service)
            }
        })
        return services!
    }
    
    func postService(service:Service){
        let userData = getCurrentUserData()
        if userData == nil {
            print("User has not signed in")
            return
        }
        let thumbnail = userData?["thumbnail"]!
        let provider = userData?["provider"]!
        let uid = userData?["uid"]!
        let now = convertDatetoString(date: Date())
        //try to post new service
        let path = ref.child("services").childByAutoId()
        let data = ["category":service.category ?? "Creative Work",
                    "title":service.title ?? "Empty Service",
                    "credit":service.credits ?? "1",
                    "visible":"\(true)",
                    "date": now,
                    "sets":service.skills ?? [],
                    "uid": uid!,
                    "provider":provider!,
                    "thumbnail":thumbnail!] as [String : Any]
        path.setValue(data)
    }
    
    func parseServiceData(child:FIRDataSnapshot)->Service{
        let service = Service()
        for elem:FIRDataSnapshot in child.children.allObjects as! [FIRDataSnapshot]{
            switch elem.key{
            case "uid":
                service.provider = elem.value as! String
                break
            case "category":
                service.category = elem.value as! String
                break
            case "title":
                service.title = elem.value as! String
                break
            case "credit":
                service.credits = elem.value as! String
                break
            case "date":
                service.date = elem.value as! String
                break
            case "sets":
                var skills:[String] = []
                for skill:FIRDataSnapshot in elem.children.allObjects as! [FIRDataSnapshot]{
                    skills.append(skill.value as! String)
                }
                service.skills = skills
                break
            default:
                break
            }
        }
        return service
    }
    
}
