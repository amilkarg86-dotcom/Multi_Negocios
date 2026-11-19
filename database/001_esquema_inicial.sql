-- =====================================================================
-- 001_esquema_inicial.sql
-- App multi-negocio (multi-tenant) guiada por configuración.
-- Primer negocio: empresa de agua (pacas 300 ml, 600 ml, 4 L).
--
-- Reglas de diseño:
--  * Toda tabla de datos lleva negocio_id: un negocio nunca ve datos de otro.
--  * Las llaves foráneas compuestas (negocio_id, id) impiden mezclar negocios.
--  * Dinero en pesos enteros (bigint), sin decimales.
--  * Cuentas y sesiones las maneja Better Auth (no se crean aquí).
--  * Lo que cambia entre negocios es configuración, no código.
-- Requiere PostgreSQL 13 o superior.
-- =====================================================================

BEGIN;

-- ---------------------------------------------------------------------
-- Tipos
-- ---------------------------------------------------------------------
CREATE TYPE rol_miembro   AS ENUM ('dueno', 'caja', 'repartidor');
CREATE TYPE estado_pedido AS ENUM ('pendiente', 'en_ruta', 'entregado', 'cancelado');
CREATE TYPE metodo_pago   AS ENUM ('efectivo', 'transferencia', 'tarjeta', 'otro');

