*** Settings ***
Documentation    Caso de reinicio e armazenamento em memoria.
Resource         ../resources/catalog.resource
Resource         ../resources/summary.resource
Resource         ../resources/templates.resource
Test Setup       Abrir Aplicacao
Test Teardown    Fechar Aplicacao

*** Test Cases ***
CT-40 - Restaurar Estado Inicial Ao Reiniciar O Aplicativo
    [Tags]    ct-40    p1
    Cadastrar Item    Material    Material QA    3,50
    Selecionar Aba    Precificação
    Informar Produto    Projeto QA
    Adicionar Linha Selecionada    1    Material    Material QA
    Salvar Modelo Atual
    Aprovar Precificacao
    Terminate Application    ${APP_PACKAGE}
    Activate Application    ${APP_PACKAGE}
    Wait Until Element Is Visible    ${EMPTY_STATE}    30s
    Campo Deve Conter    ${PRODUCT_FIELD}    Ex.: Quadro personalizado    Produto
    Selecionar Aba    Aprovadas
    Lista De Aprovadas Deve Estar Vazia
    Selecionar Aba    Modelos
    Texto Deve Estar Visivel    ${MODELO_INICIAL}
    Page Should Not Contain Element    xpath=//*[@text="Projeto QA"]
    Abrir Cadastro    Material
    Page Should Contain Element    xpath=//android.widget.Button[@content-desc="Materiais (23)"]
    Selecionar Aba    Precificação
    Adicionar Linha    1    Material
    Abrir Seletor Da Linha    1
    Pesquisar No Seletor    Material QA
    Texto Deve Estar Visivel    Nenhum item encontrado.
    Tocar Botao    Cancelar
