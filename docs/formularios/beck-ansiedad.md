# Inventario de Ansiedad de Beck (BAI)

## Información General

**Nombre completo**: Inventario de Ansiedad de Beck (Beck Anxiety Inventory)  
**Autores**: Beck, Epstein, Brown & Steer (1988)  
**Estandarización**: Población mexicana (Robles, Varela, Jurado y Páez, 2001)  
**Tipo**: Cuestionario de evaluación de síntomas de ansiedad  
**Preguntas**: 21 reactivos  
**Tiempo estimado**: 5-10 minutos  
**Población**: Adolescentes y adultos

## Propósito y Uso Clínico

### Objetivos
- **Evaluar intensidad de síntomas de ansiedad** en la última semana
- **Detectar trastornos de ansiedad** mediante puntuación cuantitativa
- **Monitorear progreso** en tratamiento (pre/post/seguimientos)
- **Clasificar severidad** para determinar tipo de intervención

### Indicaciones
- Screening inicial para todos los pacientes
- Evaluación de efectividad de tratamiento
- Seguimientos periódicos en terapia
- Comorbilidad con depresión o adicciones

## Estructura del Cuestionario

### Instrucciones
*"Indica cuánto te ha molestado cada síntoma durante la última semana, inclusive el día de hoy, marcando según la intensidad de la molestia"*

### Escala de Respuesta
- **0 - Poco o nada** 
- **1 - Más o menos**
- **2 - Moderadamente** 
- **3 - Severamente**

### Lista de Síntomas (21 items)

#### Síntomas Físicos
1. Entumecimiento, hormigueo
2. Sensación de oleadas de calor (bochorno)
3. Debilitamiento de las piernas
4. Sensación de mareo
5. Opresión en el pecho o latidos acelerados
6. Sensación de ahogo
7. Manos temblorosas
8. Cuerpo tembloroso
9. Dificultad para respirar
10. Indigestión o malestar estomacal
11. Debilidad
12. Ruborizarse
13. Sudoración (no debida al calor)

#### Síntomas Cognitivos y Emocionales
14. Dificultad para relajarse
15. Miedo a que pase lo peor
16. Inseguridad
17. Terror
18. Nerviosismo
19. Miedo a perder el control
20. Miedo a morir
21. Asustado

## Interpretación de Resultados

### Puntuación Total (0-63 puntos)

| Puntuación | Nivel de Ansiedad | Intervención Recomendada |
|------------|-------------------|--------------------------|
| **0-5** | Ansiedad Mínima | Seguimiento rutinario |
| **6-15** | Ansiedad Leve | Técnicas de relajación + psicoeducación |
| **16-30** | Ansiedad Moderada | Terapia cognitivo-conductual |
| **31-63** | Ansiedad Severa | Evaluación psiquiátrica + tratamiento intensivo |

### Propiedades Psicométricas (Población Mexicana)
- **Confiabilidad**: Alpha de Cronbach = .83
- **Test-retest**: r = .75
- **Validez convergente**: Correlación con IDARE (p<.05)
- **Validez discriminante**: Diferenciación entre pacientes y controles (t = -19.11, p<.05)

## Automatización con GoHighLevel

### Configuración de Scoring Automático

```yaml
BAI_SCORING:
  trigger: "form_submission"
  conditions:
    form_name: "Beck_Ansiedad"
  actions:
    - calculate_total: "sum(Q1 + Q2 + ... + Q21)"
    - assign_anxiety_level:
        0-5: "minima"
        6-15: "leve" 
        16-30: "moderada"
        31-63: "severa"
    - calculate_subscales:
        neurofisiologico: "Q1 + Q3 + Q6 + Q12 + Q13 + Q15 + Q18 + Q19 + Q21"
        subjetivo: "Q4 + Q8 + Q10 + Q16 + Q17"
        autonomico: "Q2 + Q7 + Q11 + Q14 + Q20"
        panico: "Q5 + Q9"
```

### Automatización por Nivel de Ansiedad

