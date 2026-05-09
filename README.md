# Movie Explorer

Aplicacion movil desarrollada en Flutter que consume la API de The Movie DB (TMDb) para mostrar peliculas populares, buscar por titulo, ver detalles y almacenar datos localmente con SQLite.

## Caracteristicas

- Lista de peliculas populares desde TMDb
- Busqueda de peliculas por titulo
- Vista de detalles (sinopsis, puntuacion, poster)
- Persistencia local con SQLite
- Manejo de estado con Provider
- Diseño responsivo con tema oscuro
- Manejo de errores y estados de carga

## Requisitos previos

Antes de comenzar, asegurate de tener instalado:

- Flutter 3.x o superior
- Android Studio
- Java JDK 17 o superior
- Un dispositivo Android (telefono fisico o emulador)

Para verificar tu instalacion de Flutter, ejecuta:

flutter doctor

## Instalacion y ejecucion

Paso 1: Clonar el repositorio

git clone https://github.com/TU_USUARIO/movie_explorer.git
cd movie_explorer

Paso 2: Obtener tu API Key de TMDb

1. Ve a https://www.themoviedb.org/
2. Registrate o inicia sesion
3. Ve a Configuracion -> API
4. Crea una nueva aplicacion:
   - Nombre: Movie Explorer
   - URL: http://localhost
   - Resumen: App movil Flutter para ver peliculas
5. Copia tu API Key (v3 auth)

Paso 3: Configurar la API Key

Abre el archivo lib/services/tmdb_service.dart y busca esta linea:

final String apiKey = 'TU_API_KEY_AQUI';

Reemplazala con tu API Key:

final String apiKey = 'tu_api_key_copiada_aqui';

Paso 4: Instalar dependencias

flutter pub get

Paso 5: Conectar un dispositivo Android

Opcion A - Telefono fisico:

1. Activa Opciones de desarrollador en tu telefono:
   - Ve a Configuracion -> Acerca del telefono
   - Presiona "Numero de compilacion" 7 veces
2. Activa Depuracion USB en Opciones de desarrollador
3. Conecta tu telefono por USB
4. Acepta "Permitir depuracion USB" en el telefono
5. Verifica la conexion:

flutter devices

Opcion B - Emulador Android:

1. Abre Android Studio
2. Ve a Tools -> Device Manager
3. Haz clic en "Create device"
4. Selecciona un modelo (ej: Pixel 6) -> Next
5. Selecciona Android 14 (API 34) -> Next -> Finish
6. Inicia el emulador con el boton Play

Paso 6: Ejecutar la aplicacion

flutter run

Para ejecutar en un dispositivo especifico:

flutter run -d NOMBRE_DEL_DISPOSITIVO

Para ejecutar en Windows (alternativa):

flutter run -d windows

## Estructura del proyecto

lib/
├── models/
│   └── movie.dart
├── services/
│   └── tmdb_service.dart
├── database/
│   └── database_helper.dart
├── screens/
│   ├── movie_list_screen.dart
│   └── movie_detail_screen.dart
└── main.dart

## Dependencias principales

- http: Peticiones HTTP a la API
- provider: Manejo de estado
- sqflite: Base de datos local SQLite
- path_provider: Acceso a directorios del dispositivo
- cached_network_image: Caché de imagenes

## Solucion de problemas comunes

Problema: MissingPluginException
Solucion: Ejecuta la app en Android, no en Chrome

Problema: INSTALL_FAILED_USER_RESTRICTED
Solucion: Activa "Instalacion via USB" en Opciones de desarrollador

Problema: NDK not found
Solucion: Instala NDK desde SDK Manager de Android Studio

Problema: API Key invalida
Solucion: Verifica que copiaste bien la API Key sin espacios

Problema: Gradle build failed
Solucion: Ejecuta flutter clean y luego flutter pub get

## Requisitos cumplidos

Obligatorios:

- Flutter 3.x o superior
- Widgets personalizados y estilos definidos
- Manejo de estado con Provider
- Peticiones HTTP con http package
- Navegacion entre vistas (lista y detalle)
- Manejo de errores y loading states
- Codigo limpio y modular

Opcionales:

- Persistencia local con SQLite
- Tema oscuro personalizado

## Video demostracion

Adjunto en Correo electronico

## Desarrollado para

Prueba Tecnica - Desarrollador Flutter

Fecha: Mayo 2026