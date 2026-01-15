import UIKit
import SwiftUI
import PhotosUI

class ProfileSettingsViewController: UIViewController {
    //MARK: - Properties
    private let viewModel = ProfileViewModel()
    private let initialUser: User?
    private let initialProfileImage: UIImage?
    
    private var name: String = "" {
        didSet {
            updateTextFields()
        }
    }
    private var email: String = "" {
        didSet {
            updateTextFields()
        }
    }
    private var selectedImage: UIImage? = nil {
        didSet {
            updateProfilePictureButton()
        }
    }
    private var currentProfileImageUrl: String? = nil {
        didSet {
            updateProfilePictureButton()
        }
    }
    
    private var preloadedImage: UIImage? = nil {
        didSet {
            updateProfilePictureButton()
        }
    }
    
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "პროფილის რედაქტირება"
        label.font = FontType.bold.uiFont(size: 20)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var profilePictureButtonHostingController: UIHostingController<ReusableProfilePictureButton>?
    private var textFieldsHostingController: UIHostingController<ProfileSettingsTextFieldsView>?
    private var reusableButtonHostingController: UIHostingController<ReusableMainButton>?
    
    //MARK: - Inits
    init(initialUser: User? = nil, initialProfileImage: UIImage? = nil) {
        self.initialUser = initialUser
        self.initialProfileImage = initialProfileImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.initialUser = nil
        self.initialProfileImage = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackground
        setupViewModel()
        setupUI()
        loadUserData()
    }
    
    //MARK: - Setup
    private func setupViewModel() {
        viewModel.onUserLoaded = { [weak self] user in
            guard let self = self else { return }
            self.name = user.name
            self.email = user.email
            self.currentProfileImageUrl = user.profileImageUrl
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.showAlert(message: errorMessage)
        }
        
        viewModel.onSaveComplete = { [weak self] in
            self?.showAlert(message: "პროფილი წარმატებით განახლდა", completion: {
                self?.navigationController?.popViewController(animated: true)
            })
        }
        
        viewModel.onImageUploadSuccess = { [weak self] imageUrl in
            self?.currentProfileImageUrl = imageUrl
            self?.selectedImage = nil
        }
        
        viewModel.onImagePreloaded = { [weak self] image in
            self?.preloadedImage = image
        }
    }
    
    private func setupUI() {
        configurePageTitleLabel()
        configureProfilePictureButton()
        configureTextFields()
        configureSaveButton()
    }
    
    private func configurePageTitleLabel() {
        view.addSubview(pageTitleLabel)
        
        NSLayoutConstraint.activate([
            pageTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            pageTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            pageTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
    }
    
    private func configureProfilePictureButton() {
        let imageToShow = selectedImage ?? preloadedImage
        let button = ReusableProfilePictureButton(
            action: { [weak self] in
                self?.choosePictureTapped()
            },
            imageUrl: imageToShow == nil ? currentProfileImageUrl : nil,
            selectedImage: imageToShow
        )
        
        let hostingController = UIHostingController(rootView: button)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        self.profilePictureButtonHostingController = hostingController
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 30),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hostingController.view.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func configureTextFields() {
        let textFieldsView = ProfileSettingsTextFieldsView(
            email: Binding(
                get: { [weak self] in self?.email ?? "" },
                set: { [weak self] in self?.email = $0 }
            ),
            name: Binding(
                get: { [weak self] in self?.name ?? "" },
                set: { [weak self] in self?.name = $0 }
            )
        )
        
        let hostingController = UIHostingController(rootView: textFieldsView)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        self.textFieldsHostingController = hostingController
        
        guard let buttonHostingController = profilePictureButtonHostingController else {
            return
        }
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: buttonHostingController.view.bottomAnchor, constant: 30),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
    private func configureSaveButton() {
        let reusableButton = ReusableMainButton(title: "შენახვა") { [weak self] in
            self?.saveButtonTapped()
        }
        
        let hostingController = UIHostingController(rootView: reusableButton)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        self.reusableButtonHostingController = hostingController
        
        NSLayoutConstraint.activate([
            hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingController.view.widthAnchor.constraint(equalToConstant: 265),
            hostingController.view.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func updateProfilePictureButton() {
        if let hostingController = profilePictureButtonHostingController {
            let imageToShow = selectedImage ?? preloadedImage
            let button = ReusableProfilePictureButton(
                action: { [weak self] in
                    self?.choosePictureTapped()
                },
                imageUrl: imageToShow == nil ? currentProfileImageUrl : nil,
                selectedImage: imageToShow
            )
            hostingController.rootView = button
        }
    }
    
    
    private func updateTextFields() {
        if let hostingController = textFieldsHostingController {
            let textFieldsView = ProfileSettingsTextFieldsView(
                email: Binding(
                    get: { [weak self] in self?.email ?? "" },
                    set: { [weak self] in self?.email = $0 }
                ),
                name: Binding(
                    get: { [weak self] in self?.name ?? "" },
                    set: { [weak self] in self?.name = $0 }
                )
            )
            hostingController.rootView = textFieldsView
        }
    }
    
    private func loadUserData() {
        if let user = initialUser {
            self.name = user.name
            self.email = user.email
            self.currentProfileImageUrl = user.profileImageUrl
            viewModel.currentUser = user // avoid duplicate fetch
            
            if let image = initialProfileImage {
                self.preloadedImage = image
            } else if let imageUrlString = user.profileImageUrl, let url = URL(string: imageUrlString) {
                viewModel.preloadImage(from: url)
            }
        } else {
            if let cachedUser = viewModel.currentUser { //check if viewmodel has cached data
                self.name = cachedUser.name
                self.email = cachedUser.email
                self.currentProfileImageUrl = cachedUser.profileImageUrl
                if let imageUrlString = cachedUser.profileImageUrl, let url = URL(string: imageUrlString) {
                    viewModel.preloadImage(from: url)
                }
            }
        }
        
        viewModel.loadCurrentUser()
    }
    
    //MARK: - Actions
    private func choosePictureTapped() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func saveButtonTapped() {
        let _ = selectedImage != nil
        viewModel.saveChanges(name: name, email: email, image: selectedImage)
    }
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "კარგი", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

//MARK: - PHPickerViewControllerDelegate
extension ProfileSettingsViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self?.selectedImage = image
                    } else if let error = error {
                        self?.showAlert(message: "სურათის ჩატვირთვა ვერ მოხერხდა: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
