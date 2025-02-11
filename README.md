# BaseUI Core

A modular Flutter application framework built with modern architecture patterns and best practices.

## Project Structure

The project is organized into two main directories:

### `/lib` Directory
- `app/`: Contains application-specific configurations, routes, and themes
- `modules/`: Houses feature-specific modules and components
- `main.dart`: Entry point of the application, sets up core configurations

### `/core` Directory
Core package that serves as the foundation of the application:
- Provides essential utilities and shared components
- Manages state using GetX
- Handles storage and persistence
- Implements common UI components and themes

## Technical Stack

- **Framework**: Flutter SDK ≥3.0.0
- **State Management**: GetX
- **Storage**: 
  - GetStorage
  - SharedPreferences
- **UI Components**:
  - Flutter Material Design
  - Flutter SVG
  - Google Fonts
- **Utilities**:
  - Image Picker
  - Intl for internationalization

## Getting Started

1. Ensure you have Flutter ≥3.0.0 installed
2. Clone the repository
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

## Features

- Modern, responsive UI with Material Design
- Modular architecture for scalability
- Built-in state management with GetX
- Persistent storage capabilities
- Theme support (light/dark modes)
- SVG and custom font support

## Project Architecture

The project follows a modular architecture pattern:
- Clear separation between core and application-specific code
- Feature-based module organization
- Dependency injection using GetX
- Centralized routing system
- Consistent theming and styling

## Contributing

Please read our contribution guidelines before submitting pull requests.

## CLI Tool

This project works in conjunction with the BaseUI CLI tool, which can be found at [base-al/baseui](https://github.com/base-al/baseui). The CLI provides helpful commands for:

- Generating new modules
- Creating components
- Managing project structure
- Scaffolding features

To use the CLI tool, visit the repository and follow the installation instructions.

## License

MIT License

Copyright (c) 2025 base-al

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
