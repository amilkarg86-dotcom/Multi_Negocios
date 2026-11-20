# Lógica funcional del sistema Multi_Negocios

## 1. Propósito
Multi_Negocios es una plataforma móvil multiempresa para gestionar operaciones comerciales y logísticas de negocios independientes. Cada negocio opera en un espacio aislado y utiliza los módulos que correspondan a su actividad.

## 2. Principios obligatorios
- **Aislamiento multiempresa:** ningún usuario consulta o modifica información de un negocio si no tiene una relación y autorización válida.
- **Mínimo privilegio:** cada perfil recibe únicamente las funciones necesarias. Los permisos específicos pueden restringirse o ampliarse por autorización del administrador, sin superar los límites del rol.
- **Autorización en servidor:** la API valida identidad, pertenencia al negocio, rol, permiso, propiedad del recurso y estado de la operación. Ocultar botones no es una medida de seguridad.
- **Trazabilidad:** las operaciones relevantes registran actor, negocio, fecha, acción y entidad afectada.
- **Separación de experiencias:** administrador, empleado, repartidor y cliente tienen navegación y pantallas independientes.
- **Consistencia:** las operaciones críticas se ejecutan con validaciones y transacciones.

## 3. Identidades y perfiles

### 3.1 Administrador del negocio
Administra únicamente el negocio al que pertenece. Puede consultar la operación completa de ese negocio, gestionar catálogo, clientes, pedidos, inventario, pagos, reportes, configuración, miembros, invitaciones y asignaciones de reparto. No accede a datos privados ni operaciones de otros negocios.

### 3.2 Empleado
Opera dentro del negocio al que fue incorporado. Puede registrar pedidos en nombre de clientes y ejecutar las funciones operativas expresamente autorizadas. No obtiene automáticamente facultades para gestionar miembros, invitaciones, permisos, configuración, reportes sensibles ni asignaciones de reparto. Los permisos de empleado son configurables por el administrador dentro de las capacidades permitidas para ese rol.

Cuando registra un pedido en nombre de un cliente, el pedido conserva al cliente como destinatario/comprador y al empleado como autor real del registro. El origen queda identificado como registro asistido por empleado.

### 3.3 Repartidor
Se incorpora a un negocio mediante invitación emitida por una persona autorizada. Aceptar la invitación crea o activa su vinculación con ese negocio, pero no le concede acceso a todos sus pedidos. Solo puede consultar las entregas asignadas a él y ejecutar acciones de entrega permitidas sobre esas asignaciones. No puede asignarse pedidos, cambiar productos, precios o importes, ni consultar inventario, cartera, ventas, otros clientes u órdenes no asignadas.

### 3.4 Cliente
Puede descubrir o seleccionar negocios, consultar su catálogo, registrar sus propios pedidos, pagar por los medios habilitados y consultar exclusivamente su información, direcciones, notificaciones e historial de compras. No accede a paneles internos, inventario privado, reportes ni datos de otros clientes.

Una cuenta de cliente no se convierte automáticamente en miembro de un negocio. Si una misma persona también trabaja para un negocio, sus relaciones y permisos se evalúan por separado y el usuario debe cambiar explícitamente de contexto.

## 4. Incorporación mediante invitaciones
1. Un administrador o miembro con permiso explícito genera una invitación para un empleado o repartidor.
2. La invitación identifica negocio, rol previsto, permisos iniciales, emisor, vencimiento y estado.
3. El destinatario se autentica o crea su cuenta y acepta la invitación.
4. El servidor valida token, vigencia, uso, negocio activo y facultad del emisor.
5. Se crea o activa la membresía con el rol indicado y permisos permitidos.
6. La invitación se marca como aceptada y no puede reutilizarse.
7. El administrador puede revocar la invitación antes de aceptarse o desactivar la membresía después.

No se permite que el destinatario elija o eleve su propio rol. Una invitación no concede acceso a otros negocios.

## 5. Catálogo y promociones del negocio

### 5.1 Administración del catálogo
Cada negocio administra su propio catálogo de productos. El administrador puede:
- Crear productos y completar su información comercial.
- Editar nombre, descripción, imágenes, categoría y demás datos del producto.
- Establecer y actualizar el precio regular.
- Publicar, modificar, pausar o retirar productos del catálogo.
- Crear y administrar promociones para los productos o conjuntos de productos de su negocio.
- Definir el precio promocional o descuento y la vigencia de la promoción.
- Consultar cómo se presenta el producto al cliente.

Los empleados solo podrán crear o modificar productos, precios o promociones si el administrador les concede permisos específicos. Sin esos permisos, su acceso al catálogo es de consulta operativa. El repartidor no administra el catálogo. El cliente únicamente consulta productos y promociones publicados y disponibles para la compra.

