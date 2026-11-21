# Arquitectura inicial

## 1. Objetivo
Definir una base mantenible para una plataforma móvil multiempresa, evitando complejidad prematura y manteniendo el costo operativo bajo control.

## 2. Decisión de arquitectura: modular
El alcance aprobado es **modular**: el primer desarrollo cubrirá los módulos esenciales que se definan para el lanzamiento inicial, pero la arquitectura permitirá incorporar y activar módulos adicionales por negocio.

La decisión implica:
- Los módulos tendrán límites funcionales claros y responsabilidades identificables.
- La activación o disponibilidad de cada módulo se podrá configurar en el contexto de un negocio.
- Un negocio podrá utilizar los módulos habilitados para él, sin que eso altere la disponibilidad de otros negocios.
- La autorización seguirá siendo independiente de la activación: tener un módulo habilitado no concede por sí solo acceso a todas sus funciones.
- Los módulos opcionales no deberán obligar a modificar el núcleo de identidad, negocios, autorización y aislamiento.
- Las dependencias entre módulos deberán declararse y validarse antes de permitir su activación.
- La desactivación de un módulo no deberá borrar automáticamente sus datos históricos. La política de conservación y lectura de esos datos se definirá para cada módulo.

La arquitectura técnica inicial será un **monolito modular**. No se dividirá en microservicios hasta que existan razones medibles de escala, despliegue o independencia operativa.

## 3. Arquitectura propuesta
- Aplicación móvil: React Native + Expo + TypeScript.
- API: Node.js + TypeScript.
- Persistencia: PostgreSQL.
- Archivos: almacenamiento de objetos compatible con S3 cuando sea necesario.

La aplicación móvil consume la API. La API es responsable de autenticación, autorización, reglas de negocio y acceso a datos.

## 4. Organización de módulos
Módulos funcionales previstos en la arquitectura:
1. Identity: autenticación, cuentas y sesiones.
2. Tenancy: negocios, membresías y contexto activo.
3. Access Control: roles, permisos e invitaciones.
4. Catalog: productos, precios y disponibilidad.
5. Customers: clientes y direcciones.
6. Orders: pedidos, artículos, estados e historial.
7. Delivery: invitaciones de repartidores, asignaciones, rutas e incidencias.
8. Payments: pagos, abonos, confirmaciones y reembolsos.
9. Inventory: existencias y movimientos.
10. Promotions: promociones y reglas comerciales.
11. Notifications: avisos por perfil y evento.
12. Reporting: consultas e informes.
13. Audit: registro de operaciones sensibles.

Esta lista representa el mapa de capacidades previsto, no una promesa de que todos los módulos estarán incluidos en la primera entrega.

### 4.1 Núcleo y módulos de negocio
Como criterio de diseño, se distinguen:
- **Núcleo de plataforma:** identidad, negocios/contexto, control de acceso y auditoría transversal.
- **Capacidades comerciales y operativas:** catálogo, clientes, pedidos, entregas y pagos.
- **Capacidades ampliables:** inventario, promociones avanzadas, notificaciones especializadas y reportes.

Esta clasificación es orientativa. La composición exacta del primer lanzamiento y la clasificación definitiva de módulos esenciales u opcionales quedan pendientes de aprobación.

### 4.2 Activación por negocio
La configuración de módulos debe:
- Identificar el negocio al que corresponde.
- Registrar el módulo y su estado de disponibilidad.
- Validar que el negocio esté autorizado para utilizarlo.
- Comprobar dependencias antes de activarlo.
- Aplicar las restricciones también en la API, no solamente ocultar opciones en la interfaz.
- Evitar que una configuración de un negocio afecte a otro.
- Mantener una estrategia segura para datos existentes cuando un módulo se pause o desactive.

La activación de módulos y la autorización de usuarios son controles distintos:
- **Disponibilidad:** determina si el negocio tiene habilitada esa capacidad.
- **Permiso:** determina qué usuario puede ejecutar una acción dentro de esa capacidad.

No se ha definido todavía si la disponibilidad se gestionará mediante planes, contratación, configuración manual u otro mecanismo. Tampoco se han fijado límites comerciales o de facturación.

## 5. Aislamiento multiempresa
- Toda entidad propiedad de un negocio deberá asociarse a un business_id.
- La API obtiene los negocios accesibles desde la identidad y membresías verificadas.
- Nunca se confía en un business_id enviado por el cliente sin comprobar autorización.
- Consultas y operaciones se limitan al negocio autorizado.
- Se evaluarán claves foráneas compuestas y políticas RLS de PostgreSQL como capas adicionales.
- Las pruebas intentarán acceder a registros de otro negocio y verificarán que el acceso sea rechazado.

## 6. Identidad, roles y permisos
Los cuatro perfiles de producto son administrador, empleado, repartidor y cliente. Los tres primeros son relaciones de membresía con un negocio; el cliente opera como usuario autenticado y puede tener una ficha comercial asociada a uno o varios negocios, sin convertirse por ello en miembro.

El modelo de autorización combinará RBAC y permisos específicos:
- **Administrador:** control del negocio al que pertenece.
- **Empleado:** operaciones permitidas por el administrador.
- **Repartidor:** solo sus asignaciones y acciones logísticas permitidas.
- **Cliente:** sus propios datos y pedidos.

La API debe validar en cada solicitud: usuario autenticado, negocio/contexto, membresía o propiedad del recurso, permiso requerido, disponibilidad del módulo y estado de la operación. La interfaz solo refleja permisos ya autorizados.

## 7. Invitaciones
Las invitaciones para empleados y repartidores deben tener negocio, rol propuesto, emisor autorizado, token seguro, vencimiento, estado y aceptación de un solo uso. La API valida la invitación antes de crear la membresía. La revocación de una membresía invalida el acceso posterior.

## 8. Pedidos y entregas
Los pedidos de cliente y empleado usan un único servicio de creación. Se conserva el origen y el actor creador; en el flujo asistido se conserva además la membresía del empleado. El cliente asociado al pedido no se confunde con quien lo registró.

La asignación de un repartidor requiere permiso y una membresía activa con rol de repartidor en el mismo negocio. El repartidor solo puede leer y actualizar las asignaciones propias, dentro de las transiciones permitidas.

## 9. Trazabilidad
Las operaciones relevantes conservan actor, negocio, fecha y hora, tipo de acción, entidad afectada y cambios relevantes, evitando guardar secretos o datos innecesarios. Se auditan invitaciones, permisos, pedidos, pagos y asignaciones.

## 10. Seguridad y operación
- Validación de entradas y autorización en el servidor.
- Contraseñas y sesiones mediante mecanismos seguros.
- Secretos en variables de entorno, nunca en el repositorio.
- HTTPS en producción.
- Copias de seguridad y pruebas periódicas de restauración.
- Registro de errores sin exponer credenciales ni datos personales innecesarios.
- Dependencias actualizadas y revisión de vulnerabilidades.

## 11. Escalabilidad
Redis, colas, réplicas de lectura y separación en servicios se incorporarán solo cuando la carga o los requisitos lo justifiquen.

## 12. Decisiones pendientes
- Módulos esenciales incluidos en la primera entrega y módulos opcionales.
- Dependencias y reglas de activación/desactivación de cada módulo.
- Si la disponibilidad se controlará por plan, contratación o configuración administrativa.
- Proveedor y flujo de autenticación definitivo.
- Estrategia final de aislamiento y RLS.
- Matriz detallada de permisos de empleado.
- Membresías múltiples y cambio de contexto.
- Estados y transiciones de pedido.
- Política de retención y despliegue.
- Requisitos de notificaciones push.
