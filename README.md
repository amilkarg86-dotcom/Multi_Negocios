# Multi_Negocios

Plataforma de gestión comercial y logística para negocios independientes.

> **Propuesta en construcción.** Este README es el documento vivo de presentación del producto. Aquí se consolidan el propósito, las experiencias por tipo de usuario, los conceptos visuales y las decisiones funcionales que se vayan aprobando. Las imágenes generadas durante el diseño sirven como referencias visuales; todavía no representan pantallas implementadas.

## Objetivo

Facilitar la administración de pedidos, clientes, productos, inventario, ventas, pagos, rutas y repartidores mediante una plataforma móvil para Android y iOS.

## Estado

Proyecto en fase de definición y diseño. Se está construyendo la propuesta funcional y visual antes de implementar las interfaces.

---

## 1. Identidad visual

- **Estilo:** digital y contemporáneo.
- **Lenguaje visual:** interfaz oscura, fondos azul profundo, acentos cian y violeta, tarjetas redondeadas, indicadores luminosos e iconografía clara.
- **Criterio de experiencia:** conservar una identidad común, pero adaptar navegación, información y acciones al tipo de usuario.
- **Diseño progresivo:** cada vista se define de manera independiente, con un concepto visual propio, antes de pasar a desarrollo.

## 2. Tipos de usuario y experiencias

### Administrador del negocio
Cuenta con una vista de control general para supervisar la actividad comercial, los pedidos, las ventas, los clientes, los productos, el inventario, los empleados y la configuración del negocio.

### Empleado
Cuenta con herramientas para la operación diaria: registrar pedidos en nombre de clientes, consultar clientes y productos, revisar pedidos pendientes, actualizar estados según sus permisos y consultar información operativa.

### Cliente
Puede encontrar y seleccionar un negocio, explorar su catálogo, añadir productos al carrito, registrar pedidos, seleccionar un método de pago y consultar el seguimiento de sus compras.

### Repartidor
Tendrá una experiencia específica para consultar entregas asignadas, revisar direcciones e instrucciones, actualizar estados de entrega y consultar su recorrido. Su vista se diseñará en una etapa posterior.

Los permisos definitivos de cada perfil deberán validarse en el backend. La interfaz no sustituye la autorización del servidor.

## 3. Catálogo de vistas y conceptos visuales

Las siguientes vistas forman parte de la propuesta de interfaz. Las cifras, negocios, nombres, productos y operaciones que aparezcan en las maquetas son ilustrativos.

### Vista 01. Inicio de sesión
Pantalla de acceso a Multi_Negocios. Presenta la identidad de la plataforma y los campos de autenticación. Debe ofrecer una entrada clara y segura para usuarios registrados.

### Vista 02. Registro de cuenta
Formulario para crear una cuenta con datos personales y credenciales. El rol no se asigna libremente: los clientes pueden crear su cuenta, mientras que empleados y repartidores deben incorporarse mediante autorización o invitación del negocio. La creación de un negocio tendrá un flujo propio.

### Vista 03. Selección de negocio
Permite buscar negocios por nombre, explorar categorías y seleccionar un negocio. También contempla el acceso mediante invitación y la posibilidad de iniciar el registro de un nuevo negocio. La disponibilidad de cada opción depende del perfil y de los permisos del usuario.

### Vista 04. Panel principal del administrador
Centro de operaciones del negocio. Incluye indicadores de pedidos, ventas, clientes y productos; resumen de ventas por periodo; pedidos recientes; notificaciones y accesos rápidos a productos, inventario, ventas y usuarios.

### Vista 05. Panel principal del empleado
Panel operativo con accesos para registrar pedidos, consultar clientes, revisar productos y ventas, gestionar pedidos pendientes y atender notificaciones. Las acciones disponibles dependen de los permisos asignados por el administrador.

### Vista 06. Panel principal del cliente
Experiencia orientada a compras. Facilita el acceso a negocios, catálogo, carrito, pedidos e historial, además de la administración de datos personales y direcciones.

### Vista 07. Catálogo, carrito y pasarela de pagos
Experiencia de compra dentro de un negocio seleccionado. Incluye:
- Identidad del negocio: nombre, logotipo, descripción, calificación y horario.
- Búsqueda y categorías de productos.
- Fotografías, precios, disponibilidad y selección de cantidades.
- Carrito con modificación y eliminación de artículos.
- Resumen de subtotal, envío y total antes de confirmar.
- Selección de método de pago.

