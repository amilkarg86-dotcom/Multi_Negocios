# Multi_Negocios

Plataforma móvil de gestión comercial y logística para negocios independientes.

> **Propuesta en construcción.** Este README consolida la visión, las experiencias por perfil, las reglas funcionales y las decisiones aprobadas. Las maquetas son referencias visuales; no representan funciones implementadas.

## Objetivo
Facilitar la administración de pedidos, clientes, productos, inventario, ventas, pagos, rutas y repartidores mediante una plataforma para Android y iOS, con aislamiento estricto entre negocios.

## Estado
Fase de definición funcional, diseño y preparación técnica.

## 1. Identidad visual
- Estilo digital y contemporáneo.
- Fondos azul profundo, acentos cian y violeta, tarjetas redondeadas e iconografía clara.
- Identidad común con navegación y funciones adaptadas a cada perfil.
- Diseño progresivo: una vista a la vez, aprobación antes de consolidarla.

## 2. Perfiles y límites
### Administrador
Controla la operación de su negocio: pedidos, clientes, catálogo, productos, precios, promociones, inventario, pagos, reportes, equipo, invitaciones, asignaciones y configuración. No accede a otros negocios.

### Empleado
Registra pedidos para clientes y ejecuta operaciones habilitadas por permisos. No administra miembros, roles, invitaciones ni configuración general salvo autorización específica. Todo pedido asistido identifica al empleado creador y al cliente correspondiente.

### Repartidor
Se vincula mediante invitación aceptada y validada. Solo consulta entregas asignadas y actualiza eventos logísticos permitidos. No registra pedidos, se autoasigna entregas, modifica importes ni consulta operaciones ajenas.

### Cliente
Descubre negocios, consulta catálogos, registra pedidos propios, paga y consulta sus datos, direcciones, notificaciones e historial. No accede a información interna ni a pedidos de otros clientes.

Los permisos se verifican en el servidor. La matriz y lógica completa están en [docs/logica-del-sistema.md](docs/logica-del-sistema.md).

## 3. Esquema de navegación
La estructura funcional por perfil está en [docs/esquema-app.md](docs/esquema-app.md). Las experiencias son independientes:
- Cliente: Inicio, Mis pedidos, Mi perfil y Notificaciones.
- Administrador: Resumen, Pedidos, Clientes, Gestión del catálogo y promociones, Inventario, Ventas/Pagos, Equipo y Configuración.
- Empleado: Inicio operativo, Registrar pedido, Pedidos, Clientes, Productos, Pagos autorizados, Notificaciones y Perfil.
- Repartidor: Inicio, Mis entregas, Detalle de entrega, Ruta, Incidencias, Historial y Perfil.

## 4. Catálogo inicial de vistas
Las cifras, negocios, personas, productos y operaciones de las maquetas son ilustrativos.

### Vista 01. Inicio de sesión
Acceso común con autenticación segura y posterior resolución del contexto y perfil autorizado.

### Vista 02. Registro de cuenta
Registro público de cuenta cliente. Empleados y repartidores se incorporan mediante invitación aceptada. El alta de un negocio tiene un flujo separado.

### Vista 03. Selección de negocio
Descubrimiento y selección de negocios disponibles, o acceso a una invitación. La pertenencia y los permisos se verifican en el servidor.

### Vista 04. Panel principal del administrador
Resumen de la actividad del negocio, indicadores, pedidos recientes y accesos a módulos autorizados.

### Vista 05. Panel principal del empleado
Panel operativo con accesos a registro de pedidos y tareas habilitadas por permisos.

### Vista 06. Panel principal del cliente
Experiencia de compra para descubrir negocios, consultar catálogo, carrito, pedidos e historial.

### Vista 07. Catálogo, carrito y pasarela de pagos
Identidad del negocio, búsqueda y categorías, productos, cantidades, carrito, resumen y selección de método de pago. Cada pedido pertenece a un solo negocio. Los pagos electrónicos se procesarán mediante proveedor seguro; no se almacenarán datos completos de tarjetas.

### Vista 08. Seguimiento del pedido del cliente
Estado, progreso, resumen, dirección histórica, pago y datos mínimos de entrega. Solo se muestra repartidor cuando exista asignación válida.

### Vista 09. Historial y detalle de pedidos del cliente
**Estado: APROBADA.** Listado cronológico, importe, estado, detalle de productos, dirección, pago, historial y acciones contextuales permitidas.

### Vista 10. Perfil y direcciones del cliente
**Estado: APROBADA.** Perfil, direcciones guardadas, dirección principal, edición y eliminación. Las direcciones de pedidos anteriores permanecen como instantáneas históricas.

### Vista 11. Centro de notificaciones
**Estado: APROBADA.** Bandeja de notificaciones, filtros por pedidos, pagos y promociones, lectura y detalle de avisos. Cada aviso se limita al destinatario autorizado.

### Vista 12. Configuración de la cuenta
**Estado: APROBADA.** Preferencias, notificaciones, privacidad, seguridad, sesiones y opciones de gestión de datos y cuenta.

La aprobación visual no significa que las pantallas o funciones estén implementadas. Las vistas 01 a 08 conservan el estado de aprobación que conste en el registro de diseño; no se infiere aprobación por su inclusión en este catálogo.

## 5. Catálogo y promociones del negocio
El administrador dispone de una experiencia propia para crear, editar, publicar, pausar y retirar productos de su catálogo; establecer precios regulares y crear promociones con precio promocional o descuento y vigencia. Los empleados solo gestionan productos, precios o promociones si reciben permisos específicos. Los repartidores no administran el catálogo. Los clientes solo consultan productos y promociones publicados y disponibles. El servidor valida precios y promociones al confirmar cada pedido, y el pedido conserva una instantánea del precio y descuento aplicados para proteger el historial comercial.

## 6. Lógica funcional
- Cliente y empleado pueden registrar pedidos mediante un flujo unificado.
- El pedido conserva cliente, origen y usuario creador; en el flujo asistido conserva también la membresía del empleado.
- El repartidor accede únicamente a entregas asignadas.
- Solo administrador o miembro expresamente autorizado puede invitar y asignar.
- Aceptar invitación no equivale a asignación de pedidos.
- El cliente solo consulta sus propios pedidos y datos.
- Cada negocio mantiene sus datos aislados.
- Direcciones guardadas no modifican direcciones históricas de pedidos.
- Pagos y estados logísticos son independientes.
- Las acciones sensibles deben ser auditables.

## 7. Documentación del proyecto
- [Plan general](PLANO.md)
- [Lógica funcional del sistema](docs/logica-del-sistema.md)
- [Esquema de navegación de la app](docs/esquema-app.md)
- [Arquitectura](docs/arquitectura.md)
- [Base de datos](docs/base-de-datos.md)
- [Hoja de ruta](docs/roadmap.md)
- [Esquema SQL inicial](database/001_esquema_inicial.sql)

## 8. Tecnologías propuestas
- React Native, Expo y TypeScript.
- Node.js y TypeScript.
- PostgreSQL.
- Monolito modular inicial.

## 9. Pendientes antes de producción
- Matriz detallada de permisos del empleado.
- Membresías múltiples y cambio de contexto.
- Estados y transiciones definitivas de pedidos.
- Reglas de inventario, cancelación y devolución.
- Tipos, acumulación, límites y compatibilidad de promociones.
- Pagos parciales, reembolsos y conciliación.
- Política de retención y eliminación.
- Estrategia de aislamiento y pruebas RLS.

---
Este documento evoluciona con el proyecto. Las decisiones nuevas deben registrarse y respetar las aprobaciones previas.
