TMDB

Arquitectura de la aplicación: VIPER

Vistas:
MoviesListViewController
MovieDetailViewController
MovieTableViewCell

Presenter:		Pasamanos entre el interactor y las vistas
MoviesPresenter

Router:
MoviesModuleRouter: 	Encargado del manejo de controladores de la app

Interactor:
MovieManager  		Encargado de la lógica de negocio de la app

Entity:	      		Modelo de datos
Movie
SearchObject



capa de persistencia:
Clase: TMDBCoreDataConnector	implementa DataConnector protocol

Core Data(SQLite) para almacenamiento de películas
y fileSystem para almacenamiento de las imágenes

Capa de red:
clase: TMDBAPIConnector    	implementa DataConnector protocol

URLSession y URLSessionDataTask	


Principio de responsabilidad unica:
Refiere a la segmentación de las funcionalidades de una aplicación. Es decir limitar una clase, estructura u objeto a una única responsabilidad y no a manejar demasiadas funciones
Una clase debe poder describirse a si misma por su nombre. Si no puedo ponerle un nombre a una clase o a un método porque hace demasiadas cosas, quizás deba pensar en refactorizarlo en distintos objetos.

Coding limpio:
Desde mi punto de vista un código de calidad o limpio refiere a aquel que no solo hace lo que debe hacer, sino que es legible por otra persona y que la misma pueda agregar o corregir funcionalidad sin mayores problemas, es modularizado, reusable, testeable fácilmente, que no tenga código repetido por todas partes. 

