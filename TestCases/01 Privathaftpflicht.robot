*** Settings ***
Documentation    1 Check24
Metadata    Source    Demo Projekte Bernd Mattern|Adam Riese|Demo
Metadata    UID    ITBEXP-TC-49106
Metadata    TCS    01 Privathaftpflicht
Metadata    Position    1/1
Metadata    Index    1.1
Metadata    Created by    redon / edis
Force Tags    PRIO-3
Resource    ../Resources/Check24.resource


Test Teardown    No Operation

*** Test Cases ***
1.1.1 Max - L
    [Documentation]    ITBEXP-TC-49106-PC-285796
    [Tags]    01_Testcase
    #für Produktion auf Headless umschalten
    [Setup]    Run Keywords    Check24.Vergleicher starten
    #Konstante
    ...    AND    Check24.Produkt auswählen        Privathaftpflicht
    #für mich, ...
    Check24.Versicherte auswählen    Mich selbst
    #weitere Persona-Daten eingeben
    Check24.Kunde eingeben    Mich selbst    24.04.1943    24568    Kaltenkirchen    nein    nein    nein
    #zu überprüfenden Tarif suchen und Web-Element merken
    Check24.Tarif auswählen    L
    #Tarifübersicht prüfen
    Check24.Übersicht prüfen    Deckungssumme    7,5 Mio. €
    #Tarifübersicht prüfen
    Check24.Übersicht prüfen    Ausfalldeckung    ja
    # #Tarifübersicht prüfen
    Check24.Übersicht prüfen    Schlüsselverlust Miete    10.000 €
    # Allgemeine Details zum Dictionary anpassen
    ${Allgemeine_Details}=    Check24.Allgemeine Details Prüfen
    # #Tarifdetails überprüfen
    Check24.Details prüfen    Deckungssumme für Sach- und Personenschäden    7,5 Mio. €    &{Allgemeine_Details}
    #Tarifdetails überprüfen
    Check24.Details prüfen    Deckungssumme für Vermögensschäden    7,5 Mio. €    &{Allgemeine_Details}
    #Tarifdetails überprüfen
    Check24.Details prüfen    Deckungssumme für Vermögensschäden    7,5 Mio. €    &{Allgemeine_Details}
    #Tarifdetails überprüfen
    Check24.Details prüfen    Generelle Selbstbeteiligung    keine    &{Allgemeine_Details}
    #Tarifdetails überprüfen
    Check24.Details prüfen    Mindestlaufzeit    1 Jahr    &{Allgemeine_Details}
    #Tarifdetails überprüfen
    Check24.Details prüfen    Kündigungsfrist des Tarifs    Bei CHECK24 jederzeit zum nächsten Tag kündbar. Sonst jederzeit mit Wirkung zum Ende Ihrer Vertragslaufzeit.   
    ...    &{Allgemeine_Details}
    #Browser schließen
    [Teardown]    Run Keyword    Check24.Vergleicher beenden

1.1.2 Lisa - XL
    [Documentation]    ITBEXP-TC-49106-PC-11367756
    [Tags]    02_Testcase
    #für Produktion auf Headless umschalten
    [Setup]    Run Keywords    Check24.Vergleicher starten
    #Konstante
    ...    AND    Check24.Produkt auswählen    Privathaftpflicht
    #für mich, ...
    Check24.Versicherte auswählen    Mich & Partner
    #weitere Persona-Daten eingeben
    Check24.Kunde eingeben    Mich & Partner    17.05.2002    24568    Kaltenkirchen    nein    nein    nein
    #zu überprüfenden Tarif suchen und Web-Element merken
    Check24.Tarif auswählen    XL
    #Tarifübersicht prüfen
    Check24.Übersicht prüfen    Deckungssumme    20 Mio. €
    #Tarifübersicht prüfen
    Check24.Übersicht prüfen    Ausfalldeckung    ja
    #Tarifübersicht prüfen
    Check24.Übersicht prüfen    Schlüsselverlust Miete    200.000 €
    # Allgemeine Details zum Dictionary anpassen
    ${Allgemeine_Details}=    Check24.Allgemeine Details Prüfen
    #Tarifdetails überprüfen
    Check24.Details prüfen    Deckungssumme für Sach- und Personenschäden    7,5 Mio. €    &{Allgemeine_Details}
    #Tarifdetails überprüfen
    Check24.Details prüfen    Deckungssumme für Vermögensschäden    7,5 Mio. €    &{Allgemeine_Details}
    #Tarifdetails überprüfen
    Check24.Details prüfen    Deckungssumme für Vermögensschäden    7,5 Mio. €    &{Allgemeine_Details}
    #Tarifdetails überprüfen
    Check24.Details prüfen    Generelle Selbstbeteiligung    keine    &{Allgemeine_Details}
    #Tarifdetails überprüfen
    Check24.Details prüfen    Mindestlaufzeit    1 Jahr    &{Allgemeine_Details}
    #Tarifdetails überprüfen
    Check24.Details prüfen    Kündigungsfrist des Tarifs    Bei CHECK24 jederzeit zum nächsten Tag kündbar. Sonst jederzeit mit Wirkung zum Ende Ihrer Vertragslaufzeit.
    ...    &{Allgemeine_Details}
    #Browser schließen
    [Teardown]    Run Keyword    Check24.Vergleicher beenden