-- ---------------------------------------------------------------------
-- Plantillas por tipo de negocio (agua, tienda, panadería, comida rápida)
-- ---------------------------------------------------------------------
CREATE TABLE tipos_negocio (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo      text NOT NULL UNIQUE,          -- 'agua', 'tienda', 'panaderia', ...
  nombre      text NOT NULL,
  modulos     jsonb NOT NULL DEFAULT '[]',   -- módulos que se activan por defecto
  creado_en   timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------
-- Negocios (tenants)
-- ---------------------------------------------------------------------
CREATE TABLE negocios (
  id                     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tipo_negocio_id        uuid NOT NULL REFERENCES tipos_negocio(id),
  nombre                 text NOT NULL,
  slug                   text NOT NULL UNIQUE,
  moneda                 text NOT NULL DEFAULT 'COP',
  zona_horaria           text NOT NULL DEFAULT 'America/Bogota',
  pedido_minimo_unidades integer NOT NULL DEFAULT 1 CHECK (pedido_minimo_unidades >= 1),
  marca                  jsonb NOT NULL DEFAULT '{}',  -- logo, colores
  config                 jsonb NOT NULL DEFAULT '{}',  -- ajustes extra por negocio
  activo                 boolean NOT NULL DEFAULT true,
  creado_en              timestamptz NOT NULL DEFAULT now(),
  actualizado_en         timestamptz NOT NULL DEFAULT now()
);

-- Interruptores de módulos por negocio (feature flags)
CREATE TABLE negocio_modulos (
  negocio_id uuid NOT NULL REFERENCES negocios(id) ON DELETE CASCADE,
  modulo     text NOT NULL,                  -- 'reparto', 'cartera', 'produccion', ...
  activo     boolean NOT NULL DEFAULT true,
  PRIMARY KEY (negocio_id, modulo)
);

-- ---------------------------------------------------------------------
-- Miembros: qué usuario (Better Auth) pertenece a qué negocio y con qué rol
-- user_id apunta a la tabla "user" de Better Auth (ver FK al final).
-- ---------------------------------------------------------------------
CREATE TABLE miembros (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  negocio_id  uuid NOT NULL REFERENCES negocios(id) ON DELETE CASCADE,
  user_id     text NOT NULL,
  rol         rol_miembro NOT NULL,
  nombre      text NOT NULL,
  telefono    text,
  activo      boolean NOT NULL DEFAULT true,
  creado_en   timestamptz NOT NULL DEFAULT now(),
  UNIQUE (negocio_id, user_id),
  UNIQUE (negocio_id, id)
);

-- ---------------------------------------------------------------------
-- Clientes
-- ---------------------------------------------------------------------
CREATE TABLE clientes (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  negocio_id      uuid NOT NULL REFERENCES negocios(id) ON DELETE CASCADE,
  nombre          text NOT NULL,
  telefono        text,
  direccion       text,
  barrio          text,
  notas           text,
  datos_extra     jsonb NOT NULL DEFAULT '{}',  -- campos propios de cada tipo de negocio
  activo          boolean NOT NULL DEFAULT true,
  creado_en       timestamptz NOT NULL DEFAULT now(),
  actualizado_en  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (negocio_id, id)
);
CREATE INDEX idx_clientes_telefono ON clientes (negocio_id, telefono);
CREATE INDEX idx_clientes_nombre   ON clientes (negocio_id, nombre);

-- ---------------------------------------------------------------------
-- Productos (ej.: Paca 300 ml, Paca 600 ml, Paca 4 L)
-- precio_unitario = pesos por unidad (paca). 25.000 por 10 pacas = 2.500.
-- ---------------------------------------------------------------------
CREATE TABLE productos (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  negocio_id       uuid NOT NULL REFERENCES negocios(id) ON DELETE CASCADE,
  nombre           text NOT NULL,
  referencia       text,                          -- '300 ml', '600 ml', '4 L'
  precio_unitario  bigint NOT NULL CHECK (precio_unitario >= 0),
  datos_extra      jsonb NOT NULL DEFAULT '{}',
  activo           boolean NOT NULL DEFAULT true,
  creado_en        timestamptz NOT NULL DEFAULT now(),
  actualizado_en   timestamptz NOT NULL DEFAULT now(),
  UNIQUE (negocio_id, id)
);
CREATE INDEX idx_productos_negocio ON productos (negocio_id) WHERE activo;

-- ---------------------------------------------------------------------
-- Pedidos
-- La regla del pedido mínimo (negocios.pedido_minimo_unidades) se valida
-- en la capa de reglas de la API, dentro de la misma transacción que
-- crea el pedido y sus ítems.
-- ---------------------------------------------------------------------
CREATE TABLE pedidos (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  negocio_id         uuid NOT NULL REFERENCES negocios(id) ON DELETE CASCADE,
  cliente_id         uuid NOT NULL,
  repartidor_id      uuid,
  estado             estado_pedido NOT NULL DEFAULT 'pendiente',
  direccion_entrega  text,                        -- copia de la dirección al momento del pedido
  total              bigint NOT NULL DEFAULT 0 CHECK (total >= 0),
  notas              text,
  creado_por         uuid,
  fecha_pedido       timestamptz NOT NULL DEFAULT now(),
  fecha_entrega      timestamptz,
  actualizado_en     timestamptz NOT NULL DEFAULT now(),
  UNIQUE (negocio_id, id),
  FOREIGN KEY (negocio_id, cliente_id)    REFERENCES clientes (negocio_id, id),
  FOREIGN KEY (negocio_id, repartidor_id) REFERENCES miembros (negocio_id, id),
  FOREIGN KEY (negocio_id, creado_por)    REFERENCES miembros (negocio_id, id)
);
CREATE INDEX idx_pedidos_estado     ON pedidos (negocio_id, estado, fecha_pedido DESC);
CREATE INDEX idx_pedidos_repartidor ON pedidos (negocio_id, repartidor_id, estado);
CREATE INDEX idx_pedidos_cliente    ON pedidos (negocio_id, cliente_id, fecha_pedido DESC);

CREATE TABLE pedido_items (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  negocio_id       uuid NOT NULL,
  pedido_id        uuid NOT NULL,
  producto_id      uuid NOT NULL,
  cantidad         integer NOT NULL CHECK (cantidad > 0),
  precio_unitario  bigint NOT NULL CHECK (precio_unitario >= 0),  -- copia del precio al vender
  subtotal         bigint GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
  FOREIGN KEY (negocio_id, pedido_id)   REFERENCES pedidos (negocio_id, id) ON DELETE CASCADE,
  FOREIGN KEY (negocio_id, producto_id) REFERENCES productos (negocio_id, id)
);
CREATE INDEX idx_items_pedido ON pedido_items (pedido_id);

-- Historial de cambios de estado (auditoría)
CREATE TABLE pedido_historial (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  negocio_id       uuid NOT NULL,
  pedido_id        uuid NOT NULL,
  estado_anterior  estado_pedido,
  estado_nuevo     estado_pedido NOT NULL,
  cambiado_por     uuid,
  cambiado_en      timestamptz NOT NULL DEFAULT now(),
  FOREIGN KEY (negocio_id, pedido_id) REFERENCES pedidos (negocio_id, id) ON DELETE CASCADE
);
CREATE INDEX idx_historial_pedido ON pedido_historial (pedido_id, cambiado_en);

-- ---------------------------------------------------------------------
-- Pagos y cartera
-- Un cliente que recibe y no paga queda con saldo (fiado).
-- referencia_externa guarda el id de Stripe o Mercado Pago, nunca datos de tarjeta.
-- ---------------------------------------------------------------------
CREATE TABLE pagos (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  negocio_id          uuid NOT NULL,
  cliente_id          uuid NOT NULL,
  pedido_id           uuid,                       -- opcional: abono general si va vacío
  monto               bigint NOT NULL CHECK (monto > 0),
  metodo              metodo_pago NOT NULL DEFAULT 'efectivo',
  referencia_externa  text,
  nota                text,
  recibido_por        uuid,
  fecha_pago          timestamptz NOT NULL DEFAULT now(),
  FOREIGN KEY (negocio_id, cliente_id)  REFERENCES clientes (negocio_id, id),
  FOREIGN KEY (negocio_id, pedido_id)   REFERENCES pedidos (negocio_id, id),
  FOREIGN KEY (negocio_id, recibido_por) REFERENCES miembros (negocio_id, id)
);
CREATE INDEX idx_pagos_cliente ON pagos (negocio_id, cliente_id, fecha_pago DESC);

-- Saldo por cliente = lo entregado menos lo pagado
CREATE VIEW cartera_clientes AS
SELECT
  c.negocio_id,
  c.id AS cliente_id,
  c.nombre,
  COALESCE(p.total_entregado, 0)                         AS total_entregado,
  COALESCE(g.total_pagado, 0)                            AS total_pagado,
  COALESCE(p.total_entregado, 0) - COALESCE(g.total_pagado, 0) AS saldo
FROM clientes c
LEFT JOIN (
  SELECT cliente_id, SUM(total) AS total_entregado
  FROM pedidos WHERE estado = 'entregado' GROUP BY cliente_id
) p ON p.cliente_id = c.id
LEFT JOIN (
  SELECT cliente_id, SUM(monto) AS total_pagado
  FROM pagos GROUP BY cliente_id
) g ON g.cliente_id = c.id;

-- ---------------------------------------------------------------------
-- Archivos (Cloudflare R2): aquí solo la dirección y a quién pertenecen
-- ---------------------------------------------------------------------
CREATE TABLE archivos (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  negocio_id   uuid NOT NULL REFERENCES negocios(id) ON DELETE CASCADE,
  clave_r2     text NOT NULL UNIQUE,             -- ruta del objeto en el bucket
  tipo_mime    text,
  tamano_bytes bigint,
  subido_por   uuid,
  creado_en    timestamptz NOT NULL DEFAULT now(),
  FOREIGN KEY (negocio_id, subido_por) REFERENCES miembros (negocio_id, id)
);

-- ---------------------------------------------------------------------
-- Triggers
-- ---------------------------------------------------------------------

-- 1) actualizado_en automático
CREATE FUNCTION tocar_actualizado_en() RETURNS trigger AS $$
BEGIN
  NEW.actualizado_en := now();
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_negocios_upd  BEFORE UPDATE ON negocios  FOR EACH ROW EXECUTE FUNCTION tocar_actualizado_en();
CREATE TRIGGER trg_clientes_upd  BEFORE UPDATE ON clientes FOR EACH ROW EXECUTE FUNCTION tocar_actualizado_en();
CREATE TRIGGER trg_productos_upd BEFORE UPDATE ON productos FOR EACH ROW EXECUTE FUNCTION tocar_actualizado_en();
CREATE TRIGGER trg_pedidos_upd   BEFORE UPDATE ON pedidos   FOR EACH ROW EXECUTE FUNCTION tocar_actualizado_en();

