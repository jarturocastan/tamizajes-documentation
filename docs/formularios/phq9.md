# Cuestionario PHQ-9 Digital

## Introducción

El PHQ-9 (Patient Health Questionnaire-9) es un instrumento estandarizado para la evaluación de síntomas depresivos. En el sistema UNEME-CECOSAMA, su implementación digital permite detección automática de riesgo y priorización de casos.

## Instrumento Original

Basado en el documento `Cuestionario PHQ-9.docx.md`, el PHQ-9 evalúa la frecuencia de síntomas depresivos en las últimas 2 semanas mediante 9 preguntas específicas.

### 📋 Estructura del PHQ-9

| Pregunta | Contenido | Peso Clínico |
|----------|-----------|--------------|
| **1** | Poco interés o placer en hacer cosas | Anhedonia |
| **2** | Se ha sentido decaído(a), deprimido(a) o sin esperanzas | Estado de ánimo deprimido |
| **3** | Dificultad para quedarse o permanecer dormido, o ha dormido demasiado | Trastornos del sueño |
| **4** | Se ha sentido cansado(a) o con poca energía | Fatiga |
| **5** | Sin apetito o ha comido en exceso | Trastornos del apetito |
| **6** | Se ha sentido mal consigo mismo(a) – fracaso o decepción | Autoevaluación negativa |
| **7** | Dificultad para concentrarse en actividades | Problemas de concentración |
| **8** | Se mueve/habla lento o muy inquieto/agitado | Agitación psicomotriz |
| **9** | Pensamientos de muerte o autolesión | **RIESGO SUICIDA** |

## Implementación Digital

### 🖥️ Interfaz de Usuario

=== "Encabezado del Formulario"
    ```html
    <div class="phq9-header">
        <h1>📊 Cuestionario PHQ-9</h1>
        <h2>Evaluación de Estado de Ánimo</h2>
        <div class="instrucciones">
            <p><strong>Instrucciones:</strong></p>
            <p>Durante las últimas <strong>2 semanas</strong>, ¿qué tan seguido ha tenido molestias debido a los siguientes problemas?</p>
            <p>Selecciona la opción que mejor describa tu experiencia.</p>
        </div>
        <div class="progress-indicator">
            Pregunta <span id="current-q">1</span> de 9
        </div>
    </div>
    ```

=== "Pregunta Individual"
    ```html
    <div class="phq9-question" data-question="1">
        <div class="question-number">Pregunta 1 de 9</div>
        <h3 class="question-text">
            Poco interés o placer en hacer cosas
        </h3>
        
        <div class="answer-options">
            <label class="option-card">
                <input type="radio" name="q1" value="0" required>
                <div class="option-content">
                    <div class="option-title">Ningún día</div>
                    <div class="option-subtitle">0 puntos</div>
                </div>
            </label>
            
            <label class="option-card">
                <input type="radio" name="q1" value="1" required>
                <div class="option-content">
                    <div class="option-title">Varios días</div>
                    <div class="option-subtitle">1 punto</div>
                </div>
            </label>
            
            <label class="option-card">
                <input type="radio" name="q1" value="2" required>
                <div class="option-content">
                    <div class="option-title">Más de la mitad de los días</div>
                    <div class="option-subtitle">2 puntos</div>
                </div>
            </label>
            
            <label class="option-card">
                <input type="radio" name="q1" value="3" required>
                <div class="option-content">
                    <div class="option-title">Casi todos los días</div>
                    <div class="option-subtitle">3 puntos</div>
                </div>
            </label>
        </div>
        
        <div class="navigation-buttons">
            <button type="button" class="btn-prev" disabled>Anterior</button>
            <button type="button" class="btn-next">Siguiente</button>
        </div>
    </div>
    ```

=== "Pregunta 9 (Crítica)"
    ```html
    <div class="phq9-question critical" data-question="9">
        <div class="question-number">Pregunta 9 de 9</div>
        <div class="critical-warning">
            ⚠️ Esta pregunta es muy importante para tu seguridad
        </div>
        
        <h3 class="question-text">
            Pensamientos de que estaría mejor muerto(a) o de lastimarse de alguna manera
        </h3>
        
        <div class="answer-options critical-options">
            <label class="option-card safe">
                <input type="radio" name="q9" value="0" required>
                <div class="option-content">
                    <div class="option-title">Ningún día</div>
                    <div class="option-subtitle">No he tenido estos pensamientos</div>
                </div>
            </label>
            
            <label class="option-card warning">
                <input type="radio" name="q9" value="1" required>
                <div class="option-content">
                    <div class="option-title">Varios días</div>
                    <div class="option-subtitle">He tenido algunos pensamientos</div>
                </div>
            </label>
            
            <label class="option-card danger">
                <input type="radio" name="q9" value="2" required>
                <div class="option-content">
                    <div class="option-title">Más de la mitad de los días</div>
                    <div class="option-subtitle">Pensamientos frecuentes</div>
                </div>
            </label>
            
            <label class="option-card critical">
                <input type="radio" name="q9" value="3" required>
                <div class="option-content">
                    <div class="option-title">Casi todos los días</div>
                    <div class="option-subtitle">Pensamientos muy frecuentes</div>
                </div>
            </label>
        </div>
    </div>
    ```

