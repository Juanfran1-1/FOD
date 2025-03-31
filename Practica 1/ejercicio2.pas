program e2_p1;
type
    numeros_enteros = file of integer;

var
    numeros: numeros_enteros;
    nombre_archivo: string;
    num: integer;
    suma: integer;
    promedio: integer;
    cant:integer;
    total: integer;

begin
    cant:= 0; promedio:= 0; suma:= 0; total:= 0;
    writeln ('Ingrese el nombre del archivo a listar: ');
    read(nombre_archivo);
    Assign(numeros,nombre_archivo);
    Reset (numeros);
    writeln ('Los numeros menores a 1500 son: ');
    while (not EOF(numeros)) do begin
        total:= total + 1;
        read(numeros,num);
        if (num<1500) then begin
            cant:= cant + 1;
            suma:= suma + num;
            writeln(num);
        end;
    end;
    close(numeros);
    writeln('--------------cantidad de num <1500----------');
    writeln(cant);
    writeln('-------------promedio-----------');
    promedio:= suma div cant;
    writeln(promedio);
    writeln('------------------------');
END.