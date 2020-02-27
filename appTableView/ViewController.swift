//
//  ViewController.swift
//  appTableView
//
//  Created by Tecnologico Roque on 2/14/20.
//  Copyright © 2020 Tecnologico Roque. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    var cliente = [Cliente]()
    var db: OpaquePointer?
    
    @IBAction func btnagrega(_ sender: UIButton) {
        if cve.text!.isEmpty || txtnombre.text!.isEmpty || txtdom.text!.isEmpty{
            mostrarAlerta(title: "Faltan datos", message: "Ingresa los Datos Faltantes")
            cve.becomeFirstResponder()
        }
        else{
            let Cve = cve.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let Nom = txtnombre.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let Dom = txtdom.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            var stmt : OpaquePointer?
            let sentencia = "INSERT INTO Cliente(cveCte,nomCte,domCte) VALUES (?,?,?)"
            
            if(sqlite3_prepare(db, sentencia, -1, &stmt, nil) != SQLITE_OK){
                mostrarAlerta(title: "ERROR", message: "Error al ligar sentencia")
                return
                
            }
            
            if (sqlite3_bind_int(stmt, 1, (Cve! as NSString).intValue) != SQLITE_OK) {
                mostrarAlerta(title: "ERROR", message: "Parametro CVE")
                return
            }
            if(sqlite3_bind_text(stmt, 2, Nom, -1, nil) != SQLITE_OK){
                mostrarAlerta(title: "ERROR", message: "Parametro NOM")
                return
            }
            if(sqlite3_bind_text(stmt, 3, Dom, -1, nil) != SQLITE_OK){
                mostrarAlerta(title: "ERROR", message: "Parametro DOM")
                return
            }
            
            if(sqlite3_step(stmt) == SQLITE_DONE){
                mostrarAlerta(title: "GUARDADO", message: "Cliente guardado en la base de  datos")
            }
            else{
                mostrarAlerta(title: "ERRORRRRRR", message: "No Guardo ni Madres")
                return
            }
           
//            cliente.append(Cliente(cvt: cve.text!, nombre: txtnombre.text!, dom: txtdom.text!))
            cve.text = ""
            txtnombre.text = ""
            txtdom.text = ""
            
            //mostrarAlerta(title: "Datos Agregados", message: "Se aggregaron con exito")
        }
    }
    @IBAction func btnconsulta(_ sender: UIButton) {
        cliente.removeAll()
        let query = "Select * From Cliente Order By nomCte"
        var stmt : OpaquePointer?
        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK{
            let error = String(cString: sqlite3_errmsg(db)!)
            mostrarAlerta(title: "Error", message: "Error en la BD: \(error)")
            return
        }
        while (sqlite3_step(stmt) == SQLITE_ROW){
            let cve = sqlite3_column_int(stmt, 0)
            let nom = String(cString : sqlite3_column_text(stmt, 1))
            let dom = String(cString : sqlite3_column_text(stmt, 2))
            cliente.append(Cliente(cvt: String(cve), nombre: String(nom), dom: String(dom)))
        }
        self.performSegue(withIdentifier: "segueLista", sender: self)
    }
    @IBOutlet weak var txtdom: UITextField!
    @IBOutlet weak var cve: UITextField!
    @IBOutlet weak var txtnombre: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mensajelabel.text = ""
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BDSQLiteClientes.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            mostrarAlerta(title: "ERROR ", message: "No se Pudo crear la Base de Datos")
            return
        }
        
        let createTable = "CREATE TABLE IF NOT EXISTS Cliente(cveCte INTEGER PRIMARY KEY, nomCte TEXT, domCte TEXT)"
        if sqlite3_exec(db, createTable, nil, nil, nil) != SQLITE_OK {
            mostrarAlerta(title: "ERROR", message: "No se Puede Crear Tabla")
            return
        }
        mostrarAlerta(title: "ETSITO", message: "SE CREO ESTA MADRE")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueLista"{
        let Lista = segue.destination as! TableViewController
            Lista.cliente = cliente
        }
    }
    
    @IBOutlet weak var mensajelabel: UILabel!
    
    func mostrarAlerta(title: String, message: String) {
        let alertaGuia = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelar = UIAlertAction(title: "Aceptar", style: .default, handler: {(action) in self.mensajelabel.text = "" })
        alertaGuia.addAction(cancelar)
        present(alertaGuia, animated: true, completion: nil)
    }
    
}

