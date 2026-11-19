*** Settings ***
Resource    pricing.resource

*** Variables ***
${MODELO_INICIAL}    Quadro A4 personalizado
${EMPTY_TEMPLATES}   xpath=//*[contains(@text, "Nenhum modelo cadastrado.")]

*** Keywords ***
Tocar Botao Do Modelo
    [Arguments]    ${nome}    ${botao}
    ${localizador}=    Set Variable    xpath=//*[@text="${nome}"]/following-sibling::android.widget.Button[@content-desc="${botao}"][1]
    Exibir Elemento    ${localizador}    ${nome}
    Click Element    ${localizador}

Valor Do Modelo Deve Ser
    [Arguments]    ${nome}    ${rotulo}    ${esperado}
    ${localizador}=    Set Variable    xpath=//*[@text="${nome}"]/following-sibling::android.widget.TextView[@text="${rotulo}"][1]/following-sibling::android.widget.TextView[1]
    Exibir Elemento    ${localizador}    ${nome}
    Element Text Should Be    ${localizador}    ${esperado}

Salvar Modelo Atual
    Tocar Botao    Salvar como modelo
    Texto Deve Estar Visivel    Modelo salvo
    Confirmar Alerta
