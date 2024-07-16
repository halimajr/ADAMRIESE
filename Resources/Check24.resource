*** Settings ***
Library    Browser
Library    String

*** Variables ***
${headless}                  ${False}
${url}                       https://www.check24.de/
${versicherungsgeber}        Adam Riese
${TIMEOUT}                   5s
&{YES_NO}                    ja=yes    nein=no
&{PROTECTION_LEVEL}          ja=basic  nein=none
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

# ${C24_}



*** Keywords ***

# 
Produkt auswählen
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
    [Arguments]    ${datum}
    Click    ${C24_UI_BIRTHDATE}
    Type Text    ${C24_UI_BIRTHDATE}    ${datum}

Postleitzahl Eingeben
    [Arguments]    ${plz}
    Click    ${C24_UI_ZIPCODE}
    Type Text    ${C24_UI_ZIPCODE}    ${plz}

Stadt Auswählen
    [Arguments]    ${ort}
    Select Options By    ${C24_UI_CITY}    value    ${ort}
    Sleep    1 seconds

Postleitzahl Und Stadt Eingeben
    [Arguments]    ${plz}    ${ort}
    Postleitzahl Eingeben    ${plz}
    Stadt Auswählen    ${ort}

Anzahl Kinder Eingeben
    [Arguments]    ${anzahl}
    Click    ${C24_UI_CHILDREN_COUNT}//input[@value=${anzahl}]/following-sibling::div


Kinder Unter 10 Auswählen
    [Arguments]    ${kinder_unter_zehn}
    Click    ${C24_UI_CHILDREN_UNDER7OR10}//input[@value="${YES_NO}[${kinder_unter_zehn}]"]/following-sibling::div

Empfehlung Stiftung Warentest Beachten
    [Arguments]    ${swt}
    Click    ${C24_UI_PROTECTION_LEVEL}//input[@value="${PROTECTION_LEVEL}[${swt}]"]/following-sibling::div

Öffentlicher Dienst Beschäftigt
    [Arguments]    ${od}
    Click    ${C24_UI_PUBLIC_SERVICE}//input[@value="${YES_NO}[${od}]"]/following-sibling::div

Individuelle Versicherungsleistungen Auswählen
    [Arguments]    ${iv}
    Click    ${C24_UI_TARGET_AUDIENCE}//input[@value="${YES_NO}[${iv}]"]/following-sibling::div

Risiken Im Dienst Versichern
    [Arguments]    ${dhw_wanted}    ${behruf}=Bundesgrenzschutz (ohne techn. Tätigkeit)
    Click    ${C24_UI_DHV_WANTED}//input[@value="${YES_NO}[${dhw_wanted}]"]/following-sibling::div
    IF    "${dhw_wanted}" == "ja"
        Type Text    //input[@id="occupation_me"]    ${behruf}
    END
    
Erstinformationen Bestätigen
    Click    ${C24_BAESTATIGEN}/following-sibling::label

Tarife Anzeigen    
    Click    ${C24_UI_SUBMIT}


Kunde eingeben
    [Arguments]    ${versicherte}    ${datum}    ${plz}    ${ort}    ${swt}    ${od}    ${iv}    ${dhw_wanted}=${EMPTY}    ${knd_count}=${EMPTY}    ${kuz}=${EMPTY} 
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
    IF    '${od}' == 'ja'    Risiken Im Dienst Versichern    ja

    Individuelle Versicherungsleistungen Auswählen    ${iv}

    Erstinformationen Bestätigen
    Tarife Anzeigen


# Finde den Tarif anhand der Eigenschaften der Subelemente
Tarif auswählen
    [Arguments]    ${tarif}
    # Sortieren nach Anbieter
    Click    //*[@id="sortbutton_provider"]/label

    # Klicke Adam Riese
    # Todo: by name 
    Click    //*[@id="content_result"]/div[2]/div/div[1]/div[2]/div/i

    @{result} =    Browser.Get Elements    //*[@id="content_result"]/div[@class="result_box"]
    #Log    ${result}
    ${found} =    Finde Tarif    ${versicherungsgeber}    ${tarif}    @{result}
    IF    not $found
        Fail
    ELSE
        Browser.Scroll To Element    ${found}
        Sleep    5 seconds
    END
    Set Test Variable    ${tarif}    ${found}
    
# Tarifübersicht prüfen
Übersicht prüfen
    [Arguments]    ${eigenschaft}    ${wert}
    # //*[@id="content_result"]/div[3]/div[2]/div[4]/div[1]/ul[1]
    # Todo: Idetify also other icons
    ${list} =    Catenate    ${tarif}    >> span[class="c24pv_bullet_text c24pv_bullet_icon-good"]
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
            END
        ELSE
            Continue For Loop
        END

    END
    Run Keyword and Continue on Failure    FAIL    Tarifeigenschaft $eigenschaft nicht gefunden! 

# Tarifdetails prüfen
Details prüfen
    [Arguments]    ${eigenschaft}    ${wert}
    # Todo: alles
    Fail

Vergleicher starten
    # Todo: Größes für Demo anpassen
    Browser.New Browser    headless=${headless}
    Browser.New Page    ${url}
    Browser.Set Viewport Size    1920    1080
    Click    body > div.c24-cookie-consent-wrapper > div.c24-cookie-consent-notice > div.c24-cookie-consent-notice-cnt.clearfix > a

Vergleicher beenden
    Browser.Close Browser

# Finde das Listenelement basierend auf Versicherernamen und Tarifnamen in der Liste der Tarife
Finde Tarif
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
