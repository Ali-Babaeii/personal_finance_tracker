# 💰 Personal Finance Tracker (Flutter)

A simple and clean **Personal Finance Tracker** built with **Flutter**, using  
**Bloc (Cubit)** for state management and **Hive** for local persistence.

---

## 🚀 Features

- Add / Edit / Delete transactions
- Income & Expense tracking
- Spending by category (Pie Chart)
- Filter transactions by date range
- Filter by Income / Expense / All
- Light / Dark theme (persisted)
- Local storage using Hive
- Clean architecture with Cubit & Repository pattern

---

## 🧱 Tech Stack

- **Flutter**
- **flutter_bloc**
- **Hive & hive_flutter**
- **SharedPreferences**
- **fl_chart**
- **intl**

---

## 📁 Project Structure

lib/
├── bloc/
│   ├── theme_cubit.dart 
│   └── transaction_cubit.dart
│
├── models/
│   └── transaction.dart
│
├── repositories/
│   └── transaction_repository.dart
│
├── screens/
│   └── home/
│       ├── home_screen.dart
│       └── widgets/
│           ├── add_transaction_dialog.dart 
│           ├── balance_section.dart 
│           ├── date_filter_section.dart
│           ├── edit_transaction_dialog.dart
│           ├── filter_section.dart
│           ├── spending_chart.dart
│           └── transaction_table.dart
│
└── main.dart
