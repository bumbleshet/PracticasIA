;Pr�ctica 6 - Inteligencia Artificial
;Manuel Sanchez, Pablo Mac-Veigh

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Enumerations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Season
;;
;; Rangos estacionales basados en http://www.almanac.com/content/first-day-seasons
;;
;; 0: primavera (90 d�as 82 - 172)
;; 1: verano    (90 d�as 173 - 263)
;; 2: oto�o     (90 d�as 264 - 354)
;; 3: invierno  (91 d�as 355 - 81)

;; hobby / theme
;;
;; 0: Deportes
;; 1: Aventura
;; 2: Cultura
;; 3: Turismo
;; 4: Gastronom�a

;; companion 
;;
;; 0: solo
;; 1: familia
;; 2: amigos

;; languages
;;
;; 0: Espa�ol
;; 1: Ingl�s
;; 2: Franc�s
;; 3: Chino
;; 4: Alem�n
;; 5: Indio
;; 6: Portugu�s

;; Continentes
;;
;; 0: Europa
;; 1: Asia
;; 2: Australia
;; 3: Am�ica del Norte
;; 4: Am�ica del Sur

(defglobal ?*crlf* = "
")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TEMPLATES DEFINITION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Definition del template del usuario
(deftemplate user
    (slot season(type number)); �poca del a�o en la que el usuario quiere viajar (ENUMERADO)
    (slot budget(type number)); Presupuesto
    (slot hobby(type number)); Afici�n (ENUMERADO). TODO: multislot varias aficiones
    (slot age(type number)); Edad
    (slot companion(type number)); Acompa�antes (ENUMERADO)
    (slot exotic(type number)); Busca un viaje ex�tico? (TRUE:1, FALSE:0)
    (slot continent(type number))
    (slot languages(type number)); Idioma (ENUMERADO)
)

;Deficiciﾃδｳn template viaje
(deftemplate travel
	(slot begins(type number)); D�a que empieza el viaje (�ndice 0-364 representando un d�a del a�o)
    (slot ends(type number)); D�a que termina el viaje (�ndice 0-364 representando un d�a del a�o)
    (slot theme(type number)); Tem�tica del viaje (Deporte, turismo, aventura, etc) (ENUMERADO)
    (slot cost (type number)) ; coste del viaje
    (slot language(type number)); Idioma del sitio de destino (Ver languages en user) TODO: multislot varios idiomas
    (slot name(type STRING)); T�tulo
    (slot continent (type number));Continente del desitno
    (slot description(type STRING)); Descripci�n del viaje     
)

;Definicion del template recomendaci�n
(deftemplate recommendation
    (slot name(type STRING))
    (slot description(type STRING))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FACTS DEFINITIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Asertaci�n de hechos: Usuario de prueba
(deffacts usr
    (user (season 1) (budget 5000) (hobby 1) (age 26) (companion 0) (exotic 1) (languages 0))
    )

;Asertaci�n de hechos: Viajes
(deffacts trvl
    ;(travel (begins) (ends) (theme) (language) (company) (name) (description))
	(travel (begins 180)(ends 201)(theme 1)(language 3) (cost 5000) (name "Viaje al T�bet") (continent 1) (description "Un viaje de 21 dias por el T�bet, una experiencia para los mas aventureros"))
	(travel (begins 90)(ends 97)(theme 4)(language 3) (cost 4500) (name "Gastronom�a Pekinesa") (continent 1) (description "Siete d�as de ensue�o en los que pasar�a por los mejores restaurantes de China, coincidiendo con el mercado de Primavera."))
	(travel (begins 356)(ends 10)(theme 1)(language 0) (cost 8000)(name "La patagonia") (continent 4) (description "La patagonia no es un sitio para cualquiera. Verano es la mejor �poca para visitar a los enormes glaciares que se desprender�n ante tus ojos."))
	(travel (begins 360)(ends 4)(theme 2)(language 4) (cost 1200)(name "El Berl�n de los museos") (continent 0) (description "Berlin tiene una cantidad de museos impresionantes, podr�as visitarlos todos"))
	(travel (begins 360)(ends 4)(theme 3)(language 4) (cost 1000)(name "Roma") (continent 0) (description "Roma es el destino ideal para turistas"))
	(travel (begins 266)(ends 286)(theme 0)(language 1) (cost 1100)(name "Estados unidos en bicicleta") (continent 3) (description "Recorra de costa este a oeste los estados unidos en bicicleta; un viaje duro para los mas osados"))
	(travel (begins 88)(ends 98)(theme 3)(language 2) (cost 4200)(name "Quebeq, la Francia ovlidada") (continent 3) (description "Un viaje por la zona franco-parlante de Canada."))
	(travel (begins 174)(ends 190)(theme 1)(language 1) (cost 4500)(name "Australia: La tierra del peligro") (continent 2) (description "Australia en verano es un sitio inh�spito, perfecto para la gente que busca aventuras"))
	(travel (begins 130)(ends 145)(theme 2)(language 5) (cost 3000)(name "La India y la Religi") (continent 1) (description "Un viaje cultural por la India, donde naci� el buddhismo."))
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SELECTION MODULE ;This module contains all the functions used by the recommendation module
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule selection)

(deffunction fitsSeason (?beginDate ?endDate ?userSeason)
    "Devuelve verdadero si la temporada que ha elegido el usuario corresponde con la del viaje"
    (return (or 
            	(and (eq ?userSeason 0)(>= ?beginDate 82)(<= ?endDate 172)(<= ?beginDate 172)(>= ?endDate 82));Primavera del 82 al 172
            	(and (eq ?userSeason 1)(>= ?beginDate 173)(<= ?endDate 263)(<= ?beginDate 263)(>= ?endDate 82));Verano del 173 al 263
          	    (and (eq ?userSeason 2)(>= ?beginDate 264)(<= ?endDate 354)(<= ?beginDate 354)(>= ?endDate 82));Oto�o del 264 al 354
            	(and (eq ?userSeason 3)(>= ?beginDate 355)(<= ?endDate 81));Invierno del 355 al 81
            )
        )
    )

(deffunction exotic (?travelLanguage ?travelContinent ?userLanguage ?userContinent ?userExotic)
    (return (or
            	(and (neq ?travelLanguage ?userLanguage)(neq ?travelContinent ?userContinent) )
            	(eq ?userExotic 0)
            )
    )
)

(deffunction age (?userAge ?travelTheme ?userExotic ?travelContinent ?userContinent)
    (return (or
            	(not(and (eq ?userExotic 0) (<= 17 ?userAge) (neq ?travelContinent ?userContinent)));Si es menor de edad y no quiere un viaje exótico no se le manda fuera del continente
            	(and (>= 35 ?userAge) (>= 2 ?travelTheme)) ;con mas de 35 años no recomienda viajes de aventuras o deportes
            	(< ?userAge 35)
            )
    )
)

(deffunction company (?travelTheme ?userHobby ?userCompanions)
    "Devuelve verdadero si el tema del viaje es adecuado para la compañia del viajante"
    (return (or	
            	(and (eq ?userCompanions 2) (< 1 ?travelTheme));Con familia puede hacer un viaje cultural, turístico o gastronómico
            	(and (eq ?userCompanions 1) (>= 1 ?travelTheme)); Con amigos puede hacer viajes de deportes o aventura
            	(eq ?userCompanions 0) ;Default, el viajante solo puede hacer todos los viajes
            )
        )
    )

(deffunction hobbies (?userHobby ?travelTheme)
    "Intenta convalidar los hobbies con la tematica y no enviar a alguien que quiere gastronomía a escalar el everest."
	(return (or
	            (and (>= ?userHobby 2)(>= ?travelTheme 2)) ; Si el viajante quiere cultura turismo o gastronomía se le puede asignar cualquiera de las tres
            	(and (< ?userHobby 2)(< ?travelTheme 2)) ; Si el viajante quiere aventura o deportes se le asignará cualquiera de los dos.
            )
        )
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RECOMMENDATION MODULE ;This module handles the recomendations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule travelRecommendation)

(defrule combine-recommendations 
    "Combiena recomendaciones iguales que puedan salir varias veces"
    ?r1 <- (recommendation (name ?n) (description ?d1))
    ?r2 <- (recommendation (name ?n) (description ?d2&:(neq ?d1 ?d2)))
    =>
    (retract ?r2)
    (modify ?r1 (description (str-cat ?d1 ?*crlf* ?d2))))

(defrule recommend
    "Aserta las recomendaciones si estas se ajustan"
    (travel (name ?tn) (begins ?tb) (ends ?te) (cost ?tc)(theme ?tt) (language ?tl)(continent ?tct)(description ?td)) ;Todos los viajes
    (user (season ?us) (budget ?ub) (hobby ?uh) (age ?ua) (companion ?uc) (exotic ?ue) (continent ?uct) (languages ?ul)) ;Todos los usuarios
    ;Los hechos sobre Travel empiezan las variables con t y los hechos sobre usuarios empiezan con u.
    
    ;llamadas tipo (test (funcion parametros)))
    (test (fitsSeason ?tb ?te ?us))
    (test (exotic ?tl ?tct ?ul ?uct ?ue))
    (test (company ?tt ?uh ?uc))
    (test (>= ?ub ?tc)) ;el viaje está en presupuesto
    (test (age ?ua ?tt ?ue ?tc ?uc))
    (test (hobbies ?uh ?tt))
    => ;;Si todas las condiciones timpo test se cumplen
    (assert (recommendation (name ?tn) (description ?td))) ;Aserta una recomendaci�n
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; REPORT MODULE; This module handles showing the information on screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule report)

(defrule sort-and-print
  ?r1 <- (recommendation (name ?n1) (description ?d1))
  (not (recommendation (name ?n2&:(< (str-compare ?n2 ?n1) 0))))
  =>
  (printout t "You should consider the following trip: " ?n1 crlf)
  (printout t "Description: "  ?d1 crlf crlf)
  (retract ?r1))

(deffunction run-system ()
    "Equivalent to main function"
  (reset);resets all facts
  (focus selection travelRecommendation report) ;order in wich modules will be 'executed'
  (run))

(run-system)
