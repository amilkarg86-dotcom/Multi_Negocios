# Arquitectura inicial

## 1. Objetivo
Definir una base mantenible para una plataforma móvil multiempresa, evitando complejidad prematura y manteniendo el costo operativo bajo control.

## 2. Arquitectura propuesta
Iniciar con un **monolito modular**:
- Aplicación móvil: React Native + Expo + TypeScript.
- API: Node.js + TypeScript.
- Persistencia: PostgreSQL.
- Archivos: almacenamiento de objetos compatible con S3 cuando sea necesario.

La aplicación móvil consume la API. La API es responsable de autenticación, autorización, reglas de negocio y acceso a datos.

## 3. Módulos del backend
1. Identity: autenticación, cuentas y sesiones.
2. Tenancy: negocios, membresías y contexto activo.
3. Access Control: roles, permisos e invitaciones.
4. Catalog: productos, precios y disponibilidad.
5. Customers: clientes y direcciones.
6. Orders: pedidos, artículos, estados e historial.
7. Delivery: invitaciones de repartidores, asignaciones, rutas e incidencias.
8. Payments: pagos, abonos, confirmaciones y reembolsos.
9. Inventory: existencias y movimientos.
10. Notifications: avisos por perfil y evento.
11. Reporting: consultas e informes.
12. Audit: registro de operaciones sensibles.

## 4. Aislamiento multiempresa
- Toda entidad propiedad de un negocio deberá asociarse a un business_id.
- La API obtiene los negocios accesibles desde la identidad y membresías verificadas.
- Nunca se confía en un business_id enviado por el cliente sin comprobar autorización.
- Consultas y operaciones se limitan al negocio autorizado.
- Se evaluarán claves foráneas compuestas y políticas RLS de PostgreSQL como capas adicionales.
- Las pruebas intentarán acceder a registros de otro negocio y verificarán que el acceso sea rechazado.

## 5. Identidad, roles y permisos
Los cuatro perfiles de producto son administrador, empleado, repartidor y cliente. Los tres primeros son relaciones de membresía con un negocio; el cliente opera como usuario autenticado y puede tener una ficha comercial asociada a uno o varios negocios, sin convertirse por ello en miembro.

El modelo de autorización combinará RBAC y permisos específicos:
- **Administrador:** control del negocio al que pertenece.
- **Empleado:** operaciones permitidas por el administrador.
- **Repartidor:** solo sus asignaciones y acciones logísticas permitidas.
- **Cliente:** sus propios datos y pedidos.

La API debe validar en cada solicitud: usuario autenticado, negocio/contexto, membresía o propiedad del recurso, permiso requerido y estado de la operación. La interfaz solo refleja permisos ya autorizados.

## 6. Invitaciones
Las invitaciones para empleados y repartidores deben tener negocio, rol propuesto, emisor autorizado, token seguro, vencimiento, estado y aceptación de un solo uso. La API valida la invitación antes de crear la membresía. La revocación de una membresía invalida el acceso posterior.

## 7. Pedidos y entregas
Los pedidos de cliente y empleado usan un único servicio de creación. Se conserva el origen y el actor creador; en el flujo asistido se conserva además la membresía del empleado. El cliente asociado al pedido no se confunde con quien lo registró.

La asignación de un repartidor requiere permiso y una membresía activa con rol de repartidor en el mismo negocio. El repartidor solo puede leer y actualizar las asignaciones propias, dentro de las transiciones permitidas.

## 8. Trazabilidad
Las operaciones relevantes conservan actor, negocio, fecha y hora, tipo de acción, entidad afectada y cambios relevantes, evitando guardar secretos o datos innecesarios. Se auditan invitaciones, permisos, pedidos, pagos y asignaciones.

## 9. Seguridad y operación
- Validación de entradas y autorización en el servidor.
- Contraseñas y sesiones mediante mecanismos seguros.
- Secretos en variables de entorno, nunca en el repositorio.
- HTTPS en producción.
- Copias de seguridad y pruebas periódicas de restauración.
- Registro de errores sin exponer credenciales ni datos personales innecesarios.
- Dependencias actualizadas y revisión de vulnerabilidades.

## 10. Escalabilidad
Redis, colas, réplicas de lectura y separación en servicios se incorporarán solo cuando la carga o los requisitos lo justifiquen.

## 11. Decisiones pendientes
- Proveedor y flujo de autenticación definitivo.
- Estrategia final de aislamiento y RLS.
- Matriz detallada de permisos de empleado.
- Membresías múltiples y cambio de contexto.
- Estados y transiciones de pedido.
- Política de retención y despliegue.
- Requisitos de notificaciones push.
