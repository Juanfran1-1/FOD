program e6_p1;
type 
    celular = record 
        codigo:integer;
        nombre:string;
        descripcion:string;
        marca:string;
        precio:real;
        stockm:integer;
        stocka:integer;
    end;

    archivo = file of celular;

procedure asignarArchivo(var celulares:archivo);
var 
    nombrefis:string;
begin 
    writeln('Ingrese el nombre del archivo');
    readln(nombrefis);
    assign(celulares,nombrefis);
end;

procedure a5(var celulares:archivo);
var 
    cel:celular;
    txt:text;
begin 
    rewrite(celulares); {crea el archivo de celulares}
    assign(txt,'celulares.txt');    {abre archivo de texto con los celulares cargados}
    writeln('paso');
    reset(txt);
    writeln('paso');
    while not (eof(txt)) do begin 
        readln(txt,cel.codigo,cel.precio,cel.marca);
        readln(txt,cel.stocka,cel.stockm,cel.descripcion);
        readln(txt,cel.nombre);
        write(celulares,cel);
    end;
    close(celulares);
    close(txt);
end;

procedure leercelular(cel:celular);
begin    
    writeln('Codigo: ',cel.codigo);
    writeln('Nombre: ',cel.nombre);
    writeln('Descripcion: ',cel.descripcion);
    writeln('Marca: ',cel.marca);
    writeln('Precio: ',cel.precio:0:2);
    writeln('Stock minimo: ',cel.stockm);
    writeln('Stock actual: ',cel.stocka);
end;

procedure b5(var celulares:archivo);
var 
    cel:celular;
begin
    reset(celulares);
    while ( not eof(celulares)) do begin 
        read(celulares,cel);
        if (cel.stocka < cel.stockm) then 
            leercelular(cel);
    end;
    close(celulares);
end;

procedure c5(var celulares:archivo);
var 
    c:celular;
    descrip:string;
begin 
    reset(celulares);
    writeln('INGRESE UNA DESCRIPCION A BUSCAR EN EL ARCHIVO: ');read(descrip);
    while (not eof(celulares)) do begin 
        read(celulares,c);
        if (c.descripcion = descrip) then 
            leercelular(c);
    end;
    close(celulares);
end;

procedure d5(var celulares:archivo);
var 
    txt:text;
    c:celular;
begin 
    assign(txt,'celulares.txt');
    rewrite(txt);
    reset(celulares);
    while(not eof(celulares)) do begin 
        read(celulares,c);
        writeln(txt, c.codigo, ' ', c.precio:2:2, ' ', c.marca);  
		writeln(txt, c.stocka, ' ', c.stockm, ' ', c.descripcion); 
		writeln(txt, c.nombre);
    end;
    close(txt);
    close(celulares);
end;

procedure cargarcelular(c:celular);
begin 
    writeln('Ingrese codigo: ');readln(c.codigo);
    writeln('Nombre: ');readln(c.nombre);
    writeln('Descripcion: ');readln(c.descripcion);
    writeln('Marca: ');readln(c.marca);
    writeln('Precio: ');readln(c.precio);
    writeln('Stock minimo: ');readln(c.stockm);
    writeln('Stock actual: ');readln(c.stocka);
end;

procedure a6(var celulares:archivo);
var 
    c:celular;
    seguir:integer;
begin 
    reset(celulares);
    seguir := 1;
    seek(celulares,filesize(celulares));
    cargarcelular(c);
    while (seguir <> 0) do begin
        write(celulares,c);
        writeln('ingrese 1 si quiere añadir un celular nuevo o 0 si quiere terminar el proceso:');read(seguir);
        cargarcelular(c);
    end;
    reset(celulares);
end;

procedure b6(var celulares:archivo);
var 
    c:celular;
    stock:integer;
    nombre: string;
    found : boolean;
begin 
    found := false;
    writeln('Ingrese el nombre del celular a modificar: ');
    readln(nombre);
    writeln('Ingrese el cantidad: ');readln(stock);
    reset(celulares);
    while ((not eof(celulares)) and (not found)) do begin 
        read(celulares,c);
        if (c.nombre = nombre) then begin 
            found:= true;
            c.stocka:= stock;
            seek(celulares,filepos(celulares)-1);
            write(celulares,c);
        end;
    end;
    close(celulares);
end;

procedure c6(var celulares:archivo);
var 
    txt:text;
    c:celular;
begin
    assign(txt,'SinStock.txt');
	rewrite(txt);
	reset(celulares);
    while (not eof(celulares)) do begin 
        read(celulares, c);
		if(c.stocka = 0)then begin
			writeln(txt, c.codigo, ' ', c.precio:2:2, ' ', c.marca);  
			writeln(txt, c.stocka, ' ', c.stockm, ' ', c.descripcion); 
			writeln(txt, c.nombre);
		end;
	end;
	close(txt);
	close(celulares); 
end;   


procedure menu(var celulares:archivo);
var 
    opcion:char;
begin 
    opcion:= 'y';
    while (opcion <> 'z') do begin 
        writeln('------MENU OPCIONES------');
        writeln('a) Crear archivo ');
        writeln('b) Mostrar celulares con stock menor al minimo');
        writeln('c) Mostrar celulares con una descripcion pedida');
        writeln('d) Exportar a archivo txt');
        writeln('e) Añadir celulares');
        writeln('f) Modificar stock de celular');
        writeln('g) Exportar a ”SinStock.txt” aquellos celulares sin stock ');
        read(opcion);
        case opcion of
            'a': a5(celulares);
            'b': b5(celulares);
            'c': c5(celulares);
            'd': d5(celulares);
            'e': a6(celulares);
            'f': b6(celulares);
            'g': c6(celulares);
            else 
                writeln('OPCION INVALIDA');
        end;
    end;
    writeln('PROGRAMA FINALIZADO');
end;

var 
    celulares:archivo;
begin 
    asignarArchivo(celulares);
    menu(celulares);
end.

