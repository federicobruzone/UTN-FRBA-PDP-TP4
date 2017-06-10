% Trabajo Practico No. 3 - "Inmobiliaria"
% Grupo 15. Integrantes: BRUZONE, Federico; LOTT, Sebastian
% 1a Entrega: 10/5/2017
% 2a Entrega: 10/6/2017

%Entidades - Casas:
propiedad(tinsmithCircle1774).
propiedad(avMoreno708).
propiedad(avSiempreViva742).
propiedad(calleFalsa123).

% propiedad(Propiedad) :- precio(Propiedad, _).

% Functores - Casas:
precio(tinsmithCircle1774, 700).
precio(avMoreno708, 2000).
precio(avSiempreViva742, 1000).
precio(calleFalsa123, 200).

tiene(tinsmithCircle1774, ambientes(3)).
tiene(tinsmithCircle1774, jardin).
tiene(tinsmithCircle1774, instalacion(aireAcondicionado)).
tiene(tinsmithCircle1774, instalacion(extractorCocina)).
tiene(tinsmithCircle1774, instalacion(calefaccion(gas))).

tiene(avMoreno708, ambientes(7)).
tiene(avMoreno708, jardin).
tiene(avMoreno708, piscina(30)).
tiene(avMoreno708, instalacion(aireAcondicionado)).
tiene(avMoreno708, instalacion(calefaccion(lozaRadiante))).
tiene(avMoreno708, instalacion(vidriosDobles)).

tiene(avSiempreViva742, ambientes(4)).
tiene(avSiempreViva742, jardin).
tiene(avSiempreViva742, instalacion(calefaccion(gas))).

tiene(calleFalsa123, ambientes(3)).


% Reglas - Casas:
tienenMismosAmbientes(Casa1, Casa2) :-
	tiene(Casa1, ambientes(X)),
	tiene(Casa2, ambientes(X)),
	Casa1 \= Casa2.
	
cumple(Propiedad, Caracteristica) :-
	tiene(Propiedad, Caracteristica).

cumple(Propiedad, ambientes(NumeroAAlcanzar)) :-
	tiene(Propiedad, ambientes(NumeroReal)),
	NumeroReal >= NumeroAAlcanzar.

cumple(Propiedad, piscina(NumeroAAlcanzar)) :-
	tiene(Propiedad, piscina(NumeroReal)),
	NumeroReal >= NumeroAAlcanzar.

% Entidades - Usuarios:
usuario(carlos).
usuario(ana).
usuario(maria).
usuario(pedro).
usuario(chameleon).

quiere(carlos, ambientes(3)).
quiere(carlos, jardin).

quiere(ana, piscina(100)).
quiere(ana, instalacion(aireAcondicionado)).
quiere(ana, instalacion(vidriosDobles)).

quiere(maria, ambientes(2)).
quiere(maria, piscina(15)).

quiere(pedro, Caracteristica) :- quiere(maria, Caracteristica).
quiere(pedro, instalacion(calefaccion(lozaRadiante))).
quiere(pedro, instalacion(vidriosDobles)).

quiere(chameleon, Caracteristica) :- 
	usuario(Persona),
	Persona \= chameleon,
	quiere(Persona, Caracteristica).

% Reglas:
tieneAlgoDeLoQueQuiere(Persona, Propiedad) :-
	usuario(Persona),
	quiere(Persona, Caracteristica),
	cumple(Propiedad, Caracteristica).

seDeseaCaracteristica(Propiedad, Caracteristica) :-
	quiere(_Persona, Caracteristica),
	cumple(Propiedad, Caracteristica).
	
noExisteConEsaCaracteristica(Caracteristica) :-
	quiere(_Persona, Caracteristica),
	not(cumple(_Propiedad, Caracteristica)).

cumpleTodo(Persona, Propiedad) :-
	usuario(Persona),
	propiedad(Propiedad),
	forall(quiere(Persona, Caracteristica), cumple(Propiedad, Caracteristica)).

mejorOpcion1(Persona, Propiedad) :-
	usuario(Persona), 
	findall(Precio, (cumpleTodo(Persona, Propiedad), precio(Propiedad, Precio)), Precios),
	min_list(Precios, Min),
	precio(Propiedad, Min).

efectividad(Efectividad) :-
	setof(Persona, usuario(Persona), Personas),
	setof(Persona, estaSatisfecho(Persona), Satisfechos),
	length(Personas, TotalPersonas),
	length(Satisfechos, TotalSatisfechos),
	Efectividad is TotalSatisfechos / TotalPersonas.
	
estaSatisfecho(Persona) :-
	cumpleTodo(Persona, _Propiedad).

esTop(Propiedad) :-
	not(esChica(Propiedad)),
	tiene(Propiedad, instalacion(aireAcondicionado)).
	
esChica(Propiedad) :- tiene(Propiedad, ambientes(1)).
esChica(Propiedad) :- not(tiene(Propiedad, ambientes(_))).

/* CONSULTAS:
******Consulta 1******
?- tiene(Propiedad, piscina(30)).
Propiedad = avMoreno708.

******Consulta 2******
?- tienenMismosAmbientes(Casa1, Casa2).
Casa1 = tinsmithCircle1774,
Casa2 = calleFalsa123 ;
Casa1 = calleFalsa123,
Casa2 = tinsmithCircle1774 ;

******Consulta 3******
?- quiere(pedro, Caracteristica).
Caracteristica = ambientes(2) ;
Caracteristica = piscina(15).

******Consulta 4******
?- cumple(Propiedad, ambientes(2)).
Propiedad = tinsmithCircle1774 ;
Propiedad = avMoreno708 ;
Propiedad = avSiempreViva742 ;
Propiedad = calleFalsa123.

******Consulta 5******
?- tieneAlgoDeLoQueQuiere(pedro, Propiedad).
Propiedad = tinsmithCircle1774 ;
Propiedad = avMoreno708 ;
Propiedad = avSiempreViva742 ;
Propiedad = calleFalsa123 ;
Propiedad = avMoreno708.

******Consulta 6******
?- seDeseaCaracteristica(avMoreno708, Caracteristica).
Caracteristica = ambientes(3) ;
Caracteristica = jardin ;
Caracteristica = ambientes(2) ;
Caracteristica = piscina(15) ;
Caracteristica = ambientes(2) ;
Caracteristica = piscina(15) ;
Caracteristica = ambientes(3) ;
Caracteristica = jardin ;
Caracteristica = ambientes(2) ;
Caracteristica = piscina(15) ;
Caracteristica = ambientes(2) ;
Caracteristica = piscina(15) ;

******Consulta 7******
?- noExisteConEsaCaracteristica(Caracteristica).
Caracteristica = piscina(100) ;
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

******Consulta 10******
?- efectividad(Numero).
Numero = 0.6.

******Consulta 11******
?- esTop(Propiedad).
Propiedad = tinsmithCircle1774 ;
Propiedad = avMoreno708 ;

*/

