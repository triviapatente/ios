# Trivia Patente - IOS
##### Table of Contents
1. [Introduction](#intro)
2. [Getting started](#getstarted)
3. [Contributing](#contribute)
4. [Authors](#authors)
5. [License](#license)

<a name="intro"></a>
## Introduction
TriviaPatente is a mobile application that makes it easier and funnier to learn the theory of the driving license, connecting you with your friends.
This repository contains the native IOS application.
|Screenshoots|||
|:----- |:----- |:----- |
|<img src="https://github.com/triviapatente/triviapatente.github.io/blob/main/images/screen1.png" alt="drawing" width="300"/>|<img src="https://github.com/triviapatente/triviapatente.github.io/blob/main/images/screen2.png" alt="drawing" width="300"/>|<img src="https://github.com/triviapatente/triviapatente.github.io/blob/main/images/screen3.png" alt="drawing" width="300"/>|

<a name="getstarted"><a/>
## Getting started
This project was a fun side hustle developed by us back in 2017. 

We recently recover the code and make it buildable again in order to showcase it in this repository.

This means obviously that it uses some old technologies, not the standard we are used to in 2023.

### Prerequisites
The code was recently converted to Swift 4.0 in order to make it buildable from XCode 14, and uses the following technologies:
||Version|
|:----- |:----- |
|IOS| Minimum: 11.0, Maximum: 17.0|
|Swift| 4.0 |
|XCode| 14.3 |
|CocoaPods| 1.12.1 |

### Installing
In order to properly configure the project, you need to remove actual pods and reinstall the dependencies

```rm -rf Pods/ Podfile.lock```

```pod install```

After that, the code should compile fine.
### Preparing the environment
In order to run the application properly, you need to deploy the backend behind it.
Please follow the instructions [here](https://github.com/triviapatente/backend)

After you setup the backend properly, deploy it anywhere and modify this line in [HTTPManager.swift](https://github.com/triviapatente/ios/blob/master/Trivia%20Patente/Trivia%20Patente/HTTPManager.swift):
```
class func getBaseURL() -> String {
    return YOUR_BASE_URL_HERE
}
```
### Executing
The projects uses some old versions of some libraries that are not compatible with ARM Targets yet. 
So, in order to execute the application on a simulator, follow this instructions
- Go to 'Product' tab on XCode;
- Follow ```Destination/Destination Architectures```;
- Choose 'Show Both', on the multiple choice form that appears;
- You can now see on the simulator destinations the 'Rosetta' simulators, choose one and you are ready to go!

<a name="contribute"><a/>
## Contribute
We still need to set up an easy way to contribute, and provide a list of updates that might improve the project. You can save your ☕️s until then or, you
can drop an [email](mailto:luigi.donadel@gmail.com) to help us:
+ Set up coding style guidelines
+ Wiki
+ Documentation
+ Set up contribution workflow
<a name="authors"><a/>
### Authors
This project was developed with ❤️ and a giant dose of curiosity and passion from some very young folks (we were 20 at the time), in 2017 as a side project.
||Authors|
|:----- |:----- |
|<img src="https://avatars.githubusercontent.com/u/7453120?v=4" alt="drawing" width="50"/>|[Luigi Donadel](https://github.com/donadev)|
|<img src="https://media.licdn.com/dms/image/C4D03AQGvkKpgIYl6jg/profile-displayphoto-shrink_200_200/0/1517931535631?e=1695859200&v=beta&t=uiddasmwI5VnP5TYdeuWd57geP_DArgR7vONoI901hk" alt="drawing" width="50"/>|[Gabriel Ciulei](https://www.linkedin.com/in/gabriel-ciulei)|
|<img src="https://avatars.githubusercontent.com/u/20773447?v=4" alt="drawing" width="50"/>|[Antonio Terpin](https://github.com/antonioterpin)|

<a name="license"><a/>
## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/triviapatente/ios/blob/master/LICENSE) file for details.
