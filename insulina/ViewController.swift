//
//  ViewController.swift
//  insulina
//
//  Created by Julia  on 02/03/20.
//  Copyright © 2020 Julia Machado. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Teclado funcionar dentro do text field
        doseFixaTextField.delegate = self
        glicemiaAntesTextField.delegate = self
        
        // Clicar na tela para teclado desaparecer
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Adicionar botao de retorno em cada teclado de text field
        doseFixaTextField.addDoneButtonToKeyboard(myAction: #selector(self.doseFixaTextField.resignFirstResponder))
        glicemiaAntesTextField.addDoneButtonToKeyboard(myAction: #selector(self.glicemiaAntesTextField.resignFirstResponder))
        
        // Botao VOLTAR escondido durante passo 1
        voltarButtonOutlet.isHidden = true
        
        // Bordas redondas do botao
        doseFixaTextField.borderStyle = UITextField.BorderStyle.roundedRect
        
        glicemiaAntesTextField.borderStyle = UITextField.BorderStyle.roundedRect
        
        // Resultado escondido
        viewPasso2.isHidden = true
        
        // Cronometro escondido
        viewPasso3.isHidden = true
        
        
        // Do any additional setup after loading the view.
    }
    
    // Passo 1
    @IBOutlet var doseFixaTextField: UITextField!
    @IBOutlet var glicemiaAntesTextField: UITextField!
    @IBOutlet var viewPasso1: UIView!
    @IBOutlet var calcularButtonOutlet: UIButton!
    
    @IBAction func calcularButton() {
        
        if doseFixaTextField.text == "" || glicemiaAntesTextField.text == "" {
            alertaPreenchimento()
        } else {
            
            // Ler text fields de dose fixa e glicemia atual em int
            let conteudoDoseFixa: Int
            conteudoDoseFixa = lerTextField(textField: doseFixaTextField)
            print(conteudoDoseFixa)
            
            let conteudoGlicemiaAntes: Int
            conteudoGlicemiaAntes = lerTextField(textField: glicemiaAntesTextField)
            print(conteudoGlicemiaAntes)
            
            // Regra de 3
            // Dose Atual = Dose Fixa x Glicemia Atual / 100 (nivel de Glicemia Ideal do ser humano)
            let resultadoInsulina:Int = conteudoDoseFixa * conteudoGlicemiaAntes / 100
            
            let resultadoInsulinaString = "\(String(resultadoInsulina))mL"
            
            resultadoInsulinaLabel.text = resultadoInsulinaString
            
            let salvarInfo = Info(dose:conteudoDoseFixa, glicemia1:conteudoGlicemiaAntes, resultado: resultadoInsulinaString)
            print(salvarInfo.resultado)
            
            // Mudar pagina
            if paginaAtual == 0 {
                paginaAtual = 1
                viewPasso1.isHidden = true
                viewPasso2.isHidden = false
                voltarButtonOutlet.isHidden = false
                viewPasso3.isHidden = true
                
            }
            else if paginaAtual == 1 {
                paginaAtual = 2
                viewPasso2.isHidden = true
                viewPasso3.isHidden = false
                
                // Rodar cronometro
                count = 3600
                rodarCronometro()
                
            }
            else if paginaAtual == 2 {
                limparTextFields()
                pararCronometro()
                cronometroLabel.text = "60:00"
                paginaAtual = 0
                viewPasso1.isHidden = false
                voltarButtonOutlet.isHidden = true
                viewPasso3.isHidden = true
                
            }
            
            // Mudar imagem da barra
            mudarBarra()
            
            // Mudar texto botao
            mudarButton()
            
        }
    }
    
    // Alertar em caso de campo nao preenchido
    func alertaPreenchimento(){
        let alerta = UIAlertController(title: "Atenção!", message: "Preencha todos os campos", preferredStyle: UIAlertController.Style.alert)
        let botaoOk = UIAlertAction(title: "Confirmar", style: UIAlertAction.Style.default) {
            (UIAlertAction) in
        }
        alerta.addAction(botaoOk)
        
        self.present(alerta, animated: true, completion: nil)
    }
    
    // Passo 2
    
    @IBOutlet var viewPasso2: UIView!
    @IBOutlet var resultadoInsulinaLabel: UILabel!
    
    @IBAction func voltarButton() {
        
        if paginaAtual == 1 {
            limparTextFields()
            paginaAtual = 0
            viewPasso1.isHidden = false
            viewPasso2.isHidden = true
            viewPasso3.isHidden = true
            
        }
        else if paginaAtual == 2 {
            cronometroLabel.text = "60:00"
            pararCronometro()
            paginaAtual = 1
            viewPasso3.isHidden = true
            viewPasso2.isHidden = false
            
        }
        
        mudarBarra()
        
        mudarButton()
        
    }
    
    @IBOutlet var voltarButtonOutlet: UIButton!
    
    // Passo 3
    @IBOutlet var viewPasso3: UIView!
    
    @IBOutlet var cronometroLabel: UILabel!
    
    var timer = Timer()
    var count = 0 // Segundos
    
    // Funcao que chama o cronometro
    func rodarCronometro(){
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(atualizarTempo), userInfo: nil, repeats: true)
    }
    
    // Rodar tempo
    @objc func atualizarTempo() {
        
        if(count > 0){
            var minutos = String(count / 60)
            var segundos = String(count % 60)
            if(minutos.count<2){
                minutos = "0"+minutos
            }
            if(segundos.count<2){
                segundos = "0"+segundos
            }
            cronometroLabel.text = minutos + ":" + segundos
            count-=1
        }
        
    }
    
    // Parar cronometro
 
    func pararCronometro () {
        timer.invalidate()
    }
    
    // Funcoes gerais
    func lerTextField(textField: UITextField) -> Int {
        
        // Acessar text fields de dose fixa, glicemia antes, glicemia depois
        // Transformar texto string em int e retornar conteudo em int
        let conteudoTextField = textField.text
        let conteudoTextFieldInt = Int(conteudoTextField!)
        return conteudoTextFieldInt!
    }
    
    var paginaAtual: Int = 0
    
    func mudarBarra() {
        if paginaAtual == 0 {
            barra.image = UIImage(named: "passo1")
        }
        else if paginaAtual == 1 {
            barra.image = UIImage(named: "passo2")
        }
        else if paginaAtual == 2 {
            barra.image = UIImage(named: "passo3")
        }
    }
    
    func mudarButton() {
        if paginaAtual == 0 {
            calcularButtonOutlet.setTitle("Calcular", for: .normal)
        }
        else if paginaAtual == 1 {
            calcularButtonOutlet.setTitle("Pronto", for: .normal)
        }
        else if paginaAtual == 2 {
            calcularButtonOutlet.setTitle("Início", for: .normal)
            
        }
        
    }
    
    // Limpar text fields
    func limparTextFields() {
        if paginaAtual != 0 {
            self.doseFixaTextField.text = nil
            self.glicemiaAntesTextField.text = nil
        }
    }
    
    
    // Gerais
    @IBOutlet var barra: UIImageView!
    
    
}

// Adicionar botao de retorno no teclado
extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Finalizar", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}
