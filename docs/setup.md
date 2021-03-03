# Setup del Proyecto Microbank - App

## Creacion del Proyecto Flutter

* Proyecto creado con Flutter y compatible con Java y iOS


## Integracion con Firebase (INACTIVO)

* Nombre del proyecto: microbank
* Analitica: Si / Default Account for Firebase
* Nota: Cuando se remueve Firebase, es necesario explicitamente agregar permiso a Internet
```
<uses-permission android:name="android.permission.INTERNET"/>
```


### Creacion del app iOS
* Desde el proyecto: microbank
* Con XCode, en el bundle identifier usar: pe.itana.microbankapp
* Register app: pe.itana.microbankapp
* Download config file: GoogleService-Info.plist
* Obviar los siguientes pasos

* Ejecutar el app nuevamente y verificar que funcione
 

### Creacion del app Android
* Desde el proyecto: microbank
* En el app/gradle usar nombre de applicationId pe.itana.microbankapp
* Registrar el App en Firebase con nombre: pe.itana.microbankapp
* Download config file: google-services.json
* Modificar el build.gradle del proyecto e incluir
```
        // JCC Agregado por Firebase
        classpath 'com.google.gms:google-services:4.3.4'
```
* Modificar el build.gradle del app para incluir lo indicado
```
// JJC: agregado por Firebase
apply plugin: 'com.google.gms.google-services'

dependencies {
    // Import the Firebase BoM
    implementation platform('com.google.firebase:firebase-bom:26.1.0')

    // Add the dependency for the Firebase SDK for Google Analytics
    // When using the BoM, don't specify versions in Firebase dependencies
    implementation 'com.google.firebase:firebase-analytics'

}
```

* Actualizar compile y target SdkVersion de 29 a 30
```
    compileSdkVersion 30

    targetSdkVersion 30

```


## Liberar version del App Android Dev via apk 

### Actualizar la version en el pubspec.yaml
```
version: 1.8.0+9
```
### Contruir el APK en modo release para compartir por medio alternativo

#### Generar el apk
* Desde el directorio del proyecto flutter
```
flutter clean
flutter build apk

```
* Verificar el apk generado
```
ll  build/app/outputs/flutter-apk/app-release.apk
```
