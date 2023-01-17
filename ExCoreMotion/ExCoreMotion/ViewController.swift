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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "CoreMotion"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private let todayStepsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let weekStepsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .blue
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let viewModel = ViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureConstraints()
    
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let auth = viewModel.checkAuthorization()
        viewModel.input.authorizationState.onNext(auth)
    }
    
    private func bind() {

        viewModel.output.todayStepCount
            .bind(to: self.todayStepsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.weekStepCount
            .bind(to: self.weekStepsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.errorAlert
            .bind { [weak self] (alertMessage) in
                DispatchQueue.main.async {
                    self?.alert(message: alertMessage)
                }
            }.disposed(by: disposeBag)

    }
    
    private func setAddSubviews() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(todayStepsLabel)
        self.view.addSubview(weekStepsLabel)
        self.view.addSubview(startDateLabel)
        self.view.addSubview(endDateLabel)
    }
    
    private func configureConstraints() {
        setAddSubviews()
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        todayStepsLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        weekStepsLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(todayStepsLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        startDateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(weekStepsLabel.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        endDateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(startDateLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }

    
}

extension ViewController {
    func alert(title : String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
