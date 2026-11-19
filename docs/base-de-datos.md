# Modelo preliminar de base de datos

## 1. Criterios
- PostgreSQL como motor propuesto.
- Identificadores estables, preferiblemente UUID.
- Fechas almacenadas con zona horaria (timestamptz).
- Restricciones e índices definidos junto con las reglas de negocio.
- Las tablas propiedad de un negocio incluirán business_id.
- El modelo deberá convertirse en migraciones versionadas antes de usarse.

## 2. Entidades iniciales

### users
Identidad global de una persona que inicia sesión. Campos conceptuales: id, name, email, phone, created_at, updated_at.

### businesses
Negocios registrados. Campos: id, name, legal_name (opcional), status, created_at, updated_at.

### business_memberships
Relación entre usuarios y negocios. Campos: id, business_id, user_id, status, joined_at. Esta estructura permite modelar pertenencia a varios negocios, decisión aún pendiente.

### roles, permissions, role_permissions, membership_roles
Estructura para asignar permisos a miembros dentro de un negocio. Los roles definitivos quedan pendientes.

### customers
Clientes de un negocio. Campos: id, business_id, name, phone, email (opcional), created_at.

### products
Catálogo de un negocio. Campos: id, business_id, name, description, sku (opcional), price, active, created_at, updated_at.

### orders
Cabecera del pedido. Campos: id, business_id, customer_id, created_by_user_id, origin, status, delivery_address, delivery_notes, subtotal, total, created_at, updated_at.

origin distinguirá al menos customer y employee. created_by_user_id identifica quién registró el pedido. Las reglas de estados y totales deben definirse antes de programar.

### order_items
Detalle del pedido. Campos: id, business_id, order_id, product_id, product_name_snapshot, unit_price, quantity, line_total. Los valores históricos de nombre y precio deben conservarse aunque el catálogo cambie.

### delivery_assignments
Asignaciones de pedidos a repartidores o rutas. Campos: id, business_id, order_id, assigned_user_id, route_id (opcional), status, assigned_at.

### routes
Rutas de entrega. Campos: id, business_id, name, scheduled_date, status.

### payments
Registros de pagos. Campos: id, business_id, order_id, amount, method, status, recorded_by_user_id, paid_at, created_at. No se almacenarán números completos de tarjetas ni códigos de seguridad.

### inventory_items e inventory_movements
Existencias y movimientos por producto. Las reglas para reservar, descontar o devolver existencias están pendientes.

### audit_logs
Registro de acciones relevantes. No debe almacenar contraseñas, tokens o información sensible innecesaria.

## 3. Reglas de integridad
- Un pedido y sus detalles deben pertenecer al mismo negocio.
- Un producto seleccionado debe pertenecer al negocio del pedido.
- Un cliente debe pertenecer al negocio correspondiente.
- Asignaciones, pagos e inventario deben validar el mismo business_id.
- Operaciones críticas deben ejecutarse en transacciones.
- Los identificadores enviados por el móvil deben validarse en el backend.

## 4. Índices iniciales a evaluar
- business_id en tablas multiempresa.
- Pedidos por (business_id, created_at).
- Pedidos por (business_id, status).
- Clientes por (business_id, phone).
- Productos por (business_id, active).

## 5. Pendiente antes de migraciones
Confirmar reglas de clientes duplicados, pertenencia multiempresa, estados de pedido, pagos parciales, inventario, eliminación lógica y retención de auditoría.
