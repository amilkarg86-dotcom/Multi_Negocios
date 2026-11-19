# Plan inicial de Multi_Negocios

## 1. Visión
Multi_Negocios será una plataforma de gestión comercial y logística para negocios independientes. Permitirá administrar clientes, catálogo, pedidos, entregas, pagos, inventario y reportes desde una aplicación móvil para Android y iOS.

## 2. Principios
- Multiempresa: cada negocio administra su propia operación.
- Aislamiento: los datos de un negocio no deben ser visibles para otro.
- Trazabilidad: registrar quién ejecutó cada acción relevante.
- Accesos por rol y permiso.
- Experiencia sencilla para clientes, empleados y repartidores.
- Desarrollo gradual, priorizando un MVP funcional y de bajo costo.

## 3. Registro de pedidos
Un pedido podrá registrarse por dos vías:
1. **Cliente:** crea su propio pedido desde la aplicación.
2. **Empleado:** registra un pedido en nombre del cliente, por llamada, mensajería o atención presencial.

Ambas vías utilizarán el mismo proceso de validación y gestión. Cada pedido conservará el origen del registro y el usuario que lo creó.

Datos iniciales: negocio, cliente, usuario creador, origen (cliente o empleado), productos, cantidades, precios, dirección, instrucciones de entrega, estado, asignación de repartidor o ruta y pagos.

## 4. Módulos previstos
- Identidad, usuarios, negocios y permisos.
- Perfil del negocio y catálogo de productos.
- Clientes y pedidos.
- Estados y seguimiento.
- Rutas y repartidores.
- Registro de pagos.
- Inventario y movimientos.
- Historial de ventas y reportes.
- Notificaciones.

La prioridad definitiva se validará durante el desarrollo.

## 5. Tecnologías propuestas
- Aplicación móvil: React Native, Expo y TypeScript.
- Backend: Node.js y TypeScript.
- Base de datos: PostgreSQL.
- Arquitectura inicial: monolito modular.
- Almacenamiento de archivos: servicio compatible con S3 cuando sea necesario.

Son propuestas iniciales, no decisiones irreversibles.

## 6. Fuera del alcance inicial
No se incorporarán automáticamente microservicios, inteligencia artificial, optimización avanzada de rutas ni múltiples proveedores de pago en la primera versión. Se evaluarán cuando exista una necesidad demostrable.

## 7. Decisiones pendientes
- Cómo encuentra un cliente un negocio: búsqueda, ubicación, enlace/código compartido o combinación.
- Si una cuenta podrá pertenecer a varios negocios.
- Roles exactos y matriz de permisos.
- Reglas de inventario al crear, cancelar o entregar pedidos.
- Estados definitivos y transiciones permitidas.
- Métodos de pago y pagos parciales.
- Reglas de asignación de rutas y repartidores.
- Requisitos de publicación, costos y proveedores.

## 8. Criterio de aceptación
Una función estará lista cuando tenga validaciones, control de permisos en el servidor, pruebas relevantes, manejo de errores y documentación mínima.
