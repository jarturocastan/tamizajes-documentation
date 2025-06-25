# ASSIST - Prueba de Detección de Consumo de Alcohol, Tabaco y Sustancias

## Información General

**Nombre completo**: Alcohol, Smoking and Substance Involvement Screening Test (ASSIST v3.1)  
**Tipo**: Cuestionario de screening para múltiples sustancias  
**Preguntas**: 8 preguntas principales + sustancias específicas  
**Tiempo estimado**: 10-15 minutos  
**Población**: Adultos y adolescentes (16+ años)

## Propósito y Uso Clínico

### Objetivos
- Detectar uso de riesgo de múltiples sustancias psicoactivas
- Identificar nivel de riesgo para cada sustancia específica
- Determinar tipo de intervención necesaria
- Screening completo de portfolio de sustancias

### Sustancias Evaluadas
1. **Tabaco** (cigarrillos, puros, pipa)
2. **Alcohol** (cerveza, vino, licores)
3. **Cannabis** (marihuana, hachís)
4. **Cocaína** (polvo, crack, pasta básica)
5. **Estimulantes tipo anfetamina** (speed, éxtasis)
6. **Inhalantes** (pegamento, gasolina, solventes)
7. **Sedantes** (pastillas para dormir, tranquilizantes)
8. **Alucinógenos** (LSD, hongos, PCP)
9. **Opiáceos** (heroína, morfina, metadona)
10. **Otras sustancias** (especificar)

## Estructura del Cuestionario

### Pregunta 1: Uso Alguna Vez en la Vida
**"¿Alguna vez en su vida ha consumido...?"**
- **No** = No continuar con esa sustancia
- **Sí** = Continuar con pregunta 2

*Nota especial: Si todas las respuestas son "No", preguntar sobre uso estudiantil*

### Pregunta 2: Frecuencia en Últimos 3 Meses
**"¿Con qué frecuencia ha consumido [sustancia] en los últimos 3 meses?"**

| Frecuencia | Puntuación |
|------------|------------|
| Nunca | 0 |
| 1 ó 2 veces | 2 |
| Mensualmente | 3 |
| Semanalmente | 4 |
| Diario o casi diario | 6 |

*Si respuesta es "Nunca" en todas las sustancias, pasar a pregunta 6*

### Pregunta 3: Deseo o Ansia de Consumo
**"¿Con qué frecuencia ha sentido un fuerte deseo o ansia de consumir [sustancia]?"**

| Frecuencia | Puntuación |
|------------|------------|
| Nunca | 0 |
| 1 ó 2 veces | 3 |
| Mensualmente | 4 |
| Semanalmente | 5 |
| Diario o casi diario | 6 |

### Pregunta 4: Problemas Relacionados
**"¿Con qué frecuencia el consumo le ha causado problemas de salud, sociales, legales o económicos?"**

| Frecuencia | Puntuación |
|------------|------------|
| Nunca | 0 |
| 1 ó 2 veces | 4 |
| Mensualmente | 5 |
| Semanalmente | 6 |
| Diario o casi diario | 7 |

### Pregunta 5: Interferencia con Responsabilidades
**"¿Con qué frecuencia dejó de hacer lo que habitualmente se esperaba por el consumo?"**

| Frecuencia | Puntuación |
|------------|------------|
| Nunca | 0 |
| 1 ó 2 veces | 5 |
| Mensualmente | 6 |
| Semanalmente | 7 |
| Diario o casi diario | 8 |

*Nota: Para tabaco, esta pregunta no se puntúa*

### Pregunta 6: Preocupación de Otros
**"¿Alguien ha mostrado preocupación por sus hábitos de consumo?"**

| Respuesta | Puntuación |
|-----------|------------|
| Nunca | 0 |
| Sí, en los últimos 3 meses | 6 |
| Sí, pero no en los últimos 3 meses | 3 |

### Pregunta 7: Intentos de Reducir/Eliminar
**"¿Ha intentado reducir o eliminar el consumo?"**

| Respuesta | Puntuación |
|-----------|------------|
| Nunca | 0 |
| Sí, en los últimos 3 meses | 6 |
| Sí, pero no en los últimos 3 meses | 3 |

### Pregunta 8: Consumo por Vía Inyectada
**"¿Alguna vez ha consumido alguna droga por vía inyectada?"**
- **Nunca**
- **Sí, en los últimos 3 meses** → Evaluación adicional y tratamiento intensivo
- **Sí, pero no en los últimos 3 meses** → Intervención breve sobre riesgos

## Cálculo de Puntuaciones

### Fórmula por Sustancia
**Puntuación = P2 + P3 + P4 + P5 + P6 + P7**

*Excepción: Para tabaco = P2 + P3 + P4 + P6 + P7 (se omite P5)*

### Interpretación por Sustancia

#### Tabaco
| Puntuación | Nivel de Riesgo | Intervención |
|------------|-----------------|--------------|
| 0-3 | Sin intervención | Consejo breve |
| 4-26 | Intervención breve | Programa cesación |
| 27+ | Tratamiento intensivo | Referencia especializada |

