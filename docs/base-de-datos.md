# Base de datos de Multi_Negocios

## Fuente SQL de referencia
El esquema inicial se conserva en [database/001_esquema_inicial.sql](../database/001_esquema_inicial.sql). No se modifica una migración que ya pueda haber sido aplicada. Los cambios estructurales se incorporarán mediante migraciones nuevas, numeradas, revisadas y probadas.

## Motor y convenciones
- PostgreSQL 13 o superior.
- UUID como identificador principal.
- Fechas con zona horaria mediante timestamptz.
- Dinero en pesos enteros mediante bigint.
- Better Auth administra cuentas y sesiones; las membresías relacionan usuarios con negocios.
- Las entidades operativas incluyen negocio_id.
- Las relaciones entre datos de negocio usan claves foráneas compuestas cuando corresponde.

## Entidades incluidas en 001
| Área | Tablas / objetos |
|---|---|
| Configuración | tipos_negocio, negocio_modulos |
| Negocios y acceso | negocios, miembros |
| Comercial | clientes, productos |
| Pedidos | pedidos, pedido_items, pedido_historial |
| Pagos y cartera | pagos, cartera_clientes |
| Archivos | archivos |
| Automatización | funciones y triggers de actualización, historial y notificación |

## Diagrama entidad-relación\nEl diagrama visual de las tablas, campos y relaciones declaradas en el SQL inicial está en [docs/modelo-entidad-relacion.md](./modelo-entidad-relacion.md). Ese documento separa el esquema actual de las entidades que todavía están pendientes de diseño e implementación.\n\n## Modelo lógico requerido por la lógica aprobada

### Identidad y membresías
- Una cuenta autenticada representa a una persona.
- Una membresía representa la relación autorizada de esa persona con un negocio y su rol (administrador, empleado o repartidor).
- El cliente no requiere membresía de negocio. Su identidad de cuenta debe poder vincularse a su ficha comercial sin convertirlo en empleado.
- Debe definirse si una persona puede tener varias membresías y cómo cambia de contexto.

### Roles y permisos
- Mantener roles diferenciados para administrador, empleado y repartidor.
- Los permisos del empleado deben poder configurarse por negocio y miembro, con un catálogo central de permisos.
- El administrador no puede concederse acceso a otro negocio.
- El cliente accede por propiedad de sus recursos y reglas de negocio, no por un rol de membresía.
- El rol no debe ser asignable por el usuario desde el registro público.

### Invitaciones
Se requiere una entidad de invitaciones con negocio, rol propuesto, emisor, token almacenado de forma segura (preferiblemente hash), vencimiento, estado, fecha de aceptación y usuario destinatario cuando se conozca. Debe impedirse la reutilización y registrarse la revocación.

### Pedidos
El esquema debe diferenciar:
- cliente_id: persona a quien corresponde la compra;
- origen: cliente o empleado;
- usuario creador: cuenta autenticada que inició la creación;
- miembro creador: membresía del empleado cuando el origen sea asistido;
- negocio_id: propietario del pedido.

El flujo de cliente no debe obligar a crear una membresía. Los artículos conservan precio y descripción aplicados al momento de la venta. El total se calcula y valida en servidor dentro de una transacción.

### Catálogo, precios y promociones
- Los productos pertenecen a un negocio y su identificador no concede acceso entre negocios.
- Se requiere información de publicación/visibilidad y estado del producto, además de precio regular vigente.
- Las promociones deben pertenecer al mismo negocio y poder asociarse a uno o varios productos según las reglas finales.
- Una promoción debe almacenar tipo de beneficio, valor o precio promocional, vigencia, estado y condiciones aplicables. Los tipos, acumulación, límites y compatibilidad deben definirse antes de crear la migración.
- El backend debe validar que la promoción esté activa, dentro de vigencia y sea aplicable al producto y pedido.
- Los ítems del pedido deben conservar instantáneas de nombre, precio regular, precio aplicado, descuento y referencia descriptiva de promoción cuando aplique. Los cambios posteriores no recalculan ventas históricas.
- La gestión del catálogo corresponde al administrador. Los permisos de empleado pueden habilitar operaciones específicas; el repartidor no tiene permisos de catálogo y el cliente solo consulta la oferta publicada.

### Direcciones
Las direcciones guardadas por el cliente deben modelarse separadamente de la dirección histórica copiada al pedido. Editar o eliminar una dirección guardada no altera pedidos previos.

### Reparto
La asignación debe validar que el miembro asignado esté activo, pertenezca al mismo negocio y tenga rol de repartidor. Debe conservarse historial de asignaciones, reasignaciones, actor y fechas. El repartidor solo accede a las asignaciones propias.

### Pagos
El pago necesita estado independiente del pedido: pendiente, confirmado, fallido, cancelado o reembolsado, según el proveedor y las reglas finales. Deben modelarse referencias externas sin almacenar datos completos de tarjetas. Los abonos generales y parciales requieren reglas de imputación claras.

### Notificaciones
Se requiere destinatario, tipo, contenido mínimo, referencia al evento/recurso, fecha, lectura y negocio cuando aplique. Las consultas deben limitarse al destinatario autorizado.

### Auditoría
Las acciones sensibles deben identificar actor autenticado, negocio, acción, entidad afectada, fecha y metadatos no sensibles. Deben contemplarse actores cliente, miembro y sistema.

## Reglas ya representadas en 001
- Tipos de negocio y módulos configurables.
- Negocios, miembros y roles iniciales.
- Clientes, productos, pedidos, ítems, historial, pagos y archivos.
- Claves foráneas compuestas en relaciones comerciales.
- Valores monetarios bigint en COP.
- Copia de precio unitario al pedido.
- Triggers de actualización, historial y notificación.

## Brechas conocidas de 001
1. El enum de miembros usa dueno/caja/repartidor; debe alinearse conceptualmente con administrador/empleado/repartidor sin romper datos existentes.
2. pedidos.creado_por solo referencia miembros y no representa correctamente pedidos creados directamente por clientes.
3. No hay invitaciones ni permisos específicos por empleado.
4. El catálogo inicial no contempla todavía un modelo completo de publicación, precios promocionales y promociones con vigencia y condiciones.
5. No hay vínculo formal entre cuenta de cliente y ficha comercial.
6. No hay entidad de direcciones guardadas del cliente.
7. pedidos.repartidor_id no conserva historial de asignaciones y no valida por sí solo el rol repartidor.
8. pedido_historial no identifica de forma completa actores cliente, miembro y sistema.
9. pagos no tiene estado de confirmación.
10. No hay tabla de notificaciones.
11. cartera_clientes debe agrupar y unir explícitamente por negocio_id; también debe definir pagos pendientes, reembolsos y abonos.
12. Debe revisarse eliminación en cascada para preservar historial comercial y financiero.
13. Debe garantizarse que el total del pedido coincide con la suma de sus ítems.

## Política de migraciones
Estos puntos son requisitos de diseño, no cambios ya aplicados. Antes de escribir la siguiente migración SQL se debe revisar el esquema efectivo, las dependencias de Better Auth y las reglas finales. Cada migración debe probarse en una base desechable y contar con pruebas de aislamiento multiempresa, autorización por perfil e integridad transaccional.
