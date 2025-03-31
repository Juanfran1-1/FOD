program e7_p1;
type 
    novela = record 
        codigo:integer;
        nombre:string;
        genero:string;
        precio:real;
    end;

    archivo = file of novela;

procedure asignar(var novelas:archivo);
var 
    nomfis: string;
begin 
    writeln('Ingrese nombre del archivo: ');
    readln(nomfis);
    assign(novelas,nomfis);    
end;

procedure cargardatos(var novelas:archivo);
var 
    txt:text;
    n:novela;
begin 
    asignar(novelas);
    writeln('IMPORTANDO DATOS DESDE ARCHIVO TXT');
    assign(txt, 'novelas.txt');
    reset(txt);
    rewrite(novelas);
    while (not eof(txt)) do begin 
        readln(txt, n.codigo, n.precio, n.genero);
        readln(txt, n.nombre);
        write(novelas,n);
    end;
    writeln('IMPORTADOS.');
    close(txt);
    close(novelas);
end;

procedure leernovela(var n:novela);
begin 
    writeln('Ingres nombre de la novela:');readln(n.nombre);
    writeln('Ingres codigo de la novela:');readln(n.codigo);
    writeln('Ingres precio de la novela:');readln(n.precio);
    writeln('Ingres genero de la novela:');readln(n.genero);
end;    

procedure agregarnovela(var novelas:archivo);
var 
    n:novela;
begin 
    leernovela(n);
    reset(novelas);
    seek(novelas,filesize(novelas));
    write(novelas,n);
    close(novelas);
end;

procedure modificarprecio(var novelas:archivo);
var 
    precionuevo:real;
    codigobuscado:integer;
    n:novela;
    encontrado:boolean;
begin 
    writeln('INGRESE CODIGO DE LA PELICULA A MODIFICAR: ');
    readln(codigobuscado);
    reset(novelas);
    encontrado := false;
    while((not eof(novelas)) and (not encontrado)) do begin 
        read(novelas,n);
        if codigobuscado = n.codigo then begin 
            encontrado:= true;
            writeln('Ingrese nuevo precio:');
            readln(precionuevo);
            n.precio:= precionuevo;
            seek(novelas,filepos(novelas)-1);
            write(novelas,n);
        end;
    end;
    if encontrado then 
        writeln('MODIFICACION HECHA.')
    else 
        writeln('CODIGO NO ENCONTRADO.');
    close(novelas);
end;

procedure modificarnombre(var novelas:archivo);
var 
    nombrenuevo:string;
    codigobuscado:integer;
    n:novela;
    encontrado:boolean;
begin 
    writeln('INGRESE CODIGO DE LA PELICULA A MODIFICAR: ');
    readln(codigobuscado);
    reset(novelas);
    encontrado := false;
    while((not eof(novelas)) and (not encontrado)) do begin 
        read(novelas,n);
        if codigobuscado = n.codigo then begin 
            encontrado:= true;
            writeln('Ingrese nuevo nombre:');
            readln(nombrenuevo);
            n.nombre:= nombrenuevo;
            seek(novelas,filepos(novelas)-1);
            write(novelas,n);
        end;
    end;
    if encontrado then 
        writeln('MODIFICACION HECHA.')
    else 
        writeln('CODIGO NO ENCONTRADO.');
    close(novelas);
end;

procedure modificargenero(var novelas:archivo);
var 
    generonuevo:string;
    codigobuscado:integer;
    n:novela;
    encontrado:boolean;
begin 
    writeln('INGRESE CODIGO DE LA PELICULA A MODIFICAR: ');
    readln(codigobuscado);
    reset(novelas);
    encontrado := false;
    while((not eof(novelas)) and (not encontrado)) do begin 
        read(novelas,n);
        if codigobuscado = n.codigo then begin 
            encontrado:= true;
            writeln('Ingrese nuevo genero:');
            readln(generonuevo);
            n.genero:= generonuevo;
            seek(novelas,filepos(novelas)-1);
            write(novelas,n);
        end;
    end;
    if encontrado then 
        writeln('MODIFICACION HECHA.')
    else 
        writeln('CODIGO NO ENCONTRADO.');
    close(novelas);
end;

procedure menu_modificaciones(var novelas:archivo);
var 
    opcion:integer;
begin  
    opcion:= 5;
    while (opcion <> 4) do begin 
        writeln('ELIJA UNA OPCION:');
        writeln('1) Modificar precio ');
        writeln('2) Modificar nombre ');
        writeln('3) Modificar genero ');
        writeln('4) Retroceder');
        readln(opcion);
        case opcion of 
            1: modificarprecio(novelas);
            2: modificarnombre(novelas);
            3: modificargenero(novelas)
            else writeln('OPCION INVALIDA');
        end;
    end; 
end;           

procedure menu_opciones(var novelas:archivo);
var 
    opcion:char;
begin 
    opcion:='z';
    while (opcion <> 'c') do begin 
        writeln('------MENU------');
        writeln('a) Agregar novela');
        writeln('b) Menu de modificaciones ');
        writeln('c) Cerrar ');
        readln(opcion);
        case opcion of 
            'a': agregarnovela(novelas);
            'b': menu_modificaciones(novelas);
            'c': writeln('CERRANDO.')
            else writeln('OPCION INVALIDA');
        end;
    end;    
end;            

var 
    novelas:archivo;
begin 
    cargardatos(novelas);
    menu_opciones(novelas);
end.