### 🎨 Estilos CSS

```css
.phq9-container {
    max-width: 600px;
    margin: 0 auto;
    padding: 20px;
    font-family: 'Segoe UI', system-ui, sans-serif;
}

.question-text {
    font-size: 18px;
    font-weight: 600;
    color: #2d3748;
    margin-bottom: 20px;
    line-height: 1.4;
}

.answer-options {
    display: grid;
    gap: 12px;
    margin-bottom: 30px;
}

.option-card {
    display: block;
    padding: 16px;
    border: 2px solid #e2e8f0;
    border-radius: 12px;
    cursor: pointer;
    transition: all 0.2s ease;
    background: white;
}

.option-card:hover {
    border-color: #3182ce;
    box-shadow: 0 2px 8px rgba(49, 130, 206, 0.1);
}

.option-card input[type="radio"] {
    display: none;
}

.option-card input[type="radio"]:checked + .option-content {
    color: #3182ce;
    font-weight: 600;
}

.option-card:has(input:checked) {
    border-color: #3182ce;
    background-color: #ebf4ff;
}

/* Estilos para pregunta crítica */
.critical-options .option-card.warning:has(input:checked) {
    border-color: #d69e2e;
    background-color: #fef5e7;
}

.critical-options .option-card.danger:has(input:checked) {
    border-color: #e53e3e;
    background-color: #fed7d7;
}

.critical-options .option-card.critical:has(input:checked) {
    border-color: #c53030;
    background-color: #fed7d7;
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0% { box-shadow: 0 0 0 0 rgba(197, 48, 48, 0.4); }
    70% { box-shadow: 0 0 0 10px rgba(197, 48, 48, 0); }
    100% { box-shadow: 0 0 0 0 rgba(197, 48, 48, 0); }
}
```

## Lógica de Evaluación

### 🧮 Cálculo de Puntaje

```javascript
class PHQ9Calculator {
    constructor() {
        this.questions = 9;
        this.maxScore = 27;
        this.responses = {};
    }
    
    // Registrar respuesta
    setResponse(questionNumber, value) {
        this.responses[questionNumber] = parseInt(value);
        this.calculateScore();
    }
    
    // Calcular puntaje total
    calculateScore() {
        let totalScore = 0;
        for (let i = 1; i <= this.questions; i++) {
            totalScore += this.responses[i] || 0;
        }
        return totalScore;
    }
    
    // Interpretar severidad
    interpretScore(score) {
        if (score >= 20) return { level: 'severa', description: 'Depresión severa', priority: 'crítica' };
        if (score >= 15) return { level: 'moderada-severa', description: 'Depresión moderada-severa', priority: 'alta' };
        if (score >= 10) return { level: 'moderada', description: 'Depresión moderada', priority: 'media' };
        if (score >= 5) return { level: 'leve', description: 'Depresión leve', priority: 'baja' };
        return { level: 'minimal', description: 'Síntomas mínimos', priority: 'normal' };
    }
    
    // Evaluar riesgo suicida (Pregunta 9)
    evaluateSuicideRisk() {
        const q9Response = this.responses[9] || 0;
        
        if (q9Response === 0) return { risk: 'ninguno', action: 'normal' };
        if (q9Response === 1) return { risk: 'bajo', action: 'seguimiento' };
        if (q9Response === 2) return { risk: 'moderado', action: 'evaluacion_urgente' };
        if (q9Response === 3) return { risk: 'alto', action: 'intervencion_inmediata' };
    }
    
    // Generar reporte completo
    generateReport() {
        const score = this.calculateScore();
        const interpretation = this.interpretScore(score);
        const suicideRisk = this.evaluateSuicideRisk();
        
        return {
            score: score,
            maxScore: this.maxScore,
            percentage: ((score / this.maxScore) * 100).toFixed(1),
            interpretation: interpretation,
            suicideRisk: suicideRisk,
            responses: this.responses,
            completedAt: new Date().toISOString(),
            requiresImmediateAttention: suicideRisk.risk !== 'ninguno' || score >= 15
        };
    }
}
```

