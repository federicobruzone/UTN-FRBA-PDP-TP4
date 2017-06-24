% Trabajo Practico No. 3 - "Inmobiliaria"
% Grupo 15. Integrantes: BRUZONE, Federico; LOTT, Sebastian
% 1a Entrega: 10/5/2017
% 2a Entrega: 10/6/2017
% 3a Entrega: 23/6/2017

propiedad(Propiedad) :- precio(Propiedad, _).	% una entidad es propiedad si estás asociada a un precio
instalacion(Instalacion) :- tiene(_, instalaciones(Instalaciones)), member(Instalacion, Instalaciones). % por las dudas

precio(tinsmithCircle1774, 700).
precio(avMoreno708, 2000).
precio(avSiempreViva742, 1000).
precio(calleFalsa123, 200).

tiene(tinsmithCircle1774, ambientes(3)).
tiene(tinsmithCircle1774, jardin).
tiene(tinsmithCircle1774, instalaciones([aireAcondicionado, extractorCocina, calefaccion(gas)])).

tiene(avMoreno708, ambientes(7)).
tiene(avMoreno708, jardin).
tiene(avMoreno708, piscina(30)).
tiene(avMoreno708, instalaciones([aireAcondicionado, vidriosDobles, calefaccion(lozaRadiante)])).

tiene(avSiempreViva742, ambientes(4)).
tiene(avSiempreViva742, jardin).
tiene(avSiempreViva742, instalaciones([calefaccion(gas)])).

tiene(calleFalsa123, ambientes(3)).



cumple(Propiedad, Caracteristica) :-
	quiere(_, Caracteristica),				% generamos para asegurar inversibilidad
	tiene(Propiedad, Caracteristica).

cumple(Propiedad, ambientes(NumeroAAlcanzar)) :-
	quiere(_, ambientes(NumeroAAlcanzar)),	% generamos para asegurar inversibilidad
	tiene(Propiedad, ambientes(NumeroReal)),
	NumeroReal >= NumeroAAlcanzar.

cumple(Propiedad, piscina(NumeroAAlcanzar)) :-
	quiere(_, piscina(NumeroAAlcanzar)),	% generamos para asegurar inversibilidad
	tiene(Propiedad, piscina(NumeroReal)),
	NumeroReal >= NumeroAAlcanzar.

cumple(Propiedad, instalaciones(InstalacionesDeseadas)) :-
	quiere(_, instalaciones(InstalacionesDeseadas)),				% generamos para asegurar inversibilidad
	tiene(Propiedad, instalaciones(InstalacionesDisponibles)),
	forall(member(Instalacion, InstalacionesDeseadas), member(Instalacion, InstalacionesDisponibles)).



usuario(carlos).
usuario(ana).
usuario(maria).
usuario(pedro).
usuario(chameleon).

quiere(carlos, ambientes(3)).
quiere(carlos, jardin).

quiere(ana, piscina(100)).
quiere(ana, instalaciones([aireAcondicionado, vidriosDobles])).

quiere(maria, ambientes(2)).
quiere(maria, piscina(15)).

quiere(pedro, Caracteristica) :- quiere(maria, Caracteristica).
quiere(pedro, instalaciones([calefaccion(lozaRadiante), vidriosDobles])).

quiere(chameleon, Caracteristica) :- 
	usuario(Persona),
	Persona \= chameleon,
	quiere(Persona, Caracteristica).


cumpleTodo(Persona, Propiedad) :-
	usuario(Persona),
	propiedad(Propiedad),
	forall(quiere(Persona, Caracteristica), cumple(Propiedad, Caracteristica)).

mejorOpcion1(Persona, Propiedad) :-
	cumpleTodo(Persona, Propiedad), 
	forall((cumpleTodo(Persona, OtraPropiedad), Propiedad \= OtraPropiedad), (precio(Propiedad, Precio), precio(OtraPropiedad, OtroPrecio), 
	Precio < OtroPrecio)).
	
mejorOpcion2(Persona, Propiedad) :-
	cumpleTodo(Persona, Propiedad),
	precio(Propiedad, Precio),
	not((cumpleTodo(Persona, OtraPropiedad), Propiedad \= OtraPropiedad, precio(OtraPropiedad, OtroPrecio), 
	OtroPrecio < Precio)).
	
efectividad(Efectividad) :-
	setof(Persona, usuario(Persona), Personas),
	setof(Persona, estaSatisfecho(Persona), Satisfechos),
	length(Personas, TotalPersonas),
	length(Satisfechos, TotalSatisfechos),
	Efectividad is TotalSatisfechos / TotalPersonas.
	
estaSatisfecho(Persona) :-
	cumpleTodo(Persona, _Propiedad).

