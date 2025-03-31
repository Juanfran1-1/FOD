program e1_p1;
type 
    archivo = file of integer;
var 
    numeros: archivo;
    nro:integer;
    nomfis:string[12];
begin
    writeln('INGRESE NOMBRE DEL ARCHIVO: ');read(nomfis);
    assign(numeros,nomfis);
    rewrite(numeros);
    writeln('INGRESE NUMERO: ');
    read(nro);
    while nro <> 30000 do begin
        write(numeros,nro);
        writeln('INGRESE NUMERO: ');
        read(nro);
    end;
    close(numeros);
    reset(numeros);
    while not EOF(numeros) do begin
        read(numeros,nro);
        writeln(nro);
    end;
    close(numeros);
end.

