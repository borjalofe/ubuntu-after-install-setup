# Ubuntu After-Install Setup Script

> **Este repositorio está descontinuado.** No lo uses para instalaciones nuevas.  
> El trabajo continúa en **[ventoy-unattended-install](https://github.com/borjalofe/ventoy-unattended-install)** (instalación desatendida con Ventoy y perfiles por rol).

## Problema (histórico)

Cada portátil Ubuntu nuevo significaba las mismas búsquedas: Chrome, VS Code, NVM, flatpaks, flags de developer vs sysadmin. Un script bash monolítico (`after-install.sh`) intentaba cerrar ese ciclo en un solo sitio.

## Quién lo usaba

Yo (desktop personal). Amigos / lectores podían copiarlo; nunca fue un producto de sysadmin de flota.

## Alcance

**Entonces:** post-install de Ubuntu Desktop con flags (`developer`, `javascript`, stacks web, LEMP/WordPress, media, sysadmin, etc.).

**Ahora:** solo archivo. El diseño se replantea en Ventoy (perfiles `front` / `back` / `infra` / …, varias familias de SO). **No se copian archivos** de aquí al sucesor.

## Sucesor

| | |
|---|---|
| **Proyecto actual** | [borjalofe/ventoy-unattended-install](https://github.com/borjalofe/ventoy-unattended-install) |
| **Enfoque** | Artefactos de instalación desatendida en USB Ventoy; perfiles por rol; varias familias de SO |
| **Relación** | Referencia histórica únicamente |

## Cómo se ejecutaba (no recomendado)

Entrada: `after-install.sh`. Cualquier one-liner con URL `/blob/` de GitHub era incorrecto (sirve HTML, no el script). El camino sano hubiera sido:

```bash
git clone https://github.com/borjalofe/ubuntu-after-install-setup.git
cd ubuntu-after-install-setup
./after-install.sh --help
```

No lo uses en máquinas nuevas: flags y paquetes están desalineados con Ubuntu actual.

## Decisiones técnicas

**¿Por qué bash monolítico y no Ansible / Nix?**

Velocidad personal en un solo desktop: un fichero, SSH, listo. Ansible hubiera sido correcto para flota; para un portátil era overhead. Nix no estaba en el radar cuando nació el script.

## Trade-offs y limitaciones

- `--yes` / quiet vs prompts: cómodo en máquina limpia, peligroso en una ya usada.
- TODO eterno (Docker, Slack, Drive…) y software que ya no uso (Skype, Steam) hinchaban el script.
- Help vs `case` del script divergían: el README no puede mentir sobre flags que el código no cumple.

## Evidencia de calidad

No hay CI ni dry-run fiable. El "check" honesto es: **no ejecutarlo** y mirar el sucesor Ventoy.

## Lecciones aprendidas

Un after-install que crece a golpe de flag acaba siendo un museo de decisiones de 2019–2023. Mejor artefactos de instalación desatendida versionados por perfil (Ventoy) que un bash que intenta ser distro-agnostic a mano.

## Próximos pasos

1. Archivar el repo en GitHub (Settings → Archive) si aún no lo está.
2. Descripción del repo: `Deprecated — use ventoy-unattended-install`.
3. Toda la planificación nueva vive en el sucesor; `docs/ventoy-relaunch-plan.md` aquí es borrador obsoleto.

## Contacto

[@borjalofe](https://github.com/borjalofe)
