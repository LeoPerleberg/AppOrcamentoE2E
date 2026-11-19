*** Settings ***
Resource    pricing.resource

*** Variables ***
${EMPTY_APPROVED}    xpath=//*[contains(@text, "Nenhuma precificação aprovada ainda.")]

*** Keywords ***
Valores Do Resumo Devem Ser
    [Arguments]    ${custo}    ${lucro}    ${preco}
    Valor Deve Ser    Custo total    ${custo}
    Valor Deve Ser    Lucro    ${lucro}
    Valor Deve Ser    Preço total cobrado    ${preco}

Aprovar Precificacao
    Abrir Resumo
    Botao Deve Estar Habilitado    Aprovar
    Tocar Botao    Aprovar
    Confirmar Alerta

Abrir Aprovacao
    [Arguments]    ${produto}
    Selecionar Aba    Aprovadas
    Tocar Texto    ${produto}
    Texto Deve Estar Visivel    Itens

Lista De Aprovadas Deve Estar Vazia
    Wait Until Element Is Visible    ${EMPTY_APPROVED}    15s