-- 2) Al cambiar de estado: fecha de entrega + historial
--    La API puede indicar quién hizo el cambio con:
--    SELECT set_config('app.miembro_id', '<uuid>', true);
CREATE FUNCTION registrar_cambio_estado() RETURNS trigger AS $$
BEGIN
  IF NEW.estado IS DISTINCT FROM OLD.estado THEN
    IF NEW.estado = 'entregado' AND NEW.fecha_entrega IS NULL THEN
      NEW.fecha_entrega := now();
    END IF;
    INSERT INTO pedido_historial (negocio_id, pedido_id, estado_anterior, estado_nuevo, cambiado_por)
    VALUES (NEW.negocio_id, NEW.id, OLD.estado, NEW.estado,
            NULLIF(current_setting('app.miembro_id', true), '')::uuid);
  END IF;
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_pedidos_estado
  BEFORE UPDATE ON pedidos
  FOR EACH ROW EXECUTE FUNCTION registrar_cambio_estado();

-- 3) Tiempo real: avisa a la API (LISTEN pedidos_cambio) cuando un pedido cambia
CREATE FUNCTION notificar_pedido() RETURNS trigger AS $$
BEGIN
  PERFORM pg_notify('pedidos_cambio', json_build_object(
    'negocio_id', NEW.negocio_id,
    'pedido_id',  NEW.id,
    'estado',     NEW.estado
  )::text);
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_pedidos_notificar
  AFTER INSERT OR UPDATE ON pedidos
  FOR EACH ROW EXECUTE FUNCTION notificar_pedido();

