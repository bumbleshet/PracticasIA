
% <Añade cita> <Con quien> <Cuando>
frase(Salida) -->  grupo_anadir, grupo_quien(N), grupo_tiempo(D,M,H),
{
	retract(ultimaCita(_,_,_,_)),
	assert(cita(D,M,H,1,N)),
	assert(ultimaCita(D,M,H,1)),
	nl,
	es_mes(Mes, M, _),
	string_concat('Reunion programada con ', N, Aux1),
	string_concat(Aux1, ' el dia ', Aux2),
	string_concat(Aux2, D, Aux3),
	string_concat(Aux3, ' de ', Aux4),
	string_concat(Aux4, Mes, Aux5),
	string_concat(Aux5, ' a las ', Aux6),
	string_concat(Aux6, H, Aux7),
	string_concat(Aux7, '.', Salida)

}.

% <Borra cita> <Con quien>
frase(Salida) -->  grupo_borrar, grupo_quien(N),
{
	retract(cita(_,_,_,_,N)),
	nl,
	string_concat('Su reunion con ', N, Aux1),
	string_concat(Aux1, ' ha sido cancelada.', Salida)
}.

% <Borra cita> <Cuando>
frase(Salida) --> grupo_borrar, grupo_tiempo(D,M,H),
{
	retract(ultimaCita(_,_,_,_)),
	retract(cita(D,M,H,_,_)),
	assert(ultimaCita(D,M,H,2)),
	nl,
	es_mes(Mes, M, _),
	string_concat('Su cita del ', D, Aux1),
	string_concat(Aux1, ' de ', Aux2),
	string_concat(Aux2, Mes, Aux3),
	string_concat(Aux3, ' a las ', Aux4),
	string_concat(Aux4, H, Aux5),
	string_concat(Aux5, ' ha sido cancelada', Salida)
}.

%<Borra cita > <de> <mañana/hoy> 
frase(Salida) --> grupo_borrar, [de], grupo_tiempo(D,M,H),
{
	retract(cita(D,M,H,_,_)),
	nl,
	es_mes(Mes, M, _),
	string_concat('Su cita del ', D, Aux1),
	string_concat(Aux1, ' de ', Aux2),
	string_concat(Aux2, Mes, Aux3),
	string_concat(Aux3, ' a las ', Aux4),
	string_concat(Aux4, H, Aux5),
	string_concat(Aux5, ' ha sido cancelada', Salida)
}.

%<Querrie de citas> <Cuando>
frase(Salida) --> grupo_querry_tiempo, grupo_tiempo(D,M,H),
{
	retract(ultimaCita(_,_,_,_)),
	setof((D,M,H,Du,P), cita(D,M,H,Du,P), ListaCitas),
	assert(ultimaCita(D,M,H,3)),
	nl,
	escribe(ListaCitas),
	string_concat('', '', Salida);
	nl,
	string_concat('No tiene ninguna cita programada el ', D, Aux1),
	es_mes(Mes, M, _),
	string_concat(Aux1, ' de ', Aux2),
	string_concat(Aux2, Mes, Salida),
	var(H); string_concat('No tiene ninguna cita programada el ', D, Aux1),
	es_mes(Mes, M, _),
	string_concat(Aux1, ' de ', Aux2),
	string_concat(Aux2, Mes, Aux3),
	string_concat(Aux3, ' a las ', Aux4),
	string_concat(Aux4, H, Salida)

}.

%<Querrie de citas> <Con quien>
frase(Salida) --> grupo_querry_persona, grupo_quien(N),
{
	setof((A,B,C,D,N), cita(A,B,C,D,N), ListaCitas),
	nl,
	escribe(ListaCitas),
	string_concat('', '', Salida);
	nl,
	string_concat('Lo sentimos, pero usted no tiene ninguna cita programada con ', N, Salida)
}.

% <y> <Con quien> <Cuando> // Querry anidada
frase(Salida) --> [y], grupo_quien(N), grupo_hora(H),
{
	ultimaCita(D,M,_,1),
	assert(cita(D,M,H,1,N)),
	retract(ultimaCita(_,_,_,_)),
	assert(ultimaCita(D,M,H,1)),
	es_mes(Mes, M, _),
	nl,
	string_concat('Reunion programada con ', N, Aux1),
	string_concat(Aux1, ' el dia ', Aux2),
	string_concat(Aux2, D, Aux3),
	string_concat(Aux3, ' de ', Aux4),
	string_concat(Aux4, Mes, Aux5),
	string_concat(Aux5, ' a las ', Aux6),
	string_concat(Aux6, H, Aux7),
	string_concat(Aux7, '.', Salida)
}.

