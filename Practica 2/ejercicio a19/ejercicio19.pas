{A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
reuniendo dicha información.
Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
nacimiento, nombre, apellido, dirección detallada (calle, nro, piso, depto, ciudad), matrícula
del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
padre.
En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
lugar.
Realizar un programa que cree el archivo maestro a partir de toda la información de los
archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
apellido, dirección detallada (calle, nro, piso, depto, ciudad), matrícula del médico, nombre y
apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
deberá, además, listar en un archivo de texto la información recolectada de cada persona.
Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única. Tenga
en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
además puede no haber fallecido.}

program ejercicio19;
const 
    valoralto=9999;
    dimf = 3; //50
type
    direccion = record 
        calle:string;
        nro:integer;
        piso:integer;
        depto:string;
        ciudad:string;
    end;
    
    regnac = record 
        nro:integer;
        nom:string;
        ape:string;
        dir:direccion;
        mat:integer;
        nommadre:string;
        apemadre:string;
        dnimadre:integer;
        nompadre:string;
        apepadre:string;
        dnipadre:integer;
    end;

    regfac= record 
        nro:integer;
        nom:string;
        ape:string;
        mat:integer;
        fecha:string;
        hora:string;
        lugar:string;
    end;
    {nro partida nacimiento, nombre,
apellido, dirección detallada (calle, nro, piso, depto, ciudad), matrícula del médico, nombre y
apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar.}
    regmae = record 
        nro:integer;
        nom:string;
        ape:string;
        dir:direccion;
        mat:integer;
        nommadre:string;
        apemadre:string;
        dnimadre:integer;
        nompadre:string;
        apepadre:string;
        dnipadre:integer;
        fallecio:boolean;
        fecha:string;
        hora:string;
        lugar:string;
    end;
    
    maestro = file of regmae;
    detallen=file of regnac;
    detallef= file of regfac;

    vecdetn = array [1..dimf] of detallen;
    vecregn = array [1..dimf] of regnac;

    vecdetf = array [1..dimf] of detallef;
    vecregf = array [1..dimf] of regfac;

procedure importardetalleN(var det:detallen; var i:integer);
var 
    txt2: Text;
    regD: regnac;
begin 
    case i of 
        1: begin assign(txt2,'detalleN1.txt'); assign(det,'detalleN1.dat'); end;
        2: begin assign(txt2,'detalleN2.txt'); assign(det,'detalleN2.dat'); end;
        3: begin assign(txt2,'detalleN3.txt'); assign(det,'detalleN3.dat'); end;
    end;
    reset(txt2);
    rewrite(det);
    while not eof(txt2) do begin
        readln(txt2, regD.nro);
        readln(txt2, regD.nom);
        readln(txt2, regD.ape);
        readln(txt2, regD.dir.calle);
        readln(txt2, regD.dir.nro);
        readln(txt2, regD.dir.piso);
        readln(txt2, regD.dir.dpto);
        readln(txt2, regD.dir.ciudad);
        readln(txt2, regD.mat);
        readln(txt2, regD.nommadre);
        readln(txt2, regD.apemadre);
        readln(txt2, regD.dnimadre);
        readln(txt2, regD.nompadre);
        readln(txt2, regD.apepadre);
        readln(txt2, regD.dnipadre);
        write(det, regD);
    end;
    close(txt2);
    close(det);
end;

procedure importardetalleF(var det:detallef; var i:integer);
var 
    txt2: Text;
    regD: regfac;
begin 
    case i of 
        1: begin assign(txt2,'detalleF1.txt'); assign(det,'detalleF1.dat'); end;
        2: begin assign(txt2,'detalleF2.txt'); assign(det,'detalleF2.dat'); end;
        3: begin assign(txt2,'detalleF3.txt'); assign(det,'detalleF3.dat'); end;
    end;
    reset(txt2);
    rewrite(det);
    while not eof(txt2) do begin
        readln(txt2, regD.nro);
        readln(txt2, regD.nom);
        readln(txt2, regD.ape);
        readln(txt2, regD.mat);
        readln(txt2, regD.fecha);
        readln(txt2, regD.hora);
        readln(txt2, regD.lugar);
        write(det, regD);
    end;
    close(txt2);
    close(det);
end;



procedure cargarvecn(var vn:vecdetn);
var 
    i:integer;
begin 
    for i := 1 to dimf do 
        importardetalleN(vn[i],i);
end;

procedure cargarvecf(vf:vecdetf):
var 
    i:integer;
begin 
    for i := 1 to dimf do
        importardetalleF(vf[i],i);
end;

procedure leerF()