**Métodos de pago considerados para evaluar:** tarjeta débito/crédito, billeteras digitales, transferencia bancaria y pago contra entrega. La integración con proveedores como Mercado Pago o Wompi es una posibilidad por investigar, no una integración confirmada. Los pagos electrónicos deberán procesarse mediante un proveedor seguro; la plataforma no almacenará números completos de tarjeta ni códigos de seguridad.

Cada pedido pertenece a un único negocio. El pago debe quedar asociado al pedido y su estado debe confirmarse antes de marcarlo como pagado.

### Vista 08. Seguimiento del pedido del cliente
Permite consultar qué ocurre con una compra después de confirmar el pedido. La pantalla contempla:
- Identidad del negocio y número del pedido.
- Estado general de la orden.
- Línea de progreso: pedido recibido, en preparación, en camino y entregado.
- Mensaje destacado con el estado actual.
- Resumen de productos, cantidades, subtotal, envío y total.
- Dirección e instrucciones de entrega.
- Información del repartidor asignado, cuando exista asignación.
- Método y estado del pago, por ejemplo, pago contra entrega pendiente.
- Acciones para ver el detalle y contactar al negocio.

Los tiempos estimados, direcciones, importes y datos del repartidor que aparezcan en la maqueta son ilustrativos. El estado y el seguimiento deberán reflejar eventos reales registrados por el sistema; no se mostrará un repartidor como asignado hasta que exista una asignación válida.

## 4. Reglas funcionales ya establecidas

- Tanto el cliente como el empleado pueden registrar pedidos.
- Cuando un empleado registra un pedido en nombre de un cliente, debe quedar guardado quién lo registró y que su origen fue el flujo de empleado.
- Los pedidos creados por clientes y empleados convergen en el mismo sistema de gestión y reglas de negocio.
- Cada pedido debe estar asociado a un negocio.
- Los datos de un negocio deben permanecer aislados de los demás negocios.
- Los permisos se verifican en el servidor y no solamente ocultando opciones en la aplicación.
- Los datos y ejemplos que aparezcan en maquetas no deben confundirse con información real.

## 5. Principios técnicos y de seguridad

- Arquitectura multiempresa con aislamiento de datos.
- Trazabilidad de las acciones relevantes.
- Validación de entradas y autorización en el backend.
- Protección de credenciales y secretos mediante variables de entorno.
- Operaciones críticas y cambios de estado consistentes.
- Copias de seguridad y pruebas de restauración antes de producción.
- Cumplimiento de las obligaciones aplicables de protección de datos personales.

## 6. Tecnologías propuestas

- Aplicación móvil: React Native, Expo y TypeScript.
- Backend: Node.js y TypeScript.
- Base de datos: PostgreSQL.
- Arquitectura inicial: monolito modular.

Estas tecnologías son una propuesta inicial y podrán ajustarse durante la planificación técnica.

## 7. Decisiones pendientes

- Mecanismo para descubrir negocios: búsqueda, ubicación, enlace/código compartido o combinación.
- Si una misma cuenta podrá pertenecer a varios negocios.
- Roles definitivos y matriz de permisos.
- Estados del pedido y transiciones permitidas.
- Reglas de inventario al crear, cancelar y entregar pedidos.
- Costos de envío y reglas de cobertura.
- Pagos parciales, reembolsos y conciliación de pagos.
- Proveedores de pago y sus condiciones en Colombia.
- Flujo de rutas y asignación de repartidores.

## 8. Próximos pasos de diseño

1. Completar la vista de seguimiento del pedido del cliente.
2. Diseñar las vistas de detalle del pedido e historial.
3. Diseñar el flujo de registro de pedidos por empleado.
4. Diseñar catálogo y gestión de productos para el administrador.
5. Diseñar inventario, ventas, usuarios y permisos.
6. Diseñar la experiencia independiente del repartidor.
7. Consolidar las decisiones funcionales y validar el conjunto de pantallas antes de implementarlas.

---

**Nota:** Este documento evoluciona con el proyecto. Las nuevas vistas y decisiones aprobadas deben incorporarse aquí para mantener una propuesta única y coherente.
