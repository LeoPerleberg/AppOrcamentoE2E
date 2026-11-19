*** Settings ***
Resource    app.resource

*** Variables ***
${MATERIAL_PADRAO}    Quadro A4
${SERVICO_PADRAO}     Impressão complexa
${PRODUTO_BASE}       Quadro teste
${PICKER_SEARCH}      xpath=//android.widget.EditText

*** Keywords ***
Informar Produto
    [Arguments]    ${nome}
    Preencher Campo    ${PRODUCT_FIELD}    ${nome}    Produto

Produto Deve Ser
    [Arguments]    ${nome}
    Campo Deve Conter    ${PRODUCT_FIELD}    ${nome}    Produto

Adicionar Linha
    [Arguments]    ${numero}    ${tipo}
    Tocar Botao    + ${tipo}
    Texto Deve Estar Visivel    Item ${numero}

Localizador Da Selecao Da Linha
    [Arguments]    ${numero}    ${selecao}
    RETURN    xpath=//*[@text="Item ${numero}"]/following-sibling::android.widget.Button[@content-desc="${selecao}" and preceding-sibling::android.widget.TextView[starts-with(@text, "Item ")][1][@text="Item ${numero}"]][1]

Abrir Seletor Da Linha
    [Arguments]    ${numero}    ${selecao}=Selecionar...
    Texto Deve Estar Visivel    Item ${numero}
    ${localizador}=    Localizador Da Selecao Da Linha    ${numero}    ${selecao}
    Exibir Elemento    ${localizador}    Item ${numero}
    Click Element    ${localizador}
    Wait Until Keyword Succeeds    3x    500ms    Wait Until Element Is Visible    ${PICKER_SEARCH}    5s

Pesquisar No Seletor
    [Arguments]    ${texto}
    Preencher Campo    ${PICKER_SEARCH}    ${texto}    Buscar...

Escolher Opcao Do Seletor
    [Arguments]    ${nome}
    ${localizador}=    Set Variable    xpath=//android.widget.Button[.//android.widget.TextView[@text="${nome}"]]
    Exibir Elemento    ${localizador}    ${nome}
    Click Element    ${localizador}

Selecionar Item Na Linha
    [Arguments]    ${numero}    ${nome}
    Abrir Seletor Da Linha    ${numero}
    Pesquisar No Seletor    ${nome}
    Escolher Opcao Do Seletor    ${nome}

Localizador Do Campo Da Linha
    [Arguments]    ${numero}    ${campo}
    IF    $campo == 'quantidade'
        ${posicao}=    Set Variable    1
    ELSE IF    $campo == 'margem'
        ${posicao}=    Set Variable    2
    ELSE
        Fail    Campo de precificação desconhecido: ${campo}
    END
    RETURN    xpath=(//*[@text="Item ${numero}"]/following-sibling::android.widget.EditText[preceding-sibling::android.widget.TextView[starts-with(@text, "Item ")][1][@text="Item ${numero}"]])[${posicao}]

Preencher Campo Da Linha
    [Arguments]    ${numero}    ${campo}    ${valor}
    ${localizador}=    Localizador Do Campo Da Linha    ${numero}    ${campo}
    Preencher Campo    ${localizador}    ${valor}    Item ${numero}

Campo Da Linha Deve Ser
    [Arguments]    ${numero}    ${campo}    ${valor}
    ${localizador}=    Localizador Do Campo Da Linha    ${numero}    ${campo}
    Campo Deve Conter    ${localizador}    ${valor}    Item ${numero}

Localizador Do Tipo Da Linha
    [Arguments]    ${numero}    ${tipo}
    RETURN    xpath=//*[@text="Item ${numero}"]/following-sibling::android.view.ViewGroup[1]//android.widget.Button[@content-desc="${tipo}"]

Tipo Da Linha Deve Ser
    [Arguments]    ${numero}    ${tipo}
    ${localizador}=    Localizador Do Tipo Da Linha    ${numero}    ${tipo}
    Exibir Elemento    ${localizador}    Item ${numero}
    Element Attribute Should Match    ${localizador}    selected    true

Alterar Tipo Da Linha
    [Arguments]    ${numero}    ${tipo}
    ${localizador}=    Localizador Do Tipo Da Linha    ${numero}    ${tipo}
    Exibir Elemento    ${localizador}    Item ${numero}
    Click Element    ${localizador}

Selecao Da Linha Deve Ser
    [Arguments]    ${numero}    ${selecao}
    ${localizador}=    Localizador Da Selecao Da Linha    ${numero}    ${selecao}
    Exibir Elemento    ${localizador}    Item ${numero}

Adicionar Linha Selecionada
    [Arguments]    ${numero}    ${tipo}    ${nome}    ${quantidade}=1    ${margem}=100
    Adicionar Linha    ${numero}    ${tipo}
    Selecionar Item Na Linha    ${numero}    ${nome}
    IF    $quantidade != '1'
        Preencher Campo Da Linha    ${numero}    quantidade    ${quantidade}
    END
    IF    $margem != '100'
        Preencher Campo Da Linha    ${numero}    margem    ${margem}
    END

Montar Precificacao Base
    Informar Produto    ${PRODUTO_BASE}
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}    2    50
    Adicionar Linha Selecionada    2    Serviço    ${SERVICO_PADRAO}    3    100

Valor Da Linha Deve Ser
    [Arguments]    ${numero}    ${rotulo}    ${esperado}
    ${localizador}=    Set Variable    xpath=//*[@text="Item ${numero}"]/following-sibling::android.widget.TextView[@text="${rotulo}" and preceding-sibling::android.widget.TextView[starts-with(@text, "Item ")][1][@text="Item ${numero}"]][1]/following-sibling::android.widget.TextView[1]
    Exibir Elemento    ${localizador}    Item ${numero}
    Wait Until Keyword Succeeds    5s    250ms    Element Text Should Be    ${localizador}    ${esperado}

Totais Da Precificacao Devem Ser
    [Arguments]    ${custo}    ${preco}
    Valor Deve Ser    Custo total    ${custo}
    Valor Deve Ser    Preço total    ${preco}

Abrir Resumo
    Esconder Teclado Se Necessario
    Tocar Botao    Ver resumo
    Texto Deve Estar Visivel    Itens

Voltar Para Edicao
    Tocar Botao    Editar
    Wait Until Keyword Succeeds    3x    500ms    Wait Until Element Is Visible    xpath=//android.widget.Button[@content-desc="Ver resumo"]    5s
