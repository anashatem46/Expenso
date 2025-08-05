import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense.dart';

class NotionApiService {
  static const String _baseUrl = 'https://api.notion.com/v1';
  final String _apiKey;
  final String _databaseId;

  NotionApiService({
    required String apiKey,
    required String databaseId,
  })  : _apiKey = apiKey,
        _databaseId = databaseId;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $_apiKey',
        'Notion-Version': '2022-06-28',
        'Content-Type': 'application/json',
      };

  /// Fetches expenses from Notion database
  Future<List<Expense>> fetchExpenses() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/databases/$_databaseId/query'),
        headers: _headers,
        body: jsonEncode({
          'sorts': [
            {
              'property': 'Date',
              'direction': 'descending',
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;
        
        return results.map((item) => _parseExpenseFromNotion(item)).toList();
      } else {
        throw Exception('Failed to fetch expenses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching expenses: $e');
    }
  }

  /// Creates a new expense in Notion
  Future<Expense> createExpense(Expense expense) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/pages'),
        headers: _headers,
        body: jsonEncode({
          'parent': {'database_id': _databaseId},
          'properties': _expenseToNotionProperties(expense),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return expense.copyWith(notionId: data['id']);
      } else {
        throw Exception('Failed to create expense: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating expense: $e');
    }
  }

  /// Updates an existing expense in Notion
  Future<void> updateExpense(Expense expense) async {
    if (expense.notionId == null) {
      throw Exception('Cannot update expense without Notion ID');
    }

    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/pages/${expense.notionId}'),
        headers: _headers,
        body: jsonEncode({
          'properties': _expenseToNotionProperties(expense),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update expense: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating expense: $e');
    }
  }

  /// Deletes an expense from Notion
  Future<void> deleteExpense(String notionId) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/pages/$notionId'),
        headers: _headers,
        body: jsonEncode({
          'archived': true,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete expense: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting expense: $e');
    }
  }

  /// Converts Notion response to Expense object
  Expense _parseExpenseFromNotion(Map<String, dynamic> notionItem) {
    final properties = notionItem['properties'] as Map<String, dynamic>;
    final id = notionItem['id'] as String;
    
    return Expense(
      id: id,
      title: _getNotionText(properties['Title']),
      amount: _getNotionNumber(properties['Amount']),
      category: _getNotionSelect(properties['Category']),
      date: _getNotionDate(properties['Date']),
      description: _getNotionText(properties['Description']),
      notionId: id,
    );
  }

  /// Converts Expense object to Notion properties format
  Map<String, dynamic> _expenseToNotionProperties(Expense expense) {
    return {
      'Title': {
        'title': [
          {
            'text': {
              'content': expense.title,
            },
          },
        ],
      },
      'Amount': {
        'number': expense.amount,
      },
      'Category': {
        'select': {
          'name': expense.category,
        },
      },
      'Date': {
        'date': {
          'start': expense.date.toIso8601String(),
        },
      },
      if (expense.description != null)
        'Description': {
          'rich_text': [
            {
              'text': {
                'content': expense.description!,
              },
            },
          ],
        },
    };
  }

  String _getNotionText(Map<String, dynamic>? property) {
    if (property == null) return '';
    final title = property['title'] as List?;
    if (title == null || title.isEmpty) return '';
    return title.first['text']['content'] as String;
  }

  double _getNotionNumber(Map<String, dynamic>? property) {
    if (property == null) return 0.0;
    return (property['number'] as num?)?.toDouble() ?? 0.0;
  }

  String _getNotionSelect(Map<String, dynamic>? property) {
    if (property == null) return '';
    final select = property['select'] as Map<String, dynamic>?;
    if (select == null) return '';
    return select['name'] as String? ?? '';
  }

  DateTime _getNotionDate(Map<String, dynamic>? property) {
    if (property == null) return DateTime.now();
    final date = property['date'] as Map<String, dynamic>?;
    if (date == null) return DateTime.now();
    final start = date['start'] as String?;
    if (start == null) return DateTime.now();
    return DateTime.parse(start);
  }
} 