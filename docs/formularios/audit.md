# AUDIT - Test de Identificación de Trastornos por Consumo de Alcohol

## Información General

**Nombre completo**: Test de Identificación de Trastornos por consumo de alcohol (AUDIT)  
**Tipo**: Cuestionario de screening para alcohol  
**Preguntas**: 10 items  
**Tiempo estimado**: 5-10 minutos  
**Población**: Adultos y adolescentes (16+ años)

## Propósito y Uso Clínico

### Objetivos
- Detectar consumo de riesgo, uso perjudicial y dependencia del alcohol
- Identificar personas en riesgo antes de que desarrollen problemas severos
- Proporcionar puntuación cuantitativa del nivel de riesgo

### Indicaciones
- Evaluación inicial en todos los pacientes
- Seguimiento de pacientes con antecedentes de consumo
- Screening en servicios de salud mental y adicciones

## Estructura del Cuestionario

### Pregunta 1: Frecuencia de Consumo
- **Nunca** (0 puntos) → Pasar a preguntas 9-10
- **Una o menos veces al mes** (1 punto)
- **De 2 a 4 veces al mes** (2 puntos) 
- **De 2 a 3 veces a la semana** (3 puntos)
- **4 o más veces a la semana** (4 puntos)

### Pregunta 2: Cantidad de Consumo
- **1 o 2 bebidas** (0 puntos)
- **3 o 4 bebidas** (1 punto)
- **5 o 6 bebidas** (2 puntos)
- **7, 8, o 9 bebidas** (3 puntos)
- **10 o más bebidas** (4 puntos)

### Pregunta 3: Consumo Intensivo
- **Nunca** (0 puntos)
- **Menos de una vez al mes** (1 punto)
- **Mensualmente** (2 puntos)
- **Semanalmente** (3 puntos)
- **A diario o casi a diario** (4 puntos)

*Nota: Si suma de P2 + P3 = 0, pasar a preguntas 9 y 10*

### Preguntas 4-8: Problemas Relacionados con el Alcohol
Cada pregunta con opciones:
- **Nunca** (0 puntos)
- **Menos de una vez al mes** (1 punto)
- **Mensualmente** (2 puntos)
- **Semanalmente** (3 puntos)
- **A diario o casi a diario** (4 puntos)

**Pregunta 4**: Incapacidad para parar de beber  
**Pregunta 5**: No cumplir expectativas por el alcohol  
**Pregunta 6**: Necesidad de beber en ayunas  
**Pregunta 7**: Sentimientos de culpa o remordimientos  
**Pregunta 8**: Lagunas de memoria por el alcohol

### Preguntas 9-10: Consecuencias y Preocupación Social
**Pregunta 9**: Lesiones relacionadas con alcohol
- **No** (0 puntos)
- **Sí, pero no en el último año** (2 puntos)
- **Sí, en el último año** (4 puntos)

**Pregunta 10**: Preocupación de otros por el consumo
- **No** (0 puntos)
- **Sí, pero no en el último año** (2 puntos)
- **Sí, en el último año** (4 puntos)

## Interpretación de Resultados

### Puntuación Total (0-40 puntos)

| Puntuación | Nivel de Riesgo | Intervención Recomendada |
|------------|-----------------|-------------------------|
| **0-7** | Consumo de bajo riesgo | Educación sobre alcohol |
| **8-15** | Consumo de riesgo | Intervención breve |
| **16-19** | Consumo perjudicial | Intervención breve intensiva + seguimiento |
| **20-40** | Probable dependencia | Evaluación diagnóstica + tratamiento especializado |

## Automatización con GoHighLevel

### Configuración de Scoring Automático

```yaml
AUDIT_SCORING:
  trigger: "form_submission"
  conditions:
    form_name: "AUDIT"
  actions:
    - calculate_score: "sum(Q1 + Q2 + Q3 + Q4 + Q5 + Q6 + Q7 + Q8 + Q9 + Q10)"
    - assign_risk_level:
        0-7: "bajo_riesgo"
        8-15: "riesgo_moderado" 
        16-19: "riesgo_alto"
        20-40: "probable_dependencia"
```

### Automatización de Alertas

#### Alertas de Riesgo Bajo (0-7 puntos)
```yaml
BAJO_RIESGO:
  actions:
    - tag_contact: "AUDIT_Bajo_Riesgo"
    - send_whatsapp: "educacion_alcohol"
    - schedule_followup: "+6_months"
    - assign_psychologist: "general"
```

#### Alertas de Riesgo Moderado (8-15 puntos)
```yaml
RIESGO_MODERADO:
  actions:
    - tag_contact: "AUDIT_Riesgo_Moderado"
    - create_urgent_task: "Intervención breve requerida"
    - schedule_appointment: "+7_days"
    - assign_specialist: "adicciones"
    - send_whatsapp: "intervencion_breve"
```

#### Alertas de Riesgo Alto (16-19 puntos)
```yaml
RIESGO_ALTO:
  actions:
    - tag_contact: "AUDIT_Riesgo_Alto"
    - create_urgent_task: "URGENTE: Intervención intensiva"
    - schedule_appointment: "+3_days"
    - assign_specialist: "psicologo_adicciones"
    - notify_supervisor: true
    - send_whatsapp: "seguimiento_intensivo"
```

#### Probable Dependencia (20-40 puntos)
```yaml
PROBABLE_DEPENDENCIA:
  actions:
    - tag_contact: "AUDIT_Probable_Dependencia"
    - create_crisis_task: "CRÍTICO: Evaluación especializada inmediata"
    - schedule_emergency_appointment: "+24_hours"
    - assign_psychiatrist: "adicciones"
    - notify_medical_team: true
    - send_whatsapp: "apoyo_crisis"
    - flag_medical_priority: "alta"
```

