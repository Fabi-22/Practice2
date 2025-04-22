% ----------------------------------
% PARTE 1: Catálogo de vehículos
% ----------------------------------

% vehicle(Marca, Referencia, Tipo, Precio, Año).
vehicle(toyota, corolla, sedan, 22000, 2021).
vehicle(toyota, rav4, suv, 28000, 2022).
vehicle(toyota, hilux, pickup, 35000, 2023).
vehicle(ford, fiesta, sedan, 18000, 2020).
vehicle(ford, ranger, pickup, 32000, 2022).
vehicle(ford, explorer, suv, 45000, 2023).
vehicle(bmw, x5, suv, 60000, 2021).
vehicle(bmw, m3, sport, 70000, 2022).
vehicle(mazda, cx5, suv, 27000, 2023).
vehicle(honda, civic, sedan, 24000, 2022).
vehicle(honda, crv, suv, 31000, 2021).

% ----------------------------------
% PARTE 2: Filtros básicos
% ----------------------------------

% meet_budget(Referencia, PresupuestoMáx)
meet_budget(Reference, BudgetMax) :-
    vehicle(_, Reference, _, Price, _),
    Price =< BudgetMax.

% Lista de referencias por marca usando findall
references_by_brand(Brand, References) :-
    findall(Ref, vehicle(Brand, Ref, _, _, _), References).

% Lista agrupada por marca usando bagof
group_by_brand(Brand, Grouped) :-
    bagof(Ref, vehicle(Brand, Ref, _, _, _), Grouped).

% ----------------------------------
% PARTE 3: Generación de reportes
% ----------------------------------

% generate_report(Marca, Tipo, PresupuestoMáx, Resultado)
generate_report(Brand, Type, Budget, Result) :-
    findall((Brand, Ref, Price),
            (vehicle(Brand, Ref, Type, Price, _), Price =< Budget),
            ResultList),
    sum_prices(ResultList, TotalValue),
    TotalValue =< 1000000,
    Result = result{vehicles: ResultList, total_value: TotalValue}.

% Suma los precios en una lista de tuplas (Marca, Ref, Precio)
sum_prices(List, Sum) :-
    sum_prices(List, 0, Sum).

sum_prices([], Acc, Acc).
sum_prices([(_, _, Price)|T], Acc, Sum) :-
    NewAcc is Acc + Price,
    sum_prices(T, NewAcc, Sum).

% ----------------------------------
% PARTE 4: Casos de prueba
% ----------------------------------

% Caso 1: Toyota SUV bajo 30k
case1(Result) :-
    findall(Ref,
        (vehicle(toyota, Ref, suv, Price, _), Price < 30000),
        Result).

% Caso 2: Ford agrupado por tipo y año con bagof
case2(Result) :-
    bagof((Type, Year, Ref),
          vehicle(ford, Ref, Type, _, Year),
          Result).

% Caso 3: Total de sedanes bajo 500k
case3(Result) :-
    findall((Ref, Price),
            (vehicle(_, Ref, sedan, Price, _), Price =< 500000),
            Vehicles),
    sum_sedan_prices(Vehicles, Total),
    Total =< 500000,
    Result = result{vehicles: Vehicles, total_value: Total}.

sum_sedan_prices(List, Sum) :-
    sum_sedan_prices(List, 0, Sum).

sum_sedan_prices([], Acc, Acc).
sum_sedan_prices([(_, Price)|T], Acc, Sum) :-
    NewAcc is Acc + Price,
    sum_sedan_prices(T, NewAcc, Sum).
