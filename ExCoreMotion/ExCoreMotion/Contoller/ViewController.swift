//
//  ViewController.swift
//  ExCoreMotion
//
//  Created by sonjuhyeong on 2023/01/17.
//

import UIKit
import SnapKit
import CoreMotion
import RxSwift

class ViewController: UIViewController {
    
    private let viewModel = ViewModel()
    private var disposeBag = DisposeBag()
    private let mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.onAppear.onNext(())
    }
    
    private func bind() {

        viewModel.output.todayStepCount
            .bind(to: mainView.todayStepsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.weekStepCount
            .bind(to: mainView.weekStepsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.errorAlert
            .subscribe(on: MainScheduler.asyncInstance)
            .bind { [weak self] (alertMessage) in
                self?.alert(message: alertMessage)
            }.disposed(by: disposeBag)
    }

}

extension UIViewController {
    func alert(title : String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
