//
//  SnapsViewController.swift
//  Lab10Snapchat
//
//  Created by Fernanda  on 7/11/18.
//  Copyright © 2018 Fernanda Alvarado. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var snaps : [Snap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("snap").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let snap = Snap()
            
            snap.imagenURL  = ((snapshot.value as! Dictionary<String, Any>)["imagenURL"] as! String)
            snap.from       = ((snapshot.value as! Dictionary<String, Any>)["from"] as! String)
            snap.descrip    = ((snapshot.value as! Dictionary<String, Any>)["descripcion"] as! String)
            snap.imagenID   = ((snapshot.value as! Dictionary<String, Any>)["imagenID"] as! String)
            snap.id = snapshot.key
            self.snaps.append(snap)
            self.tableView.reloadData()
        })
        FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("snap").observe(FIRDataEventType.childRemoved, with: {(snapshot) in
            var iterador = 0
            for snap in self.snaps{
                if snap.id == snapshot.key{
                    self.snaps.remove(at: iterador)
                }
                iterador+=1
            }
            self.tableView.reloadData()
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0{
            return 1
        }else{
            return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if snaps.count==0{
            cell.textLabel?.text = "No tienes SNAPS 😗"
        }
        else{
            let snap = snaps[indexPath.row]
            cell.textLabel?.text = snap.from
        }
        
        return cell
    }
    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "versnapSegue", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapSegue"{
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
       
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
