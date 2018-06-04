create or replace function ip2int(strip in String) return integer as
  ip1    varchar2(10);
  ip2    varchar2(10);
  ip3    varchar2(10);
  ip4    varchar2(10);
  temp   varchar2(20);
  result integer;
begin
  temp   := strip;
  ip1    := SUBSTR(temp, 1, INSTR(temp, '.', 1, 1) - 1);
  ip2    := substr(temp,
                   INSTR(temp, '.', 1, 1) + 1,
                   INSTR(temp, '.', 1, 2) - length(ip1) - 2);
  ip3    := substr(temp,
                   INSTR(temp, '.', 1, 2) + 1,
                   INSTR(temp, '.', 1, 3) - length(ip1) - length(ip2) - 3);
  ip4    := substr(temp,
                   INSTR(temp, '.', 1, 3) + 1,
                   length(temp) - length(ip1) - length(ip2) - length(3)- 3);
  result := to_number(ip1) * 16777216 + to_number(ip2) * 65536 +
            to_number(ip3) * 256 + to_number(ip4);
  return(result);
end ip2int;