#### Ansiedad Mínima (0-5 puntos)
```yaml
ANSIEDAD_MINIMA:
  actions:
    - tag_contact: "BAI_Ansiedad_Minima"
    - send_whatsapp: "resultados_normales_ansiedad"
    - schedule_followup: "+6_months"
    - add_to_campaign: "mantenimiento_bienestar"
```

#### Ansiedad Leve (6-15 puntos)
```yaml
ANSIEDAD_LEVE:
  actions:
    - tag_contact: "BAI_Ansiedad_Leve"
    - create_task: "Intervención psicoeducativa - ansiedad leve"
    - schedule_appointment: "+2_weeks"
    - assign_psychologist: "terapia_breve"
    - send_whatsapp: "tecnicas_relajacion"
    - add_to_campaign: "psicoeducacion_ansiedad"
```

#### Ansiedad Moderada (16-30 puntos)
```yaml
ANSIEDAD_MODERADA:
  actions:
    - tag_contact: "BAI_Ansiedad_Moderada"
    - create_urgent_task: "TCC para ansiedad moderada"
    - schedule_appointment: "+1_week"
    - assign_specialist: "psicologo_ansiedad"
    - send_whatsapp: "programa_ansiedad_moderada"
    - add_to_campaign: "terapia_cognitivo_conductual"
    - schedule_reevaluation: "+1_month"
```

#### Ansiedad Severa (31-63 puntos)
```yaml
ANSIEDAD_SEVERA:
  actions:
    - tag_contact: "BAI_Ansiedad_Severa"
    - create_crisis_task: "URGENTE: Evaluación psiquiátrica - ansiedad severa"
    - schedule_emergency_appointment: "+48_hours"
    - assign_psychiatrist: "ansiedad"
    - notify_supervisor: true
    - send_whatsapp: "apoyo_ansiedad_severa"
    - flag_medical_priority: "alta"
    - schedule_weekly_monitoring: true
```

### Alertas por Síntomas Específicos

```yaml
SPECIFIC_SYMPTOMS_ALERTS:
  panic_symptoms:
    conditions: "Q16 >= 2 OR Q9 >= 2" # Miedo a morir o Terror
    action: "ALERTA: Síntomas de pánico detectados"
    
  physical_symptoms_high:
    conditions: "Q7 + Q13 + Q15 >= 6" # Latidos + sudoración + respiración
    action: "ALERTA: Síntomas físicos severos"
    
  cognitive_symptoms_high:
    conditions: "Q14 + Q16 >= 4" # Pérdida control + miedo a morir
    action: "ALERTA: Síntomas cognitivos severos"
```

## Integración con Google Calendar

### Tipos de Citas por Nivel

#### Seguimiento Rutinario (0-5 puntos)
```yaml
SEGUIMIENTO_RUTINARIO:
  duration: "30_minutes"
  type: "Seguimiento bienestar - BAI normal"
  frequency: "semestral"
  resources: ["folletos_bienestar", "tecnicas_prevencion"]
```

#### Intervención Psicoeducativa (6-15 puntos)
```yaml
INTERVENCION_PSICOEDUCATIVA:
  duration: "45_minutes"
  type: "Psicoeducación ansiedad leve"
  frequency: "quincenal_x4"
  resources: ["manual_relajacion", "ejercicios_respiracion", "audio_meditacion"]
  specialist: "psicologo_general"
```

#### Terapia Cognitivo-Conductual (16-30 puntos)
```yaml
TCC_ANSIEDAD:
  duration: "60_minutes"
  type: "Terapia cognitivo-conductual - ansiedad"
  frequency: "semanal_x12"
  resources: ["protocolo_TCC_ansiedad", "autorregistros", "ejercicios_exposicion"]
  specialist: "psicologo_especialista_ansiedad"
  include_homework: true
```

#### Evaluación Psiquiátrica (31-63 puntos)
```yaml
EVALUACION_PSIQUIATRICA:
  duration: "90_minutes"
  type: "Evaluación psiquiátrica - ansiedad severa"
  frequency: "urgente"
  resources: ["protocolo_evaluacion", "escalas_adicionales", "opciones_farmacologicas"]
  required_staff: ["psiquiatra", "psicologo"]
  followup_intensive: "semanal"
```

## Bot de WhatsApp - Respuestas por Nivel

