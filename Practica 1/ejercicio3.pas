program e3_p1;
type 
    empleado= record 
        edad,dni,nro:integer;
        nombre,apellido:string;
    end;

    archivo = file of empleado;    


procedure leerEmpleado(var e:empleado);
begin 
    writeln('Ingrese el apellido del empleado');
    readln(e.apellido);
    if (e.apellido <> 'fin') then begin
        writeln('Ingrese el nombre del empleado');
        readln(e.nombre);
        writeln('Ingrese la edad del empleado');
        readln(e.edad);
        writeln('Ingrese el dni del empleado');
        readln(e.dni);
        writeln('Ingrese el numero de empleado');
        readln(e.nro);
    end;
end;

procedure listarempleado(e:empleado);
begin 
    writeln('Apellido: ',e.apellido);
    writeln('Nombre: ',e.nombre);
    writeln('Edad: ',e.edad);
    writeln('Dni: ',e.dni);
    writeln('Numero de empleado: ',e.nro);
end;


procedure cargarEmpleados(var empleados:archivo);
var 
    e:empleado;
begin
    rewrite(empleados);
    leerEmpleado(e);
    while (e.apellido <> 'fin') do begin
        write(empleados,e);
        leerEmpleado(e);
    end;
    close(empleados);
end;

procedure b1(var empleados:archivo);
var 
    e:empleado;
    buscado:string;
begin 
    writeln('Ingrese el apellido o nombre del empleado a buscar');
    readln(buscado);
    reset(empleados);
    while (not eof(empleados)) do begin
        read(empleados,e);
        if (e.apellido = buscado) or (e.nombre = buscado) then 
        begin
            listarempleado(e);
        end;
    end;
    close(empleados);
end;    

procedure b2(var empleados:archivo);
var 
    e:empleado;
begin
    writeln('lista de empleados');
    reset(empleados);
    while (not eof(empleados)) do begin
        read(empleados,e);
        listarempleado(e);
    end;
    close(empleados);
end;

procedure b3(var empleados:archivo);
var 
    e:empleado;
begin 
    writeln('LISTA DE EMPLEADOS PROXIMOS A JUBILARSE');
    reset(empleados);
    while (not eof(empleados)) do begin
        read(empleados,e);
        if (e.edad >= 70) then 
            listarempleado(e);
    end;    
    close(empleados);
end;

procedure menu(var empleados:archivo);
var 
    opcion:char;
begin
    opcion:= ' ';
    while (opcion <> 'e') do begin
        writeln('a) Cargar empleados');
        writeln('b) Buscar empleado por apellido o nombre');
        writeln('c) Listar empleados');
        writeln('d) Listar empleados proximos a jubilarse');
        writeln('e) Salir');   
        readln(opcion);
        case opcion of 
            'a': cargarEmpleados(empleados);
            'b': b1(empleados);
            'c': b2(empleados);
            'd': b3(empleados);
        end;    
    end;    
end;

var
    empleados:archivo;
begin
    assign(empleados,'empleados');
    menu(empleados);
end.