### 5.2 Publicación y aplicación de precios
- Cada catálogo pertenece a un único negocio y no se comparte automáticamente con otros negocios.
- Los productos no publicados, desactivados o fuera de vigencia no se ofrecen para nuevas compras.
- El servidor valida el precio vigente y la promoción aplicable al confirmar el pedido; no confía en importes enviados por el dispositivo.
- La promoción debe respetar su vigencia y condiciones configuradas. Los detalles de tipos de descuento, acumulación y límites se formalizarán antes de implementar.
- El pedido conserva una instantánea del nombre del producto, precio aplicado, descuento y promoción utilizada, cuando corresponda. Cambios posteriores del catálogo no modifican pedidos anteriores.

## 6. Pedidos: flujo unificado
Los pedidos pueden originarse por dos vías:
- **Cliente:** el cliente autenticado crea su pedido desde su experiencia.
- **Empleado:** un empleado autorizado registra el pedido en nombre de un cliente, por atención presencial, llamada o mensajería.

Ambas vías utilizan el mismo proceso de validación, cálculo, persistencia, pago, preparación y entrega. Cada pedido conserva como mínimo:
- negocio al que pertenece;
- cliente al que corresponde;
- origen del registro;
- usuario autenticado que lo creó;
- miembro empleado, cuando aplique;
- productos, cantidades y precios históricos;
- total calculado en servidor;
- dirección e instrucciones copiadas al pedido;
- estado e historial;
- pagos y asignaciones de entrega.

El cliente no puede alterar un pedido después de confirmado salvo mediante las acciones que el negocio habilite. El empleado solo puede modificarlo según sus permisos y las reglas de estado. El repartidor no modifica el contenido comercial.

## 7. Asignación y entrega
- Solo el administrador o un empleado con permiso expreso puede asignar o cambiar al repartidor.
- El repartidor solo ve asignaciones vigentes o su historial propio.
- Las acciones de recogida, salida a ruta, entrega o incidencia se validan contra la asignación activa y el estado actual.
- Toda asignación, reasignación y actualización de entrega queda auditada.
- La información personal del cliente se limita a lo necesario para realizar la entrega.
- La asignación no debe permitir que un repartidor consulte pedidos de otros repartidores.

## 8. Estados y pagos
Los estados definitivos y sus transiciones se deben formalizar antes de implementar. La interfaz puede representar recepción, preparación, ruta, entrega y cancelación, pero la API solo acepta transiciones válidas. El estado de pago es independiente del estado logístico del pedido. Un pedido entregado no implica automáticamente que esté pagado, y un pago confirmado no implica que esté entregado.

## 9. Clientes, direcciones e historial
Los datos de clientes pertenecen al negocio para la relación comercial, mientras que la cuenta autenticada y sus direcciones personales requieren un vínculo explícito y controles de privacidad. Cada pedido conserva una instantánea de la dirección utilizada; editar una dirección guardada no cambia pedidos anteriores.

## 10. Notificaciones
Las notificaciones se entregan al destinatario correcto según su relación con el negocio y el evento. El cliente recibe novedades de sus pedidos, pagos y comunicaciones permitidas. El repartidor recibe cambios de sus asignaciones. El empleado y administrador reciben avisos operativos acordes a sus permisos. Ninguna notificación debe revelar información de otro negocio o usuario.

## 11. Auditoría y revocación
Se registran creación y cambios de pedidos, pagos, asignaciones, invitaciones, cambios de permisos y acciones administrativas relevantes. Al desactivar una membresía o revocar una autorización, las solicitudes posteriores deben rechazarse inmediatamente. La auditoría se conserva de acuerdo con la política de retención.

## 12. Reglas de seguridad transversales
- Verificar negocio y permiso en cada lectura y escritura.
- No confiar en identificadores de negocio, rol, cliente, miembro o repartidor enviados por la aplicación.
- Aplicar límites de acceso por recurso y por estado.
- Proteger sesiones y credenciales.
- Evitar exponer datos personales innecesarios.
- Probar intentos de acceso cruzado entre negocios, clientes, empleados y repartidores.

## 13. Pendientes antes de producción
- Matriz detallada de permisos para cada acción de empleado.
- Si una cuenta podrá tener varias membresías y cómo cambiar de contexto.
- Estados exactos del pedido y transiciones por perfil.
- Reglas de cancelación, devolución y edición.
- Reglas de inventario y pagos parciales.
- Tipos de promociones, reglas de acumulación, límites, vigencia y compatibilidad entre promociones.
- Política de retención, eliminación y exportación de datos.
- Verificación de invitaciones y canales de entrega.
