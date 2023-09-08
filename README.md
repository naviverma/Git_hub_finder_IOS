# Git_hub_finder_IOS

This is a training project for my IOS summer internship in paytm india.

## GitHub Viewer

### Overview

GitHub Viewer is an application designed to provide an enriched view of GitHub user profiles for IOS devices. This includes essential details such as username, login, bio, repository count, followers, and more. Moreover, you can get insights on repositories, their contributors, and the uploaded assets like images and videos. This application leverages GitHub's public APIs to retrieve user-related details and showcases them in a user-friendly interface.

### Key Features:

- View detailed user profiles: username, bio, repository count, followers, total stars, and following.
- Access repository lists with essential details like repo name, repo description, language used, number of forks, number of stars, and timestamp showing when the repo was updated.
- Discover contributors of a specific repository and the number of contributions they have done with their profile images.
- View the whole codebase of the repository in folder structure including code images and Videos.
- Sleek UI using TableView, CollectionView, NavigationController, and custom UI cells through Xib and a responsive UI that adapts on all screen sizes and can adjust based on the orientation of the phone.
- Implemented AVplayer for playing videos that are uploaded by the users on repositories.
- Implemented Image Viewer for viewing images that are uploaded by the users on repositories.

### Technologies & Architecture:

- GitHub APIs to fetch user and repository details.
- Adopted the MVC architectural pattern for code reuse and maintainability.
- Robust application structure ensured through XCT test cases.
- Integration of Google Ads via Google AdMob.
- Analytics powered by Firebase.

### APIs

Base URL: [https://api.github.com/](https://api.github.com/)
- Fetch Profile Info:
  - URL: /users/{username}
  - Example: /users/naviverma
- Fetch User Repository List:
  - URL: /users/{username}/repos
  - Example: /users/naviverma/repos
- Fetch Repository Contributors:
  - URL: /repos/{username}/{reponame}/contributors
  - Example: /repos/naviverma/Morse-code-game-ARM-LANGUAGE-/contributors
- Fetch Repository Code & Assets:
  - URL: /repos/{username}/{reponame}/contents/
  - Example: /repos/naviverma/Morse-code-game-ARM-LANGUAGE-/contents/

### Contribution:

Your contributions are always welcome! Here's how you can contribute:
- Fork the Repository: Head over to the GitHub Viewer repository and click on the 'Fork' button.
- Clone the Project: Use the "Clone from Version Control" feature in Xcode to clone the project.
- Install Dependencies: Ensure you have CocoaPods installed and then run the required pod installation commands.
- Setup the iOS Environment: Use an iOS simulator or connect your physical iOS device to your computer.
- Run the Application: Adjust the configuration settings if using a simulator and launch the app.

### Dependency Setup with CocoaPods


# Install CocoaPods (if not installed)
```bash
sudo gem install cocoapods
```

# Navigate to Project & Initialize CocoaPods
```bash
cd path/to/your/project
```
# Initialise the podfile
```bash
pod init
```

# Add Dependencies to your Podfile
```bash
pod 'Firebase/Analytics'
pod 'Google-Mobile-Ads-SDK'
```

# Install the pod
```bash
pod install
```
# Open the workspace
```bash
open YourProjectName.xcworkspace
```


Integrate Firebase & Google Ads: Follow Firebase & Google Ads documentation for further setup.
