:- encoding(utf8).

% LibroScope - Sistema de búsqueda de libros
% Servidor web en SWI-Prolog - VERSIÓN FINAL CORREGIDA

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_json)).
:- use_module(library(http/json)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_cors)).

% Base de conocimiento con 20 libros
libro("Cien años de soledad", "Gabriel García Márquez", realismo_magico).
libro("El amor en los tiempos del cólera", "Gabriel García Márquez", realismo_magico).
libro("1984", "George Orwell", distopia).
libro("Rebelión en la granja", "George Orwell", satira).
libro("El Quijote", "Miguel de Cervantes", clasico).
libro("Orgullo y prejuicio", "Jane Austen", romance).
libro("Crimen y castigo", "Fiódor Dostoievski", drama).
libro("La metamorfosis", "Franz Kafka", existencialismo).
libro("El gran Gatsby", "F. Scott Fitzgerald", drama).
libro("Matar a un ruiseñor", "Harper Lee", drama).
libro("Ulises", "James Joyce", modernismo).
libro("En busca del tiempo perdido", "Marcel Proust", modernismo).
libro("Fahrenheit 451", "Ray Bradbury", ciencia_ficcion).
libro("Un mundo feliz", "Aldous Huxley", distopia).
libro("El señor de los anillos", "J.R.R. Tolkien", fantasia).
libro("Harry Potter y la piedra filosofal", "J.K. Rowling", fantasia).
libro("Los juegos del hambre", "Suzanne Collins", ciencia_ficcion).
libro("El código Da Vinci", "Dan Brown", misterio).
libro("It", "Stephen King", terror).
libro("Drácula", "Bram Stoker", terror).

% Reglas de búsqueda
buscar_por_genero(Genero, libro(Titulo, Autor, Genero)) :-
    downcase_atom(Genero, GeneroLower),
    libro(Titulo, Autor, GeneroLibro),
    downcase_atom(GeneroLibro, GeneroLibroLower),
    sub_atom(GeneroLibroLower, _, _, _, GeneroLower).

buscar_por_autor(Autor, libro(Titulo, Autor, Genero)) :-
    downcase_atom(Autor, AutorLower),
    libro(Titulo, AutorLibro, Genero),
    downcase_atom(AutorLibro, AutorLibroLower),
    sub_atom(AutorLibroLower, _, _, _, AutorLower).

buscar_keyword(Palabra, libro(Titulo, Autor, Genero)) :-
    downcase_atom(Palabra, PalabraLower),
    libro(Titulo, Autor, Genero),
    (   downcase_atom(Titulo, TituloLower),
        sub_atom(TituloLower, _, _, _, PalabraLower)
    ;   downcase_atom(Autor, AutorLower),
        sub_atom(AutorLower, _, _, _, PalabraLower)
    ;   downcase_atom(Genero, GeneroLower),
        sub_atom(GeneroLower, _, _, _, PalabraLower)
    ).

% Configuración de CORS
:- set_setting(http:cors, [*]).

% Manejo de la ruta /buscar
:- http_handler('/buscar', handle_buscar, [method(options), method(get)]).

handle_buscar(Request) :-
    cors_enable(Request, [methods([get,options])]),
    (   member(method(options), Request) -> 
        true
    ;   http_parameters(Request, [
            tipo(Tipo, [oneof([genero, autor, palabra]), default(palabra)]),
            valor(Valor, [default('')])
        ]),
        realizar_busqueda(Tipo, Valor, Resultados),
        length(Resultados, Count),  % CORRECCIÓN: calcular length primero
        reply_json_dict(_{
            success: true,
            resultados: Resultados,
            count: Count
        })
    ).

realizar_busqueda(genero, Valor, Resultados) :-
    findall(
        _{titulo: Titulo, autor: Autor, genero: Genero},
        buscar_por_genero(Valor, libro(Titulo, Autor, Genero)),
        Resultados
    ).

realizar_busqueda(autor, Valor, Resultados) :-
    findall(
        _{titulo: Titulo, autor: Autor, genero: Genero},
        buscar_por_autor(Valor, libro(Titulo, Autor, Genero)),
        Resultados
    ).

realizar_busqueda(palabra, Valor, Resultados) :-
    findall(
        _{titulo: Titulo, autor: Autor, genero: Genero},
        buscar_keyword(Valor, libro(Titulo, Autor, Genero)),
        Resultados
    ).

% Ruta principal
:- http_handler('/', home, [method(get)]).

home(_Request) :-
    format('Content-type: text/html; charset=utf-8~n~n'),
    format('<!DOCTYPE html>'),
    format('<html>'),
    format('<head>'),
    format('<title>LibroScope API</title>'),
    format('<style>'),
    format('body { font-family: Arial, sans-serif; padding: 40px; max-width: 800px; margin: 0 auto; line-height: 1.6; background: #f5f5f5; }'),
    format('.container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }'),
    format('h1 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }'),
    format('code { background: #f8f9fa; padding: 4px 8px; border-radius: 4px; border: 1px solid #e9ecef; font-family: "Courier New", monospace; }'),
    format('a { color: #3498db; text-decoration: none; }'),
    format('a:hover { text-decoration: underline; }'),
    format('ul { padding-left: 20px; }'),
    format('li { margin-bottom: 8px; }'),
    format('</style>'),
    format('</head>'),
    format('<body>'),
    format('<div class="container">'),
    format('<h1>LibroScope API</h1>'),
    format('<p><strong>Sistema de busqueda de libros en Prolog</strong></p>'),
    format('<h2>Endpoints disponibles:</h2>'),
    format('<ul>'),
    format('<li><code>GET /buscar?tipo=genero|autor|palabra&amp;valor=texto</code></li>'),
    format('</ul>'),
    format('<h2>Ejemplos:</h2>'),
    format('<ul>'),
    format('<li><a href="/buscar?tipo=autor&valor=garcia">/buscar?tipo=autor&amp;valor=garcia</a></li>'),
    format('<li><a href="/buscar?tipo=genero&valor=fantasia">/buscar?tipo=genero&amp;valor=fantasia</a></li>'),
    format('<li><a href="/buscar?tipo=palabra&valor=tiempo">/buscar?tipo=palabra&amp;valor=tiempo</a></li>'),
    format('</ul>'),
    format('</div>'),
    format('</body>'),
    format('</html>').

% Función para iniciar servidor
iniciar_servidor :-
    catch(http_stop_server(3000, _), _, true),
    http_server(http_dispatch, [port(3000)]),
    format('~n=== LibroScope Server ===~n'),
    format('Servidor corriendo en: http://localhost:3000~n'),
    format('Endpoint de busqueda: GET /buscar?tipo=XXX&valor=YYY~n'),
    format('=========================~n~n').

% Comando para detener el servidor
detener_servidor :-
    catch(http_stop_server(3000, _), _, true),
    format('Servidor detenido.~n').

% Comando para reiniciar
reiniciar_servidor :-
    detener_servidor,
    iniciar_servidor.