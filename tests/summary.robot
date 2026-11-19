*** Settings ***
Documentation    Casos de resumo e precificacoes aprovadas.
Resource         ../resources/summary.resource
Resource         ../resources/catalog.resource
Test Setup       Abrir Aplicacao
Test Teardown    Fechar Aplicacao

*** Test Cases ***
CT-15 - Abrir Resumo Sem Produto E Sem Itens
    [Tags]    ct-15    p1
    Abrir Resumo
    Texto Deve Estar Visivel    Produto sem nome
    Texto Deve Estar Visivel    Nenhum item válido.
    Valores Do Resumo Devem Ser    R$ 0,00    R$ 0,00    R$ 0,00
    Botao Deve Estar Desabilitado    Aprovar

CT-16 - Impedir Aprovacao Sem Nome De Produto
    [Tags]    ct-16    p1
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}
    Abrir Resumo
    Botao Deve Estar Desabilitado    Aprovar
    Voltar Para Edicao
    Informar Produto    ${SPACE}${SPACE}${SPACE}
    Abrir Resumo
    Botao Deve Estar Desabilitado    Aprovar

CT-17 - Impedir Aprovacao Sem Item Valido
    [Tags]    ct-17    p1
    Informar Produto    Produto QA
    Adicionar Linha    1    Material
    Abrir Resumo
    Texto Deve Estar Visivel    Nenhum item válido.
    Botao Deve Estar Desabilitado    Aprovar

CT-18 - Conferir Resumo E Voltar Para Edicao
    [Tags]    ct-18    p1
    Montar Precificacao Base
    Abrir Resumo
    Texto Deve Estar Visivel    ${PRODUTO_BASE}
    Page Should Contain Element    xpath=//*[contains(@text, "Quadro A4")]
    Page Should Contain Element    xpath=//*[contains(@text, "Impressão complexa")]
    Valores Do Resumo Devem Ser    R$ 19,00    R$ 11,00    R$ 30,00
    Voltar Para Edicao
    Produto Deve Ser    ${PRODUTO_BASE}
    Selecao Da Linha Deve Ser    1    ${MATERIAL_PADRAO}
    Selecao Da Linha Deve Ser    2    ${SERVICO_PADRAO}
    Totais Da Precificacao Devem Ser    R$ 19,00    R$ 30,00

CT-19 - Cancelar A Aprovacao
    [Tags]    ct-19    p1
    Montar Precificacao Base
    Abrir Resumo
    Tocar Botao    Aprovar
    Cancelar Alerta
    Voltar Para Edicao
    Produto Deve Ser    ${PRODUTO_BASE}
    Totais Da Precificacao Devem Ser    R$ 19,00    R$ 30,00
    Selecionar Aba    Aprovadas
    Lista De Aprovadas Deve Estar Vazia

CT-20 - Aprovar E Limpar A Precificacao
    [Tags]    ct-20    p1    smoke
    Montar Precificacao Base
    Aprovar Precificacao
    Texto Deve Estar Visivel    ${PRODUTO_BASE}
    Page Should Contain Element    xpath=//*[contains(@text, "2 itens")]
    Valor Deve Ser    Custo    R$ 19,00
    Valor Deve Ser    Preço cobrado    R$ 30,00
    Selecionar Aba    Precificação
    Wait Until Element Is Visible    ${EMPTY_STATE}
    Campo Deve Conter    ${PRODUCT_FIELD}    Ex.: Quadro personalizado    Produto
    Totais Da Precificacao Devem Ser    R$ 0,00    R$ 0,00

CT-21 - Manter Dados Aprovados Apos Alterar E Excluir O Cadastro
    [Tags]    ct-21    p1
    Cadastrar Item    Material    Material QA    3,50
    Selecionar Aba    Precificação
    Informar Produto    Quadro QA
    Adicionar Linha Selecionada    1    Material    Material QA    2
    Aprovar Precificacao
    Abrir Cadastro    Material
    Editar Item Do Cadastro    Material    Material QA
    Informar Nome Do Cadastro    Material QA editado
    Informar Custo Do Cadastro    Material    5,00
    Tocar Botao    Salvar alterações
    Solicitar Exclusao Do Cadastro    Material QA editado
    Confirmar Alerta
    Abrir Aprovacao    Quadro QA
    Page Should Contain Element    xpath=//*[contains(@text, "Material QA (Material)")]
    Page Should Contain Element    xpath=//*[contains(@text, "2 un") and contains(@text, "R$ 3,50") and contains(@text, "R$ 7,00")]
    Page Should Not Contain Element    xpath=//*[contains(@text, "Material QA editado")]
    Valores Do Resumo Devem Ser    R$ 7,00    R$ 7,00    R$ 14,00

CT-22 - Cancelar E Confirmar Exclusao De Aprovacao
    [Tags]    ct-22    p2
    Montar Precificacao Base
    Aprovar Precificacao
    Abrir Aprovacao    ${PRODUTO_BASE}
    Tocar Botao    Excluir
    Cancelar Alerta
    Texto Deve Estar Visivel    ${PRODUTO_BASE}
    Tocar Botao    Excluir
    Confirmar Alerta
    Lista De Aprovadas Deve Estar Vazia
