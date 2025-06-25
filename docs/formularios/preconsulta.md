# Formulario de Preconsulta Digital

## Introducción

El formulario de preconsulta digital es la primera herramienta de evaluación que se envía automáticamente a los pacientes vía WhatsApp. Basado en el documento fuente `PRECONSULTA.docx`, este formulario captura información básica esencial para la primera consulta.

## Estructura del Formulario

### 📋 Información de Identificación

| Campo | Tipo | Validación | Obligatorio | Descripción |
|-------|------|------------|-------------|-------------|
| `fecha_preconsulta` | Date | Formato DD/MM/AAAA | Sí | Fecha de llenado automático |
| `folio_preconsulta` | Text | Auto-generado | Sí | Folio único del sistema |
| `nombres` | Text | Min 2 caracteres | Sí | Nombre(s) del paciente |
| `apellido_paterno` | Text | Min 2 caracteres | Sí | Apellido paterno |
| `apellido_materno` | Text | Min 2 caracteres | No | Apellido materno |

### 🏠 Datos de Contacto

| Campo | Tipo | Validación | Obligatorio | Descripción |
|-------|------|------------|-------------|-------------|
| `calle` | Text | Min 5 caracteres | Sí | Nombre de la calle |
| `numero` | Text | Números/letras | Sí | Número exterior e interior |
| `colonia` | Text | Min 3 caracteres | Sí | Colonia/fraccionamiento |
| `municipio` | Text | Min 3 caracteres | Sí | Municipio o delegación |
| `codigo_postal` | Number | 5 dígitos | Sí | Código postal |
| `telefono_principal` | Phone | 10 dígitos | Sí | Teléfono principal |
| `telefono_alternativo` | Phone | 10 dígitos | No | Teléfono alternativo |

### 👤 Información Personal

| Campo | Tipo | Opciones | Obligatorio | Descripción |
|-------|------|----------|-------------|-------------|
| `sexo_biologico` | Radio | Hombre/Intersexual/Mujer | Sí | Sexo biológico |
| `genero_identidad` | Radio | Masculino/Femenino/No binario/Otro | No | Identidad de género |
| `genero_otro` | Text | Solo si selecciona "Otro" | Condicional | Especificar identidad |
| `edad` | Number | 12-99 años | Sí | Edad actual |
| `estado_civil` | Dropdown | Lista predefinida | Sí | Estado civil actual |
| `escolaridad` | Dropdown | Lista predefinida | Sí | Nivel educativo |
| `ocupacion` | Text | Min 3 caracteres | Sí | Ocupación actual |

### 👨‍👩‍👧‍👦 Familiar Responsable (Para menores)

| Campo | Tipo | Validación | Obligatorio | Descripción |
|-------|------|------------|-------------|-------------|
| `es_menor` | Boolean | Calculado por edad | Auto | Si es menor de 18 años |
| `familiar_responsable` | Text | Min 5 caracteres | Condicional | Nombre del responsable |
| `parentesco` | Dropdown | Lista predefinida | Condicional | Relación con el menor |
| `telefono_responsable` | Phone | 10 dígitos | Condicional | Teléfono del responsable |

## Implementación Digital

### 🖥️ Interfaz de Usuario

=== "Página de Bienvenida"
    ```html
    <div class="form-header">
        <h1>🏥 UNEME-CECOSAMA</h1>
        <h2>Formulario de Preconsulta</h2>
        <p>Este formulario nos ayuda a conocerte mejor y preparar tu primera consulta.</p>
        <div class="progress-bar">
            <div class="progress-step active">1</div>
            <div class="progress-step">2</div>
            <div class="progress-step">3</div>
            <div class="progress-step">4</div>
        </div>
    </div>
    ```

=== "Sección 1: Datos Personales"
    ```html
    <section class="form-section">
        <h3>📝 Información Personal</h3>
        
        <div class="form-group">
            <label>Nombre(s) *</label>
            <input type="text" name="nombres" required minlength="2">
        </div>
        
        <div class="form-row">
            <div class="form-group">
                <label>Apellido Paterno *</label>
                <input type="text" name="apellido_paterno" required>
            </div>
            <div class="form-group">
                <label>Apellido Materno</label>
                <input type="text" name="apellido_materno">
            </div>
        </div>
        
        <div class="form-group">
            <label>Edad *</label>
            <input type="number" name="edad" min="12" max="99" required>
        </div>
    </section>
    ```

