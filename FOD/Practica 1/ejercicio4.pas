program e4_p1;
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

function cumple(var empleados:archivo;x:integer):boolean;
var
    encontrado:boolean;
    e:empleado;
begin
    encontrado:= false;
    while(not eof(empleados) and not encontrado) do begin
        read(empleados,e);
        if (e.nro = x) then 
            encontrado:= true;
    end;
    cumple:= not encontrado;
end;

procedure a4(var empleados:archivo);
var 
    e:empleado;
    seguir:integer;
begin 
    seguir:= 1;
    reset(empleados);
    while(seguir <> 0) do begin
        leerEmpleado(e);
        if (cumple(empleados,e.nro)) then begin
            seek(empleados,filesize(empleados));
            write(empleados,e);
        end    
        else 
            writeln('Ya existe un empleado con ese numero');
        writeln('Desea seguir agregando empleados? 0 para no, 1 para si');
        readln(seguir);
    end;        
    close(empleados);
end;


procedure b4(var empleados:archivo);
var 
    e:empleado;
    edad,num:integer;
    encontrado:boolean;
begin 
    encontrado:= false;
    writeln('Ingrese el numero de empleado a modificar');
    readln(num);    
    reset(empleados);
    while (not eof(empleados) and not encontrado) do begin 
        read(empleados,e);
        if (e.nro = num) then begin 
            encontrado:= true;
            writeln('Ingrese la nueva edad del empleado');
            readln(edad);
            e.edad:= edad;
            seek(empleados,filepos(empleados)-1);
            write(empleados,e);
        end;
    end;
    if (not encontrado) then 
        writeln('No se encontro el empleado');
    close(empleados);
end;


procedure c4(var empleados:archivo);
var 
    e:empleado;
    txt:text;
begin
    assign(txt,'todos_empleados.txt');
    rewrite(txt);
    reset(empleados);
    while (not eof(empleados)) do begin 
        read(empleados,e);
        writeln(txt,'-Apellido: ', e.apellido , ' - Nombre: ', e.nombre, ' - Edad: ', e.edad, ' - Dni: ', e.dni, ' - Numero de empleado: ', e.nro);
    end;
    writeln('Archivo exportado con exito');
    close(txt);
    close(empleados);
end;


procedure d4(var empleados:archivo);
var 
    e:empleado;
    dnicero:text;
begin 
    assign(dnicero,'faltaDNIEmpleado.txt');
    rewrite(dnicero);
    reset(empleados);
    while (not eof(empleados)) do begin 
        read(empleados,e);
        if (e.dni = 00) then 
            writeln(dnicero,'-Apellido: ', e.apellido , ' - Nombre: ', e.nombre, ' - Edad: ', e.edad, ' - Dni: ', e.dni, ' - Numero de empleado: ', e.nro);
    end;
    writeln('Archivo exportado con exito');
    close(dnicero);
    close(empleados);
end;    


procedure menu(var empleados:archivo);
var 
    opcion:char;
begin
    opcion:= ' ';
    while (opcion <> 'z') do begin
        writeln('a) Cargar empleados');
        writeln('b) Buscar empleado por apellido o nombre');
        writeln('c) Listar empleados');
        writeln('d) Listar empleados proximos a jubilarse');
        writeln('e) Agregar empleado/s');   
        writeln('f) Modificar edad de empleado');
        writeln('g) Exportar lista de empleados a archivo .txt llamado "todos_empleados.txt"');
        {writeln('y) Exportar a un archivo de texto llamado "faltaDNIEmpleado.txt", DNI(00)');}
        writeln('z) Salir');
        readln(opcion);
        case opcion of 
            'a': cargarEmpleados(empleados);
            'b': b1(empleados);
            'c': b2(empleados);
            'd': b3(empleados);
            'e': a4(empleados);
            'f': b4(empleados);
            'g': c4(empleados);
            'z': writeln('CIERRE');
        end;    
    end;    
end;


var
    empleados:archivo;
begin
    assign(empleados,'empleados');
    menu(empleados);
end.