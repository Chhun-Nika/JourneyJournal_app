// data/seed/default_categories.dart
import '../../model/category.dart';

final defaultCategories = <Category>[
  // Checklist
  Category(
    categoryType: CategoryType.checklist,
    name: 'Clothes',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.checklist,
    name: 'Documents',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.checklist,
    name: 'Toiletries',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.checklist,
    name: 'Electronics',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.checklist,
    name: 'Medications',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.checklist,
    name: 'Miscellaneous',
    isDefault: true,
  ),

  // Expense
  Category(
    categoryType: CategoryType.expense,
    name: 'Food & Drinks',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.expense,
    name: 'Transport',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.expense,
    name: 'Accommodation',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.expense,
    name: 'Shopping',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.expense,
    name: 'Attractions',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.expense,
    name: 'Emergency',
    isDefault: true,
  ),

  // Itinerary Activity
  Category(
    categoryType: CategoryType.itineraryActivity,
    name: 'Sightseeing',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.itineraryActivity,
    name: 'Food',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.itineraryActivity,
    name: 'Shopping',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.itineraryActivity,
    name: 'Transport',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.itineraryActivity,
    name: 'Relaxation',
    isDefault: true,
  ),
  Category(
    categoryType: CategoryType.itineraryActivity,
    name: 'Adventure',
    isDefault: true,
  ),
];
