shader_type canvas_item;

// Parámetros ajustables desde el panel del Inspector
uniform vec4 color_borde : source_color = vec4(1.0, 1.0, 1.0, 1.0);     // Blanco sólido
uniform vec4 color_fondo : source_color = vec4(0.5, 0.5, 0.5, 0.4);     // Gris transparente superior
uniform vec4 color_sombra : source_color = vec4(0.0, 0.0, 0.0, 0.8);    // Negro inferior
uniform float grosor_borde : hint_range(0.0, 0.2) = 0.03;
uniform float radio_esquina : hint_range(0.0, 0.5) = 0.15;

// Función para calcular las esquinas redondeadas matemáticamente (SDF)
float rectangulo_redondeado(vec2 posicion, vec2 mitad_tamano, float radio) {
    vec2 d = abs(posicion) - mitad_tamano + radio;
    return min(max(d.x, d.y), 0.0) + length(max(d, 0.0)) - radio;
}

void fragment() {
    // Mapear UV de [0, 1] a [-1, 1] para centrar las coordenadas
    vec2 uv_centrado = UV * 2.0 - 1.0; 
    
    // Calcular la distancia desde el centro a los bordes
    float distancia = rectangulo_redondeado(uv_centrado, vec2(1.0), radio_esquina);
    
    // Suavizado automático según la resolución (antialiasing)
    float suavizado = fwidth(distancia);
    
    // Máscara principal (corta lo que está fuera de los bordes redondeados)
    float mascara_boton = 1.0 - smoothstep(0.0, suavizado, distancia);
    
    // Máscara interna (para separar el borde del fondo)
    float mascara_interior = 1.0 - smoothstep(-grosor_borde, -grosor_borde + suavizado, distancia);
    
    // Efecto visual: Degradado vertical en el interior (gris transparente a negro)
    vec4 color_gradiente = mix(color_fondo, color_sombra, UV.y);
    
    // Mezclar el color del borde blanco con el fondo degradado
    vec4 color_final = mix(color_borde, color_gradiente, mascara_interior);
    
    // Aplicar los colores y la transparencia total al botón
    COLOR = vec4(color_final.rgb, color_final.a * mascara_boton);
}