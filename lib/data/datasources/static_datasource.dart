import '../models/portfolio_models.dart';

class StaticPortfolioDataSource {
  List<ProjectModel> getProjects() {
    return const [
      ProjectModel(
        id: '1',
        title: 'Sales Force App',
        description:
            'Sales Force App offers a convenient and smooth retail business platform online. Through this app, retailers can instantly gain access to information regarding sales, self-services, commissions, campaigns, offers, and much more. There is also scope to sell and upsell, know about returns on investment, and share the overall experience. The app lets retailers serve subscribers faster, with only a few easy steps.',
        tags: ['Flutter', 'Firebase', 'Biometrics', 'API Integration'],
        url:
            'https://play.google.com/store/apps/details?id=com.banglalink.salesforceapp&hl=en',
        imageUrl: 'assets/images/spacex.png',
      ),
      ProjectModel(
        id: '2',
        title: 'TULO 2',
        description:
            'Local Government Engineering Department is an organ of Bangladesh government created for provision of transport infrastructures in rural areas and to provide technical support to the rural and the urban.',
        tags: ['Flutter', 'Local Database', 'API Integration'],
        url:
            'https://play.google.com/store/apps/details?id=com.ptsl.tulo2&hl=en',
        imageUrl: 'assets/images/arcade.png',
      ),
      ProjectModel(
        id: '3',
        title: 'Paribahan',
        description:
            'Paribahan.com is web portal with the data bank of the entire transport industry of Bangladesh. This information bank is helping all bus travelers to gather information about ticket price, available transports along with online booking option from the web for the transports that are linked with us for the facilities',
        tags: ['Flutter Mobile'],
        url:
            'https://play.google.com/store/apps/details?id=com.ptsl.paribahan&hl=en',
        imageUrl: 'assets/images/finance.png',
      ),
      ProjectModel(
        id: '4',
        title: 'Flights Nepal',
        description:
            'Prabas Travel & Tours Pvt. Ltd. is a licensed travel agency based in Kathmandu, Nepal. The company provides OTA in the name of Flightsnepal.com and travel-related services, including domestic and international flight ticketing, tour packages, hotel bookings, and visa assistance.',
        tags: ['Flutter', 'SQLite'],
        url:
            'https://play.google.com/store/apps/details?id=com.ptsl.flightsnepal&hl=en',
        imageUrl: 'assets/images/chat.png',
      ),
      ProjectModel(
        id: '5',
        title: 'NISSAN Drivers Guide',
        description:
            'The Nissan Driver’s Guide is an application based on Augmented Reality Technology. It will help you to learn and understand more about your vehicle.',
        tags: ['Android Native', 'Kotlin', 'AR'],
        url:
            'https://play.google.com/store/apps/details?id=com.nissan.alldriverguide&hl=en',
        imageUrl: 'assets/images/chat.png',
      ),
    ];
  }

  List<SkillModel> getSkills() {
    return const [
      // Frontend / Core
      SkillModel(
        name: 'Flutter & Dart',
        category: 'Core',
        level: 0.85,
        colorHex: '#6C22D6',
      ),
      SkillModel(
        name: 'Custom Painters',
        category: 'Core',
        level: 0.70,
        colorHex: '#00E5FF',
      ),
      SkillModel(
        name: 'State Management (Riverpod, Bloc)',
        category: 'Core',
        level: 0.80,
        colorHex: '#FF007F',
      ),
      SkillModel(
        name: 'Android Native (Kotlin)',
        category: 'Core',
        level: 0.86,
        colorHex: '#FF007F',
      ),
      SkillModel(
        name: 'MVVM + Clean Architecture',
        category: 'Core',
        level: 0.83,
        colorHex: '#FF007F',
      ),

      // Backend / Infrastructure
      SkillModel(
        name: 'Firebase & Cloud Functions',
        category: 'Backend',
        level: 0.88,
        colorHex: '#FFC107',
      ),

      // Tools & Ecosystem
      SkillModel(
        name: 'Git & GitHub Actions',
        category: 'Tools',
        level: 0.88,
        colorHex: '#E040FB',
      ),
      SkillModel(
        name: 'Figma UI/UX Designing',
        category: 'Tools',
        level: 0.85,
        colorHex: '#FF5722',
      ),
    ];
  }

