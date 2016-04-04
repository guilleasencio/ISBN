//
//  ViewController.swift
//  isbn
//
//  Created by Guillermo Asencio Sanchez on 4/4/16.
//  Copyright © 2016 Guillermo Asencio Sanchez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    let urlBase = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN"
    
    @IBOutlet weak var respuestaTextView: UITextView!
    @IBOutlet weak var isbn: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isbn.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backgroundTap(sender:UIControl){
        isbn.resignFirstResponder() //desaparece el teclado cuando toca la pantalla
    }
    
    @IBAction func textFieldDidEndEditing(textField: UITextField) {
        let url = NSURL(string: String("\(urlBase):\(isbn.text!)"))

        
        let sesion = NSURLSession.sharedSession()
        
        let bloque = { (datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
            
            //Devolver el control al thread principal una vez se tengan los datos
            dispatch_async(dispatch_get_main_queue()) {
                if (error?.code) == nil{
                    if let respuestaHTTP = resp as? NSHTTPURLResponse {
                        switch respuestaHTTP.statusCode {
                        case 200..<400:
                            let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                            self.respuestaTextView.text = String(texto!)
                        break

                        default:
                            let alertController = UIAlertController(title: "Error", message:
                                "Ocurrió un problema al realizar la petición", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))

                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
                }else{
                    let alertController = UIAlertController(title: "Error", message:
                        "Ocurrió un problema al realizar la petición", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))

                    self.presentViewController(alertController, animated: true, completion: nil)
                }

            }
        }
        
        let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()

    }

    
    @IBAction func textFieldDoneEditing(sender:UITextField)
    {
        sender.resignFirstResponder() //desaparecer el teclado
    }
    
}