-- ---------------------------------------------------------------------
-- Datos iniciales: plantillas por tipo de negocio
-- ---------------------------------------------------------------------
INSERT INTO tipos_negocio (codigo, nombre, modulos) VALUES
  ('agua',          'Fábrica de agua',      '["pedidos","reparto","cartera","produccion"]'),
  ('tienda',        'Tienda / Miscelánea',  '["ventas","inventario","cartera"]'),
  ('panaderia',     'Panadería',            '["ventas","inventario","produccion"]'),
  ('comida_rapida', 'Comida rápida',        '["ventas","comandas","mesas"]');

COMMIT;

-- ---------------------------------------------------------------------
-- EJECUTAR DESPUÉS de que Better Auth haya creado su tabla "user":
-- ---------------------------------------------------------------------
-- ALTER TABLE miembros
--   ADD CONSTRAINT miembros_user_fk
--   FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;

-- ---------------------------------------------------------------------
-- EJEMPLO: dar de alta la empresa de agua (ajusta el nombre y el slug)
-- ---------------------------------------------------------------------
-- WITH n AS (
--   INSERT INTO negocios (tipo_negocio_id, nombre, slug, pedido_minimo_unidades)
--   SELECT id, 'Mi empresa de agua', 'mi-empresa-de-agua', 10
--   FROM tipos_negocio WHERE codigo = 'agua'
--   RETURNING id
-- )
-- INSERT INTO productos (negocio_id, nombre, referencia, precio_unitario)
-- SELECT n.id, v.nombre, v.ref, 2500
-- FROM n, (VALUES ('Paca 300 ml','300 ml'), ('Paca 600 ml','600 ml'), ('Paca 4 L','4 L')) AS v(nombre, ref);