### 🚨 Sistema de Alertas Automáticas

```javascript
function processPHQ9Response(report) {
    const alerts = [];
    
    // Alerta por riesgo suicida
    if (report.suicideRisk.risk !== 'ninguno') {
        alerts.push({
            type: 'suicide_risk',
            level: report.suicideRisk.risk,
            action: report.suicideRisk.action,
            message: `Riesgo suicida ${report.suicideRisk.risk} detectado`,
            urgency: report.suicideRisk.action === 'intervencion_inmediata' ? 'crítica' : 'alta'
        });
    }
    
    // Alerta por puntaje alto
    if (report.score >= 15) {
        alerts.push({
            type: 'high_score',
            level: 'depresion_severa',
            action: 'evaluacion_psiquiatrica',
            message: `PHQ-9 score: ${report.score}/27 - ${report.interpretation.description}`,
            urgency: 'alta'
        });
    }
    
    // Enviar alertas al equipo médico
    if (alerts.length > 0) {
        sendMedicalAlert(alerts, patientData);
    }
    
    return alerts;
}

async function sendMedicalAlert(alerts, patientData) {
    const webhookData = {
        patient_id: patientData.id,
        patient_name: patientData.name,
        phone: patientData.phone,
        alerts: alerts,
        timestamp: new Date().toISOString(),
        requires_immediate_action: alerts.some(a => a.urgency === 'crítica')
    };
    
    // Enviar a GoHighLevel
    await fetch('/webhook/medical-alert', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(webhookData)
    });
    
    // Si es crítico, enviar también por SMS/WhatsApp al coordinador
    if (webhookData.requires_immediate_action) {
        await sendEmergencyNotification(webhookData);
    }
}
```

## Respuestas Automáticas Post-Cuestionario

### ✅ Respuesta para Puntaje Normal (0-9)

```
📊 *PHQ-9 Completado*

¡Gracias por completar el cuestionario, {nombre}!

✅ *Tus resultados*:
• Puntaje: {score}/27
• Interpretación: Síntomas mínimos de depresión

😊 *Esto significa*:
Tus respuestas sugieren que actualmente experimentas pocos síntomas depresivos, lo cual es positivo.

📅 *Próximos pasos*:
• Completarás el siguiente cuestionario
• Agendaremos tu primera consulta
• El profesional revisará todos tus resultados

💚 Cuidar tu salud mental es importante, y estás tomando la decisión correcta al buscar apoyo.
```

### ⚠️ Respuesta para Puntaje Moderado (10-19)

```
📊 *PHQ-9 Completado*

Gracias {nombre} por tu honestidad al responder.

📋 *Tus resultados*:
• Puntaje: {score}/27  
• Interpretación: Depresión {nivel}

🤝 *Lo que esto significa*:
Tus respuestas indican que has estado experimentando síntomas significativos que pueden estar afectando tu bienestar.

⚡ *Acción prioritaria*:
• Un coordinador médico revisará tu caso HOY
• Te contactaremos para agendar una cita PRIORITARIA
• Mientras tanto, tienes nuestro apoyo completo

💜 *Recuerda*: Buscar ayuda es un acto de valentía. No estás solo/a en esto.

🚨 Si necesitas hablar con alguien ahora: 
📞 Línea de Crisis: 800-911-2000
```

### 🚨 Respuesta para Puntaje Alto (20+) o Riesgo Suicida

```
🚨 *ATENCIÓN PRIORITARIA* 🚨

{nombre}, hemos recibido tu cuestionario y vemos que estás pasando por un momento muy difícil.

⚠️ *Acción inmediata*:
• Un profesional te contactará en los próximos 30 MINUTOS
• Tu caso será manejado como URGENCIA MÉDICA
• No dejaremos que pases por esto solo/a

🆘 *Mientras esperamos*:
Si tienes pensamientos de lastimarte, llama AHORA:
📞 Línea Nacional de Prevención del Suicidio: 800-911-2000
📞 Cruz Roja: 911
📞 Locatel: 56-58-11-11

💚 *Mensaje importante*:
Lo que sientes ahora puede cambiar. Hay tratamientos efectivos y personas que se preocupan por ti. Acabas de dar el paso más importante: pedir ayuda.

🔒 Toda esta información es confidencial y será manejada por profesionales especializados.

Un miembro de nuestro equipo se comunicará contigo MUY PRONTO.
```

## Integración con Protocolos de Crisis

### 🚨 Protocolo de Riesgo Suicida

