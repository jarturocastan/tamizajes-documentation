#!/bin/bash

echo "🏥 UNEME-CECOSAMA Documentation Server"
echo "======================================"
echo ""

# Función para mostrar ayuda
show_help() {
    echo "Uso: $0 [COMANDO]"
    echo ""
    echo "Comandos disponibles:"
    echo "  start    - Iniciar servidor de documentación"
    echo "  stop     - Detener servidor de documentación"
    echo "  build    - Construir la documentación estática"
    echo "  rebuild  - Reconstruir contenedor Docker"
    echo "  logs     - Ver logs del servidor"
    echo "  help     - Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 start    # Inicia servidor en http://localhost:8000"
    echo "  $0 build    # Genera documentación estática en site/"
    echo ""
}

# Función para verificar si Docker está corriendo
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo "❌ Error: Docker no está corriendo"
        echo "   Por favor inicia Docker Desktop o el servicio Docker"
        exit 1
    fi
}

# Función para iniciar documentación
start_docs() {
    check_docker
    echo "🚀 Iniciando servidor de documentación..."
    echo "📍 La documentación estará disponible en: http://localhost:8000"
    echo ""
    echo "⏳ Construyendo contenedor (puede tomar unos minutos la primera vez)..."
    
    docker-compose up --build -d mkdocs
    
    if [ $? -eq 0 ]; then
        echo "✅ Servidor iniciado exitosamente!"
        echo "🌐 Abre tu navegador en: http://localhost:8000"
        echo ""
        echo "💡 Comandos útiles:"
        echo "   $0 logs    - Ver logs en tiempo real"
        echo "   $0 stop    - Detener servidor"
    else
        echo "❌ Error al iniciar el servidor"
        exit 1
    fi
}

# Función para detener documentación
stop_docs() {
    check_docker
    echo "🛑 Deteniendo servidor de documentación..."
    docker-compose stop mkdocs
    docker-compose rm -f mkdocs
    echo "✅ Servidor detenido"
}

# Función para construir documentación estática
build_docs() {
    check_docker
    echo "🔨 Construyendo documentación estática..."
    docker-compose run --rm mkdocs mkdocs build
    echo "✅ Documentación construida en el directorio: site/"
    echo "📁 Puedes abrir site/index.html en tu navegador"
}

# Función para reconstruir contenedor
rebuild_container() {
    check_docker
    echo "🔄 Reconstruyendo contenedor Docker..."
    docker-compose down mkdocs
    docker-compose build --no-cache mkdocs
    echo "✅ Contenedor reconstruido"
}

# Función para ver logs
show_logs() {
    check_docker
    echo "📋 Mostrando logs del servidor (Ctrl+C para salir)..."
    docker-compose logs -f mkdocs
}

# Procesar argumentos
case "${1:-help}" in
    "start")
        start_docs
        ;;
    "stop")
        stop_docs
        ;;
    "build")
        build_docs
        ;;
    "rebuild")
        rebuild_container
        ;;
    "logs")
        show_logs
        ;;
    "help"|"--help"|"-h")
        show_help
        ;;
    *)
        echo "❌ Comando desconocido: $1"
        echo ""
        show_help
        exit 1
        ;;
esac