# BostaTask

An iOS sample app that fetches a **random user** from JSONPlaceholder, loads that user’s **albums**, and shows **photos** with live search — built with **RxSwift / RxCocoa**, **Moya / RxMoya**, and **MVVM**.

---

## Preview

| Profile | Photos + Search | Viewer |
|---|---|---|
| ![Profile](docs/profile.png) | ![Photos 1](docs/photos-1.png) ![Photos 2](docs/photos-2.png) ![Photos 3](docs/photos-3.png) | ![Viewer 1](docs/viewer-1.png) ![Viewer 2](docs/viewer-2.png) ![Viewer 3](docs/viewer-3.png) |



---

## Features

- **Profile screen**
  - Fetch a random user → render **name + full address**
  - Fetch that user’s **albums** and bind directly to a `UITableView` via **RxCocoa**
  - Tap an album to open its photos

- **Photos screen**
  - Fetch **photos** for the selected album
  - **Live search** (debounced) on photo title
  - Tap to open a simple **image viewer** (zoom/share)

- **Networking**
  - `Moya` target (`JSONPlaceholder`)
  - `NetworkManager` using **RxMoya**, returning `Single<[Model]>`
  - Endpoints: `/users`, `/albums?userId=`, `/photos?albumId=`

---

## Tech Stack

- **Swift** 5+
- **iOS** 15+
- **UIKit**
- **RxSwift**, **RxCocoa**
- **Moya**, **RxMoya** 
- **Architecture:** MVVM 
- **Unit Testing:**


