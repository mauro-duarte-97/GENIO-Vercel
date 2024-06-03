
document.addEventListener("DOMContentLoaded", function() {
    const mapElement = document.getElementById('map');
    const apiKey = mapElement.getAttribute('data-key');

    if (apiKey) {
        loadGoogleMaps(apiKey);
    } else {
        console.error('No API key found for Google Maps.');
    }
});

function loadGoogleMaps(apiKey) {
    const script = document.createElement('script');
    script.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey}&callback=initMap`;
    script.defer = true;
    script.async = true;
    document.head.appendChild(script);
}

function initMap() {
    const mapElement = document.getElementById('map');
    const map = new google.maps.Map(mapElement, {
        zoom: 14,
        center: { lat: -34.590747, lng: -58.4174746 } // Centro inicial del mapa
    });

    // Guarda la referencia del mapa en una variable global si necesitas acceder desde otras funciones
    window.myMap = map;
}


function setLocation(coordenadas) {
    // Separar las coordenadas en latitud y longitud
    const [latitud, longitud] = coordenadas.split(',');

    // Convertir las cadenas a números
    const latitudNum = parseFloat(latitud);
    const longitudNum = parseFloat(longitud);

    // Verificar si las conversiones fueron exitosas
    if (!isNaN(latitudNum) && !isNaN(longitudNum)) {
        // Centra el mapa en las nuevas coordenadas
        const map = window.myMap;
        map.setCenter({ lat: latitudNum, lng: longitudNum });

        // Opcional: Mostrar marcador en las coordenadas
        const marker = new google.maps.Marker({
            position: { lat: latitudNum, lng: longitudNum },
            map: map,
            icon: {
                url: "http://maps.google.com/mapfiles/ms/icons/red-dot.png" // Establece el icono rojo
            }
        });
    } else {
        console.error('Error al convertir las coordenadas:', coordenadas);
    }
}


// Inicializa el mapa cuando la ventana carga
window.onload = initMap;
