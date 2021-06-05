//
//  HomeViewController.swift
//  Instagrid
//
//  Created by Valc0d3 on 07/05/2021.
//

import UIKit

final class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - IBOutlets

    @IBOutlet private weak var viewTitleLabel: UILabel!
    @IBOutlet private weak var swipeLabel: UILabel!
    @IBOutlet private weak var swipeArrowImageview: UIImageView!
    
    @IBOutlet private weak var topLeftView: UIView!
    @IBOutlet private weak var topRightView: UIView!
    @IBOutlet private weak var bottomLeftView: UIView!
    @IBOutlet private weak var bottomRightView: UIView!
    
    @IBOutlet private weak var layoutOneButton: UIButton!
    @IBOutlet private weak var layoutTwoButton: UIButton!
    @IBOutlet private weak var layoutThreeButton: UIButton!
    // MARK: - Properties

    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = true
        return imagePicker
    }()

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - IBActions

    @IBAction private func didPressLayoutOne() {
        bottomRightView.isHidden = false
        topRightView.isHidden = true
        layoutOneButton.alpha = 0.4
        layoutTwoButton.alpha = 1
        layoutThreeButton.alpha = 1
    }

    @IBAction private func didPressLayoutTwo() {
        bottomRightView.isHidden = true
        topRightView.isHidden = false
        layoutOneButton.alpha = 1
        layoutTwoButton.alpha = 0.4
        layoutThreeButton.alpha = 1
        
    }
    
    @IBAction private func didPressLayoutTree() {
        bottomRightView.isHidden = false
        topRightView.isHidden = false
        layoutOneButton.alpha = 1
        layoutTwoButton.alpha = 1
        layoutThreeButton.alpha = 0.4
    }
    
    @IBAction func didPressTopLeftButton() {
        openPhotoLibrary()
    }
    
    @IBAction func didPressTopRightButton() {
        openPhotoLibrary()
    }
    
    @IBAction func didPressBottomLeftButton() {
        openPhotoLibrary()
    }
    
    @IBAction func didPressBottomRightButton() {
        openPhotoLibrary()
    }
    
    // MARK: - Functions
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Did Cancel")
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        let imageView = UIImageView(image: image)
        topLeftView.addSubview(imageView)
        picker.dismiss(animated: true, completion: nil)
    }
}



