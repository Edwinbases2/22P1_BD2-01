/*
Cree el procedimiento almacenado "sp_procesar_factura " que registre el proceso de facturación: 
Registra un producto de acuerdo un numero de factura en la tabla ítems factura.
Actualiza los valores de la factura con los valores totales
*/

 # Crear procedimiento 
DELIMITER //
CREATE  PROCEDURE  bd_sample.sp_procesar_factura (
	in p_id_factura 		int, 
    in p_fecha_emision 		datetime,
    in p_id_subscriptor		int,
    in p_numero_items 		int,
	in p_isv_total 		decimal(12,2),
    in p_subtotal		decimal(12,2),
    in p_totapagar 		decimal(12,2),
    in p_cantidad 		int,
    in p_idproducto     int
 )
BEGIN 
    #definir variables 
	declare  v_id_factura 			int; 
	declare  v_fecha_emision 		datetime; 
	declare  v_id_subscriptor		int;
	declare  v_numero_items 		int; 
    declare  v_isv_total 			decimal(12,2); 
	declare  v_subtotal				decimal(12,2); 
	declare  v_totapagar 			decimal(12,2);
    declare  v_cantidad				int;
	declare  v_idproducto 			int; 
    declare  v_precio_venta 		decimal(12,2);     
    
    #asignar valores de parametros a variables 
   set v_id_factura 			= p_id_factura;
	set v_fecha_emision			= CURRENT_TIMESTAMP; 
    set v_id_subscriptor		= p_id_subscriptor;
    set v_numero_items			= p_numero_items;
	set v_isv_total				= p_subtotal; 
    set v_subtotal				= p_subtotal;
    set v_totapagar				= p_totapagar;
	set v_cantidad				= p_cantidad;
    set v_idproducto			= p_idproducto;
    set v_precio_venta			= p_precio_prod;
	
        # ingresar producto a la factura #
       insert into bd_sample.tbl_items_factura(
		 id_factura, id_producto, cantidad
    ) values ( v_id_factura, v_id_producto, v_cantidad );
    
    select sum(p_cantidad) into p_numero_items 
    from bd_sample.tbl_items_factura
    where id_factura = @v_id_factura;
    
select precio_venta into p_precio_prod  
    from bd_sample.tbl_productos 
    where p_id_factura = p_idproducto; 
 #Actualizar Factura
update bd_sample.tbl_facturas 
		set v_numero_items = p_numero_items,
			isv_total = (p_precio_prod * p_numero_items)*0.15, 
            subtotal  =  p_precio_prod * p_numero_items,
            totapagar = (p_precio_prod * p_numero_items)*1.15
		 where id_factura =  v_id_factura;
	
    commit;
 END; 
 
 # Ejecutar procedimiento 
CALL bd_sample.sp_procesar_factura(
	#0, 			# p_id_factura
	0,				# (p_fecha_emision)
    4,				# p_id_subscriptor
    4,				# p_numero_items
	0,				# p_isv_total 
    0,				# p_subtotal
    0,				# p_totapagar
    4,				# p_cantidad 
	0,				# p_idproducto
	
      );