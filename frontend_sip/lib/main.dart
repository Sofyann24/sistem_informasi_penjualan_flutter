import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sistem_informasi_penjualan/providers/providers.dart';
import 'screens/screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting('id_ID');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..checkLoginStatus(),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CustomersProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => ProfitProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => MainLayout(),
        '/loginScreen': (context) => LoginScreen(),
        '/registerScreen': (context) => RegistrationScreen(),
        '/categoryScreen': (context) => CategoriesScreen(),

        // Customers Section
        '/customerScreen': (context) => CustomerScreen(),
        '/addCustomer': (context) => AddCustomerScreen(),
        '/editCustomer': (context) => EditCustomerScreen(),

        // Stock Section
        '/stockScreen': (context) => StockScreen(),

        // Payment Screen
        'paymentScreen':(context)=> PaymentScreen()
      },
    );
  }
}
