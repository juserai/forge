# Guia de Usuario de Skill Lint

> Empieza en 3 minutos — valida la calidad de tu skill de Claude Code

---

## Instalacion

### Claude Code (recomendado)

```bash
claude plugin add juserch/jskills
```

### Instalacion universal en una linea

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/skill-lint/SKILL.md
```

> **Cero dependencias** — Skill Lint no requiere servicios externos ni APIs. Instala y listo.

---

## Comandos

| Comando | Que hace | Cuando usarlo |
|---------|----------|---------------|
| `/skill-lint` | Mostrar informacion de uso | Ver verificaciones disponibles |
| `/skill-lint .` | Verificar el proyecto actual | Auto-verificacion durante el desarrollo |
| `/skill-lint /path/to/plugin` | Verificar una ruta especifica | Revisar otro plugin |

---

## Casos de uso

### Auto-verificacion despues de crear un nuevo skill

Despues de crear `skills/<name>/SKILL.md`, `commands/<name>.md` y archivos relacionados, ejecuta `/skill-lint .` para confirmar que la estructura esta completa, el frontmatter es correcto y la entrada en marketplace ha sido agregada.

### Revisar el plugin de otra persona

Al revisar un PR o auditar otro plugin, usa `/skill-lint /path/to/plugin` para una verificacion rapida de completitud de archivos y consistencia.

### Integracion con CI

`scripts/skill-lint.sh` puede ejecutarse directamente en un pipeline de CI, produciendo JSON para analisis automatizado:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Elementos de verificacion

### Verificaciones estructurales (ejecutadas por script Bash)

| Regla | Que verifica | Severidad |
|-------|-------------|-----------|
| S01 | `plugin.json` existe tanto en la raiz como en `.claude-plugin/` | error |
| S02 | `.claude-plugin/marketplace.json` existe | error |
| S03 | Cada `skills/<name>/` contiene un `SKILL.md` | error |
| S04 | El frontmatter de SKILL.md incluye `name` y `description` | error |
| S05 | Cada skill tiene un `commands/<name>.md` correspondiente | warning |
| S06 | Cada skill esta listado en el array `plugins` de marketplace.json | warning |
| S07 | Los archivos de references citados en SKILL.md realmente existen | error |
| S08 | `evals/<name>/scenarios.md` existe | warning |

### Verificaciones semanticas (ejecutadas por IA)

| Regla | Que verifica | Severidad |
|-------|-------------|-----------|
| M01 | La descripcion indica claramente el proposito y las condiciones de activacion | warning |
| M02 | El nombre coincide con el nombre del directorio; la descripcion es consistente entre archivos | warning |
| M03 | La logica de enrutamiento de comandos referencia correctamente el nombre del skill | warning |
| M04 | El contenido de references es logicamente consistente con SKILL.md | warning |
| M05 | Los escenarios de evaluacion cubren las rutas de funcionalidad principal (al menos 5) | warning |

---

## Ejemplos de salida esperada

### Todas las verificaciones pasaron

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────────┘
```

### Problemas encontrados

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## Flujo de trabajo

```
/skill-lint [path]
      │
      ▼
  Run skill-lint.sh ──→ JSON structural check results
      │
      ▼
  AI reads skill files ──→ Semantic checks
      │
      ▼
  Merged output (error > warning > passed)
```

---

## Preguntas frecuentes

### Puedo ejecutar solo las verificaciones estructurales, sin las semanticas?

Si — ejecuta el script bash directamente:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

Esto produce JSON puro sin analisis semantico de IA.

### Funciona en proyectos que no son jskills?

Si. Cualquier directorio que siga la estructura estandar de plugin de Claude Code (`skills/`, `commands/`, `.claude-plugin/`) puede ser validado.

### Cual es la diferencia entre errores y advertencias?

- **error**: Problemas estructurales que impediran que el skill se cargue o publique correctamente
- **warning**: Problemas de calidad que no romperan la funcionalidad pero afectan la mantenibilidad y la descubribilidad

### Otras herramientas de jskills

Skill Lint es parte de la coleccion jskills y funciona bien junto a estos skills:

- [Block Break](block-break-guide.md) — Motor de restricciones de comportamiento de alta agencia que obliga a la IA a agotar cada enfoque
- [Ralph Boost](ralph-boost-guide.md) — Motor de bucle de desarrollo autonomo con garantias de convergencia Block Break integradas

Despues de desarrollar un nuevo skill, ejecuta `/skill-lint .` para verificar la completitud estructural y confirmar que el frontmatter, marketplace.json y los enlaces de referencia son correctos.

---

## Licencia

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
