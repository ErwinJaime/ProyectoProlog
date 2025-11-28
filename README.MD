# 📚 LibroScope - Sistema de Búsqueda de Libros

Sistema de búsqueda de libros desarrollado utilizando **Prolog** como backend y una **interfaz web moderna** construida con **HTML**, **CSS** y **JavaScript**.

---

## 🚀 Características

* 🔎 **Búsqueda por Género**: Encuentra libros por categoría literaria.
* ✍️ **Búsqueda por Autor**: Filtra todos los libros de un autor específico.
* 📝 **Búsqueda por Palabra Clave**: Busca coincidencias en título, autor y género.
* 🎨 **Interfaz Moderna y Responsive**.
* 🌐 **API REST en Prolog** con respuestas JSON.
* 📚 **Base de Datos Inicial de 20 Libros**.

---

## 🛠️ Tecnologías Utilizadas

* **Backend:** SWI‑Prolog (HTTP server)
* **Frontend:** HTML5, CSS3, JavaScript Vanilla
* **Comunicación:** API REST + CORS
* **Datos:** Hechos y reglas en Prolog

---

## 📋 Requisitos del Sistema

* **SWI-Prolog 8.0+**
* **Navegador moderno** (Chrome, Firefox, Edge, Safari)

---

## 🗂️ Estructura del Proyecto

```
libroscope/
├── libroscope.pl          # Servidor Prolog + base de conocimiento
├── index.html             # Interfaz principal
├── style.css              # Estilos
├── script.js              # Lógica del frontend
└── README.md              # Este archivo
```

---

## 🚀 Instalación y Configuración

### 1. Instalar SWI-Prolog

#### **Windows**

* Descargar desde: [https://www.swi-prolog.org/Download.html](https://www.swi-prolog.org/Download.html)
* Instalar y agregar al **PATH** del sistema.

#### **macOS**

```bash
brew install swi-prolog
```

#### **Linux (Ubuntu/Debian)**

```bash
sudo apt-get update
sudo apt-get install swi-prolog
```

#### **Linux (Fedora)**

```bash
sudo dnf install pl
```

### 2. Descargar el Proyecto

* Clonar o descargar la carpeta completa.
* Asegurarse de que todos los archivos estén juntos.

---

## 🎯 Ejecución del Proyecto

### **Paso 1: Iniciar el Servidor Backend**

Navegar a la carpeta del proyecto:

```bash
cd ruta/a/tu/carpeta/libroscope
```

Iniciar Prolog:

```bash
swipl -s libroscope.pl
```

Ejecutar el servidor dentro de Prolog:

```prolog
?- iniciar_servidor.
```

Deberías ver:

```
=== LibroScope Server ===
Servidor corriendo en: http://localhost:3000
Endpoint de busqueda: GET /buscar?tipo=XXX&valor=YYY
=========================
```

### **Paso 2: Abrir la Interfaz Web**

⚠️ **No usar Live Server.**

Solo abre el archivo directamente:

* Doble clic en **index.html**, o
* Arrastrarlo al navegador.

---

## 📖 Cómo Usar LibroScope

### **Interfaz Web**

1. Escribe tu término de búsqueda.
2. Selecciona el tipo:

   * Palabra clave
   * Género
   * Autor
3. Presiona **Buscar**.
4. Los resultados aparecerán en tarjetas elegantes.

### **Ejemplos de búsqueda**

* Autor: `garcia`, `orwell`, `rowling`
* Género: `fantasia`, `ciencia_ficcion`, `drama`
* Palabra clave: `tiempo`, `amor`, `mundo`

### **Uso directo de la API**

```
http://localhost:3000/buscar?tipo=autor&valor=garcia
http://localhost:3000/buscar?tipo=genero&valor=fantasia
http://localhost:3000/buscar?tipo=palabra&valor=tiempo
```

---

## 🗃️ Estructura de la Base de Conocimiento

Los libros están definidos así:

```prolog
libro("Título", "Autor", Genero).
```

Ejemplos:

```prolog
libro("Cien años de soledad", "Gabriel García Márquez", realismo_magico).
libro("1984", "George Orwell", distopia).
libro("El señor de los anillos", "J.R.R. Tolkien", fantasia).
```

### **Géneros Disponibles:**

realismo_magico, distopia, satira, clasico, romance, drama, existencialismo, modernismo, ciencia_ficcion, fantasia, misterio, terror

---

## 🔧 Comandos Útiles en Prolog

```prolog
% Reiniciar el servidor
?- reiniciar_servidor.

% Detener servidor
?- detener_servidor.

% Recargar archivo
?- make.

% Listar todos los libros
?- libro(Titulo, Autor, Genero).

% Salir
d?- halt.
```

---

## 🎨 Personalización

### **Modificar diseño**

Edita:

* **style.css** → Colores, fuentes, layouts.
* **index.html** → Estructura visual.
* **script.js** → Lógica del frontend.

### **Agregar más libros**

```prolog
libro("Nuevo Libro", "Nombre Autor", genero).
```

### **Expandir estructura**

```prolog
% Actual
libro(Titulo, Autor, Genero).

% Extendido
libro(Titulo, Autor, Genero, Año, Paginas, Editorial).
```

---

## 🐛 Solución de Problemas

### ❗ Puerto 3000 ocupado

#### Windows

```cmd
netstat -ano | findstr :3000
taskkill /PID [PID] /F
```

#### Linux/macOS

```bash
lsof -ti:3000 | xargs kill -9
```

### ❗ Servidor desconectado

* Verificar que SWI-Prolog esté activo.
* Ejecutar `iniciar_servidor.`
* Revisar errores en la consola.

### ❗ Sin resultados

* Usar minúsculas.
* Revisar ortografía.
* Intentar términos más generales.

### ❗ Caracteres especiales

* Asegurar `charset=utf-8` en headers.
* Usar comillas dobles.

---

## 📊 Estructura Técnica

### **Backend (Prolog)**

* Servidor HTTP: `http/thread_httpd`
* Rutas: `http_handler`
* JSON: `http_json`
* CORS habilitado

### **Frontend (HTML/CSS/JS)**

* CSS Grid + Flexbox
* Responsive
* Fetch API
* UI dinámica

---

## 🔍 Ejemplos de Búsquedas Exitosas

| Tipo    | Valor      | Resultado                            |
| ------- | ---------- | ------------------------------------ |
| Autor   | `garcia`   | Libros de G. García Márquez          |
| Género  | `fantasia` | LOTR, Harry Potter                   |
| Palabra | `tiempo`   | Cien años..., En busca del tiempo... |
| Autor   | `orwell`   | 1984, Rebelión en la granja          |

---

## 📝 Notas de Desarrollo

* Excelente integración entre **Prolog** y **web moderna**.
* Base de conocimiento extensible.
* Frontend totalmente independiente.
* Ideal para aprender IA simbólica + desarrollo web.

---

## 🤝 Contribuciones

* Agregar más libros.
* Mejorar CSS.
* Crear nuevos tipos de búsqueda.
* Optimizar código.

---

## 📄 Licencia

Proyecto educativo de código abierto.

---

**¡Disfruta explorando el mundo de los libros con LibroScope! 📚✨**
