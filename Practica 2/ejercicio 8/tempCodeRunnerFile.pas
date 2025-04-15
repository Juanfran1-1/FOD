    while min.codprov <> valoralto do begin
        act:= min.codprov;
        totalYerba := 0;
        while act = min.codprov do begin
            totalYerba := totalYerba + min.cantyer;
            merge(regs, d, min);
        end;
        regm.cantyer := totalYerba;
        seek(m, filepos(m) - 1);
        write(m, regm);
        writeln('prueba');
        if not eof(m) then
            read(m, regm);
    end;