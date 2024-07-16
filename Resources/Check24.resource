*** Settings ***
Library    Browser
Library    String
Library    Collections

*** Variables ***
${headless}                  ${False}
${url}                       https://www.check24.de/
${versicherungsgeber}        Adam Riese
${TIMEOUT}                   5s
&{YES_NO}                    ja=yes    nein=no
&{PROTECTION_LEVEL}          ja=basic  nein=none
&{C24_PROVIDERS}             Adam Riese=104
${C24_MAIN_MENU}             //div[@class="c24-header-inner"]
${C24_NAVBAR}                //div[@id="c24-header-bottom"]
${C24_INSURANCE}             //div[@class="c24-nav-ele c24-nav-insurance"]
${C24_INSURANCE_PRODUCTS}    //ul[contains(@class,"c24-subnav-ele-list")]//li//a

#Insured
&{C24_INSURANCE_TYPES}          Mich selbst=single    Mich & Familie=family    Mich & Partner=couple    Mich & Kind(er)=singleKid
${C24_INSURANCE_TYPE_SUBMIT}    //div[@class="js24Fixable"]//button[@class="c24Button js24LoadingToggle"]

#Insurance User Input Options
${C24_UI_BIRTHDATE}            //*[@id='birthdate']
${C24_UI_ZIPCODE}              //*[@id='zipcode']
${C24_UI_CITY}                 //*[@id="city"]

${C24_UI_CHILDREN_COUNT}       //div[@name="count_children"]
${C24_UI_CHILDREN_UNDER7OR10}  //div[@name="childrenunder7or10"]
${C24_UI_PROTECTION_LEVEL}     //div[@name="protection_level"]
${C24_UI_PUBLIC_SERVICE}       //div[@name="public_service"]
${C24_UI_TARGET_AUDIENCE}      //div[@name="target_audience_filter_wanted"]
${C24_UI_DHV_WANTED}           //div[@name="dhv_wanted"]
${C24_BAESTATIGEN}             //input[@id="checkbox-Input1-first_information_accepted-yes"]
${C24_UI_SUBMIT}               //button[@value="Tarife anzeigen"]

${AR_PROVIDE_DIV}              //*[@id="content_result"]
${C24_RESULTS_SORT}            //*[@id="sortbutton_provider"]/label
${C24_RESULT_BOX}              //*[@id="content_result"]/div[@class="result_box"]
${C24_TARIF_BOX_RESULTS}       //div[@class="result_box_tab details_button compare_button"]
${C24_TARIF_DETAIL_TAB}        //div[@class="content_result"]//div[@class="tariff_details hidden"]
${C24_ALLGEMEIN_TAB}           //ul//li[2]
${C24_ALLGEMEIN_TAB_DETILS}    //div[@data-inlinedetail-tab-id=2]
${C24_ALLGEMEIN_TAB_ACTIVE}    //div[@class="result_box active"]//div[@class="tariff_details hidden"]
${C24_ALLGEMEIN_TAB_LINK}      //a[@data-inlinedetail-tab-id=2]
${C24_COMPARE_BOX}             //div[@class="compare__feature"]//div[@class="compare__box"]
${C24_COMPARE_BOX_TEXT}        //div[@class="compare__tooltip-text"] 
${C24_COMPARE_BOX_VALUE}       //span[@class="compare__value__currency" or @class="compare__value__text"]
${C24_UBERSICHT_VALUES}        //..//..//span[contains(@class, 'c24pv_bullet_text') and contains(@class, 'c24pv_bullet_icon-good')]
# ${C24_}



*** Keywords ***

# 
Produkt auswählen
    [Documentation]    Wählt das angegebene Versicherungsprodukt aus dem Menü aus.
    [Arguments]    ${produkt}
    # To-do: Auswahl Versicherung via Text
    Browser.Hover    ${C24_MAIN_MENU} >> ${C24_NAVBAR} >> ${C24_INSURANCE}
    Browser.Hover    ${C24_INSURANCE_PRODUCTS} >> //span[contains(text(),"${produkt}")]
    Sleep    1 seconds
    Click    ${C24_INSURANCE_PRODUCTS} >> //span[contains(text(),"${produkt}")]
    #Bernd:
    # Browser.Hover    //*[@id="c24-header-bottom"]/div/nav/div/div/div[1]/a
    # Sleep    1 seconds
    #Click    //*[@id="c24-header-bottom"]/div/nav/div/div/div[1]/a

    # //ul[contains(@class,"c24-subnav-ele-list")]//li//a//span[contains(text(),"Privathaftpflicht")]
    #Bern:
    # To-do: Auswahl des Produktes via seines Namens
    # Browser.Hover    //*[@id="c24-ver"]/div[1]/div[4]/ul[1]/li[1]/a
    # Sleep    1 seconds
    # Click    //*[@id="c24-ver"]/div[1]/div[4]/ul[1]/li[1]/a