=== "Sección 2: Sexo y Género"
    ```html
    <section class="form-section">
        <h3>👤 Identidad</h3>
        
        <div class="form-group">
            <label>Sexo Biológico *</label>
            <div class="radio-group">
                <label><input type="radio" name="sexo_biologico" value="Hombre" required> Hombre</label>
                <label><input type="radio" name="sexo_biologico" value="Mujer" required> Mujer</label>
                <label><input type="radio" name="sexo_biologico" value="Intersexual" required> Intersexual</label>
            </div>
        </div>
        
        <div class="form-group">
            <label>Identidad de Género</label>
            <div class="radio-group">
                <label><input type="radio" name="genero_identidad" value="Masculino"> Masculino</label>
                <label><input type="radio" name="genero_identidad" value="Femenino"> Femenino</label>
                <label><input type="radio" name="genero_identidad" value="No binario"> No binario</label>
                <label><input type="radio" name="genero_identidad" value="Otro" id="genero-otro"> Otro</label>
            </div>
            <input type="text" name="genero_otro" placeholder="Especificar..." style="display:none" id="genero-otro-text">
        </div>
    </section>
    ```

### 📱 Optimización Móvil

```css
/* Estilos responsivos para móvil */
.form-container {
    max-width: 100%;
    padding: 15px;
    font-size: 16px; /* Evita zoom en iOS */
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    font-weight: bold;
    margin-bottom: 5px;
    color: #2c5282;
}

.form-group input,
.form-group select,
.form-group textarea {
    width: 100%;
    padding: 12px;
    border: 2px solid #e2e8f0;
    border-radius: 8px;
    font-size: 16px;
}

/* Indicador de campo obligatorio */
.form-group label:after {
    content: " *";
    color: red;
    display: inline;
}

.form-group.optional label:after {
    display: none;
}
```

## Validaciones en Tiempo Real

### ⚡ JavaScript de Validación

```javascript
// Validación de edad y campos condicionales
document.getElementById('edad').addEventListener('input', function() {
    const edad = parseInt(this.value);
    const seccionResponsable = document.getElementById('seccion-responsable');
    
    if (edad < 18) {
        seccionResponsable.style.display = 'block';
        // Hacer campos de responsable obligatorios
        document.querySelectorAll('#seccion-responsable input[required]').forEach(input => {
            input.setAttribute('required', 'required');
        });
    } else {
        seccionResponsable.style.display = 'none';
        // Remover obligatoriedad
        document.querySelectorAll('#seccion-responsable input').forEach(input => {
            input.removeAttribute('required');
        });
    }
});

// Validación de teléfono mexicano
function validarTelefono(telefono) {
    const regex = /^[0-9]{10}$/;
    return regex.test(telefono);
}

// Validación de código postal mexicano
function validarCP(cp) {
    const regex = /^[0-9]{5}$/;
    return regex.test(cp);
}

// Mostrar campo "Otro" para género
document.getElementById('genero-otro').addEventListener('change', function() {
    const otroTexto = document.getElementById('genero-otro-text');
    if (this.checked) {
        otroTexto.style.display = 'block';
        otroTexto.setAttribute('required', 'required');
    } else {
        otroTexto.style.display = 'none';
        otroTexto.removeAttribute('required');
    }
});
```

## Integración con GoHighLevel

### 🔗 Mapeo de Campos

```json
{
  "contact_mapping": {
    "firstName": "{{nombres}}",
    "lastName": "{{apellido_paterno}} {{apellido_materno}}",
    "phone": "{{telefono_principal}}",
    "email": "{{email_opcional}}",
    "address1": "{{calle}} {{numero}}",
    "city": "{{municipio}}",
    "state": "{{estado}}",
    "postalCode": "{{codigo_postal}}",
    "customFields": {
      "edad_paciente": "{{edad}}",
      "sexo_biologico": "{{sexo_biologico}}",
      "genero_identidad": "{{genero_identidad}}",
      "estado_civil": "{{estado_civil}}",
      "escolaridad": "{{escolaridad}}",
      "ocupacion": "{{ocupacion}}",
      "familiar_responsable": "{{familiar_responsable}}",
      "parentesco_responsable": "{{parentesco}}",
      "telefono_emergencia": "{{telefono_responsable}}",
      "motivo_consulta": "{{motivo_consulta}}",
      "fecha_preconsulta": "{{fecha_preconsulta}}",
      "folio_preconsulta": "{{folio_preconsulta}}"
    }
  }
}
```

### 📤 Webhook de Envío

```javascript
// Función para enviar datos a GoHighLevel
async function enviarPreconsulta(formData) {
    const webhookURL = 'https://services.leadconnectorhq.com/hooks/webhook-id';
    
    const payload = {
        type: 'preconsulta_completed',
        timestamp: new Date().toISOString(),
        patient_data: {
            ...formData,
            form_type: 'preconsulta',
            completion_time: calculateCompletionTime(),
            device_info: getDeviceInfo()
        }
    };
    
    try {
        const response = await fetch(webhookURL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + API_TOKEN
            },
            body: JSON.stringify(payload)
        });
        
        if (response.ok) {
            mostrarPaginaExito();
            enviarSiguienteFormulario();
        } else {
            mostrarError('Error al enviar formulario');
        }
    } catch (error) {
        console.error('Error:', error);
        mostrarError('Error de conectividad');
    }
}
```

