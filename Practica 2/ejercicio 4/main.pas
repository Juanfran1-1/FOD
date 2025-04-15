program ejercicio4;
const
    valoralto= 9999;
    dimf = 3;
type 
    producto = record 
        codigo:integer;
        nombre:string;
        descripcion:string;
        stockd:integer;
        stockm:integer;
        precio:real;
    end;

    ventas = record 
        codigo : integer;
        cant:integer;
    end;

    maestro = file of producto;
    detalle = file of ventas;

    vecdet = array [1..dimf] of detalle;
    vecregdet = array [1..dimf] of ventas;

procedure importarmaestro(var mae:maestro);
var 
    p:producto;
    txt:Text;
begin 
    Assign(txt,'maestro.txt');
    Assign(mae,'maestro.dat');
    Reset(txt);
    Rewrite(mae);
    while not eof(txt) do begin
        readln(txt,p.codigo,p.stockd,p.stockm,p.precio,p.nombre);
        readln(txt,p.descripcion);
        write(mae,p);
    end;
    close(mae);
    close(txt);
end;

procedure leerdetalle(var det:detalle; var v:ventas);
begin 
    if (not eof(det)) then 
        read(det,v)
    else 
        v.codigo := valoralto;
end;

procedure importardetalle(var det:detalle; i:integer);
var 
    txt2:Text;
    v:ventas;
begin 
    case i of 
        1: begin Assign(det,'detalle1.dat'); Assign(txt2,'detalle1.txt'); end;
        2: begin Assign(det,'detalle2.dat'); Assign(txt2,'detalle2.txt'); end;
        3: begin Assign(det,'detalle3.dat'); Assign(txt2,'detalle3.txt'); end;
    end;
    Reset(txt2);
    Rewrite(det);
    while not eof(txt2) do begin
        readln(txt2,v.codigo,v.cant);
        write(det,v);
    end;
    close(det);
    close(txt2);
end;    

procedure cargarvector(var vd:vecdet);
var 
    i:integer;
begin 
    for i:= 1 to dimf do 
        importardetalle(vd[i],i);
end;

procedure Merge(var vd:vecdet;var vecreg:vecregdet;var min: ventas);
var 
    i,pos:integer;
begin 
    min.codigo := valoralto;
    for i := 1 to dimf do begin 
        if (vecreg[i].codigo < min.codigo) then begin 
            min := vecreg[i];
            pos := i;
        end;
    end;
    if min.codigo <> valoralto then begin 
        leerdetalle(vd[pos],vecreg[pos]);
    end;
end;

procedure actualizarmaestro(var mae:maestro; var vecd:vecdet ;var vecreg:vecregdet);
var 
    p:producto;
    min:ventas;
    act,tot,i:integer;
begin 
    Reset(mae); 
    read(mae,p);
    for i:= 1 to dimf do begin 
        Reset(vecd[i]);
        leerdetalle(vecd[i],vecreg[i]);
    end;
    Merge(vecd,vecreg,min);
    while(min.codigo <> valoralto) do begin 
        act:= min.codigo;
        tot:= 0;
        while (act = min.codigo) do begin 
            tot:= tot + min.cant;
            Merge(vecd,vecreg,min);
        end;
        while (p.codigo <> act) do begin 
            read(mae,p);
        end;
        p.stockd:= p.stockd - tot;
        seek(mae, FilePos(mae) - 1); 
        write(mae,p);
        if (not eof(mae)) then 
            read(mae,p);
    end;
    for i:= 1 to dimf do 
        close(vecd[i]);
    close(mae);
end;
    
procedure exportarstocks(var mae:maestro);
var 
    p:producto;
    txt:Text;
begin 
    Assign(txt,'stocks.txt');
    Rewrite(txt);
    Reset(mae);
    while not eof(mae) do begin 
        read(mae,p);
        if (p.stockd < p.stockm) then begin 
            writeln(txt,p.stockd,p.nombre);
            writeln(txt,p.precio:2:2,p.descripcion);
        end;
    end;    
    close(mae);
    close(txt);
end;    

procedure imprimirProducto(p : producto);
begin
	writeln('Codigo= ', p.codigo, ' precio= ', p.precio:0:2, ' stock disponible ', p.stockd, ' stock minimo ', p.stockm, ' nombre ', p.nombre, ' descripcion ', p.descripcion);
end;
		
procedure imprimirMaestro(var mae : maestro);
var
	p : producto;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, p);
		imprimirProducto(p);
	end;
	close(mae);
end;

var 
    mae:maestro;
    vecd:vecdet;
    vecreg:vecregdet;
begin 
    writeln('===INICIO ===');
    importarmaestro(mae);
    writeln('El archivo maestro fue creado con exito');
    cargarvector(vecd);
    writeln('Los archivos de detalle fueron creados con exito');
    actualizarmaestro(mae,vecd,vecreg);
    writeln('El archivo maestro fue actualizado con exito');
    exportarstocks(mae);
    writeln('El archivo maestro es: ');
    imprimirMaestro(mae);
end.    