Versicherte auswählen
    [Documentation]    Wählt die Art des Versicherten aus (z.B. Mich selbst, Mich & Familie).
    [Arguments]    ${versicherte}
    ${versicherte_auswhal}=    Run Keyword And Return Status    Click    //label[contains(., '${versicherte}')]
    IF    not $versicherte_auswhal

            Sleep    1 seconds
            Browser.Click    (//label[@class="${C24_INSURANCE_TYPES["${versicherte}"]}"])[2]
            Sleep    1 seconds
            Click    ${C24_INSURANCE_TYPE_SUBMIT}
    ELSE
            Click    //label[contains(., '${versicherte}')]
    END
    #Bernd:
    # To-do: Auswahl über Parameter implementieren
    # Mich selbst
    # Click    //*[@id="c24-content"]/div[1]/div/div[1]/div/section/div/div[5]/div/div/form/div/div[2]/div[1]/div/div[1]/label
    # Sleep    1 seconds
    # # jetzt vergleichen
    # Click    //*[@id="c24-content"]/div[1]/div/div[1]/div/section/div/div[5]/div/div/form/div/div[2]/div[2]/button

Geburtsdatum Eingeben
    [Documentation]    Gibt das Geburtsdatum des Versicherten ein.
    [Arguments]    ${datum}
    Click    ${C24_UI_BIRTHDATE}
    Type Text    ${C24_UI_BIRTHDATE}    ${datum}

Postleitzahl Eingeben
    [Documentation]    Gibt die Postleitzahl des Versicherten ein.
    [Arguments]    ${plz}
    Click    ${C24_UI_ZIPCODE}
    Type Text    ${C24_UI_ZIPCODE}    ${plz}

Stadt Auswählen
    [Documentation]    Wählt die Stadt des Versicherten aus einer Liste aus.
    [Arguments]    ${ort}
    Select Options By    ${C24_UI_CITY}    value    ${ort}
    Sleep    1 seconds

Postleitzahl Und Stadt Eingeben
    [Documentation]    Gibt die Postleitzahl und die Stadt des Versicherten ein.
    [Arguments]    ${plz}    ${ort}
    Postleitzahl Eingeben    ${plz}
    Stadt Auswählen    ${ort}

Anzahl Kinder Eingeben
    [Documentation]    Gibt die Anzahl der Kinder des Versicherten ein.
    [Arguments]    ${anzahl}
    Click    ${C24_UI_CHILDREN_COUNT}//input[@value=${anzahl}]/following-sibling::div

Kinder Unter 10 Auswählen
    [Documentation]    Wählt aus, ob Kinder unter 10 Jahren vorhanden sind.
    [Arguments]    ${kinder_unter_zehn}
    Click    ${C24_UI_CHILDREN_UNDER7OR10}//input[@value="${YES_NO}[${kinder_unter_zehn}]"]/following-sibling::div

Empfehlung Stiftung Warentest Beachten
    [Documentation]    Berücksichtigt die Empfehlung der Stiftung Warentest.
    [Arguments]    ${swt}
    Click    ${C24_UI_PROTECTION_LEVEL}//input[@value="${PROTECTION_LEVEL}[${swt}]"]/following-sibling::div

Öffentlicher Dienst Beschäftigt
    [Documentation]    Wählt aus, ob der Versicherte im öffentlichen Dienst beschäftigt ist.
    [Arguments]    ${od}
    Click    ${C24_UI_PUBLIC_SERVICE}//input[@value="${YES_NO}[${od}]"]/following-sibling::div

Individuelle Versicherungsleistungen Auswählen
    [Documentation]    Wählt individuelle Versicherungsleistungen aus.
    [Arguments]    ${iv}
    Click    ${C24_UI_TARGET_AUDIENCE}//input[@value="${YES_NO}[${iv}]"]/following-sibling::div

Risiken Im Dienst Versichern
    [Documentation]    Versichert Risiken im Dienst, speziell für den Bundesgrenzschutz.
    [Arguments]    ${dhw_wanted}    ${behruf}=Bundesgrenzschutz (ohne techn. Tätigkeit)
    Click    ${C24_UI_DHV_WANTED}//input[@value="${YES_NO}[${dhw_wanted}]"]/following-sibling::div
    IF    "${dhw_wanted}" == "ja"
        Type Text    //input[@id="occupation_me"]    ${behruf}
    END
    
Erstinformationen Bestätigen
    [Documentation]    Bestätigt die Erstinformationen.
    Click    ${C24_BAESTATIGEN}/following-sibling::label

Tarife Anzeigen    
    [Documentation]    Zeigt die verfügbaren Versicherungstarife an.
    Click    ${C24_UI_SUBMIT}

Kunde eingeben
    [Documentation]    Gibt die Kundendaten ein, einschließlich Versicherte, Geburtsdatum, Postleitzahl und Stadt.
    [Arguments]    ${versicherte}    ${datum}    ${plz}    ${ort}    ${swt}    ${od}    ${iv}    ${rim}=${EMPTY}    ${knd_count}=${EMPTY}    ${kuz}=${EMPTY} 
    Versicherte auswählen    ${versicherte}
    Geburtsdatum Eingeben    ${datum}
    Postleitzahl Und Stadt Eingeben    ${plz}    ${ort}

    # Conditional for Anzahl Kinder and Kinder Unter 10
    IF    '${versicherte}' == 'Mich & Familie' or '${versicherte}' == 'Mich & Kind(er)'    Anzahl Kinder Eingeben    ${knd_count}
    IF    '${versicherte}' == 'Mich & Familie' or '${versicherte}' == 'Mich & Kind(er)'    Kinder Unter 10 Auswählen    ${kuz}

    # To-do: Options
    Empfehlung Stiftung Warentest Beachten    ${swt}
    Öffentlicher Dienst Beschäftigt    ${od}

    # Conditional for Risiken Im Dienst Versichern
    IF    '${od}' == 'ja'    Risiken Im Dienst Versichern    ${rim}

    Individuelle Versicherungsleistungen Auswählen    ${iv}

    Erstinformationen Bestätigen
    Tarife Anzeigen

# Finde den Tarif anhand der Eigenschaften der Subelemente
Tarif auswählen
    [Documentation]    Wählt einen Tarif basierend auf den Eigenschaften der Subelemente aus.
    [Arguments]    ${tarif}    ${versicherungsgeber}=Adam Riese
    # Sortieren nach Anbieter
    Click    ${C24_RESULTS_SORT}
    # Klicke Adam Riese
    # To-do: by name
    Click    ${AR_PROVIDE_DIV}//div[@data-providerid=${C24_PROVIDERS}[${versicherungsgeber}]]
    Sleep    2s
    @{result} =    Browser.Get Elements        ${C24_RESULT_BOX} >> //div[@class="tariff_and_provider"]
    #Log    ${result}
    ${found} =    Finde Tarif    ${versicherungsgeber}    ${tarif}    @{result}
    IF    not $found
        Fail
    ELSE
        Browser.Scroll To Element    ${found}
        Log    Found Tarif ${found}
        Sleep    5s
    END
    Set Test Variable    ${tarif}    ${found}
    Log    ${tarif}
    Set Suite Variable    ${tarif}
    
# Tarifübersicht prüfen
Übersicht prüfen
    [Documentation]    Prüft die Übersicht der Tarifdetails anhand der angegebenen Eigenschaften und Werte.
    [Arguments]    ${eigenschaft}    ${wert}
    # //*[@id="content_result"]/div[3]/div[2]/div[4]/div[1]/ul[1]
    # Todo: Idetify also other icons
    ${list} =    Catenate    ${tarif}    >> ${C24_UBERSICHT_VALUES} 
    #<span class="c24pv_bullet_text c24pv_bullet_icon-good">Deckungssumme: <strong>7,5 Mio. €</strong></span>
    @{result} =    Browser.Get Elements    ${list} 
    FOR    ${element}    IN    @{result}
        Log    ${element}
        ${value} =    Catenate    ${element}    >> strong
        ${ist_eigenschaft} =    Browser.Get Text    ${element}
        
        ${doesStart} =    Run Keyword And Return Status   Should Start With    ${ist_eigenschaft}    ${eigenschaft}
        IF    ${doesStart}
            ${ist_value} =    Browser.Get Text    ${value}
            IF    $ist_value == $wert
                Log    Werte stimmen überein. ${eigenschaft} = ${wert} => ${ist_eigenschaft}
                Return From Keyword
            ELSE
                FAIL    Werte stimmen nicht überein. <$wert> <> <ist_value>!
                # Log    Werte stimmen nicht überein. <$wert> <> <ist_value>!
            END
        ELSE
            Continue For Loop
        END

    END
    FAIL    Tarifeigenschaft $eigenschaft nicht gefunden! 

# Tarifdetails prüfen
Allgemeine Details Prüfen
    [Documentation]    Prüft die allgemeinen Details des Tarifs.
        # Get the elements and create a dictionary
    Sleep    3s
    Click    ${tarif} >> //..//..${C24_TARIF_BOX_RESULTS}
    Sleep    3s
    # Navigate to the Allgemein tab
    Click    ${C24_ALLGEMEIN_TAB_ACTIVE} >> ${C24_ALLGEMEIN_TAB_LINK} >> nth=0
    @{result}=    Browser.Get Elements    ${C24_TARIF_DETAIL_TAB} >> ${C24_ALLGEMEIN_TAB_DETILS} >> ${C24_COMPARE_BOX}
    &{details_ergebnisse}=    Create Dictionary
    FOR    ${element}    IN    @{result}
        ${detail_text}=    Browser.Get Text    ${element} >> ${C24_COMPARE_BOX_TEXT} >> nth=0
        ${wert_sichtbar}=    Run Keyword And Return Status    Browser.Get Text    ${element} >> ${C24_COMPARE_BOX_VALUE} >> nth=0
        IF    ${wert_sichtbar}
            ${detail_wert}=    Browser.Get Text    ${element} >> ${C24_COMPARE_BOX_VALUE} >> nth=0
        ELSE
            ${detail_wert}=    Set Variable    ${EMPTY}
        END
        Set To Dictionary    ${details_ergebnisse}    ${detail_text}    ${detail_wert}
    END
    # Log the created dictionary
    Log    ${details_ergebnisse}
    RETURN    ${details_ergebnisse}

Details prüfen
    [Documentation]    Prüft die Details des Tarifs anhand der übergebenen Eigenschaft und des Werts.
    [Arguments]    ${eigenschaft}    ${wert}    &{eigenschaft_werte_dict}
    ${retrieved_value}=    Get From Dictionary    ${eigenschaft_werte_dict}    ${eigenschaft}    ${NONE}
    ${normalized_retrieved_value}=    Replace String    ${retrieved_value}    \xa0    ${SPACE}
    ${normalized_wert}=    Replace String    ${wert}    \xa0    ${SPACE}
    Should Be Equal As Strings    ${normalized_retrieved_value}    ${normalized_wert}

Vergleicher starten
    [Documentation]    Startet den Versicherungsvergleich im Browser.
    # To-do: Größes für Demo anpassen
    Browser.New Browser    headless=${headless}    args=['--window-position=-8,0']
    Browser.New Page    ${url}
    Browser.Set Viewport Size    1920    1080
    Click    body > div.c24-cookie-consent-wrapper > div.c24-cookie-consent-notice > div.c24-cookie-consent-notice-cnt.clearfix > a


Vergleicher beenden
    [Documentation]    Beendet den Versicherungsvergleich und schließt den Browser.
    Browser.Close Browser

# Finde das Listenelement basierend auf Versicherernamen und Tarifnamen in der Liste der Tarife
# //div[@class="content_result"]
Finde Tarif
    [Documentation]    Findet den Tarif basierend auf dem Versicherungs- und Tarifnamen in der Liste der Tarife.
    [Arguments]    ${versicherung}    ${tarif}    @{tarife}
    ${found} =    Set Variable    ${False}
    FOR    ${element}    IN    @{tarife}
        ${img} =    Catenate    ${element}    >> img[class="provider_logo"]
        ${v_ist} =    Get Attribute    ${img}    alt
        
        # Check Versicherung
        IF    $v_ist == $versicherung
            ${div} =    Catenate    ${element}    >> div[class="tariff_name tariff_name-recommendation-rate"]
            ${t_ist} =    Browser.Get Text    ${div}
            Log To Console    ${v_ist} ${t_ist}
            # Check Tarif
            IF    $t_ist == $tarif
                ${found} =    Set Variable    ${element}
                BREAK
            END
        ELSE
            Log To Console    ${v_ist}
        END
    END

    # Return found element or False
    RETURN    ${found}        