## Evaluación Automática

### 🎯 Criterios de Priorización

```javascript
function evaluarPrioridad(formData) {
    let prioridad = 'normal';
    let alertas = [];
    
    // Evaluación por edad
    if (formData.edad < 18) {
        prioridad = 'alta';
        alertas.push('Paciente menor de edad');
    }
    
    // Evaluación por motivo de consulta
    const motivosUrgentes = [
        'suicidio', 'matarme', 'autolesión', 'abuso', 
        'violencia', 'adicción severa', 'crisis'
    ];
    
    const motivoLower = formData.motivo_consulta.toLowerCase();
    for (let motivo of motivosUrgentes) {
        if (motivoLower.includes(motivo)) {
            prioridad = 'crítica';
            alertas.push(`Motivo de consulta contiene: ${motivo}`);
            break;
        }
    }
    
    return {
        prioridad: prioridad,
        alertas: alertas,
        requiere_revision_inmediata: prioridad === 'crítica'
    };
}
```

## Página de Confirmación

### ✅ Interfaz de Éxito

```html
<div class="success-page">
    <div class="success-icon">✅</div>
    <h2>¡Formulario Completado!</h2>
    <p>Gracias <strong>{{nombres}}</strong> por completar la preconsulta.</p>
    
    <div class="next-steps">
        <h3>📋 Próximos pasos:</h3>
        <ol>
            <li>Recibirás el siguiente cuestionario en WhatsApp</li>
            <li>Un coordinador médico revisará tu información</li>
            <li>Te contactaremos para agendar tu primera cita</li>
        </ol>
    </div>
    
    <div class="contact-info">
        <h3>📞 ¿Necesitas ayuda inmediata?</h3>
        <p><strong>Línea de Crisis:</strong> 800-911-2000</p>
        <p><strong>WhatsApp UNEME:</strong> {{telefono_whatsapp}}</p>
    </div>
    
    <button onclick="cerrarFormulario()" class="btn-primary">
        Cerrar Formulario
    </button>
</div>
```

## Reportes y Analytics

### 📊 Métricas de Formulario

| Métrica | Objetivo | Cálculo |
|---------|----------|---------|
| **Tasa de Completación** | > 85% | Completados / Enviados |
| **Tiempo Promedio** | < 5 minutos | Timestamp final - inicial |
| **Abandono por Sección** | < 10% por sección | Abandonos / Iniciados por sección |
| **Errores de Validación** | < 5% | Errores / Intentos de envío |
| **Conversión a Cita** | > 75% | Citas agendadas / Formularios completados |

### 📈 Dashboard de Monitoreo

```javascript
// Métricas en tiempo real
const metricas = {
    hoy: {
        enviados: 45,
        completados: 38,
        abandonados: 7,
        tiempo_promedio: '4:32',
        errores: 2
    },
    semana: {
        enviados: 312,
        completados: 267,
        tasa_completacion: '85.6%',
        motivos_frecuentes: [
            'Depresión - 45%',
            'Ansiedad - 32%', 
            'Problemas familiares - 15%',
            'Adicciones - 8%'
        ]
    }
};
```

## Consideraciones de Accesibilidad

### ♿ Accesibilidad Web

- **Contraste**: Mínimo 4.5:1 para texto normal
- **Navegación por teclado**: Todos los campos accesibles con Tab
- **Screen readers**: Labels apropiados y descripciones
- **Tamaño de fuente**: Mínimo 16px para evitar zoom móvil
- **Touch targets**: Mínimo 44px para elementos tocables

### 🌐 Soporte Multi-idioma

**[PENDIENTE - VALIDAR CON CLIENTE]**: Determinar si se requiere soporte para lenguas indígenas locales

---

## Checklist de Implementación

### ✅ Desarrollo
- [ ] Diseño responsive para móviles
- [ ] Validaciones en tiempo real
- [ ] Integración con WhatsApp
- [ ] Conexión con GoHighLevel
- [ ] Páginas de confirmación

### ✅ Testing
- [ ] Pruebas en múltiples dispositivos
- [ ] Validación de datos
- [ ] Flujo completo end-to-end
- [ ] Performance y velocidad de carga
- [ ] Accesibilidad web

### ✅ Seguridad
- [ ] Cifrado de datos en tránsito
- [ ] Validación server-side
- [ ] Protección contra spam
- [ ] Logs de auditoría
- [ ] Backup de datos

!!! tip "Optimización Continua"
    Revisar métricas semanalmente y optimizar campos o secciones con altas tasas de abandono.

!!! warning "Datos Sensibles"
    Todos los datos del formulario son información médica confidencial. Implementar las máximas medidas de seguridad y privacidad.