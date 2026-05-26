DELETE FROM venta;

INSERT INTO venta (
    direccion_compra,
    valor_compra,
    fecha_compra,
    despacho_generado
) VALUES
      ('Av. Siempre Viva 123', 25990, '2026-05-25', false),
      ('Los Carrera 456', 49990, '2026-05-25', true),
      ('Brasil 789', 12990, '2026-05-25', false);