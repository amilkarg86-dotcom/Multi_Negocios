# Hoja de ruta de Multi_Negocios

La hoja de ruta es incremental. Cada fase debe cerrarse con pruebas y revisión antes de ampliar el alcance.

## Fase 0. Definición y preparación
- [x] Crear repositorio y README.
- [x] Documentar visión y alcance.
- [x] Definir los cuatro perfiles y sus límites generales.
- [x] Documentar la lógica funcional y el esquema de navegación por perfil.
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
- [ ] Crear pruebas de aislamiento entre negocios y perfiles.

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

## Fase 4. Inventario y reportes
- [ ] Definir reglas de existencias.
- [ ] Registrar movimientos de inventario.
- [ ] Consultar ventas e historial.
- [ ] Crear reportes operativos con permisos.

## Fase 5. Preparación para producción
- [ ] Revisar seguridad y privacidad.
- [ ] Configurar despliegue y dominio.
- [ ] Configurar copias de seguridad y probar restauración.
- [ ] Configurar monitoreo y gestión de errores.
- [ ] Realizar pruebas con usuarios piloto.
- [ ] Preparar publicación móvil.

## Criterio de avance
Una fase no se considerará terminada solo porque exista una pantalla. Deben funcionar las reglas en el backend, los permisos, los errores esperados y las pruebas relevantes.
