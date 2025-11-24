import 'package:schemafx/models/models.dart';

// === 2. MOCK DATA / INITIAL SCHEMA (Spec Section 9) ===
// This creates the demo scenario: Customers and Orders.

final AppSchema demoSchema = AppSchema(
  id: 'demo_crm',
  name: 'Demo CRM',
  tables: [
    AppTable(
      id: 'customers',
      name: 'Customers',
      fields: [
        AppField(id: 'name', name: 'Name', type: AppFieldType.text),
        AppField(id: 'email', name: 'Email', type: AppFieldType.email),
      ],
    ),
    AppTable(
      id: 'orders',
      name: 'Orders',
      fields: [
        AppField(id: 'product', name: 'Product', type: AppFieldType.text),
        AppField(id: 'price', name: 'Price', type: AppFieldType.number),
        AppField(
          id: 'customer',
          name: 'Customer',
          type: AppFieldType.reference,
          referenceTo: 'customers', // 1:N Reference
        ),
      ],
    ),
  ],
  views: [
    AppView(
      id: 'customers_table',
      name: 'Customers Table',
      tableId: 'customers',
      type: AppViewType.table,
      fields: ['name', 'email'],
    ),
    AppView(
      id: 'customers_form',
      name: 'New Customer Form',
      tableId: 'customers',
      type: AppViewType.form,
      fields: ['name', 'email'],
    ),
    AppView(
      id: 'orders_table',
      name: 'Orders Table',
      tableId: 'orders',
      type: AppViewType.table,
      fields: ['product', 'price', 'customer'],
    ),
    AppView(
      id: 'orders_form',
      name: 'New Order Form',
      tableId: 'orders',
      type: AppViewType.form,
      fields: ['product', 'price', 'customer'],
    ),
  ],
);
