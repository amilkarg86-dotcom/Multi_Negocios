# Seguridad

## Reportar una vulnerabilidad
No publiques credenciales, datos personales ni detalles explotables de una vulnerabilidad en un issue público. Contacta de forma privada al mantenedor del proyecto.

## Principios de seguridad
- Los secretos y archivos .env no se suben al repositorio.
- La API valida identidad, pertenencia al negocio y permisos en cada operación protegida.
- Los datos de distintos negocios deben permanecer aislados.
- No se almacenan datos completos de tarjetas ni códigos de seguridad.
- Los registros de auditoría no deben contener contraseñas, tokens ni secretos.
- Se aplican actualizaciones de seguridad a dependencias y servicios.
- Las copias de seguridad deben protegerse y probarse mediante restauraciones periódicas.

Esta política inicial deberá ampliarse antes del lanzamiento público.
