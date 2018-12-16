# Marcos
FIAP:
Aluno: Marcos V. S. Matsuda

App ComprasUSA

Trabalho das matérias:
- Introdução SWIFT
- Desenvolvimento de aplicações IOS
- Desenvolvimento de aplicações IOS para cloud computing

Requisitos:
1. DescriçãodoAplicativoaserdesenvolvido
Você deverá criar um App (somente Portrait e iPhones) onde o usuário irá cadastrar produtos que comprou nos Estados Unidos e poderá ver quanto irá gastar, em Reais, levando em conta os impostos do estado onde o produto foi comprado e o IOF caso tenha comprado o produto no cartão de crédito.

2. Detalhamentoportela
a) Compras
Nesta tela você irá listar todas as compras feitas pelo usuário. Deve ser utilizada uma UITableViewController que deverá estar inserida (embed in) em uma UINavigationController. Na UINavigationItem desta tela, teremos um UIBarButtonItem que, ao ser tocado, abrirá a tela de cadastro do produto. Caso a lista de produtos esteja vazia, mostrar a mensagem “Sua lista está vazia!” na tableview. Os produtos devem ser salvos no Core Data (entidade Product), com relacionamentos com seus respectivos Estados (entidade State). Quando houverem produtos, esta tela deverá mostrar a foto, nome e preço (em dólares) de cada produto.

b) Produto
- Aqui será onde o usuário irá cadastrar cada produto adquirido, informando nome, foto, estado da compra, valor em dólares e se a compra foi feita com cartão ou não. Esta mesma tela servirá para que o produto selecionado na tela de Compras possa ser editado/alterado. Todos os campos são obrigatórios.
- Ao clicar na imagem de presente, o usuário poderá escolher se deseja inserir a foto do produto através da Biblioteca de fotos ou da Câmera, só mostrando câmera caso ela exista no device.
- Clicando no botão +, o usuário será levado para a tela de Ajustes, onde poderá cadastrar os Estados que serão selecionados pelo UITextField “Estado da compra”.
- A seleção do Estado da compra será feita através de UIPickerView.

c) Ajustes
- Nesta tela o usuário irá cadastrar os estados e seus respectivos impostos, o valor do IOF e o valor do dólar. Ela poderá ser acessada através do botão correspondente pela UITabBarController ou através da tela de cadastro de produto quando o usuário clicar no botão de adicionar estado.
- Ao clicar em Adicionar Estado, uma UIAlertController é apresentada para o cadastro do estado e imposto. Os estados são listados em uma UITableView no centro da tela.
- Ao realizar o swipe da UITableView, você pode excluir um estado. Ao selecionar algum estado, o alerta será mostrado, mas dessa vez com os dados do estado selecionado, para sua edição.
- Ao excluir um estado, os produtos que estiverem vinculados ao estado devem ser automaticamente excluídos.
- A cotação do dólar e o IOF devem ser salvos e recuperados do Settings Bundle, e devem haver valores padrões lá. A tela de ajustes deve, na primeira vez que aparecer, conter esses valores padrões.

d) Total da compra
- Nesta tela será apresentado o valor final da compra, ou seja, a soma do valor em dólar de todos os produtos (valor bruto, sem impostos) e o valor final em Reais (valor considerando todos os impostos)
- Obs.: Cuidado ao calcular o valor final em reais pois este valor deve ser a soma do valor em reais de cada produto, pois cada um pode ter sido comprado em situações diferentes (no estado X, com ou sem cartão).
