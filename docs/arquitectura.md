# Arquitectura inicial

## 1. Objetivo
Definir una base mantenible para una plataforma móvil multiempresa, evitando complejidad prematura y manteniendo el costo operativo bajo control.

## 2. Arquitectura propuesta
Iniciar con un **monolito modular**:
- Aplicación móvil: React Native + Expo + TypeScript.
- API: Node.js + TypeScript.
- Persistencia: PostgreSQL.
- Archivos: almacenamiento de objetos compatible con S3 cuando sea necesario.

La aplicación móvil consumirá la API. La API será responsable de autenticación, autorización, reglas de negocio y acceso a datos.

## 3. Módulos del backend
1. Identity: autenticación y sesiones.
2. Tenancy: negocios y pertenencia de usuarios.
3. Access Control: roles y permisos.
4. Catalog: productos y disponibilidad.
5. Customers: clientes.
6. Orders: pedidos y estados.
7. Delivery: rutas, asignaciones y repartidores.
8. Payments: registro de pagos.
9. Inventory: existencias y movimientos.
10. Reporting: consultas e informes.

## 4. Aislamiento multiempresa
- Toda entidad propiedad de un negocio deberá asociarse a un business_id.
- La API obtendrá los negocios accesibles desde la identidad y membresías verificadas.
- Nunca se confiará en un business_id enviado por el cliente sin comprobar autorización.
- Las consultas y operaciones se limitarán al negocio autorizado.
- Se evaluarán claves foráneas compuestas y políticas de seguridad a nivel de fila de PostgreSQL como capas adicionales.
- Las pruebas intentarán acceder a registros de otro negocio y verificarán que el acceso sea rechazado.

## 5. Autorización
Se utilizará control de acceso basado en roles y permisos (RBAC). Los roles iniciales por definir pueden incluir administrador, empleado y repartidor. Los permisos concretos se documentarán antes de implementar operaciones sensibles.

La interfaz puede ocultar acciones no permitidas, pero la API siempre debe validar los permisos.

## 6. Trazabilidad
Las operaciones relevantes conservarán actor, negocio, fecha y hora, tipo de acción, entidad afectada y cambios relevantes, evitando guardar secretos o datos innecesarios.

Para pedidos se conservarán, como mínimo, el origen del registro y el usuario creador.

## 7. Seguridad y operación
- Validación de entradas en el servidor.
- Contraseñas y sesiones gestionadas mediante mecanismos seguros.
- Secretos en variables de entorno, nunca en el repositorio.
- HTTPS en producción.
- Copias de seguridad y pruebas periódicas de restauración.
- Registro de errores sin exponer credenciales ni datos personales innecesarios.
- Dependencias actualizadas y revisión de vulnerabilidades.

## 8. Escalabilidad
Redis, colas, réplicas de lectura y separación en servicios se incorporarán solo cuando la carga o los requisitos lo justifiquen.

## 9. Decisiones pendientes
Proveedor y flujo de autenticación, estrategia final de aislamiento, hosting, despliegue, política de retención y requisitos de notificaciones push.
