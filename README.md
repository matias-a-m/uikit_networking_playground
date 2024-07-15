# UIKit Networking Playground

Este Playground en Swift utiliza UIKit para mostrar una lista de vehículos de Star Wars. Incorpora funcionalidad de networking para cargar imágenes desde URLs externas, siguiendo los principios de diseño limpio y escalable.

## Arquitectura MVVM

El proyecto sigue una arquitectura MVVM (Model-View-ViewModel):

- **Modelo (`StarWarsVehicle`)**: Representa los datos de un vehículo de Star Wars, incluyendo nombre, URL de imagen y configuración de carga fallida.
  
- **ViewModel (`StarWarsVehiclesViewModel`)**: Gestiona los datos y la lógica de negocio, proporcionando métodos para obtener la lista de vehículos y configurando la interfaz entre el modelo y la vista.

- **Vistas (`RoundedImageView` y `StarWarsVehiclesView`)**:
  - **RoundedImageView**: Personaliza la visualización de imágenes con esquinas redondeadas y maneja la carga de imágenes con indicadores de actividad y etiquetas de error.
  - **StarWarsVehiclesView**: La vista principal que utiliza un stack view para mostrar la lista de vehículos junto con sus imágenes.

## Ingeniería y Tecnologías

El proyecto utiliza:

- **UIKit**: Para la creación de la interfaz de usuario y la manipulación de vistas.
  
- **Playground de Swift**: Entorno interactivo para probar y visualizar el funcionamiento del código de manera rápida.

- **Networking**: Implementación de carga de imágenes desde URLs externas utilizando URLSession para manejar las solicitudes HTTP y mostrar las imágenes en las vistas correspondientes.

## Clonar y Ejecutar

1. Clona este repositorio:

   ```bash
   git clone https://github.com/tu-usuario/uikit_networking_playground.git
   
  Abre el archivo StarWarsVehicles.playground en Xcode.

  Asegúrate de seleccionar la vista de Live View para visualizar la aplicación en acción.
