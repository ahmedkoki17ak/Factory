import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const FoodFactoryApp());
}

class FoodFactoryApp extends StatelessWidget {
  const FoodFactoryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام إدارة مصنع الأغذية',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.teal,
        primaryColor: const Color(0xFF00695C),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        fontFamily: 'Cairo',
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({Key? key}) : super(key: key);

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ItemsInventoryScreen(),
    const RecipeManagementScreen(),
    const ProductionBatchScreen(),
    const StockLedgerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('مصنع الأغذية المتكامل - ERP', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () {},
            tooltip: 'التنبيهات',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Chip(
              avatar: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, size: 16, color: Color(0xFF00695C))),
              label: const Text('مدير النظام', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              backgroundColor: const Color(0xFF004D40),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() => _selectedIndex = index);
              },
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: const IconThemeData(color: Color(0xFF00695C)),
              selectedLabelTextStyle: const TextStyle(color: Color(0xFF00695C), fontWeight: FontWeight.bold),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('الرئيسية')),
                NavigationRailDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: Text('الأصناف')),
                NavigationRailDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: Text('الريسيبيهات')),
                NavigationRailDestination(icon: Icon(Icons.precision_manufacturing_outlined), selectedIcon: Icon(Icons.precision_manufacturing), label: Text('الإنتاج')),
                NavigationRailDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: Text('المخزون')),
              ],
            ),
          if (isDesktop) const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: !isDesktop
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF00695C),
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'الرئيسية'),
                BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'الأصناف'),
                BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'الريسيبي'),
                BottomNavigationBarItem(icon: Icon(Icons.precision_manufacturing), label: 'الإنتاج'),
                BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'المخزون'),
              ],
            )
          : null,
    );
  }
}

