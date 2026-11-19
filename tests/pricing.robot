*** Settings ***
Documentation    Casos de navegacao e precificacao no Android.
Resource         ../resources/pricing.resource
Test Setup       Abrir Aplicacao
Test Teardown    Fechar Aplicacao

*** Test Cases ***
CT-01 - Abrir A Tela De Precificacao Vazia
    [Tags]    ct-01    p1    smoke
    Wait Until Element Is Visible    ${EMPTY_STATE}
    Campo Deve Conter    ${PRODUCT_FIELD}    Ex.: Quadro personalizado    Produto
    Totais Da Precificacao Devem Ser    R$ 0,00    R$ 0,00
    Botao Deve Estar Desabilitado    Limpar

CT-02 - Preservar A Precificacao Ao Navegar Entre Abas
    [Tags]    ct-02    p2
    Informar Produto    Produto QA
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}
    Selecionar Aba    Modelos
    Texto Deve Estar Visivel    Quadro A4 personalizado
    Selecionar Aba    Cadastros
    Texto Deve Estar Visivel    Novo material
    Selecionar Aba    Aprovadas
    Wait Until Element Is Visible    xpath=//*[contains(@text, "Nenhuma precificação aprovada ainda.")]
    Selecionar Aba    Precificação
    Produto Deve Ser    Produto QA
    Selecao Da Linha Deve Ser    1    ${MATERIAL_PADRAO}
    Totais Da Precificacao Devem Ser    R$ 8,00    R$ 16,00

CT-03 - Adicionar Uma Linha De Material
    [Tags]    ct-03    p1    smoke
    Adicionar Linha    1    Material
    Page Should Not Contain Element    ${EMPTY_STATE}
    Tipo Da Linha Deve Ser    1    Material
    Selecao Da Linha Deve Ser    1    Selecionar...
    Campo Da Linha Deve Ser    1    quantidade    1
    Campo Da Linha Deve Ser    1    margem    100

CT-04 - Adicionar Uma Linha De Servico
    [Tags]    ct-04    p1
    Adicionar Linha    1    Serviço
    Tipo Da Linha Deve Ser    1    Serviço
    Selecao Da Linha Deve Ser    1    Selecionar...
    Campo Da Linha Deve Ser    1    quantidade    1
    Campo Da Linha Deve Ser    1    margem    100

CT-05 - Calcular Um Material Com Valores Padrao
    [Tags]    ct-05    p1
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}
    Valor Da Linha Deve Ser    1    Custo unitário    R$ 8,00
    Valor Da Linha Deve Ser    1    Custo total    R$ 8,00
    Valor Da Linha Deve Ser    1    Preço final    R$ 16,00
    Totais Da Precificacao Devem Ser    R$ 8,00    R$ 16,00

CT-06 - Calcular Quantidade Fracionaria
    [Tags]    ct-06    p1
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}    1,5
    Valor Da Linha Deve Ser    1    Custo total    R$ 12,00
    Valor Da Linha Deve Ser    1    Preço final    R$ 24,00
    Totais Da Precificacao Devem Ser    R$ 12,00    R$ 24,00

CT-07 - Calcular Diferentes Margens
    [Tags]    ct-07    p1
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}    2
    FOR    ${margem}    ${preco}    IN
    ...    0      R$ 16,00
    ...    50     R$ 24,00
    ...    100    R$ 32,00
        Preencher Campo Da Linha    1    margem    ${margem}
        Valor Da Linha Deve Ser    1    Preço final    ${preco}
        Totais Da Precificacao Devem Ser    R$ 16,00    ${preco}
    END

CT-08 - Somar Material E Servico
    [Tags]    ct-08    p1
    Montar Precificacao Base
    Totais Da Precificacao Devem Ser    R$ 19,00    R$ 30,00