## Integración con Google Calendar

### Tipos de Citas por Puntuación

#### Citas de Seguimiento (0-7 puntos)
```yaml
CITA_SEGUIMIENTO:
  duration: "30_minutes"
  type: "Educación preventiva"
  resources: ["folletos_educativos", "material_audiovisual"]
  frequency: "semestral"
```

#### Intervención Breve (8-15 puntos)
```yaml
INTERVENCION_BREVE:
  duration: "45_minutes"
  type: "Intervención motivacional"
  resources: ["manual_intervencion", "ejercicios_motivacionales"]
  frequency: "mensual"
  followup_required: true
```

#### Intervención Intensiva (16-19 puntos)
```yaml
INTERVENCION_INTENSIVA:
  duration: "60_minutes"
  type: "Terapia cognitivo-conductual"
  resources: ["protocolo_TCC", "autorregistros", "plan_tratamiento"]
  frequency: "semanal"
  multidisciplinary: true
```

#### Evaluación Especializada (20-40 puntos)
```yaml
EVALUACION_ESPECIALIZADA:
  duration: "90_minutes"
  type: "Evaluación psiquiátrica completa"
  resources: ["protocolo_diagnostico", "escalas_adicionales", "historia_clinica"]
  frequency: "urgente"
  medical_clearance: required
```

## Bot de WhatsApp - Respuestas Automáticas

### Mensajes por Nivel de Riesgo

#### Bajo Riesgo (0-7)
```
🟢 AUDIT - Resultado: Bajo Riesgo

Tu evaluación indica un consumo de bajo riesgo de alcohol.

📋 Próximos pasos:
• Mantén patrones de consumo responsable
• Recibirás información educativa
• Seguimiento en 6 meses

📞 ¿Preguntas? Responde con "CONSULTA"
```

#### Riesgo Moderado (8-15)
```
🟡 AUDIT - Resultado: Riesgo Moderado

Tu evaluación sugiere la necesidad de una intervención breve.

📋 Próximos pasos:
• Cita programada en 7 días
• Intervención motivacional breve
• Plan de reducción gradual

📞 Urgente? Responde "URGENTE"
📋 Info? Responde "INTERVENCION"
```

#### Riesgo Alto (16-19)
```
🟠 AUDIT - Resultado: Riesgo Alto

Tu evaluación indica la necesidad de intervención intensiva.

⚠️ IMPORTANTE:
• Cita programada en 3 días
• Especialista en adicciones asignado
• Seguimiento semanal requerido

🆘 Crisis? Responde "CRISIS"
📞 Preguntas? Responde "APOYO"
```

#### Probable Dependencia (20-40)
```
🔴 AUDIT - Resultado: Evaluación Urgente Requerida

Tu evaluación indica la necesidad de atención especializada inmediata.

🚨 ACCIÓN INMEDIATA:
• Cita de emergencia en 24 horas
• Evaluación psiquiátrica completa
• Equipo médico notificado

🆘 EMERGENCIA: Responde "911"
💬 APOYO INMEDIATO: Responde "CRISIS"

Recuerda: No estás solo en este proceso.
```

### Comandos de Respuesta Automática

```yaml
COMANDOS_WHATSAPP:
  "CONSULTA": "Te conectaré con un especialista para resolver tus dudas"
  "URGENTE": "Activando protocolo de urgencia. Te contactaremos en 30 minutos"
  "INTERVENCION": "Enviando información sobre intervención breve..."
  "CRISIS": "Activando apoyo inmediato. Psicólogo disponible en 15 minutos"
  "APOYO": "Conectándote con línea de apoyo 24/7"
  "911": "Contactando servicios de emergencia y equipo de crisis"
```

## Flujos de Seguimiento Automatizado

### Recordatorios WhatsApp

#### Pre-cita (24h antes)
```
📅 Recordatorio: Tienes cita mañana a las [HORA]

📍 Ubicación: [DIRECCION_UNEME]
👨‍⚕️ Con: [NOMBRE_ESPECIALISTA]
📋 Motivo: Seguimiento AUDIT - [NIVEL_RIESGO]

💡 Trae tu credencial y llega 15 min antes
❓ ¿Necesitas reagendar? Responde "REAGENDAR"
```

#### Post-cita (2h después)
```
✅ Gracias por asistir a tu cita

📋 Resumen enviado a tu expediente
📱 Próxima cita: [FECHA_PROXIMA]
📚 Material de apoyo: [LINK_RECURSOS]

⭐ ¿Cómo calificarías tu atención? (1-5)
💬 ¿Comentarios? Responde "FEEDBACK"
```

## Métricas y Reporting Automático

### Dashboard de Monitoreo

```yaml
METRICAS_AUDIT:
  - total_aplicaciones_mes
  - distribucion_niveles_riesgo
  - tiempo_promedio_respuesta_urgencias
  - adherencia_citas_por_nivel
  - efectividad_intervenciones
  - casos_escalados_a_emergencia
```

### Reportes Automatizados

#### Reporte Semanal
- Nuevos casos de riesgo alto/dependencia
- Adherencia a citas por nivel de riesgo
- Efectividad de intervenciones breves

#### Alertas de Calidad
- Casos sin seguimiento > 30 días
- Pacientes que faltaron a citas críticas
- Puntuaciones AUDIT en aumento

---
*Última actualización: 2025-06-25*  
*Versión: 1.0 - Configuración inicial de automatización*