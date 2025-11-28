class LibroScope {
    constructor() {
        this.apiBaseUrl = 'http://localhost:3000';
        this.init();
    }

    init() {
        this.bindEvents();
        this.verificarServidor();
        console.log('LibroScope inicializado');
    }

    bindEvents() {
        document.getElementById('searchInput').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.buscarLibros();
            }
        });
    }

    async verificarServidor() {
        try {
            const response = await fetch(`${this.apiBaseUrl}/buscar?tipo=palabra&valor=test`, {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            });
            
            if (response.ok) {
                this.mostrarEstadoServidor(true);
            } else {
                this.mostrarEstadoServidor(false);
            }
        } catch (error) {
            this.mostrarEstadoServidor(false);
        }
    }

    mostrarEstadoServidor(conectado) {
        const statusElement = document.getElementById('serverStatus');
        if (conectado) {
            statusElement.innerHTML = '<div class="status-online">🟢 Servidor conectado</div>';
        } else {
            statusElement.innerHTML = '<div class="status-offline">🔴 Servidor desconectado - Verifica que Prolog esté ejecutándose en puerto 3000</div>';
        }
    }

    async buscarLibros() {
        const valor = document.getElementById('searchInput').value.trim();
        const tipo = document.getElementById('searchType').value;
        const searchBtn = document.getElementById('searchBtn');

        if (!valor) {
            this.mostrarMensajeBienvenida();
            return;
        }

        this.mostrarCargando();
        searchBtn.disabled = true;

        try {
            const url = new URL(`${this.apiBaseUrl}/buscar`);
            url.searchParams.append('tipo', tipo);
            url.searchParams.append('valor', valor);

            const response = await fetch(url, {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            });

            if (!response.ok) {
                throw new Error(`Error HTTP: ${response.status}`);
            }

            const data = await response.json();
            this.mostrarResultados(data.resultados, valor);
            this.mostrarEstadoServidor(true);

        } catch (error) {
            console.error('Error en la busqueda:', error);
            this.mostrarError('No se pudo conectar con el servidor Prolog.<br>Verifica que:<br>1. El servidor esté ejecutándose<br>2. Hayas escrito: <code>?- iniciar_servidor.</code><br>3. El puerto 3000 esté disponible');
            this.mostrarEstadoServidor(false);
        } finally {
            searchBtn.disabled = false;
        }
    }

    mostrarCargando() {
        const container = document.getElementById('resultsContainer');
        container.innerHTML = `
            <div class="loading">
                <div class="loading-spinner"></div>
                <p>Buscando libros...</p>
            </div>
        `;
    }

    mostrarError(mensaje) {
        const container = document.getElementById('resultsContainer');
        container.innerHTML = `
            <div class="error-message">
                <h3>❌ Error de Conexión</h3>
                <p>${mensaje}</p>
                <button onclick="libroScope.verificarServidor()" style="margin-top: 15px; padding: 10px 20px; background: var(--primary-color); color: white; border: none; border-radius: var(--radius); cursor: pointer;">
                    Reintentar Conexión
                </button>
            </div>
        `;
    }

    mostrarMensajeBienvenida() {
        const container = document.getElementById('resultsContainer');
        container.innerHTML = `
            <div class="welcome-message">
                <div class="welcome-icon">🔍</div>
                <h3>Comienza tu busqueda</h3>
                <p>Usa el formulario arriba para buscar libros por título, autor o género</p>
            </div>
        `;
    }

    mostrarResultados(libros, terminoBusqueda) {
        const container = document.getElementById('resultsContainer');

        if (!libros || libros.length === 0) {
            container.innerHTML = `
                <div class="no-results">
                    <h3>📖 No se encontraron libros</h3>
                    <p>No hay resultados para "${terminoBusqueda}". Intenta con otros terminos.</p>
                </div>
            `;
            return;
        }

        const librosHTML = libros.map(libro => this.crearTarjetaLibro(libro)).join('');
        
        container.innerHTML = `
            <div class="results-header" style="grid-column: 1 / -1; margin-bottom: 20px;">
                <h3 style="color: var(--text-primary); font-size: 1.25rem;">
                    Se encontraron ${libros.length} libro${libros.length !== 1 ? 's' : ''} para "${terminoBusqueda}"
                </h3>
            </div>
            ${librosHTML}
        `;
    }

    crearTarjetaLibro(libro) {
        return `
            <div class="book-card">
                <div class="book-header">
                    <h3 class="book-title">${this.escapeHtml(libro.titulo)}</h3>
                    <p class="book-author">por ${this.escapeHtml(libro.autor)}</p>
                </div>
                <div class="book-footer">
                    <span class="book-genre">${this.escapeHtml(libro.genero)}</span>
                </div>
            </div>
        `;
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Inicializar la aplicación
const libroScope = new LibroScope();

// Función global para el botón
function buscarLibros() {
    libroScope.buscarLibros();
}