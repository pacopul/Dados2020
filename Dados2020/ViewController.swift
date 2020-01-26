//
//  ViewController.swift
//  Dados2020
//
//  Created by Paco Pulido on 16/01/2020.
//  Copyright © 2020 PacoPul. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var ivDado1: UIImageView!
    @IBOutlet weak var ivDado2: UIImageView!
    @IBOutlet weak var ivDado3: UIImageView!
    @IBOutlet weak var ivDado4: UIImageView!
    @IBOutlet weak var ivDado5: UIImageView!
    @IBOutlet weak var lblIntentos: UILabel!
    var intentos = 0;
    var ivDados = [UIImageView]()
    var marcados = [Bool]()
    var jugada = [Int](repeating:0, count: 5)
    
    var player : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resetGame()
        loadAnimations()
        loadAudio()
        inventa()
    }
    
    func resetGame() {
        ivDados = [ivDado1, ivDado2, ivDado3,ivDado4,ivDado5]
        marcados = [false,false,false,false,false]
        intentos = 0
    }

    func loadAnimations() {
        ivDados = [ivDado1, ivDado2, ivDado3,ivDado4,ivDado5]
        for ivDado in ivDados {
            ivDado.animationImages = [UIImage]()
            for j in 0 ..< 6 {
                let frameName = "cara\(j)"
                ivDado.animationImages?.append(UIImage(named: frameName)!)
            }
            ivDado.animationDuration = 0.6
        }
    }
    
    func loadAudio() {
        do {
            // desenvolviendo una variable (unwrapping var)
            if let fileURL = Bundle.main.path(forResource: "sonido", ofType:"mp3") {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
            } else {
                print("No existe fichero de sonido")
            }
        } catch let error {
            print("Error en la carga del sonido \(error.localizedDescription)")
        }
    }
    
    func inventa() {
        var n = 0;
        var image:UIImage!
        for (i,ivDado) in ivDados.enumerated() {
            if (!marcados[i]){
                n = Int(arc4random() % 6);
                image = UIImage(named: "cara\(n)")
                ivDado.image=image
                jugada[i] = n
            }
        }
    }
    
    @IBAction func onClickPlay(_ sender: UIButton) {
        let btnPlay = sender
        
        intentos += 1
        lblIntentos.text = "\(intentos)"
        
        for (i, ivDado) in ivDados.enumerated() {
            if (!marcados[i]){
                ivDado.startAnimating()
            }
        }
        // desenvolviendo una variable (unwrapping var)
        if let player = player{
            player.play()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute:{
            for (i, ivDado) in self.ivDados.enumerated() {
                if (!self.marcados[i]){
                    ivDado.stopAnimating()
                }
            }
            self.inventa()
            if (self.fin()) {
                btnPlay.isEnabled = false
            }
        })
    }
    @IBAction func onClickDado(_ sender: UIButton) {
        let n = sender.tag
        
        marcados[n] = !marcados[n]
        
        if (marcados[n]){
            let image = UIImage(named: "cara\(jugada[n])v")
            ivDados[n].image=image
        }
        else {
            let image = UIImage(named: "cara\(jugada[n])")
            ivDados[n].image=image
        }
    }
    
    func fin() -> Bool {
        if (todosIguales()) {
            marcarTodos()
            let alert = UIAlertController(title: "Fin", message:
                "Conseguido en \(intentos) intentos.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default,handler: nil))
            self.present(alert, animated: true, completion: nil)
            return true
        }
        return false
        
    }
    
    func todosIguales() -> Bool {
        let valor = jugada[0]
        for n in jugada {
            if (n != valor) {
                return false
            }
        }
        return true
    }
    
    func marcarTodos() {
        for i in 0 ..< 5 {
            if (!marcados[i]){
                let image = UIImage(named: "cara\(jugada[i])v")
                ivDados[i].image=image
            }
        }
    }
}