esTop(Propiedad) :-
	tieneAC(Propiedad),
	not(esChica(Propiedad)).

tieneAC(Propiedad) :-
	propiedad(Propiedad),
	tiene(Propiedad, instalaciones(Instalaciones)),
	member(aireAcondicionado, Instalaciones).
	
esChica(Propiedad) :- tiene(Propiedad, ambientes(1)).
esChica(Propiedad) :- propiedad(Propiedad), not(tiene(Propiedad, ambientes(_))).

/* PARTE TEÓRICA:
	La presente implementación del agregado de las instalaciones a nuestro modelo hizo uso del concepto de polimorfismo.
	Para comenzar, extendimos el functor (tiene\2) utilizando como segundo parámetro el tipo de dato "lista". No hizo
	falta definir previamente dicho functor para este tipo de dato, ya que aprovechamos una característica del paradigma
	que es utilización de individuos compuestos. Se trata de un caso de polimorfismo paramétrico.
	
	Para implementar el functor (quiere\2), en cambio, agregamos un predicado adicional para dicho functor, al que defi-
	nimos como "cumple(Propiedad, instalaciones(InstalacionesDeseadas))". Cuando se consulte si una propiedad tiene o no
	las instalaciones deseadas, confiamos en que el intérprete, por medio de la técnica de Pattern Matching, identifique
	el tipo de dato evaluado con este predicado en particular, y lo evalue mediante el algoritmo asociado. Se trata de
	un caso de polimorfismo ad-hoc.
*/

/* CONSULTAS:
******Consulta 1******
?- tiene(Propiedad, piscina(30)).
Propiedad = avMoreno708.

******Consulta 2******
?- tiene(Casa1, ambientes(X)), tiene(Casa2, ambientes(X)), Casa1 \= Casa2.
Casa1 = tinsmithCircle1774,
X = 3,
Casa2 = calleFalsa123 ;
Casa1 = calleFalsa123,
X = 3,
Casa2 = tinsmithCircle1774 ;
false.

******Consulta 3******
?- quiere(pedro, Caracteristica).
Caracteristica = ambientes(2) ;
Caracteristica = piscina(15) ;
Caracteristica = instalaciones([calefaccion(lozaRadiante), vidriosDobles]).

******Consulta 4******
?- cumple(_, ambientes(2)).
true.

******Consulta 5******
?- quiere(pedro, Algo), cumple(Propiedad, Algo).
Algo = ambientes(2),
Propiedad = tinsmithCircle1774 ;
Algo = ambientes(2),
Propiedad = avMoreno708 ;
Algo = ambientes(2),
Propiedad = avSiempreViva742 ;
Algo = ambientes(2),
Propiedad = calleFalsa123 ;
Algo = piscina(15),
Propiedad = avMoreno708 ;
Algo = instalaciones([calefaccion(lozaRadiante), vidriosDobles]),
Propiedad = avMoreno708 ;

******Consulta 6******
?- cumple(avMoreno708, Caracteristica).
Caracteristica = jardin ;
Caracteristica = ambientes(3) ;
Caracteristica = ambientes(2) ;
Caracteristica = piscina(15) ;
Caracteristica = instalaciones([aireAcondicionado, vidriosDobles]) ;
Caracteristica = instalaciones([calefaccion(lozaRadiante), vidriosDobles]) ;

******Consulta 7******
?- quiere(_, Caracteristica), not(cumple(_, Caracteristica)).
Caracteristica = piscina(100) ;

******Consulta 8******
?- cumpleTodo(Persona, Propiedad).
Persona = carlos,
Propiedad = tinsmithCircle1774 ;
Persona = carlos,
Propiedad = avMoreno708 ;
Persona = carlos,
Propiedad = avSiempreViva742 ;
Persona = maria,
Propiedad = avMoreno708 ;
Persona = pedro,
Propiedad = avMoreno708 ;

******Consulta 9******
?- mejorOpcion1(Persona, Propiedad).
Persona = carlos,
Propiedad = tinsmithCircle1774 ;
Persona = maria,
Propiedad = avMoreno708 ;
Persona = pedro,
Propiedad = avMoreno708 ;

?- mejorOpcion2(Persona, Propiedad).
Persona = carlos,
Propiedad = tinsmithCircle1774 ;
Persona = maria,
Propiedad = avMoreno708 ;
Persona = pedro,
Propiedad = avMoreno708 ;

******Consulta 10******
?- efectividad(Numero).
Numero = 0.6.

******Consulta 11******
?- esTop(Propiedad).
Propiedad = tinsmithCircle1774 ;
Propiedad = avMoreno708 ;
*/