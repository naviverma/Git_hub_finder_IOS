# Git_hub_finder_IOS
This is a training project for my IOS summer internship in paytm india.

GitHub Viewer

Overview

GitHub Viewer is an application designed to provide an enriched view of GitHub user profiles for IOS devices. This includes essential details such as username, login, bio, repository count, followers, and more. Moreover, you can get insights on repositories, their contributors, and the uploaded assets like images and videos.
This application leverages GitHub's public APIs to retrieve user-related details and showcases them in a user-friendly interface.

Key Features:

* View detailed user profiles: username, bio, repository count, followers, total stars and following.
* Access repository lists with essential details like repo name, repo description, language used, no of forks, no of stars and timestamp showing when the repo was updated.
* Discover contributors of a specific repository and no of contributions they have done with their profile images.
* View whole code base of the repository in folder structure including code images and Videos.
* Sleek UI using TableView, CollectionView, NavigationController, and custom UI cells through Xib and a responsive UI that adapt it on all screen sizes and can adjust based on the orientation of the phone.
* Implemented AVplayer for playing videos that are uploaded by the users on repositories.
* Implemented Image Viewer for viewing images that are uploaded by the users on repositories.

Technologies & Architecture:

* GitHub APIs to fetch user and repository details.
* Adopted the MVC architectural pattern for code reuse and maintainability.
* Robust application structure ensured through XCT test cases.
* Integration of Google Ads via Google AdMob so user can see ads while scrolling through users.
* Analytics powered by Firebase are implemented to capture user activity and ads monitoring to see if user is clicking on ad to go to App Store or just skipping it.

APIs

Base URL: https://api.github.com/
* 		Fetch Profile Info:
    * URL: /users/{username}
    * Example: /users/naviverma
* 		Fetch User Repository List:
    * URL: /users/{username}/repos
    * Example: /users/naviverma/repos
* 		Fetch Repository Contributors:
    * URL: /repos/{username}/{reponame}/contributors
    * Example: /repos/naviverma/Morse-code-game-ARM-LANGUAGE-/contributors
* 		Fetch Repository Code & Assets:
    * URL: /repos/{username}/{reponame}/contents/
    * Example: /repos/naviverma/Morse-code-game-ARM-LANGUAGE-/contents/

Contribution:
Feel free to fork this repository, open pull requests, or raise issues if you have any suggestions or bugs to report.
