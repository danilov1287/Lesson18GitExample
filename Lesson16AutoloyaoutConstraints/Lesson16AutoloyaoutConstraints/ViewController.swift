//
//  ViewController.swift
//  Lesson16AutoloyaoutConstraints
//
//  Created by Oleg on 29.05.2026.
//

import UIKit

class ViewController: UIViewController {
    private let img: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .systemBlue
        return img
    }()
    
    private let label1: UILabel = {
        let label = UILabel()
//        label.text = "первого лейбла" // у label'ов равный размер, но у первого есть вободное место
        label.text = " Текст для первого лейбла. Сжатие " // демонстрация сжатия
        label.backgroundColor = .cyan.withAlphaComponent(0.3)
        return label
    }()
    private let label2: UILabel = {
        let label = UILabel()
        label.text = "Очень длинный текст для второго лейбла, который должен сжиматься"
        label.backgroundColor = .lightGray.withAlphaComponent(0.3)
        return label
    }()
    private var horizontalConstraints: [NSLayoutConstraint] = []
    private var vericalConstraints: [NSLayoutConstraint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView([img, label1, label2])
    }

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.setupConstraints(for: size)
        })
    }
    
    private func setupConstraints(for size: CGSize){
        let isLandscape = size.width > size.height
        if isLandscape {
            NSLayoutConstraint.deactivate(self.vericalConstraints)
            NSLayoutConstraint.activate(self.horizontalConstraints)
        } else {
            NSLayoutConstraint.deactivate(self.horizontalConstraints)
            NSLayoutConstraint.activate(self.vericalConstraints)
        }
    }
    
    private func setupView(_ viewList: [UIView]){
        viewList.forEach(){ v in
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }
        horizontalConstraints = getHorizontalConstraints()
        vericalConstraints = getVerticalConstraints()
        setupConstraints(for: view.bounds.size)
    }

    private func getHorizontalConstraints() -> [NSLayoutConstraint]{
        return [// Отступы от краёв
            label1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            img.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            // Равные расстояния между view
            label1.trailingAnchor.constraint(equalTo: label2.leadingAnchor, constant: -20),
            label2.trailingAnchor.constraint(equalTo: img.leadingAnchor, constant: -20),

            // Равная ширина
            label1.widthAnchor.constraint(equalTo: label2.widthAnchor),

            // Вертикальное выравнивание
            label1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label2.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            img.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            img.widthAnchor.constraint(equalToConstant: 100),
            img.heightAnchor.constraint(equalToConstant: 100),
        ]
    }
    private func getVerticalConstraints() -> [NSLayoutConstraint]{
        let labelConstraint = label1.widthAnchor.constraint(equalTo: label2.widthAnchor)
        labelConstraint.priority = .defaultLow // если задать  без приоритета, то сжатия не будет

        let imgConsatraint = img.centerYAnchor.constraint(
            equalTo: view.centerYAnchor,
            constant: -min(view.bounds.height*0.1, 10)
        )
        imgConsatraint.priority = .defaultLow
        
        let constraints = [
            // Позиционирование label1
            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label1.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            label2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label2.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            label1.trailingAnchor.constraint(equalTo: label2.leadingAnchor, constant: -8),

            // Высота (опционально)
            label1.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            label2.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            labelConstraint,
            img.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            img.bottomAnchor.constraint(
                lessThanOrEqualTo: label1.topAnchor,
                constant: -10
            ),
            
            img.widthAnchor.constraint(equalToConstant: 100),
            img.heightAnchor.constraint(equalToConstant: 100),
            imgConsatraint
        ]
        // приоритете сжатие выше равной ширины
        label1.setContentCompressionResistancePriority(.defaultHigh+50, for: .horizontal)
        label2.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return constraints;
    }
}

