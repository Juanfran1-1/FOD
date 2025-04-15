{Suponga que usted es administrador de un servidor de correo electrónico. En los logs del
mismo (información guardada acerca de los movimientos que ocurren en el server) que se
encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.

a. Realice el procedimiento necesario para actualizar la información del log en un
día particular. Defina las estructuras de datos que utilice su procedimiento.

b. Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:
nro_usuarioX…………..cantidadMensajesEnviados
………….
nro_usuarioX+n………..cantidadMensajesEnviados

Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema. Considere la implementación de esta opción de las
siguientes maneras:

i- Como un procedimiento separado del punto a).

ii- En el mismo procedimiento de actualización del punto a). Qué cambios
se requieren en el procedimiento del punto a) para realizar el informe en
el mismo recorrido?}


program ejercicio13;
const
    valoralto = 9999;
type 
    regmae = record 
        nro:integer;
        nomusu:string;
        nombre:string;
        apellido:string;
        cant:integer;
    end;

    regdet = record 
        nro:integer;
        cuenta:string;
        cuerpo:string;
    end;

    maestro = file of regmae;
    detalle = file of regdet;

procedure importarmaestro(var mae:maestro);
var 
    r:regmae;
    txt:Text;
begin 
    assign(txt,'maestro.txt');
    assign(mae,'maestro.dat');
    reset(txt);
    rewrite(mae);
    while ( not eof(txt)) do begin 
        readln(txt,r.nro,r.cant,r.nomusu);
        readln(txt,r.nombre);
        readln(txt,r.apellido);
        write(mae,r);
    end;
    close(txt);
    close(mae);
end;

procedure importardetalle(var det:detalle);
var 
    r:regdet;
    txt2:Text;
begin 
    assign(txt2,'detalle.txt');
    assign(det,'detalle.dat');
    reset(txt2);
    rewrite(det);
    while ( not eof(txt2)) do begin 
        readln(txt2,r.nro,r.cuenta);
        readln(txt2,r.cuerpo);
        write(det,r);
    end;
    close(txt2);
    close(det);
end;

procedure leer(var det:detalle;var r:regdet);
begin 
    if (not eof(det)) then 
        read(det,r)
    else 
        r.nro := valoralto;
end;

procedure actualizarmaestro(var mae:maestro;var det:detalle);
var 
    rm:regmae;
    rd:regdet;
    cante,nroact:integer;
begin 
    reset(mae);
    reset(det);
    read(mae,rm);
    leer(det,rd);
    while (rd.nro <> valoralto) do begin 
        nroact:=rd.nro;
        cante:=0;

        while (rd.nro = nroact) do begin 
            cante:=cante+1;
            leer(det,rd);
        end;

        while (rm.nro <> nroact) do 
            read(mae,rm);

        rm.cant:=rm.cant + cante;
        seek(mae,filepos(mae)-1);
        write(mae,rm);

        if (not eof(mae)) then 
            read(mae,rm);
            
    end;
    close(mae);
    close(det);
end;

procedure informe(var mae:maestro);
var 
    r:regmae;
    txt:Text;
begin
    assign(txt,'informe.txt');
    reset(mae);
    rewrite(txt);
    while (not eof(mae)) do begin 
        read(mae, r);
        writeln(txt, r.nro, ' ', r.cant);
    end;
    close(mae);
    close(txt);
end;

var 
    mae:maestro;
    det:detalle;
begin 
    writeln('===INICIO===');
    writeln('===IMPORTANDO MAESTRO===');
    importarmaestro(mae);
    writeln('===IMPORTANDO DETALLE===');
    importardetalle(det);
    writeln('===ACTUALIZANDO MAESTRO===');
    actualizarmaestro(mae,det);
    writeln('===GENERANDO INFORME===');
    informe(mae);
    writeln('===FIN===');
end.