// -----------------------------------------------------------------------------
// 1. DASHBOARD SCREEN
// -----------------------------------------------------------------------------
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('نشرة تقرير المصنع اليومي', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF263238))),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              KpiCard(title: 'إجمالي قيمة المخزون', value: '425,000 ج.م', icon: Icons.account_balance_wallet, color: Colors.blue),
              KpiCard(title: 'تنبيهات نواقص المخزون', value: '3 أصناف', icon: Icons.warning_amber_rounded, color: Colors.orange),
              KpiCard(title: 'إنتاج اليوم (شاورما/لحوم)', value: '120 كجم', icon: Icons.factory, color: Colors.green),
              KpiCard(title: 'تكلفة الإنتاج اليومية', value: '18,400 ج.م', icon: Icons.attach_money, color: Colors.purple),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('تنبيهات المخزون المنخفض (نواقص الخامات)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                        label: const Text('طلب شراء خامات'),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00695C), foregroundColor: Colors.white),
                      )
                    ],
                  ),
                  const Divider(),
                  const LowStockListTile(itemName: 'بهارات شاورما فراخ', currentStock: '1.2 كجم', minStock: '5 كجم'),
                  const LowStockListTile(itemName: 'زيت طعام نباتي', currentStock: '12 لتر', minStock: '30 لتر'),
                  const LowStockListTile(itemName: 'أكياس تعبئة حرارية 1كجم', currentStock: '150 قطعة', minStock: '500 قطعة'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const KpiCard({Key? key, required this.title, required this.value, required this.icon, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext me) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class LowStockListTile extends StatelessWidget {
  final String itemName;
  final String currentStock;
  final String minStock;

  const LowStockListTile({Key? key, required this.itemName, required this.currentStock, required this.minStock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.error_outline, color: Colors.red),
      title: Text(itemName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('الحد الأدنى: $minStock'),
      trailing: Text('المتاح: $currentStock', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. ITEMS & RAW MATERIALS SCREEN
// -----------------------------------------------------------------------------
class ItemsInventoryScreen extends StatelessWidget {
  const ItemsInventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'بحث باسم الخامة أو الكود...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة صنف/خامة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00695C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('الكود', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('اسم الصنف', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('التصنيف', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('الرصيد الحرفي', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('متوسط التكلفة', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('إجمالي القيمة', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('الحالة', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('RAW-001')),
                        DataCell(Text('صدور فراخ طازجة')),
                        DataCell(Text('لحوم وطيور')),
                        DataCell(Text('150.00 كجم')),
                        DataCell(Text('150.00 ج.م')),
                        DataCell(Text('22,500 ج.م')),
                        DataCell(Chip(label: Text('متوفر', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green)),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('RAW-002')),
                        DataCell(Text('زيت طعام نباتي')),
                        DataCell(Text('زيوت وصوصات')),
                        DataCell(Text('12.00 لتر')),
                        DataCell(Text('100.00 ج.م')),
                        DataCell(Text('1,200 ج.م')),
                        DataCell(Chip(label: Text('منخفض', style: TextStyle(color: Colors.white)), backgroundColor: Colors.orange)),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('RAW-003')),
                        DataCell(Text('ثوم مفروم')),
                        DataCell(Text('خضروات')),
                        DataCell(Text('25.00 كجم')),
                        DataCell(Text('40.00 ج.م')),
                        DataCell(Text('1,000 ج.م')),
                        DataCell(Chip(label: Text('متوفر', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green)),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. RECIPE MANAGEMENT SCREEN
// -----------------------------------------------------------------------------
class RecipeManagementScreen extends StatelessWidget {
  const RecipeManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('شجرة الريسيبيهات والخلطات (Recipes)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.restaurant_menu),
                label: const Text('إنشاء ريسيبي جديد'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00695C), foregroundColor: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: ExpansionTile(
                    leading: const CircleAvatar(backgroundColor: Color(0xFF00695C), child: Icon(Icons.fastfood, color: Colors.white)),
                    title: const Text('شاورما فراخ جاهزة للطهي (Base 10 Kg)', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('تكلفة الـ 10 كجم: 1,230 ج.م | تكلفة الكيلو: 123 ج.م'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: const [
                            RecipeIngredientRow(name: 'صدور فراخ طازجة', qty: '8.00 كجم', cost: '1,200 ج.م'),
                            RecipeIngredientRow(name: 'زيت طعام', qty: '300 جرام', cost: '30 ج.م'),
                            RecipeIngredientRow(name: 'ملح طعام', qty: '100 جرام', cost: '2 ج.م'),
                            RecipeIngredientRow(name: 'بهارات شاورما (Sub-Recipe)', qty: '200 جرام', cost: '18 ج.م'),
                            RecipeIngredientRow(name: 'ثوم مفروم', qty: '300 جرام', cost: '12 ج.م'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RecipeIngredientRow extends StatelessWidget {
  final String name;
  final String qty;
  final String cost;

  const RecipeIngredientRow({Key? key, required this.name, required this.qty, required this.cost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('• $name', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('الكمية: $qty'),
          Text('التكلفة: $cost', style: const TextStyle(color: Color(0xFF00695C))),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4. PRODUCTION BATCH EXECUTION SCREEN
// -----------------------------------------------------------------------------
class ProductionBatchScreen extends StatefulWidget {
  const ProductionBatchScreen({Key? key}) : super(key: key);

  @override
  State<ProductionBatchScreen> createState() => _ProductionBatchScreenState();
}

class _ProductionBatchScreenState extends State<ProductionBatchScreen> {
  final TextEditingController _qtyController = TextEditingController(text: '100');
  double targetQty = 100.0;

  @override
  Widget build(BuildContext context) {
    double baseCost = 1230.0; // For 10kg
    double totalEstimatedCost = (targetQty / 10.0) * baseCost;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تسجيل أمر إنتاج جديد (Production Order)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: 'shawarma',
                      decoration: const InputDecoration(labelText: 'اختر الريسيبي المراد إنتاجه', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'shawarma', child: Text('شاورما فراخ (وحدة الأساس 10 كجم)')),
                      ],
                      onChanged: (v) {},
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'الكمية المطلوبة إنتاجها (كجم)',
                        border: OutlineInputBorder(),
                        suffixText: 'كجم',
                      ),
                      onChanged: (val) {
                        setState(() {
                          targetQty = double.tryParse(val) ?? 0.0;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('الخامات المطلوبة والمتاحة بالمخزن (حساب تلقائي):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ProductionRequirementTile(name: 'صدور فراخ', requiredQty: '${(targetQty * 0.8).toStringAsFixed(1)} كجم', availableQty: '150.0 كجم', isSufficient: 150.0 >= (targetQty * 0.8)),
                  ProductionRequirementTile(name: 'زيت طعام', requiredQty: '${(targetQty * 0.03).toStringAsFixed(1)} لتر', availableQty: '12.0 لتر', isSufficient: 12.0 >= (targetQty * 0.03)),
                  ProductionRequirementTile(name: 'ثوم مفروم', requiredQty: '${(targetQty * 0.03).toStringAsFixed(1)} كجم', availableQty: '25.0 كجم', isSufficient: 25.0 >= (targetQty * 0.03)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFFE0F2F1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('إجمالي التكلفة التقديرية للإنتاج: ${totalEstimatedCost.toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D40))),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم خصم الخامات بنجاح وإضافة المنتج للمخزون داخل DB Transaction'), backgroundColor: Colors.green),
                        );
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text('تأكيد وتنفيذ أمر الإنتاج'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00695C), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductionRequirementTile extends StatelessWidget {
  final String name;
  final String requiredQty;
  final String availableQty;
  final bool isSufficient;

  const ProductionRequirementTile({Key? key, required this.name, required this.requiredQty, required this.availableQty, required this.isSufficient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(isSufficient ? Icons.check_circle : Icons.cancel, color: isSufficient ? Colors.green : Colors.red),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('المطلوب للإنتاج: $requiredQty'),
      trailing: Text('المتاح بالمخزن: $availableQty', style: TextStyle(color: isSufficient ? Colors.black : Colors.red, fontWeight: FontWeight.bold)),
    );
  }
}

// -----------------------------------------------------------------------------
// 5. STOCK LEDGER SCREEN
// -----------------------------------------------------------------------------
class StockLedgerScreen extends StatelessWidget {
  const StockLedgerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('دفتر حركة المخزون العام (Audit Stock Ledger)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: ListView(
                children: const [
                  ListTile(
                    leading: CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.arrow_downward, color: Colors.white)),
                    title: Text('استلام توريد - فاتورة رقم #INV-9921'),
                    subtitle: Text('المورد: الشركة الوطنية للحوم | المورد بوسطة: أحمد محمود (أمين المخزن)'),
                    trailing: Text('+100 كجم فراخ', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ),
                  Divider(),
                  ListTile(
                    leading: CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.arrow_upward, color: Colors.white)),
                    title: Text('خصم إنتاج تشغيلة #PRD-8821'),
                    subtitle: Text('الوصفة: شاورما فراخ | المنفذ: مصطفى إبراهيم (الإنتاج)'),
                    trailing: Text('-80 كجم فراخ', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}