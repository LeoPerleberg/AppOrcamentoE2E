*** Settings ***
Resource    pricing.resource

*** Variables ***
${CATALOG_NAME}    xpath=//*[@text="Nome"]/following-sibling::android.widget.EditText[1]
${CATALOG_UNIT}    xpath=//*[@text="Nome"]/following-sibling::android.widget.EditText[2]

*** Keywords ***
Selecionar Categoria Do Cadastro
    [Arguments]    ${tipo}
    IF    $tipo == 'Material'
        ${categoria}=    Set Variable    Materiais
    ELSE IF    $tipo == 'Serviço'
        ${categoria}=    Set Variable    Serviços
    ELSE
        Fail    Categoria de cadastro desconhecida: ${tipo}
    END
    Texto Deve Estar Visivel    Nome
    ${localizador}=    Set Variable    xpath=//android.widget.Button[starts-with(@content-desc, "${categoria} (")]
    Wait Until Element Is Visible    ${localizador}    15s
    Click Element    ${localizador}

Abrir Cadastro
    [Arguments]    ${tipo}
    Selecionar Aba    Cadastros
    Selecionar Categoria Do Cadastro    ${tipo}

Localizador Do Custo Do Cadastro
    [Arguments]    ${tipo}
    IF    $tipo == 'Material'
        ${posicao}=    Set Variable    3
    ELSE IF    $tipo == 'Serviço'
        ${posicao}=    Set Variable    2
    ELSE
        Fail    Categoria de cadastro desconhecida: ${tipo}
    END
    RETURN    xpath=(//*[@text="Nome"]/following-sibling::android.widget.EditText)[${posicao}]

Informar Nome Do Cadastro
    [Arguments]    ${nome}
    Preencher Campo    ${CATALOG_NAME}    ${nome}    Nome

Informar Unidade Do Cadastro
    [Arguments]    ${unidade}
    Preencher Campo    ${CATALOG_UNIT}    ${unidade}    Nome

Informar Custo Do Cadastro
    [Arguments]    ${tipo}    ${custo}
    ${localizador}=    Localizador Do Custo Do Cadastro    ${tipo}
    Preencher Campo    ${localizador}    ${custo}    Nome

Cadastrar Item
    [Arguments]    ${tipo}    ${nome}    ${custo}    ${unidade}=${EMPTY}
    Abrir Cadastro    ${tipo}
    Informar Nome Do Cadastro    ${nome}
    IF    $tipo == 'Material' and $unidade != ''
        Informar Unidade Do Cadastro    ${unidade}
    END
    Informar Custo Do Cadastro    ${tipo}    ${custo}
    Tocar Botao    Adicionar

Item Do Cadastro Deve Conter
    [Arguments]    ${nome}    ${detalhe}
    ${localizador}=    Set Variable    xpath=//android.widget.Button[.//android.widget.TextView[@text="${nome}"]]
    Exibir Elemento    ${localizador}    ${nome}
    Element Attribute Should Match    ${localizador}    content-desc    *${detalhe}*

Editar Item Do Cadastro
    [Arguments]    ${tipo}    ${nome}
    ${localizador}=    Set Variable    xpath=//android.widget.Button[.//android.widget.TextView[@text="${nome}"]]
    Exibir Elemento    ${localizador}    ${nome}
    Click Element    ${localizador}
    Texto Deve Estar Visivel    Editar ${tipo.lower()}

Solicitar Exclusao Do Cadastro
    [Arguments]    ${nome}
    ${localizador}=    Set Variable    accessibility_id=Excluir ${nome}
    Exibir Elemento    ${localizador}    ${nome}
    Click Element    ${localizador}
    Wait Until Element Is Visible    ${ALERT_CONFIRM}    15s
