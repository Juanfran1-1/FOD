program ejercicio5;
const
	dimf = 3; // = 5;
	valorAlto = 9999;
type
	rango = 1..dimf;
	
	sesion = record
		codigo : integer;
		fecha : string[20];
		tiempo : real;
	end;
	
	detalle = file of sesion;
	maestro = file of sesion;
	
	vectorD = array[rango] of detalle;
	vectorR = array[rango] of sesion;
	
procedure importarDetalle(var d:detalle;i:integer);
var 
    s:sesion;
    txt:text;
begin
    case i of
        1: begin assign(txt,'detalle1.txt'); assign(d,'detalle1.dat') end;
        2: begin assign(txt,'detalle2.txt'); assign(d,'detalle2.dat') end;
        3: begin assign(txt,'detalle3.txt'); assign(d,'detalle3.dat') end;
    end;
    reset(txt);
    rewrite(d);
    while (not eof(txt)) do begin 
        readln(txt,s.codigo,s.tiempo,s.fecha);
        write(d,s);
    end;
    close(txt);
    close(d);
end;

procedure cargarVectorDetalles(var vd : vectorD);
var
	i : rango;
begin
	for i := 1 to dimf do
		importarDetalle(vd[i],i);
end;

procedure leer(var det: detalle; var regD: sesion);
begin
    if (not eof(det)) then
        read(det, regD)
    else 
        regD.codigo := valorAlto;
end;
 
procedure minimo(var vd : vectorD; var vr : vectorR; var min : sesion);
var
	i, pos : integer;
begin
	min.codigo := valorAlto;
	min.fecha := 'ZZZZ';
	for i := 1 to dimf do begin
		if (vr[i].codigo <= min.codigo) then begin
			min := vr[i];
			pos := i;
		end;
	end;
	if(min.codigo <> valorAlto)then
		leer(vd[pos], vr[pos]);
end; 

 procedure crearMaestro(var mae : maestro; var vd : vectorD);
 var
	min, dato : sesion;
	vr : vectorR;
	i: integer;
 begin
	assign(mae, 'maestro.dat');
	rewrite(mae);
	for i := 1 to dimf do begin
		reset(vd[i]);
		leer(vd[i], vr[i]);
	end;
	minimo(vd, vr, min);
	while(min.codigo <> valorAlto)do begin
		dato.codigo := min.codigo;
		while(min.codigo = dato.codigo)do begin
			dato.fecha := min.fecha;
			dato.tiempo := 0;
			while(min.codigo = dato.codigo) and (min.fecha = dato.fecha)do begin
				dato.tiempo := dato.tiempo + min.tiempo;
				minimo(vd, vr, min);
			end;
			write(mae, dato);
		end;
	end;
	close(mae);
	writeln('Archivo maestro creado'); 
	for i := 1 to dimf do
		close(vd[i]);
 end; 
 
 procedure imprimirSesion(s : sesion);
 begin
	writeln('Codigo de usuario ', s.codigo, ' fecha ', s.fecha, ' tiempo total ', s.tiempo:0:2);
 end;

procedure imprimirMaestro(var mae : maestro);
var
	s : sesion;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, s);
		imprimirSesion(s);
	end;
	close(mae);
end;

var
	vd : vectorD;
	mae : maestro;
begin
	cargarVectorDetalles(vd);
	crearMaestro(mae, vd);
	imprimirMaestro(mae);
end.