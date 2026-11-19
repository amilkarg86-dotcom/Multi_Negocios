# Base de datos de Multi_Negocios

## Fuente SQL de referencia

El esquema inicial entregado para el proyecto está guardado en [database/001_esquema_inicial.sql](../database/001_esquema_inicial.sql). Este archivo conserva el SQL original sin correcciones automáticas. Cualquier cambio estructural deberá discutirse y registrarse como una migración posterior.

## Motor y convenciones

- PostgreSQL 13 o superior.
- UUID como identificador principal.
- Fechas con zona horaria mediante timestamptz.
- Dinero en pesos enteros mediante bigint.
- Better Auth administra las cuentas y sesiones; la tabla miembros relaciona el usuario autenticado con cada negocio.
- El negocio se identifica mediante negocio_id en las tablas operativas.
- Las relaciones entre datos de negocio utilizan claves foráneas compuestas cuando corresponde.

## Entidades incluidas

| Área | Tablas / objetos |
|---|---|
| Configuración | tipos_negocio, negocio_modulos |
| Negocios y acceso | negocios, miembros |
| Comercial | clientes, productos |
| Pedidos | pedidos, pedido_items, pedido_historial |
| Pagos y cartera | pagos, cartera_clientes (vista) |
| Archivos | archivos |
| Automatización | funciones y triggers de actualización, historial y notificación |

## Reglas de negocio representadas

- Los tipos de negocio habilitan módulos por defecto y cada negocio puede activar o desactivar módulos.
- Los roles iniciales de miembro son dueno, caja y repartidor.
- El pedido conserva la dirección de entrega y el precio unitario aplicado al momento de la compra.
- El pedido mínimo se valida en la API dentro de la transacción que crea el pedido y sus ítems.
- El historial registra cambios de estado.
- PostgreSQL notifica a la API mediante el canal pedidos_cambio cuando se inserta o actualiza un pedido.
- Los pagos pueden asociarse a un pedido concreto o registrarse como abono general del cliente.
- La cartera se calcula con pedidos entregados menos pagos registrados.

## Revisión técnica pendiente

Estos puntos no modifican el SQL original; son asuntos que deben resolverse en una revisión posterior:

1. **Pedido creado por cliente:** pedidos.creado_por referencia miembros. Para pedidos creados directamente por un cliente, debe definirse cómo se identifica al usuario Better Auth que lo creó, sin obligar a convertirlo en miembro del negocio.
2. **Estados de pedido:** el enum actual contiene pendiente, en_ruta, entregado y cancelado. La interfaz contempla preparación y otros hitos; debemos acordar si se amplían los estados o si se modelan eventos separados.
3. **Estado del pago:** pagos no tiene un campo que distinga pendiente, confirmado, fallido o reembolsado. Es necesario definirlo para integrar pasarelas.
4. **Aislamiento de lectura:** las claves foráneas compuestas impiden relacionar registros de distintos negocios, pero no filtran por sí solas las consultas SELECT. La API debe autorizar cada consulta y se debe evaluar Row-Level Security (RLS) de PostgreSQL.
5. **Rol del repartidor:** la FK garantiza que el repartidor sea miembro del negocio, pero no garantiza que su rol sea repartidor. La API debe validarlo o debe añadirse una restricción adecuada.
6. **Auditoría:** pedido_historial.cambiado_por no tiene actualmente una FK compuesta hacia miembros. Debe decidirse cómo validar el actor y cómo registrar acciones del sistema o del cliente.
7. **Cartera:** la vista cartera_clientes debe revisarse para que las agregaciones y uniones incluyan negocio_id explícitamente y para definir cómo tratar pagos pendientes, reembolsos y abonos generales.
8. **Eliminación y retención:** varias relaciones usan ON DELETE CASCADE desde negocios. Antes de producción debe definirse si desactivar negocios es suficiente y cómo preservar el historial comercial y financiero.
9. **Consistencia de totales:** debe garantizarse que pedidos.total coincida con la suma de sus ítems y que las operaciones de creación/edición se ejecuten en transacciones.

## Regla de mantenimiento

No se debe editar una migración ya aplicada en un entorno compartido. Los cambios posteriores se añadirán mediante archivos de migración numerados y probados. Antes de ejecutar el esquema en producción se debe probar en una base de datos desechable y validar las dependencias de Better Auth.
