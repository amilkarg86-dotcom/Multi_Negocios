# Hoja de ruta de Multi_Negocios

La hoja de ruta es incremental. Cada fase debe cerrarse con pruebas y revisión antes de ampliar el alcance.

## Decisión de alcance
**Aprobado: modular.** Se comenzará con los módulos esenciales para operar y se diseñará la arquitectura para habilitar módulos adicionales según las necesidades de cada negocio. La aprobación de este enfoque no significa que todos los módulos previstos deban desarrollarse en la primera entrega.

La siguiente clasificación queda aprobada como punto de partida documental:

**Esenciales para el primer lanzamiento:**
- Identidad y autenticación.
- Registro y administración de negocios.
- Usuarios, roles, permisos e invitaciones.
- Clientes.
- Catálogo y productos.
- Pedidos.
- Entregas y repartidores.
- Registro y consulta de pagos.
- Notificaciones básicas.
- Auditoría y seguridad.

**Ampliables:**
- Inventario avanzado.
- Promociones avanzadas.
- Reportes y estadísticas.
- Cartera y cuentas por cobrar.
- Gestión avanzada de rutas.
- Integraciones externas.

La aprobación de esta clasificación no equivale a una especificación cerrada. Antes de programar deben definirse las funciones, reglas, dependencias y criterios de activación de cada módulo. El catálogo y las promociones sencillas se contemplan dentro de la operación comercial básica; las reglas promocionales avanzadas quedan para una ampliación.

## Fase 0. Definición y preparación
- [x] Crear repositorio y README.
- [x] Documentar visión y alcance.
- [x] Aprobar enfoque modular para el alcance inicial.
- [x] Definir los cuatro perfiles y sus límites generales.
- [x] Documentar la lógica funcional y el esquema de navegación por perfil.
- [x] Aprobar clasificación inicial de módulos esenciales y ampliables.
- [ ] Definir dependencias, reglas detalladas y criterios de activación.
- [ ] Definir quién puede activar o desactivar módulos para un negocio.
- [ ] Cerrar matriz detallada de permisos de empleado.
- [ ] Confirmar estados y transiciones de pedidos.
- [ ] Definir membresías múltiples y cambio de contexto.

## Fase 1. Fundamentos
- [ ] Configurar proyecto móvil y backend.
- [ ] Configurar PostgreSQL y migraciones.
- [ ] Implementar autenticación.
- [ ] Implementar negocios y membresías.
- [ ] Implementar invitaciones seguras.
- [ ] Implementar autorización multiempresa.
- [ ] Implementar control de disponibilidad de módulos por negocio.
- [ ] Crear pruebas de aislamiento entre negocios y perfiles.
- [ ] Crear pruebas de acceso a módulos deshabilitados.

## Fase 2. Operación comercial básica
- [ ] Perfil del negocio y catálogo.
- [ ] Registro y consulta de clientes.
- [ ] Creación de pedidos por clientes.
- [ ] Creación asistida de pedidos por empleados.
- [ ] Historial y detalle del pedido.
- [ ] Direcciones de cliente e instantánea histórica de entrega.

## Fase 3. Entregas y pagos
- [ ] Definir y programar estados y transiciones.
- [ ] Asignar repartidores mediante permisos.
- [ ] Registrar historial de asignaciones y entregas.
- [ ] Registrar métodos y estados de pago.
- [ ] Añadir notificaciones por perfil y evento.

## Fase 4. Módulos ampliables
- [ ] Definir reglas de existencias.
- [ ] Registrar movimientos de inventario.
- [ ] Implementar promociones según las reglas aprobadas.
- [ ] Consultar ventas e historial.
- [ ] Crear reportes operativos con permisos.
- [ ] Validar activación selectiva de estos módulos por negocio.

## Fase 5. Preparación para producción
- [ ] Revisar seguridad y privacidad.
- [ ] Configurar despliegue y dominio.
- [ ] Configurar copias de seguridad y probar restauración.
- [ ] Configurar monitoreo y gestión de errores.
- [ ] Realizar pruebas con usuarios piloto.
- [ ] Preparar publicación móvil.

## Criterio de avance
Una fase no se considerará terminada solo porque exista una pantalla. Deben funcionar las reglas en el backend, los permisos, los errores esperados y las pruebas relevantes.

La activación de un módulo debe verificarse en el servidor. Desactivar una capacidad no debe borrar datos históricos automáticamente ni permitir que queden operaciones parcialmente ejecutadas.