CT-09 - Ignorar Quantidade Zero Ou Vazia
    [Tags]    ct-09    p1
    Informar Produto    Produto QA
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}
    FOR    ${quantidade}    IN    0    ${EMPTY}
        Preencher Campo Da Linha    1    quantidade    ${quantidade}
        Totais Da Precificacao Devem Ser    R$ 0,00    R$ 0,00
        Abrir Resumo
        Texto Deve Estar Visivel    Nenhum item válido.
        Botao Deve Estar Desabilitado    Aprovar
        Voltar Para Edicao
    END

CT-10 - Ignorar Linha Sem Item Selecionado
    [Tags]    ct-10    p2
    Informar Produto    Produto QA
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}
    Adicionar Linha    2    Serviço
    Totais Da Precificacao Devem Ser    R$ 8,00    R$ 16,00
    Abrir Resumo
    Page Should Contain Element    xpath=//android.widget.TextView[contains(@text, "Quadro A4 (Material)")]
    ${linhas}=    Get Matching Xpath Count    xpath=//android.widget.TextView[contains(@text, "(Material)") or contains(@text, "(Serviço)")]
    Should Be Equal As Integers    ${linhas}    1
    Page Should Not Contain Element    xpath=//*[contains(@text, "Nenhum item válido.")]

CT-11 - Pesquisar E Cancelar O Seletor
    [Tags]    ct-11    p2
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}
    Abrir Seletor Da Linha    1    ${MATERIAL_PADRAO}
    Pesquisar No Seletor    QUADRO
    Texto Deve Estar Visivel    Quadro A4
    Texto Deve Estar Visivel    Quadro A5
    Texto Deve Estar Visivel    Quadro 10x15
    Pesquisar No Seletor    XYZ-NENHUM-ITEM
    Texto Deve Estar Visivel    Nenhum item encontrado.
    Tocar Botao    Cancelar
    Selecao Da Linha Deve Ser    1    ${MATERIAL_PADRAO}
    Abrir Seletor Da Linha    1    ${MATERIAL_PADRAO}
    Campo Deve Conter    ${PICKER_SEARCH}    Buscar...    Buscar...
    Tocar Botao    Cancelar

CT-12 - Limpar Selecao Ao Mudar O Tipo Da Linha
    [Tags]    ct-12    p1
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}    2    50
    Alterar Tipo Da Linha    1    Serviço
    Tipo Da Linha Deve Ser    1    Serviço
    Selecao Da Linha Deve Ser    1    Selecionar...
    Campo Da Linha Deve Ser    1    quantidade    2
    Campo Da Linha Deve Ser    1    margem    50
    Totais Da Precificacao Devem Ser    R$ 0,00    R$ 0,00

CT-13 - Remover Uma Linha E Recalcular
    [Tags]    ct-13    p1
    Montar Precificacao Base
    ${remover}=    Set Variable    accessibility_id=Remover item 1
    Exibir Elemento    ${remover}    Item 1
    Click Element    ${remover}
    Texto Deve Estar Visivel    Item 1
    Tipo Da Linha Deve Ser    1    Serviço
    Selecao Da Linha Deve Ser    1    ${SERVICO_PADRAO}
    Totais Da Precificacao Devem Ser    R$ 3,00    R$ 6,00

CT-14 - Cancelar E Confirmar Limpeza Da Precificacao
    [Tags]    ct-14    p1
    Montar Precificacao Base
    Tocar Botao    Limpar
    Cancelar Alerta
    Produto Deve Ser    ${PRODUTO_BASE}
    Totais Da Precificacao Devem Ser    R$ 19,00    R$ 30,00
    Tocar Botao    Limpar
    Confirmar Alerta
    Wait Until Element Is Visible    ${EMPTY_STATE}
    Campo Deve Conter    ${PRODUCT_FIELD}    Ex.: Quadro personalizado    Produto
    Totais Da Precificacao Devem Ser    R$ 0,00    R$ 0,00
    Botao Deve Estar Desabilitado    Limpar
