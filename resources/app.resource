*** Settings ***
Library    AppiumLibrary    timeout=15    run_on_failure=No Operation

*** Variables ***
${APPIUM_URL}       http://127.0.0.1:4723
${DEVICE_NAME}      Android
${UDID}             emulator-5554
${APP_PACKAGE}      com.apporcamento
${APP_ACTIVITY}     com.apporcamento.MainActivity
${EMPTY_STATE}      xpath=//android.widget.TextView[@text="Nenhum item adicionado. Adicione materiais e serviços abaixo."]
${PRODUCT_FIELD}    xpath=//*[@text="Produto"]/following-sibling::android.widget.EditText[1]
${ALERT_CONFIRM}    id=android:id/button1
${ALERT_CANCEL}     id=android:id/button2

*** Keywords ***
Abrir Aplicacao
    Set Test Variable    $SESSION_OPEN    ${False}
    Open Application
    ...    ${APPIUM_URL}
    ...    platformName=Android
    ...    appium:automationName=UiAutomator2
    ...    appium:deviceName=${DEVICE_NAME}
    ...    appium:udid=${UDID}
    ...    appium:appPackage=${APP_PACKAGE}
    ...    appium:appActivity=${APP_ACTIVITY}
    ...    appium:noReset=${True}
    ...    appium:forceAppLaunch=${True}
    ...    appium:shouldTerminateApp=${True}
    Set Test Variable    $SESSION_OPEN    ${True}
    Wait Until Element Is Visible    ${EMPTY_STATE}    30s

Fechar Aplicacao
    TRY
        IF    $SESSION_OPEN and '${TEST STATUS}' == 'FAIL'
            Capture Page Screenshot
        END
    FINALLY
        Close All Applications
    END

Esconder Teclado Se Necessario
    ${aberto}=    Is Keyboard Shown
    IF    $aberto
        Hide Keyboard
    END

Elemento Esta Visivel
    [Arguments]    ${localizador}    ${tentativas}=1x
    TRY
        Wait Until Keyword Succeeds    ${tentativas}    300ms
        ...    Wait Until Element Is Visible    ${localizador}    1s
    EXCEPT    *did not match any elements after*    *was not visible in*    *StaleElementReferenceException*    type=GLOB
        RETURN    ${False}
    END
    RETURN    ${True}

Exibir Elemento
    [Arguments]    ${localizador}    ${texto_rolagem}
    ${visivel}=    Elemento Esta Visivel    ${localizador}    3x
    IF    not $visivel
        Log    Procurando o elemento por rolagem: ${texto_rolagem}    DEBUG
        ${rolagem}=    Set Variable    android=new UiScrollable(new UiSelector().scrollable(true).instance(0)).setMaxSearchSwipes(15).scrollIntoView(new UiSelector().text("${texto_rolagem}"))
        Wait Until Keyword Succeeds    3x    500ms    Wait Until Page Contains Element    ${rolagem}    5s
        ${visivel}=    Elemento Esta Visivel    ${localizador}
        IF    not $visivel
            ${largura}=    Get Window Width
            ${altura}=    Get Window Height
            ${x}=    Evaluate    int($largura * 0.5)
            ${inicio}=    Evaluate    int($altura * 0.65)
            ${fim}=    Evaluate    int($altura * 0.4)
            Swipe    start_x=${x}    start_y=${inicio}    end_x=${x}    end_y=${fim}    duration=500ms
        END
    END
    Wait Until Keyword Succeeds    3x    500ms    Wait Until Element Is Visible    ${localizador}    5s

Texto Deve Estar Visivel
    [Arguments]    ${texto}
    ${localizador}=    Set Variable    xpath=//*[@text="${texto}"]
    Exibir Elemento    ${localizador}    ${texto}

Tocar Texto
    [Arguments]    ${texto}
    ${localizador}=    Set Variable    xpath=//*[@text="${texto}"]
    Exibir Elemento    ${localizador}    ${texto}
    Click Element    ${localizador}

Tocar Botao
    [Arguments]    ${texto}
    ${localizador}=    Set Variable    xpath=//android.widget.Button[@content-desc="${texto}"]
    Exibir Elemento    ${localizador}    ${texto}
    Click Element    ${localizador}

Selecionar Aba
    [Arguments]    ${nome}
    Esconder Teclado Se Necessario
    ${localizador}=    Set Variable    xpath=//*[@clickable="true" and contains(@content-desc, ", ${nome}")]
    Wait Until Element Is Visible    ${localizador}    15s
    Click Element    ${localizador}

Preencher Campo
    [Arguments]    ${localizador}    ${valor}    ${texto_rolagem}
    Exibir Elemento    ${localizador}    ${texto_rolagem}
    Clear Text    ${localizador}
    IF    $valor != ''
        Input Text    ${localizador}    ${valor}
    END
    Esconder Teclado Se Necessario

Campo Deve Conter
    [Arguments]    ${localizador}    ${esperado}    ${texto_rolagem}
    Exibir Elemento    ${localizador}    ${texto_rolagem}
    ${atual}=    Get Element Attribute    ${localizador}    text
    Should Be Equal As Strings    ${atual}    ${esperado}

Valor Deve Ser
    [Arguments]    ${rotulo}    ${esperado}
    ${localizador}=    Set Variable    xpath=(//*[@text="${rotulo}"])[last()]/following-sibling::android.widget.TextView[1]
    Exibir Elemento    ${localizador}    ${rotulo}
    Wait Until Keyword Succeeds    5s    250ms    Element Text Should Be    ${localizador}    ${esperado}

Botao Deve Estar Desabilitado
    [Arguments]    ${texto}
    ${localizador}=    Set Variable    xpath=//android.widget.Button[@content-desc="${texto}"]
    Exibir Elemento    ${localizador}    ${texto}
    Expect Element    ${localizador}    disabled

Botao Deve Estar Habilitado
    [Arguments]    ${texto}
    ${localizador}=    Set Variable    xpath=//android.widget.Button[@content-desc="${texto}"]
    Exibir Elemento    ${localizador}    ${texto}
    Expect Element    ${localizador}    enabled

Confirmar Alerta
    Wait Until Element Is Visible    ${ALERT_CONFIRM}    15s
    Click Element    ${ALERT_CONFIRM}

Cancelar Alerta
    Wait Until Element Is Visible    ${ALERT_CANCEL}    15s
    Click Element    ${ALERT_CANCEL}
