# Expenso Tracker

A modern, minimalistic Flutter expense tracking app with a clean layered architecture using BLoC pattern and Notion API integration.

## 🎨 Modern UI Design

The app features a clean, minimalistic design inspired by modern mobile apps:

- **Clean Header**: User name and current date display
- **Prominent Balance**: Large, bold balance display with color coding
- **Smooth Charts**: Modern line charts showing spending trends
- **Month Selector**: Horizontal pill-shaped month selection
- **Transaction Cards**: Clean cards with emoji icons and modern typography
- **Bottom Navigation**: Modern nav bar with centered FAB
- **Add Modal**: Rounded modal with date picker and category selection

## 🏗️ Architecture Overview

The app follows a clean layered architecture with BLoC pattern for state management:

### A. Presentation Layer (UI)
- **Location**: `lib/presentation/`
- **Purpose**: Displays data to users and handles user input
- **Components**:
  - `screens/` - Main app screens (HomeScreen)
  - `widgets/` - Reusable UI components (TransactionCard, MonthSelector, SpendingChart, AddTransactionModal)

### B. Logic Layer (State Management - BLoC)
- **Location**: `lib/logic/bloc/`
- **Purpose**: Manages app state and handles user actions using BLoC pattern
- **Components**:
  - `expense_bloc.dart` - Main BLoC for expense management
  - `expense_event.dart` - Events (LoadExpenses, AddExpense, DeleteExpense, etc.)
  - `expense_state.dart` - States with computed properties for UI

### C. Data Layer (API & Storage)
- **Location**: `lib/data/`
- **Purpose**: Communicates with Notion API and manages local cache/storage
- **Components**:
  - `api/` - Notion API service for remote data operations
  - `storage/` - Local storage service using SharedPreferences
  - `models/` - Data models with JSON serialization

## ✨ Features

- ✅ Modern, minimalistic UI design
- ✅ BLoC pattern for state management
- ✅ Add, view, and delete transactions
- ✅ Categorize transactions with emoji icons
- ✅ Local storage for offline functionality
- ✅ Notion API integration for cloud sync
- ✅ Smooth line charts for spending trends
- ✅ Month selector with pill-shaped buttons
- ✅ Modern bottom navigation with FAB
- ✅ Add transaction modal with date picker
- ✅ Dark/Light theme support
- ✅ Error handling and loading states

## 🚀 Setup

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate JSON Models**:
   ```bash
   flutter packages pub run build_runner build
   ```

3. **Configure Notion API** (Optional):
   - Get your Notion API key from [Notion Developers](https://developers.notion.com/)
   - Create a database in Notion with the following properties:
     - Title (title)
     - Amount (number)
     - Category (select)
     - Date (date)
     - Description (rich_text)
   - Update the API credentials in `lib/main.dart`

4. **Run the App**:
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point with BLoC setup
├── data/                             # Data Layer
│   ├── api/
│   │   └── notion_api_service.dart   # Notion API integration
│   ├── storage/
│   │   └── local_storage_service.dart # Local storage management
│   └── models/
│       └── expense.dart              # Expense data model
├── logic/                            # Logic Layer (BLoC)
│   └── bloc/
│       ├── expense_bloc.dart         # Main BLoC
│       ├── expense_event.dart        # Events
│       └── expense_state.dart        # States
└── presentation/                     # Presentation Layer
    ├── screens/
    │   └── home_screen.dart          # Main home screen
    └── widgets/
        ├── transaction_card.dart      # Transaction item widget
        ├── month_selector.dart       # Month selection widget
        ├── spending_chart.dart       # Chart widget
        └── add_transaction_modal.dart # Add transaction modal
```

## 📦 Dependencies

- **flutter_bloc**: BLoC pattern for state management
- **bloc**: Core BLoC library
- **equatable**: For value equality in BLoC
- **http**: HTTP client for API calls
- **shared_preferences**: Local storage
- **json_annotation**: JSON serialization
- **fl_chart**: Charts for spending trends
- **intl**: Date formatting

## 🎯 BLoC Pattern Implementation

The app uses BLoC pattern for clean state management:

### Events
- `LoadExpenses`: Load expenses from storage
- `AddExpense`: Add new expense
- `DeleteExpense`: Delete expense
- `SelectMonth`: Change selected month
- `ToggleAddModal`: Show/hide add modal

### States
- `ExpenseStatus`: Loading, loaded, error states
- `ExpenseState`: Contains expenses, selected month, modal state
- Computed properties for UI (chart data, totals, etc.)

## 🎨 UI Components

### Home Screen
- Header with user name and date
- Balance card with large amount display
- Spending trend chart
- Month selector with pill buttons
- Transaction list with modern cards
- Bottom navigation with FAB

### Add Transaction Modal
- Horizontal date picker
- Large amount input field
- Category selector with emojis
- Reason input field
- Modern rounded design

### Transaction Cards
- Emoji category icons
- Clean typography
- Color-coded amounts (green for income, red for expenses)
- Modern shadows and rounded corners

## 🔧 Usage

1. **Adding Transactions**: Tap the + button to open the add modal
2. **Viewing Transactions**: All transactions are displayed in a modern list
3. **Deleting Transactions**: Tap the delete icon on transaction cards
4. **Month Selection**: Use the pill-shaped month selector
5. **Charts**: View spending trends in the smooth line chart

## 🌐 Notion Integration

The app integrates with Notion API for cloud storage:

1. Create a Notion integration at https://www.notion.so/my-integrations
2. Create a database with the required properties
3. Share the database with your integration
4. Update the API credentials in the app

## 🤝 Contributing

This project follows a clean architecture pattern with BLoC. When adding new features:

1. **Data Layer**: Add new models, API services, or storage methods
2. **Logic Layer**: Add new BLoC events and states
3. **Presentation Layer**: Create new screens or widgets

## 📄 License

This project is licensed under the MIT License.
