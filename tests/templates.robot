*** Settings ***
Documentation    Casos de criacao, uso e exclusao de modelos.
Resource         ../resources/templates.resource
Resource         ../resources/catalog.resource
Test Setup       Abrir Aplicacao
Test Teardown    Fechar Aplicacao

*** Test Cases ***
CT-33 - Usar O Modelo Inicial Com A Precificacao Vazia
    [Tags]    ct-33    p1
    Selecionar Aba    Modelos
    Valor Do Modelo Deve Ser    ${MODELO_INICIAL}    Custo atual    R$ 11,35
    Valor Do Modelo Deve Ser    ${MODELO_INICIAL}    Preço sugerido    R$ 22,70
    Tocar Botao Do Modelo    ${MODELO_INICIAL}    Usar
    Produto Deve Ser    ${MODELO_INICIAL}
    Selecao Da Linha Deve Ser    1    Quadro A4
    Selecao Da Linha Deve Ser    2    Papel fotográfico 230g
    Selecao Da Linha Deve Ser    3    Impressão complexa
    Selecao Da Linha Deve Ser    4    Montagem canva simples
    Totais Da Precificacao Devem Ser    R$ 11,35    R$ 22,70

CT-34 - Salvar A Precificacao Como Modelo
    [Tags]    ct-34    p1
    Informar Produto    Projeto QA
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}    2    50
    Salvar Modelo Atual
    Selecionar Aba    Modelos
    Valor Do Modelo Deve Ser    Projeto QA    Custo atual    R$ 16,00
    Valor Do Modelo Deve Ser    Projeto QA    Preço sugerido    R$ 24,00
    Page Should Contain Element    xpath=//*[@text="• 2 un Quadro A4"]

CT-35 - Rejeitar Modelo Sem Nome Ou Item Selecionado
    [Tags]    ct-35    p1
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}
    Tocar Botao    Salvar como modelo
    Texto Deve Estar Visivel    Informe o nome do produto e selecione ao menos um item.
    Confirmar Alerta
    Tocar Botao    Limpar
    Confirmar Alerta
    Informar Produto    Projeto QA
    Adicionar Linha    1    Material
    Tocar Botao    Salvar como modelo
    Texto Deve Estar Visivel    Informe o nome do produto e selecione ao menos um item.
    Confirmar Alerta
    Selecionar Aba    Modelos
    Texto Deve Estar Visivel    ${MODELO_INICIAL}
    Page Should Not Contain Element    xpath=//android.widget.TextView[@text="Projeto QA"]

CT-36 - Cancelar E Confirmar Substituicao De Modelo Existente
    [Tags]    ct-36    p1
    Informar Produto    quadro a4 personalizado
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}    2    50
    Tocar Botao    Salvar como modelo
    Texto Deve Estar Visivel    Modelo existente
    Cancelar Alerta
    Selecionar Aba    Modelos
    Valor Do Modelo Deve Ser    ${MODELO_INICIAL}    Custo atual    R$ 11,35
    Selecionar Aba    Precificação
    Tocar Botao    Salvar como modelo
    Texto Deve Estar Visivel    Modelo existente
    Confirmar Alerta
    Texto Deve Estar Visivel    Modelo atualizado
    Confirmar Alerta
    Selecionar Aba    Modelos
    Valor Do Modelo Deve Ser    quadro a4 personalizado    Custo atual    R$ 16,00
    Valor Do Modelo Deve Ser    quadro a4 personalizado    Preço sugerido    R$ 24,00
    Page Should Not Contain Element    xpath=//*[@text="Quadro A4 personalizado"]

CT-37 - Cancelar E Confirmar Uso De Modelo Sobre Precificacao Atual
    [Tags]    ct-37    p1
    Informar Produto    Produto QA
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}
    Selecionar Aba    Modelos
    Tocar Botao Do Modelo    ${MODELO_INICIAL}    Usar
    Cancelar Alerta
    Selecionar Aba    Precificação
    Produto Deve Ser    Produto QA
    Totais Da Precificacao Devem Ser    R$ 8,00    R$ 16,00
    Selecionar Aba    Modelos
    Tocar Botao Do Modelo    ${MODELO_INICIAL}    Usar
    Confirmar Alerta
    Produto Deve Ser    ${MODELO_INICIAL}
    Selecao Da Linha Deve Ser    1    Quadro A4
    Selecao Da Linha Deve Ser    4    Montagem canva simples
    Totais Da Precificacao Devem Ser    R$ 11,35    R$ 22,70

CT-38 - Recalcular Modelo Com Custo Atualizado
    [Tags]    ct-38    p1
    Abrir Cadastro    Material
    Editar Item Do Cadastro    Material    ${MATERIAL_PADRAO}
    Informar Custo Do Cadastro    Material    10,00
    Tocar Botao    Salvar alterações
    Selecionar Aba    Modelos
    Valor Do Modelo Deve Ser    ${MODELO_INICIAL}    Custo atual    R$ 13,35
    Valor Do Modelo Deve Ser    ${MODELO_INICIAL}    Preço sugerido    R$ 26,70

CT-39 - Cancelar E Confirmar Exclusao De Modelo
    [Tags]    ct-39    p2
    Informar Produto    Produto QA
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}
    Selecionar Aba    Modelos
    Tocar Botao Do Modelo    ${MODELO_INICIAL}    Excluir
    Cancelar Alerta
    Texto Deve Estar Visivel    ${MODELO_INICIAL}
    Tocar Botao Do Modelo    ${MODELO_INICIAL}    Excluir
    Confirmar Alerta
    Wait Until Element Is Visible    ${EMPTY_TEMPLATES}
    Selecionar Aba    Precificação
    Produto Deve Ser    Produto QA
    Selecao Da Linha Deve Ser    1    ${MATERIAL_PADRAO}
