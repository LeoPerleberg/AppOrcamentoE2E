*** Settings ***
Documentation    Casos de cadastro de materiais e servicos.
Resource         ../resources/catalog.resource
Resource         ../resources/summary.resource
Test Setup       Abrir Aplicacao
Test Teardown    Fechar Aplicacao

*** Test Cases ***
CT-23 - Cadastrar Material Com Unidade Padrao
    [Tags]    ct-23    p1
    Cadastrar Item    Material    Material QA    3,50
    Item Do Cadastro Deve Conter    Material QA    R$ 3,50 / un
    Selecionar Aba    Precificação
    Adicionar Linha Selecionada    1    Material    Material QA
    Totais Da Precificacao Devem Ser    R$ 3,50    R$ 7,00

CT-24 - Cadastrar E Selecionar Um Servico
    [Tags]    ct-24    p1
    Cadastrar Item    Serviço    Serviço QA    2,50
    Item Do Cadastro Deve Conter    Serviço QA    R$ 2,50
    Selecionar Aba    Precificação
    Adicionar Linha Selecionada    1    Serviço    Serviço QA
    Totais Da Precificacao Devem Ser    R$ 2,50    R$ 5,00

CT-25 - Aceitar Item Com Custo Zero
    [Tags]    ct-25    p2
    Cadastrar Item    Serviço    Serviço gratuito QA    0
    Selecionar Aba    Precificação
    Informar Produto    Produto QA
    Adicionar Linha Selecionada    1    Serviço    Serviço gratuito QA
    Abrir Resumo
    Valores Do Resumo Devem Ser    R$ 0,00    R$ 0,00    R$ 0,00
    Botao Deve Estar Habilitado    Aprovar

CT-26 - Rejeitar Dados Obrigatorios Vazios E Custo Negativo
    [Tags]    ct-26    p1
    Abrir Cadastro    Material
    Informar Nome Do Cadastro    ${SPACE}${SPACE}${SPACE}
    Informar Custo Do Cadastro    Material    1
    Tocar Botao    Adicionar
    Texto Deve Estar Visivel    Dados inválidos
    Confirmar Alerta
    Informar Nome Do Cadastro    Material inválido
    Informar Custo Do Cadastro    Material    ${EMPTY}
    Tocar Botao    Adicionar
    Texto Deve Estar Visivel    Dados inválidos
    Confirmar Alerta
    Informar Custo Do Cadastro    Material    -1
    ${campo}=    Localizador Do Custo Do Cadastro    Material
    ${custo}=    Get Element Attribute    ${campo}    text
    IF    $custo == '-1'
        Tocar Botao    Adicionar
        Texto Deve Estar Visivel    Dados inválidos
        Confirmar Alerta
    ELSE
        Should Not Contain    ${custo}    -
        Log    O teclado do dispositivo não permitiu inserir um custo negativo.
    END
    Page Should Contain Element    xpath=//android.widget.Button[@content-desc="Materiais (23)"]

CT-27 - Rejeitar Nome Duplicado Na Mesma Categoria
    [Tags]    ct-27    p1
    Abrir Cadastro    Material
    Informar Nome Do Cadastro    ${SPACE}quadro a4${SPACE}
    Informar Custo Do Cadastro    Material    8
    Tocar Botao    Adicionar
    Texto Deve Estar Visivel    Item duplicado
    Confirmar Alerta
    Page Should Contain Element    xpath=//android.widget.Button[@content-desc="Materiais (23)"]

CT-28 - Cancelar Edicao E Recalcular A Precificacao Ao Salvar
    [Tags]    ct-28    p1
    Adicionar Linha Selecionada    1    Material    ${MATERIAL_PADRAO}    2    50
    Abrir Cadastro    Material
    Editar Item Do Cadastro    Material    ${MATERIAL_PADRAO}
    Informar Custo Do Cadastro    Material    9,00
    Tocar Botao    Cancelar
    Item Do Cadastro Deve Conter    ${MATERIAL_PADRAO}    R$ 8,00 / un
    Editar Item Do Cadastro    Material    ${MATERIAL_PADRAO}
    Informar Custo Do Cadastro    Material    10,00
    Tocar Botao    Salvar alterações
    Item Do Cadastro Deve Conter    ${MATERIAL_PADRAO}    R$ 10,00 / un
    Selecionar Aba    Precificação
    Totais Da Precificacao Devem Ser    R$ 20,00    R$ 30,00

CT-29 - Cancelar E Confirmar Exclusao De Item Sem Uso
    [Tags]    ct-29    p1
    Cadastrar Item    Material    Material QA    3,50
    Solicitar Exclusao Do Cadastro    Material QA
    Cancelar Alerta
    Item Do Cadastro Deve Conter    Material QA    R$ 3,50 / un
    Solicitar Exclusao Do Cadastro    Material QA
    Confirmar Alerta
    Texto Deve Estar Visivel    Nome
    Page Should Contain Element    xpath=//android.widget.Button[@content-desc="Materiais (23)"]
    Selecionar Aba    Precificação
    Adicionar Linha    1    Material
    Abrir Seletor Da Linha    1
    Pesquisar No Seletor    Material QA
    Texto Deve Estar Visivel    Nenhum item encontrado.
    Tocar Botao    Cancelar

CT-30 - Impedir Exclusao De Item Em Uso Na Precificacao
    [Tags]    ct-30    p1
    Cadastrar Item    Material    Material QA    3,50
    Selecionar Aba    Precificação
    Adicionar Linha Selecionada    1    Material    Material QA
    Abrir Cadastro    Material
    Solicitar Exclusao Do Cadastro    Material QA
    Confirmar Alerta
    Texto Deve Estar Visivel    Item em uso
    Texto Deve Estar Visivel    Remova este item da precificação atual antes de excluí-lo.
    Confirmar Alerta
    Item Do Cadastro Deve Conter    Material QA    R$ 3,50 / un

CT-31 - Impedir Exclusao De Item Em Uso Em Modelo
    [Tags]    ct-31    p1
    Abrir Cadastro    Material
    Solicitar Exclusao Do Cadastro    ${MATERIAL_PADRAO}
    Confirmar Alerta
    Texto Deve Estar Visivel    Item em uso
    Texto Deve Estar Visivel    Este item faz parte de um modelo. Exclua o modelo ou atualize-o antes de excluir o item.
    Confirmar Alerta
    Item Do Cadastro Deve Conter    ${MATERIAL_PADRAO}    R$ 8,00 / un

CT-32 - Limpar Formulario Ao Alternar Categoria
    [Tags]    ct-32    p2
    Abrir Cadastro    Material
    Informar Nome Do Cadastro    Rascunho QA
    Informar Custo Do Cadastro    Material    3,50
    Selecionar Categoria Do Cadastro    Serviço
    Selecionar Categoria Do Cadastro    Material
    Campo Deve Conter    ${CATALOG_NAME}    ${EMPTY}    Nome
    ${custo}=    Localizador Do Custo Do Cadastro    Material
    Campo Deve Conter    ${custo}    0,00    Nome