  List<ExperienceModel> getExperiences() {
    return const [
      ExperienceModel(
        id: 'exp1',
        role: 'Software Engineer',
        company: 'Primetech Solutions Ltd.',
        duration: 'January 2024 - Present',
        // descriptionPoints: [
        //   'Experienced Mobile App Developer with expertise in Flutter and native Android SDK (Kotlin), building secure, scalable, and high-quality mobile applications with clean architecture and modern development practices.',
        // ],
        jobDescription:
            'Experienced Mobile App Developer with expertise in Flutter and native Android SDK (Kotlin), building secure, scalable, and high-quality mobile applications with clean architecture and modern development practices.',
        keyContributions: [
          'Developed and maintained cross-platform mobile applications using Flutter and Dart.',
          'Implemented clean architecture, repository patterns, and robust state management solutions.',
          'Collaborated with designers and backend teams to integrate REST APIs and deliver pixel-perfect UI/UX.',
          'Optimized application performance, reduced build sizes, and configured automated deployment workflows.',
        ],
        technologiesUsed: [
          'Flutter',
          'Dart',
          'Android SDK',
          'Kotlin',
          'Clean Architecture',
          'Git',
          'REST APIs',
          'Jira',
          "Gitlab",
        ],
        iconName: 'work',
        colorHex: '#6C22D6',
      ),
      ExperienceModel(
        id: 'exp2',
        role: 'Android Developer',
        company: 'DataSoft Systems Bangladesh Limited',
        duration: 'January 2023 - April 2023',
        // descriptionPoints: [
        //   'Worked on Android application development using Kotlin with MVVM and Clean Architecture patterns. Developed and maintained modern mobile applications with a focus on scalable architecture, clean code practices, and responsive UI implementation.',
        // ],
        jobDescription:
            'Worked on Android application development using Kotlin with MVVM and Clean Architecture patterns. Developed and maintained modern mobile applications with a focus on scalable architecture, clean code practices, and responsive UI implementation.',
        keyContributions: [
          'Built Android applications using Kotlin following MVVM architecture and Clean Architecture principles.',
          'Developed modern, pixel-perfect mobile UI designs with attention to user experience and responsiveness.',
          'Created demo applications including a Land Port App using Android Kotlin and Jetpack components.',
          'Designed and implemented multiple application screens for the Nissan Driver’s Guide project.',
          'Worked with Android Jetpack libraries, API integration, repository pattern, and state management.',
          'Collaborated with team members to improve app performance, maintainability, and UI consistency.',
          'Followed best practices for reusable components, modular development, and clean coding standards.',
        ],
        technologiesUsed: [
          'Kotlin',
          'Android SDK',
          'MVVM',
          'Clean Architecture',
          'Jetpack Components',
          'Retrofit',
          'XML UI',
          'Material Design',
          'Git',
          'REST API Integration',
        ],
        iconName: 'work',
        colorHex: '#00E5FF',
      ),
    ];
  }

  List<ToolModel> getTools() {
    return const [
      ToolModel(
        name: 'VS Code',
        category: 'IDE',
        iconAsset: 'vscode',
        colorHex: '#007ACC',
      ),
      ToolModel(
        name: 'Android Studio',
        category: 'IDE',
        iconAsset: 'android_studio',
        colorHex: '#3DDC84',
      ),
      ToolModel(
        name: 'Git',
        category: 'VCS',
        iconAsset: 'git',
        colorHex: '#F05032',
      ),
      ToolModel(
        name: 'Figma',
        category: 'Design',
        iconAsset: 'figma',
        colorHex: '#F24E1E',
      ),
      ToolModel(
        name: 'Xcode',
        category: 'IDE',
        iconAsset: 'xcode',
        colorHex: '#147EFB',
      ),
      ToolModel(
        name: 'Postman',
        category: 'API Testing',
        iconAsset: 'postman',
        colorHex: '#FF6C37',
      ),
    ];
  }
}
