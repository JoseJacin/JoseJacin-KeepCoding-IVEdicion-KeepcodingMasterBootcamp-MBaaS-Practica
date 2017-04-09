# JoseJacin-KeepCoding-IVEdicion-KeepcodingMasterBootcamp-MBaaS-Practica

## Funcionalidad Requerida
### Autor
- [X] **Estado por defecto de publicación de los Post a NO:** Los Posts se crean con el estado de publicación a No
- [X] **Valoración / Nº de lecturas de los Post:** Se ha implementado la parte de las valoraciones en el lado del cliente. Falta por implementar:
  * Calcular la media de valoración en BackEnd y persistir esta información en Firebase
  * Implementar la parte del número de lecturas de cada Post
- [X] **Marcar como publicado:** Se ha implementado la funcionalidad de publicar un Post
- [ ] **Validaciones de los datos en el BackEnd:** Se encuentra pendiente de implementar, ya que en Firebase es algo más complicado que en Azure
- [ ] **Publicar en BackEnd con un Job:** Falta por implementar que la publicación se realice en "diferido" desde el BackEnd y que desde el cliente se marque como pendiente de publicar
- [ ] **Consulta de los Post publicados, sin publicar, valoración de cada noticia:** Falta por implementar

### Lector
- [X] **Tabla con los Post publicados ordenados de más reciente a más antiguo:** Se ha realizado, aunque ha sido en la parte cliente. Queda pendiente de implementarlo en en BackEnd
- [X] **El Lector puede acceder al detalle de un Post:** Se ha implementado correctamente
- [X] **En la lista de Post publicados, se debe mostrar la mínima información. Título, imagen reducida y autor:** Se ha implementado correctamente, además se ha añadido un indicador con la valoración recibida en cada Post

### Estadísticas
- [X] **Reportar toda la actividad del usuario:** Se ha implementado correctamente
- [ ] **Notificaciones Push al autor cada vez que un lector valora un Post:** Pendiente de implementar esta información

### Varios
#### ***Thumbnails***
Para abordar el requisito que en la vista principal debe descargarse la mínima información, se ha realizado la siguiente implemtación
- Mediante un proceso en Firebase se genera una imagen (thumbnail) con el mismo nombre que la original pero con el prefijo "thumb_". Esta imagen es de pequeña calidad para que la carga inicial sea más rápida.
- No se generan para todas las imagenes ya que por limitaciones de la capa gratuita de Firebase solo se pueden tratar ficheros que no ocupen demasiado.  
- Se ha establecido un "algoritmo" (lo que se me ha ocurrido viendo las horas que son) para que:
  
  - Compruebe si existe o no un thumbail, buscando una imagen con el mismo nombre pero que contenga además el prefijo "thumb_". En caso de existir, lo descarga en segundo plano
  - Si no existe el thumbnail, se descarga la imagen original.
 - Para comprobar esto correctamente, lo que he hecho ha sido crear 4 posts:
  - 2 con un pantallazo de la pantalla del dispositivo
  - 2 fotos tomadas con la cámara o de la galería (pero que sean fotos)

#### Referencias
- En cuanto a la implementación de las valoraciones, siguiendo las recomendaciones que se encuentran en la documentación de Firebase, se ha optado por añadir al documento de cada post, un subelemento **ratings** que se compone de un array con las siguientes claves **[ user : valoración ]**.
 * [Estrucutración de los datos en Firebase](https://firebase.google.com/docs/database/ios/structure-data#fanout)
 * [Implementación del sistema de puntuaciones](https://groups.google.com/forum/#!topic/firebase-talk/EJYHxKKQ6ZA)
 * [Función que conviente un Objeto Swift en un Diccionario](http://stackoverflow.com/questions/31971256/how-to-convert-a-swift-object-to-a-dictionary)
 * [Función que retorna el nombre de la clase como String](http://stackoverflow.com/questions/24494784/get-class-name-of-object-as-string-in-swift)

