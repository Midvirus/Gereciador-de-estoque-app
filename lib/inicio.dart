import 'package:flutter/material.dart';
import 'appControler.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageStates();
  }

}

class HomePageStates extends State<HomePage>{

  int val = 0;
  int sellDay = 0;
  double squarSize = 125;
  double squarSize2 = 75;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Nome'), 
              accountEmail: Text('Email'), 
              currentAccountPicture: ClipRRect(
                borderRadius: BorderRadius.circular(10000),
                child: Image.network('https://miro.medium.com/v2/resize:fit:720/format:webp/1*g09N-jl7JtVjVZGcd-vL2g.jpeg'),
              ),
              ),
            ListTile(
              leading: Icon(Icons.sell),
              title: Text('Vender'),
              //subtitle: Text('Efetuar venda local'),
              onTap: (){
                Navigator.of(context).pushNamed('/vendas');
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Adicionar Produto'),
              onTap: (){
                Navigator.of(context).pushNamed('/add');
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
            'Dai Perfumaria',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20
            ),
            ),
        actions: [
          Icon( Icons.sunny),
          CustomSwitch(),
          Icon(Icons.nightlight),
        ],
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          FirstGrade(),
          Container(
            height: 10,
          ),
          SecondGrade(val: val),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          setState(() {
            val += 10;
          });
        },
      ),
    );
  }

}

class CustomSwitch extends StatelessWidget{
  const CustomSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Switch(value: Appcontroler.instance.isDark, onChanged: (value){
          Appcontroler.instance.changeThema();
        },);
  }
}

class FirstGrade extends StatelessWidget{
  const FirstGrade({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            height: 230,
            width: double.infinity,
            child: Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            backgroundColor: Colors.green,
                            shadowColor: Colors.black,
                            elevation: 5,
                        ),
                        onPressed: () => {
                            Navigator.pushNamed(context, '/vendas')
                        },
                        child: Column(  
                            children: [
                                Icon(Icons.sell, color: Colors.white,),
                                Text(
                                    'Vender',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                )
                            ],
                        )
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            backgroundColor: Colors.blue,
                            shadowColor: Colors.black,
                            elevation: 5,
                        ),
                        onPressed: () => {
                            Navigator.pushNamed(context, '/add')
                        },
                        child: Column(  
                            children: [
                                Icon(Icons.add, color: Colors.white,),
                                Text(
                                    'Adicionar\nProdutos',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                )
                            ],
                        )
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            backgroundColor: Colors.blue,
                            shadowColor: Colors.black,
                            elevation: 5,
                        ),
                        onPressed: () => {
                            Navigator.pushNamed(context, '/cliente')
                        },
                        child: Column(  
                            children: [
                                Icon(Icons.people, color: Colors.white,),
                                Text(
                                    'Clientes',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                )
                            ],
                        )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            backgroundColor: Colors.blue,
                            shadowColor: Colors.black,
                            elevation: 5,
                        ),
                        onPressed: () => {
                            Navigator.pushNamed(context, '/produto')
                        },
                        child: Column(  
                            children: [
                                Icon(Icons.warehouse_rounded, color: Colors.white,),
                                Text(
                                    'Estoque',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                )
                            ],
                        )
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            backgroundColor: Colors.blue,
                            shadowColor: Colors.black,
                            elevation: 5,
                        ),
                        onPressed: () => {
                            Navigator.pushNamed(context, '/add')
                        },
                        child: Column(  
                            children: [
                                Icon(Icons.check_box, color: Colors.white,),
                                Text(
                                    'Vendas\nFeitas',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        
                                    ),
                                    textAlign: TextAlign.center,
                                )
                            ],
                        )
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            backgroundColor: Colors.blue,
                            shadowColor: Colors.black,
                            elevation: 5,
                        ),
                        onPressed: () => {
                            Navigator.pushNamed(context, '/vendas')
                        },
                        child: Column(  
                            children: [
                                Icon(Icons.timer, color: Colors.white,),
                                Text(
                                    'Pendencias',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                    ),
                                )
                            ],
                        )
                      ),
                    ],
                  ),
                ],
              )
            ),
          );
  }



}

class SecondGrade extends StatelessWidget {
  final int val;

  const SecondGrade({Key? key, required this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 75),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadowColor: Colors.black,
                  elevation: 5,
                ),
                onPressed: () {
                  // Ação ao clicar no botão
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.analytics_outlined, color: Colors.white),
                    Text(
                      'Estatísticas',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10), // Espaço entre o botão e os cartões
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatsCard('Total de Vendas\n de Hoje', val),
                  _buildStatsCard('Total de Vendas\n da Semana', val),
                  _buildStatsCard('Total de Vendas\n do Mês', val),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para criar os cartões de estatísticas
  Widget _buildStatsCard(String label, int val) {
    return Container(
      width: 100,
      height: 125,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.lightBlueAccent,
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // Sombra
            blurRadius: 10, // Desfoque da sombra
            offset: Offset(0, 5), // Posição da sombra
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$val',
            style: TextStyle(
              fontSize: val < 100 ? 50 : 40,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