#### Alcohol
| Puntuación | Nivel de Riesgo | Intervención |
|------------|-----------------|--------------|
| 0-10 | Sin intervención | Consejo breve |
| 11-26 | Intervención breve | Sesiones motivacionales |
| 27+ | Tratamiento intensivo | Programa especializado |

#### Otras Sustancias (Cannabis, Cocaína, etc.)
| Puntuación | Nivel de Riesgo | Intervención |
|------------|-----------------|--------------|
| 0-3 | Sin intervención | Consejo breve |
| 4-26 | Intervención breve | Sesiones especializadas |
| 27+ | Tratamiento intensivo | Programa residencial/intensivo |

## Automatización con GoHighLevel

### Configuración de Scoring Automático

```yaml
ASSIST_SCORING:
  trigger: "form_submission"
  conditions:
    form_name: "ASSIST"
  actions:
    - calculate_scores_by_substance:
        tabaco: "P2a + P3a + P4a + P6a + P7a"
        alcohol: "P2b + P3b + P4b + P5b + P6b + P7b"
        cannabis: "P2c + P3c + P4c + P5c + P6c + P7c"
        cocaina: "P2d + P3d + P4d + P5d + P6d + P7d"
        estimulantes: "P2e + P3e + P4e + P5e + P6e + P7e"
        inhalantes: "P2f + P3f + P4f + P5f + P6f + P7f"
        sedantes: "P2g + P3g + P4g + P5g + P6g + P7g"
        alucinogenos: "P2h + P3h + P4h + P5h + P6h + P7h"
        opiaceos: "P2i + P3i + P4i + P5i + P6i + P7i"
        otras: "P2j + P3j + P4j + P5j + P6j + P7j"
    - assign_risk_levels_by_substance
    - check_injection_use: "P8"
```

### Automatización por Nivel de Riesgo

#### Sin Intervención (0-3 para drogas, 0-10 alcohol)
```yaml
SIN_INTERVENCION:
  actions:
    - tag_contact: "ASSIST_Bajo_Riesgo_[SUSTANCIA]"
    - send_whatsapp: "consejo_breve_[SUSTANCIA]"
    - schedule_followup: "+12_months"
    - add_to_campaign: "educacion_preventiva"
```

#### Intervención Breve (4-26 drogas, 11-26 alcohol)
```yaml
INTERVENCION_BREVE:
  actions:
    - tag_contact: "ASSIST_Riesgo_Moderado_[SUSTANCIA]"
    - create_task: "Intervención breve requerida - [SUSTANCIA]"
    - schedule_appointment: "+1_week"
    - assign_specialist: "adicciones_[SUSTANCIA]"
    - send_whatsapp: "programa_reduccion_[SUSTANCIA]"
    - add_to_campaign: "intervencion_motivacional"
```

#### Tratamiento Intensivo (27+)
```yaml
TRATAMIENTO_INTENSIVO:
  actions:
    - tag_contact: "ASSIST_Alto_Riesgo_[SUSTANCIA]"
    - create_urgent_task: "URGENTE: Tratamiento intensivo - [SUSTANCIA]"
    - schedule_emergency_appointment: "+48_hours"
    - assign_psychiatrist: "adicciones"
    - notify_supervisor: true
    - send_whatsapp: "apoyo_intensivo_[SUSTANCIA]"
    - flag_medical_priority: "critica"
```

#### Consumo por Inyección
```yaml
CONSUMO_INYECCION:
  recent_use:
    actions:
      - tag_contact: "ASSIST_Inyeccion_Reciente"
      - create_crisis_task: "CRÍTICO: Consumo por inyección activo"
      - schedule_emergency_appointment: "+24_hours"
      - assign_medical_team: "infectologia"
      - send_whatsapp: "riesgos_inyeccion_urgente"
      - order_laboratory_tests: ["VIH", "Hepatitis_B", "Hepatitis_C"]
  past_use:
    actions:
      - tag_contact: "ASSIST_Inyeccion_Pasada"
      - schedule_appointment: "+1_week"
      - send_whatsapp: "riesgos_inyeccion_educacion"
      - recommend_testing: ["VIH", "Hepatitis"]
```

## Integración con Google Calendar

### Tipos de Citas por Sustancia y Riesgo

#### Consejo Breve (Bajo Riesgo)
```yaml
CONSEJO_BREVE:
  duration: "20_minutes"
  type: "Educación preventiva - [SUSTANCIA]"
  resources: ["folletos_[SUSTANCIA]", "material_educativo"]
  frequency: "anual"
  group_session: "opcional"
```

#### Intervención Breve (Riesgo Moderado)
```yaml
INTERVENCION_BREVE:
  duration: "45_minutes"
  type: "Intervención motivacional - [SUSTANCIA]"
  resources: ["manual_intervencion_[SUSTANCIA]", "autorregistros"]
  frequency: "semanal_x4"
  specialist_required: "psicologo_adicciones"
```

#### Tratamiento Intensivo (Alto Riesgo)
```yaml
TRATAMIENTO_INTENSIVO:
  duration: "60_minutes"
  type: "Programa intensivo - [SUSTANCIA]"
  resources: ["protocolo_especializado", "plan_tratamiento"]
  frequency: "2_veces_semana"
  multidisciplinary: ["psicologo", "psiquiatra", "medico"]
  duration_program: "6_meses"
```