% <y> <Cuando (hora) > // Querry anidada.
frase(Salida) --> [y], grupo_hora(H),
{
	ultimaCita(D,M,_,3),
	setof((D,M,H,Du,P), cita(D,M,H,Du,P), ListaCitas),
	nl,
	escribe(ListaCitas),
	string_concat('', '', Salida);
	nl,
	string_concat('No tiene ninguna cita programada el ', _D, Aux1),
	es_mes(Mes, _M, _),
	string_concat(Aux1, ' de ', Aux2),
	string_concat(Aux2, Mes, Salida),
	var(H); string_concat('No tiene ninguna cita programada el ', _D, Aux1),
	es_mes(Mes, _M, _),
	string_concat(Aux1, ' de ', Aux2),
	string_concat(Aux2, Mes, Aux3),
	string_concat(Aux3, ' a las ', Aux4),
	string_concat(Aux4, H, Salida)

}.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% GRAMATICAS %%%%%%%%%%%

consulta:- nl, assert(ultimaCita(1,1,1,0)), write('Escribe frase entre corchetes separando palabras con comas '), nl,
write('o lista vacia para parar '), nl, nl,
read(F),
trata(F).

consultap:-
read(F),
trata(F).

trata([]):- write('final').
trata(F):- frase(Salida, F, []), write(Salida),nl,nl, 
	consultap; nl, write('Error de sintaxis, 
	pruebe de nuevo'),nl,nl,consultap,!.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% GRUPOS SINTACTICOS %%%%%%

%%%%% Grupo para preguntar por las citas futuras %%%%%

grupo_querry_tiempo--> es_consulta_tiempo, [tengo].
grupo_querry_tiempo--> es_consulta_tiempo, [hay].
grupo_querry_tiempo--> es_consulta_tiempo, es_appointments, [tengo].
grupo_querry_tiempo--> es_consulta_general, [las], es_appointments.

%%%%% Grupo para preguntar por las citas con alguien %%%%%

grupo_querry_persona--> es_consulta_persona, [tengo], 
	es_consulta_persona_det,es_appointment.

grupo_querry_persona--> es_consulta_persona, [vere].

grupo_querry_persona--> es_consulta_tiempo, [tengo].

%%%%%% Grupo para añadir una cita

grupo_anadir --> es_anadir ,es_appointment.


%%%%%% Grupo para borrar una cita

grupo_borrar --> es_borrar, es_appointment.


%%%%%% Grupo para saber de que cita hablamos.

grupo_quien(N) --> es_prep, [N].

%%%%% Grupo temporal para una hora dada.

grupo_hora(H) --> [a,las],[H].


%%%%%% Grupo temporal para dar una fecha específica.

grupo_tiempo(D,Mes,H) --> es_prep_temp, [D], [de], [M], [a,las], [H],
{
	H>0-1,
	H<24,
	es_mes(M,Mes,Daux),
	D>0,
	D=<Daux
}.

%%%%%% Grupo temporal para hoy.

grupo_tiempo(D,M,H) --> [hoy,a,las], [H],
{
	hoy(D,M)
}.

%%%%%% Grupo temporal para este mes.

grupo_tiempo(D,M,H) --> [el,dia], [D], [a,las], [H],
{
	hoy(_,M)
}.

%%%%%% Grupo temporal para un dia determinado.

grupo_tiempo(D,M,_H) --> [del,dia], [D],
{
	hoy(_,M)
}.

%%%%% Grupo temporal para un dia/mes determinado.

grupo_tiempo(D,Mes,_H) --> [el], [D], [de], [M],
{
	es_mes(M,Mes,_)
}.

%%%%%% Grupos temporales para mañana.

grupo_tiempo(D,M,H) --> [manana,a,las], [H],
{
	hoy(A,M),
	D is A + 1,
	H is H
}.

grupo_tiempo(D,M,_H) --> [manana],
{
	hoy(A,M),
	D is A + 1,
	M is M
}.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% DICCIONARIO %%%%%%%%%%

es_anadir-->[anade,una].
es_anadir-->[pon,una].

es_appointment-->[reunion].
es_appointment-->[cita].
es_appointment-->[comida].
es_appointment-->[cena].

es_appointments-->[reuniones].
es_appointments-->[citas].
es_appointments-->[comidas].
es_appointments-->[cenas].

es_prep_temp-->[el].
es_prep_temp-->[del].

es_prep-->[de].
es_prep-->[con].
es_prep-->[a].

es_borrar-->[borra,la].
es_borrar-->[quita,la].

es_consulta_tiempo-->[que].

es_consulta_general-->[dime].

es_consulta_persona-->[cuando].

es_consulta_persona_det-->[una].
es_consulta_persona_det-->[la].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DATOS %%%%%%%%%%%%%
:- dynamic cita/5.
:- dynamic ultimaCita/4.

hoy(19,5).

es_mes(enero, 1, 31).
es_mes(febrero, 2,28).
es_mes(marzo, 3, 31).
es_mes(abril, 4, 30).
es_mes(mayo, 5, 31).
es_mes(junio, 6, 30).
es_mes(julio, 7, 31).
es_mes(agosto, 8, 31).
es_mes(septiembre, 9, 30).
es_mes(octubre, 10, 31).
es_mes(noviembre, 11, 30).
es_mes(diciembre, 12, 31).

escribe([]):- write('').

escribe([(D,M,H,Du,P) | Resto]):-
write([cita,el,dia,D,de,M,a,las,H,durante,Du,horas,con,P]),
nl,
escribe(Resto).