### Ansiedad Mínima (0-5)
```
🟢 BAI - Resultados: Ansiedad Mínima

Tus niveles de ansiedad están en rango normal.

📋 RECOMENDACIONES:
• Mantén técnicas de bienestar
• Ejercicio regular y relajación
• Seguimiento en 6 meses

💡 Técnicas preventivas disponibles
📞 Dudas? Responde "BIENESTAR"
```

### Ansiedad Leve (6-15)
```
🟡 BAI - Resultados: Ansiedad Leve

Detectados síntomas leves de ansiedad manejables.

📋 PLAN DE ACCIÓN:
• Cita programada en 2 semanas
• Técnicas de relajación personalizadas
• Programa psicoeducativo

🧘‍♀️ Técnicas inmediatas: Responde "RELAJACION"
📚 Información: Responde "ANSIEDAD"
```

### Ansiedad Moderada (16-30)
```
🟠 BAI - Resultados: Ansiedad Moderada

Tu nivel de ansiedad requiere intervención profesional.

📋 PLAN TERAPÉUTICO:
• Cita programada en 1 semana
• Terapia cognitivo-conductual
• Especialista en ansiedad asignado

⚡ Técnicas de crisis: Responde "CRISIS"
🔄 Programa TCC: Responde "TERAPIA"
```

### Ansiedad Severa (31-63)
```
🔴 BAI - Resultados: Ansiedad Severa

IMPORTANTE: Nivel severo requiere atención especializada.

⚠️ ACCIÓN INMEDIATA:
• Evaluación psiquiátrica en 48h
• Equipo especializado asignado
• Monitoreo semanal intensivo

🆘 CRISIS? Responde "911"
💬 APOYO INMEDIATO: Responde "ANSIEDAD"

Recuerda: La ansiedad es tratable.
```

### Comandos Especializados

```yaml
COMANDOS_ANSIEDAD:
  "BIENESTAR": "Enviando técnicas de mantenimiento del bienestar..."
  "RELAJACION": "Activando sesión de relajación guiada..."
  "ANSIEDAD": "Conectando con especialista en ansiedad..."
  "TERAPIA": "Información sobre terapia cognitivo-conductual enviada..."
  "CRISIS": "Protocolo de manejo de crisis de ansiedad activado..."
  "RESPIRACION": "Ejercicio de respiración 4-7-8 activado..."
```

## Seguimiento Automatizado

### Por Nivel de Ansiedad

#### Ansiedad Leve - Seguimiento Quincenal
```yaml
SEGUIMIENTO_LEVE:
  week_2: "¿Cómo han funcionado las técnicas de relajación?"
  week_4: "Recordatorio: Cita de seguimiento mañana"
  month_2: "Evaluación de progreso - técnicas preventivas"
  month_6: "Re-evaluación BAI programada"
```

#### Ansiedad Moderada/Severa - Seguimiento Semanal
```yaml
SEGUIMIENTO_INTENSIVO:
  week_1: "¿Cómo te has sentido desde la última sesión?"
  pre_session: "Recordatorio: Cita de TCC hoy a las [HORA]"
  post_session: "¿Cómo te sentiste en la sesión? Próxima: [FECHA]"
  between_sessions: "Recordatorio: Practicar ejercicios de respiración"
```

## Reportes y Métricas

### Dashboard BAI

```yaml
METRICAS_BAI:
  - distribucion_niveles_ansiedad
  - reduccion_puntuacion_pre_post
  - adherencia_tratamiento_por_nivel
  - tiempo_mejoria_promedio
  - sintomas_mas_reportados
  - efectividad_TCC_vs_medicacion
```

### Alertas de Calidad

```yaml
ALERTAS_BAI:
  - aumento_puntuacion_seguimiento: "Revisar progreso terapéutico"
  - sintomas_panico_nuevos: "Evaluación urgente requerida"
  - no_mejoria_6_semanas: "Ajustar plan de tratamiento"
  - abandono_tratamiento_moderado_severo: "Intervención de rescate"
```

---
*Última actualización: 2025-06-25*  
*Versión: 1.0 - Configuración de automatización completa*