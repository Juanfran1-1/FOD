program creador;
    var
        txt: Text;
    begin
        // Crear maestro.txt
        assign(txt, 'H:/FACULTAD/FOD/Practica 2/ejercicio a15/maestro.txt');
        rewrite(txt);
        writeln(txt, '1 Provincia1');
        writeln(txt, '101 Localidad1');
        writeln(txt, '10 8 5 7 6');
        writeln(txt, '1 Provincia1');
        writeln(txt, '102 Localidad2');
        writeln(txt, '12 10 6 8 7');
        writeln(txt, '2 Provincia2');
        writeln(txt, '201 Localidad3');
        writeln(txt, '15 12 8 10 9');
        writeln(txt, '2 Provincia2');
        writeln(txt, '202 Localidad4');
        writeln(txt, '18 14 10 12 11');
        writeln(txt, '3 Provincia3');
        writeln(txt, '301 Localidad5');
        writeln(txt, '20 16 12 14 13');
        close(txt);

        // Crear detalle1.txt
        assign(txt, 'H:/FACULTAD/FOD/Practica 2/ejercicio a15/detalle1.txt');
        rewrite(txt);
        writeln(txt, '1 101 5 2 3 4 1');
        writeln(txt, '1 102 3 1 2 3 2');
        writeln(txt, '2 201 4 3 2 1 1');
        close(txt);

        // Crear detalle2.txt
        assign(txt, 'H:/FACULTAD/FOD/Practica 2/ejercicio a15/detalle2.txt');
        rewrite(txt);
        writeln(txt, '2 202 6 4 5 3 2');
        writeln(txt, '3 301 2 1 1 2 1');
        writeln(txt, '3 302 3 2 2 1 1');
        close(txt);

        // Crear detalle3.txt
        assign(txt, 'H:/FACULTAD/FOD/Practica 2/ejercicio a15/detalle3.txt');
        rewrite(txt);
        writeln(txt, '1 103 4 2 3 2 1');
        writeln(txt, '2 203 5 3 4 2 2');
        writeln(txt, '3 303 3 2 1 3 1');
        close(txt);
    end.