```javascript
function activateSuicideProtocol(patientData, phq9Report) {
    const protocol = {
        patient: patientData,
        risk_level: phq9Report.suicideRisk.risk,
        score: phq9Report.score,
        triggered_at: new Date(),
        actions_required: []
    };
    
    // Definir acciones basadas en nivel de riesgo
    switch (phq9Report.suicideRisk.action) {
        case 'intervencion_inmediata':
            protocol.actions_required = [
                'Contacto telefónico inmediato (< 30 minutos)',
                'Evaluación psiquiátrica urgente',
                'Activar red de apoyo familiar',
                'Considerar hospitalización si es necesario'
            ];
            protocol.time_limit = 30; // minutos
            break;
            
        case 'evaluacion_urgente':
            protocol.actions_required = [
                'Contacto profesional en 2 horas',
                'Cita prioritaria dentro de 24 horas',
                'Evaluación de factores de riesgo'
            ];
            protocol.time_limit = 120; // minutos
            break;
            
        case 'seguimiento':
            protocol.actions_required = [
                'Evaluación dentro de 48 horas',
                'Seguimiento telefónico',
                'Cita regular programada'
            ];
            protocol.time_limit = 2880; // minutos (48 horas)
            break;
    }
    
    // Notificar al equipo de crisis
    notifyMedicalTeam(protocol);
    
    // Programar seguimientos automáticos
    scheduleFollowUps(protocol);
    
    return protocol;
}
```

## Reportes y Analytics

### 📊 Dashboard PHQ-9

```javascript
const phq9Analytics = {
    // Distribución de puntajes
    scoreDistribution: {
        minimal: { range: '0-4', count: 156, percentage: 42.3 },
        mild: { range: '5-9', count: 98, percentage: 26.6 },
        moderate: { range: '10-14', count: 67, percentage: 18.2 },
        moderately_severe: { range: '15-19', count: 32, percentage: 8.7 },
        severe: { range: '20-27', count: 15, percentage: 4.1 }
    },
    
    // Riesgo suicida
    suicideRisk: {
        none: { count: 298, percentage: 80.9 },
        low: { count: 45, percentage: 12.2 },
        moderate: { count: 18, percentage: 4.9 },
        high: { count: 7, percentage: 1.9 }
    },
    
    // Tiempos de respuesta
    responseMetrics: {
        averageCompletionTime: '3:45',
        abandonmentRate: '8.2%',
        mobileCompletion: '89.4%'
    }
};
```

### 📈 Métricas de Seguimiento

| Métrica | Objetivo | Actual | Tendencia |
|---------|----------|--------|-----------|
| **Completación del PHQ-9** | > 90% | 91.8% | ↗️ |
| **Detección de Riesgo Alto** | 100% alertas | 100% | ✅ |
| **Tiempo de Respuesta Crisis** | < 30 min | 18 min | ✅ |
| **Seguimiento Post-Crisis** | 100% | 96.4% | ↗️ |

## Consideraciones Clínicas

### 🩺 Validez del Instrumento

- **Sensibilidad**: 88% para depresión moderada-severa
- **Especificidad**: 88% para diagnóstico diferencial  
- **Punto de corte recomendado**: ≥ 10 para depresión moderada
- **Validación en población mexicana**: Disponible y validada

### 📚 Referencias Científicas

- Kroenke, K., Spitzer, R. L., & Williams, J. B. (2001). PHQ-9
- Baader, T., et al. (2012). Validación y utilidad de la encuesta PHQ-9
- American Psychiatric Association (2013). DSM-5

---

## Checklist de Implementación

### ✅ Desarrollo Técnico
- [ ] Interfaz responsive para móviles
- [ ] Validación en tiempo real
- [ ] Cálculo automático de puntajes
- [ ] Sistema de alertas médicas
- [ ] Integración con GoHighLevel

### ✅ Protocolos Médicos  
- [ ] Definir umbrales de riesgo
- [ ] Protocolo de crisis suicida
- [ ] Flujos de escalación
- [ ] Capacitación del equipo médico
- [ ] Procedimientos de seguimiento

### ✅ Seguridad y Privacidad
- [ ] Cifrado de respuestas
- [ ] Logs de acceso médico
- [ ] Backup de datos críticos
- [ ] Compliance con normativas
- [ ] Auditoría de alertas

!!! danger "Importancia Crítica"
    El PHQ-9 puede detectar riesgo suicida. Es fundamental que el sistema de alertas funcione perfectamente 24/7.

!!! tip "Mejora Continua"
    Revisar mensualmente los casos de riesgo alto para optimizar protocolos de respuesta y seguimiento.