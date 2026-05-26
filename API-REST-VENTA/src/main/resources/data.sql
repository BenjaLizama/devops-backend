DELETE FROM venta;

INSERT IGNORE INTO venta (
  id_venta,
  direccion_compra,
  valor_compra,
  fecha_compra,
  despacho_generado
) VALUES
(1, 'Av. Siempre Viva 123', 25990, '2026-05-25', false),
(2, 'Los Carrera 456', 49990, '2026-05-25', true),
(3, 'Brasil 789', 12990, '2026-05-25', false);12990, '2026-05-25', false);