#### Evaluación por Inyección
```yaml
EVALUACION_INYECCION:
  duration: "90_minutes"
  type: "Evaluación médica completa + riesgos inyección"
  resources: ["protocolo_inyeccion", "tests_laboratorio"]
  frequency: "urgente"
  specialists: ["infectologo", "psicologo_adicciones"]
  followup_intensive: true
```

## Bot de WhatsApp - Respuestas por Sustancia

### Mensajes Personalizados por Sustancia

#### Tabaco - Intervención Breve
```
🚬 ASSIST - Tabaco: Intervención Recomendada

Tu evaluación indica riesgo moderado con el tabaco.

📋 Plan personalizado:
• Programa de cesación tabáquica
• Apoyo médico para abstinencia
• Seguimiento semanal x 4 sesiones

💪 ¡Es posible dejar de fumar!
📞 Dudas? Responde "CESACION"
```

#### Cannabis - Tratamiento Intensivo
```
🌿 ASSIST - Cannabis: Atención Especializada Requerida

Tu evaluación indica consumo de alto riesgo.

⚠️ PLAN INMEDIATO:
• Cita urgente en 48h
• Programa intensivo especializado
• Evaluación psicológica completa

🔄 Recuperación es posible
💬 Apoyo 24/7: Responde "CANNABIS"
```

#### Múltiples Sustancias
```
⚠️ ASSIST - Múltiples Sustancias Detectadas

Tu evaluación indica uso de riesgo en:
• [LISTA_SUSTANCIAS_RIESGO]

📋 PLAN INTEGRAL:
• Evaluación multidisciplinaria
• Programa personalizado
• Apoyo especializado

💪 Abordaje integral disponible
📞 Responde "MULTIPLE" para info
```

#### Consumo por Inyección Reciente
```
🚨 ASSIST - ALERTA MÉDICA: Consumo por Inyección

Detectado consumo reciente por vía inyectada.

⚠️ ACCIÓN INMEDIATA:
• Cita médica urgente 24h
• Pruebas VIH/Hepatitis
• Protocolo de reducción de daños

🏥 EMERGENCIA? Responde "911"
💬 APOYO: Responde "INYECCION"
```

### Comandos Especializados

```yaml
COMANDOS_SUSTANCIAS:
  "CESACION": "Conectando con especialista en cesación tabáquica..."
  "CANNABIS": "Activando protocolo de apoyo para cannabis..."
  "MULTIPLE": "Programa integral para múltiples sustancias activado..."
  "INYECCION": "Protocolo de reducción de daños activado. Apoyo inmediato..."
  "REDUCCION": "Enviando estrategias de reducción gradual..."
  "RECAIDA": "Apoyo para prevención de recaídas activado..."
```

## Flujos de Seguimiento Especializado

### Seguimiento por Sustancia

#### Tabaco - Programa Cesación
```yaml
SEGUIMIENTO_TABACO:
  week_1: "¿Cómo va tu primera semana sin fumar?"
  week_2: "Recordatorio: Tienes cita de seguimiento mañana"
  week_4: "¡Un mes sin fumar! ¿Cómo te sientes?"
  month_3: "Seguimiento trimestral - Mantén el logro"
  month_6: "¡6 meses libre de tabaco! Evaluación final"
```

#### Sustancias Ilegales - Programa Intensivo
```yaml
SEGUIMIENTO_INTENSIVO:
  daily: "Recordatorio diario: Tu bienestar es prioridad"
  pre_session: "Cita hoy. ¿Cómo has estado desde la última sesión?"
  post_session: "Gracias por asistir. Próxima cita: [FECHA]"
  emergency: "¿Crisis? Responde CRISIS para apoyo inmediato"
  monthly: "Evaluación mensual de progreso"
```

## Reportes y Métricas Automáticas

### Dashboard ASSIST

```yaml
METRICAS_ASSIST:
  - sustancias_mas_reportadas
  - distribucion_riesgo_por_sustancia
  - casos_multiple_sustancias
  - seguimiento_inyeccion_activa
  - efectividad_programas_cesacion
  - adherencia_tratamiento_intensivo
  - tiempo_abstinencia_promedio
```

### Alertas Clínicas

```yaml
ALERTAS_AUTOMATICAS:
  - nuevos_casos_inyeccion: "Notificación inmediata a equipo médico"
  - multiple_sustancias_alto_riesgo: "Revisión multidisciplinaria"
  - no_adherencia_tratamiento: "Intervención de rescate"
  - escalamiento_riesgo: "Re-evaluación urgente"
```

### Reportes Especializados

#### Reporte Epidemiológico Semanal
- Nuevos casos por sustancia
- Tendencias de consumo por edad/género
- Efectividad de intervenciones por sustancia

#### Reporte de Calidad Mensual
- Casos sin seguimiento apropiado
- Adherencia a protocolos por sustancia
- Outcomes de programas especializados

---
*Última actualización: 2025-06-25*  
*Versión: 1.0 - Configuración inicial multisustancia*