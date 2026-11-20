# Plan de Multi_Negocios

## 1. Visión
Multi_Negocios será una plataforma de gestión comercial y logística para negocios independientes, disponible para Android y iOS. Permitirá administrar clientes, catálogo, pedidos, entregas, pagos, inventario y reportes, con espacios de trabajo separados por negocio.

## 2. Principios
- Multiempresa con aislamiento estricto de datos.
- Cuatro experiencias independientes: administrador, empleado, repartidor y cliente.
- Acceso por rol y permisos específicos.
- Empleados y repartidores se vinculan al negocio mediante invitación autorizada.
- Los pedidos de clientes y los registrados por empleados convergen en un único flujo.
- Trazabilidad de acciones y operaciones.
- Desarrollo gradual, priorizando un MVP funcional y de bajo costo.

## 3. Perfiles y límites

### Administrador
Administra la operación completa de su negocio: pedidos, clientes, catálogo, inventario, pagos, reportes, miembros, invitaciones, asignaciones y configuración. No accede a datos de otros negocios.

### Empleado
Registra pedidos en nombre de clientes y realiza tareas operativas habilitadas por permisos. No administra miembros, roles, invitaciones ni configuración general, salvo facultades específicas expresamente autorizadas. Cada pedido asistido conserva al empleado como creador y al cliente como destinatario.

### Repartidor
Se incorpora mediante invitación aceptada y validada. Solo consulta entregas asignadas y actualiza los eventos logísticos permitidos. No registra pedidos, se autoasigna entregas, modifica productos o importes ni consulta ventas, cartera, inventario o pedidos ajenos.

### Cliente
Descubre negocios, consulta catálogos, registra sus propios pedidos, realiza pagos disponibles y consulta sus direcciones, notificaciones e historial. Solo accede a sus propios datos y pedidos. No accede a funciones internas del negocio.

## 4. Registro de pedidos
Un pedido puede registrarse por dos vías:
1. **Cliente:** crea su propio pedido desde la aplicación.
2. **Empleado:** registra el pedido en nombre del cliente por atención presencial, llamada o mensajería.

Ambas vías utilizan las mismas validaciones y reglas comerciales. Se conservan negocio, cliente, origen, usuario creador, miembro empleado cuando aplique, artículos, cantidades, precios históricos, total, dirección histórica, estado, pagos e historial.

## 5. Invitaciones y asignaciones
- El administrador o una persona expresamente autorizada invita empleados y repartidores.
- La invitación indica negocio, rol, permisos iniciales, vencimiento y emisor.
- El usuario debe autenticarse y aceptar; el servidor valida y crea la membresía.
- El usuario no puede elegirse ni elevarse el rol.
- Aceptar una invitación de repartidor no da acceso a pedidos automáticamente.
- Solo el administrador o empleado autorizado asigna pedidos.
- El repartidor consulta y actualiza exclusivamente sus asignaciones vigentes.

## 6. Módulos previstos
Identidad y sesiones; negocios y membresías; roles y permisos; perfil del negocio; catálogo; clientes; pedidos; seguimiento; invitaciones; asignaciones y rutas; pagos; inventario; reportes; notificaciones; privacidad y auditoría.

Los módulos pueden activarse según el tipo de negocio y su configuración. Su activación no concede permisos por sí sola.

## 7. Tecnologías propuestas
- Aplicación móvil: React Native, Expo y TypeScript.
- Backend: Node.js y TypeScript.
- Base de datos: PostgreSQL.
- Arquitectura inicial: monolito modular.
- Almacenamiento de archivos compatible con S3 cuando sea necesario.

Son propuestas iniciales, no decisiones irreversibles.

## 8. Fuera del alcance inicial
No se incorporarán automáticamente microservicios, inteligencia artificial, optimización avanzada de rutas ni múltiples proveedores de pago en la primera versión. Se evaluarán cuando exista una necesidad demostrable.

## 9. Decisiones pendientes
- Descubrimiento de negocios: búsqueda, ubicación, enlace/código o combinación.
- Membresías múltiples y cambio de contexto.
- Matriz detallada de permisos de empleados.
- Estados y transiciones definitivas de pedidos.
- Reglas de inventario, cancelaciones y devoluciones.
- Pagos parciales, reembolsos y conciliación.
- Asignación de rutas y evidencias de entrega.
- Política de retención y eliminación de datos.

## 10. Criterio de aceptación
Una función estará lista cuando tenga validaciones, control de permisos en servidor, pruebas relevantes, manejo de errores y documentación mínima.
